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

class RefundSeckillStock
{
    /**
     *  返还秒杀库存
     * @param $param
     * @return bool
     */
    public function handle($param)
    {
        $applyRefundData = json_decode($param['apply_refund_data'], true)['order_num_data'];

        $detailId2Num = [];
        foreach ($applyRefundData as $vo) {
            $detailId2Num[$vo['order_detail_id']] = $vo['num'];
        }

        $orderDetail = (new OrderDetail())->findOne([
            'order_id' => $param['order_id']
        ], 'rule,id')['data'];

        $seckillInfo = (new SeckillOrder())->findOne([
            'order_id' => $param['order_id']
        ], 'seckill_id')['data'];

        $orderInfo = [
            'seckill_id' => $seckillInfo['seckill_id'],
            'sku' => $orderDetail['rule'],
            'num' => $detailId2Num[$orderDetail['id']]
        ];

        return (new OrderService())->refundStockAndSales($orderInfo);
    }
}