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
namespace app\index\controller;

use app\model\GoodsRule;
use app\model\GoodsRuleExtend;
use app\model\SeckillActivity;
use EasyWeChat\Factory;
use app\BaseController;
use strategy\express\ExpressProvider;
use strategy\pay\PayProvider;
use strategy\store\StoreProvider;

class Test extends BaseController
{
    public function login()
    {
        $config = [
            'app_id' => 'wx566ecdaccfbc286c',
            'secret' => 'be3ebd8ddaf5aa6e304707b6430424ce',

            // 下面为可选项
            // 指定 API 调用返回结果的类型：array(default)/collection/object/raw/自定义类名
            'response_type' => 'array',

            'log' => [
                'level' => 'debug',
                'file' => __DIR__.'/wechat.log',
            ],
        ];

        $app = Factory::miniProgram($config);

        $res = $app->auth->session(input('param.code'));
        return jsonReturn(0, 'success', $res);
    }

    public function pay()
    {
        $order = [
            'out_trade_no' => 'P2022082749971011',
            'body' => '测试支付',
            'total_fee'      => '1',
            'openid' => input('param.openid')
        ];

        $payProvider = new PayProvider("wechat_pay");
        $res = $payProvider->getStrategy()->miniappPay($order);
        return json($res);
    }

    public function refund()
    {
        $order = [
            'out_trade_no' => '1661527884', // 订单号
            'out_refund_no' => time(),
            'total_fee' => '1',
            'refund_fee' => '1',
            'refund_desc' => '测试退款haha',
        ];

        $payProvider = new PayProvider("wechat_pay");
        $res = $payProvider->getStrategy()->refund($order);
        return json($res);
    }

    public function express()
    {
        $param = [
            'no' => 'SF1627782169003:2893',
            'type' => 'SFEXPRESS'
        ];

        $provider = new ExpressProvider('aliyun');
        $res = $provider->getStrategy()->search($param);
        dd($res);
    }

    public function upload()
    {
        //exit('<img src="https://sparkshop.oss-cn-hangzhou.aliyuncs.com/home/20220921/ca1ac026ad3bd735125ba09d14bda99e.jpeg"/>');
        $file = request()->file('file');

        $config = getConfByType('store');
        $storeWay = $config['store_way'];

        $provider = new StoreProvider($storeWay);
        $saveName = \think\facade\Filesystem::disk('public')->putFile('home', $file);

        $fileArr = [
            'content' => app()->getRootPath() . 'public/storage/' . $saveName,
            'type' => $file->getMime()
        ];

        $res = $provider->getStrategy()->upload($saveName, $fileArr);
        unlink(app()->getRootPath() . 'public/storage/' . $saveName);
        removeEmptyDir(dirname(app()->getRootPath() . 'public/storage/' . $saveName));
        dd($res);
    }

    public function rule()
    {
        $activityId = 2;
        $seckillModel = new SeckillActivity();
        $seckillInfo = $seckillModel->with('activityGoods')->where('id', $activityId)->find();

        if (empty($seckillInfo)) {
            return dataReturn(-1, "秒杀商品不存在");
        }

        $redis = getRedisHandler();
        $limitKey = sprintf(config('shop.seckill_limit_key'), $activityId, $seckillInfo['goods_id']);
        $limitInfo = json_decode($redis->get($limitKey), true);

        $goodsRuleInfo = [];
        // 多规格
        if ($seckillInfo['goods_rule'] == 2) {

            $ruleIds = [];
            $rule2stock = [];
            foreach ($seckillInfo['activityGoods'] as $vo) {
                $ruleIds[] = $vo['rule_id'];
                $rule2stock[$vo['rule_id']] = $vo['stock'] - $vo['sales'];
            }

            // 规格具体信息
            $goodsRuleExtendModel = new GoodsRuleExtend();
            $goodsRuleExtendList = $goodsRuleExtendModel->getAllList([
                ['id', 'in', $ruleIds]
            ], 'id,goods_id,sku,image')['data'];

            $skuSearchMapMap = [];
            foreach ($goodsRuleExtendList as $vo) {
                $skuMap[] = explode('※', $vo['sku']);
                foreach ($skuMap as $vl) {
                    foreach ($vl as $key => $v) {
                        if (!isset($skuSearchMapMap[$key + 1])) {
                            $skuSearchMapMap[$key + 1][] = $v;
                        } else if (!in_array($v, $skuSearchMapMap[$key + 1])) {
                            $skuSearchMapMap[$key + 1][] = $v;
                        }
                    }
                }
            }

            // 规格信息
            $goodsRuleModel = new GoodsRule();
            $goodsRuleInfo = $goodsRuleModel->findOne([
                'goods_id' => $seckillInfo['goods_id']
            ])['data'];
            $goodsRuleInfo = json_decode($goodsRuleInfo['rule'], true);

            // 移除未参与秒杀的规格
            foreach ($goodsRuleInfo as $key => $vo) {
                foreach ($vo['item'] as $k => $v) {
                    $searchKey = ltrim($key , 'item');
                    if (!in_array($v, $skuSearchMapMap[$searchKey])) {
                        unset($goodsRuleInfo[$key]['item'][$k]);
                    }
                }
            }

            // 属性检索对应表
            $sku2Detail = [];
            foreach ($goodsRuleExtendList as $vo) {
                $sku2Detail[$vo['sku']] = [
                    'id' => $vo['id'],
                    'image' => $vo['image'],
                    'stock' => $rule2stock[$vo['id']],
                    'limit' => (int)$limitInfo['once_buy_num']
                ];
            }
        } else { // 单规格
            $sku2Detail = [
                'id' => 0,
                'image' => $seckillInfo['pic'],
                'stock' => $seckillInfo['activityGoods'][0]['stock'],
                'limit' => (int)$limitInfo['once_buy_num']
            ];
        }
    }

