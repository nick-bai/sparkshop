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
namespace app\api\validate;

use think\Validate;

class UserValidate extends Validate
{
    protected $rule = [
        'phone|手机号' => 'require',
        'code|验证码' => 'require',
        'password|密码' => 'require',
        'type|模板' => 'require',
        'open_id|openid' => 'require'
    ];
}