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
namespace addons\seckill\model;

use app\model\BaseModel;

class SeckillActivity extends BaseModel
{
    /**
     * 活动商品
     */
    public function activityGoods()
    {
        return $this->hasMany(SeckillActivityGoods::class, 'activity_id', 'id');
    }
}