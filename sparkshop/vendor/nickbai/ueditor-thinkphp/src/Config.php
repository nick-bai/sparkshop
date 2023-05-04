<?php

/**
 * @author Masterton
 * @version 1.0.0
 * @time 2017-8-14 14:42:49
 * UEditor编辑器通用配置文件
 */

namespace Ueditor;

class Config
{
    /**
     * 前后端通信相关的配置,注释只允许使用多行方式
     * @return array
     */
    public static function getConfig()
    {
        return config('ueditor');
    }   
}
