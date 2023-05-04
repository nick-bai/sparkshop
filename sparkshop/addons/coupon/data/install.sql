DROP TABLE IF EXISTS `<#PREFIX#>coupon`;
CREATE TABLE `<#PREFIX#>coupon` (
    `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '优惠券id',
    `name` varchar(155) COLLATE utf8mb4_bin DEFAULT '' COMMENT '优惠券名',
    `type` tinyint(2) DEFAULT '1' COMMENT '类型 1:满减券 2:折扣券',
    `discount` decimal(2,2) DEFAULT '0.00' COMMENT '折扣额',
    `max_discount_amount` decimal(10,2) DEFAULT '0.00' COMMENT '最大优惠金额',
    `amount` decimal(10,2) DEFAULT '0.00' COMMENT '优惠券面额',
    `is_limit_num` tinyint(2) DEFAULT '1' COMMENT '是否限制发放数量 1:是 2:否',
    `total_num` int(11) DEFAULT '0' COMMENT '发放总数量',
    `received_num` int(11) DEFAULT '0' COMMENT '累计领取数量',
    `used_num` int(11) DEFAULT '0' COMMENT '使用数量',
    `max_receive_num` int(11) DEFAULT '0' COMMENT '每人最大领取数量',
    `is_threshold` tinyint(2) DEFAULT '1' COMMENT '是否有门槛 1:是 2:否',
    `threshold_amount` decimal(10,2) DEFAULT '0.00' COMMENT '门槛金额',
    `status` tinyint(2) DEFAULT '1' COMMENT '状态 1:进行中 2:已作废 3:已过期 4:已领完',
    `validity_type` tinyint(2) DEFAULT '1' COMMENT '有效期类型 1:固定日期 2:领取之后',
    `start_time` datetime DEFAULT NULL COMMENT '开始日期',
    `end_time` datetime DEFAULT NULL COMMENT '结束时间',
    `receive_useful_day` int(11) DEFAULT '0' COMMENT '领取之后的有效期天数',
    `join_goods` tinyint(2) DEFAULT '1' COMMENT '商品参与方式 1:全部 2:指定商品',
    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
    `update_time` datetime DEFAULT NULL COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_coupon` (`status`,`join_goods`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPACT COMMENT='优惠券';

DROP TABLE IF EXISTS `<#PREFIX#>coupon_goods`;
CREATE TABLE `<#PREFIX#>coupon_goods` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `coupon_id` int(11) DEFAULT '0' COMMENT '优惠券id',
    `goods_id` int(11) DEFAULT '0' COMMENT '商品的id',
    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY `idx_goods` (`goods_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPACT COMMENT='优惠券关联的商品';

DROP TABLE IF EXISTS `<#PREFIX#>coupon_receive_log`;
CREATE TABLE `<#PREFIX#>coupon_receive_log` (
    `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
    `code` varchar(32) COLLATE utf8mb4_bin DEFAULT '' COMMENT '优惠券码',
    `coupon_id` int(11) DEFAULT '0' COMMENT '优惠券id',
    `coupon_name` varchar(155) COLLATE utf8mb4_bin DEFAULT '' COMMENT '优惠券名称',
    `order_id` int(11) DEFAULT '0' COMMENT '关联订单的id',
    `user_id` int(11) DEFAULT '0' COMMENT '领取人id',
    `user_name` varchar(155) COLLATE utf8mb4_bin DEFAULT '' COMMENT '领取人名',
    `status` tinyint(2) DEFAULT '1' COMMENT '状态 1:未使用 2:已使用 3:已过期',
    `used_time` datetime DEFAULT NULL COMMENT '使用时间',
    `start_time` datetime DEFAULT NULL COMMENT '有效期开始',
    `end_time` datetime DEFAULT NULL COMMENT '有效期结束',
    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
    `update_time` datetime DEFAULT NULL COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_user` (`user_id`,`status`) USING BTREE,
    KEY `idx_coupon` (`coupon_id`) USING BTREE,
    KEY `idx_code` (`code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPACT COMMENT='优惠券领取详情';