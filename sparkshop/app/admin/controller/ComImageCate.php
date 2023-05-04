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

use app\admin\service\ComImageCateService;
use app\model\system\ComImagesCate;
use think\facade\View;

class ComImageCate extends Base
{
    /**
     * 获取列表
     */
    public function index()
    {
        if (request()->isAjax()) {

            $comImagesCateModel = new ComImagesCate();
            $list = $comImagesCateModel->getAllList()['data'];

            return jsonReturn(0, 'success', makeTree($list->toArray()));
        }
    }

    /**
     * 添加
     */
    public function add()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $comImagesCateService = new ComImageCateService();
            $res = $comImagesCateService->addComImageCate($param);
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

            $comImagesCateService = new ComImageCateService();
            $res = $comImagesCateService->editComImageCate($param);
            return json($res);
        }

        $id = input('param.id');
        $comImagesCateModel = new ComImagesCate();
        View::assign([
            'info' => $comImagesCateModel->findOne([
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
        if ($id == 0) {
            return jsonReturn(-3, '不可删除');
        }

        $comImagesCateService = new ComImageCateService();
        $info = $comImagesCateService->delComImageCate($id);
        return json($info);
    }
}
