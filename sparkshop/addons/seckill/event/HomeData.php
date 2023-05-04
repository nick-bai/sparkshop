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

namespace addons\seckill\event;

use addons\seckill\model\SeckillActivity;
use addons\seckill\service\SeckillTimeService;

class HomeData
{
    /**
     *  秒杀首页信息
     * @param $param
     * @return array
     */
    public function handle($param)
    {
        $seckillTimeService = new SeckillTimeService();
        $timeList = $seckillTimeService->getTimeList()['data'];
        $nowHour = date('H');
        $seckillHour = 0;
        $seckillTimeId = 0;
        $continueHour = 0;
        foreach ($timeList as $vo) {

            $datetimeArr = [];
            for ($i = 0; $i < $vo['continue_hour']; $i++) {
                $datetimeArr[] = $vo['start_hour'] + $i;
            }

            if (in_array($nowHour, $datetimeArr)) {
                $seckillTimeId = $vo['id'];
                $seckillHour = $vo['start_hour'];
                $continueHour = $vo['continue_hour'];
                break;
            }
        }

        $seckillModel = new SeckillActivity();
        $list = $seckillModel->field('id,goods_id,goods_rule,pic,name,original_price,seckill_price,stock,sales')
            ->where('status', 2)->where('is_open', 1)
            ->where('seckill_time_id', $seckillTimeId)
            ->where('start_time', '<', now())
            ->where('end_time', '>', now())
            ->limit(3)->select();

        return dataReturn(0, 'success', compact('list', 'seckillHour', 'continueHour'));
    }
}