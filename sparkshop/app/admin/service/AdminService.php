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

use app\admin\validate\AdminUserValidate;
use app\model\system\AdminUser;
use think\exception\ValidateException;

class AdminService
{
    /**
     * 获取管理员列表
     * @param $param
     * @return array
     * @throws \think\db\exception\DbException
     */
    public function getList($param)
    {
        $limit = $param['limit'];
        $nickname = $param['nickname'];

        $where = [];
        if (!empty($nickname)) {
            $where[] = ['nickname', 'like', '%' . $nickname . '%'];
        }

        $adminUserModel = new AdminUser();
        $list = $adminUserModel->where($where)->with('role')->order('id desc')->paginate($limit)->each(function ($item, $key) {
            if ($item->role_id == 0) {
                $item->role_name = '超级管理员';
            }
        });

        return dataReturn(0, 'success', $list);
    }

    /**
     * 添加管理员
     * @param $param
     * @return array|\think\response\Json
     */
    public function addAdmin($param)
    {
        if (isset($param['file'])) {
            unset($param['file']);
        }

        try {
            validate(AdminUserValidate::class)->check($param);
        } catch (ValidateException $e) {
            return dataReturn(-1, $e->getError());
        }

        $adminUserModel = new AdminUser();
        $has = $adminUserModel->checkUnique([
            'name' => $param['name']
        ])['data'];

        if (!empty($has)) {
            return dataReturn(-2, '该管理员已经存在');
        }

        $param['password'] = makePassword($param['password']);
        $param['salt'] = config('shop.salt');
        $param['create_time'] = now();
        return $adminUserModel->insertOne($param);
    }

    /**
     * 编辑管理员
     * @param $param
     * @return array|\think\response\Json
     */
    public function editAdmin($param)
    {
        if (isset($param['file'])) {
            unset($param['file']);
        }

        try {
            validate(AdminUserValidate::class)->scene('edit')->check($param);
        } catch (ValidateException $e) {
            return dataReturn(-1, $e->getError());
        }

        if (!empty($param['password'])) {
            $param['password'] = makePassword($param['password']);
            $param['salt'] = config('shop.salt');
        } else {
            unset($param['password']);
        }

        $adminUserModel = new AdminUser();
        $where[] = ['name', '=', $param['name']];
        $where[] = ['id', '<>', $param['id']];
        $has = $adminUserModel->checkUnique($where)['data'];

        if (!empty($has)) {
            return dataReturn(-2, '该管理员已经存在');
        }

        $param['update_time'] = now();
        return $adminUserModel->updateById($param, $param['id']);
    }
}