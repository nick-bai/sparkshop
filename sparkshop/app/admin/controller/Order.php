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

use app\admin\service\OrderService;
use app\model\order\OrderDetail;
use app\model\order\OrderStatusChange;
use app\model\system\SetExpress;
use think\facade\Db;
use think\facade\View;

class Order extends Base
{
    /**
     * 订单列表
     */
    public function index()
    {
        if (request()->isAjax()) {

            $param = input('param.');

            $orderService = new OrderService();
            $orderList = $orderService->getList($param);
            return json($orderList);
        }

        return View::fetch();
    }

    /**
     * 发货
     */
    public function express()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $orderService = new OrderService();
            $res = $orderService->doExpress($param);
            return json($res);
        }

        $orderId = input('param.id');
        $setExpressModel = new SetExpress();
        $expressList = $setExpressModel->getAllList([
            'status' => 1
        ], 'name,code', 'id asc')['data'];

        $orderDetail = new OrderDetail();
        $orderInfo = $orderDetail->findOne([
            'order_id' => $orderId
        ], 'goods_id')['data'];

        $goodsModel = new \app\model\goods\Goods();
        $goodsInfo = $goodsModel->findOne([
            'id' => $orderInfo['goods_id']
        ], 'type')['data'];

        return jsonReturn(0, 'success', [
            'express' => $expressList,
            'order_id' => $orderId,
            'goods_type' => $goodsInfo['type']
        ]);
    }

    /**
     * 展示物流信息
     */
    public function showExpress()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $orderService = new OrderService();
            $res = $orderService->showExpress($param);
            return json($res);
        }

        $orderId = input('param.id');
        $setExpressModel = new SetExpress();
        $expressList = $setExpressModel->getAllList([
            'status' => 1
        ], 'name,code', 'id asc')['data'];

        $orderModel = new \app\model\order\Order();
        $info = $orderModel->findOne([
            'id' => $orderId
        ])['data'];

        View::assign([
            'express' => $expressList,
            'order_id' => $orderId,
            'info' => $info
        ]);

        return View::fetch();
    }

    /**
     * 订单详情
     */
    public function detail()
    {
        $orderId = input('param.id');

        $orderService = new OrderService();
        $res = $orderService->showDetail($orderId);
        return json($res);
    }

    /**
     * 支付日志
     */
    public function log()
    {
        $orderId = input('param.id');

        $orderStatusModel = new OrderStatusChange();
        $list = $orderStatusModel->getAllList([
            'order_id' => $orderId
        ]);

        return json($list);
    }

    /**
     * 删除订单
     */
    public function del()
    {
        $orderId = input('param.id');

        $orderModel = new \app\model\order\Order();
        $orderModel->where('id', $orderId)->update([
            'is_del' => 2
        ]);

        return jsonReturn(0, '删除成功');
    }

    /**
     * 统计订单
     */
    public function census()
    {
        $orderParam = [
            0 => 0,
            1 => 0,
            2 => 0,
            3 => 0,
            4 => 0,
            5 => 0
        ];

        $list = Db::name('order')->fieldRaw('type,count(*) as `total`')->where('pid', '=', 0)->where('status', 3)
            ->where('is_del', 1)->group('type')->select();

        if (!empty($list)) {
            foreach ($list as $vo) {
                $orderParam[$vo['type']] = $vo['total'];
            }
        }

        $orderParam[0] = Db::name('order')->where('pid', '=', 0)->where('status', 3)->where('is_del', 1)->count();
        $orderParam[5] = Db::name('order')->where('is_del', 2)->count();
        return jsonReturn(0, 'success', $orderParam);
    }

    /**
     * 导出订单
     */
    public function export()
    {
        $param = input('param.');

        $orderService = new OrderService();
        $res = $orderService->dealExport($param);
        return jsonReturn(0, 'success', $res['data']);
    }

    /**
     * 完成订单
     */
    public function complete()
    {
        $orderId = input('param.id');

        $orderService = new OrderService();
        $res = $orderService->completeOrder($orderId);
        return json($res);
    }
}