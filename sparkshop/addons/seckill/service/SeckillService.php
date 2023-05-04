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
namespace addons\seckill\service;

use addons\seckill\model\SeckillActivity;
use addons\seckill\model\SeckillActivityGoods;
use addons\seckill\model\SeckillTime;
use addons\seckill\validate\SeckillValidate;
use app\model\goods\Goods;
use app\model\goods\GoodsContent;
use app\model\goods\GoodsRuleExtend;
use think\exception\ValidateException;
use think\facade\Db;

class SeckillService
{
    // 活动状态
    protected $activityStatus = [
        1 => '未开启',
        2 => '进行中',
        3 => '已结束'
    ];

    // 秒杀的商品规格key %u: activity_id, %u: sku
    protected $seckillKey = 'seckill:%u:%s';

    // 秒杀限制信息key %u: activity_id
    protected $seckillLimitKey = 'seckill_limit:%u';

    /**
     * 秒杀商品列表
     * @param $param
     */
    public function getList($param)
    {
        $seckillTimeModel = new SeckillActivity();
        // 一键关闭过期的
        $seckillTimeModel->updateByWehere([
            'status' => 3, // 已结束
            'update_time' => now()
        ], [
            ['end_time', '<', date('Y-m-d H:i:s')],
            ['status', '=', 1],
            ['is_open', '=', 1]
        ]);

        $limit = $param['limit'];
        $name = input('param.name');

        $where = [];
        if (!empty($name)) {
            $where[] = ['name', 'like', '%' . $name . '%'];
        }

        $activityStatus = $this->activityStatus;
        $list = $seckillTimeModel->where($where)->order('id desc')->paginate($limit)->each(function ($item) use ($activityStatus) {
            $item->status_txt = $activityStatus[$item->status];
        });
        return dataReturn(0, 'success', $list);
    }

