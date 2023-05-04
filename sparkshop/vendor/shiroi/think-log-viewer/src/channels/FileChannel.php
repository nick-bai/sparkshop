<?php

namespace Shiroi\ThinkLogViewer\channels;

class FileChannel
{
    private array $config = [];

    protected string $log_path;

    protected array $all_log = [];

    protected array $param = [];

    protected string $log_file = '';

    protected string $content = '';

    protected array $content_arr = [];

    protected array $splice_content_arr = [];

    protected int $total = 0;

    protected int $totalPage = 0;

    public function __construct($channel) {
        $this->config = $channel;
        $this->initLog();
        $this->loadParam();
        $this->loadLog();
    }

    public function view()
    {
        include_once __DIR__."/../view/index.php";
    }

    private function initLog() {
        $this->log_path = public_path($this->config['path']);
        $this->all_log = $this->getDirs($this->log_path);
        krsort($this->all_log);
    }

    private function loadParam() {
        $this->param = array_merge(request()->get(),['page' => $this->getPage()]);
    }

    private function loadLog() {
        $this->log_file = $this->log_path . ($this->param['file']??'');
        $this->content = (file_exists($this->log_file) && is_file($this->log_file)) ? file_get_contents($this->log_file): "";
        foreach (array_filter(explode(PHP_EOL,$this->content)) as $k => $v) {
            if(preg_match("/(.*?)\[debug\](.*?)$/i",$v,$match)) {
                $this->content_arr[$k]['level'] = 'debug';
            } elseif (preg_match("/(.*?)\[info\](.*?)$/i",$v,$match)) {
                $this->content_arr[$k]['level'] = 'info';
            } elseif (preg_match("/(.*?)\[warning\](.*?)$/i",$v,$match)) {
                $this->content_arr[$k]['level'] = 'warning';
            } elseif (preg_match("/(.*?)\[error\](.*?)$/i",$v,$match)) {
                $this->content_arr[$k]['level'] = 'error';
            } elseif (preg_match("/(.*?)\[sql\](.*?)$/i",$v,$match)) {
                $this->content_arr[$k]['level'] = 'sql';
            }else {
                $this->content_arr[$k]['level'] = 'all';
            }
            $this->content_arr[$k]['content'] = $match[2]??$v;
        }
        //数组反转
        $this->content_arr = array_reverse($this->content_arr);
        //数组总数
        $this->total = count($this->content_arr);
        //总页数
        $this->totalPage = ceil($this->total/$this->getLimit());
        //切片后的数组
        $this->splice_content_arr = array_slice($this->content_arr,($this->getPage() - 1) * $this->getLimit(),$this->getLimit());
    }

    private function getPage() {
        return request()->get('page',1);
    }

    private function getLimit() {
        return request()->get('limit',15);
    }

    private function getDirs(string $dir): array
    {
        $files = array();
        if ( $handle = opendir($dir) ) {
            while ( ($file = readdir($handle)) !== false ) {
                if ( $file != ".." && $file != "." ) {
                    if ( is_dir($dir . "/" . $file) ) {
                        $files[$file] = $this->getDirs($dir . "/" . $file);
                    } else {
                        $files[] = $file;
                    }
                }
            }
            closedir($handle);
        }
        return $files;
    }
}