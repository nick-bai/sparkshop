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

class OrderRefund extends BaseModel
{
    public function orderInfo()
    {
        return $this->hasOne(Order::class, 'id', 'order_id')->visible(['create_time', 'remark', 'pay_status', 'pay_way']);
    }
}