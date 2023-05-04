<?php
// 应用公共文件
use app\model\system\Plugins;
use app\model\system\SysSetting;
use think\facade\Event;
use think\facade\Log;
use think\facade\Route;
use think\facade\View;
use think\helper\{Str};

/**
 * 模型内统一数据返回
 * @param $code
 * @param string $msg
 * @param array $data
 * @return array
 */

if (!function_exists('dataReturn')) {

    function dataReturn($code, $msg = 'success', $data = [])
    {
        return ['code' => $code, 'data' => $data, 'msg' => $msg];
    }
}

/**
 * 统一返回json数据
 * @param $code
 * @param string $msg
 * @param array $data
 * @return \think\response\Json
 */
if (!function_exists('jsonReturn')) {

    function jsonReturn($code, $msg = 'success', $data = [])
    {
        return json(['code' => $code, 'data' => $data, 'msg' => $msg]);
    }
}

/**
 * 统一分页返回
 * @param $list
 * @return array
 */
if (!function_exists('pageReturn')) {

    function pageReturn($list)
    {
        if (0 == $list['code']) {
            return ['code' => 0, 'msg' => 'success', 'data' => [
                'total' => $list['data']->total(),
                'rows' => $list['data']->all()
            ]];
        }

        return ['code' => 0, 'msg' => 'success', [
            'total' => 0,
            'rows' => []
        ]];
    }
}

/**
 * 生成密码
 * @param $password
 * @param $salt
 * @return string
 */
function makePassword($password, $salt = '')
{

    if (empty($salt)) {
        $salt = config('shop.salt');
    }

    return sha1(md5(md5($password . $salt)));
}

/**
 * 生成子孙树
 * @param $data
 * @return array
 */
function makeTree($data)
{

    $res = [];
    $tree = [];

    // 整理数组
    foreach ($data as $key => $vo) {
        $res[$vo['id']] = $vo;
    }
    unset($data);

    // 查询子孙
    foreach ($res as $key => $vo) {
        if ($vo['pid'] != 0) {
            $res[$vo['pid']]['child'][] = &$res[$key];
        }
    }

    // 去除杂质
    foreach ($res as $key => $vo) {
        if ($vo['pid'] == 0) {
            $tree[] = $vo;
        }
    }
    unset($res);

    return $tree;
}

function now()
{
    return date('Y-m-d H:i:s');
}

function platform()
{
    $platform = 'h5';
    $agent = strtolower($_SERVER['HTTP_USER_AGENT']);
    if (strpos($agent, "micromessenger")) { // 公众号MicroMessenger
        if (strpos($agent, "miniprogram")) { // 小程序
            $platform = 'mpapp';
        } else
            $platform = 'wxapp';

    } elseif (strpos($agent, "uni-app") || strpos($agent, "Html5Plus")) { // app
        $platform = 'app';
    }

    return $platform;
}

/**
 * array_get php的实现
 * @param $array
 * @param $key
 * @param null $default
 * @return mixed
 */
function arrayGet($array, $key, $default = null)
{
    if (is_null($key)) {
        return $array;
    }

    if (isset($array[$key])) {
        return $array[$key];
    }

    foreach (explode('.', $key) as $segment) {
        if (!is_array($array) || !array_key_exists($segment, $array)) {
            return value($default);
        }

        $array = $array[$segment];
    }
    return $array;
}

/**
 * 生成订单号
 * @param $business
 * @return string
 */
function makeOrderNo($business)
{
    return $business . date('YmdHis') . GetNumberCode(6);
}

/**
 * 随机数生成生成
 * @param int $length
 * @return string
 */
function GetNumberCode($length = 6)
{
    $code = '';
    for ($i = 0; $i < intval($length); $i++) {
        $code .= rand(0, 9);
    }

    return $code;
}

/**
 * 生成随机验证码
 * @param $len
 * @return int
 */
function makeRandNumber($len)
{
    $start = pow(10, $len - 1);
    $end = pow(10, $len) - 1;

    return rand($start, $end);
}

/**
 * 格式化短信数据
 * @param $param
 * @return array
 */
