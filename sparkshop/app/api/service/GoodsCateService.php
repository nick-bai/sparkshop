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

use app\model\goods\GoodsCate;

class GoodsCateService
{
    /**
     * 获取分类列表
     * @return array
     */
    public function getCateList()
    {
        $goodsCateModel = new GoodsCate();
        $list = $goodsCateModel->getAllList(['status' => 1], 'id,pid,name,icon,level', 'sort desc')['data'];

        return dataReturn(0, 'success', $list);
    }
}