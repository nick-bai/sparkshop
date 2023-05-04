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

namespace addons\coupon\event;

use addons\coupon\model\Coupon;
use addons\coupon\model\CouponReceiveLog;

class Index
{
    /**
     * 优惠券折扣计算
     * @param $couponData
     * @return array
     */
    public function handle($couponData)
    {
        try {

            $param = $couponData['param'];
            $userId = $couponData['userId'];
            $goods2Price = $couponData['goods2Price'];
            $totalPrice = $couponData['totalPrice'];

            $returnCouponInfo = [
                'couponAmount' => 0,
                'type' => 0, // 券的类型 1:通用券 2:商品券
                'goods_id' => [], // 关联的商品id
            ];

            // 2:拼团订单 3:秒杀订单 4:砍价订单 不参与优惠券
            if ($param['orderType'] != 1) {
                return dataReturn(0, 'success', $returnCouponInfo);
            }

            // 校验优惠券的合法性
            $couponReceivedModel = new CouponReceiveLog();
            $myCouponInfo = $couponReceivedModel->findOne([
                'code' => $param['coupon'],
                'user_id' => $userId,
                'status' => 1
            ])['data'];

            if (empty($myCouponInfo)) {
                return dataReturn(0, 'success', $returnCouponInfo);
            }

            // 已过期
            if ($myCouponInfo['end_time'] < now()) {
                $couponReceivedModel->updateById([
                    'status' => 3,
                    'update_time' => now()
                ], $myCouponInfo['id']);

                return dataReturn(0, 'success', $returnCouponInfo);
            }

            // 查询该优惠券的具体数据
            $couponModel = new Coupon();
            $couponInfo = $couponModel->with('goods')->where('id', $myCouponInfo['coupon_id'])->find();
            if (empty($couponInfo)) {
                return dataReturn(0, 'success', $returnCouponInfo);
            }

            $returnCouponInfo['type'] = $couponInfo['join_goods'];

            $goodsMap = [];
            foreach ($couponInfo['goods'] as $vo) {
                $goodsMap[] = $vo['goods_id'];
            }
            $inputGoods = [];
            foreach ($param['goods'] as $vo) {
                $inputGoods[] = $vo['goods_id'];
            }

            // 该券是否限制商品
            $returnCouponInfo['goods_id'] = $validGoods = array_intersect($inputGoods, $goodsMap);
            if ($couponInfo['join_goods'] == 2 && !empty($couponGoods)) {
                // 如果满足商品券条件，再去看门槛是否满足
                if ($couponInfo['is_threshold'] == 1) {
                    $canUse = false;
                    foreach ($validGoods as $v) {
                        if ($goods2Price[$v] > $couponInfo['threshold_amount']) {
                            $canUse = true;
                        }
                    }

                    // 如果均不满足门槛的话
                    if (!$canUse) {
                        return dataReturn(0, 'success', $returnCouponInfo);
                    }
                }
            }

            // 是否满足使用门槛,判断金额的问题
            if ($couponInfo['is_threshold'] == 1 && ($couponInfo['threshold_amount'] > $totalPrice) ) {
                return dataReturn(0, 'success', $couponInfo);
            }

            // 开始计算优惠券扣减金额
            if ($couponInfo['type'] == 1) {
                $returnCouponInfo['couponAmount'] = $couponInfo['amount']; // 抵扣金额
            } else {
                $coupon = round($totalPrice - $totalPrice * $couponInfo['discount'], 2);
                if ($couponInfo['max_discount_amount'] > 0 && $coupon > $couponInfo['max_discount_amount']) {
                    $returnCouponInfo['couponAmount'] = $couponInfo['max_discount_amount']; // 超过最大限额，则为最大限额
                } else {
                    $returnCouponInfo['couponAmount'] = $coupon;
                }
            }

        } catch (\Exception $e) {
            return dataReturn(-1, $e->getMessage(), 0);
        }

        return dataReturn(0, 'success', $returnCouponInfo);
    }
}
