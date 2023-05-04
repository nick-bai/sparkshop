<?php

return [
    // 加密串
    'salt' => 'q3lba23#$MOy10',

    // 标题
    'title' => 'SparkShop商城系统',

    // 是否开启开发模式
    'is_open_debug' => true,

    // 后台入口文件
    'backend_index' => 'admin',

    'source' => [
        //1 => 'wechat',
        2 => 'minapp',
        3 => 'PC',
        4 => 'H5',
        5 => 'APP'
    ],

    // 退款类型
    'refund_type' => [
        1 => '仅退款',
        2 => '退款退货'
    ],

    // 仅退款步骤
    'refund_step' => [
        1 => '申请仅退款',
        2 => '平台审核',
        3 => '退款完毕'
    ],

    // 退款退货步骤
    'refund_goods_step' => [
        1 => '申请退货退款',
        2 => '平台确认',
        3 => '用户退货',
        4 => '平台审核',
        5 => ' 退款完毕'
    ],

    // 审批状态
    'refund_pass' => [
        1 => '待审批',
        2 => '通过',
        3 => '拒绝',
        4 => '已取消'
    ],

    // 评论类型
    'appraise' => [
        1 => '好评',
        2 => '中评',
        3 => '差评'
    ],

    // 存储映射
    'store_config' => [
        'aliyun' => 'store_oss',
        'qiniu' => 'store_qiniu',
        'qcloud' => 'store_tencent'
    ],

    // 域名key和存储位置映射
    'store_domain' => [
        'aliyun' => 'oss_domain',
        'qiniu' => 'qiniu_domain',
        'qcloud' => 'tencent_domain'
    ],

    // jwt 密码
    'jwt_key' => 'zY6dBijuOjEpxr6',
];