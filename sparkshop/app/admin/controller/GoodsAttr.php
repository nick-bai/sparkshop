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

use app\admin\service\GoodsAttrService;
use app\model\goods\GoodsAttrTpl;
use think\facade\View;

class GoodsAttr extends Base
{
    /**
     * 获取列表
     */
    public function index()
    {
        if (request()->isAjax()) {

            $goodsAttrService = new GoodsAttrService();
            $res = $goodsAttrService->getList(input('param.'));
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

            $goodsAttrService = new GoodsAttrService();
            $res = $goodsAttrService->addGoodsAttr($param);
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

            $goodsAttrService = new GoodsAttrService();
            $res = $goodsAttrService->editGoodsAttr($param);
            return json($res);
        }

        $id = input('param.id');
        $goodsAttrTplModel = new GoodsAttrTpl();
        $info = $goodsAttrTplModel->findOne([
            'id' => $id
        ])['data'];

        View::assign([
            'info' => $info,
            'attr' => json_decode($info['value'], true)
        ]);

        return View::fetch();
    }

    /**
     * 删除
     */
    public function del()
    {
        $id = input('param.id');

        $goodsAttrTplModel = new GoodsAttrTpl();
        $info = $goodsAttrTplModel->delById($id);

        return json($info);
    }
}
