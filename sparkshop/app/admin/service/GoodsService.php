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
namespace app\admin\service;

use app\model\goods\Goods;
use app\model\goods\GoodsAttr;
use app\model\goods\GoodsAttrTpl;
use app\model\goods\GoodsCate;
use app\model\goods\GoodsContent;
use app\model\goods\GoodsRule;
use app\model\goods\GoodsRuleExtend;
use app\model\goods\GoodsRuleTpl;
use app\model\system\ShippingTemplates;
use app\model\user\UserLabel;
use think\facade\Db;

class GoodsService
{
    /**
     * 商品列表
     * @param $param
     * @return array
     */
    public function getList($param)
    {
        $limit = $param['limit'];
        $name = $param['name'];
        $cateId = $param['cate_id'];
        $type = $param['tab_type'];

        $where = [];
        if (!empty($name)) {
            $where[] = ['name', 'like', '%' . $name . '%'];
        }

        if (!empty($cateId)) {
            $where[] = ['cate_id', '=', $cateId];
        }

        if ($type == 2) {
            $where[] = ['is_show', '=', 1];
            $where[] = ['is_del', '=', 2];
        } else if ($type == 3) {
            $where[] = ['is_show', '=', 2];
            $where[] = ['is_del', '=', 2];
        } else if ($type == 4) {
            $where[] = ['is_del', '=', 2];
            $where[] = ['is_show', '=', 1];
            $where[] = ['stock', '<', 10]; // todo 预警动态
        } else if ($type == 5) {
            $where[] = ['is_del', '=', 1];
        }

        $goodsModel = new Goods();
        $list = $goodsModel->where($where)->with('cate')->order('id desc')->paginate($limit);
        return dataReturn(0, 'success', $list);
    }

    /**
     * 添加商品
     * @param $param
     * @param $mode
     * @return array
     */
    public function addGoods($param, $mode)
    {
        $res = $this->checkParam($param);
        if ($res['code'] != 0) {
            return $res;
        }

        Db::startTrans();
        try {

            $res = $this->goodsTemplate($param, $mode);
            if ($res['code'] != 0) {
                Db::rollback();
                return $res;
            }

            Db::commit();
        } catch (\Exception $e) {
            Db::rollback();
            return dataReturn(-1, $e->getMessage());
        }

        return dataReturn(0, '添加成功');
    }

    /**
     * 编辑商品
     * @param $param
     * @param $mode
     * @return array
     */
    public function editGoods($param, $mode)
    {
        $res = $this->checkParam($param);
        if ($res['code'] != 0) {
            return $res;
        }

        Db::startTrans();
        try {

            $res = $this->goodsTemplate($param, $mode);
            if ($res['code'] != 0) {
                Db::rollback();
                return $res;
            }

            Db::commit();
        } catch (\Exception $e) {
            Db::rollback();
            return dataReturn(-1, $e->getMessage());
        }

        return dataReturn(0, '编辑成功');
    }

    /**
     * 处理业务逻辑
     * @param $param
     * @param $mode
     * @return array
     */
    private function goodsTemplate($param, $mode)
    {
        $res = $this->dealBase($param, $mode);
        if ($res['code'] != 0) {
            return $res;
        }

        if ($mode == 'edit') {
            $param['goods_id'] = $param['id'];
        } else {
            $param['goods_id'] = $res['data'];
        }

        // 处理规格
        $res = $this->dealRule($param, $mode);
        if ($res['code'] != 0) {
            return $res;
        }

        // 处理内容
        $res = $this->dealContent($param, $mode);
        if ($res['code'] != 0) {
            return $res;
        }

        // 处理物流
        $res = $this->dealExpress($param);
        if ($res['code'] != 0) {
            return $res;
        }

        // 处理其他
        $res = $this->dealOther($param, $mode);
        if ($res['code'] != 0) {
            return $res;
        }

        return dataReturn(0, "添加成功");
    }

