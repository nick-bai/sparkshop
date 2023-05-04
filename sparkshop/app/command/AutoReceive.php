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

use app\api\service\UserOrderService;
use app\model\order\Order;
use app\model\user\User;
use think\console\Command;
use think\console\Input;
use think\console\Output;

class AutoReceive extends Command
{
    protected function configure()
    {
        $this->setName('autoReceive')
            ->setDescription('SparkShop商城自动收货');
    }

    protected function execute(Input $input, Output $output)
    {
        $orderModel =  new Order();
        $orderNum = $orderModel->where('status', 4)->count('id');

        $systemConfig = getConfByType('shop_base');
        $autoReceiveDay = $systemConfig['auto_receive_time'] ?: 7;

        $limit = 1000;
        $page = 1;
        $pageSize = ceil($orderNum / $limit);

        $userModel = new User();
        $userOrderService = new UserOrderService();

        for ($i = 0; $i < $pageSize; $i++) {
            $offset = ($page - 1) * $limit;

            $orderList = $orderModel->field('id,user_id,delivery_time')->where('status', 4)->limit($offset, $limit)->select()->toArray();
            foreach ($orderList as $vo) {

                $overTime = date('Y-m-d H:i:s', strtotime($vo['delivery_time']) + $autoReceiveDay * 86400);
                if ($overTime < now()) {
                    $userInfo = $userModel->findOne(['id' => $vo['user_id']], 'nickname')['data'];
                    $userOrderService->doReceived($vo['id'], $vo['user_id'], $userInfo['nickname']);
                }
            }

            $page += 1;
        }
    }
}