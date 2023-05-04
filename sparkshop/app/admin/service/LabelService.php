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

use app\admin\validate\LabelValidate;
use app\model\user\UserLabel;
use think\exception\ValidateException;

class LabelService
{
    /**
     * 获取标签列表
     * @param $param
     * @return array
     * @throws \think\db\exception\DbException
     */
    public function getList($param)
    {
        $limit = $param['limit'];

        $where = [];
        $labelModel = new UserLabel();
        $list = $labelModel->where($where)->order('id desc')->paginate($limit);

        return dataReturn(0, 'success', $list);
    }

    /**
     * 添加标签
     * @param $param
     * @return array
     */
    public function addLabel($param)
    {
        // 检验完整性
        try {
            validate(LabelValidate::class)->check($param);
        } catch (ValidateException $e) {
            return dataReturn(-1, $e->getError());
        }

        $labelModel = new UserLabel();
        $has = $labelModel->checkUnique([
            'name' => $param['name']
        ])['data'];

        if (!empty($has)) {
            return dataReturn(-2, '该标签已经存在');
        }

        $param['create_time'] = now();
        return $labelModel->insertOne($param);
    }

    /**
     * 编辑标签
     * @param $param
     * @return array
     */
    public function editLabel($param)
    {
        // 检验完整性
        try {
            validate(LabelValidate::class)->check($param);
        } catch (ValidateException $e) {
            return dataReturn(-1, $e->getError());
        }

        $labelModel = new UserLabel();

        $where[] = ['id', '<>', $param['id']];
        $where[] = ['name', '=', $param['name']];
        $has = $labelModel->checkUnique($where)['data'];

        if (!empty($has)) {
            return dataReturn(-2, '该标签已经存在');
        }

        return $labelModel->updateById($param, $param['id']);
    }
}