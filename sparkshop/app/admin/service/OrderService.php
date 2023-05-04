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
namespace app\admin\service;

use app\model\order\Order;
use app\model\order\OrderExpress;
use app\model\order\OrderRefund;
use app\model\order\OrderStatusChange;

class OrderService
{
    /**
     * 获取订单列表
     * @param $param
     * @return array
     */
    public function getList($param)
    {
        $where = $this->buildWhere($param);

        $orderModel = new Order();
        $config = config('order');
        $payStatus = $config['pay_status'];
        $payWay = $config['pay_way'];
        $orderStatus = $config['order_status'];
        $orderType = $config['order_type'];
        $orderIdList = [];

        $orderList = $orderModel->with(['detail', 'user'])->where($where)->order('id desc')->paginate($param['limit'])
            ->each(function ($item) use ($payStatus, $payWay, $orderStatus, $orderType, &$orderIdList) {
                $item->pay_status = $payStatus[$item->pay_status];
                $item->pay_way = $payWay[$item->pay_way];
                $item->status_txt = $orderStatus[$item->status];
                $item->refunded_price = 0;
                foreach ($item->detail as $vo) {
                    $item->refunded_price += $vo['refunded_price'];
                }
                $item->order_txt = $orderType[$item->type];
                $orderIdList[] = $item->id;
            });

        $refundModel = new OrderRefund();
        $refundList = $refundModel->getAllList([
            ['order_id', 'in', $orderIdList],
            ['status', '=', 1]
        ], 'id,order_id,user_id,status,refund_type')['data'];

        // 只取最新的状态
        $finalList = [];
        foreach ($refundList as $vo) {
            if (!isset($finalList[$vo['order_id']])) {
                $finalList[$vo['order_id']] = $vo->toArray();
            }
        }

        $orderList = $orderList->each(function ($item) use ($finalList) {
            $item->refund_status = 0;
            if (isset($finalList[$item->id])) {
                $item->refund_id = $item->id;
                $item->refund_status = $finalList[$item->id]['status'];
                $item->refund_type = $finalList[$item->id]['refund_type'];
            }
        });

        // 待发货的订单
        $orderList = $orderList->toArray();
        $orderList['unDelivery'] = $orderModel->where('pid', '=', 0)->where('status', 3)->count('id');

        return dataReturn(0, 'success', $orderList);
    }

    /**
     * 发货
     * @param $param
     * @return array
     */
    public function doExpress($param)
    {
        if ($param['type'] == 1 && (empty($param['delivery_name']) || empty($param['delivery_no']))) {
            return dataReturn(-1, "快递公司和快递单号不能为空");
        }

        if ($param['type'] == 2) {
            $param['delivery_name'] = '';
            $param['delivery_code'] = '';
            $param['delivery_no'] = '';
        }

        try {

            $orderModel = new Order();
            $orderInfo = $orderModel->findOne([
                'id' => $param['order_id'],
                'status' => 3,
                'is_del' => 1
            ], 'id')['data'];
            if (empty($orderInfo)) {
                return dataReturn(-3, "该订单异常，发货失败。");
            }

            // 是否有售后未处理
            $orderRefundModel = new OrderRefund();
            $refundInfo = $orderRefundModel->findOne([
                'status' => 1,
                'order_id' => $param['order_id']
            ], 'id')['data'];
            if (!empty($refundInfo)) {
                return dataReturn(-4, "该订单有售后未处理，请先处理售后订单！");
            }

            $orderModel->updateById([
                'delivery_name' => $param['delivery_name'],
                'delivery_code' => $param['delivery_code'],
                'delivery_no' => $param['delivery_no'],
                'status' => 4,
                'delivery_time' => now()
            ], $param['order_id']);

            // 记录订单状态
            $orderStatusModel = new OrderStatusChange();
            $orderStatusModel->insertOne([
                'order_id' => $param['order_id'],
                'original_status' => 3,
                'new_status' => 4,
                'msg' => '该订单已经发货',
                'operator_id' => session('admin_id'),
                'operator_name' => session('admin_name'),
                'create_time' => now()
            ]);

            if ($param['type'] == 1) {
                // 记录物流表
                $orderExpressModel = new OrderExpress();
                $orderExpressModel->insertOne([
                    'order_id' => $param['order_id'],
                    'type' => 1,
                    'end_flag' => 2,
                    'create_time' => now()
                ]);
            }
        } catch (\Exception $e) {
            return dataReturn(-2, $e->getMessage());
        }

        return dataReturn(0, '操作成功');
    }

    /**
     * 展示物流信息
     * @param $param
     * @return array
     */
    public function showExpress($param)
    {
        try {

            $orderModel = new Order();
            $orderInfo = $orderModel->findOne([
                'id' => $param['order_id'],
                'status' => 4,
                'is_del' => 1
            ], 'id')['data'];
            if (empty($orderInfo)) {
                return dataReturn(-3, "该订单未发货，不可操作。");
            }

            $orderModel->updateById([
                'delivery_name' => $param['delivery_name'],
                'delivery_code' => $param['delivery_code'],
                'delivery_no' => $param['delivery_no'],
                'update_time' => now()
            ], $param['order_id']);

        } catch (\Exception $e) {
            return dataReturn(-2, $e->getMessage());
        }

        return dataReturn(0, '操作成功');
    }

