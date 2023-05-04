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

namespace app\model\system;

use app\model\BaseModel;

class ComImages extends BaseModel
{
    /**
     * 检测文件是否存在
     * @param $sha1
     * @return array
     */
    public function checkImageExist($sha1)
    {
        try {

            $has = $this->where('sha1', $sha1)->find();
            if (!empty($has)) {
                return ['code' => 203, 'data' => $has, 'msg' => '该图片已经存在了'];
            }
        } catch (\Exception $e) {
            return ['code' => -1, 'data' => 0, 'msg' => $e->getMessage()];
        }

        return ['code' => 0, 'data' => [], 'msg' => 'success'];
    }
}

