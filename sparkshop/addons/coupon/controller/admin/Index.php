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

namespace addons\coupon\controller\admin;

use addons\coupon\model\Coupon;
use addons\coupon\model\CouponReceiveLog;
use addons\coupon\service\CouponService;
use app\PluginBaseController;

class Index extends PluginBaseController
{
    /**
     * 优惠券列表
     */
    public function index()
    {
        if (request()->isAjax()) {

            $couponService = new CouponService();
            $res = $couponService->getList(input('param.'));
            return json($res);
        }

        return fetch();
    }

    /**
     * 添加优惠券
     */
    public function add()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $couponService = new CouponService();
            $res = $couponService->addCoupon($param);
            return json($res);
        }

        if (request()->isAjax()) {
            return json((new CouponService())->getCouponGoodsList(input('param.id')));
        }

        return fetch();
    }

    /**
     * 作废优惠券
     */
    public function close()
    {
        $id = input('param.id');

        $couponModel = new Coupon();
        $res = $couponModel->updateById([
            'status' => 2,
            'update_time' => now()
        ], $id);

        return json($res);
    }

    /**
     * 领取记录
     */
    public function log()
    {
        if (request()->isAjax()) {

            $id = input('param.id');
            $limit = input('param.limit');

            $couponReceiveModel = new CouponReceiveLog();
            $list = $couponReceiveModel->where('coupon_id', $id)->paginate($limit);

            return jsonReturn(0, 'success', $list);
        }
    }
}