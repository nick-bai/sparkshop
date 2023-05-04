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

class SetCityValidate extends Validate
{
    protected $rule = [
        'pid|上级' => 'require',
        'name|名称' => 'require',
        'is_show|是否展示' => 'require',
    ];
}