DROP TABLE IF EXISTS `<#PREFIX#>seckill_activity`;
CREATE TABLE `<#PREFIX#>seckill_activity` (
    `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
    `goods_id` int(11) DEFAULT '0' COMMENT '商品的id',
    `goods_rule` tinyint(2) DEFAULT '1' COMMENT '商品规格 1:单规格 2:多规格',
    `pic` varchar(155) COLLATE utf8mb4_bin DEFAULT '' COMMENT '秒杀商品主图',
    `name` varchar(155) COLLATE utf8mb4_bin DEFAULT '' COMMENT '活动商品名称',
    `desc` varchar(255) COLLATE utf8mb4_bin DEFAULT '' COMMENT '活动描述',
    `start_time` datetime DEFAULT NULL COMMENT '活动开始时间',
    `end_time` datetime DEFAULT NULL COMMENT '活动结束时间',
    `original_price` decimal(10,2) DEFAULT '0.00' COMMENT '原价格',
    `seckill_price` decimal(10,2) DEFAULT '0.00' COMMENT '秒杀价格',
    `stock` int(11) DEFAULT '0' COMMENT '秒杀限量库存',
    `sales` int(11) DEFAULT '0' COMMENT '销量',
    `seckill_time_id` int(11) DEFAULT '0' COMMENT '活动时间段id',
    `total_buy_num` int(11) DEFAULT '1' COMMENT '累计购买数量',
    `once_buy_num` int(11) DEFAULT '1' COMMENT '一次秒杀活动购买数量',
    `seckill_goods_rule` text COLLATE utf8mb4_bin COMMENT '秒杀的商品规格',
    `status` tinyint(2) DEFAULT '1' COMMENT '状态 1:未开启 2:进行中 3:已结束',
    `is_open` tinyint(2) DEFAULT '2' COMMENT '是否开启 1:是 2:否',
    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
    `update_time` datetime DEFAULT NULL COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_status` (`status`) USING BTREE,
    KEY `idx_valid_time` (`start_time`,`end_time`) USING BTREE,
    KEY `idx_seckill_time` (`seckill_time_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPACT COMMENT='限时秒杀活动';

DROP TABLE IF EXISTS `<#PREFIX#>seckill_activity_goods`;
CREATE TABLE `<#PREFIX#>seckill_activity_goods` (
    `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
    `activity_id` int(11) DEFAULT '0' COMMENT '秒杀活动id',
    `sku` varchar(191) COLLATE utf8mb4_bin DEFAULT '' COMMENT '活动商品规格',
    `goods_id` int(11) DEFAULT '0' COMMENT '商品id',
    `image` varchar(255) COLLATE utf8mb4_bin DEFAULT '' COMMENT '规格图片',
    `goods_price` decimal(10,2) DEFAULT '0.00' COMMENT '商品价格',
    `seckill_price` decimal(10,2) DEFAULT '0.00' COMMENT '秒杀价格',
    `stock` int(11) DEFAULT '0' COMMENT '秒杀库存',
    `sales` int(11) unsigned DEFAULT '0' COMMENT '销量',
    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
    `update_time` datetime DEFAULT NULL COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_sku` (`activity_id`,`sku`) USING BTREE COMMENT '商品查询'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=COMPACT COMMENT='活动商品';

DROP TABLE IF EXISTS `<#PREFIX#>seckill_order`;
CREATE TABLE `<#PREFIX#>seckill_order` (
    `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `order_id` int(11) DEFAULT '0' COMMENT '关联的订单id',
    `user_id` int(11) DEFAULT '0' COMMENT '关联的用户的id',
    `seckill_id` int(11) DEFAULT '0' COMMENT '秒杀id',
    PRIMARY KEY (`id`),
    KEY `idx_order` (`order_id`,`seckill_id`) USING BTREE,
    KEY `idx_check` (`user_id`,`seckill_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='秒杀订单与订单关联表';

DROP TABLE IF EXISTS `<#PREFIX#>seckill_time`;
CREATE TABLE `<#PREFIX#>seckill_time`  (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `start_hour` int(2) NULL DEFAULT 0 COMMENT '开始整点',
    `continue_hour` int(2) NULL DEFAULT 0 COMMENT '持续时长',
    `status` tinyint(2) NULL DEFAULT 1 COMMENT '是否有效 1:有效 2:无效',
    `sort` tinyint(2) NULL DEFAULT 1 COMMENT '排序',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '秒杀时间段设置' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of sp_seckill_time
-- ----------------------------
INSERT INTO `<#PREFIX#>seckill_time` VALUES (1, 0, 8, 1, 10);
INSERT INTO `<#PREFIX#>seckill_time` VALUES (2, 8, 2, 1, 9);
INSERT INTO `<#PREFIX#>seckill_time` VALUES (3, 10, 2, 1, 8);
INSERT INTO `<#PREFIX#>seckill_time` VALUES (4, 12, 2, 1, 7);
INSERT INTO `<#PREFIX#>seckill_time` VALUES (5, 14, 2, 1, 6);
INSERT INTO `<#PREFIX#>seckill_time` VALUES (6, 16, 2, 1, 5);
INSERT INTO `<#PREFIX#>seckill_time` VALUES (7, 18, 2, 1, 4);
INSERT INTO `<#PREFIX#>seckill_time` VALUES (9, 20, 4, 1, 3);