    // 秒杀测试
    public function seckill()
    {
        $param = [
            "user_id" => rand(1000, 9999),
            "order_data" => '[{"id":4,"price":7999,"num":1,"rule_id":154,"type":3, "activity_id": 2}]'
        ];

        $orderData = json_decode($param['order_data'], true);
        $goodsIds = [];
        foreach ($orderData as $vo) {
            $goodsIds[] = $vo['id'];
            $goods2Num[$vo['id']] = $vo['num'];
            $goods2Rule[$vo['id']] = $vo['rule_id'];
            if (isset($vo['cart_id'])) {
                $cartId[] = $vo['cart_id'];
            }
            $orderType = $vo['type'];
        }

        // 如果是秒杀商品,确定是否有库存、购买的数量是否正确、是否可以再购买
        if ($orderType == 3) {
            return json($this->dealSeckillToken($param, $goodsIds, $orderData));
        }
    }

    /**
     * 处理秒杀
     * @param $param
     * @param $goodsIds
     * @param $orderData
     * @return array
     */
    protected function dealSeckillToken($param, $goodsIds, $orderData)
    {
        $redis = getRedisHandler();

        $limitKey = sprintf(config('shop.seckill_limit_key'), $orderData[0]['activity_id'], $goodsIds[0]);
        $limitInfo = json_decode($redis->get($limitKey), true);
        if ($limitInfo['start_time'] > now()) {
            return dataReturn(-10, '活动尚未开始');
        }

        if (now() > $limitInfo['end_time']) {
            return dataReturn(-15, '活动已经结束');
        }

        if (!in_array(date('H'), $limitInfo['start_hour'])) {
            return dataReturn(-11, '活动尚未开始');
        }

        if ($orderData[0]['num'] > $limitInfo['once_buy_num']) {
            return dataReturn(-12, '每人单次限购'. $limitInfo['once_buy_num']);
        }

        $orderModel = new \app\model\Order();
        $buyNum = $orderModel->where('seckill_id', $orderData[0]['activity_id'])->where('user_id', $param['user_id'])
            ->sum('total_num');
        if ($buyNum > $limitInfo['total_buy_num']) {
            return dataReturn(-13, '每人累计限购'. $limitInfo['total_buy_num'] . ',无法再次购买。');
        }

        $key = sprintf(config('shop.seckill_key'), $orderData[0]['activity_id'], $goodsIds[0], $orderData[0]['rule_id']);
        $storeKey = $redis->lPop($key);
        if (empty($storeKey)) {
            return dataReturn(-14, '很遗憾，您来晚了，该商品已经卖完了！');
        }

        $seckillToken = uniqid();
        $tokenKey = sprintf(config('shop.seckill_user_token'), $orderData[0]['activity_id'], $param['user_id']);
        cache($tokenKey, $seckillToken, 3600);

        return dataReturn(0, 'success', $seckillToken);
    }
}