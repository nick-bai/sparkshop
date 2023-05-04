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

use app\api\service\LoginService;
use app\BaseController;

class Login extends BaseController
{
    public function initialize()
    {
        crossDomain();
    }

    /**
     * 根据用户名登录
     */
    public function loginBySms()
    {
        $param = input('post.');

        $loginService = new LoginService();
        return json($loginService->doLoginBySms($param));
    }

    /**
     * 根据账号登录
     */
    public function loginByAccount()
    {
        $param = input('post.');

        $loginService = new LoginService();
        return json($loginService->doLoginByAccount($param));
    }

    /**
     * 注册
     */
    public function reg()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $loginService = new LoginService();
            $res = $loginService->userReg($param);
            return json($res);
        }
    }

    /**
     * 根据微信登录
     */
    public function loginByWechat()
    {
        $code = input('param.code');
        $loginCode = input('param.login_code');
        $avatar = input('param.avatar', request()->domain() . '/static/admin/default/image/avatar.png');

        $loginService = new LoginService();
        $res = $loginService->loginByWechat($code, $loginCode, $avatar);
        return json($res);
    }
}