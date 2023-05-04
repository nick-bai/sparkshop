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

use app\admin\service\GoodsRuleService;
use app\model\goods\GoodsRuleTpl as GoodsRuleTplModel;
use think\facade\View;

class GoodsRule extends Base
{
    /**
     * 获取列表
     */
    public function index()
    {
        if (request()->isAjax()) {

            $goodsRuleService = new GoodsRuleService();
            $res = $goodsRuleService->getList(input('param.'));
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

            $goodsRuleService = new GoodsRuleService();
            $res = $goodsRuleService->addGoodsRule($param);
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

            $goodsRuleService = new GoodsRuleService();
            $res = $goodsRuleService->editGoodsRule($param);
            return json($res);
        }

        $id = input('param.id');
        $goodsRuleModel = new GoodsRuleTplModel();
        $info = $goodsRuleModel->findOne([
            'id' => $id
        ])['data'];

        $first = [];
        $left = [];
        $itemNum = 0;

        if (!empty($info['value'])) {
            $value = json_decode($info['value'], true);
            $first = $value[0];
            unset($value[0]);
            $left = $value;
            $itemNum = count($value);
        }

        View::assign([
            'first' => $first,
            'left' => $left,
            'info' => $info,
            'itemNum' => $itemNum
        ]);

        return View::fetch();
    }

    /**
     * 删除
     */
    public function del()
    {
        $id = input('param.id');

        $goodsRuleModel = new GoodsRuleTplModel();
        $info = $goodsRuleModel->delById($id);

        return json($info);
    }

    /**
     * 获取规格信息
     */
    public function getRuleByGoodsId()
    {
        $id = input('param.goods_id');

        $goodsRuleService = new GoodsRuleService();
        $res = $goodsRuleService->getRuleByGoodsId($id);
        return json($res);
    }
}
