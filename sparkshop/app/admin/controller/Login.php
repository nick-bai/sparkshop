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

namespace app\admin\controller;

use app\admin\validate\LoginValidate;
use app\BaseController;
use app\model\system\AdminNode;
use app\model\system\AdminRole;
use app\model\system\AdminUser;
use think\exception\ValidateException;
use think\facade\View;
use utils\Captcha;

class Login extends BaseController
{
    public function index()
    {
        $config = config('shop');

        View::assign([
            'version' => config('version.version'),
            'title' => $config['title']
        ]);

        return View::fetch();
    }

    /**
     * 登录
     */
    public function doLogin()
    {
        $param = input('post.');

        try {
            validate(LoginValidate::class)->check($param);
        } catch (ValidateException $e) {
            return jsonReturn(-1, $e->getError());
        }

        // 验证码
        $captcha = new Captcha();
        if (!$captcha->check($param['code'])) {
            return jsonReturn(-5, '验证码错误');
        }

        $userModel = new AdminUser();
        $userInfo = $userModel->findOne([
            'name' => $param['name']
        ])['data'];

        if (empty($userInfo)) {
            return jsonReturn(-2, '用户名密码错误');
        }

        if ($userInfo['password'] != makePassword($param['password'], $userInfo['salt'])) {
            return jsonReturn(-3, '用户名密码错误');
        }

        if ($userInfo['status'] == 2) {
            return jsonReturn(-4, '您已被禁用');
        }

        $authNode = [];
        $authMenu = [];

        $adminNodeModel = new AdminNode();
        // 角色信息
        if ($userInfo['role_id'] != 1) {

            $roleModel = new AdminRole();
            $roleInfo = $roleModel->findOne([
                'id' => $userInfo['role_id']
            ])['data'];

            if ($roleInfo['status'] == 2) {
                return jsonReturn(-5, '您的账号角色被禁用');
            }

            $nodeList = $adminNodeModel->where('status', 1)
                ->whereIn('id', explode(',', $roleInfo['role_node']))->order('sort desc')->select();
            foreach ($nodeList as $vo) {
                $authNode[$vo['path']] = 1;

                if ($vo['is_menu'] == 2) {
                    $authMenu[] = [
                        'id' => $vo['id'],
                        'name' => $vo['name'],
                        'path' => $vo['path'],
                        'pid' => $vo['pid'],
                        'icon' => $vo['icon']
                    ];
                }
            }

            $authMenu = makeTree($authMenu);
        }

        $updateParam = [
            'last_login_ip' => request()->ip(),
            'last_login_time' => now(),
            'last_login_agent' => request()->header()['user-agent']
        ];

        $userModel->updateById($updateParam, $userInfo['id']);

        session('admin_id', $userInfo['id']);
        session('admin_name', $userInfo['name']);
        session('admin_nickname', $userInfo['nickname']);
        session('admin_avatar', $userInfo['avatar']);
        session('auth_menu', json_encode($authMenu));
        session('auth_node', json_encode($authNode));

        return jsonReturn(0, '登录成功');
    }

    /**
     * 退出
     */
    public function loginOut()
    {
        session('admin_id', null);
        session('admin_name', null);
        session('admin_nickname', null);
        session('admin_avatar', null);

        return redirect(request()->header()['referer']);
    }

    /**
     * 验证码
     */
    public function captcha()
    {
        $captcha = new Captcha();
        return $captcha->create();
    }
}