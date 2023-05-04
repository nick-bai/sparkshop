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

class Order extends Base
{
    /**
     * 准备下单
     */
    public function index()
    {
        $param = input('post.');

        $orderService = new OrderService();
        $param['user_id'] = $this->user['id'];
        $res = $orderService->prepareOrderParam($param);
        if ($res['code'] != 0) {
            return json($res);
        }

        $vipConf = getConfByType('shop_user_level');
        $res['data']['vipConf'] = $vipConf;

        return json($res);
    }

    /**
     * 试算
     */
    public function trail()
    {
        $orderService = new OrderService();
        $param = $orderService->doTrial(input('post.'), $this->user['id']);
        if ($param['code'] != 0) {
            return json($param);
        }

        $param['data']['vipDiscount'] = number_format($param['data']['vipDiscount'], 2);
        $param['data']['coupon'] = number_format($param['data']['coupon']['couponAmount'], 2);
        $param['data']['totalPrice'] = number_format($param['data']['totalPrice'], 2);
        $param['data']['postage'] = number_format($param['data']['postage'], 2);
        $param['data']['realPay'] = number_format($param['data']['realPay'], 2);

        return json($param);
    }

    /**
     * 创建订单
     */
    public function createOrder()
    {
        $param = input('post.');

        if (empty($param['goods'])) {
            return jsonReturn(-11, "购买商品信息错误");
        }

        if (empty($param['pay_way'])) {
            return jsonReturn(-10, "请先开启支付");
        }

        if (empty($param['address_id'])) {
            return jsonReturn(-12, "请选择收件地址");
        }

        if (!isset(request()->header()['x-csrf-token'])) {
            return jsonReturn(-13, "请求信息错误");
        }

        $param['platform'] = isset(request()->header()['x-csrf-token']) ? request()->header()['x-csrf-token'] : '';

        $orderService = new OrderService();
        $res = $orderService->createOrder($param, $this->user['id']);
        return json($res);
    }

    /**
     * 获取订单信息
     */
    public function getOrderInfo()
    {
        $orderService = new OrderService();
        return json($orderService->getOrderInfoByOrderNo(input('param.order_no')));
    }

    /**
     * 获取支付基础配置
     */
    public function getPayConf()
    {
        $orderService = new OrderService();
        return json($orderService->getPayConfig($this->user['id']));
    }
}