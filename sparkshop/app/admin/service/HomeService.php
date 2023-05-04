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
namespace app\admin\service;

use app\model\order\Order;
use app\model\system\Plugins;
use app\model\user\User;
use app\model\user\UserPv;

class HomeService
{
    /**
     * 销售金额数据
     * @return array
     */
    public function sellAmountData()
    {
        try {

            // 今日销售额
            $orderModel = new Order();
            $day = date('Y-m-d');
            $yesterdayData = $orderModel->where('pay_status', 2)->whereBetween('create_time', [
                $day, $day . ' 23:59:59'
            ])->sum('pay_price');
            $yesterdayData = round($yesterdayData, 2);

            // 日销售环比
            $beforeYesterday = date('Y-m-d', strtotime('-1 day'));
            $beforeYesterdayData = $orderModel->where('pay_status', 2)->whereBetween('create_time', [
                $beforeYesterday, $beforeYesterday . ' 23:59:59'
            ])->sum('pay_price'); // 前天销售额
            if ($yesterdayData == 0) {
                $dayRatio = '--';
            } else {
                $dayRatio = round((($yesterdayData - $beforeYesterdayData) / $yesterdayData), 2) * 100;
            }

            // 周环比销售
            $weekDate = date('Y-m-d', strtotime('-7 day'));
            $weekData = $orderModel->where('pay_status', 2)->whereBetween('create_time', [
                $weekDate, $day . ' 23:59:59'
            ])->sum('pay_price'); // 上周销售额

            $preWeekDateStart = date('Y-m-d', strtotime('-14 day'));
            $preWeekDateEnd = date('Y-m-d', strtotime('-8 day'));
            $preWeekData = $orderModel->where('pay_status', 2)->whereBetween('create_time', [
                $preWeekDateStart, $preWeekDateEnd . ' 23:59:59'
            ])->sum('pay_price'); // 上上周销售额
            if ($weekData == 0) {
                $weekRatio = '--';
            } else {
                $weekRatio = round((($weekData - $preWeekData) / $weekData), 2) * 100;
            }

            // 本月销售额
            $monthData = $orderModel->where('pay_status', 2)->where('create_time', '>', date('Y-m-01') . ' 00:00:00')->sum('pay_price');
            $monthData = round($monthData, 2);
            $data = compact('yesterdayData', 'dayRatio', 'weekRatio', 'monthData');

        } catch (\Exception $e) {
            return dataReturn(-1, $e->getMessage());
        }

        return dataReturn(0, 'success', $data);
    }

    /**
     * 用户pv数据
     * @return array
     */
    public function userPVData()
    {
        try {

            // 今日访问数据
            $userPVModel = new UserPv();
            $day = date('Y-m-d');
            $yesterdayData = $userPVModel->whereBetween('create_time', [
                $day, $day . ' 23:59:59'
            ])->count('id');
            $yesterdayData = round($yesterdayData, 2);

            // 日访问数据
            $beforeYesterday = date('Y-m-d', strtotime('-1 day'));
            $beforeYesterdayData = $userPVModel->whereBetween('create_time', [
                $beforeYesterday, $beforeYesterday . ' 23:59:59'
            ])->count('id'); // 前天访问量
            if ($yesterdayData == 0) {
                $dayRatio = '--';
            } else {
                $dayRatio = round((($yesterdayData - $beforeYesterdayData) / $yesterdayData), 2) * 100;
            }

            // 周环比访问
            $weekDate = date('Y-m-d', strtotime('-7 day'));
            $weekData = $userPVModel->whereBetween('create_time', [
                $weekDate, $day . ' 23:59:59'
            ])->count('id'); // 上周访问量

            $preWeekDateStart = date('Y-m-d', strtotime('-14 day'));
            $preWeekDateEnd = date('Y-m-d', strtotime('-8 day'));
            $preWeekData = $userPVModel->whereBetween('create_time', [
                $preWeekDateStart, $preWeekDateEnd . ' 23:59:59'
            ])->count('id'); // 上上周访问量
            if ($weekData == 0) {
                $weekRatio = '--';
            } else {
                $weekRatio = round((($weekData - $preWeekData) / $weekData), 2) * 100;
            }

            // 本月访问
            $monthData = $userPVModel->where('create_time', '>', date('Y-m-01') . ' 00:00:00')->count('id');
            $monthData = round($monthData, 2);
            $data = compact('yesterdayData', 'dayRatio', 'weekRatio', 'monthData');

        } catch (\Exception $e) {
            return dataReturn(-1, $e->getMessage());
        }

        return dataReturn(0, 'success', $data);
    }

