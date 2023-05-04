<?php
// +----------------------------------------------------------------------
// | SparkShop 坚持做优秀的商城系统
// +----------------------------------------------------------------------
// | Copyright (c) 2022~2099 http://sparkshop.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://opensource.org/licenses/mit-license.php )
// +----------------------------------------------------------------------
// | Author: NickBai
// +----------------------------------------------------------------------
namespace app\index\service;

use app\model\goods\Goods;
use app\model\order\Order;
use app\model\order\OrderRefund;
use app\traits\OrderTrait;
use strategy\pay\PayProvider;
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
        $orderList = $orderModel->with(['detail'])
            ->field('id,type,status,order_no,pay_way,pay_price,refunded_price,pay_status,seckill_goods_id,refund_flag,user_comments,create_time')
            ->where('user_id', $userId)
            ->where('user_del', 1)
            ->where($where)->order('id desc')->paginate($limit)->each(function ($item) use ($orderStatus, $payWay, &$orderIdList, &$goodsIdList) {
                $item->status_txt = $orderStatus[$item->status] ?? '未知';
                $item->pay_txt = $payWay[$item->pay_way] ?? '未知';
                $item->pay_price = number_format($item->pay_price, 2);
                $orderIdList[] = $item->id;
                foreach ($item->detail as $vo) {
                    $goodsIdList[$vo['order_id']] = $vo->goods_id;
                }
            });

        $refundModel = new OrderRefund();
        $refundList = $refundModel->getAllList([
            ['order_id', 'in', $orderIdList],
            ['status', '=', 1]
        ], 'id,order_id,order_detail_id,user_id,status,refund_type')['data'];

        // 只取最新的状态
        $finalList = [];
        foreach ($refundList as $vo) {
            if (!isset($finalList[$vo['order_id']])) {
                $finalList[$vo['order_id']] = $vo->toArray();
            }
        }

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

        $orderList = $orderList->each(function ($item) use ($finalList) {
            $item->refund_status = 0;
            $item->refund_type = 0;
            $item->refund_detail_id = 0;
            $item->refund_id = 0;
            if (isset($finalList[$item->id])) {
                $item->refund_order_id = $item->id; // 退款订单order_id
                $item->refund_id = $finalList[$item->id]['id'];
                $item->refund_detail_id = $finalList[$item->id]['order_detail_id'];
                $item->refund_status = $finalList[$item->id]['status'];
                $item->refund_type = $finalList[$item->id]['refund_type'];
            }
        });

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
    public function getOrderInfo($param)
    {
        try {

            $orderData = json_decode($param['order_data'], true);
            $goodsIds = [];
            $goods2Num = [];
            $goods2Rule = [];
            $cartId = [];
            $orderType = 0; // 订单类型
            foreach ($orderData as $vo) {
                $goodsIds[] = $vo['id'];
                $goods2Num[$vo['id']] = $vo['num'];
                $goods2Rule[$vo['id']] = $vo['rule_id'];
                if (isset($vo['cart_id'])) {
                    $cartId[] = $vo['cart_id'];
                }
                $orderType = !isset($vo['type']) ? 1 : $vo['type'];
            }

            $seckillId = 0;
            $seckillGoodsId = 0;
            // 如果是秒杀商品,确定是否有库存、购买的数量是否正确、是否可以再购买
            if ($orderType == 3) {
                $res = $this->dealSeckill($goodsIds, $orderData);
                $seckillId = $orderData[0]['seckill_id'];
                $seckillGoodsId = $orderData[0]['seckill_goods_id'];
                if ($res['code'] != 0) {
                    return $res;
                }
            }

            // 商品信息
            $goodsModel = new \app\model\Goods();
            $goodsList = $goodsModel->whereIn('id', $goodsIds)->select()->toArray();

            if (empty($goodsList)) {
                return dataReturn(-1, '您购买的商品已下架');
            }

            $buyGoods = [];
            $trail = [];
            $seckillGoodsModel = new SeckillActivityGoods();
            foreach ($goodsList as $goodsInfo) {

                // 商品的属性
                if ($goodsInfo['spec'] == 1) {

                    // 秒杀订单，价格重新计算
                    if ($orderType == 3) {
                        $seckillInfo = $seckillGoodsModel->getInfoById($orderData[0]['seckill_goods_id'], 'id', 'seckill_price')['data'];
                        $price = $seckillInfo['seckill_price'];
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

                    $ruleModel = new GoodsRuleExtend();
                    $ruleInfo = $ruleModel->field('id,sku,image,price')->where('goods_id', $goodsInfo['id'])
                        ->where('id', $goods2Rule[$goodsInfo['id']])->find();
                    $ruleInfo['sku'] = implode(" ", explode('※', $ruleInfo['sku']));

                    // 秒杀订单，价格重新计算
                    if ($orderType == 3) {
                        $seckillInfo = $seckillGoodsModel->getInfoById($orderData[0]['seckill_goods_id'], 'id', 'seckill_price')['data'];
                        $ruleInfo['price'] = $seckillInfo['seckill_price'];
                    }
                }

                $buyGoods[] = [
                    'goods' => $goodsInfo,
                    'ruleInfo' => $ruleInfo,
                    'num' => $goods2Num[$goodsInfo['id']]
                ];

                $trail[] = [
                    'goods_id' => $goodsInfo['id'],
                    'rule_id' => $ruleInfo['id'],
                    'num' => $goods2Num[$goodsInfo['id']]
                ];
            }

            $payWayConf = SparkTools::getPayWay();
            $formatOrderParam = [];
            foreach ($buyGoods as $vo) {
                $formatOrderParam[]= [
                    'goods_id' => $vo['goods']['id'],
                    'amount' => $vo['ruleInfo']['price'] * $vo['num'],
                ];
            }

            return dataReturn(0, 'success', [
                'format_order_param' => json_encode($formatOrderParam),
                'buy_goods' => $buyGoods,
                'trail' => json_encode($trail),
                'cart_ids' => implode(",", $cartId),
                'payWayMap' => $payWayConf['payWayMap'],
                'pay_way' => $payWayConf['payWay'],
                'type' => $orderType,
                'seckill_id' => $seckillId,
                'seckill_goods_id' => $seckillGoodsId
            ]);
        } catch (\Exception $e) {
            return dataReturn(-2, '订单异常');
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
        $orderModel = new \app\model\Order();
        $refundPass = config('shop.refund_pass');

        // 订单信息
        $orderInfo = $orderModel->with(['detail', 'address'])
            ->where('id', $id)->where('user_id', $userId)->where('user_del', 1)->find();

        if (empty($orderInfo)) {
            return dataReturn(-1, '订单信息错误');
        }

        $totalRefundAmount = 0;
        foreach ($orderInfo['detail'] as $vo) {
            $totalRefundAmount += $vo['refunded_price'];
        }

        // 查询退款信息
        $orderRefundModel = new OrderRefund();
        $refundInfo = $orderRefundModel->where('order_id', $orderInfo['id'])
            ->where('user_id', $userId)->where('status', 1)->find();
        if (!empty($refundInfo)) {
            $refundInfo['status_txt'] = $refundPass[$refundInfo['status']];
        }

        $orderInfo['status_txt'] = $orderStatus[$orderInfo['status']] ?? '未知';
        $orderInfo['pay_txt'] = $payWay[$orderInfo['pay_way']] ?? '未知';

        return dataReturn(0, 'success', [
            'order' => $orderInfo,
            'refund' => $refundInfo,
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
        // 处理订单数据
        $orderParam = $this->dealCreateOrder($param, $userId);
        if ($orderParam['code'] != 0) {
            return $orderParam;
        }
        $orderParam = $orderParam['data'];
        $orderParam['orderGoodsList'] = array_values($orderParam['orderGoodsList']);

        if (!empty($param['cart_id'])) {
            (new \app\model\Cart())->whereIn('id', $param['cart_id'])->where('user_id', $userId)->delete();
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
            'user_id' => $userId
        ];

        if (isset($param['platform']) && $param['platform'] == 'miniapp') {
            $res = $payProvider->getStrategy()->miniappPay($payParam);
        } else {
            $res = $payProvider->getStrategy()->pay($payParam);
        }

        return dataReturn(0, 'success', $res);
    }

    /**
     * 获取订单状态
     * @param $payOrder
     * @return array
     */
    public function getOrderStatus($payOrder)
    {
        $orderModel = new \app\model\Order();
        return $orderModel->findOne([
            'pay_order_no' => $payOrder
        ], 'pay_status');
    }
}