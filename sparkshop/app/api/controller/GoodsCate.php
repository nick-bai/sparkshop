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

use app\api\service\GoodsCateService;
use app\BaseController;

class GoodsCate extends BaseController
{
    /**
     * 商品分类列表
     */
    public function index()
    {
        $goodsCateService = new GoodsCateService();
        $res = $goodsCateService->getCateList();
        return json($res);
    }
}