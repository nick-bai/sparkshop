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
namespace app\admin\controller;

use app\admin\service\AppraiseService;
use app\model\order\OrderComment;
use think\facade\View;

class Appraise extends Base
{
    /**
     * 评价列表
     */
    public function index()
    {
        if (request()->isAjax()) {

            $appraiseService = new AppraiseService();
            $res = $appraiseService->getList(input('param.'));
            return json($res);
        }

        return View::fetch();
    }

    /**
     * 删除评价
     */
    public function del()
    {
        if (request()->isAjax()) {

            $id = input('param.id');

            $commentModel = new OrderComment();
            $res = $commentModel->delById($id);

            return json($res);
        }
    }
}