    /**
     * 订单数据
     * @return array
     */
    public function orderData()
    {
        try {

            // 今日订单量
            $orderModel = new Order();
            $day = date('Y-m-d');
            $yesterdayData = $orderModel->where('pay_status', 2)->whereBetween('create_time', [
                $day, $day . ' 23:59:59'
            ])->count('id');
            $yesterdayData = round($yesterdayData, 2);

            // 日订单量
            $beforeYesterday = date('Y-m-d', strtotime('-1 day'));
            $beforeYesterdayData = $orderModel->where('pay_status', 2)->whereBetween('create_time', [
                $beforeYesterday, $beforeYesterday . ' 23:59:59'
            ])->count('id'); // 前天订单量
            if ($yesterdayData == 0) {
                $dayRatio = '--';
            } else {
                $dayRatio = round((($yesterdayData - $beforeYesterdayData) / $yesterdayData), 2) * 100;
            }

            // 周环比订单量
            $weekDate = date('Y-m-d', strtotime('-7 day'));
            $weekData = $orderModel->where('pay_status', 2)->whereBetween('create_time', [
                $weekDate, $day . ' 23:59:59'
            ])->count('id'); // 上周订单量

            $preWeekDateStart = date('Y-m-d', strtotime('-14 day'));
            $preWeekDateEnd = date('Y-m-d', strtotime('-8 day'));
            $preWeekData = $orderModel->where('pay_status', 2)->whereBetween('create_time', [
                $preWeekDateStart, $preWeekDateEnd . ' 23:59:59'
            ])->count('id'); // 上上周订单量
            if ($weekData == 0) {
                $weekRatio = '--';
            } else {
                $weekRatio = round((($weekData - $preWeekData) / $weekData), 2) * 100;
            }

            // 本月订单量
            $monthData = $orderModel->where('pay_status', 2)->where('create_time', '>', date('Y-m-01') . ' 00:00:00')->count('id');
            $monthData = round($monthData, 2);
            $data = compact('yesterdayData', 'dayRatio', 'weekRatio', 'monthData');

        } catch (\Exception $e) {
            return dataReturn(-1, $e->getMessage());
        }

        return dataReturn(0, 'success', $data);
    }

    /**
     * 用户注册数据
     * @return array
     */
    public function userData()
    {
        try {

            // 昨日注册量
            $userModel = new User();
            $day = date('Y-m-d');
            $yesterdayData = $userModel->whereBetween('register_time', [
                $day, $day . ' 23:59:59'
            ])->count('id');
            $yesterdayData = round($yesterdayData, 2);

            // 日注册量
            $beforeYesterday = date('Y-m-d', strtotime('-1 day'));
            $beforeYesterdayData = $userModel->whereBetween('register_time', [
                $beforeYesterday, $beforeYesterday . ' 23:59:59'
            ])->count('id'); // 前天注册量
            if ($yesterdayData == 0) {
                $dayRatio = '--';
            } else {
                $dayRatio = round((($yesterdayData - $beforeYesterdayData) / $yesterdayData), 2) * 100;
            }

            // 周环比注册量
            $weekDate = date('Y-m-d', strtotime('-7 day'));
            $weekData = $userModel->whereBetween('register_time', [
                $weekDate, $day . ' 23:59:59'
            ])->count('id'); // 上周注册量

            $preWeekDateStart = date('Y-m-d', strtotime('-14 day'));
            $preWeekDateEnd = date('Y-m-d', strtotime('-8 day'));
            $preWeekData = $userModel->whereBetween('register_time', [
                $preWeekDateStart, $preWeekDateEnd . ' 23:59:59'
            ])->count('id'); // 上上周注册量
            if ($weekData == 0) {
                $weekRatio = '--';
            } else {
                $weekRatio = round((($weekData - $preWeekData) / $weekData), 2) * 100;
            }

            // 本月注册量
            $monthData = $userModel->where('register_time', '>', date('Y-m-01') . ' 00:00:00')->count('id');
            $monthData = round($monthData, 2);
            $data = compact('yesterdayData', 'dayRatio', 'weekRatio', 'monthData');

        } catch (\Exception $e) {
            return dataReturn(-1, $e->getMessage());
        }

        return dataReturn(0, 'success', $data);
    }

    /**
     * 最近15日订单数据
     * @return array
     */
    public function fifteenDayOrderData()
    {
        $start = date('Y-m-d', strtotime('-15 days'));
        $orderNumData = [];
        $orderAmountData = [];
        $timeLine = [];

        for ($i = 15; $i > 0; $i--) {
            $day = date('Y-m-d', strtotime('-' . $i . ' days'));
            $orderNumData[$day] = 0;
            $orderAmountData[$day] = 0;
            $timeLine[] = $day;
        }

        $orderModel = new Order();
        $res = $orderModel->field('DATE_FORMAT(create_time, "%Y-%m-%d") as `day`,count(*) as t_total,sum(pay_price) as amount')
            ->where('pay_status', 2)
            ->where('create_time', '>', $start)
            ->where('create_time', '<', date('Y-m-d') . ' 23:59:59')
            ->group('DATE_FORMAT(create_time, "%Y-%m-%d")')
            ->select();

        if (!empty($res)) {
            foreach ($res as $vo) {
                if (isset($orderNumData[$vo['day']])) {
                    $orderNumData[$vo['day']] = $vo['t_total'];
                    $orderAmountData[$vo['day']] = $vo['amount'];
                }
            }
        }

        return dataReturn(0, 'success', [
           'timeLine' =>  $timeLine,
            'numData' => array_values($orderNumData),
            'amountData' => array_values($orderAmountData),
        ]);
    }

    /**
     * 最近15日注册
     */
    public function registerData()
    {
        $start = date('Y-m-d', strtotime('-15 days'));
        $regNumData = [];
        $timeLine = [];

        for ($i = 15; $i > 0; $i--) {
            $day = date('Y-m-d', strtotime('-' . $i . ' days'));
            $regNumData[$day] = 0;
            $timeLine[] = $day;
        }

        $userModel = new User();
        $res = $userModel->field('DATE_FORMAT(register_time, "%Y-%m-%d") as `day`,count(*) as t_total')
            ->where('register_time', '>', $start)
            ->where('register_time', '<', date('Y-m-d') . ' 23:59:59')
            ->group('DATE_FORMAT(register_time, "%Y-%m-%d")')
            ->select();

        if (!empty($res)) {
            foreach ($res as $vo) {
                if (isset($regNumData[$vo['day']])) {
                    $regNumData[$vo['day']] = $vo['t_total'];
                }
            }
        }

        return dataReturn(0, 'success', [
            'timeLine' =>  $timeLine,
            'numData' => array_values($regNumData),
        ]);
    }
}