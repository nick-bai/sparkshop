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
namespace app\api\controller;

use app\api\service\CartService;
use app\api\service\IndexService;
use app\api\service\OrderService;
use app\BaseController;

class Index extends BaseController
{
    public function initialize()
    {
        crossDomain();
    }

    /**
     * 小程序首页
     */
    public function index()
    {
        $indexService = new IndexService();
        $data = $indexService->getIndexData();
        return json($data);
    }

    /**
     * 搜索
     */
    public function search()
    {
        $indexService = new IndexService();
        $data = $indexService->search(input('post.'));
        return json($data);
    }

    /**
     * 获取营销插件的配置
     */
    public function marketingConfig()
    {
        $orderService = new OrderService();
        return json($orderService->getMarketingConfig());
    }

    /**
     * 获取购物车数量
     */
    public function cartNum()
    {
        $cartService = new CartService();
        $cartInfo = $cartService->getCartNum();
        return json($cartInfo);
    }
}