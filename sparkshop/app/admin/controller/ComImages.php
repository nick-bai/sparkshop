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

use app\admin\service\ComImagesService;
use app\model\system\ComImages as ComImagesModel;
use think\facade\View;

class ComImages extends Base
{
    /**
     * 获取列表
     */
    public function index()
    {
        if (request()->isAjax()) {

            $param = input('param.');

            $comImagesService = new ComImagesService();
            $res = $comImagesService->getList($param);
            return json($res);
        }

        return View::fetch();
    }

    /**
     * 删除
     */
    public function del()
    {
        set_time_limit(0);
        $ids = input('param.ids');

        $comImagesService = new ComImagesService();
        $res = $comImagesService->delComImages($ids);
        return json($res);
    }

    /**
     * 移动图片分类
     */
    public function edit()
    {
        $ids = array_unique(input('param.ids'));
        $cateId = input('param.cate_id');

        $comImagesModel = new ComImagesModel();
        $res = $comImagesModel->updateByIds([
            'cate_id' => $cateId
        ], $ids);

        return json($res);
    }

    /**
     * 显示图片选择器
     */
    public function show()
    {
        View::assign([
            'type' => input('param.type', 'img'),
            'img_ext' => config('images.ext'),
            'video_ext' => config('images.video_ext'),
            'limit' => input('param.limit'),
            'callback' => input('param.callback')
        ]);

        return View::fetch();
    }
}
