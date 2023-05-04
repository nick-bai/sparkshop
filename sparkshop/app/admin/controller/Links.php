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

use app\admin\service\LinksService;
use app\model\system\WebsiteLinks;
use think\facade\View;

class Links extends Base
{
    /**
    * 获取列表
    */
    public function index()
    {
        if (request()->isAjax()) {

            $linksService = new LinksService();
            $res = $linksService->getList(input('param.'));
            return json($res);
        }

        return View::fetch();
    }

    /**
    * 添加
    */
    public function add()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $linksService = new LinksService();
            $res = $linksService->addLinks($param);
            return json($res);
        }

        return View::fetch();
    }

    /**
    * 编辑
    */
    public function edit()
    {
         if (request()->isPost()) {

            $param = input('post.');

             $linksService = new LinksService();
             $res = $linksService->editLinks($param);
            return json($res);
         }

         $id = input('param.id');
         $websiteLinksModel = new WebsiteLinks();
         View::assign([
            'info' => $websiteLinksModel->findOne([
                'id' => $id
            ])['data']
         ]);

         return View::fetch();
    }

    /**
    * 删除
    */
    public function del()
    {
        $id = input('param.id');

        $websiteLinksModel = new WebsiteLinks();
        $info = $websiteLinksModel->delById($id);

        return json($info);
   }
}

