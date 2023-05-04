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

use app\admin\validate\AdminRoleValidate;
use app\model\system\AdminRole;
use app\model\system\AdminUser;
use think\exception\ValidateException;

class RoleService
{
    /**
     * 获取角色列表
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

        $adminRoleModel = new AdminRole();
        $list = $adminRoleModel->where($where)->order('id desc')->paginate($limit);

        return dataReturn(0, 'success', $list);
    }

    /**
     * 添加角色
     * @param $param
     * @return array
     */
    public function addRole($param)
    {
        // 检验完整性
        try {
            validate(AdminRoleValidate::class)->check($param);
        } catch (ValidateException $e) {
            return dataReturn(-1, $e->getError());
        }

        $adminRoleModel = new AdminRole();
        $has = $adminRoleModel->checkUnique([
            'name' => $param['name']
        ])['data'];

        if (!empty($has)) {
            return dataReturn(-2, '该角色已经存在');
        }

        $param['role_node'] = '122,123,126,' . $param['role_node'];
        $param['create_time'] = now();
        return $adminRoleModel->insertOne($param);
    }

    /**
     * 编辑角色
     * @param $param
     * @return array
     */
    public function editRole($param)
    {
        // 检验完整性
        try {
            validate(AdminRoleValidate::class)->check($param);
        } catch (ValidateException $e) {
            return dataReturn(-1, $e->getError());
        }

        $adminRoleModel = new AdminRole();

        $where[] = ['id', '<>', $param['id']];
        $where[] = ['name', '=', $param['name']];
        $has = $adminRoleModel->checkUnique($where)['data'];

        if (!empty($has)) {
            return dataReturn(-2, '该角色已经存在');
        }

        return $adminRoleModel->updateById($param, $param['id']);
    }

    /**
     * 删除角色
     * @param $id
     * @return array
     */
    public function delRole($id)
    {
        $adminUserModel = new AdminUser();
        $has = $adminUserModel->findOne([
            'role_id' => $id
        ], 'id')['data'];
        if (!empty($has)) {
            return dataReturn(-1, '该角色已被使用无法删除');
        }

        $adminRoleModel = new AdminRole();
        return $adminRoleModel->delById($id);
    }
}