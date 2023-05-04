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

use app\admin\service\ArticleCateService;
use app\model\system\ArticleCate as ArticleCateModel;
use think\facade\View;

class ArticleCate extends Base
{
    /**
     * 获取列表
     */
    public function index()
    {
        if (request()->isAjax()) {

            $articleCateService = new ArticleCateService();
            $res = $articleCateService->getList(input('param.'));
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

            $articleCateService = new ArticleCateService();
            $res = $articleCateService->addArticleCate($param);
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

            $articleCateService = new ArticleCateService();
            $res = $articleCateService->editArticle($param);
            return json($res);
        }

        $id = input('param.id');
        $articleCateModel = new ArticleCateModel();
        View::assign([
            'info' => $articleCateModel->findOne([
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

        $articleModel = new \app\model\system\Article();
        $has = $articleModel->field('id')->where('cate_id', $id)->find();
        if (!empty($has)) {
            return jsonReturn(-1, "该分类下有文章不可删除");
        }

        $articleCateModel = new ArticleCateModel();
        $info = $articleCateModel->delById($id);

        return json($info);
    }
}

