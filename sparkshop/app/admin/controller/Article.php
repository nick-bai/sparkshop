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

use app\admin\service\ArticleService;
use app\model\system\Article as ArticleModel;
use think\facade\View;

class Article extends Base
{
    /**
     * 获取列表
     */
    public function index()
    {
        if (request()->isAjax()) {

            $articleService = new ArticleService();
            $res = $articleService->getList(input('param.'));
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

            $articleService = new ArticleService();
            $res = $articleService->addArticle($param);
            return json($res);
        }

        $articleCateModel = new \app\model\system\ArticleCate();
        View::assign([
            'cate' => json_encode($articleCateModel->getAllList([
                'status' => 1
            ], 'id,name')['data'])
        ]);

        return View::fetch();
    }

    /**
     * 编辑
     */
    public function edit()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $articleService = new ArticleService();
            $res = $articleService->editArticle($param);
            return json($res);
        }

        $articleCateModel = new \app\model\system\ArticleCate();
        $id = input('param.id');
        $articleModel = new ArticleModel();
        View::assign([
            'info' => json_encode($articleModel->findOne([
                'id' => $id
            ])['data']),
            'cate' => json_encode($articleCateModel->getAllList([
                'status' => 1
            ], 'id,name')['data'])
        ]);

        return View::fetch();
    }

    /**
     * 删除
     */
    public function del()
    {
        $id = input('param.id');

        $articleModel = new ArticleModel();
        $info = $articleModel->delById($id);

        return json($info);
    }
}

