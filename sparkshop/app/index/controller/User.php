<?php
// +----------------------------------------------------------------------
// | SparkShop 坚持做优秀的商城系统
// +----------------------------------------------------------------------
// | Copyright (c) 2022~2099 http://sparkshop.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://opensource.org/licenses/mit-license.php )
// +----------------------------------------------------------------------
// | Author: NickBai
// +----------------------------------------------------------------------

namespace app\index\controller;

use app\api\service\OrderService;
use app\index\service\UserService;
use think\facade\View;
use utils\SparkTools;

class User extends Base
{
    public function initialize()
    {
        parent::initialize();
        pcLoginCheck();
    }

    /**
     * 订单列表
     */
    public function index()
    {
        if (request()->isAjax()) {

            $param = input('param.');

            $orderService = new OrderService();
            $res = $orderService->getUserOrderList($param, session('home_user_id'));
            return json($res);
        }

        // 支付方式开启情况
        $payWayConf = SparkTools::getPayWay();

        View::assign([
            'payWayMap' => $payWayConf['payWayMap'],
            'pay_way' => $payWayConf['payWay']
        ]);

        return View::fetch();
    }

    /**
     * 订单详情
     */
    public function detail()
    {
        $id = input('param.id');

        $orderService = new OrderService();
        $res = $orderService->getOrderDetail($id, session('home_user_id'));

        if ($res['code'] != 0) {
            return View::fetch('/404', [
                'error' => $res['msg'],
                'url' => isset(request()->header()['referer']) ? request()->header()['referer'] :  '/'
            ]);
        }

        View::assign($res['data']);
        $vipConf = getConfByType('shop_user_level');

        View::assign([
            'vipConf' => $vipConf
        ]);

        return View::fetch();
    }

    /**
     * 个人资料
     */
    public function personal()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $userService = new UserService();
            $res = $userService->personalData($param, session('home_user_id'));
            if ($res['code'] != 0) {
                return json($res);
            }

            return jsonReturn(0, "编辑成功");
        }

        $userModel = new \app\model\user\User();
        $info = $userModel->findOne([
            'id' => session('home_user_id')
        ])['data'];

        if ($info['sex'] == 0) {
            $info['sex'] = '未知';
        } else if ($info['sex'] == 1) {
            $info['sex'] = '男';
        } else {
            $info['sex'] = '女';
        }

        View::assign([
            'info' => $info
        ]);

        return View::fetch();
    }

    public function address()
    {
        return View::fetch();
    }

    /**
     * 我的积分
     */
    public function score()
    {
        if (request()->isAjax()) {

            $limit = input('param.limit');

            $userService = new UserService();
            $res = $userService->getMyScore($limit, session('home_user_id'));
            return json($res);
        }

        return View::fetch();
    }
}