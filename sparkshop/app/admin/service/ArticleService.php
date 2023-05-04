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

use app\admin\validate\ArticleValidate;
use app\model\system\Article;
use think\exception\ValidateException;

class ArticleService
{
    /**
     * 获取文章列表
     * @param $param
     * @return array
     * @throws \think\db\exception\DbException
     */
    public function getList($param)
    {
        $limit = $param['limit'];
        $name = $param['name'];

        $where = [];
        if (!empty($name)) {
            $where[] = ['name', 'like', '%' . $name . '%'];
        }

        $articleModel = new Article();
        $list = $articleModel->with('cateInfo')->where($where)->order('id desc')->paginate($limit);

        return dataReturn(0, 'success', $list);
    }

    /**
     * 添加文章
     * @param $param
     * @return array|\think\response\Json
     */
    public function addArticle($param)
    {
        // 检验完整性
        try {
            validate(ArticleValidate::class)->check($param);
        } catch (ValidateException $e) {
            return dataReturn(-1, $e->getError());
        }

        $articleModel = new Article();
        $has = $articleModel->checkUnique([
            'title' => $param['title']
        ])['data'];

        if (!empty($has)) {
            return dataReturn(-2, '文章标题已经存在');
        }

        $param['create_time'] = now();
        return $articleModel->insertOne($param);
    }

    /**
     * 编辑文章
     * @param $param
     * @return array|\think\response\Json
     */
    public function editArticle($param)
    {
        // 检验完整性
        try {
            validate(ArticleValidate::class)->check($param);
        } catch (ValidateException $e) {
            return dataReturn(-1, $e->getError());
        }

        $articleModel = new Article();

        $where[] = ['id', '<>', $param['id']];
        $where[] = ['title', '=', $param['title']];
        $has = $articleModel->checkUnique($where)['data'];

        if (!empty($has)) {
            return dataReturn(-2, '文章标题已经存在');
        }

        return $articleModel->updateById($param, $param['id']);
    }
}