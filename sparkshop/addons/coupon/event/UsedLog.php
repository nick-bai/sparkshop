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

class UsedLog
{
    public function handle($param)
    {
        $couponReceivedModel = new CouponReceiveLog();
        $myCouponInfo = $couponReceivedModel->findOne([
            'code' => $param['coupon'],
            'user_id' => $param['user_id'],
            'status' => 1
        ])['data'];

        if (!empty($myCouponInfo)) {
            $couponReceivedModel->updateById([
                'order_id' => $param['order_id'],
                'status' => 2,
                'used_time' => now(),
                'update_time' => now()
            ], $myCouponInfo['id']);

            // 累计使用数量
            Db::startTrans();
            try {

                $couponModel = new Coupon();
                $couponModel->where('id', $myCouponInfo['coupon_id'])->lock(true)->find();
                $couponModel->where('id', $myCouponInfo['coupon_id'])->inc('used_num', 1)->update();
                Db::commit();
            } catch (\Exception $e) {
                Db::rollback();
            }
        }
    }
}