<?php
// +----------------------------------------------------------------------
// | SparkShop 坚持做优秀的商城系统
// +----------------------------------------------------------------------
// | Copyright (c) 2022~2099 http://sparkshop.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://opensource.org/licenses/mit-license.php )
// +----------------------------------------------------------------------
// | Author: NickBai
// +----------------------------------------------------------------------
namespace app\index\controller;

use app\BaseController;
use strategy\notify\NotifyProvider;
use strategy\pay\PayProvider;
use Yansongda\Pay\Log;

class Notify extends BaseController
{
    public function alipay()
    {
        $alipay = (new PayProvider('alipay'))->getStrategy();
        $alipayObj = $alipay->getObject();
        $data = $alipayObj->verify();

        Log::debug('alipay notify', $data->all());
        $notifyProvider = new NotifyProvider($data->out_trade_no);
        $notifyProvider->getStrategy()->dealOrder($data, 1);

        return $alipayObj->success()->send();
    }

    public function wechat()
    {
        $wechatPay = (new PayProvider('wechat_pay'))->getStrategy();
        $wechatPayObj = $wechatPay->getObject();
        $data = $wechatPayObj->verify();

        Log::debug('Wechat notify', $data->all());
        $notifyProvider = new NotifyProvider($data->out_trade_no);
        $notifyProvider->getStrategy()->dealOrder($data, 2);

        return $wechatPayObj->success()->send();
    }
}