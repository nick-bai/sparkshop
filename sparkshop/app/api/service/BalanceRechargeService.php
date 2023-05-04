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

namespace app\api\service;

use app\model\order\OrderOverdue;
use app\model\user\UserBalanceRecharge;
use strategy\pay\PayProvider;
use think\facade\Db;

class BalanceRechargeService
{
    /**
     * 创建余额充值订单
     * @param $param
     * @return array
     */
    public function createOrder($param)
    {
        Db::startTrans();
        try {

            $userInfo = getJWT(getHeaderToken());

            if (empty($param['amount']) || empty($param['pay_way'])) {
                return dataReturn(-1, '支付参数异常');
            }

            if (!is_numeric($param['amount'])) {
                return dataReturn(-10, '支付金额错误');
            }

            $balanceRechargeModel = new UserBalanceRecharge();
            $orderNo = makeOrderNo('B');
            $payNo = makeOrderNo('B');
            // 创建订单
            $orderId = $balanceRechargeModel->insertGetId([
                'recharge_no' => $orderNo,
                'pay_no' => $payNo,
                'user_id' => $userInfo['id'],
                'username' => $userInfo['name'],
                'amount' => $param['amount'],
                'pay_way' => ($param['pay_way'] == 'wechat_pay') ? 1: 2,
                'status' => 1, // 待支付
                'create_time' => now()
            ]);

            $orderCancel = getConfByType('shop_base');
            if (empty($orderCancel['recharge_balance_cancel_time'])) {
                $orderCancel['recharge_balance_cancel_time'] = 1; // 默认一小时防止出错
            }

            $overDueHour = $orderCancel['recharge_balance_cancel_time'];

            // 记录订单逾期快检表
            $orderOverdueModel = new OrderOverdue();
            $orderOverdueModel->insert([
                'order_id' => $orderId,
                'type' => 5, // 余额充值订单
                'overdue_time' => date('Y-m-d H:i:s', time() + $overDueHour * 3600)
            ]);

            // 发起支付
            $config = getConfByType('base');
            $payProvider = new PayProvider($param['pay_way']);
            $payParam = [
                'out_trade_no' => $payNo,
                'total_amount' => $param['amount'],
                'subject' => '余额充值',
                'user_id' => $userInfo['id'],
                'return_url' => $config['h5_domain'] . '/#/pages/order/order'
            ];

            $platform = $param['platform'] ?? '';
            $res = $payProvider->payByPlatform($platform, $param['pay_way'], $payParam);

            Db::commit();
        } catch (\Exception $e) {
            Db::rollback();
            return dataReturn(-5, '创建订单失败', $e->getMessage());
        }

        return dataReturn(0, '创建订单成功', $res);
    }
}