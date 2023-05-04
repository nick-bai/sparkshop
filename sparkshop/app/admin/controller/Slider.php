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

use app\admin\service\SliderService;
use app\model\system\WebsiteSlider;
use think\facade\View;

class Slider extends Base
{
    /**
     * 获取列表
     */
    public function index()
    {
        if (request()->isAjax()) {

            $sliderService = new SliderService();
            $list = $sliderService->getList(input('param.'));
            return json($list);
        }

        return View::fetch();
    }

    /**
     * 添加
     */
    public function add()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $sliderService = new SliderService();
            $res = $sliderService->addSlider($param);
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

            $sliderService = new SliderService();
            $res = $sliderService->editSlider($param);
            return json($res);
        }

        $id = input('param.id');
        $websiteSliderModel = new WebsiteSlider();
        View::assign([
            'info' => $websiteSliderModel->findOne([
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

        $websiteSliderModel = new WebsiteSlider();
        $info = $websiteSliderModel->delById($id);

        return json($info);
    }
}

