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

use app\admin\service\MenuService;
use app\admin\service\RoleService;
use think\facade\View;

class Role extends Base
{
    /**
     * 获取列表
     */
    public function index()
    {
        if (request()->isAjax()) {

            $roleService = new RoleService();
            $res = $roleService->getList(input('param.'));
            return json($res);
        }

        return View::fetch();
    }

    /**
     * 添加
     */
    public function add()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $roleService = new RoleService();
            $res = $roleService->addRole($param);
            return json($res);
        }

        return jsonReturn(0, 'success', (new MenuService())->getNodeTree());
    }

    /**
     * 编辑
     */
    public function edit()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $roleService = new RoleService();
            $res = $roleService->editRole($param);
            return json($res);
        }

        return jsonReturn(0, 'success', (new MenuService())->getNodeTree());
    }

    /**
     * 删除
     */
    public function del()
    {
        $id = input('param.id');

        $roleService = new RoleService();
        $res = $roleService->delRole($id);
        return json($res);
    }
}
