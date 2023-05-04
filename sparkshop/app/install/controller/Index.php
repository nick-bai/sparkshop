<?php
declare (strict_types=1);

namespace app\install\controller;

use app\BaseController;

class Index extends BaseController
{
    /**
     * 使用协议
     */
    public function index()
    {
        return include './install/index.html';
    }

    /**
     * 检测安装环境
     */
    public function step1()
    {

        if (request()->isPost()) {

            // 服务环境检测
            if (function_exists('saeAutoLoader') || isset($_SERVER['HTTP_BAE_ENV_APPID'])) {
                return json(['code' => 105, 'msg' => '对不起，当前环境不支持本系统，请使用独立服务或云主机！']);
            }

            // 检测生产环境
            foreach (checkenv() as $key => $value) {

                if ($key == 'php' && (float)$value < 7.2) {
                    return json(['code' => 101, 'msg' => '您的php版本太低，不能安装本软件，兼容php版本7.2~7.4，谢谢！']);
                }

                if ($key == 'php' && (float)$value > 8) {
                    return json(['code' => 101, 'msg' => '您的php版本太高，不能安装本软件，兼容php版本7.2~7.4，谢谢！']);
                }

                if ($value == false && $value != 'redis') {
                    return json(['code' => 101, 'msg' => $key . '扩展未安装！']);
                }
            }

            // 检测目录权限
            foreach (check_dirfile() as $value) {
                if ($value[1] == ERROR
                    || $value[2] == ERROR) {
                    return json(['code' => 101, 'msg' => $value[3] . ' 权限读写错误！']);
                }
            }

            cache('checkenv', 'success', 3600);
            return json(['code' => 200, 'url' => '/install/index/step2']);
        }

        $checkenv = checkenv();
        $checkdirfile = check_dirfile();
        include './install/step1.html';
    }

    /**
     * 检查环境变量
     */
    public function step2()
    {
        if (!cache('checkenv')) {
            return redirect('/install/index/step1');
        }

        if (request()->isPost()) {

            $post = input();

            // redis链接检测
            try {

                $redis = new \Redis();
                $redis->connect($post['redis_host'], intval($post['redis_port']), 2);
                if (!empty($post['redis_pwd'])) {
                    $redis->auth($post['redis_pwd']);
                }
            } catch (\Exception $e) {
                return json(['code' => 101, 'msg' => 'redis配置错误']);
            }

            // 链接数据库
            $connect = @mysqli_connect($post['hostname'] . ':' . $post['hostport'], $post['username'], $post['password']);
            if (!$connect) {
                return json(['code' => 101, 'msg' => '数据库链接失败！']);
            }

            // 检测MySQL版本
            $mysqlInfo = mysqli_get_server_info($connect);
            if ((float)$mysqlInfo < 5.6) {
                return json(['code' => 101, 'msg' => 'MySQL版本过低！']);
            }

            // 查询数据库名
            $database = mysqli_select_db($connect, $post['database']);
            if (!$database) {
                $query = "CREATE DATABASE IF NOT EXISTS `" . $post['database'] . "` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;";
                if (!mysqli_query($connect, $query)) {
                    return json(['code' => 101, 'msg' => '数据库创建失败或已存在，请手动修改！']);
                }
            } else {
                $mysql_table = mysqli_query($connect, 'SHOW TABLES FROM' . ' `' . $post['database'] . '`');
                $mysql_table = mysqli_fetch_array($mysql_table);
                if (!empty($mysql_table) && is_array($mysql_table)) {
                    return json(['code' => 101, 'msg' => '数据表已存在，请勿重复安装！']);
                }
            }

            cache('mysql', $post, 3600);
            return json(['code' => 200, 'url' => '/install/index/step3']);
        }

        include './install/step2.html';
    }

    /**
     * 初始化数据库
     */
    public function step3()
    {

        $mysql = cache('mysql');
        if (!$mysql) {
            return redirect('/install/index/step2');
        }

        include './install/step3.html';
    }

