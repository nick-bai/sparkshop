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
namespace app\command;

use app\model\BaseModel;
use app\model\order\Order;
use app\model\order\OrderOverdue;
use app\model\user\UserBalanceRecharge;
use think\console\Command;
use think\console\Input;
use think\console\Output;

class OrderTimer extends Command
{
    protected function configure()
    {
        $this->setName('orderTimer')
            ->setDescription('SparkShop商城各种订单超时定时器');
    }

    protected function execute(Input $input, Output $output)
    {
        $overTimeOrderModel = new OrderOverdue();
        $overTimeOrderList = $overTimeOrderModel->field('order_id,type')->where([
            ['overdue_time', '<', now()]
        ])->select();
        // 日志标记
        echo $overTimeOrderModel->getLastSql() . PHP_EOL;

        if (!empty($overTimeOrderList)) {
            $orderModel = new Order();
            $balanceRechargeModel = new UserBalanceRecharge();
            foreach ($overTimeOrderList as $vo) {

                // 移除快检表的数据
                $overTimeOrderModel->delByWhere(['order_id' => $vo['order_id'], 'type' => $vo['type']]);
                switch ($vo['type']) {
                    case 1:
                        $this->dealOrder($vo, $orderModel);
                        break;
                    case 2:
                        $this->dealGroupBuyOrder($vo);
                        break;
                    case 3:
                        $this->dealSeckillOrder($vo, $orderModel);
                        break;
                    case 4:
                        $this->dealBargaining($vo);
                        break;
                    case 5:
                        $this->dealBalanceOrder($vo, $balanceRechargeModel);
                        break;
                }
            }
        }
    }

    /**
     * 处理普通订单
     * @param $orderInfo
     * @param Order $orderModel
     * @return array
     */
    protected function dealOrder($orderInfo, Order $orderModel)
    {
        return $orderModel->updateById([
            'status' => 8, // 已关闭
            'close_time' => now()
        ], $orderInfo['order_id']);
    }

    /**
     * 处理团购订单 TODO 待更新
     * @param $orderInfo
     * @return array
     */
    protected function dealGroupBuyOrder($orderInfo)
    {
        return dataReturn(0);
    }

    /**
     * 处理秒杀订单
     * @param $orderInfo
     * @param Order $orderModel
     * @return array
     */
    protected function dealSeckillOrder($orderInfo, Order $orderModel)
    {
        return $orderModel->updateById([
            'status' => 8, // 已关闭
            'close_time' => now()
        ], $orderInfo['order_id']);
    }

    /**
     * 处理砍价订单 TODO 待更新
     * @param $orderInfo
     * @return array
     */
    protected function dealBargaining($orderInfo)
    {
        return dataReturn(0);
    }

    /**
     * 处理余额充值订单
     * @param $orderInfo
     * @param UserBalanceRecharge $balanceRechargeModel
     * @return array
     */
    protected function dealBalanceOrder($orderInfo, UserBalanceRecharge $balanceRechargeModel)
    {
        return $balanceRechargeModel->updateById([
            'status' => 4
        ], $orderInfo['order_id']);
    }
}