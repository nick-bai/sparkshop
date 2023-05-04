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
namespace strategy\pay;

use strategy\pay\impl\AlipayImpl;
use strategy\pay\impl\BalanceImpl;
use strategy\pay\impl\WechatPayImpl;

class PayProvider
{
    protected $strategy;

    public function __construct($type)
    {
        if ($type == 'alipay') {
            $this->strategy = new AlipayImpl();
        } else if ($type == 'wechat_pay') {
            $this->strategy = new WechatPayImpl();
        } else if ($type == 'balance') {
            $this->strategy = new BalanceImpl();
        }
    }

    public function getStrategy()
    {
        return $this->strategy;
    }

    public function payByPlatform($platform, $payWay, $payParam)
    {
        // pc端支付
        if (empty($platform)) {
            return $this->getStrategy()->pay($payParam);
        }

        // 微信小程序支付
        if ($platform == 'miniapp' && $payWay == 'wechat_pay') {
            return $this->getStrategy()->miniappPay($payParam);
        }

        // 小程序端支付
        if ($platform == 'h5') {
            return $this->getStrategy()->web($payParam);
        }

        // 余额支付
        return $this->getStrategy()->pay($payParam);
    }
}