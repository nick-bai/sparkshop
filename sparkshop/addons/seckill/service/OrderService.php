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
use addons\seckill\model\SeckillOrder;
use addons\seckill\model\SeckillTime;
use app\model\order\Order;
use app\model\order\OrderAddress;
use app\model\order\OrderDetail;
use app\model\order\OrderOverdue;
use app\model\order\OrderPayLog;
use app\model\order\OrderStatusChange;
use app\model\user\User;
use app\model\user\UserAddress;
use strategy\pay\PayProvider;
use think\facade\Db;
use utils\SparkTools;

class OrderService
{
    // 秒杀的商品规格key %u: activity_id, %u: sku
    protected $seckillKey = 'seckill:%u:%s';

    // 秒杀限制信息key %u: activity_id
    protected $seckillLimitKey = 'seckill_limit:%u';

    /**
     * 秒杀商品信息
     * @param $param
     * @return array
     */
    public function seckillGoodsInfo($param)
    {
        $orderData = json_decode($param['order_data'], true)[0];
        $res = $this->checkSeckill($orderData['id']);

        if ($res['code'] != 0) {
            return $res;
        }

        // 秒杀信息
        $seckillGoodsModel = new SeckillActivityGoods();
        $where[] = ['activity_id', '=', $orderData['id']];
        if (!empty($orderData['rule'])) {
            $where[] = ['sku', '=', $orderData['rule']];
        }
        $goodsList = $seckillGoodsModel->getAllList($where, 'image,sku,seckill_price as price')['data'];

        foreach ($goodsList as $key => $vo) {
            $goodsList[$key]['name'] = $res['data']['info']['name'];
            $goodsList[$key]['num'] = $orderData['num'];
        }

        $payWayConf = SparkTools::getPayWay();
        $return = [
            'payWayMap' => $payWayConf['payWayMap'],
            'pay_way' => $payWayConf['payWay'],
            'goodsList' => $goodsList
        ];

        return dataReturn(0, 'success', $return);
    }

    /**
     * 订单试算
     * @param $param
     * @return array
     */
    public function trail($param)
    {
        // 商品信息
        $orderData = json_decode($param['goods'], true)[0];

        $seckillGoodsModel = new SeckillActivityGoods();
        $where[] = ['activity_id', '=', $orderData['id']];
        if (!empty($orderData['rule'])) {
            $where[] = ['sku', '=', $orderData['rule']];
        }
        $goodsInfo = $seckillGoodsModel->findOne($where, 'image,sku,seckill_price as price')['data']->toArray();

        $totalPrice = round($goodsInfo['price'] * $orderData['num'], 2);
        $postage = 0;
        $realPay = $totalPrice + $postage;
        $userInfo = getUserInfo();
        $userBalance = (new User())->findOne(['id' => $userInfo['id']], 'balance')['data']->balance;
        $price = $goodsInfo['price'];

        return dataReturn(0, 'success', compact('totalPrice', 'postage', 'realPay', 'userBalance', 'price'));
    }

    /**
     * 检查秒杀数据
     * @param $seckillId
     * @return array
     */
    public function checkSeckill($seckillId)
    {
        // 获取秒杀信息
        $seckillActivity = new SeckillActivity();
        $info = $seckillActivity->findOne([
            ['id', '=', $seckillId],
            ['status', '=', 2],
            ['start_time', '<', now()],
            ['end_time', '>', now()]
        ])['data'];

        if (empty($info)) {
            return dataReturn(-1, '该活动已结束');
        }

        // 检测活动时间
        $activityTime = (new SeckillTime())->findOne([
            'id' => $info['seckill_time_id'],
            'status' => 1
        ])['data'];
        if (empty($activityTime)) {
            return dataReturn(-2, '活动信息异常');
        }

        $nowHour = date('H');
        if ($nowHour < $activityTime['start_hour']) {
            return dataReturn(-3, '活动尚未开始');
        }

        if ($nowHour > ($activityTime['start_hour'] + $activityTime['continue_hour'])) {
            return dataReturn(-4, '活动已经开始');
        }

        return dataReturn(0, 'success', compact('info', 'activityTime'));
    }

