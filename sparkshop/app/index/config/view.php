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

// 后台主题
define('THEME', 'default');

return [
    // 模板引擎类型使用Think
    'type' => 'Think',
    // 默认模板渲染规则 1 解析为小写+下划线 2 全部转换小写 3 保持操作方法
    'auto_rule' => 1,
    // 模板目录名
    'view_dir_name' => 'view' . DS . THEME,
    // 模板后缀
    'view_suffix' => 'html',
    // 模板文件名分隔符
    'view_depr' => DIRECTORY_SEPARATOR,
    // 模板引擎普通标签开始标记
    'tpl_begin' => '{',
    // 模板引擎普通标签结束标记
    'tpl_end' => '}',
    // 标签库标签开始标记
    'taglib_begin' => '{',
    // 标签库标签结束标记
    'taglib_end' => '}',
    // 模板引用静态资源路径
    'tpl_replace_string' => [
        '{__STATIC__}' => '/static/home/' . THEME,
        '{__CSS__}' => '/static/home/' . THEME . '/css',
        '{__JS__}' => '/static/home/' . THEME . '/js',
        '{__IMG__}' => '/static/home/' . THEME . '/image',
    ],
];
