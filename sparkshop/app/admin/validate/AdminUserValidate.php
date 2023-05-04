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

class AdminUserValidate extends Validate
{
    protected $rule = [
        'name|登录名' => 'require|max:155|alpha',
        'nickname|昵称' => 'require|max:155',
        'password|密码' => 'require|min:6|max:32',
        'avatar|头像' => 'require',
        'status|状态' => 'require'
    ];

    protected $scene = [
        'edit' => ['name', 'nickname', 'avatar', 'status']
    ];
}