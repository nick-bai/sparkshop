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

use app\model\system\AdminNode;
use think\facade\Db;
use think\facade\View;

class Curd extends Base
{
    public function index()
    {
        $dbTable = Db::query('SHOW TABLES');
        $tables = [];

        $sysTable = config('auth.sys_table');
        $prefix = env('database.prefix');
        foreach ($dbTable as $vo) {
            if (!isset($sysTable[ltrim(array_values($vo)[0], $prefix)])) {
                $tables[] = array_values($vo)[0];
            }
        }

        $adminNodeModel = new AdminNode();
        View::assign([
            'tables' => $tables,
            'menu' => $adminNodeModel->where('is_menu', 2)->select()
        ]);

        return View::fetch();
    }

    public function showTableFields()
    {
        $tableName = input('param.table_name');
        $fields = Db::table($tableName)->getFields();

        return jsonReturn(0, 'success', $fields);
    }

    public function autoMake()
    {
        $param = input('post.');

        switch ($param['flag']) {

            case 'controller':
                $res = \curd\Curd::makeController($param);
                break;
            case 'model':
                $res = \curd\Curd::makeModel($param);
                break;
            case 'validate':
                $res = \curd\Curd::makeValidate($param);
                break;
            case 'menu':
                $res = \curd\Curd::makeNodeMenu($param);
                break;
            case 'view':
                $res = \curd\Curd::makeView($param);
                break;
        }

        return json($res);
    }
}