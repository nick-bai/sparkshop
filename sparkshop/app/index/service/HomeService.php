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

namespace app\index\service;

use app\model\goods\Goods;
use app\model\goods\GoodsCate;
use app\model\system\WebsiteSlider;
use app\model\user\UserAgreement;

class HomeService
{
    /**
     * 首页数据
     * @return array
     */
    public function getHomeData()
    {
        // 幻灯
        $websiteModel = new WebsiteSlider();
        $flash = $websiteModel->getAllList([], '*', 'sort desc')['data'];

        // 分类
        $cateModel = new GoodsCate();
        $cateList = $cateModel->getAllList([
            ['status', '=', 1]
        ], 'id,pid,name,icon', 'sort desc')['data'];

        // 精品推荐
        $goodsModel = new Goods();
        $recommendList = $goodsModel->getLimitList([
            ['is_recommend', '=', 1],
            ['is_del', '=', 2],
        ], 4, 'id,name,slider_image,sales,price,original_price')['data']->toArray();
        foreach ($recommendList as $key => $vo) {
            $recommendList[$key]['pic'] = json_decode($vo['slider_image'], true)['0'];
        }

        // 数码办公
        $pcIds = [2, 3, 4, 5];
        $pcList = $goodsModel->getLimitList([
            ['cate_id', 'in', $pcIds],
            ['is_del', '=', 2],
        ], 8, 'id,name,slider_image,collects,price,original_price')['data']->toArray();
        foreach ($pcList as $key => $vo) {
            $pcList[$key]['pic'] = json_decode($vo['slider_image'], true)['0'];
        }

        return dataReturn(0, 'success', [
            'flash' => $flash,
            'cate' => makeTree($cateList->toArray()),
            'recommend' => $recommendList,
            'pcList' => $pcList
        ]);
    }

    /**
     * 获取用户协议
     * @param $type
     * @return array
     */
    public function getAgreement($type)
    {
        $userAgreementModel = new UserAgreement();
        $info = $userAgreementModel->findOne([
            'type' => $type
        ], 'content')['data'];

        return dataReturn(0, 'success', $info);
    }
}