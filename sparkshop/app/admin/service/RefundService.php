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
namespace app\admin\service;

use app\model\order\Order;
use app\model\order\OrderAddress;
use app\model\order\OrderDetail;
use app\model\order\OrderPayLog;
use app\model\order\OrderRefund;
use app\model\order\OrderStatusChange;
use app\model\user\User;
use app\model\user\UserExperienceLog;
use app\model\user\UserLevel;
use app\traits\OrderTrait;
use strategy\pay\PayProvider;
use think\Exception;
use think\facade\Db;
use think\facade\Log;

class RefundService
{
    use OrderTrait;

    /**
     * 退款列表
     * @param $param
     * @return array
     * @throws \think\db\exception\DbException
     */
    public function getList($param)
    {
        $limit = $param['limit'];
        $status = $param['status'];
        $creatTime = $param['create_time'];

        $where = [];
        if (!empty($status)) {
            $where[] = ['status', '=', $status];
        }

        if (!empty($creatTime)) {
            $where[] = ['create_time', 'between', [$creatTime[0] . ' 00:00:00', $creatTime[1] . ' 23:59:59']];
        }

        $refundPass = config('shop.refund_pass');
        $refundStep = config('shop.refund_step');
        $refundGoodsStep = config('shop.refund_goods_step');

        $orderRefundModel = new OrderRefund();
        $orderDetailModel = new OrderDetail();
        $orderList = $orderRefundModel->where($where)->order('id desc')->paginate($limit)
            ->each(function ($item) use ($refundPass, $orderDetailModel, $refundStep, $refundGoodsStep) {
                $item->status_txt = $refundPass[$item->status] ?? '';
                if ($item->refund_type == 1) {
                    $item->step_txt = $refundStep[$item->step] ?? '';
                } else if ($item->refund_type == 2) {
                    $item->step_txt = $refundGoodsStep[$item->step] ?? '';
                }

                $applyRefundData = json_decode($item->apply_refund_data, true);
                $orderDetailIds = [];
                $ids2Num = [];
                foreach ($applyRefundData['order_num_data'] as $vo) {
                    $orderDetailIds[] = $vo['order_detail_id'];
                    $ids2Num[$vo['order_detail_id']] = $vo['num'];
                }

                $detailList = $orderDetailModel->getAllList([
                    ['id', 'in', $orderDetailIds]
                ])['data'];

                foreach ($detailList as $key => $vo) {
                    $detailList[$key]['apply_refund_num'] = $ids2Num[$vo['id']];
                }

                $item->detail = $detailList;
            });

        $orderList = $orderList->toArray();
        // 待审批
        $orderList['unCheck'] = $orderRefundModel->where('status', 1)->count('id');

        return dataReturn(0, 'success', $orderList);
    }

    /**
     * 获取详情
     * @param $orderId
     * @param $refundId
     * @return array
     */
    public function getDetail($orderId, $refundId)
    {
        $orderModel = new Order();
        $info = $orderModel->with(['detail', 'user', 'address'])->where('id', $orderId)->find()->toArray();

        // 退款信息
        $refundOrderModel = new OrderRefund();
        $refundOrder = $refundOrderModel->findOne([
            ['id', '=', $refundId]
        ])['data'];
        $refundOrder['refund_img'] = array_filter(explode(',', $refundOrder['refund_img']));
        $refundStep = config('shop.refund_step');
        $refundGoodsStep = config('shop.refund_goods_step');
        $refundPass = config('shop.refund_pass');
        if ($refundOrder['refund_type'] == 1) {
            $refundOrder['step_txt'] = $refundStep[$refundOrder['step']];
        } else {
            $refundOrder['step_txt'] = $refundGoodsStep[$refundOrder['step']];
        }

        $refundOrder['status_txt'] = $refundPass[$refundOrder['status']];

        return dataReturn(0, 'success', [
            'info' => $info,
            'status' => config('order.order_status'),
            'payWay' => config('order.pay_way'),
            'refund' => $refundOrder,
            'imgJson' => $refundOrder['refund_img']
        ]);
    }

