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

class CateService
{
    /**
     * 商品分类信息
     * @param $cateId
     * @param $level
     * @param $limit
     * @param $sortPrice
     * @return array|string
     */
    public function getCateList($cateId, $level, $limit, $sortPrice)
    {
        // 该分类信息
        $cateModel = new GoodsCate();
        $cateInfo = $cateModel->findOne([
            'id' => $cateId,
            'status' => 1
        ], 'pid')['data'];

        // 从导航菜单进来，默认全部一级分类
        if (empty($cateInfo)) {
            $cateInfo['pid'] = 0;
            $defaultCate = $cateModel->findOne([
                'status' => 1,
                'pid' => 0
            ], 'id')['data'];

            if (empty($defaultCate)) {
                return build404(['msg' => '商品分类数据有误']);
            }

            $cateId = $defaultCate['id'];
        }

        // 统计分类信息
        $cateList = $cateModel->getAllList([
            'level' => $level,
            'pid' => $cateInfo['pid'],
            'status' => 1
        ], 'id,level,name', 'sort desc')['data'];

        $res = $this->buildCrumbsAndCate($level, $cateId, $cateModel)['data'];
        $crumbs = $res['crumbs'];
        $cateIds = $res['cateIds'];

        $crumbs = array_reverse($crumbs);
        // 关联的商品信息
        $goodsModel = new Goods();
        $where[] = ['cate_id', 'in', $cateIds];
        $where[] = ['is_del', '=', 2];

        $order = 'id desc';
        if (!empty($sortPrice)) {
            $order = 'price ' . $sortPrice;
        }

        $goodsList = $goodsModel->getPageList($limit, $where, 'id,name,slider_image,sales,collects,price', $order)['data']
            ->each(function ($item) {
                $item->slider_image = json_decode($item->slider_image, true)['0'];
            })->toArray();

        return dataReturn(0, 'success', compact('cateList', 'crumbs', 'goodsList'));
    }

    /**
     * 构建数据
     * @param $level
     * @param $cateId
     * @param $cateModel
     * @return array
     */
    private function buildCrumbsAndCate($level, $cateId, $cateModel)
    {
        $cateIds = [];
        $crumbs = []; // 面包屑
        if ($level == 3) {

            $crumbs[2] = $cateModel->findOne([
                'id' => $cateId
            ], 'id,level,pid,name')['data']->toArray();
            $cateIds[] = $cateId;

            $crumbs[1] = $cateModel->findOne([
                'id' => $crumbs[2]['pid']
            ], 'id,level,pid,name')['data']->toArray();

            $crumbs[0] = $cateModel->findOne([
                'id' => $crumbs[1]['pid']
            ], 'id,level,pid,name')['data']->toArray();
        } else if ($level == 2) {

            $crumbs[1] = $cateModel->findOne([
                'id' => $cateId
            ], 'id,level,pid,name')['data']->toArray();
            $cateIds[] = $cateId;

            $crumbs[0] = $cateModel->findOne([
                'id' => $crumbs[1]['pid']
            ], 'id,level,pid,name')['data']->toArray();
            $cateIds[] = $crumbs[1]['id'];
        } else {

            $crumbs[] = $cateModel->findOne([
                'id' => $cateId
            ], 'id,level,pid,name')['data'];
            $cateIds[] = $cateId;

            // 顶级的二级
            $cateIdMaps = $cateModel->getAllList([
                'pid' => $cateId
            ], 'id,pid')['data']->toArray();
            if (!empty($cateIdMaps)) {
                $pids = [];
                foreach ($cateIdMaps as $vo) {
                    $pids[] = $cateIds[] = $vo['id'];
                }

                // 三级数据
                if (!empty($cateIds)) {
                    $cateIdMaps = $cateModel->getAllList([
                        ['pid', 'in', $pids]
                    ], 'id,pid')['data']->toArray();

                    if (!empty($cateIdMaps)) {
                        foreach ($cateIdMaps as $vo) {
                            $cateIds[] = $vo['id'];
                        }
                    }
                }
            }
        }

        return dataReturn(0, 'success', [
            'cateIds' => $cateIds,
            'crumbs' => $crumbs
        ]);
    }
}