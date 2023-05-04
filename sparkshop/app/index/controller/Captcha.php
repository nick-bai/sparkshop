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

use utils\SparkTools;

class Captcha extends Base
{
    /**
     * 初始化数据
     */
    public function initData()
    {
        $dragWrap = input('post.dragWrap');
        $dragBtn = input('post.dragBtn');

        $slideAreaNum = 8;
        $randRot = rand(30, 270);

        $sucLenMin = (360 - $slideAreaNum - $randRot) * ($dragWrap - $dragBtn) / 360;
        $sucLenMax = (360 + $slideAreaNum - $randRot) * ($dragWrap - $dragBtn) / 360;

        session('captcha', [
            'min' => $sucLenMin,
            'max' => $sucLenMax
        ]);

        return json(['code' => 0, 'data' => [
            'randRot' => $randRot
        ], 'msg' => 'success']);
    }

    /**
     * 验证
     */
    public function verify()
    {
        $disLf = input('post.disLf');
        $phone = input('post.phone');
        $type = input('post.type');

        // 注册校验手机号
        if ($type == 'reg_sms_code') {
            $userModel = new \app\model\user\User();
            $has = $userModel->findOne(['phone' => $phone], 'id')['data'];

            if (!empty($has)) {
                return jsonReturn(0, "该手机号已经注册");
            }
        }

        $verifyData = session('captcha');
        if ($verifyData['min'] <= $disLf && $verifyData['max'] >= $disLf) {
            $res = SparkTools::sendSms(['phone' => $phone, 'type' => $type]);
            $msg = '短信发送成功';
            if ($res['code'] != 0) {
                $msg = $res['msg'];
            }

            return json(['code' => 0, 'data' => [], 'msg' => $msg]);
        }

        return json(['code' => -1, 'data' => [], 'msg' => '验证失败']);
    }
}