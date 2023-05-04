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
namespace strategy\sms;

use strategy\sms\impl\AliSmsImpl;

class SmsProvider
{
    protected $strategy;

    public function __construct($type)
    {
        if ($type == 'ali') {
            $this->strategy = new AliSmsImpl();
        }
    }

    public function getStrategy()
    {
        return $this->strategy;
    }
}