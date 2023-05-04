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
namespace app\api\service;

use app\model\goods\Goods;
use app\model\goods\GoodsAttr;
use app\model\goods\GoodsContent;
use app\model\goods\GoodsRule;
use app\model\goods\GoodsRuleExtend;
use app\model\order\OrderComment;
use app\model\user\UserCollection;

class GoodsService
{
    /**
     * 获取商品页详情信息
     * @param $goodsId
     * @return array|string
     */
    public function getGoodsDetail($goodsId)
    {
        $goodsModel = new Goods();
        $goodsDetail = $goodsModel->findOne([
            'id' => $goodsId,
            'is_show' => 1,
            'is_del' => 2
        ])['data'];
        if (empty($goodsDetail)) {
            return dataReturn(-10, '商品不存在');
        }
        $goodsDetail['slider_image'] = json_decode($goodsDetail['slider_image'], true);

        // 商品属性
        $goodsAttrModel = new GoodsAttr();
        $goodsAttr = $goodsAttrModel->getAllList([
            'goods_id' => $goodsId
        ], '*', 'id asc')['data'];

        // 商品详情
        $goodsContentModel = new GoodsContent();
        $goodsContent = $goodsContentModel->findOne([
            'goods_id' => $goodsId
        ])['data'];

        // 商品规格
        $goodsRuleModel = new GoodsRule();
        $goodsRule = $goodsRuleModel->findOne([
            'goods_id' => $goodsId
        ])['data'];
        $ruleJson = '[]';
        if (!empty($goodsRule)) {
            $goodsRule = $goodsRule->toArray();
            $ruleMap = $goodsRule['rule'] = array_values(json_decode($goodsRule['rule'], true));
            $ruleJsonMap = [];
            foreach ($ruleMap as $vo) {
                $ruleJsonMap[] = $vo['item'];
            }

            $ruleJson = json_encode($ruleJsonMap);
        }

        // 规格的具体数据
        $goodsRuleExtendModel = new GoodsRuleExtend();
        $goodsRuleExtend = $goodsRuleExtendModel->getAllList([
            ['goods_id', '=', $goodsId],
            ['stock', '>', 0]
        ], 'id,sku,stock', 'id asc')['data'];
        $selectRuleMap = json_encode($this->formatRule($goodsRuleExtend));

        // 增加流量量
        $goodsModel->updateById([
            'views' => $goodsDetail['views'] + 1
        ], $goodsId);

        // 热卖
        $hotSale = $goodsModel->getLimitList(['is_del' => 2], 4, 'id,name,slider_image,price,sales', 'sales desc')['data'];
        foreach ($hotSale as $key => $vo) {
            $hotSale[$key]['img'] = json_decode($vo['slider_image'], true)[0];
        }

        // 初始价格
        $price = [];
        if ($goodsDetail['spec'] == 2) {
            $priceInfo = $goodsRuleExtendModel->findOne([
                'goods_id' => $goodsId
            ], 'min( price ) min_price,max( price ) max_price,min( original_price ) min_original_price,max( original_price ) max_original_price')['data']->toArray();
            $price['original_price'] = number_format($priceInfo['min_original_price'], 2).  '-' . number_format($priceInfo['max_original_price'], 2);
            $price['price'] = number_format($priceInfo['min_price'], 2) . '-' . number_format($priceInfo['max_price'], 2);
        } else {
            $price['original_price'] = number_format($goodsDetail['original_price'], 2);
            $price['price'] = number_format($goodsDetail['price'], 2);
        }

        // 查询评价
        $OrderCommentsModel = new OrderComment();
        $comments = $OrderCommentsModel->field('count(*) as `t_total`,type')
            ->where('goods_id', $goodsId)->group('type')->select()->toArray();
        $commentsMap = [
            1 => 0,
            2 => 0,
            3 => 0
        ];
        $total = count($comments);
        $goodsAppraise = 0;
        foreach ($comments as $vo) {
            $commentsMap[$vo['type']] = $vo['t_total'];
            if ($vo['type'] <= 2) {
                $goodsAppraise += 1;
            }
        }

        if ($total == 0) {
            $goodsPercent = 100;
        } else {
            $goodsPercent = ceil($goodsAppraise / $total) * 100;
        }

        return dataReturn(0, 'success', compact('goodsDetail', 'goodsAttr', 'goodsContent', 'goodsRule', 'selectRuleMap',
            'ruleJson', 'hotSale', 'goodsId', 'price', 'commentsMap', 'goodsPercent'));
    }

