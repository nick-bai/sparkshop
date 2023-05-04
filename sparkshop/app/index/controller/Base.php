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

namespace app\index\controller;

use app\BaseController;
use app\index\service\CartService;
use think\facade\View;

class Base extends BaseController
{
    public function initialize()
    {
        $cartService = new CartService();
        View::assign([
            'userInfo' => [
                'id' => session('home_user_id'),
                'name' => session('home_user_name'),
                'avatar' => session('home_user_avatar')
            ],
            'conf' => getConfByType('base'),
            'cartNum' => empty(session('home_user_id')) ? 0.00 : $cartService->getUserCartNum(session('home_user_id'))['data'],
            'cartAmount' => empty(session('home_user_id')) ? 0.00 : number_format($cartService->getUserCartAmount(session('home_user_id'))['data'], 2)
        ]);
    }
}