    /**
     * 构建基础信息
     * @return array
     */
    public function getBaseParam()
    {
        $goodsRuleModel = new GoodsRuleTpl();
        $rule = $goodsRuleModel->getAllList([], '*', 'id asc')['data'];
        foreach ($rule as $vo) {
            $vo->value = json_decode($vo->value, true);
        }

        $goodsCateModel = new GoodsCate();
        $cate = $goodsCateModel->getAllList([
            'status' => 1
        ], 'id,pid,name', 'id asc')['data']->toArray();

        $goodsAttrModel = new GoodsAttrTpl();
        $attr = $goodsAttrModel->getAllList([], '*', 'id asc')['data'];
        foreach ($attr as $vo) {
            $vo->value = json_decode($vo->value, true);
        }

        $labelModel = new UserLabel();
        $labelList = $labelModel->getAllList([], 'id value,name', 'id asc')['data'];

        $shippingTemplatesModel = new ShippingTemplates();
        $list = $shippingTemplatesModel->getAllList([
            'is_del' => 1
        ], 'id,name', 'id asc')['data'];

        return [
            'rule' => json_encode($rule),
            'cate' => json_encode(makeTree($cate)),
            'attr' => json_encode($attr),
            'label' => json_encode($labelList),
            'tpl' => json_encode($list)
        ];
    }

    /**
     * 删除商品
     * @param $id
     */
    public function delGoods($id)
    {
        $goodsModel = new Goods();
        $res = $goodsModel->updateByIds([
            'is_show' => 2,
            'is_del' => 1
        ], $id);

        $res['msg'] = '操作成功';
        return json($res);
    }

    /**
     * 检测资源的合法性
     * @param $param
     * @return array
     */
    private function checkParam($param)
    {
        if (empty($param['cate_id'])) {
            return dataReturn(-1, "请选择商品分类", 1);
        }

        if (empty($param['name'])) {
            return dataReturn(-2, "请输入商品名称", 1);
        }

        if (empty($param['unit'])) {
            return dataReturn(-3, "请输入单位", 1);
        }

        if (!isset($param['slider_image'])) {
            return dataReturn(-4, "请选择商品图", 1);
        }

        if ($param['spec'] == 1) {

            if (empty($param['price']) || $param['price'] < 0) {
                return dataReturn(-5, "请输入大于等于0的售价", 2);
            }

            if ($param['stock'] == '' || $param['stock'] < 0) {
                return dataReturn(-5, "请输入大于等于0的库存", 2);
            }
        } else if ($param['spec'] == 2) {

            $errorMsg = '';
            if (!isset($param['final']) || empty($param['final'])) {
                return dataReturn(-6, "请生成商品规格", 2);
            }

            foreach ($param['final'] as $vo) {
                if (empty($vo['price']) || $vo['price'] < 0) {
                    $errorMsg = '规格售价要大于等于0元';
                    break;
                }

                if ($vo['stock'] == '' || $vo['stock'] < 0) {
                    $errorMsg = '规格库存要大于等于0';
                    break;
                }

                $skuStr = '';
                foreach ($vo['sku'] as $v) {
                    $skuStr .= $v . ',';
                }

                if (strlen(trim($skuStr, ',')) > 128) {
                    $errorMsg = '规格名过长';
                    break;
                }
            }

            if (!empty($errorMsg)) {
                return dataReturn(-7, $errorMsg, 2);
            }
        }

        if ($param['freight'] == 1 && trim($param['postage']) == '') {
            return dataReturn(-8, "请输入有效的邮费", 4);
        }

        // 商品参数校验
        if (!empty($param['attr_tpl_id']) || (isset($param['attr_item']) && !empty(array_filter($param['attr_item'])))) {

            if (count($param['attr_item']) != count(array_filter($param['attr_item']))) {
                return dataReturn(-9, "商品参数名存在空值，请认真检查", 5);
            }

            if (count($param['attr_value']) != count(array_filter($param['attr_value']))) {
                return dataReturn(-10, "商品参数值存在空值，请认真检查", 5);
            }
        }

        return dataReturn(0);
    }

