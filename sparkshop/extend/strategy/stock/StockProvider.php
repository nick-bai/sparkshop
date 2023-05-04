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

namespace strategy\stock;

use strategy\stock\impl\ComOrderStockImpl;
use strategy\stock\impl\SeckillOrderStockImpl;

class StockProvider
{
    protected $strategy;

    public function __construct($type)
    {
        // 订单类型 1:普通订单 2:拼团订单 3:秒杀订单 4:砍价订单
        switch ($type) {
            // 普通订单
            case 1:
                $this->strategy = new ComOrderStockImpl();
                break;
            // 秒杀订单
            case 3:
                $this->strategy = new SeckillOrderStockImpl();
                break;
        }
    }

    public function getStrategy()
    {
        return $this->strategy;
    }
}