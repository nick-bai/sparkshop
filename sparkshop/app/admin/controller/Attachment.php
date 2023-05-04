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

namespace app\admin\controller;

use app\model\system\ComImages;
use think\facade\App;
use think\facade\Filesystem;
use utils\SparkTools;

class Attachment extends Base
{
    /**
     * 资源管理中的上传图片
     */
    public function upload()
    {
        $file = request()->file('file');
        $cateId = input('param.cate_id', 0);

        // 上传到本地服务器
        try {

            $imageConf = config('images');
            $extMap = explode('|', $imageConf['ext']);
            $mineMap = explode(',', $imageConf['acceptMime']);

            // 检测文件类型
            $mine = $file->getMime();
            if (!in_array($mine, $mineMap)) {
                return json(['code' => -2, 'data' => [], 'msg' => '上传图片类型有误']);
            }

            // 检测文件后缀
            $ext = $file->getOriginalExtension();
            if (!in_array($ext, $extMap)) {
                return json(['code' => -3, 'data' => [], 'msg' => '上传图片类型有误']);
            }

            $imageModel = new ComImages();
            $has = $imageModel->checkImageExist($file->hash());
            if ($has['code'] != 0) {
                return json($has);
            }

            // 存到本地
            $saveName = Filesystem::disk('public')->putFile('local', $file);
            $url = request()->domain() . DS . 'storage' . DS . $saveName;
            $storeWay = getConfByType('store')['store_way'];
            if ($storeWay != 'local') {
                $url = SparkTools::storeOSS($storeWay, $file, $saveName);
            }

            // 存储入库
            $sourceId = $imageModel->insertGetId([
                'cate_id' => $cateId,
                'name' => $file->getOriginalName(),
                'sha1' => $file->hash(),
                'url' => $url,
                'path' => app()->getRootPath() . 'public' . DS . 'storage' . DS . $saveName,
                'ext' => $ext,
                'folder' => 'local' . DS . date('Ymd'),
                'type' => $storeWay,
                'create_time' => date('Y-m-d H:i:s')
            ]);

            // 添加水印
            // Image::water(app()->getRootPath() . 'public/storage/' . $saveName);
        } catch (\Exception $e) {

            return json(['code' => -1, 'data' => [], 'msg' => $e->getMessage()]);
        }

        return json(['code' => 0, 'data' => ['url' => $url], 'msg' => '上传成功']);
    }

    /**
     * 删除图片
     */
    public function del()
    {
        if (request()->isAjax()) {

            $sourceId = input('param.id');
            $path = input('param.path');

            $imageModel = new ComImages();
            $res = $imageModel->delById($sourceId);

            @unlink($path);

            return json($res);
        }
    }

    /**
     * 上传 商品video
     * TODO 后面扩展成分片上传
     */
    public function uploadFile()
    {
        set_time_limit(0);
        $file = request()->file('file');

        // 上传到本地服务器
        try {

            $extMap = explode('|', config('images.video_ext'));

            // 检测文件后缀
            $ext = $file->getOriginalExtension();
            if (!in_array($ext, $extMap)) {
                return json(['code' => -3, 'data' => [], 'msg' => '上传视频类型有误']);
            }

            // 存到本地
            $saveName = Filesystem::disk('public')->putFile('video', $file);
            $url = request()->domain() . DS . 'storage' . DS . $saveName;
            $storeWay = getConfByType('store')['store_way'];
            if ($storeWay != 'local') {
                $url = SparkTools::storeOSS($storeWay, $file, $saveName);
            }

        } catch (\Exception $e) {

            return json(['code' => -1, 'data' => [], 'msg' => $e->getMessage()]);
        }

        return json(['code' => 0, 'data' => ['url' => $url], 'msg' => '上传成功']);
    }

    /**
     * 上传其他资源
     * @return \think\response\Json
     */
    public function uploadOtherFile()
    {
        set_time_limit(0);
        $file = request()->file('file');
        // 上传到本地服务器
        try {

            // 存到本地
            $saveName = Filesystem::disk('public')->putFile('other', $file);

        } catch (\Exception $e) {

            return json(['code' => -1, 'data' => [], 'msg' => $e->getMessage()]);
        }

        return json(['code' => 0, 'data' => [
            'url' => App::getRootPath() . 'public' . DS . 'storage' . DS . $saveName,
            'name' => rtrim($file->getOriginalName(), '.zip')
        ], 'msg' => '上传成功']);
    }
}