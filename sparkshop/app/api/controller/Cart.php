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

class Cart extends Base
{
    /**
     * 我的购车列表
     */
    public function list()
    {
        $limit = input('param.limit');

        $cartService = new CartService();
        $list = $cartService->detail($limit, $this->user['id']);
        return json($list);
    }

    /**
     * 添加购物车
     */
    public function add()
    {
        $param = input('post.');

        $cartService = new CartService();
        $res = $cartService->addCart($param, $this->user['id']);
        return json($res);
    }

    /**
     * 移除购物车
     */
    public function remove()
    {
        $id = input('param.id');

        $cartService = new CartService();
        $res = $cartService->removeCartGoods($id, $this->user['id']);
        return json($res);
    }

    /**
     * 清空购物车
     */
    public function clearCart()
    {
        $cartService = new CartService();
        $res = $cartService->clearCart($this->user['id']);
        return json($res);
    }
}