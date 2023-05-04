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
namespace addons\seckill;

use app\model\system\AdminNode;
use plugins\Addons;
use utils\SqlTool;

class Plugin extends Addons
{
    // 事件注册
    public function hooks()
    {
        return [
            'seckill' => [
                'seckillHomeData' => ['HomeData'],
                'seckillStock' => ['seckillStock'],
                'refundSeckillStock' => ['refundSeckillStock'],
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
        $pid = $adminNodeModel->insertOne(makeMenuItem(105, 'seckill', '限时秒杀', '#', 'el-icon-timer', 2, 98))['data'];

        $subPid = $adminNodeModel->insertOne(makeMenuItem($pid, 'seckill', '秒杀商品', 'addons/seckill/admin.seckill/index', '', 2, 98))['data'];
        $adminNodeModel->insertBatch([
            makeMenuItem($subPid, 'seckill', '添加', 'addons/seckill/admin.seckill/add'),
            makeMenuItem($subPid, 'seckill', '编辑', 'addons/seckill/admin.seckill/edit'),
            makeMenuItem($subPid, 'seckill', '删除', 'addons/seckill/admin.seckill/del')
        ]);

        $subPid = $adminNodeModel->insertOne(makeMenuItem($pid, 'seckill', '秒杀配置', 'addons/seckill/admin.seckillTime/index', '', 2, 98))['data'];
        $adminNodeModel->insertBatch([
            makeMenuItem($subPid, 'seckill', '添加', 'addons/seckill/admin.seckillTime/add'),
            makeMenuItem($subPid, 'seckill', '添加', 'addons/seckill/admin.seckillTime/edit'),
            makeMenuItem($subPid, 'seckill', '添加', 'addons/seckill/admin.seckillTime/del')
        ]);

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
            'name' => 'seckill',
            'title' => '限时秒杀',
            'description' => '限时秒杀',
            'author' => 'NickBai',
            'home_page' => 'https://gitee.com/nickbai/sparkshop',
            'version' => '1.0.1'
        ];
    }
}