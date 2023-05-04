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
namespace strategy\express;

use strategy\express\impl\AliyunImpl;

class ExpressProvider
{
    protected $strategy;

    public function __construct($type)
    {
        if ($type == 'aliyun') {
            $this->strategy = new AliyunImpl();
        }
    }

    public function getStrategy()
    {
        return $this->strategy;
    }
}