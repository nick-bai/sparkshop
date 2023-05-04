百度UEditor 上传插件包使用说明
Composer 安装：<br />
composer require tanzhenxing/ueditor-thinkphp

# UEditor php 上传文件封装

### 使用：
```
use Ueditor\Ueditor;

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
    	$start = array_get($params, 'start');
    	$size = array_get($params, 'size');
        $result = $ueditor->listImage()->getListImage($start, $size);
        break;
    /* 列出文件 */
    case 'listfile':
    	$start = array_get($params, 'start');
    	$size = array_get($params, 'size');
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
```