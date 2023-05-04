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
namespace strategy\store;

interface StoreInterface
{
    /**
     * 上传
     * @param $path
     * @param $file
     * @return mixed
     */
    public function upload($path, $file);

    /**
     * 删除
     * @param $path
     * @return mixed
     */
    public function del($path);
}