    /**
     * 审核退货
     * @param $param
     * @return array
     */
    public function checkRefundGoods($param)
    {
        // 退款信息
        $refundModel = new OrderRefund();
        $refundInfo = $refundModel->findOne([
            ['id', '=', $param['id']]
        ])['data'];

        if (empty($refundInfo)) {
            return dataReturn(-1, "该退款申请不存在");
        }

        if ($refundInfo['status'] != 1) {
            return dataReturn(-2, "该订单状态异常");
        }

        // 同意退款退货
        if ($param['status'] == 1) {
            $refundModel->updateById([
                'step' => $refundInfo['step'] + 1,
                'update_time' => now()
            ], $param['id']);
        } else { // 不同意退款退货
            $refundModel->updateById([
                'status' => 3,
                'update_time' => now()
            ], $param['id']);
        }

        return dataReturn(0);
    }

    /**
     * 审核退款
     * @param $param
     * @return array
     */
    public function checkRefundMoney($param)
    {
        // 退款信息
        $refundModel = new OrderRefund();
        $refundInfo = $refundModel->findOne([
            ['id', '=', $param['id']]
        ])['data'];

        if (empty($refundInfo)) {
            return dataReturn(-1, "该退款申请不存在");
        }

        if ($refundInfo['status'] != 1) {
            return dataReturn(-2, "该退款申请状态异常无法完成退款");
        }

        // 同意退款
        if ($param['status'] == 1) {
            $res = $this->agreeRefund($param, $refundInfo, $refundModel);
        } else { // 不同意退款
            $res = $this->denyRefund($param, $refundInfo, $refundModel);
        }

        if ($res['code'] != 0) {
            return $res;
        }
        return dataReturn(0, '操作成功', $res);
    }

    /**
     * 不同意退款
     * @param $param
     * @param $refundInfo
     * @param $refundModel
     * @return array
     */
    private function denyRefund($param, $refundInfo, $refundModel)
    {
        if (empty($param['refund_reason'])) {
            return dataReturn(-1, "拒绝原因不能为空");
        }

        // 更新订单退款状态
        (new Order())->updateById([
            'refund_status' => 1,
            'update_time' => now()
        ], $refundInfo['order_id']);

        // 更新退款订单
        $res = $refundModel->updateById([
            'status' => 3,
            'unrefund_reason' => $param['refund_reason'],
            'update_time' => now()
        ], $refundInfo['id']);
        if ($res['code'] != 0) {
            return $res;
        }

        return dataReturn(0, '操作成功');
    }

