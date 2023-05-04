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

namespace app\admin\validate;

use think\Validate;

class WebsiteLinksValidate extends Validate
{
    protected $rule = [
        'name|友链标题' => 'require',
        'url|友链地址' => 'require',
        'target|打开方式 1:新页面 2:本页面' => 'require',
        'status|状态 1:启用 2:禁用' => 'require',
    ];
}