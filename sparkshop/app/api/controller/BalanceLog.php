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
namespace app\api\controller;

use app\api\service\BalanceLogService;

class BalanceLog extends Base
{
    /**
     * 余额记录
     */
    public function index()
    {
        $param = input('param.');
        $param['user_id'] = $this->user['id'];

        $balanceLogService = new BalanceLogService();
        return json($balanceLogService->getBalanceList($param));
    }

    /**
     * 获取基础信息
     */
    public function getTotalInfo()
    {
        $param = input('param.');
        $param['user_id'] = $this->user['id'];

        $balanceLogService = new BalanceLogService();
        return json($balanceLogService->getTotalInfo($param));
    }
}