    /**
     * 添加秒杀商品
     * @param $param
     * @return array
     */
    public function addSeckillGoods($param)
    {
        $checkParam = $this->checkParam($param);
        if ($checkParam['code'] != 0) {
            return $checkParam;
        }

        $timeMap = $param['activity_time'];

        Db::startTrans();
        try {

            $ttl = strtotime($timeMap[1]) - time() + 60 * 5; // 有效期

            $activity = [
                'goods_id' => $param['goods_id'],
                'goods_rule' => $param['goods_rule'],
                'pic' => $param['pic'],
                'name' => $param['name'],
                'desc' => $param['desc'],
                'start_time' => $timeMap[0],
                'end_time' => $timeMap[1],
                'seckill_time_id' => $param['seckill_time_id'],
                'total_buy_num' => $param['total_buy_num'],
                'once_buy_num' => $param['once_buy_num'],
                'seckill_goods_rule' => '', // 选择的商品规格
                'status' => ($param['is_open'] == 1) ? 2 : 1,
                'is_open' => $param['is_open'],
                'create_time' => now()
            ];

            $activityModel = new SeckillActivity();
            $activityRes = $activityModel->insertOne($activity);
            if ($activityRes['code'] != 0) {
                Db::rollback();
                return dataReturn(-5, $activityRes['msg']);
            }

            $redis = getRedisHandler();
            $activityGoods = [];
            $originalPrice = 0;
            $stock = 0;
            $seckillPrice = 0;
            // 单规格商品
            if ($param['goods_rule'] == 1) {

                $activityGoods[] = [
                    'activity_id' => $activityRes['data'],
                    'goods_id' => $param['goods_id'],
                    'sku' => '',
                    'image' => $param['pic'],
                    'goods_price' => $param['goods_price'],
                    'seckill_price' => $param['seckill_price'],
                    'stock' => $param['stock'],
                    'create_time' => now()
                ];

                $originalPrice = $param['goods_price'];
                $stock += $param['stock'];
                $seckillPrice = $param['seckill_price'];
                $key = sprintf($this->seckillKey, $activityRes['data'], '');
                $redis->del($key);
                $redis->set($key, $param['stock']);
                $redis->expire($key, $ttl);
            } else {
                // 多规格商品
                $selectedRules = [];
                foreach ($param['final'] as $vo) {

                    $sku = implode('※', $vo['sku']);
                    $activityGoods[] = [
                        'activity_id' => $activityRes['data'],
                        'sku' => $sku,
                        'goods_id' => $vo['goods_id'],
                        'image' => $vo['image'],
                        'goods_price' => $vo['goods_price'],
                        'seckill_price' => $vo['seckill_price'],
                        'stock' => $vo['stock'],
                        'create_time' => now()
                    ];

                    foreach ($vo['sku'] as $key => $v) {
                        $selectedRules[$key][] = $v;
                    }

                    $originalPrice = $vo['goods_price'];
                    $stock += $vo['stock'];
                    $seckillPrice = $vo['seckill_price'];
                    $key = sprintf($this->seckillKey, $activityRes['data'], $sku);
                    $redis->del($key);
                    $redis->set($key, $vo['stock']);
                    $redis->expire($key, $ttl);
                }

                // 选中的规格
                foreach ($param['rule'] as $key => $vo) {
                    $param['rule'][$key]['item'] = array_values(array_intersect($vo['item'], $selectedRules[$key]));
                }

                $activityModel->updateById([
                    'seckill_goods_rule' => json_encode($param['rule'])
                ], $activityRes['data']);
            }

            // 设置单次购买数量限制
            $limitKey = sprintf($this->seckillLimitKey, $activityRes['data'], $param['goods_id']);
            $seckillTimeModel = new SeckillTime();
            $startHourInfo = $seckillTimeModel->findOne([
                'id' => $param['seckill_time_id']
            ])['data'];

            $startHour = [];
            $start = $startHourInfo['start_hour'];
            for ($i = 0; $i < $startHourInfo['continue_hour']; $i++) {
                $startHour[] = $start + $i;
            }

            $redis->del($limitKey);
            $redis->setex($limitKey, $ttl, json_encode([
                'once_buy_num' => $param['once_buy_num'],
                'total_buy_num' => $param['total_buy_num'],
                'start_time' => $timeMap[0],
                'end_time' => $timeMap[1],
                'start_hour' => $startHour
            ]));

            // 写入活动商品
            $seckillActivityGoodsModel = new SeckillActivityGoods();
            $res = $seckillActivityGoodsModel->insertBatch($activityGoods);
            if ($res['code'] != 0) {
                Db::rollback();
                return dataReturn(-6, $res['msg']);
            }

            $activityModel->updateById([
                'original_price' => $originalPrice,
                'seckill_price' => $seckillPrice,
                'stock' => $stock
            ], $activityRes['data']);

            Db::commit();
        } catch (\Exception $e) {
            Db::rollback();
            return dataReturn(-10, $e->getMessage() . '|' . $e->getFile() . '|' . $e->getLine());
        }

        return dataReturn(0, '添加成功');
    }

