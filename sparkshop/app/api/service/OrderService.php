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
namespace app\api\service;

use app\model\goods\Goods;
use app\model\goods\GoodsRuleExtend;
use app\model\order\Order;
use app\model\order\OrderOverdue;
use app\model\system\Cart;
use app\model\system\Plugins;
use app\model\system\SysSetting;
use app\model\user\User;
use app\traits\OrderTrait;
use strategy\pay\PayProvider;
use think\facade\Db;
use utils\SparkTools;

class OrderService
{
    use OrderTrait;

    /**
     * 获取用户的订单列表
     * @param $param
     * @param $userId
     * @return array
     */
    public function getUserOrderList($param, $userId)
    {
        $limit = $param['limit'];
        $status = $param['status'];
        $keywords = $param['keywords'];

        $where[] = ['pid', '>=', 0];
        // 小程序端 status = 0 表示待评价
        if ($status == 0) {
            $where[] = ['status', '=', 6];
            $where[] = ['user_comments', '=', 1];
        } else if ($status > 0) {
            $where[] = ['status', 'in', $status];
        }

        if (!empty($keywords)) {
            $where[] = ['order_no', '=', $keywords];
        }

        $orderStatus = config('order.order_status');
        $payWay = config('order.pay_way');

        $orderIdList = [];
        $goodsIdList = [];
        $orderModel = new Order();
        $orderList = $orderModel->with(['detail', 'refund'])
            ->field('id,type,status,order_no,pay_way,pay_price,pay_status,user_comments,create_time')
            ->where('user_id', $userId)
            ->where('is_del', 1)
            ->where('user_del', 1)
            ->where($where)->order('id desc')->paginate($limit)->each(function ($item) use ($orderStatus, $payWay, &$orderIdList, &$goodsIdList) {
                $item->status_txt = $orderStatus[$item->status] ?? '未知';
                $item->pay_txt = $payWay[$item->pay_way] ?? '未知';
                $item->pay_price = number_format($item->pay_price, 2);

                $applyMap = [];
                if (!empty($item->refund)) {
                    $applyData = json_decode($item->refund->apply_refund_data, true)['order_num_data'];
                    foreach ($applyData as $vo) {
                        $applyMap[$vo['order_detail_id']] = $vo['num'];
                    }
                }

                $orderIdList[] = $item->id;
                foreach ($item->detail as $key => $vo) {
                    $goodsIdList[$vo['order_id']] = $vo->goods_id;

                    if (isset($applyMap[$vo['id']])) {
                        $item->detail[$key]['apply_refund_num'] = $applyMap[$vo['id']];
                    }
                }

                return $item;
            });

        // 商品信息
        $goodsModel = new Goods();
        $goodsInfo = $goodsModel->getAllList([
            ['id', 'in', array_unique(array_values($goodsIdList))],
        ], 'id,type')['data'];

        $goods2type = [];
        foreach ($goodsInfo as $vo) {
            foreach ($goodsIdList as $k => $v) {
                if ($v == $vo['id']) {
                    $goods2type[$k] = $vo['type'];
                }
            }
        }

        $orderList = $orderList->each(function ($item) use ($goods2type) {
            $item->goods_type = $goods2type[$item->id];
        });

        return dataReturn(0, 'success', $orderList);
    }

