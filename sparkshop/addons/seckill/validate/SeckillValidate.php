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
namespace addons\seckill\validate;

use think\Validate;

class SeckillValidate extends Validate
{
    protected $rule = [
        'name|商品标题' => 'require|max:150',
        'desc|秒杀活动简介' => 'require|max:200',
        'activity_time|活动日期' => 'require',
        'seckill_time_id|秒杀时间段' => 'require',
        'total_buy_num|购买总数限制' => 'require|number',
        'once_buy_num|单次购买限制' => 'require|number',
        'is_open|活动状态' => 'require|number|in:1,2'
    ];
}