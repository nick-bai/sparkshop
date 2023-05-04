<?php
// +----------------------------------------------------------------------
// | SparkShop 坚持做优秀的商城系统
// +----------------------------------------------------------------------
// | Copyright (c) 2022~2099 http://sparkshop.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://opensource.org/licenses/mit-license.php )
// +----------------------------------------------------------------------
// | Author: NickBai  <876337011@qq.com>
// +----------------------------------------------------------------------
namespace app\traits;

use app\model\goods\Goods;
use app\model\goods\GoodsRuleExtend;
use app\model\order\Order;
use app\model\order\OrderAddress;
use app\model\order\OrderDetail;
use app\model\order\OrderOverdue;
use app\model\order\OrderPayLog;
use app\model\order\OrderStatusChange;
use app\model\user\User;
use app\model\user\UserAddress;
use think\facade\Db;
use think\facade\Log;

trait OrderTrait
{
    use PostageTrait, UserVipTrait;

    /**
     * 处理试算
     * @param $param
     * @return array
     */
    private function dealTrial($param, $userId)
    {
        try {

            $goodsIds = [];
            $goods2Price = []; // 每种商品的价格
            $num = 0;
            foreach ($param['goods'] as $vo) {
                $goodsIds[] = $vo['goods_id'];
                $num += $vo['num'];
            }

            // 商品信息
            $goodsModel = new Goods();
            $goodsList = $goodsModel->whereIn('id', array_unique($goodsIds))->select();
            if (empty($goodsList)) {
                return dataReturn(-1, '该商品已下架无法购买');
            }

            $goodsId2Info = [];
            foreach ($goodsList as $vo) {
                $goodsId2Info[$vo['id']] = $vo;
            }

            $totalPrice = 0;
            $weight = 0;
            $volume = 0;
            $goodsPostage = [];
            foreach ($param['goods'] as $vo) {

                $goodsInfo = $goodsId2Info[$vo['goods_id']];
                switch ($goodsInfo['spec']) {
                    // 单规格商品
                    case 1:
                        $param['price'] = $goodsInfo['price'];
                        $weight = $goodsInfo['weight'];
                        $volume = $goodsInfo['volume'];
                        break;
                    // 多规格商品
                    case 2:
                        $ruleModel = new GoodsRuleExtend();
                        $ruleInfo = $ruleModel->field('price,weight,volume')->where('goods_id', $vo['goods_id'])
                            ->where('id', $vo['rule_id'])->find();

                        $param['price'] = $ruleInfo['price'];
                        $weight = $ruleInfo['weight'];
                        $volume = $ruleInfo['volume'];
                        break;
                }

                // 计算本次购买的全部商品的体积重量和总价格
                $price = $param['price'];

                $weight = $weight * $vo['num']; // 重量
                $volume = $volume * $vo['num']; // 体积
                if (isset($goods2Price[$goodsInfo['id']])) {
                    $goods2Price[$goodsInfo['id']] += $price * $vo['num'];
                } else {
                    $goods2Price[$goodsInfo['id']] = $price * $vo['num'];
                }

                $totalPrice += $vo['num'] * $price;
                // 按商品整理运费模板
                if (isset($goodsPostage[$goodsInfo['id']])) {
                    $goodsPostage[$goodsInfo['id']]['num'] += $vo['num'];
                    $goodsPostage[$goodsInfo['id']]['weight'] += $weight;
                    $goodsPostage[$goodsInfo['id']]['volume'] += $volume;
                } else {
                    $goodsPostage[$goodsInfo['id']] = [
                        'freight' => $goodsInfo['freight'],
                        'num' => $vo['num'],
                        'weight' => $weight,
                        'volume' => $volume,
                        'postage' => $goodsInfo['postage'],
                        'shipping_tpl_id' => $goodsInfo['shipping_tpl_id']
                    ];
                }
            }

            // 开始计算邮价
            $postage = $this->getPostageByTpl($goodsPostage, $param['address_id']);
            if ($postage < 0) {
                return dataReturn(-3, "系统异常");
            }

            // 计算vip优惠
            if ($param['orderType'] == 1) {
                $vipDiscountAmount = $this->calcUserVip($totalPrice, $userId)['data'];
            } else {
                // 秒杀不参与vip计算
                $vipDiscountAmount = 0;
            }
            $orderPrice = $totalPrice - $vipDiscountAmount;

            // 优惠券抵扣金额
            $couponInfo = $this->calcCoupon($param, $orderPrice, $goods2Price, $userId)['data'];

            if ($orderPrice < 0) {
                $orderPrice = 0;
            } else {
                // 剩下的订单小于优惠券金额，则
                if ($orderPrice < $couponInfo['couponAmount']) {
                    $couponInfo['couponAmount'] = $orderPrice;
                    $orderPrice = 0;
                } else {
                    $orderPrice = $orderPrice - $couponInfo['couponAmount'];
                }
            }

            $trialParam = [
                'count' => $num,
                'totalPrice' => $totalPrice,
                'coupon' => $couponInfo,
                'postage' => $postage,
                'vipDiscount' => $vipDiscountAmount,
                'realPay' => $orderPrice + $postage,
                'user_balance' => (new User())->find($userId)->balance
            ];

            return dataReturn(0, 'success', $trialParam);
        } catch (\Exception $e) {
            Log::error('创建订单错误: ' . $e->getMessage() . '|' . $e->getFile() . '|' . $e->getLine());
            return dataReturn(-5, '系统错误');
        }
    }

