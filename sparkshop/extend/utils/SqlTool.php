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

namespace utils;

use think\facade\Db;

class SqlTool
{
    /**
     * 脚本执行
     * @param $path
     * @return array
     */
    public static function query($path)
    {
        $sqlFile = file_get_contents($path);
        $sqlFile = str_replace('<#PREFIX#>', env('database.prefix'), $sqlFile);
        $sqlMap = str_replace("\r", "\n", $sqlFile);
        $sqlMap = explode(";\n", $sqlMap);

        try {
            // 写入数据库
            foreach ($sqlMap as $sql) {

                $sql = trim($sql);
                if (empty($sql)) {
                    continue;
                }

                Db::query($sql);
            }
        } catch (\Exception $e) { // 异常信息
            return dataReturn(-100, 'sql执行异常: ' . $e->getMessage());
        }

        return dataReturn(0, '执行成功');
    }
}