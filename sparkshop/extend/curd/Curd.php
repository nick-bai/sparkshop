<?php
// +----------------------------------------------------------------------
// | SparkShop 坚持做优秀的商城系统
// +----------------------------------------------------------------------
// | Copyright (c) 2011~2099 http://sparkshop.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://opensource.org/licenses/mit-license.php )
// +----------------------------------------------------------------------
// | Author: NickBai  <876337011@qq.com>
// +----------------------------------------------------------------------

namespace curd;

use app\model\system\AdminNode;
use Symfony\Component\VarExporter\VarExporter;
use think\facade\App;
use think\facade\Db;
use think\helper\Str;

class Curd
{
    public static function getAllTable()
    {
        $list = Db::query('SHOW TABLES');
        return dataReturn(0, $list);
    }

    public static function getTpl($flag)
    {
        $path = App::getRootPath() . 'extend' . DS . 'curd' . DS . 'tpl' . DS . $flag . '.tpl';
        if (!file_exists($path)) {
            return dataReturn(-1, '模板不存在');
        }

        $content = file_get_contents($path);
        return dataReturn(0, 'success', $content);
    }

    public static function makeController($param)
    {
        $controllerTplContent = self::getTpl('controller')['data'];

        $controller = ucfirst($param['name']);
        $model = ucfirst(Str::camel(str_replace(env('database.prefix'), '', $param['table'])));
        $modelLow = lcfirst($model);
        $unique = $param['fields'][$param['unique_field']];
        $uniqueField = $param['unique_field'];

        $replacedContent = str_replace([
            '<modelLow>',
            '<controller>',
            '<model>',
            '<unique>',
            '<uniqueField>'
        ], [
            $modelLow,
            $controller,
            $model,
            $unique,
            $uniqueField
        ], $controllerTplContent);

        $controllerPath = App::getAppPath() . 'controller' . DS . $controller . '.php';
        file_put_contents($controllerPath, $replacedContent);

        return dataReturn(0, 'success');
    }

    public static function makeModel($param)
    {
        $modelTplContent = self::getTpl('model')['data'];
        $model = ucfirst(Str::camel(str_replace(env('database.prefix'), '', $param['table'])));

        $replacedContent = str_replace([
            '<model>'
        ], [
            $model,
        ], $modelTplContent);

        $modelPath = App::getRootPath() . DS . 'app' . DS . 'model' . DS . $model . '.php';
        file_put_contents($modelPath, $replacedContent);

        return dataReturn(0, 'success');
    }

    public static function makeValidate($param)
    {
        $validateTplContent = self::getTpl('validate')['data'];
        $model = ucfirst(Str::camel(str_replace(env('database.prefix'), '', $param['table'])));

        $tableFields = $param['form'];
        $needFields = $param['show_form'];

        $rule = [];
        foreach ($needFields as $vo) {
            if (isset($tableFields[$vo])) {
                $rule[$vo . '|' . $tableFields[$vo]] = 'require';
            }
        }

        $ruleArr = VarExporter::export($rule);

        $replacedContent = str_replace([
            '<model>',
            '<rule>'
        ], [
            $model,
            $ruleArr
        ], $validateTplContent);

        $controllerPath = App::getAppPath() . 'validate' . DS . $model . 'Validate.php';
        file_put_contents($controllerPath, $replacedContent);

        return dataReturn(0, 'success');
    }

    public static function makeView($param)
    {
        ViewMaker::makeIndex($param);
        ViewMaker::makeAdd($param);
        ViewMaker::makeEdit($param);

        return dataReturn(0, 'success');
    }

    public static function makeNodeMenu($param)
    {
        $path = lcfirst($param['name']) . '/index';
        $indexMethod = [
            'name' => $param['method_name'],
            'path' => $path,
            'pid' => $param['pid'],
            'icon' => $param['icon'],
            'is_menu' => $param['is_menu'],
            'create_time' => now()
        ];

        $adminNodeModel = new AdminNode();

        $nodeInfo = $adminNodeModel->where('path', $path)->find();
        if (!empty($nodeInfo)) {
            $adminNodeModel->where('id', $nodeInfo['id'])->delete();
            $adminNodeModel->where('pid', $nodeInfo['id'])->delete();
        }

        $pid = $adminNodeModel->insertGetId($indexMethod);

        $methodMap[] = [
            'name' => '新增',
            'path' => lcfirst($param['name']) . '/add',
            'pid' => $pid,
            'is_menu' => 1,
            'create_time' => now()
        ];

        $methodMap[] = [
            'name' => '编辑',
            'path' => lcfirst($param['name']) . '/edit',
            'pid' => $pid,
            'is_menu' => 1,
            'create_time' => now()
        ];

        $methodMap[] = [
            'name' => '删除',
            'path' => lcfirst($param['name']) . '/del',
            'pid' => $pid,
            'is_menu' => 1,
            'create_time' => now()
        ];

        $adminNodeModel->insertAll($methodMap);

        return dataReturn(0, 'success');
    }
}