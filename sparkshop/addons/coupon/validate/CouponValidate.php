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
namespace addons\coupon\validate;

use think\Validate;

class CouponValidate extends Validate
{
    protected $rule = [
        'name|优惠券名' => 'require',
        'type|优惠券类型' => 'require|number',
        'is_limit_num|发放量限制' => 'require|number',
        'max_receive_num|最多领取数量' => 'require|number',
        'validity_type|有效期类型' => 'require|number',
        'join_goods|参与方式' => 'require|number'
    ];
}