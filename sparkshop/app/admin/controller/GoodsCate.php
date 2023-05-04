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

use app\admin\service\GoodsCateService;
use app\model\goods\GoodsCate as GoodsCateModel;
use think\facade\View;

class GoodsCate extends Base
{
    /**
     * 获取列表
     */
    public function index()
    {
        if (request()->isAjax()) {

            $goodsCate = new GoodsCateModel();
            $list = $goodsCate->getAllList([], "*", "id asc");

            return jsonReturn(0, 'success', makeTree($list['data']->toArray()));
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

            $goodsCateService = new GoodsCateService();
            $res = $goodsCateService->addGoodsCate($param);
            return json($res);
        }

        View::assign([
            'pid' => input('param.pid'),
            'pName' => input('param.pname')
        ]);

        return View::fetch();
    }

    /**
     * 编辑
     */
    public function edit()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $goodsCateService = new GoodsCateService();
            $res = $goodsCateService->editGoodsCate($param);
            return json($res);
        }

        $pid = input('param.pid');
        $id = input('param.id');
        $goodsCateModel = new GoodsCateModel();

        if (0 == $pid) {
            $pName = '顶级分类';
        } else {
            $pName = $goodsCateModel->getInfoById($pid)['data']['name'];
        }

        View::assign([
            'info' => json_encode($goodsCateModel->findOne([
                'id' => $id
            ])['data']),
            'pid' => input('param.pid'),
            'pName' => $pName,
        ]);

        return View::fetch();
    }

    /**
     * 删除
     */
    public function del()
    {
        $id = input('param.id');

        $goodsCateService = new GoodsCateService();
        $res = $goodsCateService->delGoodsCate($id);
        return json($res);
    }
}
