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

use app\admin\validate\WebsiteLinksValidate;
use app\model\system\WebsiteLinks;
use think\exception\ValidateException;

class LinksService
{
    /**
     * 获取友情链接
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

        $websiteLinksModel = new WebsiteLinks();
        $list = $websiteLinksModel->where($where)->order('id desc')->paginate($limit);

        return dataReturn(0, 'success', $list);
    }

    /**
     * 添加友链
     * @param $param
     * @return array
     */
    public function addLinks($param)
    {
        // 检验完整性
        try {
            validate(WebsiteLinksValidate::class)->check($param);
        } catch (ValidateException $e) {
            return dataReturn(-1, $e->getError());
        }

        $websiteLinksModel = new WebsiteLinks();
        $has = $websiteLinksModel->checkUnique([
            'name' => $param['name']
        ])['data'];

        if (!empty($has)) {
            return dataReturn(-2, '友链标题已经存在');
        }

        $param['create_time'] = now();
        return $websiteLinksModel->insertOne($param);
    }

    /**
     * 编辑友链
     * @param $param
     * @return array
     */
    public function editLinks($param)
    {
        // 检验完整性
        try {
            validate(WebsiteLinksValidate::class)->check($param);
        } catch (ValidateException $e) {
            return dataReturn(-1, $e->getError());
        }

        $websiteLinksModel = new WebsiteLinks();

        $where[] = ['id', '<>', $param['id']];
        $where[] = ['name', '=', $param['name']];
        $has = $websiteLinksModel->checkUnique($where)['data'];

        if (!empty($has)) {
            return dataReturn(-2, '友链标题已经存在');
        }

        $param['update_time'] = now();
        return $websiteLinksModel->updateById($param, $param['id']);
    }
}