    /**
     * 处理基础信息
     * @param $param
     * @param $mode
     * @return array
     */
    private function dealBase($param, $mode)
    {
        $goodsModel = new Goods();
        if ($mode == 'edit') {
            $uniqueGoods = $goodsModel->findOne([
                ['name', '=', $param['name']],
                ['cate_id', '=', $param['cate_id']],
                ['id', '<>', $param['id']]
            ])['data'];
        } else {
            $uniqueGoods = $goodsModel->findOne([
                'name' => $param['name'],
                'cate_id' => $param['cate_id']
            ])['data'];
        }

        if (!empty($uniqueGoods)) {
            return dataReturn(-10, "该商品已经存在");
        }

        $baseParam = [
            'type' => $param['type'],
            'name' => $param['name'],
            'sub_name' => $param['sub_name'],
            'cate_id' => $param['cate_id'],
            'unit' => $param['unit'],
            'slider_image' => json_encode($param['slider_image']),
            'video_src' => $param['video_src'],
            'is_show' => $param['is_show'],
            'create_time' => now()
        ];

        if ($mode == 'edit') {
            unset($baseParam['create_time']);
            $baseParam['update_time'] = now();
            return $goodsModel->updateById($baseParam, $param['id']);
        } else {
            return $goodsModel->insertOne($baseParam);
        }
    }

    /**
     * 处理规则数据
     * @param $param
     * @param $mode
     * @return array
     */
    private function dealRule($param, $mode)
    {
        $goodsStock = 0;
        $priceMap = [];
        // 如果是多规格
        if ($param['spec'] == 2) {

            $goodsRuleModel = new GoodsRule();
            $goodsRuleMap = [
                'goods_id' => $param['goods_id'],
                'rule' => json_encode($param['preItem'])
            ];

            if ($mode == 'edit') {
                $res = $goodsRuleModel->updateById($goodsRuleMap, $param['id'], 'goods_id');
            } else {
                $res = $goodsRuleModel->insertOne($goodsRuleMap);
            }

            if ($res['code'] != 0) {
                return $res;
            }

            $itemsMap = [];
            $goodsRuleExtendModel = new GoodsRuleExtend();
            foreach ($param['final'] as $vo) {
                $itemParam = [];
                $skuStr = '';
                foreach ($vo['sku'] as $v) {
                    $skuStr .= $v . '※';
                }
                $itemParam['sku'] = rtrim($skuStr, '※');
                $itemParam['goods_id'] = $param['goods_id'];
                $itemParam['unique'] = uniqid();
                $itemParam['price'] = $vo['price'];
                $itemParam['stock'] = $vo['stock'];
                $itemParam['image'] = $vo['image'] ?? '';
                $itemParam['cost_price'] = $vo['cost_price'];
                $itemParam['original_price'] = $vo['original_price'];
                $itemParam['weight'] = $vo['weight'];
                $itemParam['volume'] = $vo['volume'];
                $itemParam['spu'] = $vo['spu'];
                $itemParam['create_time'] = now();

                $goodsStock += $vo['stock'];
                $priceMap[] = $vo['price'];

                $itemsMap[] = $itemParam;
            }

            if ($mode == 'edit') {
                // 规则存的则更新，新增的插入，多余的删除
                $ruleExtendList = $goodsRuleExtendModel->getAllList([
                    'goods_id' => $param['goods_id']
                ])['data'];

                $sku2Id = [];
                foreach ($ruleExtendList as $vo) {
                    $sku2Id[$vo['sku']] = $vo['id'];
                }

                $insertMap = [];
                $needDel = $sku2Id;
                foreach ($itemsMap as $vo) {
                    if (!isset($sku2Id[$vo['sku']])) {
                        $insertMap[] = $vo;
                    } else {
                        // 存在的，更新
                        $res = $goodsRuleExtendModel->updateById($vo, $sku2Id[$vo['sku']]);
                        if ($res['code'] != 0) {
                            return $res;
                        }
                        unset($needDel[$vo['sku']]);
                    }
                }

                // 本次新增的插入
                if (!empty($insertMap)) {
                    $res = $goodsRuleExtendModel->insertBatch($insertMap);
                    if ($res['code'] != 0) {
                        return $res;
                    }
                }

                // 已经删除的，则删掉
                if (!empty($needDel)) {
                    $goodsRuleExtendModel->delByIds(array_values($needDel));
                }
            } else {
                $res = $goodsRuleExtendModel->insertBatch($itemsMap);
                if ($res['code'] != 0) {
                    return $res;
                }
            }
        }

        $goodsModel = new Goods();
        $ruleParam = [
            'spec' => $param['spec'],
            'price' => $param['price'],
            'cost_price' => $param['cost_price'],
            'original_price' => $param['original_price'],
            'stock' => $param['stock'],
            'spu' => $param['spu'],
            'weight' => $param['weight'],
            'volume' => $param['volume']
        ];

        if ($param['spec'] == 2) {
            $ruleParam['stock'] = $goodsStock;
            $ruleParam['price'] = min($priceMap);
        }

        $res = $goodsModel->updateById($ruleParam, $param['goods_id']);
        if ($res['code'] != 0) {
            return $res;
        }

        return dataReturn(0);
    }

