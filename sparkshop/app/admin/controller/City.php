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

namespace app\admin\controller;

use app\admin\service\CityService;
use app\model\system\SetCity;
use think\facade\View;

class City extends Base
{
    /**
     * 获取列表
     */
    public function index()
    {
        $pid = input('param.pid', 0);
        $level = input('param.level', 0);
        $where[] = ['pid', '=', $pid];

        $cityService = new CityService();
        $res = $cityService->getList($where, $level);

        if (request()->isAjax()) {
            return jsonReturn(0, 'success', $res['data']);
        }

        View::assign([
            'tree' => $res['data']
        ]);

        return View::fetch();
    }

    /**
     * 添加
     */
    public function add()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $cityService = new CityService();
            $res = $cityService->addCity($param);
            return json($res);
        }

        return View::fetch();
    }

    /**
     * 编辑
     */
    public function edit()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $cityService = new CityService();
            $res = $cityService->editCity($param);
            return json($res);
        }

        $id = input('param.id');
        $setCityModel = new SetCity();
        View::assign([
            'info' => $setCityModel->findOne([
                'id' => $id
            ])['data']
        ]);

        return View::fetch();
    }

    /**
     * 删除
     */
    public function del()
    {
        $id = input('param.id');

        $setCityModel = new SetCity();

        $has = $setCityModel->where('pid', $id)->find();
        if (!empty($has)) {
            return jsonReturn(-1, '该地区下还存在地区，不可删除');
        }

        $info = $setCityModel->delById($id);

        return json($info);
    }

    /**
     * 获取所有的区域
     */
    public function area()
    {
        $cityService = new CityService();
        $res = $cityService->getAreaTree();

        return json($res);
    }
}
