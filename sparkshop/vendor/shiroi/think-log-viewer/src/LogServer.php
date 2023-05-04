<?php

namespace Shiroi\ThinkLogViewer;

use Shiroi\ThinkLogViewer\channels\FileChannel;

class LogServer
{
    //配置信息
    protected array $config = [];

    //是否开启日志记录
    private bool $isOpen = true;

    //查看默认日志记录通道
    private string $default = 'file';

    //默认记录数组
    protected array $default_channel = [];

    //日志记录级别
    private array $level = [];

    //日志类型记录的通道
    private array $type_channel = [];

    //关闭全局日志写入
    private bool $close = false;

    //全局日志处理 支持闭包
    private ?object $processor = null;

    private int $total = 0;

    //日志通道列表
    private array $channels = [];

    public function __construct() {
        $this->loadConfig();
        $this->init();
        $this->loadParam();
    }

    public function index()
    {
        if($this->isOpen) {
            switch ($this->default) {
                case 'file':
                    (new FileChannel($this->default_channel))->view();
                    break;
                default:
            }
        }
    }

    /**
     * @return array
     */
    public function getConfig(): array
    {
        return $this->config;
    }

    /**
     * @return bool
     */
    public function getIsOpen(): bool
    {
        return $this->isOpen;
    }

    /**
     * @return string
     */
    public function getDefault(): string
    {
        return $this->config['default']??$this->default;
    }

    /**
     * @return array
     */
    public function getDefaultChannel(): array
    {
        return $this->default_channel;
    }

    /**
     * @return array
     */
    public function getLevel(): array
    {
        return $this->level;
    }

    /**
     * @return array
     */
    public function getTypeChannel(): array
    {
        return $this->type_channel;
    }

    /**
     * @return bool
     */
    public function isClose(): bool
    {
        return $this->close;
    }

    /**
     * @return object|null
     */
    public function getProcessor(): ?object
    {
        return $this->processor;
    }

    /**
     * @return array
     */
    public function getChannels(): array
    {
        return $this->config['channels']??$this->channels;
    }

    /**
     * @return int
     */
    public function getTotal(): int
    {
        return $this->total;
    }

    /**
     * @param int $total
     */
    private function setTotal(int $total): void
    {
        $this->total = $total;
    }

    /**
     * @return void
     */
    private function loadConfig(): void
    {
        $this->config = config('log');
    }

    /**
     * @return void
     */
    private function init(): void
    {
        foreach ($this->config as $key => $value) {
            if(property_exists($this,$key)) $this->$key = $value;
        }
    }

    /**
     * @return void
     */
    private function loadParam(): void
    {
        $this->default_channel = $this->config['channels'][$this->getDefault()]??[];
        $this->isOpen = (bool)$this->default_channel['path'];
    }
}