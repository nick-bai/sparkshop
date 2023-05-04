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
use addons\coupon\model\CouponGoods;
use addons\coupon\model\CouponReceiveLog;
use addons\coupon\validate\CouponValidate;
use app\model\goods\Goods;
use think\exception\ValidateException;
use think\facade\Db;

class CouponService
{
    public $couponType = [
        1 => '满减券',
        2 => '折扣券'
    ];

    public $couponStatus = [
        1 => '进行中',
        2 => '已作废',
        3 => '已过期',
        4 => '已领完'
    ];

    /**
     * 获取优惠券列表
     * @param $param
     * @return array
     */
    public function getList($param)
    {
        $limit = $param['limit'];
        $status = $param['status'];
        $name = $param['name'];

        $where = [];
        if (!empty($status)) {
            $where[] = ['status', '=', $status];
        }

        if (!empty($name)) {
            $where[] = ['name', 'like', '%' . $name . '%'];
        }

        $couponModel = new Coupon();
        $list = $couponModel->where($where)->order('id desc')->paginate($limit)->each(function ($item) {
            $item->type_txt = $this->couponType[$item->type];
            $item->status_txt = $this->couponStatus[$item->status];
        });

        return dataReturn(0, 'success', $list);
    }

    /**
     * 添加优惠券
     * @param $param
     * @return array
     */
    public function addCoupon($param)
    {
        try {

            validate(CouponValidate::class)->check($param);
        } catch (ValidateException $e) {
            return dataReturn(-1, $e->getError());
        }

        if ($param['type'] == 1) {
            if (empty($param['amount'])) {
                return dataReturn(-2, '优惠券面额需要大于0');
            }
        } else {
            if (empty($param['discount'])) {
                return dataReturn(-3, '优惠折扣需要大于0');
            }
        }

        if ($param['is_limit_num'] == 1 && empty($param['total_num'])) {
            return dataReturn(-4, '发放数量要大于等于0');
        }

        if ($param['is_threshold'] == 1 && (!is_numeric($param['threshold_amount']) || $param['threshold_amount'] < 0)) {
            return dataReturn(-5, '门槛金额要大于等于0');
        }

        if ($param['validity_type'] == 1) {
            if (empty($param['datetime_range'])) {
                return dataReturn(-6, '有效期不能为空');
            } else {
                $param['start_time'] = $param['datetime_range'][0];
                $param['end_time'] = $param['datetime_range'][1];
            }
        } else {
            if (empty($param['receive_useful_day'])) {
                return dataReturn(-7, '领取有效期不能为空');
            }
        }
        unset($param['datetime_range']);

        if ($param['join_goods'] == 2 && empty($param['selectedGoods'])) {
            return dataReturn(-8, '活动商品不能为空');
        }

        Db::startTrans();
        try {

            $joinGoods = $param['selectedGoods'] ?? [];
            unset($param['selectedGoods']);
            $param['create_time'] = now();

            $couponModel = new Coupon();
            $couponId = $couponModel->insertGetId($param);

            if (!empty($joinGoods)) {
                $goodsBatch = [];
                foreach ($joinGoods as $vo) {
                    $goodsBatch[] = [
                        'coupon_id' => $couponId,
                        'goods_id' => $vo,
                        'create_time' => now()
                    ];
                }

                $couponGoodsModel = new CouponGoods();
                $couponGoodsModel->insertBatch($goodsBatch);
            }
            Db::commit();
        } catch (\Exception $e) {
            Db::rollback();
            return dataReturn(-9, $e->getMessage());
        }

        return dataReturn(0, '新增成功');
    }

    /**
     * 获取优惠券关联的商品信息
     * @param $couponId
     * @return array
     */
    public function getCouponGoodsList($couponId)
    {
        $couponGoodsModel = new CouponGoods();
        $list = $couponGoodsModel->getAllList(['coupon_id' => $couponId], 'goods_id')['data'];

        $goodsIds = [];
        foreach ($list as $vo) {
            $goodsIds[] = $vo['goods_id'];
        }

        $goodsModel = new Goods();
        return $goodsModel->getAllList([
            ['id', 'in', $goodsIds]
        ], 'name,price,stock');
    }

