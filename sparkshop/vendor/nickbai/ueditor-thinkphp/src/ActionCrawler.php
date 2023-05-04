<?php

/**
 * @author Masterton
 * @version 1.0.0
 * @time 2017-8-14 15:07:40
 */

namespace Ueditor;


class ActionCrawler
{
    /**
     * 配置信息
     * @var array
     *
     */
    private $config;

    /**
     * 构造方法
     * ActionCrawler constructor.
     * @param $config
     */
    public function __construct($config)
    {
        $this->config = $config;
    }

    /**
     * 抓取远程图片
     *
     */
    public function crawlerImage()
    {
        /* 上传配置 */
        $crawlerConfig = array(
            "pathFormat" => $this->config['catcherPathFormat'],
            "maxSize" => $this->config['catcherMaxSize'],
            "allowFiles" => $this->config['catcherAllowFiles'],
            "oriName" => "remote.png"
        );
        $fieldName = $this->config['catcherFieldName'];

        /* 抓取远程图片 */
        $list = [];
        if (isset($_POST[$fieldName])) {
            $source = $_POST[$fieldName];
        } else {
            $source = $_GET[$fieldName];
        }
        foreach ($source as $imgUrl) {
            $item = new Uploader($imgUrl, $crawlerConfig, "remote");
            $info = $item->getFileInfo();
            array_push($list, [
                "state" => $info["state"],
                "url" => $info["url"],
                "size" => $info["size"],
                "title" => htmlspecialchars($info["title"]),
                "original" => htmlspecialchars($info["original"]),
                "source" => htmlspecialchars($imgUrl),
                'file_path' => str_replace( '\\' , '/' , realpath(dirname(__FILE__).'/../../../../web/')).$info["url"]
            ]);
        }// TODO

        /* 返回抓取数据 */
        return [
            'state'=> count($list) ? 'SUCCESS':'ERROR',
            'list'=> $list
        ];
    }
}