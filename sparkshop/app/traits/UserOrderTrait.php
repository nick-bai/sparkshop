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

use app\model\order\Order;
use app\model\order\OrderDetail;
use app\model\order\OrderPayLog;
use app\model\order\OrderRefund;
use strategy\pay\PayProvider;
use think\facade\Db;

trait UserOrderTrait
{
    /**
     * 处理再次支付
     * @param $param
     * @param $orderInfo
     * @param $orderModel
     * @param $userId
     * @return array
     */
    private function dealGoPay($param, $orderInfo, $orderModel, $userId)
    {
        $payOrderNo = makeOrderNo('P');
        $config = getConfByType('base');
        $payType = config('pay.pay_type');

        // 支付详情
        $orderDetailModel = new OrderDetail();
        $detailInfo = $orderDetailModel->getAllList([
            ['order_id', '=', $param['order_id']],
        ])['data']->toArray();

        Db::startTrans();
        try {

            $orderPayLogModel = new OrderPayLog();
            // 旧的记录重新支付
            $orderPayLogModel->where('order_id', $param['order_id'])
                ->where('pay_order_no', $orderInfo['pay_order_no'])->update([
                    'status' => 7,
                    'update_time' => now()
                ]);
            // 写入支付记录
            $orderPayLogModel->insert([
                'order_id' => $param['order_id'],
                'pay_way' => $payType[$param['pay_way']],
                'pay_order_no' => $payOrderNo,
                'status' => 1,
                'create_time' => now()
            ]);

            // 更新订单信息
            $orderModel->where('id', $param['order_id'])->update([
                'pay_way' => $payType[$param['pay_way']],
                'pay_order_no' => $payOrderNo,
                'update_time' => now()
            ]);

            $count = 0;
            foreach ($detailInfo as $vo) {
                $count += $vo['cart_num'];
            }

            // 发起支付
            $payProvider = new PayProvider($param['pay_way']);
            $payParam = [
                'out_trade_no' => $payOrderNo,
                'total_amount' => $orderInfo['pay_price'],
                'subject' => count($detailInfo) >= 2 ?
                    $config['website_title'] . '合并订单共' .  $count . '件'
                    : $detailInfo[0]['goods_name'],
                'user_id' => $userId,
                'return_url' => $config['h5_domain'] . '/#/pages/order/order'
            ];

            $platform = $param['platform'] ?? '';
            $res = $payProvider->payByPlatform($platform, $param['pay_way'], $payParam);
            if ($platform != 'h5') {
                $res['pay_price'] = $orderInfo['pay_price'];
            }

            Db::commit();
            return dataReturn(0, $orderInfo['order_no'], $res);
        } catch (\Exception $e) {
            Db::rollback();
            return dataReturn(-6, $e->getMessage() . '|' . $e->getFile() . '|' . $e->getLine());
        }
    }

    /**
     * 处理退款
     * @param $param
     * @param $userId
     * @param $userName
     * @return array
     */
    private function dealRefundOrder($param, $userId, $userName)
    {
        if (isset($param['refund_img']) && !empty($param['refund_img'])) {
            $refundImg = explode(',', $param['refund_img']);
            if (count($refundImg) > 3) {
                return dataReturn(-1, "最多上传3张凭证");
            }
        }

        if (isset($param['refund_num']) && $param['refund_num'] <= 0) {
            return dataReturn(-10, "退款数量需大于0");
        }

        $orderModel = new Order();
        $orderInfo = $orderModel->findOne([
            ['id', 'in', $param['order_id']],
            ['status', 'in', [3, 4, 5, 6]],
            ['user_id', '=', $userId]
        ])['data'];

        if (empty($orderInfo)) {
            return dataReturn(-1, "订单异常无法退款");
        }

        if ($orderInfo['refund_status'] == 2) {
            return dataReturn(-2, "该订单已经申请了退款,请耐心等待审批");
        }

        if ($orderInfo['refund_status'] == 3) {
            return dataReturn(-3, "该订单无法再次申请退款");
        }

        // 看是否已过了申请有效期
        if (!empty($orderInfo['received_time'])) {
            $validateDay = getConfByType('shop_refund')['refund_validate_day'] ?? 7;
            if ((time() - strtotime($orderInfo['received_time'])) > $validateDay * 86400) {
                return dataReturn(-4, "抱歉，该订单已过售后申请时效");
            }
        }

        $param['order_no'] = $orderInfo['order_no'];

        // 判断是否是全部退款还是部分退款
        $orderDetailModel = new OrderDetail();
        $orderDetailList = $orderDetailModel->getAllList([
            'order_id' => $param['order_id'],
            'refunded_flag' => 1
        ])['data'];

        // 订单详情一致且数量一致，则是全部退款
        $param['order_num_data'] = $postRefundOrderDetail = json_decode($param['order_num_data'], true);
        if (count($orderDetailList) == count($postRefundOrderDetail)) {
            $postRefundOrderDetailMap = [];
            foreach ($postRefundOrderDetail as $vo) {
                $postRefundOrderDetailMap[$vo['order_detail_id']] = $vo['num'];
            }

            $orderDetailListTmp = $orderDetailList;
            $orderDetailListTmp = $orderDetailListTmp->toArray();
            foreach ($orderDetailListTmp as $key => $vo) {

                if (isset($postRefundOrderDetailMap[$vo['id']])) {
                    if ($postRefundOrderDetailMap[$vo['id']] > $vo['cart_num']) {
                        return dataReturn(-11, '退款数量异常');
                    }

                    if ($vo['cart_num'] == $postRefundOrderDetailMap[$vo['id']]) {
                        unset($orderDetailListTmp[$key]);
                    }
                }
            }

            if (empty($orderDetailListTmp)) {
                // 整体退款
                return $this->refundMainOrder($param, $userId, $userName, $orderInfo);
            } else {
                // 部分退款
                return $this->refundSubOrder($param, $userId, $userName, $orderDetailList);
            }
        } else {
            // 部分退款
            return $this->refundSubOrder($param, $userId, $userName, $orderDetailList);
        }
    }

