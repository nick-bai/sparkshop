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
use think\facade\View;

class Menu extends Base
{
    /**
     * 菜单列表
     */
    public function index()
    {
        if (request()->isAjax()) {

            $menuService = new MenuService();
            return json($menuService->getMenuTree());
        }

        return View::fetch();
    }

    /**
     * 新增菜单
     */
    public function add()
    {
        if (request()->isPost()) {

            $menuService = new MenuService();
            return json($menuService->addMenu(input('post.')));
        }
    }

    /**
     * 编辑菜单
     */
    public function edit()
    {
        if (request()->isPost()) {

            $menuService = new MenuService();
            return json($menuService->editMenu(input('post.')));
        }
    }

    /**
     * 删除菜单
     */
    public function del()
    {
        $menuService = new MenuService();
        return json($menuService->delMenu(input('param.id')));
    }
}