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

use addons\coupon\model\CouponReceiveLog;
use addons\seckill\model\SeckillActivityGoods;
use app\model\goods\Goods;
use app\model\order\Order;
use app\model\order\OrderAddress;
use app\model\order\OrderComment;
use app\model\order\OrderDetail;
use app\model\order\OrderExpress;
use app\model\order\OrderRefund;
use app\model\order\OrderStatusChange;
use app\model\user\User;
use app\model\user\UserBalanceLog;
use app\model\user\UserLevel;
use app\traits\UserOrderTrait;
use strategy\express\ExpressProvider;
use think\facade\Db;

class UserOrderService
{
    use UserOrderTrait;

    /**
     * 订单取消
     * @param $id
     * @param $userId
     * @param $userName
     * @return array
     */
    public function orderCancel($id, $userId, $userName)
    {
        Db::startTrans();
        try {

            $orderModel = new Order();
            $orderInfo = $orderModel->where('user_id', $userId)->where('id', $id)
                ->where('status', 2)
                ->where('user_del', 1)
                ->where('is_del', 1)->find();

            if (empty($orderInfo)) {
                return dataReturn(-1, '该订单异常');
            }

            $orderModel->where('id', $id)->update([
                'status' => 7, // 取消
                'refund_flag' => 2, // 还可以申请售后
                'pay_price' => 0, // 实际支付为 0
                'cancel_time' => now()
            ]);

            $orderStatusModel = new OrderStatusChange();
            $orderStatusModel->insert([
                'order_id' => $id,
                'original_status' => 2,
                'new_status' => 7,
                'msg' => '订单取消',
                'operator_id' => $userId,
                'operator_name' => $userName,
                'create_time' => now()
            ]);

            // 归还优惠券
            $myCouponReceivedModel = new CouponReceiveLog();
            $myCouponReceivedModel->where('order_id', $id)->update([
                'status' => 1,
                'order_id' => 0,
                'update_time' => now()
            ]);

            Db::commit();
        } catch (\Exception $e) {
            Db::rollback();
            return dataReturn(-2, $e->getMessage());
        }

        return dataReturn(0, '取消成功');
    }

    /**
     * 订单内支付
     * @param $param
     * @param $userId
     * @return array
     */
    public function goPay($param, $userId)
    {
        if (empty($param['order_id'])) {
            return dataReturn(-1, '请选择要支付的订单');
        }

        if (empty($param['pay_way'])) {
            return dataReturn(-2, '请选择支付方式');
        }

        $orderModel = new Order();
        $orderInfo = $orderModel->findOne([
            ['id', '=', $param['order_id']],
            ['user_id', '=', $userId]
        ])['data'];

        if (empty($orderInfo)) {
            return dataReturn(-3, '订单数据错误');
        }

        if ($orderInfo['pay_status'] != 1 && $orderInfo['status'] != 2) {
            return dataReturn(-4, '该订单无法支付');
        }

        return $this->dealGoPay($param, $orderInfo, $orderModel, $userId);
    }