    /**
     * 启动安装
     */
    public function install()
    {
        if (request()->isAjax()) {

            $mysql = cache('mysql');
            if (is_file('../extend/install/install.lock') || !$mysql) {
                return '请勿重复安装本系统';
            }

            // 获取变量文件
            $env = app_path() . 'install.env';
            $parse = parse_ini_file($env, true);
            $parse['DATABASE']['HOSTNAME'] = $mysql['hostname'];
            $parse['DATABASE']['HOSTPORT'] = $mysql['hostport'];
            $parse['DATABASE']['DATABASE'] = $mysql['database'];
            $parse['DATABASE']['USERNAME'] = $mysql['username'];
            $parse['DATABASE']['PASSWORD'] = $mysql['password'];
            $parse['DATABASE']['PREFIX'] = $mysql['prefix'];

            $parse['REDIS']['HOST'] = $mysql['redis_host'];
            $parse['REDIS']['PORT'] = $mysql['redis_port'];
            $parse['REDIS']['PASSWORD'] = $mysql['redis_pwd'];

            $content = parse_array_ini($parse);
            write_file(root_path() . '.env', $content);

            // 读取MySQL数据
            $path = app_path() . 'install.sql';
            $sql = file_get_contents($path);
            $sql = str_replace("\r", "\n", $sql);

            $domain = request()->domain();
            // 替换数据库表前缀
            $sql = explode(";\n", $sql);
            $sql = str_replace("{PREFIX}", "{$mysql['prefix']}", $sql);
            $sql = str_replace("{DOMAIN}", "{$domain}", $sql);
            $spDomain = str_replace('/', '\\/', $domain);
            $sql = str_replace("{SPDOMAIN}", "{$spDomain}", $sql);

            // 缓存任务总数
            cache('total', count($sql), 3600);

            // 链接数据库
            $connect = @mysqli_connect($mysql['hostname'] . ':' . $mysql['hostport'], $mysql['username'], $mysql['password']);
            mysqli_select_db($connect, $mysql['database']);
            mysqli_query($connect, "set names utf8mb4");

            $logs = [];
            $nums = 0;
            try {
                // 写入数据库
                foreach ($sql as $key => $value) {

                    cache('progress', $key, 3600);
                    $value = trim($value);
                    if (empty($value)) {
                        continue;
                    }

                    if (substr($value, 0, 12) == 'CREATE TABLE') {
                        $name = preg_replace("/^CREATE TABLE `(\w+)` .*/s", "\\1", $value);
                        $msg = "创建数据表 {$name}...";

                        if (false !== mysqli_query($connect, $value)) {
                            $msg .= '成功！';
                            $logs[$nums] = [
                                'id' => $nums,
                                'msg' => $msg,
                            ];
                            $nums++;
                            cache('tasks', $logs, 3600);
                        }
                    } else {
                        mysqli_query($connect, $value);
                    }
                }

            } catch (\Throwable $th) { // 异常信息
                cache('error', $th->getMessage(), 7200);
                exit();
            }

            // 修改初始化密码
            $salt = uniqid();
            $pwd = makePassword(empty($mysql['pwd']) ? 'admin123' : $mysql['pwd'], $salt);
            mysqli_query($connect, "UPDATE {$mysql['prefix']}admin_user SET password='{$pwd}', salt='{$salt}' where id = 1");

            write_file(root_path() . 'extend/install/install.lock', true);
        }
    }

    /**
     * 获取安装进度
     */
    public function progress()
    {
        if (request()->isAjax()) {

            // 查询错误
            $error = cache('error');
            if (!empty($error)) {
                return json(['code' => 101, 'msg' => $error]);
            }

            // 获取任务信息
            $tasks = cache('tasks') ?? [
                'id' => 9999,
                'msg' => '获取任务信息失败！',
            ];
            $progress = round(cache('progress') / cache('total') * 100) . '%';

            $result = [
                'code' => 200,
                'msg' => $tasks,
                'progress' => $progress,
            ];

            return json($result);
        }
    }

    /**
     * 清理安装文件包
     */
    public function clear()
    {

    }
}