    /**
     * 获取待付款订单信息
     * @param $param
     * @return array
     */
    public function prepareOrderParam($param)
    {
        try {

            $orderData = json_decode($param['order_data'], true);
            $goodsIds = [];
            $trail = [];
            $cartId = [];
            $orderType = 0; // 订单类型
            foreach ($orderData as $vo) {
                $goodsIds[] = $vo['id'];

                if (isset($vo['cart_id'])) {
                    $cartId[] = $vo['cart_id'];
                }

                $trail[] = [
                    'goods_id' => $vo['id'],
                    'rule_id' => $vo['rule_id'],
                    'num' => $vo['num']
                ];

                $orderType = !isset($vo['order_type']) ? 1 : $vo['order_type']; // 订单类型 1:普通订单 2:拼团订单 3:秒杀订单 4:砍价订单
            }

            // 其他类型订单的参数
            $otherOrderParam = [];

            // 商品信息
            $goodsModel = new Goods();
            $goodsList = $goodsModel->whereIn('id', array_unique($goodsIds))->select()->toArray();

            if (empty($goodsList)) {
                return dataReturn(-1, '您购买的商品已下架');
            }

            $goodsId2Info = [];
            foreach ($goodsList as $vo) {
                $goodsId2Info[$vo['id']] = $vo;
            }

            $buyGoods = [];
            $ruleModel = new GoodsRuleExtend();
            foreach ($orderData as $vo) {

                // 商品的属性
                $goodsInfo = $goodsId2Info[$vo['id']];
                if ($goodsInfo['spec'] == 1) {
                    // 不是普通订单，价格重新计算
                    if ($orderType != 1) {
                        $price = 0;
                    } else {
                        $price = $goodsInfo['price'];
                    }

                    $ruleInfo = [
                        'id' => 0,
                        'sku' => '',
                        'image' => json_decode($goodsInfo['slider_image'], true)[0],
                        'price' => $price
                    ];
                } else {
                    $ruleInfo = $ruleModel->field('id,sku,image,price')->where('goods_id', $vo['id'])
                        ->where('id', $vo['rule_id'])->find();
                    $ruleInfo['sku'] = implode(" ", explode('※', $ruleInfo['sku']));

                    // 不是普通订单，价格重新计算
                    if ($orderType != 1) {
                        $ruleInfo['price'] = 0;
                    }
                }

                $buyGoods[] = [
                    'goods' => $goodsInfo,
                    'ruleInfo' => $ruleInfo,
                    'num' => $vo['num']
                ];
            }

            $payWayConf = SparkTools::getPayWay();

            return dataReturn(0, 'success', [
                'buy_goods' => $buyGoods,
                'trail' => json_encode($trail),
                'cart_ids' => implode(",", $cartId),
                'payWayMap' => $payWayConf['payWayMap'],
                'pay_way' => $payWayConf['payWay'],
                'type' => $orderType,
                'other_order_param' => $otherOrderParam // 该参数舍弃
            ]);
        } catch (\Exception $e) {
            return dataReturn(-2, '订单异常', $e->getMessage() . '|' . $e->getFile() . '|' . $e->getLine());
        }
    }

    /**
     * 查询订单详情
     * @param $id
     * @param $userId
     * @return array
     */
    public function getOrderDetail($id, $userId)
    {
        $orderStatus = config('order.order_status');
        $payWay = config('order.pay_way');
        $orderModel = new Order();

        // 订单信息
        $field = 'id,coupon_amount,create_time,order_no,order_price,pay_order_no,pay_postage,pay_price,pay_status,pay_time,pay_way,refund_status,received_time,status,vip_discount,delivery_name,delivery_no';
        $orderInfo = $orderModel->with(['detail', 'address', 'refund'])->field($field)
            ->where('id', $id)->where('user_id', $userId)->where('user_del', 1)->find();

        if (empty($orderInfo)) {
            return dataReturn(-11, '订单信息错误');
        }

        $applyMap = [];
        if (!empty($orderInfo['refund'])) {
            $applyData = json_decode($orderInfo['refund']->apply_refund_data, true)['order_num_data'];
            foreach ($applyData as $vo) {
                $applyMap[$vo['order_detail_id']] = $vo['num'];
            }
        }

        foreach ($orderInfo['detail'] as $key => $vo) {
            if (isset($applyMap[$vo['id']])) {
                $orderInfo['detail'][$key]['apply_refund_num'] = $applyMap[$vo['id']];
            }
        }

        if (empty($orderInfo)) {
            return dataReturn(-1, '订单信息错误');
        }

        $totalRefundAmount = 0;
        foreach ($orderInfo['detail'] as $vo) {
            $totalRefundAmount += $vo['refunded_price'];
        }

        $orderInfo['status_txt'] = $orderStatus[$orderInfo['status']] ?? '未知';
        $orderInfo['pay_txt'] = $payWay[$orderInfo['pay_way']] ?? '未知';

        $orderInfo['can_refund'] = true;
        if (!empty($orderInfo['received_time'])) {
            $refundValidateDay = getConfByType('shop_refund')['refund_validate_day'];
            if ((time() - strtotime($orderInfo['received_time'])) > $refundValidateDay * 86400) {
                $orderInfo['can_refund'] = false;
            }
        }

        return dataReturn(0, 'success', [
            'order' => $orderInfo,
            'totalRefundAmount' => $totalRefundAmount
        ]);
    }