    /**
     * 创建订单
     * @param $param
     * @return array
     */
    public function createOrder($param)
    {
        // 商品信息
        $orderData = json_decode($param['goods'], true)[0];
        $redis = getRedisHandler();

        // 检测下单条件
        $checkRes = $this->preCheck($redis, $orderData);
        if ($checkRes['code'] != 0) {
            return $checkRes;
        }

        $seckillActivityInfo = (new SeckillActivity())->findOne(['id' => $orderData['id']])['data'];
        if (empty($seckillActivityInfo)) {
            return dataReturn(-9, '活动信息异常');
        }

        $seckillGoodsInfo = (new SeckillActivityGoods())->findOne([
            'activity_id' => $orderData['id'],
            'goods_id' => $seckillActivityInfo['goods_id'],
            'sku' => $orderData['rule']
        ], 'image,seckill_price')['data'];
        if (empty($seckillGoodsInfo)) {
            return dataReturn(-10, '活动商品异常');
        }
        $seckillActivityInfo['image'] = $seckillGoodsInfo['image'];
        $seckillActivityInfo['seckill_price'] = $seckillGoodsInfo['seckill_price'];

        Db::startTrans();
        try {

            // 执行创建订单
            $orderCreateRes = $this->dealCreateOrder($param, $orderData, $seckillActivityInfo);
            if ($orderCreateRes['code'] != 0) {
                $key = sprintf($this->seckillKey, $orderData['id'], $orderData['rule']);
                $redis->incrby($key, $orderData['num']); // 还原redis库存
                Db::rollback();
                return $orderCreateRes;
            }

            // 无需实际支付的
            if ($orderCreateRes['data']['calcParam']['realPay'] <= 0) {
                // 删除快检表的数据，防止过多的扫描
                $overdueModel = new OrderOverdue();
                $overdueModel->delById($orderCreateRes['data']['orderId'], 'order_id');

                return $this->completeOrder([
                    'seckill_id' => $orderData['id'],
                    'sku' => $orderData['rule'],
                    'id' => $orderCreateRes['data']['orderId'],
                    'pay_order_no' => $orderCreateRes['data']['payOrderNo'],
                    'num' => $orderData['num']
                ]);
            }

            $userInfo = getUserInfo();
            // 发起支付
            $payProvider = new PayProvider($param['pay_way']);
            $payParam = [
                'out_trade_no' => $orderCreateRes['data']['payOrderNo'],
                'total_amount' => $orderCreateRes['data']['calcParam']['realPay'],
                'subject' => $seckillActivityInfo['name'],
                'user_id' => $userInfo['id']
            ];

            $platform = $param['platform'] ?? '';
            $res = $payProvider->payByPlatform($platform, $param['pay_way'], $payParam);

            Db::commit();
            return dataReturn(0, $orderCreateRes['data']['orderNo'], $res);
        } catch (\Exception $e) {
            $key = sprintf($this->seckillKey, $orderData['id'], $orderData['rule']);
            $redis->incrby($key, $orderData['num']); // 还原redis库存
            Db::rollback();
            return dataReturn(-12, '系统错误');
        }
    }

    /**
     * 前置订单检测
     * @param $redis
     * @param $orderData
     * @return array
     */
    protected function preCheck($redis, $orderData)
    {
        $userInfo = getUserInfo();

        // 用户过往买过的该秒杀商品
        $orderModel = new SeckillOrder();
        $seckillInfo = $orderModel->getAllList([
            'seckill_id' => $orderData['id'],
            'user_id' => $userInfo['id']
        ], 'order_id')['data'];

        if (empty($seckillInfo)) {
            $buyNum = 0;
        } else {
            $orderIds = [];
            foreach ($seckillInfo as $vo) {
                $orderIds[] = $vo['order_id'];
            }
            $buyNum = (new Order())->whereIn('id', $orderIds)->where('pay_status', 2)->count('id');
        }
        $limitKey = sprintf($this->seckillLimitKey, $orderData['id']);
        $limitInfo = json_decode($redis->get($limitKey), true);

        if ($buyNum >= $limitInfo['total_buy_num']) {
            return dataReturn(-1, '每人累计限购'. $limitInfo['total_buy_num'] . ',无法再次购买。');
        }

        if ($limitInfo['start_time'] > now()) {
            return dataReturn(-2, '活动尚未开始');
        }

        if (now() > $limitInfo['end_time']) {
            return dataReturn(-3, '活动已经结束');
        }

        if (!in_array(date('H'), $limitInfo['start_hour'])) {
            return dataReturn(-4, '活动尚未开始');
        }

        if ($orderData['num'] > $limitInfo['once_buy_num']) {
            return dataReturn(-5, '每人单次限购'. $limitInfo['once_buy_num']);
        }

        // 扣除redis库存
        $key = sprintf($this->seckillKey, $orderData['id'], $orderData['rule']);
        $canBuy = SparkTools::luaDecStock($redis, $key, $orderData['num']);
        if ($canBuy == -1) {
            return dataReturn(-6, '很遗憾，您来晚了，该商品已经卖完了！');
        }

        if ($canBuy == -2) {
            return dataReturn(-7, '剩余库存不足');
        }

        return dataReturn(0, 'success', $seckillInfo);
    }

