<?php
// +----------------------------------------------------------------------
// | SparkShop 坚持做优秀的商城系统
// +----------------------------------------------------------------------
// | Copyright (c) 2022~2099 http://sparkshop.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://opensource.org/licenses/mit-license.php )
// +----------------------------------------------------------------------
// | Author: NickBai
// +----------------------------------------------------------------------
use think\facade\Route;

// 商品详情
Route::get('goods/:id/:type?', 'index/goods/detail')->pattern(['id' => '\d+', 'type' => '\d+']);
// 商品的规格
Route::get('goodsRule', 'index/goods/goodsRuleDetail');
// 退款详情
Route::get('refundDetail/:id', 'index/userOrder/refundDetail');
// 用户详情
Route::get('detail/:id', 'index/user/detail');
// 退款详情
Route::get('refund/:type/:id', 'index/userOrder/refund');
// 物流信息
Route::get('express/:id', 'index/userOrder/express');
// 售后订单
Route::get('afterOrder', 'index/userOrder/afterOrder');
// 评价
Route::get('appraise/:id', 'index/userOrder/appraise');
// 商品秒杀
Route::get('seckill/:seckill_id', 'index/seckill/goods');
// 创建订单
Route::post('order$', 'index/order/index');
// 试算
Route::post('order/trial', 'index/order/trial');
// 用户协议
Route::get('agreement', 'index/index/agreement');
// 商品分类
Route::get('cate/:id/:level', 'index/cate/index');
