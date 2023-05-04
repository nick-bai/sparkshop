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

use app\admin\validate\SetCityValidate;
use app\model\system\SetCity;
use think\exception\ValidateException;

class CityService
{
    /**
     * 获取城市列表
     * @param $where
     * @param $level
     * @return array|\think\response\Json
     */
    public function getList($where, $level)
    {
        $cityModel = new SetCity();
        if (request()->isAjax()) {

            $list = $cityModel->getAllList($where, "id,pid,name,level,is_show", "id asc")['data'];
            foreach ($list as $key => $vo) {
                if ($level <= 1) {
                    $list[$key]['hasChildren'] = true;
                    $list[$key]['children'] = [];
                }
            }

            return dataReturn(0, 'success', $list);
        }

        $list = $cityModel->getAllList($where, "id,pid,name,level,is_show", "id asc")['data'];
        foreach ($list as $key => $vo) {
            $list[$key]['hasChildren'] = true;
            $list[$key]['children'] = [];
        }

        return dataReturn(0, 'success', $list);
    }

    /**
     * 添加城市
     * @param $param
     * @return array|\think\response\Json
     */
    public function addCity($param)
    {
        // 检验完整性
        try {
            validate(SetCityValidate::class)->check($param);
        } catch (ValidateException $e) {
            return dataReturn(-1, $e->getError());
        }

        $setCityModel = new SetCity();
        $has = $setCityModel->checkUnique([
            'name' => $param['name'],
            'pid' => $param['pid'],
        ])['data'];

        if (!empty($has)) {
            return dataReturn(-2, '名称已经存在');
        }

        return $setCityModel->insertOne($param);
    }

    /**
     * 编辑城市
     * @param $param
     * @return array|\think\response\Json
     */
    public function editCity($param)
    {
        // 检验完整性
        try {
            validate(SetCityValidate::class)->check($param);
        } catch (ValidateException $e) {
            return dataReturn(-1, $e->getError());
        }

        $setCityModel = new SetCity();

        $where[] = ['id', '<>', $param['id']];
        $where[] = ['name', '=', $param['name']];
        $has = $setCityModel->checkUnique($where)['data'];

        if (!empty($has)) {
            return dataReturn(-2, '名称已经存在');
        }

        return $setCityModel->updateById($param, $param['id']);
    }

    /**
     * 地区tree
     * @return array
     */
    public function getAreaTree()
    {
        $cityModel = new SetCity();
        $where[] = ['level', '<=', 3];
        $list = $cityModel->getAllList($where, "id,pid,name,level,is_show", "id asc")['data'];

        $tree = makeTree($list->toArray());

        return dataReturn(0, 'success', $tree);
    }
}