    /**
     * 编辑秒杀商品
     * @param $param
     * @return array
     */
    public function editSeckillGoods($param)
    {
        $checkParam = $this->checkParam($param);
        if ($checkParam['code'] != 0) {
            return $checkParam;
        }

        $timeMap = $param['activity_time'];

        Db::startTrans();
        try {

            $ttl = strtotime($timeMap[1]) - time() + 60 * 5; // 有效期

            $activityModel = new SeckillActivity();
            $info = $activityModel->with('activityGoods')->where('id', $param['id'])->find();

            $seckillTimeModel = new SeckillTime();
            $startHourInfo = $seckillTimeModel->findOne([
                'id' => $param['seckill_time_id']
            ])['data'];

            $startHour = [];
            $start = $startHourInfo['start_hour'];
            for ($i = 0; $i < $startHourInfo['continue_hour']; $i++) {
                $startHour[] = $start + $i;
            }

            // 限制进行中的活动不得更改，防止数据错乱
            if ($info['start_time'] < now() && $info['end_time'] > now() && in_array(date('H'), $startHour) &&
                ($info['seckill_time_id'] == $param['seckill_time_id'])) {
                return dataReturn(-1, '该活动时间正在进行中，不可修改');
            }

            $activity = [
                'goods_id' => $param['goods_id'],
                'goods_rule' => $param['goods_rule'],
                'pic' => $param['pic'],
                'name' => $param['name'],
                'desc' => $param['desc'],
                'start_time' => $timeMap[0],
                'end_time' => $timeMap[1],
                'seckill_time_id' => $param['seckill_time_id'],
                'total_buy_num' => $param['total_buy_num'],
                'once_buy_num' => $param['once_buy_num'],
                'status' => ($param['is_open'] == 1) ? 2 : 1,
                'is_open' => $param['is_open'],
                'update_time' => now()
            ];

            $activityRes = $activityModel->updateById($activity, $param['id']);
            if ($activityRes['code'] != 0) {
                Db::rollback();
                return dataReturn(-5, $activityRes['msg']);
            }

            $redis = getRedisHandler();
            $activityGoods = [];
            $originalPrice = 0;
            $stock = 0;
            $seckillPrice = 0;
            // 单规格
            if ($param['goods_rule'] == 1) {

                $activityGoods[] = [
                    'activity_id' => $param['id'],
                    'goods_id' => $param['goods_id'],
                    'image' => $param['pic'],
                    'seckill_price' => $param['seckill_price'],
                    'goods_price' => $param['goods_price'],
                    'stock' => $param['stock'],
                    'create_time' => now()
                ];

                $originalPrice = $param['goods_price'];
                $stock += $param['stock'];
                $seckillPrice = $param['seckill_price'];
                $key = sprintf($this->seckillKey, $param['id'], '');
                $redis->del($key);
                $redis->set($key, $param['stock']);
                $redis->expire($key, $ttl);
            } else { // 多规格
                // 移除旧的key
                foreach ($info['activityGoods'] as $vo) {
                    $key = sprintf($this->seckillKey, $param['id'], $vo['sku']);
                    $redis->del($key);
                }

                $selectedRules = [];
                foreach ($param['final'] as $vo) {

                    $sku = implode('※', $vo['sku']);
                    $activityGoods[] = [
                        'activity_id' => $param['id'],
                        'sku' => $sku,
                        'goods_id' => $vo['goods_id'],
                        'image' => $vo['image'],
                        'goods_price' => $vo['goods_price'],
                        'seckill_price' => $vo['seckill_price'],
                        'stock' => $vo['stock'],
                        'create_time' => now()
                    ];

                    foreach ($vo['sku'] as $key => $v) {
                        $selectedRules[$key][] = $v;
                    }

                    $originalPrice = $vo['goods_price'];
                    $stock += $vo['stock'];
                    $seckillPrice = $vo['seckill_price'];
                    $key = sprintf($this->seckillKey, $param['id'], $sku);
                    $redis->set($key, $vo['stock']);
                    $redis->expire($key, $ttl);
                }

                // 选中的规格
                foreach ($param['rule'] as $key => $vo) {
                    $param['rule'][$key]['item'] = array_values(array_intersect($vo['item'], $selectedRules[$key]));
                }

                $activityModel->updateById([
                    'seckill_goods_rule' => json_encode($param['rule'])
                ], $activityRes['data']);
            }

            // 设置单次购买数量限制
            $limitKey = sprintf($this->seckillLimitKey, $param['id'], $param['goods_id']);
            $redis->del($limitKey);
            $redis->setex($limitKey, $ttl, json_encode([
                'once_buy_num' => $param['once_buy_num'],
                'total_buy_num' => $param['total_buy_num'],
                'start_time' => $timeMap[0],
                'end_time' => $timeMap[1],
                'start_hour' => $startHour
            ]));

            $seckillActivityGoodsModel = new SeckillActivityGoods();
            // 删除旧的数据
            $seckillActivityGoodsModel->delByWhere([
                'activity_id' => $param['id']
            ]);
            // 写入活动商品
            $res = $seckillActivityGoodsModel->insertBatch($activityGoods);
            if ($res['code'] != 0) {
                Db::rollback();
                return dataReturn(-6, $res['msg']);
            }

            $activityModel->updateById([
                'original_price' => $originalPrice,
                'seckill_price' => $seckillPrice,
                'stock' => $stock
            ], $param['id']);

            Db::commit();
        } catch (\Exception $e) {
            Db::rollback();
            return dataReturn(-10, $e->getMessage());
        }

        return dataReturn(0, '编辑成功');
    }

