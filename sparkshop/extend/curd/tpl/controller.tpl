<?php
// +----------------------------------------------------------------------
// | SparkShop 坚持做优秀的商城系统
// +----------------------------------------------------------------------
// | Copyright (c) 2011~2099 http://sparkshop.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://opensource.org/licenses/mit-license.php )
// +----------------------------------------------------------------------
// | Author: NickBai  <876337011@qq.com>
// +----------------------------------------------------------------------

namespace app\admin\controller;

use app\model\<model>;
use app\admin\validate\<model>Validate;
use think\exception\ValidateException;
use think\facade\View;

class <controller> extends Base
{
    /**
    * 获取列表
    */
    public function index()
    {
        if (request()->isAjax()) {

            $limit = input('param.limit');
            $name = input('param.name');
            $where = [];

            if (!empty($name)) {
                $where[] = ['name', 'like', '%' . $name . '%'];
            }

            $<modelLow>Model = new <model>();
            $list = $<modelLow>Model->where($where)->order('id desc')->paginate($limit);

            return jsonReturn(0, 'success', $list);
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

            // 检验完整性
            try {
                validate(<model>Validate::class)->check($param);
            } catch (ValidateException $e) {
                return jsonReturn(-1, $e->getError());
            }

            $<modelLow>Model = new <model>();
            $has = $<modelLow>Model->checkUnique([
                '<uniqueField>' => $param['<uniqueField>']
            ])['data'];

            if (!empty($has)) {
                return jsonReturn(-2, '<unique>已经存在');
            }

            $param['create_time'] = now();
            $res = $<modelLow>Model->insertOne($param);

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

            // 检验完整性
            try {
                validate(<model>Validate::class)->check($param);
            } catch (ValidateException $e) {
                return jsonReturn(-1, $e->getError());
            }

            $<modelLow>Model = new <model>();

            $where[] = ['id', '<>', $param['id']];
            $where[] = ['<uniqueField>', '=', $param['<uniqueField>']];
            $has = $<modelLow>Model->checkUnique($where)['data'];

            if (!empty($has)) {
                return jsonReturn(-2, '<unique>已经存在');
            }

            $res = $<modelLow>Model->updateById($param, $param['id']);

            return json($res);
         }

         $id = input('param.id');
         $<modelLow>Model = new <model>();
         View::assign([
            'info' => $<modelLow>Model->findOne([
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

        $<modelLow>Model = new <model>();
        $info = $<modelLow>Model->delById($id);

        return json($info);
   }
}

