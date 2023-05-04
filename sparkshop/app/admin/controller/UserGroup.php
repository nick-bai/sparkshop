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

use app\admin\service\UserGroupService;
use app\model\user\UserGroup as UserGroupModel;
use think\facade\View;

class UserGroup extends Base
{
    /**
     * 获取列表
     */
    public function index()
    {
        if (request()->isAjax()) {

            $userGroupService = new UserGroupService();
            $res = $userGroupService->getList(input('param.'));
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

            $userGroupService = new UserGroupService();
            $res = $userGroupService->addUserGroup($param);
            return json($res);
        }

        return View::fetch();
    }

    /**
     * 编辑
     */
    public function edit()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $userGroupService = new UserGroupService();
            $res = $userGroupService->editUserGroup($param);
            return json($res);
        }

        $id = input('param.id');
        $userGroupModel = new UserGroupModel();
        View::assign([
            'info' => $userGroupModel->findOne([
                'id' => $id
            ])['data']
        ]);

        return View::fetch();
    }

    /**
     * 删除
     */
    public function del()
    {
        $id = input('param.id');

        $userGroupModel = new UserGroupModel();
        $info = $userGroupModel->delById($id);

        return json($info);
    }
}
