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
use addons\seckill\validate\SeckillTimeValidate;
use addons\seckill\model\SeckillTime;
use think\exception\ValidateException;

class SeckillTimeService
{
    /**
     * 获取秒杀时间段
     * @param $param
     * @return array
     */
    public function getList($param)
    {
        $limit = $param['limit'];

        $seckillTimeModel = new SeckillTime();
        $status = [
            1 => '有效',
            2 => '无效'
        ];
        $list = $seckillTimeModel->order('sort desc')->paginate($limit)->each(function ($item) use ($status) {
            $item->status_txt = $status[$item->status];
        });

        return dataReturn(0, 'success', $list);
    }

    /**
     * 添加时间段
     * @param $param
     * @return array
     */
    public function addTime($param)
    {
        try {

            validate(SeckillTimeValidate::class)->check($param);
        } catch (ValidateException $e) {
            return dataReturn(-1, $e->getError());
        }

        // 检测时间的有效性
        $addTimeMap = [];
        for ($i = 0; $i < $param['continue_hour']; $i++) {
            $addTimeMap[] = $param['start_hour'] + $i;
        }

        // 旧的规则
        $seckillTimeModel = new SeckillTime();
        $oldData = $seckillTimeModel->getAllList([
            'status' => 1
        ], 'start_hour,continue_hour')['data'];

        $oldTimeArr = [];
        foreach ($oldData as $vo) {
            for ($i = 0; $i < $vo['continue_hour']; $i++) {
                $oldTimeArr[] = $vo['start_hour'] + $i;
            }
        }

        if (!empty(array_intersect($addTimeMap, $oldTimeArr))) {
            return dataReturn(-2, '时段已经存在');
        }

        return $seckillTimeModel->insertOne($param);
    }

    /**
     * 编辑时间段
     * @param $param
     * @return array
     */
    public function editTime($param)
    {
        try {

            validate(SeckillTimeValidate::class)->check($param);
        } catch (ValidateException $e) {
            return dataReturn(-1, $e->getError());
        }

        // 检测时间的有效性
        $addTimeMap = [];
        for ($i = 0; $i < $param['continue_hour']; $i++) {
            $addTimeMap[] = $param['start_hour'] + $i;
        }

        // 旧的规则
        $seckillTimeModel = new SeckillTime();
        $oldData = $seckillTimeModel->getAllList([
            ['status', '=', 1],
            ['id', '<>', $param['id']]
        ], 'start_hour,continue_hour')['data'];

        $oldTimeArr = [];
        foreach ($oldData as $vo) {
            for ($i = 0; $i < $vo['continue_hour']; $i++) {
                $oldTimeArr[] = $vo['start_hour'] + $i;
            }
        }

        if (!empty(array_intersect($addTimeMap, $oldTimeArr))) {
            return dataReturn(-2, '时段已经存在');
        }

        return $seckillTimeModel->updateById($param, $param['id']);
    }

    /**
     * 删除时间段
     * @param $id
     * @return array
     */
    public function delTime($id)
    {
        $seckillActivityModel = new SeckillActivity();
        $has = $seckillActivityModel->findOne([
            'seckill_time_id' => $id
        ])['data'];

        if (!empty($has)) {
            return dataReturn(-1, '该时间段下有秒杀商品不可删除');
        }

        $seckillTimeModel = new SeckillTime();
        return $seckillTimeModel->delById($id);
    }

    /**
     * 秒杀时间段
     * @return array
     */
    public function getTimeList()
    {
        $seckillTimeModel = new SeckillTime();
        // 缓存2小时
        $list = $seckillTimeModel->cache(true, 7200)->where('status', 1)->order('sort desc')->select();

        return dataReturn(0, 'success', $list);
    }
}