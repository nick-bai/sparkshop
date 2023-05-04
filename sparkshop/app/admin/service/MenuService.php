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

use app\admin\validate\AdminNodeValidate;
use app\model\system\AdminNode;
use think\exception\ValidateException;

class MenuService
{
    /**
     * 获取菜单树
     * @return array
     */
    public function getMenuTree()
    {
        $adminNodeModel = new AdminNode();
        $list = $adminNodeModel->getAllList(['status' => 1], '*', 'sort desc')['data'];

        return dataReturn(0, 'success', makeTree($list->toArray()));
    }

    /**
     * 添加菜单
     * @return array
     */
    public function addMenu($param)
    {
        try {
            validate(AdminNodeValidate::class)->check($param);
        } catch (ValidateException $e) {
            return dataReturn(-1, $e->getError());
        }

        $adminNodeModel = new AdminNode();
        // 检查唯一
        $has = $adminNodeModel->checkUnique([
            'path' => $param['path'],
            'status' => 1
        ])['data'];
        if (!empty($has)) {
            return dataReturn(-2, '该菜单路由已经存在');
        }

        $param['create_time'] = now();
        return $adminNodeModel->insertOne($param);
    }

    /**
     * 编辑菜单
     * @return array
     */
    public function editMenu($param)
    {
        try {
            validate(AdminNodeValidate::class)->check($param);
        } catch (ValidateException $e) {
            return dataReturn(-1, $e->getError());
        }

        $adminNodeModel = new AdminNode();
        // 检查唯一
        $has = $adminNodeModel->checkUnique([
            ['path', '=', $param['path']],
            ['id', '<>', $param['id']],
            ['path', '<>', '#'],
            ['status', '=', 1]
        ])['data'];
        if (!empty($has)) {
            return dataReturn(-2, '该菜单路由已经存在');
        }

        $param['update_time'] = now();
        return $adminNodeModel->updateById($param, $param['id']);
    }

    /**
     * 删除带单
     * @param $id
     * @return array
     */
    public function delMenu($id)
    {
        $adminNodeModel = new AdminNode();

        $has = $adminNodeModel->findOne(['pid' => $id])['data'];
        if (!empty($has)) {
            return dataReturn(-1, '该菜单下有子菜单，不可删除');
        }

        return $adminNodeModel->delById($id);
    }

    /**
     * 获取菜单节点树
     * @return array
     */
    public function getNodeTree()
    {
        $adminNodeModel = new AdminNode();
        $nodeList = $adminNodeModel->getAllList(['status' => 1], 'id,name,pid', 'sort desc')['data'];
        $tree = makeTree($nodeList->toArray());

        foreach ($tree as $key => $vo) {
            if ($vo['name'] == '首页') {
                $tree[$key]['disabled'] = true;

                foreach ($vo['child'] as $k => $v) {
                    $tree[$key]['child'][$k]['disabled'] = true;
                }
            }
        }

        return $tree;
    }

    /**
     * 获取超管的节点
     * @return array
     */
    public function getSuperAdminNode()
    {
        $adminNodeModel = new AdminNode();
        return $adminNodeModel->getAllList([
            'status' => 1,
            'is_menu' => 2
        ], 'id,name,path,pid,icon', 'sort desc')['data']->toArray();
    }
}