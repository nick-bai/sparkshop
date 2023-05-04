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

class WebsiteSliderValidate extends Validate
{
    protected $rule = [
        'name|轮播描述' => 'require',
        'target_url|链接地址' => 'require',
        'pic_url|图片地址' => 'require',
        'type|链接类型' => 'require',
        'sort|排序值' => 'require',
    ];
}