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
namespace strategy\store\impl;

use League\Flysystem\Config;
use League\Flysystem\Filesystem;
use strategy\store\StoreInterface;
use Xxtime\Flysystem\Aliyun\OssAdapter;

class AliyunImpl implements StoreInterface
{
    protected $ossObj = null;

    public function __construct($config)
    {
        $adapter = new OssAdapter([
            'accessId'     => $config['accesskey_id'],
            'accessSecret' => $config['accesskey_secret'],
            'bucket'       => $config['bucket'],
            'endpoint'     => $config['endpoint'],
        ]);


        $this->ossObj = new Filesystem($adapter);
    }

    /**
     * 上传
     * @param $path
     * @param $file
     * @return array|mixed
     */
    public function upload($path, $file)
    {
        try {

            $config = [
                "Content-Type" => $file['type']
            ];
            $this->ossObj->write($path, file_get_contents($file['content']), $config);
        } catch (\Exception $e) {
            return dataReturn(-1, $e->getMessage());
        }

        return dataReturn(0, '上传成功');
    }

    /**
     * 删除
     * @param $path
     * @return array|mixed
     */
    public function del($path)
    {
        try {

            $this->ossObj->delete($path);
        } catch (\Exception $e) {
            return dataReturn(-1, $e->getMessage());
        }

        return dataReturn(0, '删除成功');
    }
}