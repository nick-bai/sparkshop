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

use app\api\service\UserService;

class User extends Base
{
    /**
     * 获取用户中心首页数据
     */
    public function index()
    {
        $userService = new UserService();
        return json($userService->getMyBaseInfo($this->user['id']));
    }

    /**
     * 获取用户基础数据
     */
    public function info()
    {
        $userService = new UserService();
        return json($userService->getUserInfo($this->user['id']));
    }

    /**
     * 修改用户信息
     */
    public function update()
    {
        $param = input('post.');

        $userService = new UserService();
        return json($userService->updateInfo($param));
    }

    /**
     * 修改绑定手机号
     */
    public function changePhone()
    {
        $param = input('post.');
        $param['user_id'] = $this->user['id'];

        $userService = new UserService();
        return json($userService->changePhone($param));
    }

    /**
     * 修改密码
     */
    public function changePassword()
    {
        $param = input('post.');
        $param['user_id'] = $this->user['id'];

        $userService = new UserService();
        return json($userService->changePassword($param));
    }
}