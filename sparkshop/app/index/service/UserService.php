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
namespace app\index\service;

use app\model\user\User;
use app\model\user\UserBalanceLog;
use app\model\user\UserLevel;

class UserService
{
    /**
     * 个人信息
     * @param $param
     * @param $userId
     * @return array
     */
    public function personalData($param, $userId)
    {
        $param['update_time'] = now();

        if (isset($param['phone'])) {
            if (empty($param['phone']) || empty($param['code'])) {
                return dataReturn(-1, "手机号或验证码不能为空");
            }

            // 检测验证码
            $code = cache($param['phone'] . '_reg_sms');
            if ($param['code'] != $code) {
                return dataReturn(-3, "验证码错误");
            }
            cache($param['phone'] . '_reg_sms', null);
            unset($param['code']);
        }

        $userModel = new User();
        return $userModel->updateById($param, $userId);
    }

    /**
     * 我的积分
     * @param $limit
     * @param $userId
     * @return array
     */
    public function getMyScore($limit, $userId)
    {
        $userScoreModel = new UserBalanceLog();
        $list = $userScoreModel->getPageList($limit, ['user_id' => $userId])['data'];

        $userLevelModel = new UserLevel();
        $levelInfo = $userLevelModel->getAllList()['data'];
        $levelMap = [];
        foreach ($levelInfo as $vo) {
            $levelMap[$vo['level']] = $vo['discount'];
        }

        $userModel = new User();
        $userInfo = $userModel->findOne([
            'id' => $userId
        ], 'vip_level,score,useful_score')['data'];

        $userInfo['discount'] = '无折扣';
        if (isset($levelMap[$userInfo['vip_level']])) {
            $userInfo['discount'] = $levelMap[$userInfo['vip_level']] . '%';
        }

        return dataReturn(0, 'success', [
            'list' => $list,
            'userInfo' => $userInfo
        ]);
    }
}