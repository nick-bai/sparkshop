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

namespace app\admin\controller;

use app\admin\service\SystemService;
use app\model\user\UserAgreement;
use think\facade\View;

class System extends Base
{
    /**
     * 基础配置
     */
    public function index()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $systemService = new SystemService();
            $systemService->saveSystem($param);
            return jsonReturn(0, '保存成功');
        }

        View::assign([
            'base' => json_encode(getConfByType('base')),
            'shop_base' => json_encode(getConfByType('shop_base')),
            'shop_user_level' => json_encode(getConfByType('shop_user_level')),
            'shop_refund' => json_encode(getConfByType('shop_refund'))
        ]);

        return View::fetch();
    }

    /**
     * 短信配置
     */
    public function sms()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $systemService = new SystemService();
            $systemService->saveSystem($param);
            return jsonReturn(0, '保存成功');
        }

        View::assign([
            'info' => json_encode(getConfByType('sms'))
        ]);

        return View::fetch();
    }

    /**
     * 支付配置
     */
    public function pay()
    {
        if (request()->isPost()) {

            $param = input('post.');
            if (isset($param['file'])) {
                unset($param['file']);
            }

            $systemService = new SystemService();
            $systemService->saveSystem($param);
            return jsonReturn(0, '保存成功');
        }

        View::assign([
            'alipay' => json_encode(getConfByType('alipay')),
            'wechat' => json_encode(getConfByType('wechat_pay')),
            'balance' => json_encode(getConfByType('balance_pay')),
        ]);

        return View::fetch();
    }

    /**
     * 物流配置
     */
    public function express()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $systemService = new SystemService();
            $systemService->saveSystem($param);
            return jsonReturn(0, '保存成功');
        }

        View::assign([
            'info' => json_encode(getConfByType('express'))
        ]);

        return View::fetch();
    }

    /**
     * 协议配置
     */
    public function agreement()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $userAgreementModel = new UserAgreement();
            $has = $userAgreementModel->findOne([
                'type' => $param['type']
            ], 'id')['data'];

            if (!empty($has)) {
                $userAgreementModel->updateById([
                    'content' => $param['content'],
                    'update_time' => now()
                ], $has['id']);
            } else {
                $userAgreementModel->insertOne([
                    'type' => $param['type'],
                    'content' => $param['content'],
                    'create_time' => now()
                ]);
            }

            return jsonReturn(0 ,'保存成功');
        }

        $userAgreementModel = new UserAgreement();
        $agreementList = $userAgreementModel->getAllList()['data'];

        $agreementMap = [
            1 => '',
            2 => ''
        ];

        if (!empty($agreementList)) {
            foreach ($agreementList as $vo) {
                $agreementMap[$vo['type']] = $vo['content'];
            }
        }

        View::assign([
            'agreementMap' => json_encode($agreementMap)
        ]);

        return View::fetch();
    }

    /**
     * 三方存储配置
     */
    public function store()
    {
        if (request()->isPost()) {
            $param = input('post.');

            $systemService = new SystemService();
            $systemService->saveSystem($param);
            return jsonReturn(0, '保存成功');
        }

        View::assign([
            'store' => json_encode(getConfByType('store')),
            'aliyun' => json_encode(getConfByType('store_oss')),
            'qiniu' => json_encode(getConfByType('store_qiniu')),
            'qcloud' => json_encode(getConfByType('store_tencent')),
        ]);

        return View::fetch();
    }

    public function miniapp()
    {
        if (request()->isPost()) {
            $param = input('post.');

            $systemService = new SystemService();
            $systemService->saveSystem($param);
            return jsonReturn(0, '保存成功');
        }

        View::assign([
            'info' => json_encode(getConfByType('miniapp')),
        ]);

        return View::fetch();
    }
}