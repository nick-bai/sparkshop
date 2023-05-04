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
namespace app\admin\service;


use app\model\order\OrderComment;

class AppraiseService
{
    /**
     * 获取评价列表
     * @param $param
     * @return array
     * @throws \think\db\exception\DbException
     */
    public function getList($param)
    {
        $limit = $param['limit'];
        $type = $param['type'];
        $appraiseTime = $param['create_time'];

        $where = [];
        if (!empty($type)) {
            $where[] = ['type', '=', $type];
        }

        if (!empty($appraiseTime)) {
            $where[] = ['create_time', 'between', [$appraiseTime[0] . ' 00:00:00', $appraiseTime[1] . ' 23:59:59']];
        }

        $appraise = config('shop.appraise');
        $commentModel = new OrderComment();
        $list = $commentModel->where($where)->order('id desc')->paginate($limit)->each(function ($item) use ($appraise) {
            $item->type = $appraise[$item->type];
        });

        return dataReturn(0, 'success', $list);
    }
}