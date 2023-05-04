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

use app\model\system\SysSetting;

class SystemService
{
    /**
     * 保存配置
     * @param $param
     * @return array
     */
    public function saveSystem($param)
    {
        try {

            $sysSettingModel = new SysSetting();
            foreach ($param as $key => $vo) {
                $sysSettingModel->where('key', $key)->update([
                    'value' => $vo
                ]);
            }
        } catch (\Exception $e) {
            return dataReturn(-1, $e->getMessage());
        }

        return dataReturn(0);
    }
}