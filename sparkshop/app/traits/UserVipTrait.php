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

namespace app\traits;

use app\model\user\User;
use app\model\user\UserLabelRelation;
use app\model\user\UserLevel;

trait UserVipTrait
{
    /**
     * 计算vip优惠
     * @param $payAmount
     * @param $userId
     * @return array
     */
    public function calcUserVip($payAmount, $userId)
    {
        $vipDiscount = 0;
        $vipConf = getConfByType('shop_user_level');
        if ($vipConf['user_level_open'] != 1) {
            return dataReturn(0, 'success', $vipDiscount);
        }

        // 用户等级
        $userModel = new User();
        $userInfo = $userModel->findOne([
            'id' => $userId
        ], 'vip_level')['data'];
        if ($userInfo['vip_level'] == 0) {
            return dataReturn(0, 'success', $vipDiscount);
        }

        // 查询对应的折扣
        $userLevelModel = new UserLevel();
        $vipDiscountInfo = $userLevelModel->findOne([
            'level' => $userInfo['vip_level']
        ], 'discount')['data'];

        if (empty($vipDiscountInfo)) {
            $vipDiscountInfo['discount'] = 0;
        }

        $vipDiscount = round($payAmount - $payAmount * ($vipDiscountInfo['discount'] / 100), 2);

        return dataReturn(0, 'success', $vipDiscount);
    }

    /**
     * 关联用户标签
     * @param $labels
     * @param $userId
     */
    public function linkUserLabel($labels, $userId)
    {
        $labelArr = explode(',', rtrim($labels, ','));

        $userLabelRelationModel = new UserLabelRelation();
        $userLabels = $userLabelRelationModel->getAllList([
            ['user_id', '=', $userId],
            ['label_id', 'in', $labelArr]
        ], 'label_id')['data'];

        $hasLabels = [];
        foreach ($userLabels as $vo) {
            $hasLabels[] = $vo['label_id'];
        }

        // 计算差集
        $newLabel = array_diff($labelArr, $hasLabels);
        $labelMap = [];
        foreach ($newLabel as $vo) {
            $labelMap[] = [
                'user_id' => $userId,
                'label_id' => $vo,
                'create_time' => now()
            ];
        }

        $userLabelRelationModel->insertBatch($labelMap);
    }
}