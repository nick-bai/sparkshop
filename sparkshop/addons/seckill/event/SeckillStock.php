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

namespace addons\seckill\event;

use addons\seckill\model\SeckillOrder;
use addons\seckill\service\OrderService;
use app\model\order\OrderDetail;

class SeckillStock
{
    /**
     *  扣除秒杀库存
     * @param $param
     * @return bool
     */
    public function handle($param)
    {
        $orderDetail = (new OrderDetail())->findOne([
            'order_id' => $param['id']
        ], 'rule,cart_num')['data'];

        $seckillInfo = (new SeckillOrder())->findOne([
            'order_id' => $param['id']
        ], 'seckill_id')['data'];

        $orderInfo = [
            'seckill_id' => $seckillInfo['seckill_id'],
            'sku' => $orderDetail['rule'],
            'num' => $orderDetail['cart_num']
        ];

        return (new OrderService())->dealStockAndSales($orderInfo);
    }
}