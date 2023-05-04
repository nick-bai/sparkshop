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

namespace addons\seckill\controller\admin;

use addons\seckill\service\SeckillService;
use app\PluginBaseController;

class Seckill extends PluginBaseController
{
    /**
     * 秒杀列表
     */
    public function index()
    {
        if (request()->isAjax()) {

            $param = input('param.');

            $seckillService = new SeckillService();
            $res = $seckillService->getList($param);
            return json($res);
        }

        return fetch();
    }

    /**
     * 添加秒杀商品
     */
    public function add()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $seckillService = new SeckillService();
            $res = $seckillService->addSeckillGoods($param);
            return json($res);
        }

        $seckillTimeModel = new \addons\seckill\model\SeckillTime();
        $list = $seckillTimeModel->getAllList([
            'status' => 1
        ], '*', 'sort desc')['data'];

        return jsonReturn(0, 'success', [
            'seckill_time' => $list
        ]);
    }

    /**
     * 编辑秒杀商品
     */
    public function edit()
    {
        $seckillService = new SeckillService();

        if (request()->isPost()) {

            $param = input('post.');

            $res = $seckillService->editSeckillGoods($param);
            return json($res);
        }

        return json($seckillService->buildEditParam(input('param.activity_id')));
    }

    /**
     * 删除秒杀商品
     */
    public function del()
    {
        if (request()->isAjax()) {

            $id = input('param.id');

            $seckillService = new SeckillService();
            $res = $seckillService->delSeckill($id);
            return json($res);
        }
    }
}