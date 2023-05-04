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

use app\model\goods\Goods;
use app\model\goods\GoodsRuleExtend;
use app\model\system\Cart;

class CartService
{
    /**
     * 添加购物车
     * @param $param
     * @param $userId
     * @return array
     */
    public function addCart($param, $userId)
    {
        try {

            $goodsModel = new Goods();
            $goodsInfo = $goodsModel->where('id', $param['goods_id'])->where('is_del', 2)->find();
            if (empty($goodsInfo)) {
                return dataReturn(-1, "该商品不存在");
            }

            $cartModel = new Cart();
            // 多规格
            if ($goodsInfo['spec'] == 2) {

                $goodsRuleExtendModel = new GoodsRuleExtend();
                $ruleInfo = $goodsRuleExtendModel->where('goods_id', $param['goods_id'])
                    ->where('sku', implode('※', $param['rule']))->find();

                if (empty($ruleInfo)) {
                    return dataReturn(-2, "该商品不存在");
                }

                if ($ruleInfo['stock'] <= 0) {
                    return dataReturn(-3, "该商品库存不足");
                }

                // 查询购物车是否有相同的商品
                $hasGoods = $cartModel->findOne([
                    'user_id' => $userId,
                    'goods_id' => $param['goods_id'],
                    'rule_id' => $ruleInfo['id']
                ], 'id,goods_num')['data'];

                if (!empty($hasGoods)) {

                    $cartModel->updateById([
                        'goods_num' => $hasGoods['goods_num'] + 1,
                        'update_time' => now()
                    ], $hasGoods['id']);
                } else {

                    $param = [
                        'user_id' => $userId,
                        'goods_id' => $param['goods_id'],
                        'title' => $goodsInfo['name'],
                        'images' => $ruleInfo['image'],
                        'original_price' => $ruleInfo['original_price'],
                        'price' => $ruleInfo['price'],
                        'goods_num' => $param['num'],
                        'total_amount' => $param['num'] * $ruleInfo['price'],
                        'rule_id' => $ruleInfo['id'],
                        'rule_text' => implode(' ', $param['rule']),
                        'create_time' => now()
                    ];

                    $res = $cartModel->insertOne($param);
                    if ($res['code'] != 0) {
                        return $res;
                    }
                }
            } else { // 单规格

                // 查询购物车是否有相同的商品
                $hasGoods = $cartModel->findOne([
                    'user_id' => $userId,
                    'goods_id' => $param['goods_id'],
                ], 'id,goods_num')['data'];

                if (!empty($hasGoods)) {

                    $cartModel->updateById([
                        'goods_num' => $hasGoods['goods_num'] + 1,
                        'update_time' => now()
                    ], $hasGoods['id']);
                } else {
                    $param = [
                        'user_id' => $userId,
                        'goods_id' => $param['goods_id'],
                        'title' => $goodsInfo['name'],
                        'images' => json_decode($goodsInfo['slider_image'], true)[0],
                        'original_price' => $goodsInfo['original_price'],
                        'price' => $goodsInfo['price'],
                        'goods_num' => $param['num'],
                        'total_amount' => $param['num'] * $goodsInfo['price'],
                        'rule_id' => 0,
                        'create_time' => now()
                    ];

                    $res = $cartModel->insertOne($param);
                    if ($res['code'] != 0) {
                        return $res;
                    }
                }
            }

            $cartNum = $cartModel->where('user_id', $userId)->sum('goods_num');
            $cartAmount = number_format($cartModel->where('user_id', $userId)->sum('total_amount'), 2);

            return  dataReturn(0, "加入成功", compact('cartNum', 'cartAmount'));
        } catch (\Exception $e) {

            return dataReturn(-5, $e->getMessage());
        }
    }

    /**
     * @param $limit
     * @param $userId
     * @return array
     */
    public function detail($limit, $userId)
    {
        try {

            $cartModel = new Cart();
            $cartList = $cartModel->where('user_id', $userId)
                ->order('id desc')->paginate($limit);

            return dataReturn(0, "success", $cartList);
        } catch (\Exception $e) {
            return dataReturn(-1, $e->getMessage());
        }
    }

    /**
     * 删除购物车物品
     * @param $id
     * @param $userId
     * @return array
     */
    public function removeCartGoods($id, $userId)
    {
        $cartModel = new Cart();
        return $cartModel->delByWhere([
            'id' => $id,
            'user_id' => $userId
        ]);
    }

    /**
     * 购物车数量
     * @return array
     */
    public function getCartNum()
    {
        $userInfo = getJWT(getHeaderToken());
        if (empty($userInfo)) {
            return dataReturn(0, 'success', 0);
        }

        $num = (new Cart())->where('user_id', $userInfo['id'])->sum('goods_num');
        return dataReturn(0, 'success', $num);
    }

    /**
     * 清空购物车
     * @param $userId
     * @return array
     */
    public function clearCart($userId)
    {
        (new Cart())->where('user_id', $userId)->delete();
        return dataReturn(0, '删除成功');
    }
}