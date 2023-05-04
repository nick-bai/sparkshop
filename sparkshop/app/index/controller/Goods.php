<?php
// +----------------------------------------------------------------------
// | SparkShop 坚持做优秀的商城系统
// +----------------------------------------------------------------------
// | Copyright (c) 2022~2099 http://sparkshop.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://opensource.org/licenses/mit-license.php )
// +----------------------------------------------------------------------
// | Author: NickBai
// +----------------------------------------------------------------------

namespace app\index\controller;

use app\index\service\GoodsService;
use think\facade\View;

class Goods extends Base
{
    /**
     * 商品详情页
     */
    public function detail()
    {
        $goodsId = input('param.id');
        $type = input('param.type', 1);

        $goodsService = new GoodsService();
        $res = $goodsService->getGoodsDetail($goodsId);
        if ($res['code'] != 0) {
            return build404($res);
        }

        View::assign($res['data']);
        View::assign(['type' => $type]);

        return View::fetch();
    }

    /**
     * 查询可用的优惠券
     */
    public function coupon()
    {
        $goodsId = input('param.goods_id');

        $goodsService = new GoodsService();
        $res = $goodsService->getGoodsValidCoupon($goodsId);
        return json($res);
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
        if (request()->isAjax()) {

            $goodsService = new GoodsService();
            $res = $goodsService->getComments(input('param.'));
            return json($res);
        }
    }
}