    /**
     * 构建参数
     * @param $id
     * @param $type
     * @param $userId
     * @return array
     */
    public function buildOrderParam($id, $type, $userId)
    {
        $orderDetailModel = new OrderDetail();
        $seckillGoodsModel = new SeckillActivityGoods();
        // 整体退款
        if ($type == 1) {
            $orderModel = new Order();
            $orderInfo = $orderModel->findOne([
                ['id', '=', $id],
                ['status', 'in', [3, 6]],
                ['user_id', '=', $userId]
            ])['data'];

            if (empty($orderInfo)) {
                return dataReturn(-1, '该订单状态已变更，请稍后再试。');
            }

            // 订单详情
            $orderList = $orderDetailModel->getAllList([
                ['order_id', '=', $id]
            ])['data'];

            $total = 0;
            foreach ($orderList as $key => $vo) {
                $total += $vo['cart_num'];
                // 秒杀商品
                if ($orderInfo['type'] == 3) {
                    $res = $seckillGoodsModel->findOne([
                        'id' => $orderInfo['seckill_goods_id']
                    ], 'seckill_price')['data'];

                    $orderList[$key]['price'] = $res['seckill_price'];
                }
            }

            $orderType = 1;
        } else { // 一单多商品，退其中一个

            $detailInfo = $orderDetailModel->findOne([
                'id' => $id
            ])['data'];

            if (empty($detailInfo)) {
                return dataReturn(-2, '该订单数据异常');
            }

            // 确定该订单是否属于当前用户
            $orderModel = new Order();
            $orderData = $orderModel->findOne([
                ['id', '=', $detailInfo['order_id']],
                ['status', 'in', [3, 6]],
                ['user_id', '=', $userId]
            ], 'id,type,seckill_goods_id,status,coupon_amount')['data'];

            if (empty($orderData)) {
               return dataReturn(-3, '该订单数据异常');
            }

            // 秒杀商品
            if ($orderData['type'] == 3) {
                $res = $seckillGoodsModel->findOne([
                    'id' => $orderData['seckill_goods_id']
                ], 'seckill_price')['data'];

                $detailInfo['price'] = $res['seckill_price'];
            }

            // 退款单详情
            $refundOrderModel = new OrderRefund();
            $refundInfo = $refundOrderModel->findOne([
                'order_id' => $detailInfo['order_id'],
                'user_id' => $userId,
                'status' => 1
            ])['data'];

            if (empty($refundInfo)) {
                $refundInfo['refund_num'] = 0;
            }

            // 订单内的全部商品都退了，则退邮费
            $postage = (($orderData['total_num'] - $orderData['refunded_num']) == $refundInfo['refund_num']) ? $orderData['pay_postage'] : 0;
            $orderList[] = $detailInfo;

            $orderType = 2;
            $total = $detailInfo['cart_num'];
            $couponAmount = $detailInfo['coupon_amount'];
            $vipDiscount = $detailInfo['vip_discount'];

            $orderInfo = [
                'status' => $orderData['status'],
                'id' => $detailInfo['id'],
                'pay_price' => $detailInfo['price'] * $detailInfo['cart_num'] - $couponAmount - $vipDiscount,
                'total_num' => $detailInfo['cart_num'],
                'order_price' => $detailInfo['price'] * $detailInfo['cart_num'] + $postage,
                'coupon_amount' => $couponAmount, // 优惠券
                'vip_discount' => $vipDiscount, // 会员折扣
                'pay_postage' => $postage
            ];
        }

        $goodsId = $orderList[0]['goods_id'];
        $goodsModel = new Goods();
        $goodsInfo = $goodsModel->findOne([
            'id' => $goodsId
        ], 'type')['data'];
        $refundConf = getConfByType('shop_refund');

        return dataReturn(0, 'success', [
            'order_type' => $orderType,
            'total' => $total,
            'info' => $orderInfo,
            'detail' => $orderList,
            'refund_select' => explode(PHP_EOL, $refundConf['only_refund']),
            'refund_goods_select' => explode(PHP_EOL, $refundConf['goods_refund']),
            'goods_type' => $goodsInfo['type']
        ]);
    }

    /**
     * 处理退款订单
     * @param $param
     * @param $userId
     * @param $userName
     * @return array
     */
    public function doRefundOrder($param, $userId, $userName)
    {
        return $this->refundOrder($param, $userId, $userName);
    }

