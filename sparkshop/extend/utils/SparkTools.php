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

use app\model\system\SysSetting;
use strategy\sms\SmsProvider;
use strategy\store\StoreProvider;

class SparkTools
{
    public static function sendSms($param)
    {
        if (empty($param['phone']) || empty($param['type'])) {
            return dataReturn(-1, '参数错误');
        }

        $info = getConfByType('sms');

        $sms = [
            'access_key_id' => $info['access_key_id'],
            'access_key_secret' => $info['access_key_secret'],
            'sign_name' => $info['sign_name'],
            'templateCode' => $info[$param['type']],
            'phone' => $param['phone']
        ];

        $smsProvider = new SmsProvider('ali');
        $sendParam = formatSmsData($sms);
        $res = $smsProvider->getStrategy()->send($sendParam);

        if ($res['code'] == 0) {
            // 记录5分钟
            cache($param['phone'] . '_' . $param['type'], json_decode($sendParam['code'], true)['code'], 300);
        }

        return $res;
    }

    public static function getPayWay()
    {
        // 支付方式开启情况
        $sysSettingModel = new SysSetting();
        $payWayMap = $sysSettingModel->getOpenWay()['data'];
        $payWay = '';
        if (isset($payWayMap['wechat_pay']) && $payWayMap['wechat_pay'] == 1) {
            $payWay = 'wechat_pay';
        } else if (isset($payWayMap['alipay']) && $payWayMap['alipay'] == 1) {
            $payWay = 'alipay';
        }

        return compact('payWayMap', 'payWay');
    }

    /**
     * 第三方存储
     * @param $storeWay
     * @param $file
     * @param $saveName
     * @return string
     */
    public static function storeOSS($storeWay, $file, $saveName)
    {
        $storeConfigMap = config('shop.store_config');
        $config = getConfByType($storeConfigMap[$storeWay]);
        $provider = new StoreProvider($storeWay, $config);
        $fileArr = [
            'content' => app()->getRootPath() . 'public/storage/' . $saveName,
            'type' => $file->getMime()
        ];

        $provider->getStrategy()->upload($saveName, $fileArr);
        unlink(app()->getRootPath() . 'public/storage/' . $saveName);
        removeEmptyDir(dirname(app()->getRootPath() . 'public/storage/' . $saveName));
        $ossDomain = $config[config('shop.store_domain')[$storeWay]];
        if (strstr($ossDomain, 'http://') == false && strstr($ossDomain, 'https://') == false) {
            $ossDomain = 'https://' . $ossDomain;
        }

        return str_replace('\\', '/', $ossDomain . '/' . $saveName);
    }

    /**
     * 保持目录结构的压缩方法
     * @param string $zipFile
     * @param $folderPaths
     * @param $zipRootPath
     * @return void
     */
    public static function dirZip(string $zipFile, $folderPaths, $zipRootPath)
    {
        //1. $folderPaths 路径为数组
        // 初始化zip对象
        $zip = new \ZipArchive();
        //打开压缩文件
        $zip->open($zipFile, \ZipArchive::CREATE | \ZipArchive::OVERWRITE);

        if(is_array($folderPaths)) {
            foreach($folderPaths as $folderPath) {

                // 被压缩文件绝对路径
                $rootPath = realpath($folderPath);
                // Create recursive directory iterator
                //获取所有文件数组SplFileInfo[] $files
                $files = new \RecursiveIteratorIterator(
                    new \RecursiveDirectoryIterator($rootPath),
                    \RecursiveIteratorIterator::LEAVES_ONLY
                );

                foreach ($files as $name => $file) {
                    //要跳过所有子目录
                    if (!$file->isDir()) {
                        // 真实文件路径
                        $filePath = $file->getRealPath();
                        // zip文件的相对路径
                        $relativePath = str_replace($zipRootPath, '', $filePath);
                        //添加文件到压缩包
                        $zip->addFile($filePath, $relativePath);
                    }
                }
            }
        } else {
            // 2. $folderPaths 路径为string
            // 被压缩文件绝对路径
            $rootPath = realpath($folderPaths);
            // Create recursive directory iterator
            // 获取所有文件数组SplFileInfo[] $files
            $files = new \RecursiveIteratorIterator(
                new \RecursiveDirectoryIterator($rootPath),
                \RecursiveIteratorIterator::LEAVES_ONLY
            );

            foreach ($files as $name => $file) {
                // 要跳过所有子目录
                if (!$file->isDir()) {
                    // 要压缩的文件路径
                    $filePath = $file->getRealPath();
                    // zip目录内文件的相对路径
                    $relativePath = str_replace($zipRootPath, '', $filePath);
                    // 添加文件到压缩包
                    $zip->addFile($filePath, $relativePath);
                }
            }
        }

        $zip->close();
    }

    /**
     * 获得锁,如果锁被占用,阻塞,直到获得锁或者超时。
     * -- 1、如果 $timeout 参数为 0,则立即返回锁。
     * -- 2、建议 timeout 设置为 0,避免 redis 因为阻塞导致性能下降。请根据实际需求进行设置。
     *
     * @param string $key 缓存KEY。
     * @param int $timeout 取锁超时时间。单位(秒)。等于0,如果当前锁被占用,则立即返回失败。如果大于0,则反复尝试获取锁直到达到该超时时间。
     * @param int $lockSecond 锁定时间。单位(秒)。
     * @param int $sleep 取锁间隔时间。单位(微秒)。当锁为占用状态时。每隔多久尝试去取锁。默认 0.1 秒一次取锁。
     * @return bool 成功:true、失败:false
     * @throws \Exception
     */
    public static function lock(string $key, int $timeout = 0, int $lockSecond = 20, int $sleep = 100000): bool
    {
        $redis = getRedisHandler();
        if (strlen($key) === 0) {
            // 项目抛异常方法
            throw new \Exception(500, '缓存KEY没有设置');
        }
        $start = floatval(self::getMicroTime());
        do {
            // [1] 锁的 KEY 不存在时设置其值并把过期时间设置为指定的时间。锁的值并不重要。重要的是利用 Redis 的特性。
            $acquired = $redis->set("Lock:{$key}", 1, ['NX', 'EX' => $lockSecond]);
            if ($acquired) {
                break;
            }
            if ($timeout === 0) {
                break;
            }
            usleep($sleep);
        } while (!is_numeric($timeout) || (self::getMicroTime()) < ($start + ($timeout * 1000000)));

        return (bool)$acquired;
    }

    /**
     * 释放锁
     *
     * @param mixed $key 被加锁的KEY。
     * @return void
     * @throws \Exception
     */
    public static function release($key)
    {
        $redis = getRedisHandler();
        if (strlen($key) === 0) {
            // 项目抛异常方法
            throw new \Exception(500, '缓存KEY没有设置');
        }
        $redis->del("Lock:{$key}");
    }

    /**
     * 获取当前微秒。
     */
    public static function getMicroTime(): string
    {
        return bcmul(microtime(true), 1000000);
    }

    /**
     * lua减少库存
     */
    public static function luaDecStock($redis, $key, $val)
    {
        $script = <<<LUA
local stock = redis.call('get', KEYS[1])
stock = tonumber(stock)
local userBuyNum = tonumber(ARGV[1])
if (stock == 0) then
    return -1
elseif (stock < userBuyNum) then
    return -2
else
    redis.call('decrby', KEYS[1], ARGV[1])
    return 0
end
LUA;
        return $redis->eval($script, [$key, $val], 1);
    }
}