    /**
     * 同意退款
     * @param $param
     * @param $refundInfo
     * @param $refundModel
     * @return array
     */
    private function agreeRefund($param, $refundInfo, $refundModel)
    {
        // 查询对应的订单信息
        $orderModel = new Order();
        $orderInfo = $orderModel->findOne([
            ['id', '=', $refundInfo['order_id']]
        ])['data'];

        $orderClose = false;
        if ($refundInfo['refund_way'] == 1) { // 整单退
            $orderClose = true;
        }

        Db::startTrans();
        try {

            // 更新退款订单
            $refundOrder = [
                'step' => $refundInfo['step'] + 1,
                'refunded_price' => $param['refund_price'], // 申请退款金额
                'refunded_time' => now(),
                'status' => 2,
                'update_time' => now()
            ];
            $res = $refundModel->updateById($refundOrder, $refundInfo['id']);
            if ($res['code'] != 0) {
                throw new Exception($res['msg']);
            }

            // 更新订单 3:已退款 4:部分退款
            $orderParam = [
                'refunded_price' => $param['refund_price'],
                'refunded_num' => $refundInfo['refund_num'],
                'pay_status' => $orderClose ? 3 : 4,
                'update_time' => now()
            ];

            // 如果订单全部关闭
            if ($orderClose) {
                $orderParam['close_time'] = now(); // 关闭时间
                $orderParam['status'] = 8; // 关闭
                // $orderParam['pay_price'] = 0;
                $this->changeStatusAndUpdateCoupon($orderInfo);
            }

            // 如果是部分退款
            if ($refundInfo['refund_way'] == 2) {
                // 开始拆单
                $res = $this->splitOrder($orderInfo, $refundInfo);
                if ($res['code'] != 0) {
                    throw new Exception($res['msg']);
                }
            } else { // 退整体
                // $orderParam['pay_price'] = $orderInfo['pay_price'] - $param['refund_price'];
                // 退积分
                if ($orderInfo['experience'] > 0) {
                    $this->calcUserVip($orderInfo, $orderInfo['experience']);
                    $orderParam['experience'] = 0; // 把赠送的积分全部清空
                }

                $res = $orderModel->updateById($orderParam, $refundInfo['order_id']);
                if ($res['code'] != 0) {
                    throw new Exception($res['msg']);
                }

                // 更新退款详情
                $orderDetailModel = new OrderDetail();
                $orderDetailList = $orderDetailModel->getAllList([
                    'order_id' => $refundInfo['order_id']
                ])['data'];
                $detailCount = count($orderDetailList);

                foreach ($orderDetailList as $key => $vo) {
                    // 仅有一个种类的商品
                    if ($detailCount == 1) {
                        $refundedPrice = $param['refund_price'];
                    } else {
                        // 如果是最后一个
                        if (($key + 1) == $detailCount) {
                            $refundedPrice = $vo['price'] * $vo['cart_num'] - $vo['coupon_amount'] - $vo['vip_discount'] + $orderInfo['pay_postage'];
                        } else {
                            $refundedPrice = $vo['price'] * $vo['cart_num'] - $vo['coupon_amount'] - $vo['vip_discount'];
                        }
                    }

                    $orderDetailModel->where('id', $vo['id'])->update([
                        'refunded_price' => $refundedPrice,
                        'refunded_num' => $vo['cart_num']
                    ]);
                }
            }

            // 记录支付记录
            $orderPayLogModel = new OrderPayLog();
            $res = $orderPayLogModel->insertOne([
                'order_id' => $refundInfo['order_id'],
                'pay_way' => $orderInfo['pay_way'],
                'pay_order_no' => $orderInfo['pay_order_no'],
                'status' => $orderClose ? 3 : 4,
                'create_time' => now()
            ]);
            if ($res['code'] != 0) {
                throw new Exception($res['msg']);
            }

            // 原路退回金额
            $payId2Way = config('pay.pay_id_type');
            $provider = new PayProvider($payId2Way[$orderInfo['pay_way']]);
            $res = $provider->getStrategy()->refund([
                'order_no' => $orderInfo['pay_order_no'],
                'refund_order_no' => $refundInfo['refund_order_no'],
                'pay_price' => $orderInfo['pay_price'],
                'refund_price' => $param['refund_price'],
                'user_id' => $orderInfo['user_id']
            ]);
            if ($res['code'] != 0) {
                throw new Exception($res['msg']);
            }

            $refundModel->updateById([
                'third_return_msg' => json_encode($res['data'])
            ], $refundInfo['id']);

            // 退还库存
            $this->giveBackSaleAndStore($refundInfo, $orderInfo);

            Db::commit();
        } catch (\Exception $e) {
            Db::rollback();
            Log::error($e);
            return dataReturn(-10, $e->getMessage() . '|' . $e->getFile() . '|' . $e->getLine());
        }

        return dataReturn(0, '操作成功', $res['data']);
    }

    /**
     * 记录订单状态并且更新优惠券状态
     * @param $orderInfo
     */
    private function changeStatusAndUpdateCoupon($orderInfo)
    {
        // 维护状态变更日志
        $orderStatusModel = new OrderStatusChange();
        $orderStatusModel->insert([
            'order_id' => $orderInfo['id'],
            'original_status' => $orderInfo['status'],
            'new_status' => 8,
            'msg' => '订单退款',
            'create_time' => now()
        ]);

        $couponInstalled = hasInstalled('coupon');
        // 如果存在消耗的优惠券，则退回优惠券
        if ($couponInstalled) {
            event('couponCancel', ['order_id' => $orderInfo['id']]);
        }
    }

    /**
     * 拆单
     * @param $orderInfo
     * @param $refundInfo
     * @return array
     */
    private function splitOrder($orderInfo, $refundInfo)
    {
        try {
            // 原订单所有的子订单数据
            $orderDetailModel = new OrderDetail();
            $detailList = $orderDetailModel->getAllList([
                'order_id' => $orderInfo['id']
            ])['data'];

            // 设置父订单（原订单）pid 为 -1,则可个关闭
            $orderModel = new Order();
            $res = $orderModel->updateById([
                'pid' => -1,
                'refunded_price' => $refundInfo['refund_price'],
                'refunded_num' => $refundInfo['refund_num'],
                'refund_status' => 3,
                'update_time' => now()
            ], $orderInfo['id']);
            if ($res['code'] < 0) {
                return $res;
            }

            // 重新生成订单
            $this->rebuildOrder($orderInfo, $detailList, $refundInfo);
        } catch (\Exception $e) {
            return dataReturn(-11, $e->getMessage());
        }

        return dataReturn(0, '操作成功');
    }