    /**
     * 退款详情
     * @param $id
     * @param $userId
     * @return array
     */
    public function userRefundDetail($id, $userId)
    {
        $orderRefundModel = new OrderRefund();
        $refundOrderInfo = $orderRefundModel->findOne([
            ['id', '=', $id],
            ['user_id', '=', $userId]
        ])['data'];

        if (empty($refundOrderInfo)) {
           return dataReturn(0, '该订单数据异常无法查看');
        }

        $refundType = config('shop.refund_type');
        $step = config('shop.refund_step');
        $refundGoodsStep = config('shop.refund_goods_step');
        $refundPass = config('shop.refund_pass');

        // 订单具体的信息
        $orderDetailModel = new OrderDetail();
        $detailData = $orderDetailModel->getAllList([
            ['id', 'in', $refundOrderInfo['order_detail_ids']]
        ])['data'];

        $refundOrderInfo['refund_type_txt'] = $refundType[$refundOrderInfo['refund_type']];
        if ($refundOrderInfo['refund_type'] == 1) {
            $refundOrderInfo['step_txt'] = $step[$refundOrderInfo['step']];
        } else {
            $refundOrderInfo['step_txt'] = $refundGoodsStep[$refundOrderInfo['step']];
        }
        $refundOrderInfo['refund_status_txt'] = $refundPass[$refundOrderInfo['status']];
        $refundOrderInfo['refund_img'] = array_filter(explode(',', $refundOrderInfo['refund_img']));

        // 订单金额
        $orderModel = new Order();
        $info = $orderData = $orderModel->findOne([
            ['id', '=', $refundOrderInfo['order_id']],
            ['user_id', '=', $userId]
        ])['data'];

        // 如果是秒杀商品
        if ($info['type'] == 3) {
            $seckillGoodsModel = new SeckillActivityGoods();
            $res = $seckillGoodsModel->getInfoById($info['seckill_goods_id'], 'id', 'seckill_price')['data'];
            foreach ($detailData as $key => $vo) {
                $detailData[$key]['price'] = $res['seckill_price'];
            }
        }

        // 订单基础信息
        if ($refundOrderInfo['refund_way'] == 2) {

            $total = $detailData[0]['cart_num'];
            // 订单内的全部商品都退了，则退邮费
            $postage = (($orderData['total_num'] - $orderData['refund_num']) == $total) ? $orderData['postage'] : 0;
            $info = [
                'pay_price' => $total * $detailData[0]['price'] - $detailData[0]['coupon_amount'] - $detailData[0]['vip_discount'],
                'total_num' => $total,
                'order_price' => $total * $detailData[0]['price'],
                'coupon_amount' => $detailData[0]['coupon_amount'], // 优惠券
                'vip_discount' => $detailData[0]['vip_discount'], // 会员折扣
                'pay_postage' => $postage,
                'refunded_price' => $orderData['refunded_price']
            ];
        }

        return dataReturn(0, 'success', [
            'info' => $info,
            'order' => $refundOrderInfo,
            'detail' => $detailData,
            'address' => getConfByType('shop_refund')
        ]);
    }

    /**
     * 获取售后订单
     * @param $param
     * @param $userId
     * @return array
     */
    public function getAfterOrder($param, $userId)
    {
        $limit = $param['limit'];
        $status = $param['status'];

        $where = [];
        if (!empty($status)) {
            $where[] = ['status', 'in', $status];
        }

        $refundPass = config('shop.refund_pass');

        $orderRefundModel = new OrderRefund();
        $orderDetailModel = new OrderDetail();
        $orderList = $orderRefundModel->where($where)->where('user_id', $userId)->order('id desc')->paginate($limit)
            ->each(function ($item) use ($refundPass, $orderDetailModel) {
                $item->refund_txt = $refundPass[$item->status] ?? '';
                $item->detail = json_decode($orderDetailModel->getAllList([
                    ['id', 'in', $item->order_detail_ids]
                ])['data'], true);
            });

        return dataReturn(0, 'success', $orderList);
    }

    /**
     * 取消退款
     * @param $id
     * @param $userId
     * @return array
     */
    public function cancelRefund($id, $userId)
    {
        $refundModel = new OrderRefund();
        $orderInfo = $refundModel->findOne([
            ['id', '=', $id],
            ['user_id', '=', $userId],
            ['status', '=', 1]
        ])['data'];

        if (empty($orderInfo)) {
            return dataReturn(-1, '该订单无法取消退款');
        }

        return $refundModel->updateById([
            'status' => 4,
            'update_time' => now()
        ], $orderInfo['id']);
    }

