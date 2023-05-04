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

namespace addons\coupon\controller\api;

use addons\coupon\service\CouponReceiveService;
use addons\coupon\service\CouponService;
use app\api\controller\Base;

class UserCoupon extends Base
{
    /**
     * 获取可用的优惠券
     */
    public function getMyValid()
    {
        $param = input('post.');

        $couponReceiveService = new CouponReceiveService();
        return json($couponReceiveService->getMyCoupon($param));
    }

    /**
     * 领取优惠券
     */
    public function receive()
    {
        $param = input('post.');

        $couponReceiveService = new CouponReceiveService();
        return json($couponReceiveService->userReceive($param));
    }

    /**
     * 获取我的优惠券
     */
    public function myCoupon()
    {
        $param = input('param.');

        $couponService = new CouponService();
        return json($couponService->getMyCouponList($param));
    }
}