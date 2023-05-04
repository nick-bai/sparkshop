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

namespace app\admin\service;

use app\admin\validate\PluginValidate;
use app\model\system\AdminNode;
use app\model\system\Plugins;
use think\exception\ValidateException;
use think\facade\App;
use utils\SparkTools;

class PluginService
{
    /**
     * 获取所有的插件
     * @param $param
     * @return array
     */
    public function getAppList($param)
    {
        $where = [];
        if (!empty($param['title'])) {
            $where[] = ['title', 'like', '%' . $param['title'] . '%'];
        }

        if (!empty($param['status'])) {
            $where[] = ['status', '=', $param['status']];
        }

        $pluginsModel = new Plugins();
        $list = $pluginsModel->getPageList($param['limit'], $where);

        return pageReturn($list);
    }

    /**
     * 创建插件
     * @param $param
     * @return array
     */
    public function createPlugin($param)
    {
        try {
            validate(PluginValidate::class)->check($param);
        } catch (ValidateException $e) {
            return dataReturn(-1, $e->getError());
        }

        $pluginsName = $param['name'];

        // 检测插件名称是否存在
        $pluginsModel = new Plugins();
        $has = $pluginsModel->findOne(['name' => $pluginsName], 'id')['data'];
        if (!empty($has)) {
            return dataReturn(-2, '该插件名已经存在，请换一个！');
        }

        // 写入数据库
        $param['create_time'] = now();
        $param['status'] = 2; // 已安装
        $pluginsModel->insertOne($param);

        $module = App::getRootPath() . 'addons' . DS . $pluginsName;
        if (is_dir($module)) {
            return dataReturn(-3, '该插件目录已经存在，请换一个！');
        }

        mkdir($module, 0755, true);

        // controller
        $controllerFilePath = $module . DS . 'controller' . DS . 'admin' . DS . 'Index.php';
        $content = file_get_contents(App::getRootPath() . 'extend' . DS . 'addonsTpl' . DS . 'controller.tpl');
        $content = str_replace('<<pluginName>>', $pluginsName, $content);
        $content = str_replace('<<moduleName>>', 'admin', $content);
        mkdir($module . DS . 'controller' . DS . 'admin', 0755, true);
        file_put_contents($controllerFilePath, $content);

        $controllerFilePath = $module . DS . 'controller' . DS . 'api' . DS . 'Index.php';
        $content = file_get_contents(App::getRootPath() . 'extend' . DS . 'addonsTpl' . DS . 'apiController.tpl');
        $content = str_replace('<<pluginName>>', $pluginsName, $content);
        $content = str_replace('<<moduleName>>', 'api', $content);
        mkdir($module . DS . 'controller' . DS . 'api', 0755, true);
        file_put_contents($controllerFilePath, $content);

        // event
        mkdir($module . DS . 'event', 0755, true);

        // model
        mkdir($module . DS . 'model', 0755, true);

        // service
        mkdir($module . DS . 'service', 0755, true);

        // validate
        mkdir($module . DS . 'validate', 0755, true);

        // 数据库脚本文件
        mkdir($module . DS . 'data', 0755, true);
        file_put_contents($module . DS . 'data/install.sql', '');
        file_put_contents($module . DS . 'data/uninstall.sql', '');
        file_put_contents($module . DS . 'data/update.sql', '');

        // view
        $viewFilePath = $module . DS . 'view' . DS . 'admin' . DS . 'index' . DS . 'index.html';
        $content = file_get_contents(App::getRootPath() . 'extend' . DS . 'addonsTpl' . DS . 'view.tpl');
        mkdir($module . DS . 'view' . DS . 'admin' . DS . 'index', 0755, true);
        file_put_contents($viewFilePath, $content);

        // plugin
        $content = file_get_contents(App::getRootPath() . 'extend' . DS . 'addonsTpl' . DS . 'plugin.tpl');
        $content = str_replace('<<pluginName>>', $pluginsName, $content);
        $content = str_replace('<<title>>', $param['title'], $content);
        $content = str_replace('<<description>>', $param['description'], $content);
        $content = str_replace('<<author>>', $param['author'], $content);
        $content = str_replace('<<home_page>>', $param['home_page'], $content);
        $content = str_replace('<<version>>', $param['version'], $content);
        file_put_contents($module . DS . 'Plugin.php', $content);

        return dataReturn(0, '创建成功');
    }

