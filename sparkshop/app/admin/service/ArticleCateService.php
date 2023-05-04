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

use app\admin\validate\ArticleCateValidate;
use app\model\system\ArticleCate;
use think\exception\ValidateException;

class ArticleCateService
{
    /**
     * 获取文章分类列表
     * @param $param
     * @return array
     * @throws \think\db\exception\DbException
     */
    public function getList($param)
    {
        $name = $param['name'];
        $limit = $param['limit'];

        $where = [];
        if (!empty($name)) {
            $where[] = ['name', 'like', '%' . $name . '%'];
        }

        $articleCateModel = new ArticleCate();
        $list = $articleCateModel->where($where)->order('id desc')->paginate($limit);

        return dataReturn(0, 'success', $list);
    }

    /**
     * 添加文章分类
     * @param $param
     * @return array|\think\response\Json
     */
    public function addArticleCate($param)
    {
        // 检验完整性
        try {
            validate(ArticleCateValidate::class)->check($param);
        } catch (ValidateException $e) {
            return dataReturn(-1, $e->getError());
        }

        $articleCateModel = new ArticleCate();
        $has = $articleCateModel->checkUnique([
            'name' => $param['name']
        ])['data'];

        if (!empty($has)) {
            return dataReturn(-2, '分类名已经存在');
        }

        $param['create_time'] = now();
        return $articleCateModel->insertOne($param);
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
            validate(ArticleCateValidate::class)->check($param);
        } catch (ValidateException $e) {
            return dataReturn(-1, $e->getError());
        }

        $articleCateModel = new ArticleCate();

        $where[] = ['id', '<>', $param['id']];
        $where[] = ['name', '=', $param['name']];
        $has = $articleCateModel->checkUnique($where)['data'];

        if (!empty($has)) {
            return dataReturn(-2, '分类名已经存在');
        }

        return $articleCateModel->updateById($param, $param['id']);
    }
}