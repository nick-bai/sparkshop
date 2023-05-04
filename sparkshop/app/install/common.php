<?php

const SUCCESS = 'layui-icon-ok-circle';
const ERROR = 'layui-icon-close-fill';

if (!function_exists('checkenv')) {
    /**
     * 检测环境变量
     */
    function checkenv()
    {
        $items = [];
        $items['php'] = PHP_VERSION;
        $items['mysqli'] =  extension_loaded('mysqli');
        $items['redis'] = extension_loaded('redis');
        $items['curl'] = extension_loaded('curl');
        $items['fileinfo'] = extension_loaded('fileinfo');
        $items['exif'] = extension_loaded('exif');
        $items['gd'] = extension_loaded('gd');

        return $items;
    }
}

if (!function_exists('check_dirfile')) {
    /**
     * 检测读写环境
     */
    function check_dirfile()
    {
        $items = array(
            array('dir', SUCCESS, SUCCESS, './'),
            array('dir', SUCCESS, SUCCESS, './public'),
            array('dir', SUCCESS, SUCCESS, './public/storage'),
            array('dir', SUCCESS, SUCCESS, './runtime'),
            array('dir', SUCCESS, SUCCESS, './extend'),
            // array('dir', SUCCESS, SUCCESS, './test/1.txt'),
        );

        foreach ($items as &$value) {

            $item = root_path().$value[3];

            // 写入权限
            if (!is_writable($item)) {
                $value[1] = ERROR;
            }
            // 读取权限
            if (!is_readable($item)) {
                $value[2] = ERROR;
            }
        }

        return $items;
    }
}

if (!function_exists('parse_array_ini')) {
    /**
     * 解析数组到ini文件
     * @param  array 	$array 		数组
     * @param  string 	$content 	字符串
     * @return string	返回一个ini格式的字符串
     */
    function parse_array_ini($array,$content = '')
    {

        foreach ($array as $key => $value) {
            if (is_array($value)) {
                // 分割符PHP_EOL
                $content .= PHP_EOL.'['.$key.']'.PHP_EOL;
                foreach ($value as $field => $data) {
                    $content .= $field .' = '. $data . PHP_EOL;
                }

            }else {
                $content .= $key .' = '. $value . PHP_EOL;
            }
        }

        return $content;
    }
}

if (!function_exists('write_file')) {
    /**
     * 数据写入文件
     * @param  string  $file    文件路径
     * @param  string  $content 文件数据
     * @return content
     */
    function write_file($file, $content='')
    {
        $dir = dirname($file);
        if(!is_dir($dir)){
            mkdir($dir);
        }
        return @file_put_contents($file, $content);
    }
}
