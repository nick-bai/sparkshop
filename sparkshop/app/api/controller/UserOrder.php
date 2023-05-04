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

use app\api\service\OrderService;
use app\api\service\UserOrderService;

class UserOrder extends Base
{
    /**
     * 用户订单
     */
    public function index()
    {
        $param = input('param.');

        $orderService = new OrderService();
        $res = $orderService->getUserOrderList($param, $this->user['id']);
        return json($res);
    }

    /**
     * 订单信息
     */
    public function detail()
    {
        $orderId = input('param.id');

        $orderService = new OrderService();
        $res = $orderService->getOrderDetail($orderId, $this->user['id']);
        return json($res);
    }

    /**
     * 取消订单
     */
    public function cancel()
    {
        $orderId = input('param.id');

        $orderService = new UserOrderService();
        $res = $orderService->orderCancel($orderId, $this->user['id'], $this->user['name']);
        return json($res);
    }

    /**
     * 去支付
     */
    public function goPay()
    {
        $param = input('post.');
        $param['platform'] = isset(request()->header()['x-csrf-token']) ? request()->header()['x-csrf-token'] : '';

        $userOrderService = new UserOrderService();
        $res = $userOrderService->goPay($param, $this->user['id']);
        return json($res);
    }

    /**
     * 确认收货
     */
    public function received()
    {
        $orderId = input('param.id');

        $userOrderService = new UserOrderService();
        $res = $userOrderService->doReceived($orderId, $this->user['id'], $this->user['name']);
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

            $userOrderService = new UserOrderService();
            return json($userOrderService->doAppraise(input('post.'), $this->user));
        }

        $orderId = input('param.order_id');
        $orderDetailId = input('param.order_detail_id');

        $userOrderService = new UserOrderService();
        $res = $userOrderService->getGoodsComments($orderId, $orderDetailId, $this->user['id']);
        return json($res);
    }

    /**
     * 物流信息
     */
    public function express()
    {
        $id = input('param.id');

        $userOrderService = new UserOrderService();
        $res = $userOrderService->getExpressInfo($id, $this->user['id']);
        return json($res);
    }
}