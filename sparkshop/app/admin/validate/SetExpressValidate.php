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

class SetExpressValidate extends Validate
{
    protected $rule = [
        'name|物流公司名称' => 'require',
        'code|物流公司编码' => 'require',
        'status|状态' => 'require',
    ];
}