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

use app\admin\service\PluginService;
use app\BaseController;
use think\facade\View;

class Plugin extends BaseController
{
    public function initialize()
    {
        $config = config('shop');

        View::assign([
            'title' => $config['title'],
            'is_debug' => $config['is_open_debug']
        ]);
    }

    /**
     * 应用中心
     */
    public function index()
    {
        if (request()->isAjax()) {

            $param = input('param.');

            $pluginService = new PluginService();
            return json($pluginService->getAppList($param));
        }

        return View::fetch();
    }

    /**
     * 创建应用
     */
    public function create()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $pluginService = new PluginService();
            return json($pluginService->createPlugin($param));
        }
    }

    /**
     * 卸载插件
     */
    public function uninstall()
    {
        $id = input('param.id');

        $pluginService = new PluginService();
        return json($pluginService->uninstallPlugin($id));
    }

    /**
     * 安装插件
     */
    public function install()
    {
        $id = input('param.id');

        $pluginService = new PluginService();
        return json($pluginService->installPlugin($id));
    }

    /**
     * 删除插件
     */
    public function del()
    {
        $id = input('param.id');

        $pluginService = new PluginService();
        return json($pluginService->deletePlugin($id));
    }

    /**
     * 上传插件
     */
    public function import()
    {
        $param = input('post.');

        $pluginService = new PluginService();
        return json($pluginService->updateOrInstall($param));
    }

    /**
     * 打包
     */
    public function pack()
    {
        $pluginName = input('param.name');

        $pluginService = new PluginService();
        return json($pluginService->doPack($pluginName));
    }

    /**
     * 制作升级包
     */
    public function update()
    {
        $param = input('post.');
        $pluginService = new PluginService();

        return json($pluginService->makeUpdateZip($param));
    }
}