    /**
     * 卸载插件
     * @param $id
     * @return array
     */
    public function uninstallPlugin($id)
    {
        $pluginsModel = new Plugins();
        $pluginInfo = $pluginsModel->findOne(['id' => $id])['data'];
        if (empty($pluginInfo)) {
            return dataReturn(-2, '插件不存在');
        }

        // 卸载插件
        $res = $pluginsModel->updateById([
            'status' => 1,
            'update_time' => now()
        ], $id);
        if ($res['code'] != 0) {
            return $pluginInfo;
        }

        // 卸载菜单
        return (new AdminNode())->updateByWehere([
            'status' => 2, // 禁用
            'update_time' => now()
        ], ['type' => $pluginInfo['name']]);
    }

    /**
     * 安装插件
     * @param $id
     * @return array
     */
    public function installPlugin($id)
    {
        $pluginsModel = new Plugins();
        $pluginInfo = $pluginsModel->findOne(['id' => $id])['data'];
        if (empty($pluginInfo)) {
            return dataReturn(-2, '插件不存在');
        }

        // 安装插件
        $res = $pluginsModel->updateById([
            'status' => 2,
            'update_time' => now()
        ], $id);
        if ($res['code'] != 0) {
            return $pluginInfo;
        }

        // 菜单未安装过，则执行安装脚本
        $nodeModel = new AdminNode();
        $hasMenu = $nodeModel->findOne(['type' => $pluginInfo['name']])['data'];
        if (empty($hasMenu)) {
            // 安装菜单
            $class = 'addons\\' . $pluginInfo['name'] . '\Plugin';
            $methods = (array)get_class_methods($class);

            foreach ($methods as $vo) {
                if ($vo == 'install') {
                    $res = call_user_func([$class, 'install']);
                    if ($res['code'] != 0) {
                        return $res;
                    }
                    break;
                }
            }
        }

        return $nodeModel->updateByWehere([
            'status' => 1, // 启用
            'update_time' => now()
        ], ['type' => $pluginInfo['name']]);
    }

    /**
     * 删除插件
     * @param $id
     * @return array
     */
    public function deletePlugin($id)
    {
        $pluginsModel = new Plugins();
        $pluginInfo = $pluginsModel->findOne(['id' => $id])['data'];
        if (empty($pluginInfo)) {
            return dataReturn(-2, '插件不存在');
        }

        $class = 'addons\\' . $pluginInfo['name'] . '\Plugin';
        $methods = (array)get_class_methods($class);

        foreach ($methods as $vo) {
            if ($vo == 'uninstall') {
                $res = call_user_func([$class, 'uninstall']);
                if ($res['code'] != 0) {
                    return $res;
                }
                break;
            }
        }

        // 删除安装项
        $res = $pluginsModel->delById($id);
        if ($res['code'] != 0) {
            return $res;
        }

        // 删除菜单
        $adminNodeModel = new AdminNode();
        $res = $adminNodeModel->delByWhere([
            'type' => $pluginInfo['name']
        ]);
        if ($res['code'] != 0) {
            return $res;
        }

        // 删除目录
        delDir(App::getRootPath() . 'addons' . DS . $pluginInfo['name']);

        return dataReturn(0, '删除成功');
    }

    /**
     * 插件打包
     * @param $name
     * @return array
     */
    public function doPack($name)
    {
        $dir = App::getRootPath() . 'addons' . DS . $name;
        if (!is_dir($dir)) {
            return dataReturn(-1, '插件不存在');
        }

        try {
            SparkTools::dirZip($name . '.zip', $dir, root_path() . 'addons' . DS);
        } catch (\Exception $e) {
            return dataReturn(-2, '插件打包错误:' . $e->getMessage());
        }

        return dataReturn(0, '打包成功');
    }

