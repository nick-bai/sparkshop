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
use think\facade\Db;

class Cancel
{
    public function handle($param)
    {
        $receivedCouponModel = new CouponReceiveLog();
        $usedCoupon = $receivedCouponModel->findOne([
            'order_id' => $param['order_id'],
        ], 'id,coupon_id,end_time')['data'];

        if (!empty($usedCoupon)) {
            $receivedCouponModel->updateById([
                'order_id' => 0,
                'status' => (now() > $usedCoupon['end_time']) ? 3 : 1,
                'update_time' => now()
            ], $usedCoupon['id']);

            // 减少对应的使用
            Db::startTrans();
            try {

                $couponModel = new Coupon();
                $couponModel->where('id', $usedCoupon['coupon_id'])->lock(true)->find();
                $couponModel->where('id', $usedCoupon['coupon_id'])->dec('used_num', 1)->update();
                Db::commit();
            } catch (\Exception $e) {
                Db::rollback();
            }
        }
    }
}