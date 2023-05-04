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

use addons\coupon\service\CouponService;
use app\BaseController;

class Index extends BaseController
{
    /**
     * 获取可领取的优惠券
     */
    public function getCouponList()
    {
        $param = input('param.');

        $couponService = new CouponService();
        return json($couponService->getCanReceiveList($param));
    }
}