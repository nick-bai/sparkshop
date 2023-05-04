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

use app\admin\service\ExpressService;
use app\model\system\SetExpress;
use think\facade\View;

class Express extends Base
{
    /**
     * 获取列表
     */
    public function index()
    {
        if (request()->isAjax()) {

            $param = input('param.');

            $expressService = new ExpressService();
            $res = $expressService->getList($param);
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

            $expressService = new ExpressService();
            $res = $expressService->addExpress($param);
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

            $expressService = new ExpressService();
            $res = $expressService->editExpress($param);
            return json($res);
        }

        $id = input('param.id');
        $setExpressModel = new SetExpress();
        View::assign([
            'info' => $setExpressModel->findOne([
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

        $setExpressModel = new SetExpress();
        $info = $setExpressModel->delById($id);

        return json($info);
    }
}
