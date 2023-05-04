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

class AutoAppraise extends Command
{
    protected function configure()
    {
        $this->setName('autoAppraise')
            ->setDescription('SparkShop商城自动评价');
    }

    protected function execute(Input $input, Output $output)
    {
        $orderModel =  new Order();
        $orderNum = $orderModel->where('status', 6)->where('user_comments', 1)->count('id');

        $systemConfig = getConfByType('shop_base');
        $autoAppraiseDay = $systemConfig['auto_goods_appraise'] ?: 3;

        $limit = 1000;
        $page = 1;
        $pageSize = ceil($orderNum / $limit);

        $userModel = new User();
        $userOrderService = new UserOrderService();

        for ($i = 0; $i < $pageSize; $i++) {
            $offset = ($page - 1) * $limit;

            $orderList = $orderModel->field('id,user_id,received_time')->with('detailSimple')->where('status', 6)
                ->where('user_comments', 1)->limit($offset, $limit)->select()->toArray();
            foreach ($orderList as $vo) {

                $overTime = date('Y-m-d H:i:s', strtotime($vo['received_time']) + $autoAppraiseDay * 86400);
                if ($overTime < now()) {
                    $userInfo = $userModel->findOne(['id' => $vo['user_id']], 'nickname,avatar')['data'];

                    foreach ($vo['detailSimple'] as $v) {
                        $userOrderService->doAppraise([
                            'content' => '自动评价',
                            'desc_match' => 5,
                            'order_detail_id' => $v['id'],
                            'order_id' => $vo['id'],
                            'pictures' => "",
                            'type' => 1
                        ], [
                            'id' => $vo['user_id'],
                            'name' => $userInfo['nickname'],
                            'avatar' => $userInfo['avatar']
                        ]);
                    }
                }
            }

            $page += 1;
        }
    }
}