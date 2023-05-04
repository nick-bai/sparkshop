<?php
// +----------------------------------------------------------------------
// | SparkShop 坚持做优秀的商城系统
// +----------------------------------------------------------------------
// | Copyright (c) 2022~2099 http://sparkshop.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://opensource.org/licenses/mit-license.php )
// +----------------------------------------------------------------------
// | Author: NickBai
// +----------------------------------------------------------------------
namespace app\index\controller;

use app\index\service\CartService;
use think\facade\View;

class Cart extends Base
{
    public function initialize()
    {
        parent::initialize();
        pcLoginCheck();
    }

    /**
     * 加入购物车
     */
    public function add()
    {
        $param = input('post.');

        $cartService = new CartService();
        $res = $cartService->addCart($param, session('home_user_id'));
        return json($res);
    }

    /**
     * 购物车详情
     */
    public function detail()
    {
        if (request()->isAjax()) {

            $limit = input('param.limit', 1);

            $cartService = new CartService();
            $res = $cartService->detail($limit, session('home_user_id'));
            return json($res);
        }

        return View::fetch();
    }

    /**
     * 移除购物车
     */
    public function remove()
    {
        $id = input('param.id');

        $cartService = new CartService();
        $res = $cartService->removeCartGoods($id, session('home_user_id'));
        return json($res);
    }
}