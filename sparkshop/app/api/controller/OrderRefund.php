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
namespace app\api\controller;

use app\api\service\OrderRefundService;
use app\api\service\UserOrderService;

class OrderRefund extends Base
{
    /**
     * 售后订单列表
     */
    public function index()
    {
        $param = input('param.');

        $orderRefundService = new OrderRefundService();
        $list = $orderRefundService->getRefundList($param);

        return json($list);
    }

    /**
     * 退款试算
     */
    public function refundTrail()
    {
        $param = input('post.');
        $param['user_id'] = $this->user['id'];

        $userOrderService = new UserOrderService();
        return json($userOrderService->refundTrail($param));
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

            $res = $userOrderService->doRefundOrder($param, $this->user);
            return json($res);
        }
    }

    /**
     * 订单详情
     */
    public function getDetail()
    {
        $refundId = input('param.refund_id');

        $orderRefundService = new OrderRefundService();
        $info = $orderRefundService->getRefundDetail($refundId, $this->user['id']);
        return json($info);
    }

    /**
     * 取消退款
     */
    public function cancelRefund()
    {
        $id = input('param.id');

        $userOrderService = new UserOrderService();
        $res = $userOrderService->cancelRefund($id, $this->user['id']);
        return json($res);
    }

    /**
     * 快递信息查询
     */
    public function refundExpress()
    {
        $param = input('post.');

        $orderRefundService = new OrderRefundService();
        $res = $orderRefundService->doRefundExpress($param, $this->user['id']);
        if ($res['code'] == 0) {
            $res['msg'] = '操作成功';
        }

        return json($res);
    }
}