    /**
     * 处理商品详情
     * @param $param
     * @param $mode
     * @return array
     */
    private function dealContent($param, $mode)
    {
        $contentMap = [
            'goods_id' => $param['goods_id'],
            'content' => $param['content']
        ];

        $goodsContentModel = new GoodsContent();

        if ($mode == 'edit') {
            $res = $goodsContentModel->updateById($contentMap, $param['id'], 'goods_id');
        } else {
            $res = $goodsContentModel->insertOne($contentMap);
        }

        if ($res['code'] != 0) {
            return $res;
        }

        return dataReturn(0);
    }

    /**
     * 处理物流信息
     * @param $param
     * @return array
     */
    private function dealExpress($param)
    {
        $freightMap = [
            'freight' => $param['freight'],
            'postage' => $param['postage'],
            'shipping_tpl_id' => $param['shipping_tpl_id']
        ];

        $goodsModel = new Goods();
        $res = $goodsModel->updateById($freightMap, $param['goods_id']);
        if ($res['code'] != 0) {
            return $res;
        }

        return dataReturn(0);
    }

    /**
     * 处理其他数据
     * @param $param
     * @param $mode
     * @return array
     */
    private function dealOther($param, $mode)
    {
        $otherMap = [
            'seo_title' => $param['seo_title'],
            'seo_keywords' => $param['seo_keywords'],
            'seo_desc' => $param['seo_desc'],
            'is_hot' => $param['is_hot'],
            'is_recommend' => $param['is_recommend'],
            'is_new' => $param['is_new'],
            'user_label' => $param['label_id']
        ];

        $goodsModel = new Goods();
        $res = $goodsModel->updateById($otherMap, $param['goods_id']);
        if ($res['code'] != 0) {
            return $res;
        }

        if (!empty($param['attr_tpl_id']) || (isset($param['attr_item']) && !empty(array_filter($param['attr_item'])))) {

            $goodsAttrModel = new GoodsAttr();
            $attrMap = [];

            foreach ($param['attr_item'] as $key => $vo) {
                $attrMap[] = [
                    'goods_id' => $param['goods_id'],
                    'name' => $vo,
                    'value' => $param['attr_value'][$key],
                    'create_time' => now()
                ];
            }

            if ($mode == 'edit') {
                $goodsAttrModel->delById($param['id'], 'goods_id');
            }

            $res = $goodsAttrModel->insertBatch($attrMap);
            if ($res['code'] != 0) {
                return $res;
            }
        }

        return dataReturn(0);
    }
}