    /**
     * 获取详情
     * @param $orderId
     * @return array
     */
    public function showDetail($orderId)
    {
        $orderModel = new Order();
        $info = $orderModel->with(['detail', 'user', 'address'])->where('id', $orderId)->find()->toArray();

        // 商品是否有退款信息
        $refundMap = [
            'goods' => [],
            'price' => 0,
            'num' => 0
        ];
        $refundAmount = 0;

        foreach ($info['detail'] as $vo) {
            if ($vo['refunded_price'] > 0) {
                $refundMap['goods'][] = $vo;
                $refundMap['price'] = $refundAmount += $vo['refunded_price'];
                $refundMap['num'] += $vo['refunded_num'];
            }

            // 秒杀商品
            if ($info['type'] == 3) {

            }
        }

        $orderExpressModel = new OrderExpress();
        $expressInfo = $orderExpressModel->findOne([
            'order_id' => $orderId,
            'type' => 1, // TODO 退货暂时不提供物流查询
        ])['data'];

        $detail = [];
        if (!empty($expressInfo)) {
            $detail = json_decode($expressInfo['express'], true);
        }

        return dataReturn(0, 'success', [
            'info' => $info,
            'status' => config('order.order_status'),
            'payWay' => config('order.pay_way'),
            'detail' => $detail,
            'refund' => $refundMap,
            'refund_amount' => $refundAmount
        ]);
    }

    /**
     * 处理导出
     * @param $param
     * @return array
     */
    public function dealExport($param)
    {
        $where = $this->buildWhere($param);

        $orderModel = new Order();
        $payStatus = config('order.pay_status');
        $orderStatus = config('order.order_status');

        $list = $orderModel->with(['detail', 'user', 'address'])->where($where)->order('id desc')->select();

        $orderData[] = ['订单号', '收货人姓名', '收货人电话', '收货地址', '商品信息', '总价格', '实际支付', '邮费', '支付状态', '支付时间', '订单状态', '下单时间', '用户备注'];
        foreach ($list as $vo) {
            $nameStr = '';
            foreach ($vo['detail'] as $v) {
                if (!empty($v['rule'])) {
                    $nameStr .= $v['goods_name'] . '  [' . $v['cart_num'] . '件 | '. $v['rule'] . "]\r\n";
                } else {
                    $nameStr .= $v['goods_name'] . '  [' . $v['cart_num'] . "件]\r\n";
                }
            }

            $orderData[] = [
                $vo['order_no'],
                $vo['address']['user_name'],
                $vo['address']['phone'],
                $vo['address']['province'] . $vo['address']['city'] . $vo['address']['county'] . $vo['address']['detail'],
                $nameStr,
                $vo['order_price'],
                $vo['pay_price'],
                $vo['pay_postage'],
                $payStatus[$vo['pay_status']],
                $vo['pay_time'],
                $orderStatus[$vo['status']],
                $vo['create_time'],
                $vo['remark']
            ];
        }

        return dataReturn(0, 'success', $orderData);
    }

    /**
     * 完成订单
     * @param $orderId
     * @return array
     */
    public function completeOrder($orderId)
    {
        $orderModel = new Order();
        $orderInfo = $orderModel->findOne([
            ['id', '=', $orderId]
        ])['data'];

        $res = $orderModel->updateById([
            'status' => 6,
            'received_time' => now(),
            'update_time' => now()
        ], $orderId);

        if ($res['code'] != 0) {
            return $res;
        }

        // 记录日志
        $orderStatusModel = new OrderStatusChange();
        $orderStatusModel->insertOne([
            'order_id' => $orderId,
            'original_status' => $orderInfo['status'],
            'new_status' => 6,
            'msg' => '订单完成',
            'operator_id' => session('admin_id'),
            'operator_name' => session('admin_name'),
            'create_time' => now()
        ]);

        return dataReturn(0, '操作成功');
    }

    /**
     * 构建搜索条件
     * @param $param
     * @return array
     */
    private function buildWhere($param)
    {
        $where[] = ['pid', '>=', 0];
        if (!empty($param['type'])) {
            if ($param['type'] == 5) {
                $where[] = ['is_del', '=', 2];
            } else {
                $where[] = ['is_del', '=', 1];
                $where[] = ['type', '=', $param['type']];
            }
        }

        if (!empty($param['status'])) {
            $where[] = ['status', '=', $param['status']];
        }

        if (!empty($param['pay_status'])) {
            $where[] = ['pay_status', '=', $param['pay_status']];
        }

        if (!empty($param['order_no'])) {
            $where[] = ['order_no', '=', $param['order_no']];
        }

        if (!empty($param['pay_way'])) {
            $where[] = ['pay_way', '=', $param['pay_way']];
        }

        if (!empty($param['user_id'])) {
            $where[] = ['user_id', '=', $param['user_id']];
        }

        if (!empty($param['create_time'])) {
            $where[] = ['create_time', 'between', [$param['create_time'][0] . ' 00:00:00', $param['create_time'][1] . ' 23:59:59']];
        }

        return $where;
    }
}