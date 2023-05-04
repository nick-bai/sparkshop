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

use app\admin\service\GoodsService;
use app\model\goods\Goods as GoodsModel;
use app\model\goods\GoodsContent;
use app\model\goods\GoodsRuleExtend;
use think\facade\View;

class Goods extends Base
{
    /**
     * 获取列表
     */
    public function index()
    {
        if (request()->isAjax()) {

            $goodsService = new GoodsService();
            $res = $goodsService->getList(input('param.'));
            return json($res);
        }

        $goodsCateModel = new \app\model\goods\GoodsCate();
        $cate = $goodsCateModel->getAllList([
            'status' => 1
        ], 'id,pid,name')['data']->toArray();

        View::assign([
            'cate' => json_encode(makeTree($cate))
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

            $goodsService = new GoodsService();
            $res = $goodsService->addGoods($param, 'add');
            return json($res);
        }

        $goodsService = new GoodsService();
        View::assign($goodsService->getBaseParam());

        return View::fetch();
    }

    /**
     * 编辑
     */
    public function edit()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $goodsService = new GoodsService();
            $res = $goodsService->editGoods($param, 'edit');
            return json($res);
        }

        $id = input('param.id');
        $goodsModel = new GoodsModel();
        $goodsRuleModel = new \app\model\goods\GoodsRule();
        $goodsRuleExtendModel = new GoodsRuleExtend();
        $goodsContentModel = new GoodsContent();
        $goodsAttrModel = new \app\model\goods\GoodsAttr();
        View::assign([
            'info' => json_encode($goodsModel->findOne([
                'id' => $id
            ])['data']),
            'ruleData' => json_encode($goodsRuleModel->findOne([
                'goods_id' => $id
            ])['data']),
            'extend' => json_encode($goodsRuleExtendModel->getAllList([
                'goods_id' => $id
            ], '*', 'id asc')['data']),
            'content' => json_encode($goodsContentModel->findOne([
                'goods_id' => $id
            ])['data']),
            'attrData' => json_encode($goodsAttrModel->getAllList([
                'goods_id' => $id
            ], '*', 'id asc')['data'])
        ]);

        $goodsService = new GoodsService();
        View::assign($goodsService->getBaseParam());

        return View::fetch();
    }

    /**
     * 上下架
     */
    public function shelf()
    {
        $param = input('post.');
        $goodsModel = new GoodsModel();

        $res = $goodsModel->updateByIds([
            'is_show' => $param['is_show']
        ], $param['ids']);

        $res['msg'] = '操作成功';
        return json($res);
    }

    /**
     * 删除商品
     */
    public function del()
    {
        $goodsService = new GoodsService();
        return json($goodsService->delGoods(input('param.id')));
    }

    public function recover()
    {
        $id = input('param.id');
        $goodsModel = new GoodsModel();

        $res = $goodsModel->updateByIds([
            'is_del' => 2
        ], $id);

        $res['msg'] = '操作成功';
        return json($res);
    }
}
