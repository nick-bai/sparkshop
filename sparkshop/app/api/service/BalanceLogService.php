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
namespace app\api\service;


use app\model\user\User;
use app\model\user\UserBalanceLog;

class BalanceLogService
{
    /**
     * 余额记录
     * @param $param
     * @return array
     */
    public function getBalanceList($param)
    {
        $where[] = ['user_id', '=', $param['user_id']];
        if (!empty($param['type'])) {
            if ($param['type'] == 1) {
                $where[] = ['type', '=', 1];
            } else {
                $where[] = ['type', 'in', [2, 3, 4]];
            }
        }

        $balanceLogModel = new UserBalanceLog();
        $list = $balanceLogModel->where($where)->order('id desc')->paginate($param['limit']);

        return dataReturn(0, 'success', $list);
    }

    /**
     * 获取基础数据
     * @param $param
     * @return array
     */
    public function getTotalInfo($param)
    {
        $where[] = ['id', '=', $param['user_id']];

        $userModel = new User();
        $balance= $userModel->findOne($where, 'balance')['data']->balance;

        $userBalanceLogModel = new UserBalanceLog();
        // 累计充值金额
        $rechargeAmount = $userBalanceLogModel->where('user_id', $param['user_id'])->whereIn('type', [3, 4])->sum('balance');
        // 累计消费金额
        $spendAmount = $userBalanceLogModel->where('user_id', $param['user_id'])->where('type', 1)->sum('balance');

        return dataReturn(0, 'success', compact('balance', 'rechargeAmount', 'spendAmount'));
    }
}