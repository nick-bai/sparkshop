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

use app\admin\service\HomeService;
use app\admin\service\MenuService;
use app\model\system\AdminNode;
use think\facade\View;

class Index extends Base
{
    public function index()
    {
        if (session('admin_id') != 1) {
            $authMenu = json_decode(session('auth_menu'), true);
        } else {

            $authMenu = makeTree((new MenuService())->getSuperAdminNode());
        }

        View::assign([
            'menu' => json_encode($authMenu)
        ]);

        return View::fetch('/index');
    }

    public function home()
    {
        if (request()->isAjax()) {

            $homeService = new HomeService();
            // 销售数据
            $sellData = $homeService->sellAmountData()['data'];
            // 访问数据
            $pvData = $homeService->userPVData()['data'];
            // 订单量
            $orderData = $homeService->orderData()['data'];
            // 用户注册数据
            $userData = $homeService->userData()['data'];
            // 订单统计图
            $orderChartsData = $homeService->fifteenDayOrderData()['data'];
            // 注册统计图
            $regData = $homeService->registerData()['data'];

            return jsonReturn(0, 'success', compact('sellData', 'pvData', 'orderData', 'userData', 'orderChartsData', 'regData'));
        }

        return View::fetch();
    }
}