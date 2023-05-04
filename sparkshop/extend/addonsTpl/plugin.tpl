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
namespace addons\<<pluginName>>;

use plugins\Addons;
use utils\SqlTool;

class Plugin extends Addons
{
    // 事件注册
    public function hooks()
    {
        return [
            '<<pluginName>>' => [

            ]
        ];
    }

    /**
     * 插件安装方法
     * @return array
     */
    public static function install()
    {
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
            'name' => '<<pluginName>>',
            'title' => '<<title>>',
            'description' => '<<description>>',
            'author' => '<<author>>',
            'home_page' => '<<home_page>>',
            'version' => '<<version>>'
        ];
    }
}