    /**
     * 获取物流信息
     * @param $id
     * @param $userId
     * @return array
     */
    public function getExpressInfo($id, $userId)
    {
        $orderModel = new Order();
        $orderInfo = $orderModel->findOne([
            'id' => $id,
            'user_id' => $userId
        ])['data'];

        $detail = [];
        if (!empty($orderInfo)) {
            $orderExpressModel = new OrderExpress();
            $expressInfo = $orderExpressModel->findOne([
                'order_id' => $orderInfo['id'],
                'type' => 1 // TODO 退货暂时不提供路由
            ])['data'];

            $addressModel = new OrderAddress();
            if (!empty($expressInfo['express'])) {
                $detail = json_decode($expressInfo['express'], true);

                // 2小时查一次
                if ($expressInfo['end_flag'] == 2 && (time() - strtotime($expressInfo['update_time'])) > 7200) {

                    $addressInfo = $addressModel->findOne([
                        'order_id' => $orderInfo['id']
                    ])['data'];

                    $expressProvider = new ExpressProvider('aliyun');
                    $detail = $expressProvider->getStrategy()->search([
                        'id' => $expressInfo['id'],
                        'order_id' => $orderInfo['id'],
                        'no' => $orderInfo['delivery_no'] . ':' . substr($addressInfo['phone'], 7, 4),
                        'type' => $orderInfo['delivery_code']
                    ])['data'];

                    $detail = json_decode($detail, true);
                }
            } else {

                $addressInfo = $addressModel->findOne([
                    'order_id' => $orderInfo['id'],
                ])['data'];

                $expressProvider = new ExpressProvider('aliyun');
                $detail = $expressProvider->getStrategy()->search([
                    'id' => $expressInfo['id'],
                    'order_id' => $orderInfo['id'],
                    'no' => $orderInfo['delivery_no'] . ':' . substr($addressInfo['phone'], 7, 4),
                    'type' => $orderInfo['delivery_code']
                ])['data'];

                $detail = json_decode($detail, true);
            }

            $endFlag = 2;
            if ($detail['status'] == 0 && isset($detail['result']['deliverystatus'])
                && $detail['result']['deliverystatus'] >= 3) {
                $endFlag = 1;
            }

            $addressModel->updateById([
                'end_flag' => $endFlag,
                'express' => json_encode($detail),
                'update_time' => now()
            ], $expressInfo['id']);
        }

        return dataReturn(0, 'success', [
            'express_name' => $orderInfo['delivery_name'],
            'delivery_no' => $orderInfo['delivery_no'],
            'detail' => $detail
        ]);
    }

    /**
     * 处理订单收货
     * @param $orderId
     * @param $userId
     * @param $userName
     * @return array
     */
    public function doReceived($orderId, $userId, $userName)
    {
        $orderModel = new Order();
        $orderInfo = $orderModel->findOne([
            'id' => $orderId,
            'user_id' => $userId
        ])['data'];

        if (empty($orderInfo)) {
            return dataReturn(-1, '订单信息异常');
        }

        if ($orderInfo['status'] != 4) {
            return dataReturn(-2, '该订单尚未发货');
        }

        // 查询是否开启会员等级
        $vip = getConfByType('shop_user_level');
        $score = 0;
        if ($vip['user_level_open'] == 1) {
            $score = $this->dealIncUserVip($orderInfo, $vip, $userId);
        }

        $res = $orderModel->updateById([
            'status' => 6,
            'score' => $score, // 赠送积分
            'received_time' => now(),
            'update_time' => now()
        ], $orderId);
        if ($res['code'] != 0) {
            return $res;
        }

        $orderStatusModel = new OrderStatusChange();
        return $orderStatusModel->insertOne([
            'order_id' => $orderId,
            'original_status' => $orderInfo['status'],
            'new_status' => 6,
            'msg' => '订单收货',
            'operator_id' => $userId,
            'operator_name' => $userName,
            'create_time' => now()
        ]);
    }

    /**
     * 快递信息查询
     * @param $param
     * @param $userId
     * @return array
     */
    public function doRefundExpress($param, $userId)
    {
        if (empty($param['refund_express_name']) || empty($param['refund_express'])) {
            return dataReturn(-2, '快递名或快递单号不能为空');
        }

        $refundModel = new OrderRefund();
        $refundInfo = $refundModel->findOne([
            'id' => $param['id'],
            'user_id' => $userId
        ])['data'];

        if (empty($refundInfo)) {
            return dataReturn(-1, '订单信息异常');
        }

        $param['step'] = $refundInfo['step'] + 1;
        return $refundModel->updateById($param, $param['id']);
    }

    /**
     * 关闭订单
     * @param $id
     * @param $userId
     * @param $userName
     * @return array
     */
    public function closeOrder($id, $userId, $userName)
    {
        $orderModel = new \app\model\Order();
        $orderInfo = $orderModel->findOne([
            'id' => $id,
            'user_id' => $userId,
            'status' => 2
        ])['data'];

        if (empty($orderInfo)) {
            return dataReturn(-1, '订单信息异常');
        }

        $res = $orderModel->updateById([
            'status' => 8,
            'update_time' => now()
        ], $id);
        if ($res['code'] != 0) {
            return $res;
        }

        // 记录状态变更
        $orderStatusModel = new OrderStatusChange();
        return $orderStatusModel->insertOne([
            'order_id' => $id,
            'original_status' => $orderInfo['status'],
            'new_status' => 8,
            'msg' => '订单关闭',
            'operator_id' => $userId,
            'operator_name' => $userName,
            'create_time' => now()
        ]);
    }

