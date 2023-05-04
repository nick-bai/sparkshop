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

namespace addons\seckill\controller\api;

use addons\seckill\service\OrderService;
use addons\seckill\service\SeckillService;
use app\api\controller\Base;

class Index extends Base
{
    /**
     * 秒杀商品列表
     */
    public function index()
    {
        $param = input('param.');

        $seckillService = new SeckillService();
        return json($seckillService->getSeckillList($param));
    }

    /**
     * 秒杀商品详情
     */
    public function detail()
    {
        $seckillId = input('param.seckill_id');

        $seckillService = new SeckillService();
        return json($seckillService->seckillDetail($seckillId));
    }

    /**
     * 秒杀订单商品信息
     */
    public function goodsInfo()
    {
        $param = input('post.');

        $orderService = new OrderService();
        return json($orderService->seckillGoodsInfo($param));
    }

    /**
     * 订单试算
     */
    public function trail()
    {
        $param = input('post.');

        $orderService = new OrderService();
        return json($orderService->trail($param));
    }

    /**
     * 创建订单
     */
    public function createOrder()
    {
        $param = input('post.');
        $param['platform'] = isset(request()->header()['x-csrf-token']) ? request()->header()['x-csrf-token'] : '';

        $orderService = new OrderService();
        return json($orderService->createorder($param));
    }
}