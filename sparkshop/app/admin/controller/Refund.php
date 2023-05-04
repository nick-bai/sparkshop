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
namespace app\admin\controller;

use app\admin\service\RefundService;
use think\facade\View;

class Refund extends Base
{
    /**
     * 退款列表
     */
    public function index()
    {
        if (request()->isAjax()) {

            $refundService = new RefundService();
            $res = $refundService->getList(input('param.'));
            return json($res);
        }

        return View::fetch();
    }

    /**
     * 订单详情
     */
    public function detail()
    {
        $orderId = input('param.id');
        $refundId = input('param.refund');

        $refundService = new RefundService();
        $res = $refundService->getDetail($orderId, $refundId);
        return json($res);
    }

    /**
     * 退货审核
     */
    public function checkRefundGoods()
    {
        $param = input('post.');

        $refundService = new RefundService();
        $refundService->checkRefundGoods($param);
        return jsonReturn(0, '操作成功');
    }

    /**
     * 退款审核
     */
    public function checkRefundMoney()
    {
        $param = input('post.');

        $refundService = new RefundService();
        $res = $refundService->checkRefundMoney($param);
        return json($res);
    }
}