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

use app\admin\service\ShippingService;
use app\model\system\ShippingTemplates;
use app\model\system\ShippingTemplatesRegion;
use think\facade\View;

class Shipping extends Base
{
    /**
     * 获取列表
     */
    public function index()
    {
        if (request()->isAjax()) {

            $shippingService = new ShippingService();
            $res = $shippingService->getList(input('param.'));
            return json($res);
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

            $shippingService = new ShippingService();
            $res = $shippingService->addShipping($param);
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

            $shippingService = new ShippingService();
            $res = $shippingService->editShipping($param);
            return json($res);
        }

        $id = input('param.id');
        $shippingTemplatesModel = new ShippingTemplates();
        $shippingTemplatesRegionModel = new ShippingTemplatesRegion();
        $extend = $shippingTemplatesRegionModel->with(['province', 'city'])->where('tpl_id', $id)->select()->toArray();

        $country = [];
        foreach ($extend as $key => $vo) {
            if ($vo['province_id'] == 0 && $vo['city_id'] == 0) {
                $country = $vo;
                unset($extend[$key]);
                break;
            }
        }

        // 整理模板数据
        $extendMap = [];
        foreach ($extend as $vo) {
            $extendMap[$vo['uniqid']][] = $vo;
        }

        $shippingService = new ShippingService();
        View::assign([
            'info' => json_encode($shippingTemplatesModel->findOne([
                'id' => $id
            ])['data']),
            'extend' => json_encode($shippingService->formatShowParam($extendMap)),
            'country' => json_encode($country)
        ]);

        return View::fetch();
    }

    /**
     * 删除
     */
    public function del()
    {
        $id = input('param.id');

        $shippingTemplatesModel = new ShippingTemplates();
        $info = $shippingTemplatesModel->updateById([
            'is_del' => 2
        ], $id);
        $info['msg'] = '删除成功';
        return json($info);
    }
}
