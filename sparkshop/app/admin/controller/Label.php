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

use app\admin\service\LabelService;
use app\model\user\UserLabel;
use think\facade\View;

class Label extends Base
{
    /**
     * 获取列表
     */
    public function index()
    {
        if (request()->isAjax()) {

            $labelService = new LabelService();
            $res = $labelService->getList(input('param.'));
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

            $labelService = new LabelService();
            $res = $labelService->addLabel($param);
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

            $labelService = new LabelService();
            $res = $labelService->editLabel($param);
            return json($res);
        }

        $id = input('param.id');
        $labelModel = new UserLabel();
        View::assign([
            'info' => $labelModel->findOne([
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

        $labelModel = new UserLabel();
        $info = $labelModel->delById($id);

        return json($info);
    }
}
