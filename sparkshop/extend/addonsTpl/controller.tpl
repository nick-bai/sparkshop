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

namespace addons\<<pluginName>>\controller\<<moduleName>>;

use app\PluginBaseController;

class Index extends PluginBaseController
{
    public function index()
    {
        if (request()->isAjax()) {

            $param = input('param.');

            return jsonReturn(0, '请求成功');
        }

        return fetch();
    }
}