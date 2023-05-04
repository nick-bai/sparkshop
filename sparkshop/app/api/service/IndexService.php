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
use app\model\system\WebsiteSlider;

class IndexService
{
    /**
     * 获取首页数据
     * @return array
     */
    public function getIndexData()
    {
        // 热销商品
        $goodsModel = new Goods();
        $hotSale = $goodsModel->getLimitList([
            'is_del' => 2,
            'is_show' => 1
        ], 10, 'id,name,slider_image,sales,price,original_price', 'sales desc')['data'];

        // 新品推荐
        $newGoods = $goodsModel->getLimitList([
            'is_del' => 2,
            'is_new' => 1
        ], 6, 'id,name,slider_image,sales,price,original_price', 'sales desc')['data'];

        // 幻灯片
        $sliderModel = new WebsiteSlider();
        $slider = $sliderModel->getAllList([], 'target_url,pic_url,type', 'sort desc')['data'];

        foreach ($hotSale as $key => $vo) {
            $hotSale[$key]['pic'] = json_decode($vo['slider_image'], true)['0'];
        }

        foreach ($newGoods as $key => $vo) {
            $newGoods[$key]['pic'] = json_decode($vo['slider_image'], true)['0'];
        }

        $seckillList = [];
        $seckillHour = 0;
        $seckillInstalled = hasInstalled('seckill');
        // 首页秒杀信息
        $res = $seckillInstalled ? event('seckillHomeData') : [];
        if (!empty($res)) {
            $seckillList = $res[0]['data']['list'];
            $seckillHour = $res[0]['data']['seckillHour'];
        }

        // 优惠券
        $couponInstalled = hasInstalled('coupon');

        return dataReturn(0, 'success', compact('hotSale', 'newGoods', 'slider', 'seckillList', 'seckillHour', 'seckillInstalled', 'couponInstalled'));
    }

    /**
     * 搜索
     * @param $param
     * @return array
     */
    public function search($param)
    {
        $goodsModel = new Goods();

        $where[] = ['is_del', '=', 2];
        $where[] = ['name', 'like', '%' . $param['keywords'] . '%'];
        $field = 'id,name,slider_image,sales,price,original_price';

        $list = $goodsModel->getPageList($param['limit'], $where, $field);
        $list['data']->each(function ($item) {
            $item->pic = json_decode($item['slider_image'], true)['0'];
            return $item;
        });

        return $list;
    }
}