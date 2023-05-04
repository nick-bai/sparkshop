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
namespace app\index\controller;

use app\index\service\UserOrderService;
use think\facade\View;

class UserOrder extends Base
{
    public function initialize()
    {
        parent::initialize();
        pcLoginCheck();
    }

    /**
     * 取消订单
     */
    public function cancel()
    {
        $id = input('param.id');

        $userOrderService = new UserOrderService();
        $res = $userOrderService->orderCancel($id, session('home_user_id'), session('home_user_name'));
        return json($res);
    }

    /**
     * 去支付
     */
    public function goPay()
    {
        $param = input('post.');

        $userOrderService = new UserOrderService();
        $res = $userOrderService->goPay($param, session('home_user_id'));
        return json($res);
    }

    /**
     * 申请售后
     */
    public function refund()
    {
        $userOrderService = new UserOrderService();
        // 处理提交售后
        if (request()->isPost()) {

            $param = input('post.');
            unset($param['file']);

            $res = $userOrderService->doRefundOrder($param, session('home_user_id'), session('home_user_name'));
            return json($res);
        }

        $id = input('param.id');
        $type = input('param.type');

        $res = $userOrderService->buildOrderParam($id, $type, session('home_user_id'));
        if ($res['code'] != 0) {
            return build404($res);
        }

        View::assign($res['data']);

        $vipConf = getConfByType('shop_user_level');
        View::assign([
            'vipConf' => $vipConf
        ]);

        return View::fetch();
    }

    /**
     * 退款进度
     */
    public function refundDetail()
    {
        $id = input('param.id');

        $userOrderService = new UserOrderService();
        $res = $userOrderService->userRefundDetail($id, session('home_user_id'));
        if ($res['code'] != 0) {
            return build404($res);
        }

        View::assign($res['data']);

        $vipConf = getConfByType('shop_user_level');
        View::assign([
            'vipConf' => $vipConf
        ]);

        return View::fetch();
    }

    /**
     * 订单售后列表
     */
    public function afterOrder()
    {
        if (request()->isAjax()) {

            $param = input('param.');

            $userOrderService = new UserOrderService();
            $res = $userOrderService->getAfterOrder($param, session('home_user_id'));
            return json($res);
        }

        return View::fetch();
    }

    /**
     * 取消退款
     */
    public function cancelRefund()
    {
        if (request()->isAjax()) {

            $id = input('param.id');

            $userOrderService = new UserOrderService();
            $res = $userOrderService->cancelRefund($id, session('home_user_id'));
            return json($res);
        }
    }

    /**
     * 物流信息
     */
    public function express()
    {
        $id = input('param.id');

        $userOrderService = new UserOrderService();
        $res = $userOrderService->getExpressInfo($id, session('home_user_id'));

        return View::fetch($res['data']);
    }

    /**
     * 确认收货
     */
    public function received()
    {
        $orderId = input('param.id');

        $userOrderService = new UserOrderService();
        $res = $userOrderService->doReceived($orderId, session('home_user_id'), session('home_user_name'));
        if ($res['code'] == 0) {
            $res['msg'] = '操作成功';
        }

        return json($res);
    }

    /**
     * 快递信息查询
     */
    public function refundExpress()
    {
        $param = input('post.');

        $userOrderService = new UserOrderService();
        $res = $userOrderService->doRefundExpress($param, session('home_user_id'));
        if ($res['code'] == 0) {
            $res['msg'] = '操作成功';
        }

        return json($res);
    }

    /**
     * 关闭订单
     */
    public function close()
    {
        $id = input('param.id');

        $userOrderService = new UserOrderService();
        $res = $userOrderService->closeOrder($id, session('home_user_id'), session('home_user_name'));
        if ($res['code'] == 0) {
            $res['msg'] = '操作成功';
        }

        return json($res);
    }

    /**
     * 评价
     */
    public function appraise()
    {
        if (request()->isPost()) {

            $param = input('post.');
            unset($param['file']);

            $userOrderService = new UserOrderService();
            $res = $userOrderService->doAppraise($param, session('home_user_id'), session('home_user_name'), session('home_user_avatar'));
            if ($res['code'] != 0) {
                $res['msg'] = '评价成功';
            }

            return json($res);
        }

        $id = input('param.id');

        $userOrderService = new UserOrderService();
        $res = $userOrderService->getGoodsComments($id, session('home_user_id'));

        if ($res['code'] != 0) {
            return build404($res);
        }

        View::assign($res['data']);

        return View::fetch();
    }
}