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

use app\admin\service\UserLevelService;
use app\model\user\UserLevel as UserLevelModel;
use think\facade\View;

class UserLevel extends Base
{
    /**
     * 获取列表
     */
    public function index()
    {
        if (request()->isAjax()) {

            $userLevelService = new UserLevelService();
            $res = $userLevelService->getList(input('param.'));
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

            $userLevelService = new UserLevelService();
            $res = $userLevelService->addUserLevel($param);
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

            $userLevelService = new UserLevelService();
            $res = $userLevelService->editUserLevel($param);
            return json($res);
        }

        $id = input('param.id');
        $userLevelModel = new UserLevelModel();
        View::assign([
            'info' => $userLevelModel->findOne([
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

        $userLevelModel = new UserLevelModel();
        $info = $userLevelModel->delById($id);

        return json($info);
    }
}
