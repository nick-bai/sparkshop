<?php
// +----------------------------------------------------------------------
// | SparkShop 坚持做优秀的商城系统
// +----------------------------------------------------------------------
// | Copyright (c) 2022~2099 http://sparkshop.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://opensource.org/licenses/mit-license.php )
// +----------------------------------------------------------------------
// | Author: NickBai
// +----------------------------------------------------------------------
namespace app\index\controller;

use think\facade\Filesystem;
use utils\SparkTools;

class Upload extends Base
{
    // 上传图片
    public function img()
    {
        $file = request()->file('file');
        // 上传到本地服务器
        try {

            $imageConf = config('images');
            $extMap = explode('|', $imageConf['ext']);
            $mineMap = explode(',', $imageConf['acceptMime']);

            // 检测文件类型
            $mine = $file->getMime();
            if (!in_array($mine, $mineMap)) {
                return json(['code' => -2, 'data' => [], 'msg' => '只支持上传jpg|png|bmp|jpeg|gif类型图片']);
            }

            // 检测文件后缀
            $ext = $file->getOriginalExtension();
            if (!in_array($ext, $extMap)) {
                return json(['code' => -3, 'data' => [], 'msg' => '只支持上传jpg|png|bmp|jpeg|gif类型图片']);
            }

            // 存到本地
            $saveName = Filesystem::disk('public')->putFile('home', $file);
            $url = request()->domain() . '/storage/' . $saveName;
            $storeWay = getConfByType('store')['store_way'];
            if ($storeWay != 'local') {
                $url = SparkTools::storeOSS($storeWay, $file, $saveName);
            }
        } catch (\Exception $e) {

            return json(['code' => -1, 'data' => [], 'msg' => $e->getMessage()]);
        }

        return json(['code' => 0, 'data' => ['url' => $url], 'msg' => '上传成功']);
    }
}