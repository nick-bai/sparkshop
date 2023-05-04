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

namespace app\model\system;

use app\model\BaseModel;

class ShippingTemplatesRegion extends BaseModel
{
    public function province()
    {
        return $this->hasOne(SetCity::class, 'id', 'province_id');
    }

    public function city()
    {
        return $this->hasOne(SetCity::class, 'id', 'city_id');
    }
}