    /**
     * 创建订单
     * @param $param
     * @param $userId
     * @return mixed
     */
    private function dealCreateOrder($param, $userId)
    {
        try {

            $goodsModel = new Goods();
            $goodIds = [];
            $goods2Num = [];
            foreach ($param['goods'] as $vo) {
                $gKey = $vo['goods_id'] . '_' . $vo['rule_id'];
                $goods2Num[$gKey] = $vo['num'];
                $goodIds[] = $vo['goods_id'];
            }

            $goodsList = $goodsModel->whereIn('id', array_unique($goodIds))->where('is_show', 1)->where('is_del', 2)->select()->toArray();
            if (empty($goodsList)) {
                return dataReturn(-1, "购买的商品已下架活被删除无法购买");
            }

            $goodsId2Info = [];
            foreach ($goodsList as $vo) {
                $goodsId2Info[$vo['id']] = $vo;
            }

            $orderGoodsList = [];
            $labels = ''; // 关联的用户标签
            $goodsRuleExtendModel = new GoodsRuleExtend();
            foreach ($param['goods'] as $vo) {

                $goodsInfo = $goodsId2Info[$vo['goods_id']];
                $name = $goodsInfo['name'];
                // 单规格商品
                if ($goodsInfo['spec'] == 1) {
                    $param['price'] = $goodsInfo['price'];
                    $stock = $goodsInfo['stock'];
                    $rule = 0;
                    $logo = json_decode($goodsInfo['slider_image'], true)[0];
                } else { // 多规格商品
                    $goodsRuleInfo = $goodsRuleExtendModel->where('goods_id', $vo['goods_id'])
                        ->where('id', $vo['rule_id'])->find();
                    $stock = $goodsRuleInfo['stock'];
                    $rule = $goodsRuleInfo['sku'];
                    $logo = $goodsRuleInfo['image'];
                    $param['price'] = $goodsRuleInfo['price'];
                }

                $price = $param['price'];

                if ($stock < 0) {
                    return dataReturn(-2, $goodsInfo['name'] . "已经售罄");
                }

                // 库存小于购买数量
                if ($stock < $vo['num']) {
                    return dataReturn(-6, $goodsInfo['name'] . "库存不足");
                }

                $gKey = $vo['goods_id'] . '_' . $vo['rule_id'];
                $orderGoodsList[$gKey] = compact('rule', 'logo', 'name', 'price');
                $labels .= $goodsInfo['user_label'] . ',';
            }

            // 费用计算
            $calcParam = $this->dealTrial($param, $userId)['data'];
            if ($param['pay_way'] == 'balance' && $calcParam['realPay'] > $calcParam['user_balance']) {
                return dataReturn(-20, "您的余额不足以支付该订单，请更换其他支付方式");
            }

            $payOrderNo = makeOrderNo('P');
            $orderNo = makeOrderNo('D');
            $payType = config('pay.pay_type');
            // 1、创建订单
            $order = [
                'pid' => 0,
                'type' => $param['orderType'],
                'order_no' => $orderNo,
                'pay_order_no' => $payOrderNo,
                'user_id' => $userId,
                'total_num' => $calcParam['count'],
                'postage' => $calcParam['postage'],
                'order_price' => $calcParam['totalPrice'],
                'pay_way' => $payType[$param['pay_way']],
                'pay_price' => $calcParam['realPay'],
                'pay_postage' => $calcParam['postage'],
                'vip_discount' => $calcParam['vipDiscount'],
                'coupon_amount' => $calcParam['coupon']['couponAmount'],
                'pay_status' => 1,
                'status' => 2, // 已确认/待支付
                'source' => $param['platform'],
                'remark' => $param['remark'],
                'create_time' => now()
            ];

            $orderModel = new Order();
            $orderId = $orderModel->insertGetId($order);

            // 2、记录订单快检表
            $overduePayType = config('pay.overdue_pay_type');
            if (isset($overduePayType[$param['pay_way']])) {
                $this->writeOverdueData($orderId, $param['orderType'], $param['goods']);
            }

            // 3、记录支付记录
            $payLog = [
                'order_id' => $orderId,
                'pay_way' => $payType[$param['pay_way']],
                'pay_order_no' => $payOrderNo,
                'status' => 1,
                'create_time' => now()
            ];

            $orderPayLogModel = new OrderPayLog();
            $orderPayLogModel->insert($payLog);

            // 4、处理用户的货地址表
            $userAddressModel = new UserAddress();
            $addressInfo = $userAddressModel->where('id', $param['address_id'])->where('user_id', $userId)->find();
            if (empty($addressInfo)) {
                return dataReturn(-3, "收货地址异常");
            }

            $address = [
                'order_id' => $orderId,
                'user_id' => $userId,
                'address_id' => $param['address_id'],
                'user_name' => $addressInfo['real_name'],
                'phone' => $addressInfo['phone'],
                'province' => $addressInfo['province'],
                'city' => $addressInfo['city'],
                'county' => $addressInfo['county'],
                'detail' => $addressInfo['detail'],
                'post_code' => $addressInfo['post_code'],
                'longitude' => $addressInfo['longitude'],
                'latitude' => $addressInfo['latitude'],
                'create_time' => now()
            ];

            $orderAddressModel = new OrderAddress();
            $orderAddressModel->insert($address);

            // 5、计算出各个子订单均摊的优惠券金额
            $goods2Amount = [];
            if ($calcParam['coupon']['couponAmount'] > 0) {
                $goods2Amount = $this->calcDivideCoupon($calcParam, $orderGoodsList, $goods2Num); // TODO 校验优惠券
                // 记录使用情况
                $couponParam = $param;
                $couponParam['user_id'] = $userId;
                $couponParam['order_id'] = $orderId;
                event('couponUsed', $couponParam);
            }

            // 6、计算出各个子订单均摊的会员优惠
            $vip2Amount = [];
            if ($calcParam['vipDiscount'] > 0) {
                $vip2Amount = $this->calcDivideUserVip($calcParam, $orderGoodsList, $goods2Num);
            }

            // 7、写入订单商品详情
            $orderDetail = [];
            foreach ($orderGoodsList as $key => $vo) {

                $orderDetail[] = [
                    'order_id' => $orderId,
                    'goods_id' => explode('_', $key)[0], // 截取
                    'goods_name' => $vo['name'],
                    'price' => $vo['price'],
                    'logo' => $vo['logo'],
                    'rule_id' => explode('_', $key)[1], // 截取
                    'rule' => $vo['rule'], // 规格
                    'cart_num' => $goods2Num[$key],
                    'coupon_amount' => $goods2Amount[$key] ?? 0, // 均摊的优惠券金额
                    'vip_discount' => $vip2Amount[$key] ?? 0 // 均摊的会员折扣金额
                ];
            }

            $orderDetailModel = new OrderDetail();
            $orderDetailModel->insertAll($orderDetail);

            // 8、维护状态变更日志
            $orderStatusModel = new OrderStatusChange();
            $orderStatusModel->insert([
                'order_id' => $orderId,
                'original_status' => 1,
                'new_status' => 2,
                'msg' => '订单创建',
                'create_time' => now()
            ]);

            // 9、用户标签维护
            if (!empty($labels)) {
                $this->linkUserLabel($labels, $userId);
            }

        } catch (\Exception $e) {
            Log::error('创建订单错误: ' . $e->getMessage() . '|' . $e->getFile() . '|' . $e->getLine());
            return dataReturn(-5, '系统错误');
        }

        return dataReturn(0, "success", compact('orderId', 'payOrderNo', 'orderNo', 'calcParam', 'orderGoodsList'));
    }

