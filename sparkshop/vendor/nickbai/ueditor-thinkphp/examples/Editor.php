<?php
/**
 * Created by PhpStorm.
 * User: tanzhenxing
 * Date: 2018/4/16
 * Time: 21:59
 */
namespace app\index\controller;

use Ueditor\Ueditor;

class Editor
{
    /**
     * 百度编辑器
     * @param string $action
     * @param string $params
     * @return mixed
     */
    public function index($action = '', $params = '')
    {
        $ueditor = new Ueditor();

        switch ($action) {
            case 'config':
                $result = $ueditor->getConfig();
                break;

            /* 上传图片 */
            case 'uploadimage':
                $result = $ueditor->uploadImage()->saveImage();
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
                $start = $params('start');
                $size = $params( 'size');
                $result = $ueditor->listImage()->getListImage($start, $size);

                break;
            /* 列出文件 */
            case 'listfile':
                $start = $params('start');
                $size = $params('size');
                $result = $ueditor->listFile()->getListFile($start, $size);
                break;

            /* 抓取远程文件 */
            case 'catchimage':
                $result = $ueditor->catchImage()->crawlerImage();
                break;

            default:
                $result = [
                    'state'=> '请求地址出错'
                ];
                break;
        }

        return json_encode($result);
    }

}