    /**
     * 获取商品评价信息
     * @param $id
     * @param $userId
     * @return array
     */
    public function getGoodsComments($id, $userId)
    {
        $orderModel = new Order();
        $orderInfo = $orderModel->with(['detail'])->where('id', $id)->where('user_id', $userId)->find();

        if (empty($orderInfo) || $orderInfo['status'] != 6) {
            return dataReturn(-1, '该订单无法评价');
        }

        // 若已评价，则查出评价
        $comment = [];
        if ($orderInfo['user_comments'] == 2) {

            $orderCommentModel = new OrderComment();
            $comment = $orderCommentModel->findOne([
                'order_id' => $id,
                'user_id' => $userId
            ])['data'];

            if (!empty($comment['pictures'])) {
                $comment['pictures'] = json_decode($comment['pictures'], true);
            }
        }

        return dataReturn(0, 'success', [
            'info' => $orderInfo,
            'comment' => $comment
        ]);
    }

    /**
     * 评价
     * @param $param
     * @param $userId
     * @param $userName
     * @param $userAvatar
     * @return array
     */
    public function doAppraise($param, $userId, $userName, $userAvatar)
    {
        $orderModel = new Order();
        $orderInfo = $orderModel->where('id', $param['order_id'])->where('user_id', $userId)->find();

        if (empty($orderInfo)) {
            return dataReturn(-1, "该订单无法您无法评价");
        }

        if ($orderInfo['user_comments'] == 2) {
            return dataReturn(-2, "该订单您已评价");
        }

        // 查询关联的goods_id
        $orderDetailModel = new OrderDetail();
        $orderDetailInfo = $orderDetailModel->getAllList([
            'order_id' => $param['order_id']
        ], 'goods_id,goods_name,rule')['data'];

        $param['user_id'] = $userId;
        $param['user_name'] = $userName;
        $param['user_avatar'] = $userAvatar;
        $param['create_time'] = now();
        if (!empty($param['pictures'])) {
            $param['pictures'] = json_encode($param['pictures']);
        }
        $orderCommentModel = new OrderComment();

        $comments = [];
        foreach ($orderDetailInfo as $key => $vo) {
            $param['goods_id'] = $vo['goods_id'];
            $param['goods_name'] = $vo['goods_name'];
            $param['sku'] = $vo['rule'];
            $comments[$key] = $param;
        }
        $res = $orderCommentModel->insertBatch($comments);
        if ($res['code'] < 0) {
            return $res;
        }

        $res = $orderModel->updateById([
            'user_comments' => 2,
            'user_comments_time' => now()
        ], $param['order_id']);

        if ($res['code'] != 0) {
            return $res;
        }

        $res['msg'] = '评价成功';
        return $res;
    }

    /**
     * 处理用户vip等级
     * @param $orderInfo
     * @param $vip
     * @param $userId
     */
    private function dealIncUserVip($orderInfo, $vip, $userId)
    {
        $score = ceil($orderInfo['pay_price'] * $vip['give_points']);

        // 记录变更日志
        $userScoreModel = new UserBalanceLog();
        $userScoreModel->insertOne([
            'user_id' => $userId,
            'score' => $score,
            'order_id' => $orderInfo['id'],
            'order_code' => $orderInfo['order_no'],
            'remark' => '购物赠送',
            'create_time' => now()
        ]);

        $userModel = new User();
        $userInfo = $userModel->findOne([
            'id' => $userId
        ])['data'];

        // 等级梯度
        $userLevelModel = new UserLevel();
        $userLevelInfo = $userLevelModel->getAllList([], 'level,experience', 'level asc')['data'];

        // 计算此次后的等级
        $nowScore = $userInfo['score'] + $score;
        $level = 0;
        foreach ($userLevelInfo as $vo) {
            if ($nowScore > $vo['experience']) {
                $level = $vo['level'];
            }
        }

        $userModel = new User();
        if ($level > $userInfo['vip_level']) { // 如果等级增长
            $param = [
                'score' => $nowScore,
                'useful_score' => $userInfo['useful_score'] + $score,
                'vip_level' => $level
            ];
        } else {
            $param = [
                'score' => $nowScore,
                'useful_score' => $userInfo['useful_score'] + $score
            ];
        }

        $userModel->updateById($param, $userId);

        return $score;
    }
}