    /**
     * 删除秒杀数据
     * @param $id
     */
    public function delSeckill($id)
    {
        $activityModel = new SeckillActivity();
        $info = $activityModel->with('activityGoods')->where('id', $id)->find();

        $seckillTimeModel = new SeckillTime();
        $startHourInfo = $seckillTimeModel->findOne([
            'id' => $info['seckill_time_id']
        ])['data'];

        $startHour = [];
        $start = $startHourInfo['start_hour'];
        for ($i = 0; $i < $startHourInfo['continue_hour']; $i++) {
            $startHour[] = $start + $i;
        }

        // 限制进行中的活动不得更改，防止数据错乱
        if ($info['start_time'] < now() && $info['end_time'] > now() && in_array(date('H'), $startHour)) {
            return dataReturn(-1, '该活动正在进行中，不可删除');
        }

        $redis = getRedisHandler();
        // 移除旧的key
        foreach ($info['activityGoods'] as $vo) {
            $key = sprintf($this->seckillKey,  $info['id'], $vo['sku']);
            $redis->del($key);
        }

        $limitKey = sprintf($this->seckillLimitKey, $info['id'], $info['goods_id']);
        $redis->del($limitKey);

        $activityModel->delById($id);
        $seckillActivityModel = new SeckillActivityGoods();
        $seckillActivityModel->delByWhere([
            'activity_id' => $id
        ]);

        return dataReturn(0, '删除成功');
    }

    /**
     * 秒杀信息列表
     * @param $param
     * @return array
     */
    public function getSeckillList($param)
    {
        $limit = $param['limit'];
        $checkTime = $param['time'];

        $seckillTimeModel = new SeckillTimeService();
        $timeList = $seckillTimeModel->getTimeList()['data']->toArray();

        $nowHour = empty($checkTime) ? date('H') : intval(date('H', strtotime($checkTime)));
        $seckillHour = 0;
        $seckillTimeId = 0;
        $active = 0;
        $timeLine = [];
        // 限制显示4条
        $offsetLimit = 4;
        $realHour = date('H');

        // 按限制条数整理数据
        $finalTimeLine = [];
        $slices = ceil(count($timeList) / $offsetLimit);
        for ($i = 0; $i < $slices; $i++) {
            $finalTimeLine[] = array_slice($timeList, $i * $offsetLimit, $offsetLimit);
        }

        $hasMatch = false;
        foreach ($finalTimeLine as $v) {

            foreach ($v as $key => $vo) {

                if ($nowHour >= $vo['start_hour'] && $nowHour < ($vo['start_hour'] + $vo['continue_hour'])) {
                    $seckillTimeId = $vo['id'];
                    $seckillHour = $vo['start_hour'];

                    $active = $key;

                    foreach ($v as $time => $val) {
                        $realHour = intval($realHour);
                        $runTime = $val['start_hour'] + $val['continue_hour'];
                        $hour = $val['start_hour'] < 10 ? '0' . $val['start_hour'] : $val['start_hour'];
                        $hour .= ':00';
                        $timeLine[$time]['start_hour'] = $hour;

                        if ($realHour >= $val['start_hour'] && $realHour < $runTime) {
                            $timeLine[$time]['status'] = 2; // 进行中
                        } else if ($realHour >= $runTime) {
                            $timeLine[$time]['status'] = 3; // 已结束
                        } else {
                            $timeLine[$time]['status'] = 1; // 未开始
                        }
                    }
                    $hasMatch = true;
                    break;
                }
            }

            if ($hasMatch) {
                break;
            }
        }

        $seckillModel = new SeckillActivity();
        $list = $seckillModel->field('id,goods_id,goods_rule,pic,name,original_price,seckill_price,stock,sales,status')
            ->where('status', 2)->where('is_open', 1)
            ->where('seckill_time_id', $seckillTimeId)
            ->where('start_time', '<', now())
            ->where('end_time', '>', now())
            ->paginate($limit);

        return dataReturn(0, 'success', [
            'start_hour' => $seckillHour,
            'active' => $active,
            'list' => $list,
            'time_line' => $timeLine
        ]);
    }