    /**
     * 打包升级包
     * @param $param
     * @return array
     */
    public function makeUpdateZip($param)
    {
        if (empty($param['version'])) {
            return dataReturn(-1, '版本号不能为空');
        }

        $baseDir = App::getRootPath() . 'addons' . DS . $param['name'];
        $updateFileMap = explode("\n", $param['files']);
        foreach ($updateFileMap as $vo) {

            mk_dir('./update/' . $param['name'] . DS . dirname($vo));
            copy($baseDir . DS . $vo, './update/' . $param['name'] . DS . $vo);
        }

        // 复制 update.sql
        if (!is_dir('./update/' . $param['name'] . DS . 'data')) {
            mkdir('./update/' . $param['name'] . DS . 'data');
        }
        copy($baseDir . DS . 'data' . DS . 'update.sql', './update' . DS . $param['name'] . DS . 'data' . DS . 'update.sql');

        // 复制 Plugin.php
        copy($baseDir . DS . 'Plugin.php', './update' . DS . $param['name'] . DS . 'Plugin.php');

        // 压缩成zip
        try {
            $fileName = $param['name'] . '_update_' . $param['version'] . '.zip';
            $updateDir = App::getRootPath() . 'public' . DS . 'update' . DS . $param['name'];
            SparkTools::dirZip($fileName, $updateDir, root_path() . 'public' . DS . 'update' . DS);

            // 删除临时文件
            delDir($updateDir);
        } catch (\Exception $e) {
            return dataReturn(-3, '插件打包错误:' . $e->getMessage() . '|' . $e->getLine());
        }

        return dataReturn(0, '打包成功');
    }

    /**
     * 获取目录信息
     * @param $name
     * @param $dir
     * @return array
     */
    public function getDirInfo($name, $dir)
    {
        if (empty($dir)) {
            $dir = App::getRootPath() . 'addons' . DS . $name;
        }

        if (!is_dir($dir)) {
            return dataReturn(-1, '目录不存在');
        }

        $files = [];
        $fileMap = scandir($dir);
        foreach ($fileMap as $vo) {
            if ($vo == '.' || $vo == '..') {
                continue;
            }

            $path = $dir . DS . $vo;
            if (is_dir($path)) {
                $files[] = [
                    'type' => 'dir',
                    'name' => $vo,
                    'path' => $path
                ];
            } else {
                $files[] = [
                    'type' => 'file',
                    'name' => $vo,
                    'path' => $path
                ];
            }
        }

        return dataReturn(0, 'success', $files);
    }

    /**
     * 安装或者升级更新包
     * @param $param
     * @return array
     */
    public function updateOrInstall($param)
    {
        $flag = unzip($param['package_url'], App::getRootPath() . 'addons');
        if (!$flag) {
            return dataReturn(-1, '安装失败');
        }

        $res = ($param['package_type'] == 1) ? $this->dealInstall($param) : $this->dealUpdate($param);
        if ($res['code'] != 0) {
            return $res;
        }

        return dataReturn(0, '安装成功');
    }

    /**
     * 处理安装插件
     * @param $param
     * @return array
     */
    protected function dealInstall($param)
    {
        $pluginsModel = new Plugins();
        $pluginInfo = $pluginsModel->findOne(['name' => $param['name']])['data'];
        if (!empty($pluginInfo)) {
            return dataReturn(-2, '插件已经存在');
        }

        $class = 'addons\\' . $param['name'] . '\Plugin';
        $methods = (array)get_class_methods($class);

        // 写入安装库
        foreach ($methods as $vo) {
            if ($vo == 'getInfo') { // 安装数据
                $installParam = call_user_func([$class, 'getInfo']);
                $installParam['create_time'] = now();
                $installParam['status'] = 1; // 待安装

                $pluginsModel->insertOne($installParam);
                break;
            }
        }

        return dataReturn(0);
    }

    /**
     * 处理更新包
     * @param $param
     * @return array|mixed
     */
    protected function dealUpdate($param)
    {
        $packageInfo = explode('_update_', $param['name']);
        $name = $packageInfo[0];

        $pluginsModel = new Plugins();
        $pluginInfo = $pluginsModel->findOne(['name' => $name])['data'];
        if (empty($pluginInfo)) {
            return dataReturn(-2, '插件不存在');
        }
        $pluginsModel->updateById(['version' => $packageInfo[1]], $pluginInfo['id']);

        $class = 'addons\\' . $name . '\Plugin';
        $methods = (array)get_class_methods($class);

        foreach ($methods as $vo) {
            if ($vo == 'update') { // 安装数据
                $res = call_user_func([$class, 'update']);
                if ($res['code'] != 0) {
                    return $res;
                }
                break;
            }
        }

        return dataReturn(0);
    }
}