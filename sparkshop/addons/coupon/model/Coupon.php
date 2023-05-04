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
namespace addons\coupon\model;

use app\model\BaseModel;

class Coupon extends BaseModel
{
    public function goods()
    {
        return $this->hasMany(CouponGoods::class, 'coupon_id', 'id');
    }

    public function couponGoods()
    {
        return $this->hasMany(CouponGoods::class, 'coupon_id', 'id')->visible(['id']);
    }
}