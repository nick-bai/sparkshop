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

use app\admin\validate\SetExpressValidate;
use app\model\system\SetExpress;
use think\exception\ValidateException;

class ExpressService
{
    /**
     * 获取快递列表
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

        $setExpressModel = new SetExpress();
        $list = $setExpressModel->where($where)->order('id desc')->paginate($limit);
        return dataReturn(0, 'success', $list);
    }

    /**
     * 添加快递
     * @param $param
     * @return array
     */
    public function addExpress($param)
    {
        // 检验完整性
        try {
            validate(SetExpressValidate::class)->check($param);
        } catch (ValidateException $e) {
            return dataReturn(-1, $e->getError());
        }

        $setExpressModel = new SetExpress();
        $has = $setExpressModel->checkUnique([
            'name' => $param['name']
        ])['data'];

        if (!empty($has)) {
            return dataReturn(-2, '物流公司名称已经存在');
        }

        $param['create_time'] = now();
        return $setExpressModel->insertOne($param);
    }

    /**
     * 编辑快递
     * @param $param
     * @return array
     */
    public function editExpress($param)
    {
        // 检验完整性
        try {
            validate(SetExpressValidate::class)->check($param);
        } catch (ValidateException $e) {
            return dataReturn(-1, $e->getError());
        }

        $setExpressModel = new SetExpress();

        $where[] = ['id', '<>', $param['id']];
        $where[] = ['name', '=', $param['name']];
        $has = $setExpressModel->checkUnique($where)['data'];

        if (!empty($has)) {
            return dataReturn(-2, '物流公司名称已经存在');
        }

        return $setExpressModel->updateById($param, $param['id']);
    }
}