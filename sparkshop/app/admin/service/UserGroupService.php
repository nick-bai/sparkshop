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

use app\admin\validate\UserGroupValidate;
use app\model\user\UserGroup;
use think\exception\ValidateException;

class UserGroupService
{
    /**
     * 获取用户分组
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

        $userGroupModel = new UserGroup();
        $list = $userGroupModel->where($where)->order('id desc')->paginate($limit);

        return dataReturn(0, 'success', $list);
    }

    /**
     * 添加用户分组
     * @param $param
     * @return array
     */
    public function addUserGroup($param)
    {
        // 检验完整性
        try {
            validate(UserGroupValidate::class)->check($param);
        } catch (ValidateException $e) {
            return dataReturn(-1, $e->getError());
        }

        $userGroupModel = new UserGroup();
        $has = $userGroupModel->checkUnique([
            'name' => $param['name']
        ])['data'];

        if (!empty($has)) {
            return dataReturn(-2, '该分组已经存在');
        }

        $param['create_time'] = now();
        return $userGroupModel->insertOne($param);
    }

    /**
     * 编辑用户分组
     * @param $param
     * @return array
     */
    public function editUserGroup($param)
    {
        // 检验完整性
        try {
            validate(UserGroupValidate::class)->check($param);
        } catch (ValidateException $e) {
            return dataReturn(-1, $e->getError());
        }

        $userGroupModel = new UserGroup();

        $where[] = ['id', '<>', $param['id']];
        $where[] = ['name', '=', $param['name']];
        $has = $userGroupModel->checkUnique($where)['data'];

        if (!empty($has)) {
            return dataReturn(-2, '该分组已经存在');
        }
        return $userGroupModel->updateById($param, $param['id']);
    }
}