    /**
     * 直接完成订单
     * @param $orderInfo
     * @return array
     */
    private function completeOrder($orderInfo)
    {
        try {

            $orderModel = new Order();
            $payLogModel = new OrderPayLog();

            // 扣减商品库存 、维护销量
            $stockNotEnough = $this->dealStockAndSales($orderInfo);
            $status = 3;
            if ($stockNotEnough) {
                $status = 9;
            }

            // 维护状态
            $orderModel->where('id', $orderInfo['id'])->update([
                'pay_status' => 2,
                'status' => $status,
                'third_code' => '',
                'return_msg' => '',
                'pay_time' => now(),
                'update_time' => now()
            ]);

            // 记录日志
            $payLogModel->where('order_id', $orderInfo['id'])->where('pay_order_no', $orderInfo['pay_order_no'])->update([
                'status' => 2,
                'update_time' => now()
            ]);

            // 维护状态变更日志
            $orderStatusModel = new OrderStatusChange();
            $orderStatusModel->insert([
                'order_id' => $orderInfo['id'],
                'original_status' => 2,
                'new_status' => $status,
                'msg' => '订单支付成功',
                'create_time' => now()
            ]);

        } catch (\Exception $e) {
            return dataReturn(-1, $e->getMessage());
        }

        return dataReturn(0);
    }

