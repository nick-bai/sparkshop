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
namespace strategy\pay\impl;

use app\model\user\User;
use strategy\pay\PayInterface;
use Yansongda\Pay\Pay;

class WechatPayImpl implements PayInterface
{
    private $config = [];
    protected $notifyUrl = '';

    public function __construct()
    {
        $formatConfig = getConfByType('wechat_pay');
        $base = getConfByType('base');
        $this->notifyUrl = $base['website_url'] . '/index/notify/wechat';

        $this->config = [
            'app_id' => $formatConfig['wechat_pay_app_id'],
            'mch_id' => $formatConfig['wechat_pay_mchid'],
            'miniapp_id' => $formatConfig['wechat_miniapp_id'],
            'key' => $formatConfig['wechat_pay_key'],
            'notify_url' => $this->notifyUrl,
            'cert_client' => $formatConfig['wechat_pay_cert'],
            'cert_key' => $formatConfig['wechat_pay_pem'],
            'log' => [
                'file' => './logs/wechat.log',
                'level' => 'info',
                'type' => 'single',
                'max_file' => 30,
            ],
            'http' => [
                'timeout' => 5.0,
                'connect_timeout' => 5.0
            ],
            //'mode' => 'dev'
        ];
    }

    public function pay($param)
    {
        $res = Pay::wechat($this->config)->scan([
            'out_trade_no' => $param['out_trade_no'],
            'total_fee' => $param['total_amount'] * 100,
            'body' => mb_substr($param['subject'], 0, 30)
        ]);

        if ($res['result_code'] == 'SUCCESS') {
            return [
                "code" => "200",
                "msg" => "Success",
                "out_trade_no" => $param['out_trade_no'],
                "qr_code" => $res['code_url']
            ];
        } else {
            return $res;
        }
    }

    public function web($param)
    {
        $res = Pay::wechat($this->config)->wap([
            'out_trade_no' => $param['out_trade_no'],
            'total_fee' => $param['total_amount'] * 100,
            'body' => mb_substr($param['subject'], 0, 30)
        ]);

        return $res->getTargetUrl() . '&redirect_url=' . urlencode($param['return_url']);
    }

    public function miniappPay($param)
    {
        $userModel = new User();
        $userInfo = $userModel->findOne(['id' => $param['user_id']])['data'];
        return Pay::wechat($this->config)->miniapp([
            'out_trade_no' => $param['out_trade_no'],
            'total_fee' => $param['total_amount'] * 100,
            'body' => mb_substr($param['subject'], 0, 30),
            'openid' => $userInfo['open_id'],
        ]);
    }

    public function refund($param)
    {
        $order = [
            'out_trade_no' => $param['order_no'],
            'out_refund_no' => $param['refund_order_no'],
            'total_fee' => $param['pay_price'] * 100,
            'refund_fee' => $param['refund_price'] * 100,
            'refund_desc' => $param['order_no'] . '退款',
        ];

        $result = Pay::wechat($this->config)->refund($order);
        if ($result['code'] != 0) {
            return $result;
        }
        return dataReturn(0, 'success', $result);
    }

    public function close($param)
    {

    }

    public function getObject()
    {
        return Pay::wechat($this->config);
    }

    public function setNotifyUrl($url)
    {
        $this->config['notify_url'] = $url;
        return $this;
    }
}