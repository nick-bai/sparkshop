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

namespace app\api\controller;

use app\api\service\UserCollectService;

class UserCollect extends Base
{
    /**
     * 我的收藏
     */
    public function myCollect()
    {
        $param = input('param.');

        $userCollectService = new UserCollectService();
        return json($userCollectService->getMyCollect($param));
    }

    /**
     * 收藏
     */
    public function add()
    {
        $param = input('param.');

        $userCollectService = new UserCollectService();
        return json($userCollectService->addCollect($param));
    }

    /**
     * 移除收藏
     */
    public function remove()
    {
        $userCollectService = new UserCollectService();
        return json($userCollectService->removeCollect(input('param.id')));
    }

    /**
     * 通过goods_id 移除收藏
     */
    public function removeByGoodsId()
    {
        $userCollectService = new UserCollectService();
        return json($userCollectService->removeCollectByGoodsId(input('param.goods_id')));
    }
}