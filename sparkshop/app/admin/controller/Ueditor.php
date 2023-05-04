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

class Ueditor extends Base
{
    /**
     * ueditor 统一处理方法
     * @param string $action
     * @return \think\response\Json
     */
    public function index($action = '')
    {
        $params = input('param.');
        $ueditor = new \Ueditor\Ueditor();

        switch ($action) {
            case 'config':

                $result = $ueditor->getConfig();
                break;
            /* 上传图片 */
            case 'uploadimage':

                $result = $ueditor->uploadImage()->saveImage();
                // 记录入库
                $imageModel = new ComImages();
                $sourceId = $imageModel->insertGetId([
                    'cate_id' => 0,
                    'name' => $result['original'],
                    'sha1' => sha1_file($result['file_path']),
                    'url' => $result['url'],
                    'path' => $result['file_path'],
                    'ext' => '',
                    'folder' => 'ueditor/' . date('Ymd'),
                    'type' => 'local',
                    'create_time' => date('Y-m-d H:i:s')
                ]);
                break;
            /* 上传涂鸦 */
            case 'uploadscrawl':

                $result = $ueditor->uploadImage()->saveScrawl();
                break;
            /* 上传视频 */
            case 'uploadvideo':

                $result = $ueditor->uploadImage()->saveVideo();
                break;
            /* 上传文件 */
            case 'uploadfile':

                $result = $ueditor->uploadImage()->saveFile();
                break;
            /* 列出图片 */
            case 'listimage':

                $start = arrayGet($params, 'start');
                $size = arrayGet($params, 'size');
                $result = $ueditor->listImage()->getListImage($start, $size);
                break;
            /* 列出文件 */
            case 'listfile':

                $start = arrayGet($params, 'start');
                $size = arrayGet($params, 'size');
                $result = $ueditor->listFile()->getListFile($start, $size);
                break;
            /* 抓取远程文件 */
            case 'catchimage':

                $result = $ueditor->catchImage()->crawlerImage();
                break;
            default:
                $result = [
                    'state' => '请求地址出错'
                ];
                break;
        }

        return json($result);
    }
}