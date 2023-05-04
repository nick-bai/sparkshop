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

use app\admin\service\AdminService;
use app\model\system\AdminRole;
use app\model\system\AdminUser;
use think\facade\View;

class Admin extends Base
{
    /**
     * 管理员列表
     */
    public function index()
    {
        if (request()->isAjax()) {

            $adminService = new AdminService();
            $res = $adminService->getList(input('param.'));
            return json($res);
        }

        return View::fetch();
    }

    /**
     * 添加管理员
     */
    public function add()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $adminService = new AdminService();
            $res = $adminService->addAdmin($param);
            return json($res);
        }

        $adminRoleModel = new AdminRole();
        $where[] = ['status', '=', 1];
        $where[] = ['id', '>', 1];
        return json($adminRoleModel->getAllList($where));
    }

    /**
     * 编辑管理员
     */
    public function edit()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $adminService = new AdminService();
            $res = $adminService->editAdmin($param);
            return json($res);
        }

        $adminRoleModel = new AdminRole();
        $where[] = ['status', '=', 1];
        $where[] = ['id', '>', 1];
        return json($adminRoleModel->getAllList($where));
    }

    /**
     * 删除管理员
     */
    public function del()
    {
        $id = input('param.id');

        if ($id === 1) {
            return jsonReturn(-1, '超级管理员不可以删除');
        }

        $adminUserModel = new AdminUser();
        $res = $adminUserModel->delById($id);

        return json($res);
    }
}