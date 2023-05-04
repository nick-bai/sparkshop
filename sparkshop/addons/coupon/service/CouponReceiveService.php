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

namespace addons\coupon\service;

use addons\coupon\model\Coupon;
use addons\coupon\model\CouponReceiveLog;
use think\facade\Db;

class CouponReceiveService
{
    public $receiveCouponStatus = [
        1 => '未使用',
        2 => '已使用',
        3 => '已过期'
    ];

    /**
     * 获取我的可用的优惠券
     * @param $param
     * @return array
     */
    public function getMyCoupon($param)
    {
        $goodsLimit = [];
        $goods = json_decode($param['goods'], true);
        foreach ($goods as $vo) {
            $goodsLimit[$vo['goods_id']] = 1;
        }

        // 一键设置过期
        $couponReceiveLogModel = new CouponReceiveLog();
        $couponReceiveLogModel->updateByWehere([
            'status' => 3,
            'update_time' => now()
        ], ['end_time', '<', now()]);

        $userInfo = getUserInfo();
        $list = $couponReceiveLogModel->field('code,coupon_id,coupon_name name,start_time,end_time')->where([
            ['user_id', '=', $userInfo['id']],
            ['status', '=', 1]
        ])->order('end_time desc')->select()->toArray();

        $couponIds = [];
        foreach ($list as $vo) {
            $couponIds[] = $vo['coupon_id'];
        }

        $couponModel = new Coupon();
        $couponList = $couponModel->whereIn('id', $couponIds)->with(['couponGoods'])->select()->toArray();
        // 优惠券商品限制
        $couponGoodsLimit = [];
        $couponInfo = [];
        foreach ($couponList as $vo) {
            $couponInfo[$vo['id']] = $vo;
            if (!empty($vo['couponGoods'])) {
                foreach ($vo['couponGoods'] as $v) {
                    $couponGoodsLimit[$vo['id']][] = $v['id'];
                }
            }
        }

        // 查出不可使用的优惠券
        $cannotUse = [];
        foreach ($couponGoodsLimit as $key => $vo) {

            $has = false;
            foreach ($vo as $v) {
               if (isset($goodsLimit[$v])) {
                   $has = true;
                   break;
               }
            }

            if (!$has) {
                $cannotUse[$key] = 1;
            }
        }

        // 删掉我手上不可使用的优惠券,补全优惠券信息
        foreach ($list as $key => $vo) {
            if (isset($cannotUse[$vo['coupon_id']])) {
                unset($list[$key]);
                continue;
            }

            $info = $couponInfo[$vo['coupon_id']];
            // 判断门槛
            if ($info['is_threshold'] == 1 && $param['amount'] < $info['threshold_amount']) {
                unset($list[$key]);
                continue;
            }

            if (!empty($vo['start_time'])) {
                $list[$key]['start_time'] = date('Y-m-d', strtotime($vo['start_time']));
            }

            if (!empty($vo['end_time'])) {
                $list[$key]['end_time'] = date('Y-m-d', strtotime($vo['end_time']));
            }

            $list[$key]['type'] = $info['type'];
            $list[$key]['amount'] = $info['amount'];
            $list[$key]['max_receive_num'] = $info['max_receive_num'];
            $list[$key]['validity_type'] = $info['validity_type'];
            $list[$key]['receive_useful_day'] = $info['receive_useful_day'];
            $list[$key]['is_threshold'] = $info['is_threshold'];
            $list[$key]['threshold_amount'] = $info['threshold_amount'];
            $list[$key]['discount'] = $info['discount'];
        }

        return dataReturn(0, 'success', $list);
    }

    /**
     * 获取优惠券领取日志
     * @param $param
     * @return array
     */
    public function getCouponReceiveLog($param)
    {
        $limit = $param['limit'];
        $status = $param['status'];
        $userName = $param['user_name'];

        $where = [];
        if (!empty($status)) {
            $where[] = ['status', '=', $status];
        }

        if (!empty($userName)) {
            $where[] = ['user_name', 'like', '%' . $userName . '%'];
        }

        $couponModel = new CouponReceiveLog();
        $list = $couponModel->with('coupon')->where($where)->order('id desc')->paginate($limit)->each(function ($item) {
            $item->status_txt = $this->receiveCouponStatus[$item->status];
        });

        return dataReturn(0, 'success', $list);
    }

    /**
     * 用户领取优惠券
     * @param $param
     * @return array
     */
    public function userReceive($param)
    {
        Db::startTrans();
        try {

            $couponModel = new Coupon();
            // 一键过期优惠券
            $couponModel->updateByWehere([
                'status' => 3, // 已过期
                'update_time' => now()
            ], [
                ['validity_type', '=', 1],
                ['end_time', '<', now()]
            ]);

            // 查询优惠券信息
            $info = $couponModel->where('id', $param['id'])->where('status', 1)->lock(true)->find();
            if (empty($info)) {
                Db::commit();
                return dataReturn(-1, '优惠券异常');
            }

            // 检测是否还可以领取
            if ($info['is_limit_num'] == 1 && $info['received_num'] >= $info['total_num']) {
                $couponModel->updateByWehere([
                    'status' => 4, // 已领取完
                    'update_time' => now()
                ], ['id' => $info['id']]);

                Db::commit();
                return dataReturn(-2, '优惠券已经领取完了');
            }

            $userInfo = getUserInfo();
            $couponReceiveLog = new CouponReceiveLog();

            // 查询自己是否还可以再领
            $userHasReceived = $couponReceiveLog->where('user_id', $userInfo['id'])->where('coupon_id', $info['id'])->count('id');
            if ($userHasReceived >= $info['max_receive_num']) {
                return dataReturn(-5, '您不可以再领取该优惠券了');
            }

            $startDate = '';
            $endDate = '';
            if ($info['validity_type'] == 1) {
                $startDate = $info['start_time'];
                $endDate = $info['end_time'];
            } else if ($info['validity_type'] == 2) {
                $startDate = now();
                $endDate = date('Y-m-d H:i:s', strtotime('+' . $info['receive_useful_day'] . ' days'));
            }

            // 记录领取
            $couponReceiveLog->insert([
                'code' => uniqid(),
                'coupon_id' => $info['id'],
                'coupon_name' => $info['name'],
                'user_id' => $userInfo['id'],
                'user_name' => $userInfo['name'],
                'status' => 1,
                'start_time' => $startDate,
                'end_time' => $endDate,
                'create_time' => now()
            ]);

            if ($info['received_num'] + 1 == $info['total_num']) {
                $couponModel->updateByWehere([
                    'status' => 4, // 已领取完
                    'update_time' => now()
                ], ['id' => $info['id']]);
            }

            // 变更数量
            $couponModel->where('id', $info['id'])->inc('received_num', 1)->update();

            Db::commit();
        } catch (\Exception $e) {
            Db::rollback();
            return dataReturn(-10, '领取失败');
        }

        return dataReturn(0, '领取成功');
    }
}