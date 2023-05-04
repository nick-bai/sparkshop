<?php

/**
 * @author Masterton
 * @version 1.0.0
 * @time 2017-8-14 14:42:49
 * UEditor编辑器文件上传入口类
 */

namespace Ueditor;

class Ueditor
{
    /**
     * 百度编辑器
     * Ueditor Configure
     * @var array
     *
     */
    private $config;


    public function __construct()
    {
        $this->config = Config::getConfig();
    }

    /**
     * 获取配置信息
     *
     */
    public function getConfig()
    {
        return $this->config;
    }

    /**
     * 上传图片
     *
     */
    public function uploadImage()
    {
        return new ActionUpload($this->config);
    }

    /**
     * 上传涂鸦
     *
     */
    public function uploadScrawl()
    {
        return new ActionUpload($this->config);
    }

    /**
     * 上传视频
     *
     */
    public function uploadVideo()
    {
        return new ActionUpload($this->config);
    }

    /**
     * 上传文件
     *
     */
    public function uploadFile()
    {
        return new ActionUpload($this->config);
    }

    /**
     * 列出图片
     *
     */
    public function listImage()
    {
        return new ActionList($this->config);
    }

    /**
     * 列出文件
     *
     */
    public function listFile()
    {
        return new ActionList($this->config);
    }

    /**
     * 抓取远程文件
     *
     */
    public function catchImage()
    {
        return new ActionCrawler($this->config);
    }
}