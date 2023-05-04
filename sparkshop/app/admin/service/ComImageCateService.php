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

use app\admin\validate\ComImagesCateValidate;
use app\model\system\ComImages;
use app\model\system\ComImagesCate;
use think\exception\ValidateException;

class ComImageCateService
{
    /**
     * 添加分类
     * @param $param
     * @return array|\think\response\Json
     */
    public function addComImageCate($param)
    {
        // 检验完整性
        try {
            validate(ComImagesCateValidate::class)->check($param);
        } catch (ValidateException $e) {
            return dataReturn(-1, $e->getError());
        }

        $comImagesCateModel = new ComImagesCate();
        $has = $comImagesCateModel->checkUnique([
            'name' => $param['name']
        ])['data'];

        if (!empty($has)) {
            return dataReturn(-2, '分类名已经存在');
        }

        $param['create_time'] = now();
        return $comImagesCateModel->insertOne($param);
    }

    /**
     * 编辑图片分类
     * @param $param
     * @return array|\think\response\Json
     */
    public function editComImageCate($param)
    {
        // 检验完整性
        try {
            validate(ComImagesCateValidate::class)->scene('edit')->check($param);
        } catch (ValidateException $e) {
            return dataReturn(-1, $e->getError());
        }

        $comImagesCateModel = new ComImagesCate();

        $where[] = ['id', '<>', $param['id']];
        $where[] = ['name', '=', $param['name']];
        $has = $comImagesCateModel->checkUnique($where)['data'];

        if (!empty($has)) {
            return dataReturn(-2, '分类名已经存在');
        }

        return $comImagesCateModel->updateById($param, $param['id']);
    }

    /**
     * 删除图片分类
     * @param $id
     * @return array
     */
    public function delComImageCate($id)
    {
        $comImagesCateModel = new ComImagesCate();
        $hasSub = $comImagesCateModel->findOne([
            'pid' => $id
        ], 'id')['data'];
        if (!empty($hasSub)) {
            return dataReturn(-1, '该分类下有子分类不可删除');
        }

        $comImagesModel = new ComImages();
        $hasUsed = $comImagesModel->findOne([
            'cate_id' => $id
        ], 'id')['data'];
        if (!empty($hasUsed)) {
            return dataReturn(-2, '该分类已经被使用无法删除');
        }

        return $comImagesCateModel->delById($id);
    }
}