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

class UserValidate extends Validate
{
    protected $rule = [
        'nickname|昵称' => 'require',
        'password|用户密码' => 'require',
        'phone|手机号' => 'require',
        'register_time|注册时间' => 'require',
        'status|状态' => 'require',
    ];

    protected $scene = [
        'edit' => ['nickname', 'phone', 'register_time', 'status']
    ];
}