    /**
     * 重新生成订单
     * @param $orderInfo
     * @param $detailList
     * @param $refundInfo
     * @return array
     */
    private function rebuildOrder($orderInfo, $detailList, $refundInfo)
    {
        $newSubOrder = clone $orderInfo; // 退款后新的订单
        $refundSubOrder = clone $orderInfo; // 退款的订单
        $orderDetailModel = new OrderDetail();
        $orderAddressModel = new OrderAddress();
        $orderModel = new Order();
        $orderRefundModel = new OrderRefund();

        // 退款总件数
        $applyRefundData = json_decode($refundInfo['apply_refund_data'], true)['order_num_data'];
        $detailId2Data = [];
        $totalRefundNum = 0;
        foreach ($applyRefundData as $vo) {
            $totalRefundNum += $vo['num'];
            $detailId2Data[$vo['order_detail_id']] = $vo['num'];
        }

        $totalRefundOrderPrice = 0; // 累计订单金额
        $totalRefundVipDiscount = 0; // 累计会员打折金额
        $totalRefundCouponAmount = 0; // 累计优惠券优惠金额
        $newOrderDetail = []; // 新订单详情
        $refundOrderDetail = []; // 退款订单详情
        foreach ($detailList as $vo) {

            $vo->old_id = $orderInfo->id;
            $id = $vo['id'];
            unset($vo['id']);
            if (isset($detailId2Data[$id])) {

                $totalRefundOrderPrice += $vo['price'] * $detailId2Data[$id];

                // 全退了
                if ($vo['cart_num'] == $detailId2Data[$id]) {
                    $refundOrderDetail[] = $vo->toArray();
                    $totalRefundVipDiscount += $vo['vip_discount'];
                    $totalRefundCouponAmount += $vo['coupon_amount'];
                } else { // 若未全退

                    $percent = ($vo['cart_num'] - $detailId2Data[$id]) / $vo['cart_num'];
                    $refundVipDiscount = round($percent * $vo->vip_discount, 2);
                    $refundCouponAmount = round($percent * $vo->coupon_amount, 2);

                    $totalRefundVipDiscount += $refundVipDiscount;
                    $totalRefundCouponAmount += $refundCouponAmount;

                    // 退款订单详情
                    $refundData = clone $vo;
                    $refundData->cart_num = $detailId2Data[$id];
                    $refundData->coupon_amount = $refundCouponAmount;
                    $refundData->vip_discount = $refundVipDiscount;
                    $refundData->refunded_flag = 2;
                    $refundData->refunded_price = $vo->price * $detailId2Data[$id] - $refundCouponAmount - $refundVipDiscount;
                    $refundData->refunded_num = $detailId2Data[$id];
                    $refundOrderDetail[] = $refundData->toArray();

                    // 剩下的订单详情
                    $newData = clone $vo;
                    $newData->cart_num = $vo['cart_num'] - $detailId2Data[$id];
                    $newData->coupon_amount = $vo->coupon_amount - $refundCouponAmount;
                    $newData->vip_discount = $vo->vip_discount - $refundVipDiscount;
                    $newData->refunded_flag = 1;
                    $newData->refunded_price = 0;
                    $newData->refunded_num = 0;
                    $newOrderDetail[] = $newData->toArray();
                }
            } else {
                $newOrderDetail[] = $vo->toArray();
            }
        }

        // 累计支付金额
        $totalRefundPayPrice = $totalRefundOrderPrice - $totalRefundVipDiscount - $totalRefundCouponAmount;

        // 记录两笔订单
        // 退款订单
        unset($refundSubOrder['id']);
        $refundSubOrder->pid = $orderInfo->id;
        $refundSubOrder->order_no = makeOrderNo('D');
        $refundSubOrder->total_num = $totalRefundNum;
        $refundSubOrder->order_price = $totalRefundOrderPrice;
        $refundSubOrder->pay_price = $totalRefundPayPrice;
        $refundSubOrder->vip_discount = $totalRefundVipDiscount;
        $refundSubOrder->coupon_amount = $totalRefundCouponAmount;
        $refundSubOrder->postage = 0; // 不全退，不退邮费
        $refundSubOrder->pay_postage = 0;
        $refundSubOrder->refund_status = 3;
        $refundSubOrder->pay_status = 3;
        $refundSubOrder->status = 8;
        $refundSubOrder->refunded_price = $totalRefundPayPrice;
        $refundSubOrder->refunded_num = $totalRefundNum;
        $refundSubOrder->create_time = now();
        $refundOrderId = $orderModel->insertGetId($refundSubOrder->toArray());

        if (!empty($refundOrderDetail)) {
            foreach ($refundOrderDetail as $key => $vo) {
                $refundOrderDetail[$key]['order_id'] = $refundOrderId;
            }

            $orderDetailModel->insertAll($refundOrderDetail);
        }

        // 新订单
        unset($newSubOrder['id']);
        $newSubOrder->pid = $orderInfo->id;
        $newSubOrder->order_no = makeOrderNo('D');
        $newSubOrder->total_num = $orderInfo->total_num - $totalRefundNum;
        $newSubOrder->order_price = $orderInfo->order_price - $totalRefundOrderPrice;
        $newSubOrder->pay_price = $orderInfo->pay_price - $totalRefundPayPrice;
        $newSubOrder->vip_discount = $orderInfo->vip_discount - $totalRefundVipDiscount;
        $newSubOrder->coupon_amount = $orderInfo->coupon_amount - $totalRefundCouponAmount;
        $newSubOrder->refund_status = 1;
        $newSubOrder->create_time = now();
        $newOrderId = $orderModel->insertGetId($newSubOrder->toArray());

        if (!empty($newOrderDetail)) {
            foreach ($newOrderDetail as $key => $vo) {
                $newOrderDetail[$key]['order_id'] = $newOrderId;
            }

            $orderDetailModel->insertAll($newOrderDetail);
        }

        $orderAddressInfo = $orderAddressModel->find($orderInfo->id);
        // 重新绑定收货地址
        $orderAddressModel->where('order_id', $orderInfo->id)->update([
            'order_id' => $newOrderId
        ]);

        $orderAddressInfo->order_id = $refundOrderId;
        unset($orderAddressInfo->id);
        $orderAddressModel->insert($orderAddressInfo->toArray());

        // 讲原退款申请，绑定到已经退款的订单上
        $orderRefundModel->where('id', $refundInfo->id)->update([
            'order_id' => $refundOrderId
        ]);

        return dataReturn(0, '订单重建成功', $newOrderId);
    }

