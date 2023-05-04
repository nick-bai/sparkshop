<?php
// +----------------------------------------------------------------------
// | SparkShop 坚持做优秀的商城系统
// +----------------------------------------------------------------------
// | Copyright (c) 2022~2099 http://sparkshop.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://opensource.org/licenses/mit-license.php )
// +----------------------------------------------------------------------
// | Author: NickBai  <876337011@qq.com>
// +----------------------------------------------------------------------
namespace app\command;

use Fairy\HttpCrontab;
use think\console\Command;
use think\console\Input;
use think\console\input\Argument;
use think\console\Output;

class Crontab extends Command
{
    protected function configure()
    {
        $this->setName('定时任务')->addArgument('option', Argument::OPTIONAL, "your option");
    }

    protected function execute(Input $input, Output $output)
    {
        date_default_timezone_set('PRC');

        $dbConfig = [
            'hostname' => env('database.hostname', '127.0.0.1'),
            'hostport' => env('database.hostport', '3306'),
            'username' => env('database.username', 'root'),
            'password' => env('database.password', ''),
            'database' => env('database.database', ''),
            'charset' => env('database.charset', 'utf8')
        ];

        $logo =<<<EOL
   _____                  _     _____ _                 
  / ____|                | |   / ____| |                
 | (___  _ __   __ _ _ __| | _| (___ | |__   ___  _ __  
  \___ \| '_ \ / _` | '__| |/ /\___ \| '_ \ / _ \| '_ \ 
  ____) | |_) | (_| | |  |   < ____) | | | | (_) | |_) |
 |_____/| .__/ \__,_|_|  |_|\_\_____/|_| |_|\___/| .__/ 
        | |                                      | |    
        |_|                                      |_|
EOL;

        $output->writeln($logo . PHP_EOL);

        (new HttpCrontab())->setDebug(true)
            ->setName('定时任务服务器')
            ->setDbConfig($dbConfig)
            ->run();
    }
}