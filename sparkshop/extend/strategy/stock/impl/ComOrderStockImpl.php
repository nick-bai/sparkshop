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

namespace strategy\stock\impl;

use app\model\goods\Goods;
use app\model\goods\GoodsRuleExtend;
use app\model\order\OrderDetail;
use strategy\stock\StockInterface;

class ComOrderStockImpl implements StockInterface
{
    public function dealStockAndSales($param)
    {
        $stockNotEnough = false;

        $orderDetailModel = new OrderDetail();
        $buyGoodsList = $orderDetailModel->where('order_id', $param['id'])->select();
        $goods2Num = [];
        $goods2Rule = [];
        $rule2Num = [];
        foreach ($buyGoodsList as $vo) {
            $goods2Num[$vo['goods_id']] = $vo['cart_num'];
            $goods2Rule[$vo['goods_id']][] = $vo['rule_id'];
            $rule2Num[$vo['rule_id']] = $vo['cart_num'];
        }

        $goodsRuleExtendModel = new GoodsRuleExtend();
        $goodsModel = new Goods();
        $goodsList = $goodsModel->field('id,sales,spec,stock')->whereIn('id', array_keys($goods2Num))->select();
        foreach ($goodsList as $vo) {
            // 单规格
            if ($vo['spec'] == 1) {

                if ($vo['stock'] < $goods2Num[$vo['id']]) {
                    $stockNotEnough = true;
                    break;
                } else {
                    $goodsModel->where('id', $vo['id'])->update([
                        'stock' => $vo['stock'] - $goods2Num[$vo['id']],
                        'sales' => $vo['sales'] + $goods2Num[$vo['id']],
                        'update_time' => now()
                    ]);
                }
            } else { // 多规格

                $goodsRuleList = $goodsRuleExtendModel->field('id,goods_id,stock,sales')->where('goods_id', $vo['id'])
                    ->whereIn('id', $goods2Rule[$vo['id']])->select();
                $totalSale = 0;
                foreach ($goodsRuleList as $v) {

                    $totalSale += $rule2Num[$v['id']];

                    if ($v['stock'] < $rule2Num[$v['id']]) {
                        $stockNotEnough = true;
                        break;
                    } else {
                        $goodsRuleExtendModel->where('id', $v['id'])->update([
                            'sales' => $v['sales'] + $rule2Num[$v['id']],
                            'stock' => $v['stock'] - $rule2Num[$v['id']]
                        ]);
                    }
                }

                $goodsModel->where('id', $vo['id'])->update([
                    'stock' => $vo['stock'] - $totalSale,
                    'sales' => $vo['sales'] + $totalSale,
                    'update_time' => now()
                ]);
            }
        }

        return $stockNotEnough;
    }
}