    /**
     * 重新计算会员等级
     * @param $orderParam
     * @param $experience
     */
    private function calcUserVip($orderParam, $experience)
    {
        // 记录变更日志
        $userExperienceModel = new UserExperienceLog();
        $userExperienceModel->insertOne([
            'user_id' => $orderParam['user_id'],
            'experience' => 0 - $orderParam['experience'],
            'order_id' => $orderParam['id'],
            'order_code' => $orderParam['order_no'],
            'remark' => '退款收回',
            'create_time' => now()
        ]);

        // 等级梯度
        $userLevelModel = new UserLevel();
        $userLevelInfo = $userLevelModel->getAllList([], 'level,experience', 'level asc')['data'];

        // 用户基础信息
        $userModel = new User();
        $userInfo = $userModel->findOne([
            'id' => $orderParam['user_id']
        ], 'experience,vip_level')['data'];

        // 计算此次后的等级
        $nowExperience = $userInfo['experience'] - $experience;
        $nowExperience = ($nowExperience < 0) ? 0 : $nowExperience;
        $level = 0;
        foreach ($userLevelInfo as $vo) {
            if ($nowExperience > $vo['experience']) {
                $level = $vo['level'];
            }
        }

        $userModel = new User();
        if ($level < $userInfo['vip_level']) { // 如果等级下降
            $param = [
                'experience' => $nowExperience,
                'vip_level' => $level
            ];
        } else {
            $param = [
                'experience' => $nowExperience
            ];
        }

        $userModel->updateById($param, $orderParam['user_id']);
    }
}