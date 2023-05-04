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

namespace strategy\notify\impl;

use app\model\order\Order;
use app\model\order\OrderOverdue;
use app\model\order\OrderPayLog;
use app\model\order\OrderStatusChange;
use strategy\notify\NotifyInterface;
use strategy\stock\StockProvider;
use think\facade\Db;
use Yansongda\Pay\Log;

class OrderNotifyImpl implements NotifyInterface
{
    public function dealOrder($data, $way)
    {
        Db::startTrans();
        try {

            // 开始校验
            $orderModel = new Order();
            $payLogModel = new OrderPayLog();
            $orderInfo = $orderModel->findOne([
                'pay_order_no' => $data->out_trade_no,
                'is_del' => 1
            ])['data'];

            if (empty($orderInfo)) {
                return dataReturn(0);
            }

            if (1 != $orderInfo['pay_status']) {
                $orderModel->where('id', $orderInfo['id'])->update([
                    'pay_status' => 6,
                    'third_code' => $data->trade_no,
                    'return_msg' => json_encode($data->all()),
                    'pay_time' => now(),
                    'update_time' => now()
                ]);

                $payLogModel->where('order_id', $orderInfo['id'])->where('pay_order_no', $data->out_trade_no)->update([
                    'status' => 6,
                    'update_time' => now()
                ]);
                return dataReturn(0);
            }

            if ($way == 2) {
                $payAmount = $data->total_fee / 100;
                $thirdCode = $data->transaction_id;
            } else {
                $payAmount = $data->total_amount;
                $thirdCode = $data->trade_no;
            }

            if ($payAmount != $orderInfo['pay_price']) {
                $orderModel->where('id', $orderInfo['id'])->update([
                    'pay_status' => 5,
                    'third_code' => $thirdCode,
                    'return_msg' => json_encode($data->all()),
                    'pay_time' => now(),
                    'update_time' => now()
                ]);

                $payLogModel->where('order_id', $orderInfo['id'])->where('pay_order_no', $data->out_trade_no)->update([
                    'status' => 5,
                    'update_time' => now()
                ]);
                return dataReturn(0);
            }

            // 扣减商品库存 、维护销量
            $stockProvider = new StockProvider($orderInfo['type']);
            $stockNotEnough = $stockProvider->getStrategy()->dealStockAndSales($orderInfo);
            $status = 3;
            if ($stockNotEnough) {
                $status = 9;
            }

            // 维护订单状态
            $orderModel->where('id', $orderInfo['id'])->update([
                'pay_status' => 2,
                'status' => $status,
                'third_code' => $thirdCode,
                'return_msg' => json_encode($data->all()),
                'pay_time' => now(),
                'update_time' => now()
            ]);

            // 记录日志
            $payLogModel->where('order_id', $orderInfo['id'])->where('pay_order_no', $data->out_trade_no)->update([
                'status' => 2,
                'update_time' => now()
            ]);

            // 维护状态变更日志
            $orderStatusModel = new OrderStatusChange();
            $orderStatusModel->insert([
                'order_id' => $orderInfo['id'],
                'original_status' => 2,
                'new_status' => $status,
                'msg' => '订单支付成功',
                'create_time' => now()
            ]);

            // 删除快检表的数据，防止过多的扫描
            $overdueModel = new OrderOverdue();
            $overdueModel->delByWhere([
                'order_id' => $orderInfo['id'],
                'type' => $orderInfo['type']
            ]);

            Db::commit();
        } catch (\Exception $e) {
            Log::error('支付回调异常：' . $e);
            Db::rollback();
        }

        return dataReturn(0);
    }
}