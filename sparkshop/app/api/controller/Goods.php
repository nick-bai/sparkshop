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
namespace app\api\controller;

use app\api\service\GoodsService;
use app\BaseController;

class Goods extends BaseController
{
    public function initialize()
    {
        crossDomain();
    }

    /**
     * 商品详情
     */
    public function detail()
    {
        $goodsId = input('param.id');

        $goodsService = new GoodsService();
        $info = $goodsService->getMobileGoodsDetail($goodsId);
        return json($info);
    }

    /**
     * 商品规格详情
     */
    public function goodsRuleDetail()
    {
        $sku = input('param.sku');
        $goodsId = input('param.goods_id');

        $goodsService = new GoodsService();
        $res = $goodsService->getGoodsRuleDetail($sku, $goodsId);
        return json($res);
    }

    /**
     * 获取商品评论
     */
    public function getComments()
    {
        $goodsService = new GoodsService();
        $res = $goodsService->getComments(input('param.'));
        return json($res);
    }

    /**
     * 获取分类下的商品
     */
    public function getGoodsByCateInfo()
    {
        $param = input('param.');

        $goodsService = new GoodsService();
        $res = $goodsService->getGoodsByCateId($param);
        return json($res);
    }
}