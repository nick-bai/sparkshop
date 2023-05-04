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

use app\admin\service\UserService;
use app\model\user\User as UserModel;
use app\model\user\UserLabel;
use think\facade\View;

class User extends Base
{
    /**
     * 获取列表
     */
    public function index()
    {
        if (request()->isAjax()) {

            $userService = new UserService();
            $res = $userService->getList(input('param.'));
            return json($res);
        }

        $userService = new UserService();
        View::assign($userService->buildBaseParam());

        $labelModel = new UserLabel();
        $labelList = $labelModel->getAllList([], 'id value,name', 'id asc')['data'];

        View::assign([
            'label' => json_encode($labelList)
        ]);

        return View::fetch();
    }

    /**
     * 添加
     */
    public function add()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $userService = new UserService();
            $res = $userService->addUser($param);
            return json($res);
        }
    }

    /**
     * 编辑
     */
    public function edit()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $userService = new UserService();
            $res = $userService->editUser($param);
            return json($res);
        }

        $id = input('param.id');
        $userModel = new UserModel();
        View::assign([
            'info' => $userModel->findOne([
                'id' => $id
            ])['data']
        ]);

        return View::fetch();
    }

    /**
     * 余额编辑
     */
    public function balance()
    {
        $param = input('post.');

        $userService = new UserService();
        $res = $userService->changeBalance($param);
        return json($res);
    }
}
