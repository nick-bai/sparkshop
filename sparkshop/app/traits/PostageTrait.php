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

use app\model\system\SetCity;
use app\model\system\ShippingTemplatesRegion;
use app\model\user\UserAddress;

trait PostageTrait
{
    /**
     * 通过模板计算出邮费
     * @param $goodsPostage
     * @param $addressId
     * @return int
     */
    public function getPostageByTpl($goodsPostage, $addressId)
    {
        try {

            $postage = 0;
            $tplIds = []; // 采用的运费模板
            $goods2Tpl = []; // 商品id和模板id的映射
            foreach ($goodsPostage as $key => $vo) {
                // 如果是固定邮费,则直接计算出邮费
                if ($vo['freight'] == 1) {
                    $postage += $vo['num'] * $vo['postage'];
                } else {
                    $tplIds[] = $vo['shipping_tpl_id'];
                    $goods2Tpl[$vo['shipping_tpl_id']][$key] = [
                        'num' => $vo['num'],
                        'weight' => $vo['weight'],
                        'volume' => $vo['volume']
                    ];
                }
            }

            if (empty($tplIds)) {
                return $postage;
            }
            $tplIds = array_unique($tplIds); // 过滤重复的模板

            // 获取本次邮寄的目的地
            $userAddressModel = new UserAddress();
            $addressInfo = $userAddressModel->field('province,city')->where('id', $addressId)->find();
            if (empty($addressInfo)) {
                return 0;
            }

            $province = $addressInfo['province'];
            $city = $addressInfo['city'];

            $setCityModel = new SetCity();
            $provinceId = $setCityModel->field('id')->where('name', $province)->find()['id'];
            $cityId = $setCityModel->field('id')->where('name', $city)->find()['id'];

            $shippingModel = new ShippingTemplatesRegion();
            $shippingList = $shippingModel->whereIn('tpl_id', $tplIds)->select();

            $tplGroup = []; // 模板分组
            foreach ($shippingList as $vo) {
                $tplGroup[$vo['tpl_id']][] = $vo->toArray();
            }

            $tplGroupPostage = [];
            // 确定使用的模板
            foreach ($tplGroup as $key => $val) {
                foreach ($val as $vo) {
                    if ($vo['province_id'] == 0 && $vo['city_id'] == 0) {
                        $tplGroupPostage[$key]['commonMoney'] = $vo; // 全国通用价格
                    } else {
                        $tplGroupPostage[$key]['shippingMap'][$vo['province_id']][$vo['city_id']] = $vo; // 各省市价格
                    }
                }
            }

            // 按照收件地址对比模板选择运送的模板
            $checkedTpl = [];
            foreach ($tplGroupPostage as $key => $shippingMap) {

                if (isset($shippingMap['shippingMap'][$provinceId])) {

                    if (isset($shippingMap['shippingMap'][$provinceId][$cityId])) {

                        $checkedTpl[$key] = $shippingMap['shippingMap'][$provinceId][$cityId];
                    } else if (isset($shippingMap['shippingMap'][$provinceId][0])) {

                        $checkedTpl[$key] = $shippingMap['shippingMap'][$provinceId][0];
                    } else {

                        $checkedTpl[$key] = $shippingMap['commonMoney'];
                    }
                } else {

                    $checkedTpl[$key] = $shippingMap['commonMoney'];
                }
            }

            if (empty($checkedTpl)) {
                return -2;
            }

            // 算出最终的价格
            $postage += $this->calcPostageByType($checkedTpl, $goods2Tpl);

        } catch (\Exception $e) {
            return -1;
        }

        return $postage;
    }

    /**
     * 根据类型计算运费
     * 如一个订单里包含多个商品多个运费模板时，运费计算逻辑是：根据首费最高、增费最低的原则选择首费模板，其余的商品只计算增费。
     * @param $checkedTpl
     * @param $goods2Tpl
     * @return float|int
     */
    private function calcPostageByType($checkedTpl, $goods2Tpl)
    {
        $optTpl = $checkedTpl;
        $optTpl = array_values($optTpl);
        $firstTpl = $optTpl[0];
        unset($optTpl[0]);
        // 确定首费模板
        foreach ($optTpl as $vo) {
            if ($vo['first_price'] > $firstTpl['first_price']) {
                $firstTpl = $vo;
            } else if (($vo['first_price'] == $firstTpl['first_price']) &&
                ($vo['continue_price'] < $firstTpl['continue_price'])) {
                $firstTpl = $vo;
            }
        }

        $finalGoods2Tpl = [];
        // 将相同模板下的商品数据合并
        foreach ($goods2Tpl as $key => $val) {
            $finalGoods2Tpl[$key]['num'] = 0;
            $finalGoods2Tpl[$key]['weight'] = 0;
            $finalGoods2Tpl[$key]['volume'] = 0;

            foreach ($val as $vo) {
                $finalGoods2Tpl[$key]['num'] += $vo['num'];
                $finalGoods2Tpl[$key]['weight'] += $vo['weight'];
                $finalGoods2Tpl[$key]['volume'] += $vo['volume'];
            }
        }

        // 载入购买的商品计算价格
        $continuePrice = 0;
        foreach ($finalGoods2Tpl as $tplId => $item) {

            if ($checkedTpl[$tplId]['type'] == 1) {
                $continuePrice += $this->calcContinuePrice($checkedTpl[$tplId], $item, 'weight');
            } else if ($checkedTpl[$tplId]['type'] == 2) {
                $continuePrice += $this->calcContinuePrice($checkedTpl[$tplId], $item, 'num');
            } else if ($checkedTpl[$tplId]['type'] == 3) {
                $continuePrice += $this->calcContinuePrice($checkedTpl[$tplId], $item, 'volume');
            }
        }

        $postage = round($firstTpl['first_price'] + $continuePrice, 2);
        return $postage;
    }

    private function calcContinuePrice($checkedTpl, $item, $type)
    {
        $continuePrice = 0;
        if ($item[$type] < $checkedTpl['first']) {
            $continuePrice += 0;
        } else {
            $continuePrice += (($item[$type] - $checkedTpl['first']) / $checkedTpl['continue']) * $checkedTpl['continue_price'];
        }

        return $continuePrice;
    }
}