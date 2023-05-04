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

namespace app\model\order;

use app\model\BaseModel;

class OrderDetail extends BaseModel
{
    public function comment()
    {
        return $this->hasOne(OrderComment::class, 'order_detail_id', 'id');
    }
}