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
namespace app\index\validate;

use think\Validate;

class LoginValidate extends Validate
{
    protected $rule = [
        'phone|手机号' => 'require|mobile',
        'password|密码' => 'require|min:6|max:16',
        'code|验证码' => 'require|number'
    ];

    protected $scene = [
        'sendSms' => ['phone'],
        'reg' => ['phone', 'password', 'code'],
        'login_1' => ['phone', 'password'],
        'login_2' => ['phone', 'code'],
    ];
}