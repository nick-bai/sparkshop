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

use app\index\service\CateService;
use think\facade\Route;
use think\facade\View;

class Cate extends Base
{
    public function index()
    {
        $cateId = input('param.id');
        $level = input('param.level', 1);
        $limit = input('param.limit', 20);
        $sortPrice = input('param.p_s', 'asc');

        $cateService = new CateService();
        $cateInfo = $cateService->getCateList($cateId, $level, $limit, $sortPrice);
        $cateList = $cateInfo['data']['cateList'];
        $crumbs = $cateInfo['data']['crumbs'];
        $goodsList = $cateInfo['data']['goodsList'];

        View::assign([
            'cate_id' => $cateId,
            'cate_list' => $cateList,
            'crumbs' => $crumbs,
            'goods_list' => $goodsList,
            'level' => $level,
            'price_type' => $sortPrice,
            'getMoreUrl' => Route::buildUrl('/index/cate', [
                'id' => $cateId,
                'level' => $level,
                'limit' => $limit,
                'page' => $goodsList['current_page'] + 1,
                'p_s' => $sortPrice
            ])
        ]);

        return View::fetch();
    }
}