    /**
     * 创建订单
     * @param $param
     * @param $orderData
     * @param $seckillActivityInfo
     * @return array
     */
    private function dealCreateOrder($param, $orderData, $seckillActivityInfo)
    {
        try {
            // 开始下单
            $userInfo = getUserInfo();

            $payOrderNo = makeOrderNo('P');
            $orderNo = makeOrderNo('D');
            $payType = config('pay.pay_type');

            // 试算
            $calcParam = $this->trail($param)['data'];

            // 1、创建订单
            $order = [
                'pid' => 0,
                'type' => 3, // 秒杀订单
                'order_no' => $orderNo,
                'pay_order_no' => $payOrderNo,
                'user_id' => $userInfo['id'],
                'total_num' => $orderData['num'],
                'postage' => 0,
                'order_price' => $calcParam['realPay'], // 秒杀下和realPay价格一样
                'pay_way' => $payType[$param['pay_way']],
                'pay_price' => $calcParam['realPay'],
                'pay_postage' => 0, // TODO 秒杀商品不处理邮费
                'vip_discount' => 0,
                'coupon_amount' => 0,
                'pay_status' => 1,
                'status' => 2, // 已确认/待支付
                'source' => $param['platform'],
                'remark' => $param['remark'],
                'create_time' => now()
            ];

            $orderModel = new Order();
            $orderId = $orderModel->insertGetId($order);

            // 2、记录订单快检表
            $overduePayType = config('pay.overdue_pay_type');
            if (isset($overduePayType[$param['pay_way']])) {
                $this->writeOverdueData($orderId, $orderData['num']);
            }

            // 3、记录支付记录
            $payLog = [
                'order_id' => $orderId,
                'pay_way' => $payType[$param['pay_way']],
                'pay_order_no' => $payOrderNo,
                'status' => 1,
                'create_time' => now()
            ];

            $orderPayLogModel = new OrderPayLog();
            $orderPayLogModel->insert($payLog);

            // 4、处理用户的货地址表
            $userAddressModel = new UserAddress();
            $addressInfo = $userAddressModel->where('id', $param['address_id'])->where('user_id', $userInfo['id'])->find();
            if (empty($addressInfo)) {
                return dataReturn(-3, "收货地址异常");
            }

            $address = [
                'order_id' => $orderId,
                'user_id' => $userInfo['id'],
                'address_id' => $param['address_id'],
                'user_name' => $addressInfo['real_name'],
                'phone' => $addressInfo['phone'],
                'province' => $addressInfo['province'],
                'city' => $addressInfo['city'],
                'county' => $addressInfo['county'],
                'detail' => $addressInfo['detail'],
                'post_code' => $addressInfo['post_code'],
                'longitude' => $addressInfo['longitude'],
                'latitude' => $addressInfo['latitude'],
                'create_time' => now()
            ];

            $orderAddressModel = new OrderAddress();
            $orderAddressModel->insert($address);

            // 7、写入订单商品详情
            $orderDetailModel = new OrderDetail();
            $orderDetailModel->insert([
                'order_id' => $orderId,
                'goods_id' => $seckillActivityInfo['goods_id'],
                'goods_name' => $seckillActivityInfo['name'],
                'price' => $seckillActivityInfo['seckill_price'],
                'logo' => $seckillActivityInfo['image'],
                'rule_id' => 0,
                'rule' => $orderData['rule'], // 规格
                'cart_num' => $orderData['num'],
                'coupon_amount' => 0,
                'vip_discount' => 0
            ]);

            // 8、维护状态变更日志
            $orderStatusModel = new OrderStatusChange();
            $orderStatusModel->insert([
                'order_id' => $orderId,
                'original_status' => 1,
                'new_status' => 2,
                'msg' => '订单创建',
                'create_time' => now()
            ]);

            // 维护关联订单
            $seckillOrderModel = new SeckillOrder();
            $seckillOrderModel->insert([
                'order_id' => $orderId,
                'user_id' => $userInfo['id'],
                'seckill_id' => $orderData['id']
            ]);
        } catch (\Exception $e) {
            return dataReturn(-11, '下单异常' . $e->getMessage() . '>>>' . $e->getLine());
        }

        return dataReturn(0, 'success', [
            'calcParam' => $calcParam,
            'orderId' => $orderId,
            'payOrderNo' => $payOrderNo,
            'orderNo' => $orderNo
        ]);
    }

