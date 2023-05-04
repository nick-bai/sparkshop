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

use app\model\order\OrderOverdue;
use app\model\user\User;
use app\model\user\UserBalanceLog;
use app\model\user\UserBalanceRecharge;
use strategy\notify\NotifyInterface;
use think\facade\Db;
use Yansongda\Pay\Log;

class BalanceNotifyImpl implements NotifyInterface
{
    public function dealOrder($data, $way)
    {
        Db::startTrans();
        try {

            // 开始校验
            $userBalanceRechargeModel = new UserBalanceRecharge();
            $orderInfo = $userBalanceRechargeModel->findOne([
                'pay_no' => $data->out_trade_no
            ])['data'];

            if (empty($orderInfo)) {
                return dataReturn(-1, '订单信息异常');
            }

            if ($orderInfo['status'] != 1) {
                return dataReturn(-2, '订单不可支付');
            }

            // 金额对比
            if ($way == 2) {
                $payAmount = $data->total_fee / 100;
                $thirdCode = $data->transaction_id;
            } else {
                $payAmount = $data->total_amount;
                $thirdCode = $data->trade_no;
            }

            if ($payAmount != $orderInfo['amount']) {
                $userBalanceRechargeModel->where('id', $orderInfo['id'])->update([
                    'status' => 3,
                    'third_no' => $thirdCode,
                    'return_msg' => json_encode($data->all()),
                    'update_time' => now()
                ]);
                Db::commit();
                return dataReturn(-3, '订单金额异常');
            }

            $userModel = new User();
            $userInfo = $userModel->where('id', $orderInfo['user_id'])->lock(true)->find();

            // 删除快检表的数据，防止过多的扫描
            $overdueModel = new OrderOverdue();
            $overdueModel->delByWhere([
                'order_id' => $orderInfo['id'],
                'type' => 5
            ]);

            // 变更订单状态
            $userBalanceRechargeModel->where('id', $orderInfo['id'])->update([
                'status' => 2,
                'third_no' => $thirdCode,
                'return_msg' => json_encode($data->all()),
                'update_time' => now()
            ]);

            // 记录积分变动记录
            (new UserBalanceLog())->insert([
                'type' => 4,
                'user_id' => $orderInfo['user_id'],
                'balance' => $orderInfo['amount'],
                'order_id' => $orderInfo['id'],
                'order_no' => $orderInfo['order_no'],
                'remark' => '余额充值',
                'create_time' => now()
            ]);

            // 增加可用余额
            $userInfo->where('id', $userInfo['id'])->inc('balance', $orderInfo['amount'])->update();

            Db::commit();
        } catch (\Exception $e) {
            Db::rollback();
            Log::error('余额充值错误: ' . $e->getMessage() . '|' . $e->getFile() . '|' . $e->getLine());
        }

        return  dataReturn(0);
    }
}