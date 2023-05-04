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
namespace addons\coupon;

use app\model\system\AdminNode;
use plugins\Addons;
use utils\SqlTool;

class Plugin extends Addons
{
    // 事件注册
    public function hooks()
    {
        return [
            'coupon' => [
                'coupon' => ['index'],
                'couponUsed' => ['usedLog'],
                'couponCancel' => ['cancel']
            ]
        ];
    }

    /**
     * 插件安装方法
     * @return array
     */
    public static function install()
    {
        // 写菜单
        $adminNodeModel = new AdminNode();
        $pid = $adminNodeModel->insertOne(makeMenuItem(105, 'coupon', '优惠券', '#', 'el-icon-s-ticket', 2, 98))['data'];

        $subPid = $adminNodeModel->insertOne(makeMenuItem($pid, 'coupon', '优惠券列表', 'addons/coupon/admin.index/index', '', 2, 98))['data'];
        $adminNodeModel->insertBatch([
            makeMenuItem($subPid, 'coupon', '添加', 'addons/coupon/admin.index/add'),
            makeMenuItem($subPid, 'coupon', '作废', 'addons/coupon/admin.index/close'),
            makeMenuItem($subPid, 'coupon', '用户领取记录', 'addons/coupon/admin.index/log')
        ]);

        $adminNodeModel->insertOne(makeMenuItem($pid, 'coupon', '领取记录', 'addons/coupon/admin.receiveLog/index', '', 2, 90))['data'];

        return SqlTool::query(__DIR__ . DS . 'data' . DS . 'install.sql');
    }

    /**
     * 插件卸载方法
     * @return array
     */
    public static function uninstall()
    {
        return SqlTool::query(__DIR__ . DS . 'data' . DS . 'uninstall.sql');
    }

    /**
     * 插件升级方法
     * @return array
     */
    public static function update()
    {
        return SqlTool::query(__DIR__ . DS . 'data' . DS . 'update.sql');
    }

    /**
     * 获取插件名称
     * @return array
     */
    public static function getInfo()
    {
        return [
            'name' => 'coupon',
            'title' => '优惠券',
            'description' => '满减券、折扣券、用户领取记录、用户使用记录',
            'author' => 'NickBai',
            'home_page' => 'https://gitee.com/nickbai/sparkshop',
            'version' => '1.0.1'
        ];
    }
}