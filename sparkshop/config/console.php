<?php
// +----------------------------------------------------------------------
// | 控制台配置
// +----------------------------------------------------------------------
return [
    // 指令定义
    'commands' => [
        'crontab' => 'app\\command\\Crontab',
        'orderTimer' => 'app\\command\\OrderTimer', // 订单超时关闭
        'autoReceive' => 'app\\command\\AutoReceive', // 自动收货
        'autoAppraise' => 'app\\command\\AutoAppraise' // 自动评价
    ],
];