function formatSmsData($param)
{
    $code = makeRandNumber(6);
    return [
        'accessKeyId' => $param['access_key_id'],
        'accessKeySecret' => $param['access_key_secret'],
        'signName' => $param['sign_name'],
        'templateCode' => $param['templateCode'],
        'phone' => $param['phone'],
        'code' => json_encode(['code' => $code])
    ];
}

/**
 * 根据ip定位
 * @param $ip
 * @param $type
 * @return string | array
 * @throws Exception
 */
function getLocationByIp($ip, $type = 1)
{
    $ip2region = new \Ip2Region();
    $info = $ip2region->btreeSearch($ip);

    $info = explode('|', $info['region']);

    $address = '';
    foreach ($info as $vo) {
        if ('0' !== $vo) {
            $address .= $vo . '-';
        }
    }

    if (2 == $type) {
        return ['province' => $info['2'], 'city' => $info['3']];
    }

    return rtrim($address, '-');
}

/**
 * 获取配置
 * @param $type
 * @return array
 */
function getConfByType($type)
{
    try {

        $configModel = new SysSetting();
        $config = $configModel->where('type', $type)->select();
        $formatConfig = [];
        foreach ($config as $vo) {
            $formatConfig[$vo['key']] = $vo['value'];
        }

        return $formatConfig;
    } catch (\Exception $e) {
        return [];
    }
}

/**
 * 名字加密
 * @param $name
 * @return string
 */
function encryptName($name)
{
    $encryptName = '';
    // 判断是否包含中文字符
    if (preg_match("/[\x{4e00}-\x{9fa5}]+/u", $name)) {
        // 按照中文字符计算长度
        $len = mb_strlen($name, 'UTF-8');
        // echo '中文';
        if ($len >= 3) {
            // 三个字符或三个字符以上掐头取尾，中间用*代替
            $encryptName = mb_substr($name, 0, 1, 'UTF-8') . str_repeat('*', $len - 2) . mb_substr($name, -1, 1, 'UTF-8');
        } elseif ($len === 2) {
            //两个字符
            $encryptName = mb_substr($name, 0, 1, 'UTF-8') . '*';
        }
    } else {
        // 按照英文字串计算长度
        $len = strlen($name);
        // echo 'English';
        if ($len >= 3) {
            // 三个字符或三个字符以上掐头取尾，中间用*代替
            $encryptName = substr($name, 0, 1) . str_repeat('*', $len - 2) . substr($name, -1);
        } elseif ($len === 2) {
            // 两个字符
            $encryptName = substr($name, 0, 1) . '*';
        }
    }

    return $encryptName;
}

/**
 * 删除空目录
 * @param string $path
 */
function removeEmptyDir(string $path)
{
    $path_handle = opendir($path);
    readdir($path_handle);
    readdir($path_handle); //读取目录两个自带的隐藏目录'.'和'..'

    if (!(bool)readdir($path_handle)) {
        rmdir($path);
    }
}

/**
 * 获取redis对象
 * @return Redis
 */
function getRedisHandler()
{
    $redis = new \Redis();
    $redis->connect(env('redis.host', ''), env('redis.port', ''), 60);
    if (!empty(env('redis.password', ''))) {
        $redis->auth(env('redis.password', ''));
    }

    return $redis;
}

/**
 * 构建 404访问页面
 * @param $res
 * @return string
 */
function build404($res)
{
    return View::fetch('/404', [
        'error' => $res['msg'],
        'url' => isset(request()->header()['referer']) ? request()->header()['referer'] : '/'
    ]);
}

/**
 * 设置jwt
 * @param $data
 * @return string
 */
function setJWT($data)
{
    $jwt = new Firebase\JWT\JWT();
    $token = [
        // "iss"  => "http://example.org", // 签发者
        // "aud"  => "http://example.com", // 认证者
        'iat' => time(), // 签发时间
        'nbf' => time(), // 生效时间
        'exp' => (time() + 60 * 60 * 24 * 7), // 过期时间  7天后的时间戳
        'data' => $data
    ];

    return $jwt::encode($token, \config('shop.jwt_key'), 'HS256');
}

/**
 * 获取token中的信息
 * @param $token
 * @return array|null
 */
