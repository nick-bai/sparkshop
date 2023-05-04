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

use app\BaseController;
use app\index\service\LoginService;
use think\facade\View;

class Login extends BaseController
{
    /**
     * 登录
     */
    public function index()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $loginService = new LoginService();
            return json($loginService->doLogin($param));
        }

        return View::fetch();
    }

    /**
     * 注册
     */
    public function reg()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $loginService = new LoginService();
            return json($loginService->doReg($param));
        }

        return View::fetch();
    }

    /**
     * 退出登录
     */
    public function loginOut()
    {
        session('home_user_id', null);
        session('home_user_name', null);
        session('home_user_avatar', null);

        return redirect('/');
    }

    /**
     * 验证码
     */
    public function captcha()
    {
        View::assign([
            'phone' => input('param.phone'),
            'type' => input('param.type')
        ]);

        return View::fetch();
    }

    /**
     * 忘记密码
     */
    public function forget()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $loginService = new LoginService();
            return json($loginService->forgetPassword($param));
        }

        return View::fetch();
    }
}