    /**
     * 退主订单
     * @param $param
     * @param $userId
     * @param $userName
     * @param $orderInfo
     * @return array
     */
    private function refundMainOrder($param, $userId, $userName, $orderInfo)
    {
        $orderModel = new Order();
        $orderRefundModel = new OrderRefund();

        // 更新已经申请退款了
        $orderModel->updateById([
            'refund_status' => 2, // 审批中
            'update_time' => now()
        ], $param['order_id']);

        $res = $orderRefundModel->insertOne([
            'order_id' => $param['order_id'],
            'order_no' => $orderInfo['order_no'],
            'refund_order_no' => makeOrderNo('T'),
            'user_id' => $userId,
            'user_name' => $userName,
            'step' => 2,
            'refund_type' => $param['refund_type'],
            'refund_way' => 1,
            'refund_price' => $orderInfo['pay_price'],
            'refund_num' => $orderInfo['total_num'],
            'apply_refund_reason' => $param['apply_refund_reason'],
            'refund_img' => $param['refund_img'] ?? '',
            'apply_refund_data' => json_encode($param),
            'remark' => $param['remark'],
            'status' => 1, // 待审批
            'create_time' => now()
        ]);

        return dataReturn(0, "申请成功，请耐心等待审批。", $res['data']);
    }

    /**
     * 部分退款
     * @param $param
     * @return array
     */
    private function refundSubOrder($param, $userId, $userName, $orderDetailList)
    {
        $orderModel = new Order();
        $orderRefundModel = new OrderRefund();

        // 更新已经申请退款了
        $orderModel->updateById([
            //'refund_status' => 2, // 审批中
            'update_time' => now()
        ], $param['order_id']);

        $detailId2Num = [];
        $refundNum = 0;
        foreach ($param['order_num_data'] as $vo) {
            $refundNum += $vo['num'];
            $detailId2Num[$vo['order_detail_id']] = $vo['num'];
        }

        $totalAmount = 0;
        // 需要退的优惠券金额
        $totalCouponAmount = 0;
        // 均摊的会员折扣
        $totalDiscountAmount = 0;

        foreach ($orderDetailList as $vo) {
            if (!isset($detailId2Num[$vo['id']])) {
                continue;
            }

            // 申请退款的数量等于实际下单的数量
            if ($detailId2Num[$vo['id']] == $vo['cart_num']) {
                $totalCouponAmount += $vo['coupon_amount'];
                $totalDiscountAmount += $vo['vip_discount'];
            } else {
                $totalCouponAmount += round(($vo['coupon_amount'] / $vo['cart_num']) * $detailId2Num[$vo['id']], 2);
                $totalDiscountAmount += round(($vo['vip_discount'] / $vo['cart_num']) * $detailId2Num[$vo['id']], 2);
            }

            $totalAmount += round($detailId2Num[$vo['id']] * $vo['price'], 2);
        }

        $res = $orderRefundModel->insertOne([
            'order_id' => $param['order_id'],
            'order_no' => $param['order_no'],
            'refund_order_no' => makeOrderNo('T'),
            'user_id' => $userId,
            'user_name' => $userName,
            'step' => 2,
            'refund_type' => $param['refund_type'],
            'refund_price' => $totalAmount - $totalCouponAmount - $totalDiscountAmount,
            'refund_way' => 2, // 部分退
            'refund_num' => $refundNum,
            'apply_refund_reason' => $param['apply_refund_reason'],
            'refund_img' => $param['refund_img'] ?? '',
            'apply_refund_data' => json_encode($param),
            'remark' => $param['remark'],
            'status' => 1, // 待审批
            'create_time' => now()
        ]);

        return dataReturn(0, "申请成功，请耐心等待审批。", $res['data']);
    }
}