    /**
     * 处理库存和销量信息
     * @param $orderInfo
     * @return bool
     */
    private function dealStockAndSales($orderInfo)
    {
        $stockNotEnough = false;

        $orderDetailModel = new OrderDetail();
        $buyGoodsList = $orderDetailModel->where('order_id', $orderInfo['id'])->select();
        $goods2Num = [];
        $goods2Rule = [];
        $rule2Num = [];
        foreach ($buyGoodsList as $vo) {
            $goods2Num[$vo['goods_id']] = $vo['cart_num'];
            $goods2Rule[$vo['goods_id']][] = $vo['rule_id'];
            $rule2Num[$vo['rule_id']] = $vo['cart_num'];
        }

        $goodsRuleExtendModel = new GoodsRuleExtend();
        $goodsModel = new Goods();
        $goodsList = $goodsModel->field('id,sales,spec,stock')->whereIn('id', array_keys($goods2Num))->select();
        foreach ($goodsList as $vo) {
            // 单规格
            if ($vo['spec'] == 1) {

                if ($vo['stock'] < $goods2Num[$vo['id']]) {
                    $stockNotEnough = true;
                    break;
                } else {
                    $goodsModel->where('id', $vo['id'])->update([
                        'stock' => $vo['stock'] - $goods2Num[$vo['id']],
                        'sales' => $vo['sales'] + $goods2Num[$vo['id']],
                        'update_time' => now()
                    ]);
                }
            } else { // 多规格

                $goodsRuleList = $goodsRuleExtendModel->field('id,goods_id,stock,sales')->where('goods_id', $vo['id'])
                    ->whereIn('id', $goods2Rule[$vo['id']])->select();
                $totalSale = 0;
                foreach ($goodsRuleList as $v) {

                    $totalSale += $rule2Num[$v['id']];

                    if ($v['stock'] < $rule2Num[$v['id']]) {
                        $stockNotEnough = true;
                        break;
                    } else {
                        $goodsRuleExtendModel->where('id', $v['id'])->update([
                            'sales' => $v['sales'] + $rule2Num[$v['id']],
                            'stock' => $v['stock'] - $rule2Num[$v['id']]
                        ]);
                    }
                }

                $goodsModel->where('id', $vo['id'])->update([
                    'stock' => $vo['stock'] - $totalSale,
                    'sales' => $vo['sales'] + $totalSale,
                    'update_time' => now()
                ]);
            }
        }

        return $stockNotEnough;
    }