    /**
     * 获取可领取的优惠券
     * @param $param
     * @return array
     */
    public function getCanReceiveList($param)
    {
        $couponModel = new Coupon();
        // 一键过期优惠券
        $couponModel->updateByWehere([
            'status' => 3, // 已过期
            'update_time' => now()
        ], [
            ['validity_type', '=', 1],
            ['end_time', '<', now()]
        ]);

        $goodsCouponList = [];
        // 通用券
        $field = 'id,name,type,amount,max_receive_num,validity_type,start_time,end_time,receive_useful_day,is_threshold,threshold_amount,discount';
        $comCouponList = $couponModel->getAllList(['join_goods' => 1, 'status' => 1], $field)['data']->toArray();

        // 商品券
        $couponGoodsModel = new CouponGoods();
        $couponGoodsList = $couponGoodsModel->getAllList([
            ['goods_id', 'in', $param['goods_id']]
        ], 'coupon_id')['data'];

        if (!empty($couponGoodsList)) {
            $couponIds = [];
            foreach ($couponGoodsList as $vo) {
                $couponIds[] = $vo['coupon_id'];
            }

            $goodsCouponList = $couponModel->getAllList([
                ['id', 'in', $couponIds],
                ['status', '=', 1]
            ], $field)['data']->toArray();
        }

        $couponList = array_merge($comCouponList, $goodsCouponList);

        // 用户已经领过的这些券
        $validCouponIds = [];
        foreach ($couponList as $vo) {
            $validCouponIds[] = $vo['id'];
        }

        $userInfo = getUserInfo();
        $userCouponNum = [];
        if (!empty($userInfo)) {
            $couponReceiveLogModel = new CouponReceiveLog();
            $hasReceived = $couponReceiveLogModel->field('coupon_id,count(*) as c_total')->where([
                ['coupon_id', 'in', $validCouponIds],
                ['user_id', '=', $userInfo['id']]
            ])->group('coupon_id')->select()->toArray();

            foreach ($hasReceived as $vo) {
                $userCouponNum[$vo['coupon_id']] = $vo['c_total'];
            }
        }

        // 过滤给前端
        foreach ($couponList as $key => $vo) {
            if (!empty($vo['start_time'])) {
                $couponList[$key]['start_time'] = date('Y-m-d', strtotime($vo['start_time']));
            }

            if (!empty($vo['end_time'])) {
                $couponList[$key]['end_time'] = date('Y-m-d', strtotime($vo['end_time']));
            }

            $couponList[$key]['received'] = 0;
            if (!isset($userCouponNum[$vo['id']])) {
                continue;
            }

            $receivedNum = $userCouponNum[$vo['id']];
            if ($receivedNum >= $vo['max_receive_num'] ) {
                $couponList[$key]['received'] = 1;
            }
        }

        return dataReturn(0, 'success', $couponList);
    }

    /**
     * 获取我的优惠券
     * @param $param
     * @return array
     */
    public function getMyCouponList($param)
    {
        $couponModel = new Coupon();
        // 一键过期优惠券
        $couponModel->updateByWehere([
            'status' => 3, // 已过期
            'update_time' => now()
        ], [
            ['validity_type', '=', 1],
            ['end_time', '<', now()]
        ]);

        if ($param['status'] == 2) {
            $param['status'] = [2, 3];
        }

        $userInfo = getUserInfo();
        $couponReceiveLogModel = new CouponReceiveLog();

        $list = $couponReceiveLogModel->field('code,coupon_id,coupon_name name,start_time,end_time,status')->where([
            ['user_id', '=', $userInfo['id']],
            ['status', 'in', $param['status']]
        ])->order('end_time desc')->paginate($param['limit'])->toArray();

        $couponIds = [];
        foreach ($list['data'] as $vo) {
            $couponIds[] = $vo['coupon_id'];
        }

        $couponModel = new Coupon();
        $couponList = $couponModel->whereIn('id', $couponIds)->with(['couponGoods'])->select()->toArray();

        $couponInfo = [];
        foreach ($couponList as $vo) {
            $couponInfo[$vo['id']] = $vo;
        }

        foreach ($list['data'] as $key => $vo) {

            $info = $couponInfo[$vo['coupon_id']];
            if (!empty($vo['start_time'])) {
                $list['data'][$key]['start_time'] = date('Y-m-d', strtotime($vo['start_time']));
            }

            if (!empty($vo['end_time'])) {
                $list['data'][$key]['end_time'] = date('Y-m-d', strtotime($vo['end_time']));
            }

            $list['data'][$key]['type'] = $info['type'];
            $list['data'][$key]['amount'] = $info['amount'];
            $list['data'][$key]['max_receive_num'] = $info['max_receive_num'];
            $list['data'][$key]['validity_type'] = $info['validity_type'];
            $list['data'][$key]['receive_useful_day'] = $info['receive_useful_day'];
            $list['data'][$key]['is_threshold'] = $info['is_threshold'];
            $list['data'][$key]['threshold_amount'] = $info['threshold_amount'];
            $list['data'][$key]['discount'] = $info['discount'];
        }

        return dataReturn(0, 'success', $list);
    }
}