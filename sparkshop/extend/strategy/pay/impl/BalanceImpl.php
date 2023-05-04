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
namespace strategy\pay\impl;

use app\model\order\Order;
use app\model\order\OrderPayLog;
use app\model\order\OrderRefund;
use app\model\order\OrderStatusChange;
use app\model\user\User;
use app\model\user\UserBalanceLog;
use strategy\pay\PayInterface;
use strategy\stock\StockProvider;
use think\facade\Db;
use think\facade\Log;

class BalanceImpl implements PayInterface
{
    public function pay($param)
    {
        Db::startTrans();
        try {

            // 查询订单
            $orderModel = new Order();
            $orderInfo = $orderModel->with(['detail'])->where([
                'pay_order_no' => $param['out_trade_no'],
                'user_id' => $param['user_id'],
                'is_del' => 1,
                'status' => 2
            ])->find();

            if (empty($orderInfo)) {
                Db::commit();
                return dataReturn(-2, '订单信息异常');
            }

            $userModel = new User();
            $userInfo = $userModel->where('id', $param['user_id'])->lock(true)->find();
            if ($param['total_amount'] > $userInfo['balance']) {
                Db::commit();
                return dataReturn(-3, '您的余额不足以支付该订单');
            }

            // 1、扣减商品库存 、维护销量
            $stockProvider = new StockProvider($orderInfo['type']);
            $stockNotEnough = $stockProvider->getStrategy()->dealStockAndSales($orderInfo);
            $status = 3;
            if ($stockNotEnough) {
                $status = 9;
            }

            // 2、维护订单状态
            $orderModel->where('id', $orderInfo['id'])->update([
                'pay_status' => 2,
                'status' => $status,
                'third_code' => '',
                'return_msg' => '',
                'pay_time' => now(),
                'update_time' => now()
            ]);

            // 3、记录日志
            $payLogModel = new OrderPayLog();
            $payLogModel->where('order_id', $orderInfo['id'])->where('pay_order_no', $param['out_trade_no'])->update([
                'status' => 2,
                'update_time' => now()
            ]);

            // 4、维护状态变更日志
            $orderStatusModel = new OrderStatusChange();
            $orderStatusModel->insert([
                'order_id' => $orderInfo['id'],
                'original_status' => 2,
                'new_status' => $status,
                'msg' => '订单支付成功',
                'create_time' => now()
            ]);

            // 5、扣除自己的余额
            $userModel->where('id', $param['user_id'])->dec('balance', $param['total_amount'])->update();

            // 6、记录余额记录
            (new UserBalanceLog())->insert([
                'type' => 1,
                'user_id' => $param['user_id'],
                'balance' => 0 - $param['total_amount'],
                'order_id' => $orderInfo['id'],
                'order_no' => $orderInfo['order_no'],
                'remark' => '购买消耗',
                'create_time' => now()
            ]);

            Db::commit();
        } catch (\Exception $e) {
            Db::rollback();
            Log::error('余额支付异常: ' . $param['out_trade_no'] . PHP_EOL . $e);
            return dataReturn(-1, '系统异常');
        }

        return dataReturn(0, '支付成功');
    }

    public function web($param)
    {
        return $this->pay($param);
    }

    public function refund($param)
    {
        Db::startTrans();
        try {

            $userModel = new User();
            $userModel->where('id', $param['user_id'])->lock(true)->find();

            // 增加该用户的余额
            $userModel->where('id', $param['user_id'])->inc('balance', $param['refund_price'] )->update();

            // 写入余额记录
            $refundOrderInfo = (new OrderRefund())->where('refund_order_no', $param['refund_order_no'])->find();
            (new UserBalanceLog())->insert([
                'type' => 1,
                'user_id' => $param['user_id'],
                'balance' => $param['refund_price'],
                'order_id' => $refundOrderInfo['id'],
                'order_no' => $refundOrderInfo['order_no'],
                'remark' => '退款退回',
                'create_time' => now()
            ]);

            Db::commit();
        } catch (\Exception $e) {
            Db::rollback();
            Log::error('系统退款异常: ' . $param['refund_order_no'] . PHP_EOL . $e);
            return dataReturn(-1, $e->getMessage());
        }

        return dataReturn(0, '退款成功');
    }

    public function close($param)
    {

    }

    public function getObject()
    {

    }

    public function setNotifyUrl($url)
    {
        return $this;
    }
}