    /**
     * 退还库存
     * @param $refundInfo
     * @param $orderInfo
     * @return array
     */
    public function giveBackSaleAndStore($refundInfo, $orderInfo)
    {
        // 普通订单
        if ($orderInfo['type'] == 1) {

            $applyRefundData = json_decode($refundInfo['apply_refund_data'], true)['order_num_data'];

            $detailId2Num = [];
            foreach ($applyRefundData as $vo) {
                $detailId2Num[$vo['order_detail_id']] = $vo['num'];
            }

            $orderDetailModel = new OrderDetail();
            $orderDetailList = $orderDetailModel->getAllList([
                ['id', 'in', array_keys($detailId2Num)]
            ])['data'];

            $goodsModel = new Goods();
            $goodsRuleExtendModel = new GoodsRuleExtend();
            foreach ($orderDetailList as $vo) {
                if (!empty($vo['rule_id'])) {

                    $goodsRuleExtendModel->where('id', $vo['rule_id'])->lock(true)->find();
                    $goodsRuleExtendModel->where('id', $vo['rule_id'])->inc('stock', $detailId2Num[$vo['id']])
                        ->dec('sales', $detailId2Num[$vo['id']])->update();

                    $goodsModel->where('id', $vo['goods_id'])->lock(true)->find();
                    $goodsModel->where('id', $vo['goods_id'])->inc('stock', $detailId2Num[$vo['id']])
                        ->dec('sales', $detailId2Num[$vo['id']])->update();
                } else {

                    $goodsModel->where('id', $vo['goods_id'])->lock(true)->find();
                    $goodsModel->where('id', $vo['goods_id'])->inc('stock', $detailId2Num[$vo['id']])
                        ->dec('sales', $detailId2Num[$vo['id']])->update();
                }
            }
        } else if ($orderInfo['type'] == 2) { // 拼团订单

        } else if ($orderInfo['type'] == 3) { // 秒杀订单
            $installed = hasInstalled('seckill');
            if (!$installed) {
                return dataReturn(-10, '秒杀插件未安装');
            }
            event('refundSeckillStock', $refundInfo);
        } else if ($orderInfo['type'] == 4) { // 砍价订单

        }

        return dataReturn(0, '操作成功');
    }

    /**
     * 计算优惠券折扣金额
     * @param $param
     * @param $totalPrice
     * @param $goods2Price
     * @param $userId
     * @return array
     */
    private function calcCoupon($param, $totalPrice, $goods2Price, $userId)
    {
        $couponInstalled = hasInstalled('coupon');
        if (!$couponInstalled) {
            return dataReturn(0, 'success', [
                'couponAmount' => 0,
                'type' => 0, // 券的类型 1:通用券 2:商品券
                'goods_id' => [], // 关联的商品id
            ]);
        }

        $couponParam = event('coupon', compact('param', 'totalPrice', 'goods2Price', 'userId'))['0'];
        if (empty($couponParam)) {
            return dataReturn(0, 'success', [
                'couponAmount' => 0,
                'type' => 0, // 券的类型 1:通用券 2:商品券
                'goods_id' => [], // 关联的商品id
            ]);
        }

        return $couponParam;
    }