    /**
     * 试算
     * @param $param
     * @return array
     */
    public function doTrial($param, $userId)
    {
        return $this->dealTrial($param, $userId);
    }

    /**
     * 创建订单
     * @param $param
     * @param $userId
     * @return array
     */
    public function createOrder($param, $userId)
    {
        Db::startTrans();
        try {

            // 处理订单数据
            $orderParam = $this->dealCreateOrder($param, $userId);
            if ($orderParam['code'] != 0) {
                return $orderParam;
            }
            $orderParam = $orderParam['data'];
            $orderParam['orderGoodsList'] = array_values($orderParam['orderGoodsList']);

            // 处理购物车
            if (!empty($param['cart_id'])) {
                (new Cart())->whereIn('id', $param['cart_id'])->where('user_id', $userId)->delete();
            }

            // 无需实际支付的
            if ($orderParam['calcParam']['realPay'] <= 0) {
                // 删除快检表的数据，防止过多的扫描
                $overdueModel = new OrderOverdue();
                $overdueModel->delById($orderParam['orderId'], 'order_id');

                return $this->completeOrder([
                    'id' => $orderParam['orderId'],
                    'pay_order_no' => $orderParam['payOrderNo']
                ]);
            }

            $config = getConfByType('base');
            // 发起支付
            $payProvider = new PayProvider($param['pay_way']);
            $payParam = [
                'out_trade_no' => $orderParam['payOrderNo'],
                'total_amount' => $orderParam['calcParam']['realPay'],
                'subject' => count($orderParam['orderGoodsList']) >= 2 ?
                    $config['website_title'] . '合并订单共' .  $orderParam['calcParam']['count'] . '件'
                    : $orderParam['orderGoodsList'][0]['name'],
                'user_id' => $userId,
                'return_url' => $config['h5_domain'] . '/#/pages/order/order'
            ];

            $platform = $param['platform'] ?? '';
            $res = $payProvider->payByPlatform($platform, $param['pay_way'], $payParam);

            Db::commit();
            return dataReturn(0, $orderParam['orderNo'], $res);
        } catch (\Exception $e) {
            Db::rollback();
            return dataReturn(-11, '系统异常');
        }
    }

    /**
     * 获取订单信息
     * @param $orderNo
     * @return array
     */
    public function getOrderInfoByOrderNo($orderNo)
    {
        $orderModel = new Order();
        return $orderModel->findOne([
            'order_no' => $orderNo
        ], 'id,order_no,create_time,pay_way,pay_price,pay_status');
    }

    /**
     * 获取营销插件配置
     * @return array
     */
    public function getMarketingConfig()
    {
        // 会员等级折扣
        $vipConf = getConfByType('shop_user_level');
        $config['userVip'] = ($vipConf['user_level_open'] == 1) ? 1 : 0;

        // 优惠券是否开启
        $pluginsModel = new Plugins();
        $couponConfig = $pluginsModel->findOne([
            'name' => 'coupon'
        ])['data'];

        if (empty($couponConfig)) {
            $config['coupon'] = 0;
        } else {
            $config['coupon'] = ($couponConfig['status'] == 2) ? 1 : 0;
        }

        return dataReturn(0, 'success', $config);
    }

    /**
     * 获取支付基础配置
     * @return array
     */
    public function getPayConfig($userId)
    {
        $sysSettingModel = new SysSetting();
        $config = $sysSettingModel->getOpenWay();

        return dataReturn(0, 'success', [
            'config' => $config['data'],
            'balance' => User::where('id', $userId)->find()->balance
        ]);
    }
}