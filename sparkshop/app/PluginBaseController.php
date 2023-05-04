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

namespace app;

use think\facade\View;
use think\session\driver\File;

class PluginBaseController extends BaseController
{
    public $admin;

    public function initialize()
    {
        $this->initAdmin();
        if (empty($this->admin['admin_id'])) {
            if (request()->isAjax()) {
                exit(json_encode(dataReturn(401, "请先登录")));
            }

            header('location:' . url('login/index'));
            exit;
        }

        if ($this->admin['admin_id'] != 1) {
            $this->checkAuth();
        }
    }

    /**
     * 权限检测
     */
    protected function checkAuth()
    {
        $checkAuth = request()->pathinfo();
        $authMap = json_decode($this->admin['auth_node'], true);
        $skipAuth = config('auth.skip_auth');

        if (!isset($skipAuth[$checkAuth]) && !isset($authMap[$checkAuth])) {

            if (request()->isAjax()) {
                exit(json_encode(['code' => 403, 'data' => [], 'msg' => '您没有权限']));
            }

            exit(file_get_contents(app()->getAppPath() . 'view/default/error_tpl.html'));
        }
    }

    /**
     * 初始化admin信息
     * @return bool
     */
    private function initAdmin()
    {
        // TODO redis方式的存储，后面在做
        if (request()->isAjax()) {
            $sessionConfig = include App()->getAppPath() . config('shop.backend_index') . DIRECTORY_SEPARATOR . 'config' . DIRECTORY_SEPARATOR . 'session.php';
        } else {
            $sessionConfig = include App()->getAppPath() . 'config' . DIRECTORY_SEPARATOR . 'session.php';
        }

        if ($sessionConfig['type'] == 'file') {
            if (request()->isAjax()) {
                $sessionConfig['path'] = App()->getRuntimePath() . config('shop.backend_index') . DIRECTORY_SEPARATOR . 'session' . DIRECTORY_SEPARATOR;
            } else {
                $sessionConfig['path'] = App()->getRuntimePath() . 'session' . DIRECTORY_SEPARATOR;
            }

            preg_match('/adminSession=[0-9a-z]{0,32}/', request()->header()['cookie'], $matches);
            $sessionId = str_replace($sessionConfig['name'] . '=', '', str_replace('adminSession=', '', $matches[0]));
            $content = (new File(App(), $sessionConfig))->read($sessionId);
            $content = unserialize($content);

            if (empty($content)) {
                return true;
            }

            $this->admin = $content;
            return false;
        }

        return false;
    }
}