function getJWT($token)
{
    $jwt = new Firebase\JWT\JWT();
    $data = [];
    try {
        $jwtData = $jwt::decode($token, new Firebase\JWT\Key(\config('shop.jwt_key'), 'HS256'));
        $data = (array)($jwtData->data);
    } catch (\Exception $e) {
        Log::write($e->getMessage(), 'error');
        return null;
    }
    return $data;
}

/**
 * 从头部获取token
 * @return bool|string
 */
function getHeaderToken()
{
    $header = request()->header();
    if (isset($header['authorization'])) {
        return substr($header['authorization'], 7);
    }

    return '';
}

/**
 * 跨域配置
 */
function crossDomain()
{

    header("access-control-allow-headers: X-CSRF-TOKEN, Authorization, Content-Type, If-Match, If-Modified-Since, If-None-Match, If-Unmodified-Since, X-Requested-With");
    header("access-control-allow-methods: OPTIONS, GET, POST, PATCH, PUT, DELETE");
    header("access-control-allow-origin: *");
}

/**
 * 插件中渲染模板
 * @param string $tpl
 * @param array $data
 * @return string
 */
function fetch($tpl = '', $data = [])
{

    $pathInfo = explode('/', request()->pathinfo());
    $tpl = empty($tpl) ? rtrim($pathInfo[3], '.html') : $tpl;

    $view = View::engine('Think');
    $view->config([
        'view_path' => \think\facade\App::getRootPath() . $pathInfo[0] . '/' . $pathInfo[1] . '/view/'
    ]);

    return $view->fetch($tpl, $data);
}

// 插件类库自动载入
spl_autoload_register(function ($class) {

    $class = ltrim($class, '\\');

    $dir = app()->getRootPath();
    $namespace = 'addons';

    if (strpos($class, $namespace) === 0) {
        $class = substr($class, strlen($namespace));
        $path = '';
        if (($pos = strripos($class, '\\')) !== false) {
            $path = str_replace('\\', '/', substr($class, 0, $pos)) . '/';
            $class = substr($class, $pos + 1);
        }
        $path .= str_replace('_', '/', $class) . '.php';
        $dir .= $namespace . $path;

        if (file_exists($dir)) {
            include $dir;
            return true;
        }

        return false;
    }

    return false;

});

if (!function_exists('hook')) {
    /**
     * 处理插件钩子
     * @param string $event 钩子名称
     * @param array|null $params 传入参数
     * @param bool $once 是否只返回一个结果
     * @return mixed
     */
    function hook($event, $params = null, bool $once = false)
    {
        $result = Event::trigger($event, $params, $once);

        return join('', $result);
    }
}

if (!function_exists('get_addons_class')) {
    /**
     * 获取插件类的类名
     * @param string $name 插件名
     * @param string $type 返回命名空间类型
     * @param string $class 当前类名
     * @return string
     */
    function get_addons_class($name, $type = 'hook', $class = null)
    {
        $name = trim($name);
        // 处理多级控制器情况
        if (!is_null($class) && strpos($class, '.')) {
            $class = explode('.', $class);
            $class[count($class) - 1] = Str::studly(end($class));
            $class = implode('\\', $class);

        } else {
            $class = Str::studly(is_null($class) ? $name : $class);
        }

        switch ($type) {
            case 'controller':
                $namespace = '\\addons\\' . $name . '\\controller\\' . $class;
                break;
            default:
                $namespace = '\\addons\\' . $name . '\\event\\' . $class;
        }

        return class_exists($namespace) ? $namespace : '';
    }
}

if (!function_exists('addons_url')) {
    /**
     * 插件显示内容里生成访问插件的url
     * @param $url
     * @param array $param
     * @param bool|string $suffix 生成的URL后缀
     * @param bool|string $domain 域名
     * @return bool|string
     */
    function addons_url($url = '', $param = [], $suffix = true, $domain = false)
    {
        $request = app('request');
        if (empty($url)) {
            // 生成 url 模板变量
            $addons = $request->addon;
            $controller = $request->controller();
            $controller = str_replace('/', '.', $controller);
            $action = $request->action();
        } else {
            $url = Str::studly($url);
            $url = parse_url($url);
            if (isset($url['scheme'])) {
                $addons = strtolower($url['scheme']);
                $controller = $url['host'];
                $action = trim($url['path'], '/');
            } else {
                $route = explode('/', $url['path']);
                $addons = $request->addon;
                $action = array_pop($route);
                $controller = array_pop($route) ?: $request->controller();
            }
            $controller = Str::snake(Str::lower((string)$controller));

            /* 解析URL带的参数 */
            if (isset($url['query'])) {
                parse_str($url['query'], $query);
                $param = array_merge($query, $param);
            }
        }

        return Route::buildUrl("@addons/{$addons}/{$controller}/{$action}", $param)->suffix($suffix)->domain($domain);
    }
}

