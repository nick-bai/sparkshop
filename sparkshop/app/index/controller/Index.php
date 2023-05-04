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

use app\index\service\HomeService;
use think\facade\View;

class Index extends Base
{
    /**
     * pc商城首页
     */
    public function index()
    {
        $data = (new HomeService())->getHomeData()['data'];
        View::assign($data);

        return View::fetch();
    }

    public function agreement()
    {
        $type = input('param.type');
        $info = (new HomeService())->getAgreement($type)['data'];

        View::assign([
            'title' => ($type == 1) ? '用户协议' : '隐私协议',
            'info' => $info
        ]);

        return View::fetch();
    }
}