    /**
     * 订单快检表，方便处理订单过期未处理问题
     * @param $orderId
     * @param $orderType
     * @param $postGoodsInfo
     * @return void
     */
    private function writeOverdueData($orderId, $orderType, $postGoodsInfo)
    {
        $overdueModel = new OrderOverdue();
        $baseConf = getConfByType('shop_base');

        $confTime = 0;
        if ($orderType == 1) {
            $confTime = $baseConf['com_unpaid_cancel_time'] ?? 2;
        } else if ($orderType == 2) {
            $confTime = $baseConf['collage_unpaid_cancel_time'] ?? 1;
        } else if ($orderType == 3) {
            $confTime = $baseConf['seckill_unpaid_cancel_time'] ?? 1;
        } else if ($orderType == 4) {
            $confTime = $baseConf['cut_unpaid_cancel_time'] ?? 1;
        }

        $overdueTime = date('Y-m-d H:i:s', time() + $confTime * 3600);
        $param = [];
        foreach ($postGoodsInfo as $vo) {
            $param[] = [
                'order_id' => $orderId,
                'type' => $orderType,
                'goods_id' => $vo['goods_id'],
                'rule_id' => $vo['rule_id'],
                'num' => $vo['num'],
                'overdue_time' => $overdueTime
            ];
        }
        $overdueModel->insertBatch($param);
    }

    /**
     * 计算优惠券均摊
     * @param $calcParam
     * @param $orderGoodsList
     * @param $goods2Num
     * @return array
     */
    protected function calcDivideCoupon($calcParam, $orderGoodsList, $goods2Num)
    {
        $goods2Amount = [];
        // 通用券
        if ($calcParam['coupon']['type'] == 1) {
            $hasDivideAmount = 0;
            $i = 0;
            $total = count($orderGoodsList);
            foreach ($orderGoodsList as $key => $vo) {
                $i++;
                if ($i == $total) {
                    $goods2Amount[$key] = $calcParam['coupon']['couponAmount'] - $hasDivideAmount; // 最后一个防止比例不对
                } else {

                    $goods2Amount[$key] = round((($vo['price'] * $goods2Num[$key]) / $calcParam['totalPrice'])
                        * $calcParam['coupon']['couponAmount'], 2);
                    $hasDivideAmount += $goods2Amount[$key];
                }
            }
        } else { // 指定商品券
            $hasDivideAmount = 0;
            $i = 0;
            $total = count($calcParam['coupon']['goods_id']);
            // 找出符合券的商品总额
            $totalPrice = 0;
            foreach ($calcParam['coupon']['goods_id'] as $vo) {
                $totalPrice += $orderGoodsList[$vo]['price'] * $goods2Num[$vo];
            }

            foreach ($calcParam['coupon']['goods_id'] as $vo) {
                $i++;
                if ($i == $total) {
                    $goods2Amount[$vo] = $calcParam['coupon']['couponAmount'] - $hasDivideAmount;
                } else {
                    $goods2Amount[$vo] = round((($orderGoodsList[$vo]['price'] * $goods2Num[$vo]) / $totalPrice)
                        * $calcParam['coupon']['couponAmount'], 2);
                    $hasDivideAmount = $goods2Amount[$vo] ;
                }
            }
        }

        return $goods2Amount;
    }

    /**
     * 计算vip均摊
     * @param $calcParam
     * @param $orderGoodsList
     * @param $goods2Num
     * @return array
     */
    protected function calcDivideUserVip($calcParam, $orderGoodsList, $goods2Num)
    {
        $vip2Amount = [];
        $hasDivideAmount = 0;
        $i = 0;
        $total = count($orderGoodsList);
        foreach ($orderGoodsList as $key => $vo) {
            $i++;
            if ($i == $total) {
                $vip2Amount[$key] = $calcParam['vipDiscount'] - $hasDivideAmount; // 最后一个防止比例不对
            } else {

                $vip2Amount[$key] = round((($vo['price'] * $goods2Num[$key]) / $calcParam['totalPrice'])
                    * $calcParam['vipDiscount'], 2);
                $hasDivideAmount += $vip2Amount[$key];
            }
        }

        return $vip2Amount;
    }
}