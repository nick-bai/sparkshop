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

use app\BaseController;
use think\facade\View;

class Base extends BaseController
{
    public function initialize()
    {
        if (empty(session('admin_name'))) {
            if (request()->isAjax()) {
                exit(json_encode(dataReturn(401, "请先登录")));
            }

            header('location:' . url('login/index'));
            exit;
        }

        $config = config('shop');
        if (session('admin_id') != 1) {
           $this->checkAuth();
        }

        View::assign([
            'nickname' => session('admin_nickname'),
            'avatar' => session('admin_avatar'),
            'version' => config('version.version'),
            'title' => $config['title'],
            'is_debug' => $config['is_open_debug']
        ]);
    }

    /**
     * 权限检测
     */
    protected function checkAuth()
    {
        $controller = lcfirst(request()->controller());
        $action = request()->action();
        $checkAuth = $controller . '/' . $action;

        $authMap = json_decode(session('auth_node'), true);
        $skipAuth = config('auth.skip_auth');

        if (!isset($skipAuth[$checkAuth]) && !isset($authMap[$checkAuth])) {

            if (request()->isAjax()) {
                exit(json_encode(['code' => 403, 'data' => [], 'msg' => '您没有权限']));
            }

            exit(file_get_contents(app()->getAppPath() . 'view/default/error_tpl.html'));
        }
    }
}