    /**
     * 秒杀商品详情
     * @param $id
     * @return array
     */
    public function seckillDetail($id)
    {
        // 检测秒杀参数的合法性
        $res = (new OrderService())->checkSeckill($id);
        if ($res['code'] != 0) {
            return $res;
        }

        $seckillInfo = $res['data']['info'];
        // 规格信息
        $ruleInfo = (new SeckillActivityGoods())->getAllList([
            ['goods_id', '=', $seckillInfo['goods_id']],
            ['activity_id', '=', $id],
            ['stock', '>', 0]
        ], 'goods_price,image,sales,seckill_price,sku,stock', 'id asc')['data'];
        // 商品详情
        $content = (new GoodsContent())->findOne(['goods_id' => $seckillInfo['goods_id']])['data'];

        return dataReturn(0, 'success', [
            'content' => $content['content'],
            'goodsRuleMap' => $ruleInfo,
            'activity' => [
                'stock' => $seckillInfo['stock'],
                'sales' => $seckillInfo['sales'],
                'spec' => $seckillInfo['goods_rule'],
                'name' => $seckillInfo['name'],
                'once_buy_num' => $seckillInfo['once_buy_num']
            ],
            'goodsRule' => [
                'rule' => json_decode($seckillInfo['seckill_goods_rule'], true)
            ]
        ]);
    }

    /**
     * 检测参数
     * @param $param
     * @return array
     */
    protected function checkParam($param)
    {
        try {

            validate(SeckillValidate::class)->check($param);
        } catch (ValidateException $e) {
            return dataReturn(-1, $e->getError());
        }

        if ($param['total_buy_num'] < $param['once_buy_num']) {
            return dataReturn(-9, '购买总是限制不得小于单次购买限制');
        }

        // 单规格
        if ($param['goods_rule'] == 1) {

            if (!isset($param['seckill_price']) || empty($param['seckill_price'])) {
                return dataReturn(-2, '选择的规格，秒杀价应大于等于0');
            }

            if (!is_numeric($param['stock']) || $param['stock'] < 0) {
                return dataReturn(-3, '选择的规格，限量应该大于等于0');
            }

            if ($param['stock'] > $param['goods_stock']) {
                return dataReturn(-4, '限量库存不得大于商品库存');
            }
        } else { // 多规格

            foreach ($param['final'] as $vo) {
                if (!is_numeric($vo['seckill_price']) || $vo['seckill_price'] < 0) {
                    return dataReturn(-6, '选择的规格，秒杀价应大于等于0');
                }

                if (!is_numeric($vo['stock']) || $vo['stock'] < 0) {
                    return dataReturn(-7, '选择的规格，限量应该大于等于0');
                }

                if ($vo['stock'] > $vo['goods_stock']) {
                    return dataReturn(-8, '限量库存不得大于商品库存');
                }
            }
        }

        return dataReturn(0);
    }

    /**
     * 构建编辑参数
     * @param $activityId
     * @return array
     */
    public function buildEditParam($activityId)
    {
        $seckillTimeModel = new SeckillTime();
        $list = $seckillTimeModel->getAllList([
            'status' => 1
        ], '*', 'sort desc')['data'];

        $activityModel = new SeckillActivity();
        $activityInfo = $activityModel->with(['activityGoods'])->where('id', $activityId)->find();

        // 多规格商品
        if ($activityInfo['goods_rule'] == 2) {
            $goodsRuleExtendModel = new GoodsRuleExtend();
            $ruleList = $goodsRuleExtendModel->getAllList(['goods_id' => $activityInfo['goods_id']])['data'];
            $sku2Stock = [];
            foreach ($ruleList as $vo) {
                $sku2Stock[$vo['sku']] = $vo['stock'];
            }

            foreach ($activityInfo['activityGoods'] as $key => $vo) {
                $activityInfo['activityGoods'][$key]['goods_stock'] = $sku2Stock[$vo['sku']] ?? 0;
            }
        } else { // 单规格商品

            $goodsModel = new Goods();
            $info = $goodsModel->findOne(['id' => $activityInfo['goods_id']])['data'];

            foreach ($activityInfo['activityGoods'] as $key => $vo) {
                $activityInfo['activityGoods'][$key]['goods_stock'] = $info->stock;
            }
        }

        return dataReturn(0, 'success', [
            'seckill_time' => $list,
            'jsonInfo' => $activityInfo['activityGoods']
        ]);
    }
}