/**
 * 获取当前用户
 * @return array|null
 */
function getUserInfo() {
    return getJWT(getHeaderToken());
}

/**
 * 检测是否安装了某个插件
 * @param $flag
 * @return bool
 */
function hasInstalled($flag) {
    $info = (new Plugins())->findOne(['name' => $flag])['data'];
    return !empty($info);
}

/**
 * 删除目录
 * @param $dir
 * @return bool
 */
function delDir($dir) {
    // 先删除目录下的文件：
    $dh = opendir($dir);
    while ($file = readdir($dh)) {
        if ($file != "." && $file != "..") {

            $fullPath = $dir . "/" . $file;
            if (!is_dir($fullPath)) {
                unlink($fullPath);
            } else {
                delDir($fullPath);
            }
        }
    }

    closedir($dh);
    // 删除当前文件夹：
    if (rmdir($dir)) {
        return true;
    } else {
        return false;
    }
}

/**
 * 创建目录
 * @param $path
 * @return void
 */
function mk_dir($path) {
    // 第1种情况，该目录已经存在
    if (is_dir($path)) {
        return;
    }

    // 第2种情况，父目录存在，本身不存在
    if (is_dir(dirname($path))) {
        mkdir($path);
    }

    // 第3种情况，父目录不存在
    if (!is_dir(dirname($path))) {
        mk_dir(dirname($path)); // 创建父目录
        mkdir($path);
    }
}

/**
 * zip解压方法
 * @param string $filePath 压缩包所在地址 【绝对文件地址】d:/test/123.zip
 * @param string $path 解压路径 【绝对文件目录路径】d:/test
 * @return bool
 */
function unzip($filePath, $path) {
    if (empty($path) || empty($filePath)) {
        return false;
    }

    $zip = new ZipArchive();

    if ($zip->open($filePath) === true) {
        $zip->extractTo($path);
        $zip->close();
        return true;
    } else {
        return false;
    }
}

/**
 * post提交
 * @param $url
 * @param $data
 * @return bool|string
 */
function curlPost($url, $data) {
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_HEADER, 0);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0); // 对认证证书来源的检查
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0); // 从证书中检查SSL加密算法是否存在
    curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
    $output = curl_exec ($ch);
    curl_close ($ch);

    return json_decode($output, true);
}

/**
 * get 提交
 * @param $url
 * @param $data
 * @return mixed
 */
function curlGet($url, $data) {
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url . '?' . http_build_query($data));
    curl_setopt($ch, CURLOPT_HEADER, 0);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);;
    $output = curl_exec($ch);
    curl_close($ch);

    return json_decode($output,true);
}

/**
 * 构建菜单项目
 * @param $pid
 * @param $type
 * @param $name
 * @param $path
 * @param $icon
 * @param $isMenu
 * @param $sort
 * @param $status
 * @return array
 */
function makeMenuItem($pid, $type, $name, $path, $icon = '', $isMenu = 1, $sort = 0, $status = 1) {
    return [
        'pid' => $pid,
        'type' => $type,
        'name' => $name,
        'path' => $path,
        'icon' => $icon,
        'is_menu' => $isMenu,
        'sort' => $sort,
        'status' => $status,
        'create_time' => now()
    ];
}

/**
 * 检测登陆
 * @return void
 */
function pcLoginCheck() {
    if (empty(session('home_user_id'))) {

        if (request()->isAjax()) {
            exit(json_encode(['code' => 403, 'data' => [], 'msg' => '请先登录']));
        } else {
            exit(header(("location:/index/login/index")));
        }
    }
}