    /**
     * 移动端商品详情
     * @param $goodsId
     * @return array|string
     */
    public function getMobileGoodsDetail($goodsId)
    {
        $goodsModel = new Goods();
        $goodsDetail = $goodsModel->findOne([
            'id' => $goodsId,
            'is_show' => 1,
            'is_del' => 2
        ], 'name,spec,price,sales,slider_image,stock,unit,views,original_price')['data'];
        if (empty($goodsDetail)) {
            return dataReturn(-10, '商品不存在');
        }
        $goodsDetail['slider_image'] = json_decode($goodsDetail['slider_image'], true);

        // 商品属性
        $goodsAttrModel = new GoodsAttr();
        $goodsAttr = $goodsAttrModel->getAllList([
            'goods_id' => $goodsId
        ], 'name,value', 'id asc')['data'];

        // 商品详情
        $goodsContentModel = new GoodsContent();
        $goodsContent = $goodsContentModel->findOne([
            'goods_id' => $goodsId
        ])['data'];

        // 商品规格
        $goodsRuleModel = new GoodsRule();
        $goodsRule = $goodsRuleModel->findOne([
            'goods_id' => $goodsId
        ])['data'];

        if (!empty($goodsRule)) {
            $goodsRule = $goodsRule->toArray();
            $goodsRule['rule'] = array_values(json_decode($goodsRule['rule'], true));
        }

        // 规格的具体数据
        $goodsRuleExtendModel = new GoodsRuleExtend();
        $goodsRuleMap = $goodsRuleExtendModel->getAllList([
            ['goods_id', '=', $goodsId],
            ['stock', '>', 0]
        ], 'sku,stock,price,image,original_price', 'id asc')['data']->toArray();

        // 增加流量量
        $goodsModel->updateById([
            'views' => $goodsDetail['views'] + 1
        ], $goodsId);

        // 查询评价
        $OrderCommentsModel = new OrderComment();
        $comments = $OrderCommentsModel->field('count(*) as `t_total`,type')
            ->where('goods_id', $goodsId)->group('type')->select()->toArray();

        $commentTotal = count($comments);
        $goodsAppraise = 0;
        foreach ($comments as $vo) {
            if ($vo['type'] <= 2) {
                $goodsAppraise += 1;
            }
        }

        if ($commentTotal == 0) {
            $goodPercent = 100;
        } else {
            $goodPercent = ceil($goodsAppraise / $commentTotal) * 100;
        }

        // 我的收藏
        $favorite = false;
        $userInfo = getUserInfo();
        if (!empty($userInfo)) {
           $has = (new UserCollection())->findOne([
               'goods_id' => $goodsId,
               'user_id' => $userInfo['id']
           ], 'id')['data'];
           if (!empty($has)) {
               $favorite = true;
           }
        }

        return dataReturn(0, 'success', compact('goodsDetail', 'goodsAttr', 'goodsContent',
            'goodsRule', 'goodsRuleMap', 'commentTotal', 'goodPercent', 'favorite'));
    }

    /**
     * 获取商品的规格详情
     * @param $sku
     * @param $goodsId
     * @return array
     */
    public function getGoodsRuleDetail($sku, $goodsId)
    {
        $goodsRuleExtendModel = new GoodsRuleExtend();
        $skuInfo = $goodsRuleExtendModel->findOne([
            'sku' => $sku,
            'goods_id' => $goodsId
        ], 'id,goods_id,sku,stock,original_price,price,image,spu')['data'];

        if (!empty($skuInfo)) {
            $skuInfo['original_price'] = number_format($skuInfo['original_price'], 2);
            $skuInfo['price'] = number_format($skuInfo['price'], 2);
        }

        return dataReturn(0, 'success', $skuInfo);
    }

    /**
     * 获取商品评论
     * @param $param
     * @return array
     */
    public function getComments($param)
    {
        $limit = $param['limit'];
        $type = $param['type'];
        $goodsId = $param['goods_id'];

        $where = [];
        if (!empty($type)) {
            $where[] = ['type', '=', $type];
        }

        $commentsModel = new OrderComment();
        $list = $commentsModel->where('goods_id', $goodsId)->where($where)->order('id desc')->paginate($limit)
            ->each(function ($item) {
                $item->user_name = encryptName($item->user_name);
                $item->sku = str_replace('※', ' ', $item->sku);
                $item->pictures = !empty($item->pictures) ? explode(',', $item->pictures) : [];
                $item->create_time = date('Y-m-d', strtotime($item->create_time));
            });

        $appraiseNum = $commentsModel->field('type,count(*) t_total')->where('goods_id', $goodsId)->group('type')->select()->toArray();
        $finalNum = [];
        foreach ($appraiseNum as $vo) {
            $finalNum[$vo['type']] = $vo['t_total'];
        }

        return dataReturn(0, 'success', ['list' => $list, 'num' => $finalNum]);
    }

    /**
     * 根据查询分类下的商品列表
     * @param $param
     * @return array
     */
    public function getGoodsByCateId($param)
    {
        $limit = $param['limit'];
        $cateId = $param['cate_id'];

        $where['cate_id'] = $cateId;
        $orderBy = 'id desc';
        if (!empty($param['order_by_sales'])) {
            $orderBy = 'sales desc';
        }

        if (!empty($param['order_by_price'])) {
            if ($param['order_by_price'] == 1) {
                $orderBy = 'price asc';
            } else {
                $orderBy = 'price desc';
            }
        }

        $goodsModel = new Goods();
        return $goodsModel->getPageList($limit, $where, 'id,name,slider_image,sales,price,original_price', $orderBy);
    }

    /**
     * 生成所有子集是否可选、库存状态 map
     * @param $goodsRuleExtend
     * @return array|string
     */
    protected function formatRule($goodsRuleExtend)
    {
        $res = [];
        if (empty($goodsRuleExtend)) {
            return $res;
        }
        $goodsRuleExtend = $goodsRuleExtend->toArray();

        $allKeys = [];
        foreach ($goodsRuleExtend as $key => $vo) {
            $allKeys[] = $vo['sku'];
        }

        foreach ($allKeys as $key => $vo) {

            $sku = $goodsRuleExtend[$key]['id'];
            // 获取keys的所有排列组合
            $allSets = $this->powerSet(explode('※', $vo));
            foreach ($allSets as $v) {
                $key = implode('※', $v);
                if (isset($res[$key])) {
                    $res[$key][] = $sku;
                } else {
                    $res[$key] = [$sku];
                }
            }
        }

        return $res;
    }

    /**
     * 取得集合的所有子集「幂集」(所有可能性)
     * @param $item
     * @return array[]
     */
    protected function powerSet($item)
    {
        $ps = [[]];
        for ($i = 0; $i < count($item); $i++) {
            for ($j = 0, $len = count($ps); $j < $len; $j++) {
                $ps[] = array_merge($ps[$j],[$item[$i]]);
            }
        }

        return $ps;
    }
}