    /**
     * 订单快检表，方便处理订单过期未处理问题
     * @param $orderId
     * @param $num
     * @return void
     */
    private function writeOverdueData($orderId, $num)
    {
        $overdueModel = new OrderOverdue();
        $baseConf = getConfByType('shop_base');
        $confTime = $baseConf['seckill_unpaid_cancel_time'] ?? 1;

        $overdueTime = date('Y-m-d H:i:s', time() + $confTime * 3600);
        $overdueModel->insert([
            'order_id' => $orderId,
            'type' => 3,
            'goods_id' => 0, // 不记录
            'rule_id' => 0, // 不记录
            'num' => $num,
            'overdue_time' => $overdueTime
        ]);
    }

    /**
     * 直接完成订单
     * @param $orderInfo
     * @return array
     */
    private function completeOrder($orderInfo)
    {
        try {

            $orderModel = new Order();
            $payLogModel = new OrderPayLog();

            // 扣减商品库存 、维护销量
            $stockNotEnough = $this->dealStockAndSales($orderInfo);
            $status = 3;
            if ($stockNotEnough) {
                $status = 9;
            }

            // 维护状态
            $orderModel->where('id', $orderInfo['id'])->update([
                'pay_status' => 2,
                'status' => $status,
                'third_code' => '',
                'return_msg' => '',
                'pay_time' => now(),
                'update_time' => now()
            ]);

            // 记录日志
            $payLogModel->where('order_id', $orderInfo['id'])->where('pay_order_no', $orderInfo['pay_order_no'])->update([
                'status' => 2,
                'update_time' => now()
            ]);

            // 维护状态变更日志
            $orderStatusModel = new OrderStatusChange();
            $orderStatusModel->insert([
                'order_id' => $orderInfo['id'],
                'original_status' => 2,
                'new_status' => $status,
                'msg' => '订单支付成功',
                'create_time' => now()
            ]);

        } catch (\Exception $e) {
            return dataReturn(-1, $e->getMessage());
        }

        return dataReturn(0);
    }

    /**
     * 维护销量
     * @param $orderInfo
     * @return bool
     */
    public function dealStockAndSales($orderInfo)
    {
        $seckillActivityGoodsModel = new SeckillActivityGoods();
        $info = $seckillActivityGoodsModel->where('activity_id', $orderInfo['seckill_id'])->where('sku', $orderInfo['sku'])->lock(true)->find();
        if ($info['stock'] <= 0) {
            return true;
        }

        $seckillActivityGoodsModel->where('activity_id', $orderInfo['seckill_id'])
            ->where('sku', $orderInfo['sku'])->inc('sales', $orderInfo['num'])->dec('stock', $orderInfo['num'])
            ->update();

        $seckillActivityModel = new SeckillActivity();
        $info = $seckillActivityModel->where('id', $orderInfo['seckill_id'])->lock(true)->find();
        if ($info['stock'] <= 0) {
            return true;
        }

        $seckillActivityModel->where('id', $orderInfo['seckill_id'])->inc('sales', $orderInfo['num'])->dec('stock', $orderInfo['num'])
            ->update();

        return false;
    }

    /**
     * 退款返还库存和销量
     * @param $orderInfo
     * @return bool
     */
    public function refundStockAndSales($orderInfo)
    {
        $seckillActivityGoodsModel = new SeckillActivityGoods();
        $seckillActivityGoodsModel->where('activity_id', $orderInfo['seckill_id'])->where('sku', $orderInfo['sku'])->lock(true)->find();

        $seckillActivityGoodsModel->where('activity_id', $orderInfo['seckill_id'])
            ->where('sku', $orderInfo['sku'])->dec('sales', $orderInfo['num'])->inc('stock', $orderInfo['num'])
            ->update();

        $seckillActivityModel = new SeckillActivity();
        $seckillActivityModel->where('id', $orderInfo['seckill_id'])->lock(true)->find();

        $seckillActivityModel->where('id', $orderInfo['seckill_id'])->dec('sales', $orderInfo['num'])->inc('stock', $orderInfo['num'])
            ->update();

        $key = sprintf($this->seckillKey, $orderInfo['seckill_id'], $orderInfo['sku']);
        $redis = getRedisHandler();
        $redis->incrby($key, $orderInfo['num']); // 还原redis库存

        return false;
    }
}