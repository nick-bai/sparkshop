DROP TABLE IF EXISTS `crontab_task`;
CREATE TABLE `crontab_task`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务标题',
  `type` tinyint(4) NOT NULL DEFAULT 0 COMMENT '任务类型[0请求url,1执行sql,2执行shell]',
  `frequency` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务频率',
  `shell` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '任务脚本',
  `running_times` int(11) NOT NULL DEFAULT 0 COMMENT '已运行次数',
  `last_running_time` int(11) NOT NULL DEFAULT 0 COMMENT '最近运行时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务备注',
  `sort` int(11) NOT NULL DEFAULT 0 COMMENT '排序，越大越前',
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '任务状态状态[0:禁用;1启用]',
  `create_time` int(11) NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `title`(`title`) USING BTREE,
  INDEX `type`(`type`) USING BTREE,
  INDEX `create_time`(`create_time`) USING BTREE,
  INDEX `status`(`status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '定时器任务表' ROW_FORMAT = Dynamic;

INSERT INTO `crontab_task` VALUES (1, '订单超时检测', 2, '0 */10 * * * *', 'php think orderTimer', 0, 0, '', 0, 1, 1682430020, 1682430020);
INSERT INTO `crontab_task` VALUES (2, '自动收货', 2, '0 */10 * * * *', 'php think autoReceive', 0, 0, '', 0, 1, 1682430048, 1682430048);
INSERT INTO `crontab_task` VALUES (3, '自动好评', 2, '0 */10 * * * *', 'php think autoAppraise', 0, 0, '', 0, 1, 1682430067, 1682430067);

DROP TABLE IF EXISTS `crontab_task_lock`;
CREATE TABLE `crontab_task_lock`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `sid` int(60) NOT NULL COMMENT '任务id',
  `is_lock` tinyint(4) NOT NULL DEFAULT 0 COMMENT '是否锁定(0:否,1是)',
  `create_time` int(11) NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `sid`(`sid`) USING BTREE,
  INDEX `create_time`(`create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '定时器任务锁表' ROW_FORMAT = Dynamic;

DROP TABLE IF EXISTS `crontab_task_log_202304`;
CREATE TABLE `crontab_task_log_202304`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `sid` int(60) NOT NULL COMMENT '任务id',
  `command` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '执行命令',
  `output` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '执行输出',
  `return_var` tinyint(4) NOT NULL COMMENT '执行返回状态[0成功; 1失败]',
  `running_time` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '执行所用时间',
  `create_time` int(11) NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `sid`(`sid`) USING BTREE,
  INDEX `create_time`(`create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '定时器任务流水表202304' ROW_FORMAT = Dynamic;

DROP TABLE IF EXISTS `{PREFIX}admin_node`;
CREATE TABLE `{PREFIX}admin_node`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '节点id',
  `pid` int(11) NULL DEFAULT 0 COMMENT '所属节点',
  `type` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT 'system' COMMENT '菜单类型',
  `name` varchar(155) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '节点名称',
  `path` varchar(155) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '节点路径',
  `icon` varchar(55) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '节点图标',
  `is_menu` tinyint(1) NULL DEFAULT 1 COMMENT '是否是菜单项 1 不是 2 是',
  `sort` int(4) NULL DEFAULT 0 COMMENT '排序，值越大越靠前',
  `status` tinyint(2) NULL DEFAULT 1 COMMENT '节点状态 1:正常 2:禁用',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '添加时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 164 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '节点表' ROW_FORMAT = Compact;

INSERT INTO `{PREFIX}admin_node` VALUES (2, 66, 'system', '管理员管理', 'admin/index', 'el-icon-user', 2, 90, 1, '2022-06-25 20:43:29', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (3, 2, 'system', '添加', 'admin/add', NULL, 1, 0, 1, '2022-06-25 20:44:00', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (4, 2, 'system', '编辑', 'admin/edit', NULL, 1, 0, 1, '2022-06-25 20:44:25', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (5, 2, 'system', '删除', 'admin/del', NULL, 1, 0, 1, '2022-06-25 20:44:43', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (6, 66, 'system', '角色管理', 'role/index', 'el-icon-headset', 2, 89, 1, '2022-06-25 20:44:54', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (7, 6, 'system', '新增', 'role/add', NULL, 1, 0, 1, '2022-06-25 20:44:54', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (8, 6, 'system', '编辑', 'role/edit', NULL, 1, 0, 1, '2022-06-25 20:44:54', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (9, 6, 'system', '删除', 'role/del', NULL, 1, 0, 1, '2022-06-25 20:44:54', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (10, 0, 'system', '用户', '#', 'el-icon-user-solid', 2, 90, 1, '2022-06-26 08:35:08', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (11, 10, 'system', '用户分组', 'userGroup/index', 'el-icon-s-custom', 2, 9, 1, '2022-06-26 08:42:57', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (12, 11, 'system', '新增', 'userGroup/add', NULL, 1, 0, 1, '2022-06-26 08:42:57', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (13, 11, 'system', '编辑', 'userGroup/edit', NULL, 1, 0, 1, '2022-06-26 08:42:57', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (14, 11, 'system', '删除', 'userGroup/del', NULL, 1, 0, 1, '2022-06-26 08:42:57', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (15, 10, 'system', '用户标签', 'label/index', 'el-icon-postcard', 2, 8, 1, '2022-06-26 11:34:18', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (16, 15, 'system', '新增', 'label/add', NULL, 1, 0, 1, '2022-06-26 11:34:18', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (17, 15, 'system', '编辑', 'label/edit', NULL, 1, 0, 1, '2022-06-26 11:34:18', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (18, 15, 'system', '删除', 'label/del', NULL, 1, 0, 1, '2022-06-26 11:34:18', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (19, 10, 'system', '用户等级', 'userLevel/index', 'el-icon-medal', 2, 7, 1, '2022-06-26 14:58:28', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (20, 19, 'system', '新增', 'userLevel/add', NULL, 1, 0, 1, '2022-06-26 14:58:28', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (21, 19, 'system', '编辑', 'userLevel/edit', NULL, 1, 0, 1, '2022-06-26 14:58:28', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (22, 19, 'system', '删除', 'userLevel/del', NULL, 1, 0, 1, '2022-06-26 14:58:28', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (23, 10, 'system', '用户管理', 'user/index', 'el-icon-user', 2, 10, 1, '2022-06-26 17:33:33', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (24, 23, 'system', '新增', 'user/add', NULL, 1, 0, 1, '2022-06-26 17:33:33', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (25, 23, 'system', '编辑', 'user/edit', NULL, 1, 0, 1, '2022-06-26 17:33:33', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (26, 23, 'system', '删除', 'user/del', NULL, 1, 0, 1, '2022-06-26 17:33:33', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (27, 0, 'system', '商品', '#', 'el-icon-s-goods', 2, 99, 1, '2022-06-28 22:08:52', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (28, 27, 'system', '商品分类', 'goodsCate/index', 'el-icon-s-goods', 2, 80, 1, '2022-06-28 22:11:24', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (29, 28, 'system', '新增', 'goodsCate/add', NULL, 1, 0, 1, '2022-06-28 22:11:24', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (30, 28, 'system', '编辑', 'goodsCate/edit', NULL, 1, 0, 1, '2022-06-28 22:11:24', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (31, 28, 'system', '删除', 'goodsCate/del', NULL, 1, 0, 1, '2022-06-28 22:11:24', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (32, 36, 'system', '资源分类', 'comImageCate/index', '', 1, 0, 1, '2022-06-29 23:03:19', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (33, 32, 'system', '新增', 'comImageCate/add', NULL, 1, 0, 1, '2022-06-29 23:03:19', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (34, 32, 'system', '编辑', 'comImageCate/edit', NULL, 1, 0, 1, '2022-06-29 23:03:19', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (35, 32, 'system', '删除', 'comImageCate/del', NULL, 1, 0, 1, '2022-06-29 23:03:19', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (36, 66, 'system', '资源管理', 'comImages/index', 'el-icon-picture', 2, 0, 1, '2022-06-29 23:06:44', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (37, 36, 'system', '删除', 'comImages/del', NULL, 1, 0, 1, '2022-06-29 23:06:44', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (38, 36, 'system', '移动', 'comImages/edit', NULL, 1, 0, 1, '2022-07-02 15:40:01', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (39, 27, 'system', '商品规格', 'goodsRule/index', 'el-icon-s-help', 2, 0, 1, '2022-07-04 20:20:30', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (40, 39, 'system', '新增', 'goodsRule/add', NULL, 1, 0, 1, '2022-07-04 20:20:30', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (41, 39, 'system', '编辑', 'goodsRule/edit', NULL, 1, 0, 1, '2022-07-04 20:20:30', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (42, 39, 'system', '删除', 'goodsRule/del', NULL, 1, 0, 1, '2022-07-04 20:20:30', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (43, 27, 'system', '商品参数', 'goodsAttr/index', 'el-icon-s-claim', 2, 0, 1, '2022-07-05 20:31:25', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (44, 43, 'system', '新增', 'goodsAttr/add', NULL, 1, 0, 1, '2022-07-05 20:31:25', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (45, 43, 'system', '编辑', 'goodsAttr/edit', NULL, 1, 0, 1, '2022-07-05 20:31:25', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (46, 43, 'system', '删除', 'goodsAttr/del', NULL, 1, 0, 1, '2022-07-05 20:31:25', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (47, 27, 'system', '商品管理', 'goods/index', 'el-icon-s-cooperation', 2, 90, 1, '2022-07-07 21:16:12', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (48, 47, 'system', '新增', 'goods/add', NULL, 1, 0, 1, '2022-07-07 21:16:12', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (49, 47, 'system', '编辑', 'goods/edit', NULL, 1, 0, 1, '2022-07-07 21:16:12', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (50, 47, 'system', '批量上下架', 'goods/shelf', NULL, 1, 0, 1, '2022-07-07 21:16:12', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (51, 0, 'system', '设置', '#', 'el-icon-s-tools', 2, 50, 1, '2022-07-10 17:31:21', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (52, 51, 'system', '物流公司', 'express/index', 'el-icon-truck', 2, 89, 1, '2022-07-10 19:56:14', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (53, 52, 'system', '新增', 'express/add', NULL, 1, 0, 1, '2022-07-10 19:56:14', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (54, 52, 'system', '编辑', 'express/edit', NULL, 1, 0, 1, '2022-07-10 19:56:14', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (55, 52, 'system', '删除', 'express/del', NULL, 1, 0, 1, '2022-07-10 19:56:14', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (56, 51, 'system', '城市数据', 'city/index', 'el-icon-school', 2, 0, 1, '2022-07-10 20:18:21', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (57, 56, 'system', '新增', 'city/add', NULL, 1, 0, 1, '2022-07-10 20:18:21', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (58, 56, 'system', '编辑', 'city/edit', NULL, 1, 0, 1, '2022-07-10 20:18:21', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (59, 56, 'system', '删除', 'city/del', NULL, 1, 0, 1, '2022-07-10 20:18:21', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (60, 51, 'system', '运费模板', 'shipping/index', 'el-icon-reading', 2, 86, 1, '2022-07-12 21:06:30', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (61, 60, 'system', '新增', 'shipping/add', NULL, 1, 0, 1, '2022-07-12 21:06:30', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (62, 60, 'system', '编辑', 'shipping/edit', NULL, 1, 0, 1, '2022-07-12 21:06:30', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (63, 60, 'system', '删除', 'shipping/del', NULL, 1, 0, 1, '2022-07-12 21:06:30', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (64, 47, 'system', '删除', 'goods/del', NULL, 1, 0, 1, '2022-07-18 22:33:46', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (65, 47, 'system', '恢复', 'goods/recover', NULL, 1, 0, 1, '2022-07-18 22:34:19', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (66, 0, 'system', '网站', '#', 'el-icon-s-shop', 2, 70, 1, '2022-07-30 08:34:01', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (67, 66, 'system', '网站轮播', 'slider/index', 'el-icon-film', 2, 0, 1, '2022-07-30 09:14:46', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (68, 67, 'system', '新增', 'slider/add', NULL, 1, 0, 1, '2022-07-30 09:14:46', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (69, 67, 'system', '编辑', 'slider/edit', NULL, 1, 0, 1, '2022-07-30 09:14:46', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (70, 67, 'system', '删除', 'slider/del', NULL, 1, 0, 1, '2022-07-30 09:14:46', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (71, 66, 'system', '友链管理', 'links/index', 'el-icon-position', 2, 0, 1, '2022-07-30 11:50:33', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (72, 71, 'system', '新增', 'links/add', NULL, 1, 0, 1, '2022-07-30 11:50:33', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (73, 71, 'system', '编辑', 'links/edit', NULL, 1, 0, 1, '2022-07-30 11:50:33', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (74, 71, 'system', '删除', 'links/del', NULL, 1, 0, 1, '2022-07-30 11:50:33', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (76, 66, 'system', '文章分类', 'articleCate/index', 'el-icon-notebook-2', 2, 2, 1, '2022-07-30 16:09:02', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (77, 76, 'system', '新增', 'articleCate/add', NULL, 1, 0, 1, '2022-07-30 16:09:02', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (78, 76, 'system', '编辑', 'articleCate/edit', NULL, 1, 0, 1, '2022-07-30 16:09:02', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (79, 76, 'system', '删除', 'articleCate/del', NULL, 1, 0, 1, '2022-07-30 16:09:02', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (80, 66, 'system', '文章内容', 'article/index', 'el-icon-notebook-1', 2, 1, 1, '2022-07-30 16:20:02', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (81, 80, 'system', '新增', 'article/add', NULL, 1, 0, 1, '2022-07-30 16:20:02', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (82, 80, 'system', '编辑', 'article/edit', NULL, 1, 0, 1, '2022-07-30 16:20:02', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (83, 80, 'system', '删除', 'article/del', NULL, 1, 0, 1, '2022-07-30 16:20:02', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (84, 51, 'system', '系统设置', 'system/index', 'el-icon-setting', 2, 97, 1, '2022-07-31 16:31:07', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (85, 51, 'system', '短信设置', 'system/sms', 'el-icon-chat-line-round', 2, 90, 1, '2022-08-03 20:43:11', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (86, 51, 'system', '支付配置', 'system/pay', 'el-icon-money', 2, 96, 1, '2022-08-17 22:55:04', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (87, 0, 'system', '订单', '#', 'el-icon-s-finance', 2, 98, 1, '2022-08-19 15:08:49', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (88, 87, 'system', '订单管理', 'order/index', 'el-icon-s-finance', 2, 99, 1, '2022-08-19 15:09:45', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (89, 88, 'system', '订单发货', 'order/express', NULL, 1, 0, 1, '2022-08-19 15:10:43', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (90, 88, 'system', '订单详情', 'order/detail', NULL, 1, 0, 1, '2022-08-19 15:11:06', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (91, 88, 'system', '订单记录', 'order/log', NULL, 1, 0, 1, '2022-08-19 15:11:24', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (92, 88, 'system', '删除订单', 'order/del', NULL, 1, 0, 1, '2022-08-19 15:11:39', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (93, 88, 'system', '订单物流', 'order/showExpress', NULL, 1, 0, 1, '2022-08-20 19:02:14', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (94, 88, 'system', '订单导出', 'order/export', NULL, 1, 0, 1, '2022-08-21 16:59:13', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (95, 87, 'system', '售后订单', 'refund/index', 'el-icon-s-order', 2, 90, 1, '2022-09-02 21:49:02', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (96, 95, 'system', '订单详情', 'refund/detail', NULL, 1, 0, 1, '2022-09-03 09:20:55', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (97, 88, 'system', '完成订单', 'order/complete', NULL, 1, 0, 1, '2022-09-03 17:35:29', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (98, 51, 'system', '物流查询配置', 'system/express', 'el-icon-bicycle', 2, 95, 1, '2022-09-04 10:51:37', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (99, 95, 'system', '审核退款', 'refund/checkRefundMoney', NULL, 1, 0, 1, '2022-09-04 23:01:54', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (100, 95, 'system', '审核退货', 'refund/checkRefundGoods', NULL, 1, 0, 1, '2022-09-04 23:02:21', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (101, 27, 'system', '商品评价', 'appraise/index', 'el-icon-s-comment', 2, 0, 1, '2022-09-17 10:54:19', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (102, 101, 'system', '删除商品评价', 'appraise/del', NULL, 1, 0, 1, '2022-09-17 10:54:47', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (103, 51, 'system', '用户协议', 'system/agreement', 'el-icon-collection', 2, 80, 1, '2022-09-20 17:29:39', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (104, 51, 'system', '存储配置', 'system/store', 'el-icon-cloudy', 2, 86, 1, '2022-09-20 22:30:56', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (105, 0, 'system', '营销', '#', 'el-icon-s-ticket', 2, 89, 1, '2022-09-22 15:50:17', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (121, 51, 'system', '小程序设置', 'system/miniapp', 'el-icon-mobile', 2, 96, 1, '2022-11-11 23:05:12', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (122, 0, 'system', '首页', '#', 'el-icon-s-home', 2, 100, 1, '2022-12-31 18:27:55', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (123, 122, 'system', '首页概览', 'index/home', 'el-icon-s-data', 2, 99, 1, '2022-12-31 18:28:28', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (126, 122, 'system', '应用中心', 'plugin/index', 'el-icon-mouse', 2, 98, 1, '2023-01-21 23:21:12', '2023-04-01 21:45:30');
INSERT INTO `{PREFIX}admin_node` VALUES (127, 66, 'system', '菜单管理', 'menu/index', 'el-icon-menu', 2, 88, 1, '2023-01-22 15:45:47', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (128, 127, 'system', '新增', 'menu/add', NULL, 1, 0, 1, '2023-01-22 15:52:16', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (129, 127, 'system', '编辑', 'menu/edit', NULL, 1, 0, 1, '2023-01-22 15:52:45', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (130, 127, 'system', '删除', 'menu/del', NULL, 1, 0, 1, '2023-01-22 15:53:07', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (131, 126, 'system', '创建插件', 'plugin/create', '', 1, 0, 1, '2023-04-01 21:51:41', '2023-04-01 22:51:07');
INSERT INTO `{PREFIX}admin_node` VALUES (132, 126, 'system', '卸载插件', 'plugin/uninstall', '', 1, 0, 1, '2023-04-01 22:50:11', '2023-04-01 22:51:11');
INSERT INTO `{PREFIX}admin_node` VALUES (133, 126, 'system', '安装插件', 'plugin/install', '', 1, 0, 1, '2023-04-01 22:50:30', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (134, 126, 'system', '删除插件', 'plugin/del', '', 1, 0, 1, '2023-04-01 22:50:57', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (135, 126, 'system', '打包', 'plugin/pack', '', 1, 0, 1, '2023-04-03 22:51:21', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (136, 126, 'system', '升级包', 'plugin/update', '', 1, 0, 1, '2023-04-03 23:20:26', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (142, 51, 'system', '定时任务', 'crontabApi/index', 'el-icon-time', 2, 0, 1, '2023-04-11 21:35:31', '2023-04-11 21:55:34');
INSERT INTO `{PREFIX}admin_node` VALUES (143, 142, 'system', '创建', 'crontabApi/add', '', 1, 0, 1, '2023-04-11 21:55:28', '2023-04-11 21:57:19');
INSERT INTO `{PREFIX}admin_node` VALUES (144, 142, 'system', '编辑', 'crontabApi/edit', '', 1, 0, 1, '2023-04-11 21:56:08', '2023-04-11 21:57:24');
INSERT INTO `{PREFIX}admin_node` VALUES (145, 142, 'system', '删除', 'crontabApi/del', '', 1, 0, 1, '2023-04-11 21:56:31', '2023-04-11 21:57:29');
INSERT INTO `{PREFIX}admin_node` VALUES (146, 142, 'system', '重启', 'crontabApi/reload', '', 1, 0, 1, '2023-04-11 21:56:59', '2023-04-11 21:57:34');
INSERT INTO `{PREFIX}admin_node` VALUES (147, 142, 'system', '日志', 'crontabApi/flow', '', 1, 0, 1, '2023-04-11 21:58:11', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (148, 23, 'system', '修改余额', 'user/balance', '', 1, 0, 1, '2023-04-12 22:26:04', NULL);
INSERT INTO `{PREFIX}admin_node` VALUES (149, 105, 'coupon', '优惠券', '#', 'el-icon-s-ticket', 2, 98, 1, '2023-04-25 21:45:25', '2023-04-25 21:45:25');
INSERT INTO `{PREFIX}admin_node` VALUES (150, 149, 'coupon', '优惠券列表', 'addons/coupon/admin.index/index', '', 2, 98, 1, '2023-04-25 21:45:25', '2023-04-25 21:45:25');
INSERT INTO `{PREFIX}admin_node` VALUES (151, 150, 'coupon', '添加', 'addons/coupon/admin.index/add', '', 1, 0, 1, '2023-04-25 21:45:25', '2023-04-25 21:45:25');
INSERT INTO `{PREFIX}admin_node` VALUES (152, 150, 'coupon', '作废', 'addons/coupon/admin.index/close', '', 1, 0, 1, '2023-04-25 21:45:25', '2023-04-25 21:45:25');
INSERT INTO `{PREFIX}admin_node` VALUES (153, 150, 'coupon', '用户领取记录', 'addons/coupon/admin.index/log', '', 1, 0, 1, '2023-04-25 21:45:25', '2023-04-25 21:45:25');
INSERT INTO `{PREFIX}admin_node` VALUES (154, 149, 'coupon', '领取记录', 'addons/coupon/admin.receiveLog/index', '', 2, 90, 1, '2023-04-25 21:45:25', '2023-04-25 21:45:25');
INSERT INTO `{PREFIX}admin_node` VALUES (155, 105, 'seckill', '限时秒杀', '#', 'el-icon-timer', 2, 98, 1, '2023-04-25 21:45:37', '2023-04-25 21:45:37');
INSERT INTO `{PREFIX}admin_node` VALUES (156, 155, 'seckill', '秒杀商品', 'addons/seckill/admin.seckill/index', '', 2, 98, 1, '2023-04-25 21:45:37', '2023-04-25 21:45:37');
INSERT INTO `{PREFIX}admin_node` VALUES (157, 156, 'seckill', '添加', 'addons/seckill/admin.seckill/add', '', 1, 0, 1, '2023-04-25 21:45:37', '2023-04-25 21:45:37');
INSERT INTO `{PREFIX}admin_node` VALUES (158, 156, 'seckill', '编辑', 'addons/seckill/admin.seckill/edit', '', 1, 0, 1, '2023-04-25 21:45:37', '2023-04-25 21:45:37');
INSERT INTO `{PREFIX}admin_node` VALUES (159, 156, 'seckill', '删除', 'addons/seckill/admin.seckill/del', '', 1, 0, 1, '2023-04-25 21:45:37', '2023-04-25 21:45:37');
INSERT INTO `{PREFIX}admin_node` VALUES (160, 155, 'seckill', '秒杀配置', 'addons/seckill/admin.seckillTime/index', '', 2, 98, 1, '2023-04-25 21:45:37', '2023-04-25 21:45:37');
INSERT INTO `{PREFIX}admin_node` VALUES (161, 160, 'seckill', '添加', 'addons/seckill/admin.seckillTime/add', '', 1, 0, 1, '2023-04-25 21:45:37', '2023-04-25 21:45:37');
INSERT INTO `{PREFIX}admin_node` VALUES (162, 160, 'seckill', '添加', 'addons/seckill/admin.seckillTime/edit', '', 1, 0, 1, '2023-04-25 21:45:37', '2023-04-25 21:45:37');
INSERT INTO `{PREFIX}admin_node` VALUES (163, 160, 'seckill', '添加', 'addons/seckill/admin.seckillTime/del', '', 1, 0, 1, '2023-04-25 21:45:37', '2023-04-25 21:45:37');

DROP TABLE IF EXISTS `{PREFIX}admin_role`;
CREATE TABLE `{PREFIX}admin_role`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '角色id',
  `name` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '角色名称',
  `role_node` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '角色拥有的菜单节点',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '状态  1 有效 2 无效',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '角色表' ROW_FORMAT = Compact;

INSERT INTO `{PREFIX}admin_role` VALUES (1, '超级管理员', '*', 1, '2022-06-25 20:38:45', NULL);

DROP TABLE IF EXISTS `{PREFIX}admin_user`;
CREATE TABLE `{PREFIX}admin_user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '管理员id',
  `name` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '登录名称',
  `nickname` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '昵称',
  `password` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '管理员密码',
  `salt` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '当前用户加密盐',
  `avatar` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '管理员头像',
  `role_id` int(11) NULL DEFAULT 0 COMMENT '所属角色id',
  `last_login_ip` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '最近一次登录ip',
  `last_login_time` datetime(0) NULL DEFAULT NULL COMMENT '最近一次登录时间',
  `last_login_agent` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '最近一次登录设备',
  `status` tinyint(2) NULL DEFAULT 1 COMMENT '1 正常 2 禁用',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '添加时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '用户表' ROW_FORMAT = Compact;

INSERT INTO `{PREFIX}admin_user` VALUES (1, 'admin', '管理员', '14d5ba4d081b03522d63acbc8e942a4643af2638', '6449e393e1f5d', '{DOMAIN}/static/admin/default/image/avatar.png', 1, '127.0.0.1', '2023-04-27 10:57:44', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36', 1, '2022-06-19 22:47:15', '2022-06-25 21:25:55');

DROP TABLE IF EXISTS `{PREFIX}article`;
CREATE TABLE `{PREFIX}article`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '文章id',
  `title` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '文章标题',
  `cate_id` int(11) NULL DEFAULT 0 COMMENT '文章分类id',
  `desc` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '文章描述',
  `views` int(11) NULL DEFAULT 0 COMMENT '阅读次数',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '文章内容',
  `seo_title` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT 'seo标题',
  `seo_desc` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT 'seo描述',
  `seo_keywords` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT 'seo关键词',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '文章表' ROW_FORMAT = Compact;

INSERT INTO `{PREFIX}article` VALUES (1, '企业微信SCRM的主要亮点是什么?', 1, '今年，每个企业都在寻找新的出路，每个企业都在努力生存。虽然很多公司因为这次疫情而倒下，但是还是有一些公司在逆风中前行，流量部在此时推出企业微信SCRM，就是为那些 “逆行者”提供推动力的科技力量。那企业微信SCRM具体有哪些主要亮点呢?', 0, '<p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">今年，每个企业都在寻找新的出路，每个企业都在努力生存。虽然很多公司因为这次疫情而倒下，但是还是有一些公司在逆风中前行，流量部在此时推出企业微信SCRM，就是为那些 “逆行者”提供推动力的科技力量。那企业微信SCRM具体有哪些主要亮点呢?</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">(1)私域获客玩法丰富，获客成本极低</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">在企业微信SCRM的系统内，提供了多种私域获客玩法：任务获客、好友获客、抽奖获客、红包获客.....企业可根据实际情况，选择合适的获客方式。其中，好友获客、红包获客、群获客玩法引流效果最佳。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">(2)运营能力升级，助力客户精细化运营</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">在企业微信自带的功能之余，企业微信SCRM实现了进一步的功能升级，帮助企业进一步提升私域运营效率与精细程度。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">① 企业微信SCRM支持统一下达【不限次数】的社群素材任务，一线的员工/导购可一键发送至社群，提升同步效率。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">② 企业微信SCRM为员工打造专业化智能名片，帮助企业员工展示专业、统一的对外形象，提升客户信任度。只要客户访问了智能名片，员工将收到实时提醒，方便员工定向跟进客户。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">③ 企业微信SCRM优化员工和客户的聊天，通过话术内容管理、消息存档和敏感词监控等功能，不断优化员工对客户的了解，并进行词句监控和优化。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">此外，企业微信SCRM还有互动雷达、快捷话术、客户SOP、客户标签等运营功能，帮助企业提升私域 1 对 1 运营效率。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">(3)企业微信SCRM工作台，赋能一线员工</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">通过企业微信SCRM工作台，我们可以将一线的销售与导购，快速培养成为标准化的营销服务人才，更好地服务客户。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">① 企业微信工作台的待办事项通知，以及企业微信SCRM提供的互动雷达提醒、离职继承功能，可以辅助一线的销售和导购人员，定向跟进高意向、高活跃度的客户，了解客户流失情况，及时查找流失原因并挽回，提高跟进效率和成交效率，让员工更高效跟进客户。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">②员工可实时查看自己的客户服务数据，更高效检索客户与客户群，对于自己手头的客户跟进情况，做到心中有数。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">③赋能一线员工更强的客户服务与营销能力。让每一个一线的销售与导购人员，都能够高效添加客户、高效服务客户，非常顺畅地进行客户营销与客户转化。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">(4)快速生产、同步营销获客策略，导流私域</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">在许多企业内部，后端的营销策略与前端的执行，往往是非常割裂的。总部/运营部门制定的活动方案，同步效率与执行效率都很低。而通过企业微信，可以做到高效同步、高效对接。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">运营人员在企业微信SCRM系统的后台，可以使用全域引流、私域获客模块的丰富玩法，为企业的私域进行导流。如创建好友获客、抽奖获客、红包获客活动。同时，可以为各部门设置特定欢迎语、设置智能名片、客户推送SOP、智能雷达，极大解放一线销售/导购人员的双手的同时，统一客户服务标准，提升客户服务的效率。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">(5)优化客户管理，防止客户流失</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">许多企业都会面临员工离职，带走客户，或者员工飞单的情况。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">企业微信SCRM提供离职继承和在职转接功能，能有效保护企业客户资源，解决企业客户交接难题。并通过消息存档功能，让沟通过程透明化，防止员工私单、飞单。</p><p><br/></p>', '标题', '描述', '关键词,关键词2', '2022-07-30 22:44:42', NULL);
INSERT INTO `{PREFIX}article` VALUES (2, '涨知识：新华社新公布的禁用词', 2, '新华社在《新闻阅评动态》第315期发表《新华社新闻报道中的禁用词(第一批)》中规定了媒体报道中的禁用词', 0, '<p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">新华社在《新闻阅评动态》第315期发表《新华社新闻报道中的禁用词(第一批)》中规定了媒体报道中的禁用词</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">一、法律类的禁用词</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">1.在新闻稿件中涉及如下对象时不宜公开报道其真实姓名：</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">(1)犯罪嫌疑人家属;</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">(2)涉及案件的未成年人;</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">(3)涉及案件的妇女和儿童;</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">(4)采用人工受精等辅助生育手段的孕、产妇;</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">(5)严重传染病患者;</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">(6)精神病患者;</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">(7)被暴力胁迫卖淫的妇女;</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">(8)艾滋病患者;</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">(9)有吸毒史或被强制戒毒的人员。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">涉及这些人时，稿件可使用其真实姓氏加“某”字的指代，如“张某”、“李某”，不宜使用化名。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">2.对刑事案件当事人，在法院宣判有罪之前，不使用“罪犯”，而应使用“犯罪嫌疑人”。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">3.在民事和行政案件中，原告和被告法律地位是平等的，原告可以起诉，被告也可以反诉。不要使用原告“将某某推上被告席”这样带有主观色彩的句子。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">4.不得使用“某某党委决定给某政府干部行政上撤职、开除等处分”，可使用“某某党委建议给予某某撤职、开除等处分”。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">5.不要将“全国人大常委会副委员长”称作“全国人大副委员长”，也不要将“省人大常委会副主任”称作“省人大副主任”。各级人大常委会的委员，不要称作“人大常委”。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">6.“村民委员会主任”简称“村主任”，不得称“村长”。村干部不要称作“村官”。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">7.在案件报道中指称“小偷”、“强奸犯”等时，不要使用其社会身份作前缀。如：一个曾经是工人的小偷，不要写成“工人小偷”;一名教授作了案，不要写成“教授罪犯”。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">8.国务院机构中的审计署的正副行政首长称“审计长”、“副审计长”，不要称作“署长”、“副署长”。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">9.各级检察院的“检察长”不要写成“检察院院长”。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">二、社会生活类的禁用词</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">1.对有身体伤疾的人士不使用“残废人”、“独眼龙”、“瞎子”、“聋子”、“傻子”、“呆子”、“弱智”等蔑称，而应使用“残疾人”、“盲人”、“聋人”、“智力障碍者”等词语。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">2.报道各种事实特别是产品、商品时不使用“最佳”、“最好”、“最著名”等具有强烈评价色彩的词语。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">3.医药报道中不得含有“疗效最佳”、“根治”、“安全预防”、“安全无副作用”等词语，药品报道中不得含有“药到病除”、“无效退款”、“保险公司保险”、“最新技术”、“最高技术”、“最先进制法”、“药之王”、“国家级新药”等词语。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">4.对文艺界人士，不使用“影帝”、“影后”、“巨星”、“天王”等词语，一般可使用“文艺界人士”或“著名演员”、“著名艺术家”等。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">5.对各级领导同志的各种活动报道，不使用“亲自”等形容词。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">6.作为国家通讯社，新华社通稿中不应使用“哇噻”、“妈的”等俚语、脏话、黑话等。如果在引语中不能不使用这类词语，均应用括号加注，表明其内涵。近年来网络用语中对脏语进行缩略后新造的“SB”、“TMD”、“NB”等，也不得在报道中使用。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">三、民族宗教类的禁用词</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">1.对各民族，不得使用旧社会流传的带有污辱性的称呼。不能使用“回回”、“蛮子”等，而应使用“回族”等。也不能随意简称，如“蒙古族”不能简称为“蒙族”，“维吾尔族”不能简称为“维族”，“哈萨克族”不能简称为“哈萨”等。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">2.禁用口头语言或专业用语中含有民族名称的污辱性说法，不得使用“蒙古大夫”来指代“庸医”，不得使用“蒙古人”来指代“先天愚型”等。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">3.少数民族支系、部落不能称为民族，只能称为“XX人”。如“摩梭人”“撒尼人”“穿(川)青人”“僜人”，不能称为“摩梭族”“撒尼族”“穿(川)青族”“僜族”等。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">4.不要把古代民族名称与后世民族名称混淆，如不能将“高句丽”称为“高丽”，不能将“哈萨克族”、“乌孜别克族”等泛称为“突厥族”或“突厥人”。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">5.“穆斯林”是伊斯兰教信徒的通称，不能把宗教和民族混为一谈。不能说“回族就是伊斯兰教”、“伊斯兰教就是回族”。报道中遇到“阿拉伯人”等提法，不要改称“穆斯林”。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">6.涉及信仰伊斯兰教的民族的报道，不要提“猪肉”。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">7.穆斯林宰牛羊及家禽，只说“宰”，不能写作“杀”。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">四、涉及我领土、主权和港澳台的禁用词</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">1.香港、澳门是中国的特别行政区，台湾是中国的一个省。在任何文字、地图、图表中都要特别注意不要将其称作“国家”。尤其是多个国家和地区名称连用时，应格外注意不要漏写“(国家)和地区”字样。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">2.对台湾当局“政权”系统和其他机构的名称，无法回避时应加引号，如台湾“立法院”、“行政院”、“监察院”、“选委会”、“行政院主计处”等。不得出现“中央”、“国立”、“中华台北”等字样，如不得不出现时应加引号，如台湾“中央银行”等。台湾“行政院长”、“立法委员”等均应加引号表述。台湾“清华大学”、“故宫博物院”等也应加引号。严禁用“中华民国总统(副总统)”称呼台湾地区领导人，即使加注引号也不得使用。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">3.对台湾地区施行的所谓“法律”，应表述为“台湾地区的有关规定”。涉及对台法律事务，一律不使用“文书验证”、“司法协助”、“引渡”等国际法上的用语。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">4.不得将海峡两岸和香港并称为“两岸三地”。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">5.不得说“港澳台游客来华旅游”，而应称“港澳台游客来大陆(或：内地)旅游”。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">6.“台湾”与“祖国大陆(或‘大陆’)”为对应概念，“香港、澳门”与“内地”为对应概念，不得弄混。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">7.不得将台湾、香港、澳门与中国并列提及，如“中港”、“中台”、“中澳”等。可以使用“内地与香港”、“大陆与台湾”或“京港”、“沪港”、“闽台”等。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">8.“台湾独立”或“台独”必须加引号使用。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">9.台湾的一些社会团体如“中华道教文化团体联合会”、“中华两岸婚姻协调促进会”等有“中国”、“中华”字样者，应加引号表述。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">10.不得将台湾称为“福摩萨”。如报道中需要转述时，一定要加引号。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">11.南沙群岛不得称为“斯普拉特利群岛”。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">12.钓鱼岛不得称为“尖阁群岛”。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">13.严禁将新疆称为“东突厥斯坦”。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">五、国际关系类禁用词</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">1.不得使用“北朝鲜(英文North Korea)”来称呼“朝鲜民主主义人民共和国”，可直接使用简称“朝鲜”。英文应使用“the Democratic People’s Republic ofKorea”或使用缩写“DPRK”。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">2.有的国际组织的成员中，既包括一些既有国家，也包括一些地区。在涉及此类国际组织时，不得使用“成员国”，而应使用“成员”或“成员方”，如不能使用“世界贸易组织成员国”、“亚太经合组织成员国”，而应使用“世界贸易组织成员”、“世界贸易组织成员方”、“亚太经合组织成员”、“亚太经合组织成员方”(英文用members)。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">3.不使用“穆斯林国家”或“穆斯林世界”，而要用“伊斯兰国家”或“伊斯兰世界”。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">4.在达尔富尔报道中不使用“阿拉伯民兵”，而应使用“武装民兵”或“部族武装”。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">5.在报道社会犯罪和武装冲突时，一般不要刻意突出犯罪嫌疑人和冲突参与者的肤色、种族和性别特征。比如，在报道中应回避“黑人歹徒”的提法，可直接使用“歹徒”。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">6.公开报道不要使用“伊斯兰原教旨主义”、“伊斯兰原教旨主义者”等说法。可用“宗教激进主义(激进派、激进组织)”替代。如回避不了而必须使用时，可使用“伊斯兰激进组织(分子)”，但不要用“激进伊斯兰组织(分子)”。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">7.不要使用“十字军”等说法。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">8.人质报道中不使用“斩首”，可用中性词语为“人质被砍头杀害”。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">9.对国际战争中双方的战斗人员死亡的报道，不要使用“击毙”等词语，可使用“打死”等词语。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">10.不要将撒哈拉沙漠以南的地区称“黑非洲”，而应称为“撒哈拉沙漠以南的非洲”。</p><p style=\"box-sizing: border-box; list-style: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); margin-top: 0px; margin-bottom: 0px; padding: 0px; text-align: justify; font-size: 14px; color: rgb(85, 85, 85); line-height: 28px; font-family: &quot;Helvetica Neue&quot;, Helvetica, &quot;PingFang SC&quot;, Tahoma, Arial, sans-serif; white-space: normal; background-color: rgb(255, 255, 255);\">本篇文章来源于新华社。</p><p><br/></p>', '', '', '', '2022-07-30 22:48:59', NULL);
INSERT INTO `{PREFIX}article` VALUES (3, '如何注册成为会员', 3, '如何注册成为会员', 0, '<ul class=\"import-link list-paddingleft-2\" style=\"list-style-type: none;\"><li><p><a href=\"{DOMAIN}/index/goods/about.html\" style=\"box-sizing: border-box; color: rgb(10, 88, 202); text-decoration-line: none; transition: all 0.5s ease 0s;\">如何注册成为会员</a></p></li></ul>', '', '', '', '2022-09-22 09:23:45', NULL);
INSERT INTO `{PREFIX}article` VALUES (4, '如何搜索', 3, '如何搜索', 0, '<ul class=\"import-link list-paddingleft-2\" style=\"list-style-type: none;\"><li><p><a href=\"{DOMAIN}/index/goods/order-tracking.html\" style=\"box-sizing: border-box; color: rgb(10, 88, 202); text-decoration-line: none; transition: all 0.5s ease 0s;\">如何搜索</a></p></li></ul><p><br/></p>', '', '', '', '2022-09-22 09:24:28', NULL);
INSERT INTO `{PREFIX}article` VALUES (5, '用户协议', 4, '用户协议', 0, '<ul class=\"import-link list-paddingleft-2\" style=\"list-style-type: none;\"><li><p><a href=\"{DOMAIN}/index/goods/faq.html\" style=\"box-sizing: border-box; color: rgb(156, 156, 156); text-decoration-line: none; transition: all 0.5s ease 0s;\">用户协议</a></p></li></ul>', '', '', '', '2022-09-22 09:25:07', NULL);
INSERT INTO `{PREFIX}article` VALUES (6, '如何退款', 4, '如何退款', 0, '<ul class=\"import-link list-paddingleft-2\" style=\"list-style-type: none;\"><li><p><a href=\"{DOMAIN}/index/goods/products.html\" style=\"box-sizing: border-box; color: rgb(10, 88, 202); text-decoration-line: none; transition: all 0.5s ease 0s;\">如何退款</a></p></li></ul><p><br/></p>', '', '', '', '2022-09-22 09:25:24', NULL);
INSERT INTO `{PREFIX}article` VALUES (7, '运费细节', 4, '运费细节', 0, '<ul class=\"import-link list-paddingleft-2\" style=\"list-style-type: none;\"><li><p><a href=\"{DOMAIN}/index/goods/terms-conditions.html\" style=\"box-sizing: border-box; color: rgb(10, 88, 202); text-decoration-line: none; transition: all 0.5s ease 0s;\">运费细节</a></p></li></ul><p><br/></p>', '', '', '', '2022-09-22 09:25:38', NULL);

DROP TABLE IF EXISTS `{PREFIX}article_cate`;
CREATE TABLE `{PREFIX}article_cate`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '分类id',
  `name` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '分类名',
  `status` tinyint(2) NULL DEFAULT 1 COMMENT '状态 1:启用 2:禁用',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '文章分类表' ROW_FORMAT = Compact;

INSERT INTO `{PREFIX}article_cate` VALUES (1, '新闻资讯', 1, '2022-07-30 16:17:26', NULL);
INSERT INTO `{PREFIX}article_cate` VALUES (2, '企业新闻', 1, '2022-07-30 16:17:52', NULL);
INSERT INTO `{PREFIX}article_cate` VALUES (3, '客户服务', 1, '2022-09-22 09:21:58', NULL);
INSERT INTO `{PREFIX}article_cate` VALUES (4, '服务条款', 1, '2022-09-22 09:24:45', NULL);

DROP TABLE IF EXISTS `{PREFIX}cart`;
CREATE TABLE `{PREFIX}cart`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `user_id` int(11) UNSIGNED NULL DEFAULT 0 COMMENT '用户id',
  `goods_id` int(11) UNSIGNED NULL DEFAULT 0 COMMENT '商品id',
  `title` char(160) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '标题',
  `images` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '封面图片',
  `original_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '原价',
  `price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '销售价格',
  `goods_num` int(11) UNSIGNED NULL DEFAULT 0 COMMENT '购买数量',
  `total_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '总价',
  `rule_id` int(11) NULL DEFAULT 0 COMMENT '规格id',
  `rule_text` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '规格值',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  INDEX `goods_id`(`goods_id`) USING BTREE,
  INDEX `title`(`title`) USING BTREE,
  INDEX `goods_num`(`goods_num`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '购物车' ROW_FORMAT = Compact;

DROP TABLE IF EXISTS `{PREFIX}com_images`;
CREATE TABLE `{PREFIX}com_images`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '资源id',
  `cate_id` int(11) NULL DEFAULT 0 COMMENT '所属分类id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '图片名称',
  `sha1` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '文件标识',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '绝对地址',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '物理地址',
  `ext` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '后缀',
  `folder` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '所在文件夹',
  `type` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'local' COMMENT '存储引擎',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_folder`(`folder`(191)) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 33 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '图片表' ROW_FORMAT = Dynamic;

INSERT INTO `{PREFIX}com_images` VALUES (1, 1, '01c69f26a1f0347316be619dabc8d9eb.jpg', 'c39b4c538616e7e819c3188cf329c395254aae0c', '{DOMAIN}/storage/local/20230413/1dea23437b7ed8b4d424679daed9f9a3.jpg', '/www/wwwroot/sparkshop/sparkshop/public/storage/local/20230413/1dea23437b7ed8b4d424679daed9f9a3.jpg', 'jpg', 'local/20230413', 'local', '2023-04-13 22:36:45');
INSERT INTO `{PREFIX}com_images` VALUES (2, 1, '3b570808fc3593aa51b2a94ceaba3e6f.png', '7c8919947947c31f81adb96392350280968e57cf', '{DOMAIN}/storage/local/20230413/b58e9b1efbad875e3a7f9dbc8ca07d97.png', '/www/wwwroot/sparkshop/sparkshop/public/storage/local/20230413/b58e9b1efbad875e3a7f9dbc8ca07d97.png', 'png', 'local/20230413', 'local', '2023-04-13 22:37:38');
INSERT INTO `{PREFIX}com_images` VALUES (3, 1, '5ae4f6a3f8bf153beb849e02e14b5c40.png', '4220b59bb229be45d6131dd42ceb5dee968b3f29', '{DOMAIN}/storage/local/20230413/8086ea6ac4620652dc466afb9302ff05.png', '/www/wwwroot/sparkshop/sparkshop/public/storage/local/20230413/8086ea6ac4620652dc466afb9302ff05.png', 'png', 'local/20230413', 'local', '2023-04-13 22:46:53');
INSERT INTO `{PREFIX}com_images` VALUES (4, 1, '5b64e6584c06020347a5fa58af79d42a.png', '50f0aa366dd84b86fedda03536dd98ba581c7392', '{DOMAIN}/storage/local/20230413/1111edf07d90b3c5ac3d1f11c95e30e0.png', '/www/wwwroot/sparkshop/sparkshop/public/storage/local/20230413/1111edf07d90b3c5ac3d1f11c95e30e0.png', 'png', 'local/20230413', 'local', '2023-04-13 22:47:16');
INSERT INTO `{PREFIX}com_images` VALUES (5, 1, '23fbc5512b9bc9f8b2cd22065dbe3a57.jpg', 'a7c6fdfefa0aea9a915b03a4a0aeb4bc065d59d9', '{DOMAIN}/storage/local/20230413/0ec86d19d10255c40a8f3946b8f1c76d.jpg', '/www/wwwroot/sparkshop/sparkshop/public/storage/local/20230413/0ec86d19d10255c40a8f3946b8f1c76d.jpg', 'jpg', 'local/20230413', 'local', '2023-04-13 22:47:19');
INSERT INTO `{PREFIX}com_images` VALUES (6, 3, '62c718b8f546c0e601fbc00b63e63be2.jpeg', 'f54dc223ea48f21b6a1406fc500a84437082334d', '{DOMAIN}/storage/local/20230413/c573d54008928634f7b87a48b5f9f3c3.jpeg', '/www/wwwroot/sparkshop/sparkshop/public/storage/local/20230413/c573d54008928634f7b87a48b5f9f3c3.jpeg', 'jpeg', 'local/20230413', 'local', '2023-04-13 22:47:37');
INSERT INTO `{PREFIX}com_images` VALUES (8, 2, '11ae9e1404f77bd921ee990108d10720.jpg', 'e186323ab685a161426451cb9e2ce7371dc4b8b4', '{DOMAIN}/storage/local/20230413/9db6e5e29be2a41a307fc3c6b0d15243.jpg', '/www/wwwroot/sparkshop/sparkshop/public/storage/local/20230413/9db6e5e29be2a41a307fc3c6b0d15243.jpg', 'jpg', 'local/20230413', 'local', '2023-04-13 22:47:50');
INSERT INTO `{PREFIX}com_images` VALUES (10, 1, '10801cb0049c2d8fb34754ef7c1ce54f.jpg', '95ade33ea523691cbf40ba3bd5fd0db4fd341dab', '{DOMAIN}/storage/local/20230413/4089ae5ee2cc36e2f3d43e618837b987.jpg', '/www/wwwroot/sparkshop/sparkshop/public/storage/local/20230413/4089ae5ee2cc36e2f3d43e618837b987.jpg', 'jpg', 'local/20230413', 'local', '2023-04-13 22:50:04');
INSERT INTO `{PREFIX}com_images` VALUES (11, 1, 'big_1759437a06bd9d54b3c2c09336d25f44.jpg', '0d1edd0e3110877d45aa57863f1acac955126a0f', '{DOMAIN}/storage/local/20230413/d1fda29fdef62d42318d601126e797a0.jpg', '/www/wwwroot/sparkshop/sparkshop/public/storage/local/20230413/d1fda29fdef62d42318d601126e797a0.jpg', 'jpg', 'local/20230413', 'local', '2023-04-13 22:51:24');
INSERT INTO `{PREFIX}com_images` VALUES (13, 1, 'big_f9c81ca764bcccc2fc5ecde9d411824e.jpg', 'cc4b5b674182d68a62f5f16de35d84dd3edf82d6', '{DOMAIN}/storage/local/20230413/78615ecb80b19904a9cceef76a3526fc.jpg', '/www/wwwroot/sparkshop/sparkshop/public/storage/local/20230413/78615ecb80b19904a9cceef76a3526fc.jpg', 'jpg', 'local/20230413', 'local', '2023-04-13 22:51:57');
INSERT INTO `{PREFIX}com_images` VALUES (14, 3, 'mid_ecad6b5e5c68351568f350dd561dd5b3.png', '55f998e3144f24ef8672092e80f682d49ddee119', '{DOMAIN}/storage/local/20230413/96908ed9d2ebb154ecdb811ed0066c77.png', '/www/wwwroot/sparkshop/sparkshop/public/storage/local/20230413/96908ed9d2ebb154ecdb811ed0066c77.png', 'png', 'local/20230413', 'local', '2023-04-13 22:52:39');
INSERT INTO `{PREFIX}com_images` VALUES (15, 1, 'adb54a4da6288f89722872d54ff4994e.jpg', '2ae54d92d2546002cf57b498d3bccebfa6212440', '{DOMAIN}/storage/local/20230413/7b84b938d4eb44a9f5a26e16b1428090.jpg', '/www/wwwroot/sparkshop/sparkshop/public/storage/local/20230413/7b84b938d4eb44a9f5a26e16b1428090.jpg', 'jpg', 'local/20230413', 'local', '2023-04-13 22:57:35');
INSERT INTO `{PREFIX}com_images` VALUES (16, 1, 'big_e1b434ef85145430b8bd1a93528c1e26.jpg', '0c126bea443502ce6d881c890140eaf6d871337d', '{DOMAIN}/storage/local/20230413/d5667ea79a230dcd58b06fe94da4bb16.jpg', '/www/wwwroot/sparkshop/sparkshop/public/storage/local/20230413/d5667ea79a230dcd58b06fe94da4bb16.jpg', 'jpg', 'local/20230413', 'local', '2023-04-13 22:58:11');
INSERT INTO `{PREFIX}com_images` VALUES (17, 1, 'small_542267cb5f660e19c6647a71913c5624.jpg', 'a9f0f48862dbee2b85289aa262cd178c08916dd7', '{DOMAIN}/storage/local/20230413/a30d814e545858f11bcdde3babe9726d.jpg', '/www/wwwroot/sparkshop/sparkshop/public/storage/local/20230413/a30d814e545858f11bcdde3babe9726d.jpg', 'jpg', 'local/20230413', 'local', '2023-04-13 22:59:31');
INSERT INTO `{PREFIX}com_images` VALUES (18, 2, '3c49ade797d647b41412e06805a33fb6.jpeg', '40957f41aa1ecbe8e0c7ad157039860a6ed39282', '{DOMAIN}/storage/local/20230413/b1b767102c017f2a1203583be23d63b4.jpeg', '/www/wwwroot/sparkshop/sparkshop/public/storage/local/20230413/b1b767102c017f2a1203583be23d63b4.jpeg', 'jpeg', 'local/20230413', 'local', '2023-04-13 23:41:29');
INSERT INTO `{PREFIX}com_images` VALUES (19, 2, '58df0d104288e168a4efdbcdbebcfd33.jpeg', 'ab28683fc526ede003e4d09443ffe4a6880773ea', '{DOMAIN}/storage/local/20230413/9867dbdcd7cc5713988e3f2685b66ca4.jpeg', '/www/wwwroot/sparkshop/sparkshop/public/storage/local/20230413/9867dbdcd7cc5713988e3f2685b66ca4.jpeg', 'jpeg', 'local/20230413', 'local', '2023-04-13 23:41:43');
INSERT INTO `{PREFIX}com_images` VALUES (20, 2, 'd434773d91b3e3a6b7f4756c0044410a.jpeg', '473babb7c788eb961d80ae78fc7c55566a2fd30a', '{DOMAIN}/storage/local/20230413/96d9061352dd6c83348a3b171a2ab990.jpeg', '/www/wwwroot/sparkshop/sparkshop/public/storage/local/20230413/96d9061352dd6c83348a3b171a2ab990.jpeg', 'jpeg', 'local/20230413', 'local', '2023-04-13 23:41:46');
INSERT INTO `{PREFIX}com_images` VALUES (21, 2, 'e91ef8d30ee780f84c5966649117bcba.jpeg', '2847383e5c47c769bc147879e8b0e838e787cb40', '{DOMAIN}/storage/local/20230413/18a3693484575c460da3fb4600b75f83.jpeg', '/www/wwwroot/sparkshop/sparkshop/public/storage/local/20230413/18a3693484575c460da3fb4600b75f83.jpeg', 'jpeg', 'local/20230413', 'local', '2023-04-13 23:41:49');
INSERT INTO `{PREFIX}com_images` VALUES (22, 2, 'mid_5ae4f6a3f8bf153beb849e02e14b5c40.png', 'e74b841e9127f89908556bf136a680b5aa348796', '{DOMAIN}/storage/local/20230413/e535e8f5601d19c4c0c78837974c750c.png', '/www/wwwroot/sparkshop/sparkshop/public/storage/local/20230413/e535e8f5601d19c4c0c78837974c750c.png', 'png', 'local/20230413', 'local', '2023-04-13 23:41:52');
INSERT INTO `{PREFIX}com_images` VALUES (23, 2, 'pms_1664192129.37246333.png', 'fed1813ad53826b65c3760dea3677266ac97a634', '{DOMAIN}/storage/local/20230414/28935030a2dcddb7affa28f429b2c658.png', '/www/wwwroot/sparkshop/sparkshop/public/storage/local/20230414/28935030a2dcddb7affa28f429b2c658.png', 'png', 'local/20230414', 'local', '2023-04-14 00:04:04');
INSERT INTO `{PREFIX}com_images` VALUES (24, 2, 'pms_1666842735.73611426.png', '058b09e2918465dc4d99c4e2c60c3a331d971216', '{DOMAIN}/storage/local/20230414/d4488d0d8093853cf2122e9f382c1dac.png', '/www/wwwroot/sparkshop/sparkshop/public/storage/local/20230414/d4488d0d8093853cf2122e9f382c1dac.png', 'png', 'local/20230414', 'local', '2023-04-14 21:56:44');
INSERT INTO `{PREFIX}com_images` VALUES (25, 2, 'specs-head.jpg', '8c791733e867f83a12caf7da98e4b12db63e9b1a', '{DOMAIN}/storage/local/20230414/fd1f2833f9cc65191b3d9a52a58fd2b1.jpg', '/www/wwwroot/sparkshop/sparkshop/public/storage/local/20230414/fd1f2833f9cc65191b3d9a52a58fd2b1.jpg', 'jpg', 'local/20230414', 'local', '2023-04-14 21:58:51');
INSERT INTO `{PREFIX}com_images` VALUES (26, 4, 'big_5e79fa43e20ba097e7c646186054de84.png', '56cb4ab2d141173d2d45b4797c30a20777c6681d', '{DOMAIN}/storage/local/20230414/fe83e6f100973dcb10ab7177d717b576.png', '/www/wwwroot/sparkshop/sparkshop/public/storage/local/20230414/fe83e6f100973dcb10ab7177d717b576.png', 'png', 'local/20230414', 'local', '2023-04-14 22:06:24');
INSERT INTO `{PREFIX}com_images` VALUES (27, 4, 'user_level_1_icon.jpeg', '85046a7f9b087ccbe87d7cbb630ad686364214d3', '{DOMAIN}/storage/local/20230414/993bc45e7e502306d586a08f723aefa9.jpeg', '/www/wwwroot/sparkshop/sparkshop/public/storage/local/20230414/993bc45e7e502306d586a08f723aefa9.jpeg', 'jpeg', 'local/20230414', 'local', '2023-04-14 22:28:01');
INSERT INTO `{PREFIX}com_images` VALUES (28, 4, 'user_level_2_icon.jpeg', 'a1eee3a02d1bbf195036a363aed47af592787506', '{DOMAIN}/storage/local/20230414/381ce9c5bddfb2bab039cc8dd1a6d8cd.jpeg', '/www/wwwroot/sparkshop/sparkshop/public/storage/local/20230414/381ce9c5bddfb2bab039cc8dd1a6d8cd.jpeg', 'jpeg', 'local/20230414', 'local', '2023-04-14 22:28:06');
INSERT INTO `{PREFIX}com_images` VALUES (29, 4, 'user_level_3_icon.jpeg', '2d79862a9665bcd9cf1e97799b97fd6032dd65e7', '{DOMAIN}/storage/local/20230414/00ddec748361149036c84352f301fbbb.jpeg', '/www/wwwroot/sparkshop/sparkshop/public/storage/local/20230414/00ddec748361149036c84352f301fbbb.jpeg', 'jpeg', 'local/20230414', 'local', '2023-04-14 22:28:08');
INSERT INTO `{PREFIX}com_images` VALUES (30, 4, 'user_level_1_bgimg.jpeg', 'a17cfcb751478d2709bacb4b9e3d8c2156845044', '{DOMAIN}/storage/local/20230414/2a4dcc669d6053ce15a6d689e1e09f6b.jpeg', '/www/wwwroot/sparkshop/sparkshop/public/storage/local/20230414/2a4dcc669d6053ce15a6d689e1e09f6b.jpeg', 'jpeg', 'local/20230414', 'local', '2023-04-14 22:28:12');
INSERT INTO `{PREFIX}com_images` VALUES (31, 4, 'user_level_2_bgimg.jpeg', '02eaf2251b13e53e0633ee9c552fe756ec474722', '{DOMAIN}/storage/local/20230414/a4a26564db0a6e971e7d0ce3dfea063a.jpeg', '/www/wwwroot/sparkshop/sparkshop/public/storage/local/20230414/a4a26564db0a6e971e7d0ce3dfea063a.jpeg', 'jpeg', 'local/20230414', 'local', '2023-04-14 22:28:17');
INSERT INTO `{PREFIX}com_images` VALUES (32, 4, 'user_level_3_bgimg.jpeg', 'cb172f4624feca8b7aa4566380f24df3e273e6e7', '{DOMAIN}/storage/local/20230414/a68b0bfffa7546a701eeebc512e12bc6.jpeg', '/www/wwwroot/sparkshop/sparkshop/public/storage/local/20230414/a68b0bfffa7546a701eeebc512e12bc6.jpeg', 'jpeg', 'local/20230414', 'local', '2023-04-14 22:28:20');

DROP TABLE IF EXISTS `{PREFIX}com_images_cate`;
CREATE TABLE `{PREFIX}com_images_cate`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '图片分类id',
  `pid` int(11) NULL DEFAULT 0 COMMENT '上级分类id',
  `name` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '分类名',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '资源图片分类' ROW_FORMAT = Dynamic;

INSERT INTO `{PREFIX}com_images_cate` VALUES (1, 0, '分类图片', '2023-04-13 20:45:08', NULL);
INSERT INTO `{PREFIX}com_images_cate` VALUES (2, 0, '商品图片', '2023-04-13 23:36:01', NULL);
INSERT INTO `{PREFIX}com_images_cate` VALUES (3, 0, '导航图片', '2023-04-13 23:36:12', NULL);
INSERT INTO `{PREFIX}com_images_cate` VALUES (4, 0, '系统图片', '2023-04-14 22:05:24', NULL);

DROP TABLE IF EXISTS `{PREFIX}coupon`;
CREATE TABLE `{PREFIX}coupon`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '优惠券id',
  `name` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '优惠券名',
  `type` tinyint(2) NULL DEFAULT 1 COMMENT '类型 1:满减券 2:折扣券',
  `discount` decimal(2, 2) NULL DEFAULT 0.00 COMMENT '折扣额',
  `max_discount_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '最大优惠金额',
  `amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '优惠券面额',
  `is_limit_num` tinyint(2) NULL DEFAULT 1 COMMENT '是否限制发放数量 1:是 2:否',
  `total_num` int(11) NULL DEFAULT 0 COMMENT '发放总数量',
  `received_num` int(11) NULL DEFAULT 0 COMMENT '累计领取数量',
  `used_num` int(11) NULL DEFAULT 0 COMMENT '使用数量',
  `max_receive_num` int(11) NULL DEFAULT 0 COMMENT '每人最大领取数量',
  `is_threshold` tinyint(2) NULL DEFAULT 1 COMMENT '是否有门槛 1:是 2:否',
  `threshold_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '门槛金额',
  `status` tinyint(2) NULL DEFAULT 1 COMMENT '状态 1:进行中 2:已作废 3:已过期 4:已领完',
  `validity_type` tinyint(2) NULL DEFAULT 1 COMMENT '有效期类型 1:固定日期 2:领取之后',
  `start_time` datetime(0) NULL DEFAULT NULL COMMENT '开始日期',
  `end_time` datetime(0) NULL DEFAULT NULL COMMENT '结束时间',
  `receive_useful_day` int(11) NULL DEFAULT 0 COMMENT '领取之后的有效期天数',
  `join_goods` tinyint(2) NULL DEFAULT 1 COMMENT '商品参与方式 1:全部 2:指定商品',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_coupon`(`status`, `join_goods`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '优惠券' ROW_FORMAT = Compact;

DROP TABLE IF EXISTS `{PREFIX}coupon_goods`;
CREATE TABLE `{PREFIX}coupon_goods`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `coupon_id` int(11) NULL DEFAULT 0 COMMENT '优惠券id',
  `goods_id` int(11) NULL DEFAULT 0 COMMENT '商品的id',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_goods`(`goods_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '优惠券关联的商品' ROW_FORMAT = Compact;

DROP TABLE IF EXISTS `{PREFIX}coupon_receive_log`;
CREATE TABLE `{PREFIX}coupon_receive_log`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '优惠券码',
  `coupon_id` int(11) NULL DEFAULT 0 COMMENT '优惠券id',
  `coupon_name` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '优惠券名称',
  `order_id` int(11) NULL DEFAULT 0 COMMENT '关联订单的id',
  `user_id` int(11) NULL DEFAULT 0 COMMENT '领取人id',
  `user_name` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '领取人名',
  `status` tinyint(2) NULL DEFAULT 1 COMMENT '状态 1:未使用 2:已使用 3:已过期',
  `used_time` datetime(0) NULL DEFAULT NULL COMMENT '使用时间',
  `start_time` datetime(0) NULL DEFAULT NULL COMMENT '有效期开始',
  `end_time` datetime(0) NULL DEFAULT NULL COMMENT '有效期结束',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user`(`user_id`, `status`) USING BTREE,
  INDEX `idx_coupon`(`coupon_id`) USING BTREE,
  INDEX `idx_code`(`code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '优惠券领取详情' ROW_FORMAT = Compact;

DROP TABLE IF EXISTS `{PREFIX}goods`;
CREATE TABLE `{PREFIX}goods`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '商品id',
  `type` tinyint(2) NULL DEFAULT 1 COMMENT '商品类型 1:实物 2:虚拟',
  `name` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '商品名称',
  `sub_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '商品副标题',
  `cate_id` int(11) NULL DEFAULT 0 COMMENT '商品分类',
  `unit` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '单位',
  `slider_image` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '轮播图',
  `video_src` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '视频地址',
  `sales` int(11) NULL DEFAULT 0 COMMENT '销量',
  `views` int(11) NULL DEFAULT 0 COMMENT '浏览量',
  `collects` int(11) NULL DEFAULT 0 COMMENT '收藏数',
  `spec` tinyint(2) NULL DEFAULT 1 COMMENT '规格 1:单规格 2:多规格',
  `price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '销售价格',
  `cost_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '成本价格',
  `original_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '划线原价',
  `postage` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '邮费',
  `spu` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '商品编码',
  `stock` int(11) UNSIGNED NULL DEFAULT 0 COMMENT '库存数',
  `weight` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '重量 KG',
  `volume` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '体积 m³',
  `user_label` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '关联的用户标签',
  `is_show` tinyint(2) NULL DEFAULT 1 COMMENT '是否上架 1:是 2:否',
  `is_hot` tinyint(2) NULL DEFAULT 2 COMMENT '是否热门 1:是 2:否',
  `is_recommend` tinyint(2) NULL DEFAULT 2 COMMENT '是否推荐 1:是 2:否',
  `is_new` tinyint(2) NULL DEFAULT 2 COMMENT '是否新品 1:是 2:否',
  `is_del` tinyint(2) NULL DEFAULT 2 COMMENT '是否删除 1:是 2:否',
  `shipping_tpl_id` int(11) NULL DEFAULT 0 COMMENT '运费模板id',
  `freight` tinyint(2) NULL DEFAULT 2 COMMENT '运费设置 1:固定 2:运费模板',
  `seo_title` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT 'seo标题',
  `seo_keywords` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT 'seo关键词',
  `seo_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT 'seo描述',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_show`(`is_show`) USING BTREE,
  INDEX `idx_del`(`is_del`) USING BTREE,
  INDEX `idx_stock`(`stock`) USING BTREE,
  INDEX `idx_cate_list`(`cate_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '商品表' ROW_FORMAT = Dynamic;

INSERT INTO `{PREFIX}goods` VALUES (1, 1, 'Xiaomi Civi 2 冰冰蓝 8GB+128GB', '第一代骁龙7移动平台｜不锈钢VC液冷散热', 2, '台', '[\"{SPDOMAIN}\\/storage\\/local\\/20230414\\/28935030a2dcddb7affa28f429b2c658.png\"]', '', 2, 78, 0, 2, 2099.00, 0.00, 0.00, 0.00, '', 398, 0.00, 0.00, '1', 1, 1, 0, 1, 2, 0, 1, '', '', '', '2023-04-13 23:59:50', '2023-04-26 23:10:57');
INSERT INTO `{PREFIX}goods` VALUES (2, 1, '蓝牙音乐手表 | Jeep智能表蓝牙通话健康管理 P07', '', 3, '个', '[\"{SPDOMAIN}\\/storage\\/local\\/20230413\\/e535e8f5601d19c4c0c78837974c750c.png\"]', '', 5, 88, 0, 2, 0.01, 0.00, 0.00, 0.00, '', 5, 0.00, 0.00, '', 1, 0, 0, 0, 2, 0, 1, '', '', '', '2023-04-14 21:51:44', '2023-04-26 23:37:19');
INSERT INTO `{PREFIX}goods` VALUES (3, 1, 'Apple/苹果iPad mini6 8.3英寸平板电脑 64G-WLAN版 深空灰色', '', 5, '台', '[\"{SPDOMAIN}\\/storage\\/local\\/20230413\\/1111edf07d90b3c5ac3d1f11c95e30e0.png\"]', '', 0, 10, 0, 1, 3999.00, 3299.00, 4799.00, 0.00, '', 100, 1.00, 1.00, '', 1, 0, 0, 1, 2, 0, 1, '', '', '', '2023-04-14 21:55:02', '2023-04-14 22:53:01');
INSERT INTO `{PREFIX}goods` VALUES (4, 1, 'Xiaomi Book Air 13 i5/16G/512G', '薄至约12mm 时尚超薄 | 2.8K OLED 大师触控屏，音画双绝 ', 8, '台', '[\"{SPDOMAIN}\\/storage\\/local\\/20230414\\/d4488d0d8093853cf2122e9f382c1dac.png\"]', '', 0, 10, 0, 1, 4899.00, 4399.00, 5999.00, 10.00, '', 100, 1.20, 1.00, '', 1, 0, 0, 2, 2, 0, 1, '', '', '', '2023-04-14 21:59:04', '2023-04-14 22:52:55');

DROP TABLE IF EXISTS `{PREFIX}goods_attr`;
CREATE TABLE `{PREFIX}goods_attr`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '属性id',
  `goods_id` int(11) NULL DEFAULT 0 COMMENT '商品id',
  `name` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '属性名',
  `value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '属性值',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_goods`(`goods_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '商品属性表' ROW_FORMAT = Dynamic;

INSERT INTO `{PREFIX}goods_attr` VALUES (7, 1, '内存', '128/256', '2023-04-14 00:07:54');
INSERT INTO `{PREFIX}goods_attr` VALUES (8, 1, 'CPU', '第一代骁龙7平台', '2023-04-14 00:07:54');

DROP TABLE IF EXISTS `{PREFIX}goods_attr_tpl`;
CREATE TABLE `{PREFIX}goods_attr_tpl`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '属性id',
  `name` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '属性模板名',
  `value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '属性值',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '商品属性模板表' ROW_FORMAT = Compact;

DROP TABLE IF EXISTS `{PREFIX}goods_cate`;
CREATE TABLE `{PREFIX}goods_cate`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '分类id',
  `pid` int(11) NULL DEFAULT 0 COMMENT '父级id',
  `level` tinyint(2) NULL DEFAULT 1 COMMENT '分类层级',
  `name` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '分类名',
  `sub_name` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '分类副标题',
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '分类描述',
  `icon` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT 'icon图标',
  `big_pic` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '大图',
  `sort` tinyint(3) NULL DEFAULT 0 COMMENT '排序 0-100 值越大越靠前',
  `is_recommend` tinyint(2) NULL DEFAULT 2 COMMENT '是否推荐 1:是 2:否',
  `status` tinyint(2) NULL DEFAULT 1 COMMENT '是否显示 1:显示 2:不显示',
  `seo_title` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT 'seo标题',
  `seo_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT 'seo描述',
  `seo_keywords` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT 'seo关键词',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_level`(`level`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '商品分类表' ROW_FORMAT = Dynamic;

INSERT INTO `{PREFIX}goods_cate` VALUES (1, 0, 1, '手机数码', '', '', '{DOMAIN}/storage/local/20230413/b58e9b1efbad875e3a7f9dbc8ca07d97.png', '', 0, 2, 1, '', '', '', '2023-04-13 22:54:25', NULL);
INSERT INTO `{PREFIX}goods_cate` VALUES (2, 1, 2, '智能手机', '', '', '{DOMAIN}/storage/local/20230413/1dea23437b7ed8b4d424679daed9f9a3.jpg', '', 0, 2, 1, '', '', '', '2023-04-13 22:54:51', NULL);
INSERT INTO `{PREFIX}goods_cate` VALUES (3, 1, 2, '穿戴设备', '', '', '{DOMAIN}/storage/local/20230413/8086ea6ac4620652dc466afb9302ff05.png', '', 0, 2, 1, '', '', '', '2023-04-13 22:55:21', NULL);
INSERT INTO `{PREFIX}goods_cate` VALUES (4, 1, 2, '手机配件', '', '', '{DOMAIN}/storage/local/20230413/78615ecb80b19904a9cceef76a3526fc.jpg', '', 0, 2, 1, '', '', '', '2023-04-13 22:55:53', NULL);
INSERT INTO `{PREFIX}goods_cate` VALUES (5, 1, 2, '平版电脑', '', '', '{DOMAIN}/storage/local/20230413/1111edf07d90b3c5ac3d1f11c95e30e0.png', '', 0, 2, 1, '', '', '', '2023-04-13 22:56:32', NULL);
INSERT INTO `{PREFIX}goods_cate` VALUES (6, 0, 1, '电脑办公', '', '', '{DOMAIN}/storage/local/20230413/d1fda29fdef62d42318d601126e797a0.jpg', '', 0, 2, 1, '', '', '', '2023-04-13 22:56:54', NULL);
INSERT INTO `{PREFIX}goods_cate` VALUES (7, 6, 2, '台式机', '', '', '{DOMAIN}/storage/local/20230413/d1fda29fdef62d42318d601126e797a0.jpg', '', 0, 2, 1, '', '', '', '2023-04-13 22:57:11', NULL);
INSERT INTO `{PREFIX}goods_cate` VALUES (8, 6, 2, '笔记本', '', '', '{DOMAIN}/storage/local/20230413/7b84b938d4eb44a9f5a26e16b1428090.jpg', '', 0, 2, 1, '', '', '', '2023-04-13 22:57:41', NULL);
INSERT INTO `{PREFIX}goods_cate` VALUES (9, 6, 2, '游戏机', '', '', '{DOMAIN}/storage/local/20230413/d5667ea79a230dcd58b06fe94da4bb16.jpg', '', 0, 2, 1, '', '', '', '2023-04-13 22:58:15', NULL);
INSERT INTO `{PREFIX}goods_cate` VALUES (10, 0, 1, '家用电器', '', '', '{DOMAIN}/storage/local/20230413/4089ae5ee2cc36e2f3d43e618837b987.jpg', '', 0, 2, 1, '', '', '', '2023-04-13 22:58:45', NULL);
INSERT INTO `{PREFIX}goods_cate` VALUES (11, 10, 2, '洗衣机', '', '', '{DOMAIN}/storage/local/20230413/4089ae5ee2cc36e2f3d43e618837b987.jpg', '', 0, 2, 1, '', '', '', '2023-04-13 22:58:58', NULL);
INSERT INTO `{PREFIX}goods_cate` VALUES (12, 10, 2, '饮水机', '', '', '{DOMAIN}/storage/local/20230413/a30d814e545858f11bcdde3babe9726d.jpg', '', 0, 2, 1, '', '', '', '2023-04-13 22:59:41', NULL);

DROP TABLE IF EXISTS `{PREFIX}goods_content`;
CREATE TABLE `{PREFIX}goods_content`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '内容id',
  `goods_id` int(11) NULL DEFAULT 0 COMMENT '商品id',
  `content` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '描述内容',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_goods`(`goods_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '商品内容描述表' ROW_FORMAT = Dynamic;

INSERT INTO `{PREFIX}goods_content` VALUES (1, 1, '<p><img src=\"{DOMAIN}/storage/local/20230413/18a3693484575c460da3fb4600b75f83.jpeg\"/><img src=\"{DOMAIN}/storage/local/20230413/9867dbdcd7cc5713988e3f2685b66ca4.jpeg\"/><img src=\"{DOMAIN}/storage/local/20230413/b1b767102c017f2a1203583be23d63b4.jpeg\"/></p>');
INSERT INTO `{PREFIX}goods_content` VALUES (2, 2, '<p><img src=\"{DOMAIN}/storage/local/20230413/96d9061352dd6c83348a3b171a2ab990.jpeg\"/></p>');
INSERT INTO `{PREFIX}goods_content` VALUES (3, 3, '<p><img src=\"{DOMAIN}/storage/local/20230413/9db6e5e29be2a41a307fc3c6b0d15243.jpg\"/></p>');
INSERT INTO `{PREFIX}goods_content` VALUES (4, 4, '<p><img src=\"{DOMAIN}/storage/local/20230414/fd1f2833f9cc65191b3d9a52a58fd2b1.jpg\"/></p>');

DROP TABLE IF EXISTS `{PREFIX}goods_rule`;
CREATE TABLE `{PREFIX}goods_rule`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '商品规格id',
  `goods_id` int(11) NULL DEFAULT 0 COMMENT '商品id',
  `rule` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '自定义规格',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_search`(`goods_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '商品规格表' ROW_FORMAT = Dynamic;

INSERT INTO `{PREFIX}goods_rule` VALUES (1, 1, '[{\"title\":\"\\u5185\\u5b58\",\"item\":[\"8G+256G\",\"8G+128G\"]},{\"title\":\"\\u989c\\u8272\",\"item\":[\" \\u5c0f\\u767d\\u88d9\",\"\\u6026\\u6026\\u7c89\"]}]');
INSERT INTO `{PREFIX}goods_rule` VALUES (2, 2, '[{\"title\":\"\\u989c\\u8272\",\"item\":[\"\\u9ed1\\u8272\"]},{\"title\":\"\\u5c3a\\u5bf8\",\"item\":[\"46mm\"]}]');

DROP TABLE IF EXISTS `{PREFIX}goods_rule_extend`;
CREATE TABLE `{PREFIX}goods_rule_extend`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `goods_id` int(11) UNSIGNED NULL DEFAULT 0 COMMENT '商品ID',
  `sku` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '0' COMMENT '属性索引',
  `stock` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '属性对应的库存',
  `sales` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '销量',
  `price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '属性金额',
  `image` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '图片',
  `unique` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '唯一值',
  `cost_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '成本价',
  `bar_code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '商品条码',
  `original_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '原价',
  `weight` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '重量',
  `volume` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '体积',
  `spu` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '商品编号',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_goods`(`goods_id`) USING BTREE,
  INDEX `idx_suk`(`sku`) USING BTREE,
  INDEX `idx_stock`(`stock`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '商品规格值扩展表' ROW_FORMAT = Dynamic;

INSERT INTO `{PREFIX}goods_rule_extend` VALUES (1, 1, '8G+256G※ 小白裙', 98, 2, 2299.00, '{DOMAIN}/storage/local/20230413/b58e9b1efbad875e3a7f9dbc8ca07d97.png', '643828da0252e', 2000.00, '', 2499.00, 0.17, 0.00, '', '2023-04-14 00:07:54');
INSERT INTO `{PREFIX}goods_rule_extend` VALUES (2, 1, '8G+256G※怦怦粉', 100, 0, 2299.00, '{DOMAIN}/storage/local/20230413/b58e9b1efbad875e3a7f9dbc8ca07d97.png', '643828da0253d', 2000.00, '', 2499.00, 0.17, 0.00, '', '2023-04-14 00:07:54');
INSERT INTO `{PREFIX}goods_rule_extend` VALUES (3, 1, '8G+128G※ 小白裙', 100, 0, 2099.00, '{DOMAIN}/storage/local/20230413/b58e9b1efbad875e3a7f9dbc8ca07d97.png', '643828da02548', 1900.00, '', 2299.00, 0.17, 0.00, '', '2023-04-14 00:07:54');
INSERT INTO `{PREFIX}goods_rule_extend` VALUES (4, 1, '8G+128G※怦怦粉', 100, 0, 2099.00, '{DOMAIN}/storage/local/20230413/b58e9b1efbad875e3a7f9dbc8ca07d97.png', '643828da0254e', 1900.00, '', 2299.00, 0.17, 0.00, '', '2023-04-14 00:07:54');
INSERT INTO `{PREFIX}goods_rule_extend` VALUES (5, 2, '黑色※46mm', 5, 5, 0.01, '{DOMAIN}/storage/local/20230413/e535e8f5601d19c4c0c78837974c750c.png', '643a329c96bf5', 219.00, '', 356.00, 1.00, 1.00, '', '2023-04-15 13:14:04');

DROP TABLE IF EXISTS `{PREFIX}goods_rule_tpl`;
CREATE TABLE `{PREFIX}goods_rule_tpl`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '商品规格id',
  `name` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '规则名',
  `value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '规则值',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '商品规格模板表' ROW_FORMAT = Dynamic;

INSERT INTO `{PREFIX}goods_rule_tpl` VALUES (1, '手机模板', '[{\"title\":\"\\u5185\\u5b58\",\"item\":[\"128G\",\"256G\"]},{\"title\":\"\\u989c\\u8272\",\"item\":[\"\\u767d\\u8272\"]}]');

DROP TABLE IF EXISTS `{PREFIX}order`;
CREATE TABLE `{PREFIX}order`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '订单id',
  `pid` int(11) NULL DEFAULT 0 COMMENT '父订单id',
  `type` tinyint(2) NULL DEFAULT 1 COMMENT '订单类型 1:普通订单 2:拼团订单 3:秒杀订单 4:砍价订单',
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '订单号',
  `pay_order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '支付订单号',
  `user_id` int(11) NULL DEFAULT 0 COMMENT '下单用户',
  `total_num` int(5) NULL DEFAULT 0 COMMENT '订单商品数量',
  `postage` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '邮费',
  `order_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '订单总金额',
  `pay_way` tinyint(2) NULL DEFAULT 1 COMMENT '支付方式 1:微信 2:支付宝 3:余额',
  `pay_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '实际支付金额',
  `pay_postage` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '实际支付邮费',
  `vip_discount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '会员优惠',
  `coupon_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '优惠券累计抵扣金额',
  `pay_status` tinyint(2) NULL DEFAULT 1 COMMENT '支付状态 1:待支付 2:已支付 3:已退款 4:部分退款 5:部分支付 6:支付异常',
  `pay_time` datetime(0) NULL DEFAULT NULL COMMENT '支付时间',
  `delivery_time` datetime(0) NULL DEFAULT NULL COMMENT '发货时间',
  `cancel_time` datetime(0) NULL DEFAULT NULL COMMENT '取消时间',
  `received_time` datetime(0) NULL DEFAULT NULL COMMENT '收货时间',
  `close_time` datetime(0) NULL DEFAULT NULL COMMENT '关闭时间',
  `status` tinyint(2) NULL DEFAULT 1 COMMENT '订单状态 1:待确认 2:待支付 3:待发货 4:待收货 5:部分发货 6:交易完成 7:已取消 8:已关闭 9:库存不足',
  `source` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT 'PC' COMMENT '订单来源',
  `refund_status` tinyint(2) NULL DEFAULT 1 COMMENT '退款状态 1:未退款 2:审批中 3:不可退款',
  `refunded_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '已退款金额',
  `refunded_num` int(11) NULL DEFAULT 0 COMMENT '已退款数量',
  `return_msg` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '第三方返回信息',
  `third_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '第三方支付订单号',
  `delivery_name` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '快递名称',
  `delivery_code` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '快递编号',
  `delivery_no` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '快递单号',
  `user_comments` tinyint(2) NULL DEFAULT 1 COMMENT '用户是否评价 1:未评价 2:已评价',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '用户备注',
  `is_del` tinyint(2) NULL DEFAULT 1 COMMENT '后台是否删除 1:正常 2:删除',
  `user_del` tinyint(2) NULL DEFAULT 1 COMMENT '用户是否删除 1:正常 2:删除',
  `experience` int(11) NULL DEFAULT 0 COMMENT '赠送的经验值',
  `integral` int(11) NULL DEFAULT 0 COMMENT '赠送的积分',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_order_no`(`order_no`) USING BTREE,
  INDEX `idx_pay_status`(`pay_status`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_type`(`type`) USING BTREE,
  INDEX `idx_pay_no`(`pay_order_no`) USING BTREE,
  INDEX `idx_census`(`pay_status`, `create_time`) USING BTREE,
  INDEX `idx_status`(`status`, `delivery_time`, `user_id`, `user_comments`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '订单主表' ROW_FORMAT = Compact;

DROP TABLE IF EXISTS `{PREFIX}order_address`;
CREATE TABLE `{PREFIX}order_address`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '地址id',
  `order_id` int(11) NULL DEFAULT 0 COMMENT '订单id',
  `user_id` int(11) NULL DEFAULT 0 COMMENT '下单人id',
  `address_id` int(11) NULL DEFAULT 0 COMMENT '管理的地址id',
  `user_name` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '收货人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '手机号',
  `province` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '收件省份',
  `city` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '收件城市',
  `county` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '收货人所在区',
  `detail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '收货人详细地址',
  `post_code` int(10) NULL DEFAULT 0 COMMENT '邮编',
  `longitude` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '0' COMMENT '经度',
  `latitude` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '0' COMMENT '纬度',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order`(`order_id`, `user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '用户订单收件地址' ROW_FORMAT = Compact;

DROP TABLE IF EXISTS `{PREFIX}order_comment`;
CREATE TABLE `{PREFIX}order_comment`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `order_id` int(11) NULL DEFAULT 0 COMMENT '订单id',
  `order_detail_id` int(11) NULL DEFAULT 0 COMMENT '商品详情id',
  `goods_id` int(11) NULL DEFAULT 0 COMMENT '关联的产品的id',
  `goods_name` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '评论的商品名',
  `type` tinyint(2) NULL DEFAULT 1 COMMENT '类型 1:好评 2:中评 3:差评',
  `desc_match` tinyint(2) NULL DEFAULT 5 COMMENT '描述是否相符 1~5',
  `sku` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT 'sku',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '评价内容',
  `pictures` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '评价图',
  `user_id` int(11) NULL DEFAULT 0 COMMENT '评价人id',
  `user_name` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '评价人名',
  `user_avatar` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '评论人头像',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '评价时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user`(`user_id`) USING BTREE,
  INDEX `idx_order_id`(`order_id`) USING BTREE,
  INDEX `idx_type`(`type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '订单评价' ROW_FORMAT = Compact;

DROP TABLE IF EXISTS `{PREFIX}order_detail`;
CREATE TABLE `{PREFIX}order_detail`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `old_id` int(11) NULL DEFAULT 0 COMMENT '重新关联前id',
  `order_id` int(11) UNSIGNED NULL DEFAULT 0 COMMENT '订单id',
  `goods_id` int(11) UNSIGNED NULL DEFAULT 0 COMMENT '商品id',
  `goods_name` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '商品名称',
  `price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '单价',
  `logo` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '商品图片',
  `rule_id` int(11) NULL DEFAULT 0 COMMENT '规格id',
  `rule` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '规格',
  `cart_num` int(10) NULL DEFAULT 0 COMMENT '数量',
  `coupon_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '均摊优惠券金额',
  `vip_discount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '均摊的会员优惠',
  `refunded_flag` tinyint(2) NULL DEFAULT 1 COMMENT '退款状态 1:未退款 2:已退款',
  `refunded_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '已退款金额',
  `refunded_num` int(10) NULL DEFAULT 0 COMMENT '已退款数量',
  `user_comments` tinyint(2) NULL DEFAULT 1 COMMENT '用户是否评价 1:未评价 2:已评价',
  `user_comments_time` datetime(0) NULL DEFAULT NULL COMMENT '评价时间',
  `merchant_comments` tinyint(2) NULL DEFAULT 1 COMMENT '商户是否评价 1:未评价 2:已评价',
  `merchant_comments_time` datetime(0) NULL DEFAULT NULL COMMENT '商户评价时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_goods`(`goods_id`) USING BTREE,
  INDEX `idx_order`(`order_id`, `refunded_flag`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '订单购物详情表' ROW_FORMAT = Compact;

DROP TABLE IF EXISTS `{PREFIX}order_express`;
CREATE TABLE `{PREFIX}order_express`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `order_id` int(11) NULL DEFAULT 0 COMMENT '订单id',
  `type` tinyint(2) NULL DEFAULT 1 COMMENT '类型1:发货物流 2:退货物流',
  `end_flag` tinyint(2) NULL DEFAULT 2 COMMENT '是否完成 1:是 2:否',
  `express` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '物流信息',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order_id`(`order_id`) USING BTREE,
  INDEX `idx_search`(`order_id`, `type`, `end_flag`, `update_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '订单物流表' ROW_FORMAT = Compact;

DROP TABLE IF EXISTS `{PREFIX}order_overdue`;
CREATE TABLE `{PREFIX}order_overdue`  (
  `order_id` int(11) NOT NULL COMMENT '订单id',
  `type` tinyint(3) NULL DEFAULT 1 COMMENT '订单类型 1:普通订单 2:拼团订单 3:秒杀订单 4:砍价订单 5:余额充值订单',
  `goods_id` int(11) NULL DEFAULT 0 COMMENT '商品的id',
  `rule_id` int(11) NULL DEFAULT 0 COMMENT '规格id',
  `num` int(11) NULL DEFAULT 0 COMMENT '购买数量',
  `overdue_time` datetime(0) NULL DEFAULT NULL COMMENT '过期时间',
  INDEX `idx_order`(`order_id`, `type`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '订单过期快检表' ROW_FORMAT = Compact;

DROP TABLE IF EXISTS `{PREFIX}order_pay_log`;
CREATE TABLE `{PREFIX}order_pay_log`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '日志id',
  `order_id` int(11) NULL DEFAULT 0 COMMENT '订单id',
  `pay_way` tinyint(2) NULL DEFAULT 1 COMMENT '1:微信 2:支付宝',
  `pay_order_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '支付订单号',
  `status` tinyint(2) NULL DEFAULT 1 COMMENT '支付状态 1:待支付 2:已支付 3:已退款 4:部分退款 5:部分支付 6:支付异常 7:重新支付',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order_id`(`order_id`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '订单支付记录' ROW_FORMAT = Compact;

DROP TABLE IF EXISTS `{PREFIX}order_refund`;
CREATE TABLE `{PREFIX}order_refund`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NULL DEFAULT 0 COMMENT '订单表ID',
  `order_type` tinyint(2) NULL DEFAULT 1 COMMENT '订单类型 1:普通订单 2:拼团订单 3:秒杀订单 4:砍价订单',
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '订单号',
  `refund_order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '退款订单号',
  `user_id` int(11) NULL DEFAULT 0 COMMENT '用户UID',
  `user_name` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '用户名',
  `step` tinyint(2) NULL DEFAULT 2 COMMENT '步骤号',
  `refund_type` tinyint(2) NULL DEFAULT 1 COMMENT '退款申请类型 1:仅退款 2:退货退款',
  `refund_way` tinyint(2) NULL DEFAULT 1 COMMENT '退款方式 1:整单退 2:退部分',
  `refund_num` int(5) NULL DEFAULT 0 COMMENT '退款件数',
  `refund_price` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '申请退款金额',
  `refunded_price` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '已退款金额',
  `refund_phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '退款电话',
  `refund_express` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '退货快递单号',
  `refund_express_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '退货快递名称',
  `apply_refund_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '申请退款原因',
  `refund_img` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '退款图片',
  `unrefund_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '不同意退款的原因',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备注',
  `refunded_time` datetime(0) NULL DEFAULT NULL COMMENT '处理时间',
  `apply_refund_data` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '退款商品信息',
  `status` tinyint(2) NULL DEFAULT 1 COMMENT '状态 1:待审批 2:通过 3:拒绝 4:取消',
  `third_return_msg` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '第三方支付返回信息',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user`(`user_id`, `order_id`, `status`) USING BTREE,
  INDEX `idx_user_ordere`(`order_id`, `user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '订单退款表' ROW_FORMAT = Compact;

DROP TABLE IF EXISTS `{PREFIX}order_status_change`;
CREATE TABLE `{PREFIX}order_status_change`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `order_id` int(11) UNSIGNED NULL DEFAULT 0 COMMENT '订单id',
  `original_status` int(11) NULL DEFAULT 0 COMMENT '原始状态',
  `new_status` int(11) NULL DEFAULT 0 COMMENT '最新状态',
  `msg` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '操作描述',
  `operator_id` int(11) UNSIGNED NULL DEFAULT 0 COMMENT '创建-用户id',
  `operator_name` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建人-姓名',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_id`(`order_id`) USING BTREE,
  INDEX `original_status`(`original_status`) USING BTREE,
  INDEX `new_status`(`new_status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '订单状态历史纪录' ROW_FORMAT = Compact;

DROP TABLE IF EXISTS `{PREFIX}plugins`;
CREATE TABLE `{PREFIX}plugins`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '插件标识',
  `title` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '插件名称',
  `icon` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '插件图标',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '插件描述',
  `author` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '插件作者',
  `home_page` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '插件主页',
  `version` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '插件版本',
  `status` tinyint(2) NULL DEFAULT 1 COMMENT '状态 1:待安装  2:已安装',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '系统插件列表' ROW_FORMAT = Compact;

INSERT INTO `{PREFIX}plugins` VALUES (3, 'coupon', '优惠券', '', '满减券、折扣券、用户领取记录、用户使用记录', 'NickBai', 'https://gitee.com/nickbai/sparkshop', '1.0.1', 2, '2023-04-25 21:45:19', '2023-04-25 21:45:25');
INSERT INTO `{PREFIX}plugins` VALUES (4, 'seckill', '限时秒杀', '', '限时秒杀', 'NickBai', 'https://gitee.com/nickbai/sparkshop', '1.0.1', 2, '2023-04-25 21:45:32', '2023-04-25 21:45:37');

DROP TABLE IF EXISTS `{PREFIX}seckill_activity`;
CREATE TABLE `{PREFIX}seckill_activity`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `goods_id` int(11) NULL DEFAULT 0 COMMENT '商品的id',
  `goods_rule` tinyint(2) NULL DEFAULT 1 COMMENT '商品规格 1:单规格 2:多规格',
  `pic` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '秒杀商品主图',
  `name` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '活动商品名称',
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '活动描述',
  `start_time` datetime(0) NULL DEFAULT NULL COMMENT '活动开始时间',
  `end_time` datetime(0) NULL DEFAULT NULL COMMENT '活动结束时间',
  `original_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '原价格',
  `seckill_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '秒杀价格',
  `stock` int(11) NULL DEFAULT 0 COMMENT '秒杀限量库存',
  `sales` int(11) NULL DEFAULT 0 COMMENT '销量',
  `seckill_time_id` int(11) NULL DEFAULT 0 COMMENT '活动时间段id',
  `total_buy_num` int(11) NULL DEFAULT 1 COMMENT '累计购买数量',
  `once_buy_num` int(11) NULL DEFAULT 1 COMMENT '一次秒杀活动购买数量',
  `seckill_goods_rule` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '秒杀的商品规格',
  `status` tinyint(2) NULL DEFAULT 1 COMMENT '状态 1:未开启 2:进行中 3:已结束',
  `is_open` tinyint(2) NULL DEFAULT 2 COMMENT '是否开启 1:是 2:否',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_valid_time`(`start_time`, `end_time`) USING BTREE,
  INDEX `idx_seckill_time`(`seckill_time_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '限时秒杀活动' ROW_FORMAT = Compact;

DROP TABLE IF EXISTS `{PREFIX}seckill_activity_goods`;
CREATE TABLE `{PREFIX}seckill_activity_goods`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `activity_id` int(11) NULL DEFAULT 0 COMMENT '秒杀活动id',
  `sku` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '活动商品规格',
  `goods_id` int(11) NULL DEFAULT 0 COMMENT '商品id',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '规格图片',
  `goods_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '商品价格',
  `seckill_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '秒杀价格',
  `stock` int(11) NULL DEFAULT 0 COMMENT '秒杀库存',
  `sales` int(11) UNSIGNED NULL DEFAULT 0 COMMENT '销量',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sku`(`activity_id`, `sku`) USING BTREE COMMENT '商品查询'
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '活动商品' ROW_FORMAT = Compact;

DROP TABLE IF EXISTS `{PREFIX}seckill_order`;
CREATE TABLE `{PREFIX}seckill_order`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `order_id` int(11) NULL DEFAULT 0 COMMENT '关联的订单id',
  `user_id` int(11) NULL DEFAULT 0 COMMENT '关联的用户的id',
  `seckill_id` int(11) NULL DEFAULT 0 COMMENT '秒杀id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order`(`order_id`, `seckill_id`) USING BTREE,
  INDEX `idx_check`(`user_id`, `seckill_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '秒杀订单与订单关联表' ROW_FORMAT = Compact;

DROP TABLE IF EXISTS `{PREFIX}seckill_time`;
CREATE TABLE `{PREFIX}seckill_time`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `start_hour` int(2) NULL DEFAULT 0 COMMENT '开始整点',
  `continue_hour` int(2) NULL DEFAULT 0 COMMENT '持续时长',
  `status` tinyint(2) NULL DEFAULT 1 COMMENT '是否有效 1:有效 2:无效',
  `sort` tinyint(2) NULL DEFAULT 1 COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '秒杀时间段设置' ROW_FORMAT = Compact;

INSERT INTO `{PREFIX}seckill_time` VALUES (1, 0, 8, 1, 10);
INSERT INTO `{PREFIX}seckill_time` VALUES (2, 8, 2, 1, 9);
INSERT INTO `{PREFIX}seckill_time` VALUES (3, 10, 2, 1, 8);
INSERT INTO `{PREFIX}seckill_time` VALUES (4, 12, 2, 1, 7);
INSERT INTO `{PREFIX}seckill_time` VALUES (5, 14, 2, 1, 6);
INSERT INTO `{PREFIX}seckill_time` VALUES (6, 16, 2, 1, 5);
INSERT INTO `{PREFIX}seckill_time` VALUES (7, 18, 2, 1, 4);
INSERT INTO `{PREFIX}seckill_time` VALUES (9, 20, 4, 1, 3);

DROP TABLE IF EXISTS `{PREFIX}set_city`;
CREATE TABLE `{PREFIX}set_city`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `pid` int(11) NOT NULL DEFAULT 0 COMMENT '父级',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '名称',
  `shortname` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '简称',
  `longitude` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '经度',
  `latitude` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '纬度',
  `level` smallint(6) NOT NULL DEFAULT 0 COMMENT '级别',
  `sort` mediumint(9) NOT NULL DEFAULT 0 COMMENT '排序',
  `is_show` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态1有效',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `IDX_nc_area`(`name`, `shortname`) USING BTREE,
  INDEX `level`(`level`, `sort`, `is_show`) USING BTREE,
  INDEX `longitude`(`longitude`, `latitude`) USING BTREE,
  INDEX `pid`(`pid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 659011 AVG_ROW_LENGTH = 84 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '地址表' ROW_FORMAT = Compact;

INSERT INTO `{PREFIX}set_city` VALUES (110000, 0, '北京市', '北京', '116.40529', '39.904987', 1, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (110100, 110000, '北京市', '北京', '116.40529', '39.904987', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (110101, 110100, '东城区', '东城', '116.418755', '39.917545', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (110102, 110100, '西城区', '西城', '116.36679', '39.91531', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (110105, 110100, '朝阳区', '朝阳', '116.48641', '39.92149', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (110106, 110100, '丰台区', '丰台', '116.286964', '39.863644', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (110107, 110100, '石景山区', '石景山', '116.19544', '39.9146', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (110108, 110100, '海淀区', '海淀', '116.31032', '39.956074', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (110109, 110100, '门头沟区', '门头沟', '116.10538', '39.937183', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (110111, 110100, '房山区', '房山', '116.13916', '39.735535', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (110112, 110100, '通州区', '通州', '116.6586', '39.902485', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (110113, 110100, '顺义区', '顺义', '116.65353', '40.128937', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (110114, 110100, '昌平区', '昌平', '116.23591', '40.218086', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (110115, 110100, '大兴区', '大兴', '116.338036', '39.72891', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (110116, 110100, '怀柔区', '怀柔', '116.63712', '40.324272', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (110117, 110100, '平谷区', '平谷', '117.112335', '40.144783', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (110118, 110100, '密云区', '密云', '116.84317', '40.37625', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (110119, 110100, '延庆区', '延庆', '115.97503', '40.45678', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (120000, 0, '天津市', '天津', '117.190186', '39.125595', 1, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (120100, 120000, '天津市', '天津', '117.190186', '39.125595', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (120101, 120100, '和平区', '和平', '117.19591', '39.11833', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (120102, 120100, '河东区', '河东', '117.22657', '39.122124', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (120103, 120100, '河西区', '河西', '117.21754', '39.1019', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (120104, 120100, '南开区', '南开', '117.16415', '39.120476', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (120105, 120100, '河北区', '河北', '117.20157', '39.15663', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (120106, 120100, '红桥区', '红桥', '117.1633', '39.175068', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (120110, 120100, '东丽区', '东丽', '117.313965', '39.087765', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (120111, 120100, '西青区', '西青', '117.012245', '39.139446', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (120112, 120100, '津南区', '津南', '117.382545', '38.98958', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (120113, 120100, '北辰区', '北辰', '117.13482', '39.225555', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (120114, 120100, '武清区', '武清', '117.05796', '39.376926', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (120115, 120100, '宝坻区', '宝坻', '117.30809', '39.716965', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (120116, 120100, '滨海新区', '滨海', '117.654175', '39.032845', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (120117, 120100, '宁河区', '宁河', '117.82478', '39.33091', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (120118, 120100, '静海区', '静海', '116.97428', '38.94737', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (120119, 120100, '蓟州区', '蓟州', '117.40829', '40.04577', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130000, 0, '河北省', '河北', '114.502464', '38.045475', 1, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130100, 130000, '石家庄市', '石家庄', '114.502464', '38.045475', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130102, 130100, '长安区', '长安', '114.54815', '38.0475', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130104, 130100, '桥西区', '桥西', '114.46293', '38.02838', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130105, 130100, '新华区', '新华', '114.46597', '38.067142', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130107, 130100, '井陉矿区', '井陉矿', '114.05818', '38.069748', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130108, 130100, '裕华区', '裕华', '114.53326', '38.027695', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130109, 130100, '藁城区', '藁城', '114.84676', '38.02166', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130110, 130100, '鹿泉区', '鹿泉', '114.31344', '38.08587', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130111, 130100, '栾城区', '栾城', '114.64839', '37.90025', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130121, 130100, '井陉县', '井陉', '114.144485', '38.033615', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130123, 130100, '正定县', '正定', '114.569885', '38.147835', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130125, 130100, '行唐县', '行唐', '114.552734', '38.437424', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130126, 130100, '灵寿县', '灵寿', '114.37946', '38.306545', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130127, 130100, '高邑县', '高邑', '114.6107', '37.605713', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130128, 130100, '深泽县', '深泽', '115.20021', '38.18454', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130129, 130100, '赞皇县', '赞皇', '114.38776', '37.6602', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130130, 130100, '无极县', '无极', '114.977844', '38.176376', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130131, 130100, '平山县', '平山', '114.18414', '38.25931', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130132, 130100, '元氏县', '元氏', '114.52618', '37.762512', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130133, 130100, '赵县', '赵县', '114.77536', '37.75434', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130181, 130100, '辛集市', '辛集', '115.21745', '37.92904', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130183, 130100, '晋州市', '晋州', '115.04488', '38.027477', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130184, 130100, '新乐市', '新乐', '114.68578', '38.34477', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130200, 130000, '唐山市', '唐山', '118.17539', '39.635113', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130202, 130200, '路南区', '路南', '118.21082', '39.61516', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130203, 130200, '路北区', '路北', '118.174736', '39.628536', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130204, 130200, '古冶区', '古冶', '118.45429', '39.715736', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130205, 130200, '开平区', '开平', '118.26443', '39.67617', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130207, 130200, '丰南区', '丰南', '118.110794', '39.56303', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130208, 130200, '丰润区', '丰润', '118.15578', '39.831364', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130209, 130200, '曹妃甸区', '曹妃甸', '118.46023', '39.27313', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130224, 130200, '滦南县', '滦南', '118.68155', '39.506203', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130225, 130200, '乐亭县', '乐亭', '118.90534', '39.42813', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130227, 130200, '迁西县', '迁西', '118.30514', '40.146236', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130229, 130200, '玉田县', '玉田', '117.75366', '39.88732', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130281, 130200, '遵化市', '遵化', '117.96587', '40.188618', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130283, 130200, '迁安市', '迁安', '118.701935', '40.012108', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130284, 130200, '滦州市', '滦州', '118.70351', '39.74058', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130300, 130000, '秦皇岛市', '秦皇岛', '119.58658', '39.94253', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130302, 130300, '海港区', '海港', '119.59622', '39.94346', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130303, 130300, '山海关区', '山海关', '119.75359', '39.998024', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130304, 130300, '北戴河区', '北戴河', '119.48628', '39.825123', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130306, 130300, '抚宁区', '抚宁', '119.24444', '39.87634', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130321, 130300, '青龙满族自治县', '青龙', '118.95455', '40.40602', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130322, 130300, '昌黎县', '昌黎', '119.16454', '39.70973', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130324, 130300, '卢龙县', '卢龙', '118.881805', '39.89164', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130400, 130000, '邯郸市', '邯郸', '114.490685', '36.612274', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130402, 130400, '邯山区', '邯山', '114.484985', '36.603195', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130403, 130400, '丛台区', '丛台', '114.494705', '36.61108', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130404, 130400, '复兴区', '复兴', '114.458244', '36.615482', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130406, 130400, '峰峰矿区', '峰峰矿', '114.20994', '36.420486', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130407, 130400, '肥乡区', '肥乡', '114.80002', '36.54811', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130408, 130400, '永年区', '永年', '114.49095', '36.77771', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130423, 130400, '临漳县', '临漳', '114.6107', '36.337605', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130424, 130400, '成安县', '成安', '114.68036', '36.443832', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130425, 130400, '大名县', '大名', '115.15259', '36.283318', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130426, 130400, '涉县', '涉县', '113.673294', '36.563145', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130427, 130400, '磁县', '磁县', '114.38208', '36.367672', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130430, 130400, '邱县', '邱县', '115.16859', '36.81325', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130431, 130400, '鸡泽县', '鸡泽', '114.87852', '36.91491', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130432, 130400, '广平县', '广平', '114.95086', '36.483604', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130433, 130400, '馆陶县', '馆陶', '115.289055', '36.53946', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130434, 130400, '魏县', '魏县', '114.93411', '36.354248', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130435, 130400, '曲周县', '曲周', '114.95759', '36.7734', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130481, 130400, '武安市', '武安', '114.19458', '36.696114', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130500, 130000, '邢台市', '邢台', '114.50885', '37.0682', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130502, 130500, '襄都区', '桥东', '114.50713', '37.064125', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130503, 130500, '信都区', '桥西', '114.47369', '37.06801', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130505, 130500, '任泽区', '任泽', '', '', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130506, 130500, '南和区', '南和', '', '', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130522, 130500, '临城县', '临城', '114.506874', '37.444008', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130523, 130500, '内丘县', '内丘', '114.51152', '37.287663', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130524, 130500, '柏乡县', '柏乡', '114.69338', '37.483597', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130525, 130500, '隆尧县', '隆尧', '114.776344', '37.350925', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130528, 130500, '宁晋县', '宁晋', '114.92103', '37.618958', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130529, 130500, '巨鹿县', '巨鹿', '115.03878', '37.21768', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130530, 130500, '新河县', '新河', '115.247536', '37.526215', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130531, 130500, '广宗县', '广宗', '115.1428', '37.075546', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130532, 130500, '平乡县', '平乡', '115.02922', '37.069405', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130533, 130500, '威县', '威县', '115.27275', '36.983273', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130534, 130500, '清河县', '清河', '115.669', '37.05999', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130535, 130500, '临西县', '临西', '115.49869', '36.8642', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130581, 130500, '南宫市', '南宫', '115.3981', '37.35967', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130582, 130500, '沙河市', '沙河', '114.504906', '36.861904', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130600, 130000, '保定市', '保定', '115.48233', '38.867657', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130602, 130600, '竞秀区', '新市', '115.47066', '38.88662', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130606, 130600, '莲池区', '莲池', '115.49715', '38.88353', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130607, 130600, '满城区', '满城', '115.32217', '38.94892', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130608, 130600, '清苑区', '清苑', '115.48989', '38.76526', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130609, 130600, '徐水区', '徐水', '115.65586', '39.01865', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130623, 130600, '涞水县', '涞水', '115.71198', '39.393147', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130624, 130600, '阜平县', '阜平', '114.1988', '38.847275', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130626, 130600, '定兴县', '定兴', '115.7969', '39.266193', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130627, 130600, '唐县', '唐县', '114.98124', '38.748543', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130628, 130600, '高阳县', '高阳', '115.77888', '38.69009', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130629, 130600, '容城县', '容城', '115.86625', '39.05282', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130630, 130600, '涞源县', '涞源', '114.692566', '39.35755', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130631, 130600, '望都县', '望都', '115.15401', '38.707447', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130632, 130600, '安新县', '安新', '115.93198', '38.929913', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130633, 130600, '易县', '易县', '115.501144', '39.35297', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130634, 130600, '曲阳县', '曲阳', '114.704056', '38.61999', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130635, 130600, '蠡县', '蠡县', '115.58363', '38.49643', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130636, 130600, '顺平县', '顺平', '115.13275', '38.845127', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130637, 130600, '博野县', '博野', '115.4618', '38.45827', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130638, 130600, '雄县', '雄县', '116.107475', '38.990818', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130681, 130600, '涿州市', '涿州', '115.97341', '39.485764', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130682, 130600, '定州市', '定州', '114.99139', '38.5176', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130683, 130600, '安国市', '安国', '115.33141', '38.421368', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130684, 130600, '高碑店市', '高碑店', '115.882706', '39.32769', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130700, 130000, '张家口市', '张家口', '114.884094', '40.8119', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130702, 130700, '桥东区', '桥东', '114.88566', '40.813873', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130703, 130700, '桥西区', '桥西', '114.882126', '40.824387', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130705, 130700, '宣化区', '宣化区', '115.0632', '40.609367', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130706, 130700, '下花园区', '下花园', '115.281', '40.488644', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130708, 130700, '万全区', '万全', '114.74055', '40.76699', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130709, 130700, '崇礼区', '崇礼', '115.282349', '40.974758', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130722, 130700, '张北县', '张北', '114.71595', '41.151714', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130723, 130700, '康保县', '康保', '114.61581', '41.850044', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130724, 130700, '沽源县', '沽源', '115.68484', '41.66742', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130725, 130700, '尚义县', '尚义', '113.977715', '41.08009', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130726, 130700, '蔚县', '蔚县', '114.582695', '39.83718', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130727, 130700, '阳原县', '阳原', '114.16734', '40.11342', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130728, 130700, '怀安县', '怀安', '114.42236', '40.671272', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130730, 130700, '怀来县', '怀来', '115.52084', '40.405403', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130731, 130700, '涿鹿县', '涿鹿', '115.219246', '40.3787', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130732, 130700, '赤城县', '赤城', '115.83271', '40.912083', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130800, 130000, '承德市', '承德', '117.939156', '40.976204', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130802, 130800, '双桥区', '双桥', '117.939156', '40.976204', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130803, 130800, '双滦区', '双滦', '117.797485', '40.959755', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130804, 130800, '鹰手营子矿区', '鹰手营子矿', '117.661156', '40.546955', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130821, 130800, '承德县', '承德', '118.17249', '40.76864', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130822, 130800, '兴隆县', '兴隆', '117.507095', '40.418526', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130824, 130800, '滦平县', '滦平', '117.33713', '40.936646', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130825, 130800, '隆化县', '隆化', '117.73634', '41.316666', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130826, 130800, '丰宁满族自治县', '丰宁', '116.65121', '41.209904', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130827, 130800, '宽城满族自治县', '宽城', '118.48864', '40.607983', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130828, 130800, '围场满族蒙古族自治县', '围场', '117.764084', '41.949406', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130881, 130800, '平泉市', '平泉', '118.70065', '41.01797', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130900, 130000, '沧州市', '沧州', '116.85746', '38.31058', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130902, 130900, '新华区', '新华', '116.87305', '38.308273', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130903, 130900, '运河区', '运河', '116.840065', '38.307404', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130921, 130900, '沧县', '沧县', '117.00748', '38.219856', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130922, 130900, '青县', '青县', '116.83839', '38.569645', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130923, 130900, '东光县', '东光', '116.54206', '37.88655', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130924, 130900, '海兴县', '海兴', '117.496605', '38.141582', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130925, 130900, '盐山县', '盐山', '117.22981', '38.05614', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130926, 130900, '肃宁县', '肃宁', '115.83585', '38.4271', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130927, 130900, '南皮县', '南皮', '116.70917', '38.04244', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130928, 130900, '吴桥县', '吴桥', '116.39151', '37.62818', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130929, 130900, '献县', '献县', '116.12384', '38.18966', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130930, 130900, '孟村回族自治县', '孟村', '117.1051', '38.057953', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130981, 130900, '泊头市', '泊头', '116.57016', '38.07348', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130982, 130900, '任丘市', '任丘', '116.106766', '38.706512', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130983, 130900, '黄骅市', '黄骅', '117.3438', '38.36924', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (130984, 130900, '河间市', '河间', '116.089455', '38.44149', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (131000, 130000, '廊坊市', '廊坊', '116.70444', '39.523926', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (131002, 131000, '安次区', '安次', '116.69454', '39.502567', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (131003, 131000, '广阳区', '广阳', '116.71371', '39.52193', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (131022, 131000, '固安县', '固安', '116.2999', '39.436466', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (131023, 131000, '永清县', '永清', '116.49809', '39.319717', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (131024, 131000, '香河县', '香河', '117.007164', '39.757214', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (131025, 131000, '大城县', '大城', '116.64073', '38.699215', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (131026, 131000, '文安县', '文安', '116.460106', '38.866802', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (131028, 131000, '大厂回族自治县', '大厂', '116.9865', '39.889267', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (131081, 131000, '霸州市', '霸州', '116.39202', '39.117332', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (131082, 131000, '三河市', '三河', '117.07702', '39.982777', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (131100, 130000, '衡水市', '衡水', '115.66599', '37.735096', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (131102, 131100, '桃城区', '桃城', '115.69495', '37.73224', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (131103, 131100, '冀州区', '冀州', '115.57938', '37.55085', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (131121, 131100, '枣强县', '枣强', '115.7265', '37.511513', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (131122, 131100, '武邑县', '武邑', '115.89242', '37.803776', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (131123, 131100, '武强县', '武强', '115.97024', '38.03698', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (131124, 131100, '饶阳县', '饶阳', '115.72658', '38.23267', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (131125, 131100, '安平县', '安平', '115.51963', '38.233513', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (131126, 131100, '故城县', '故城', '115.96674', '37.350983', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (131127, 131100, '景县', '景县', '116.258446', '37.686623', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (131128, 131100, '阜城县', '阜城', '116.16473', '37.869946', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (131182, 131100, '深州市', '深州', '115.554596', '38.00347', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140000, 0, '山西省', '山西', '112.54925', '37.857014', 1, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140100, 140000, '太原市', '太原', '112.54925', '37.857014', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140105, 140100, '小店区', '小店', '112.56427', '37.817974', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140106, 140100, '迎泽区', '迎泽', '112.55885', '37.855804', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140107, 140100, '杏花岭区', '杏花岭', '112.560745', '37.87929', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140108, 140100, '尖草坪区', '尖草坪', '112.48712', '37.93989', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140109, 140100, '万柏林区', '万柏林', '112.522255', '37.86265', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140110, 140100, '晋源区', '晋源', '112.47785', '37.71562', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140121, 140100, '清徐县', '清徐', '112.35796', '37.60729', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140122, 140100, '阳曲县', '阳曲', '112.67382', '38.058796', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140123, 140100, '娄烦县', '娄烦', '111.7938', '38.066036', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140181, 140100, '古交市', '古交', '112.174355', '37.908535', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140200, 140000, '大同市', '大同', '113.29526', '40.09031', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140212, 140200, '新荣区', '新荣', '113.141045', '40.25827', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140213, 140200, '平城区', '平城', '113.29798', '40.07583', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140214, 140200, '云冈区', '云冈', '113.14952', '40.00543', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140215, 140200, '云州区', '云州', '113.61217', '40.04016', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140221, 140200, '阳高县', '阳高', '113.74987', '40.364925', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140222, 140200, '天镇县', '天镇', '114.09112', '40.421337', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140223, 140200, '广灵县', '广灵', '114.27925', '39.76305', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140224, 140200, '灵丘县', '灵丘', '114.23576', '39.438866', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140225, 140200, '浑源县', '浑源', '113.69809', '39.6991', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140226, 140200, '左云县', '左云', '112.70641', '40.012875', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140300, 140000, '阳泉市', '阳泉', '113.58328', '37.861187', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140302, 140300, '城区', '城区', '113.58651', '37.86094', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140303, 140300, '矿区', '矿区', '113.55907', '37.870087', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140311, 140300, '郊区', '郊区', '113.58328', '37.861187', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140321, 140300, '平定县', '平定', '113.63105', '37.80029', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140322, 140300, '盂县', '盂县', '113.41223', '38.086132', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140400, 140000, '长治市', '长治', '113.113556', '36.191113', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140403, 140400, '潞州区', '潞州', '113.12303', '36.20346', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140404, 140400, '上党区', '上党', '113.05135', '36.05312', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140405, 140400, '屯留区', '屯留', '112.89221', '36.31553', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140406, 140400, '潞城区', '潞城', '113.22893', '36.33418', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140423, 140400, '襄垣县', '襄垣', '113.050095', '36.532852', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140425, 140400, '平顺县', '平顺', '113.43879', '36.200203', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140426, 140400, '黎城县', '黎城', '113.38737', '36.50297', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140427, 140400, '壶关县', '壶关', '113.20614', '36.11094', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140428, 140400, '长子县', '长子', '112.88466', '36.119484', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140429, 140400, '武乡县', '武乡', '112.8653', '36.834316', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140430, 140400, '沁县', '沁县', '112.70138', '36.757122', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140431, 140400, '沁源县', '沁源', '112.34088', '36.50078', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140500, 140000, '晋城市', '晋城', '112.85127', '35.497555', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140502, 140500, '城区', '城区', '112.8531', '35.49664', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140521, 140500, '沁水县', '沁水', '112.18721', '35.689472', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140522, 140500, '阳城县', '阳城', '112.42201', '35.482178', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140524, 140500, '陵川县', '陵川', '113.27888', '35.775616', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140525, 140500, '泽州县', '泽州', '112.89914', '35.61722', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140581, 140500, '高平市', '高平', '112.930695', '35.791355', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140600, 140000, '朔州市', '朔州', '112.43339', '39.33126', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140602, 140600, '朔城区', '朔城', '112.42867', '39.324524', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140603, 140600, '平鲁区', '平鲁', '112.29523', '39.515602', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140621, 140600, '山阴县', '山阴', '112.8164', '39.52677', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140622, 140600, '应县', '应县', '113.18751', '39.55919', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140623, 140600, '右玉县', '右玉', '112.46559', '39.98881', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140681, 140600, '怀仁市', '怀仁', '113.10012', '39.82788', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140700, 140000, '晋中市', '晋中', '112.736465', '37.696495', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140702, 140700, '榆次区', '榆次', '112.74006', '37.6976', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140703, 140700, '太谷区', '太谷', '112.55126', '37.42119', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140721, 140700, '榆社县', '榆社', '112.97352', '37.06902', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140722, 140700, '左权县', '左权', '113.37783', '37.079674', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140723, 140700, '和顺县', '和顺', '113.57292', '37.327026', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140724, 140700, '昔阳县', '昔阳', '113.70617', '37.60437', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140725, 140700, '寿阳县', '寿阳', '113.17771', '37.891136', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140727, 140700, '祁县', '祁县', '112.33053', '37.358738', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140728, 140700, '平遥县', '平遥', '112.17406', '37.195473', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140729, 140700, '灵石县', '灵石', '111.77276', '36.84747', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140781, 140700, '介休市', '介休', '111.91386', '37.027615', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140800, 140000, '运城市', '运城', '111.00396', '35.022778', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140802, 140800, '盐湖区', '盐湖', '111.000626', '35.025642', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140821, 140800, '临猗县', '临猗', '110.77493', '35.141884', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140822, 140800, '万荣县', '万荣', '110.84356', '35.41704', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140823, 140800, '闻喜县', '闻喜', '111.22031', '35.35384', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140824, 140800, '稷山县', '稷山', '110.979', '35.60041', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140825, 140800, '新绛县', '新绛', '111.225204', '35.613697', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140826, 140800, '绛县', '绛县', '111.57618', '35.49045', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140827, 140800, '垣曲县', '垣曲', '111.67099', '35.298294', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140828, 140800, '夏县', '夏县', '111.223175', '35.14044', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140829, 140800, '平陆县', '平陆', '111.21238', '34.837257', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140830, 140800, '芮城县', '芮城', '110.69114', '34.69477', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140881, 140800, '永济市', '永济', '110.44798', '34.865124', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140882, 140800, '河津市', '河津', '110.710266', '35.59715', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140900, 140000, '忻州市', '忻州', '112.733536', '38.41769', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140902, 140900, '忻府区', '忻府', '112.734116', '38.417744', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140921, 140900, '定襄县', '定襄', '112.963234', '38.484947', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140922, 140900, '五台县', '五台', '113.25901', '38.72571', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140923, 140900, '代县', '代县', '112.96252', '39.06514', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140924, 140900, '繁峙县', '繁峙', '113.26771', '39.188103', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140925, 140900, '宁武县', '宁武', '112.30794', '39.001717', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140926, 140900, '静乐县', '静乐', '111.94023', '38.355946', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140927, 140900, '神池县', '神池', '112.20044', '39.088467', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140928, 140900, '五寨县', '五寨', '111.84102', '38.91276', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140929, 140900, '岢岚县', '岢岚', '111.56981', '38.705624', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140930, 140900, '河曲县', '河曲', '111.14661', '39.381893', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140931, 140900, '保德县', '保德', '111.085686', '39.022575', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140932, 140900, '偏关县', '偏关', '111.50048', '39.442154', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (140981, 140900, '原平市', '原平', '112.713135', '38.729187', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (141000, 140000, '临汾市', '临汾', '111.517975', '36.08415', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (141002, 141000, '尧都区', '尧都', '111.52294', '36.080364', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (141021, 141000, '曲沃县', '曲沃', '111.47553', '35.641388', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (141022, 141000, '翼城县', '翼城', '111.71351', '35.73862', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (141023, 141000, '襄汾县', '襄汾', '111.44293', '35.87614', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (141024, 141000, '洪洞县', '洪洞', '111.67369', '36.25574', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (141025, 141000, '古县', '古县', '111.920204', '36.26855', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (141026, 141000, '安泽县', '安泽', '112.25137', '36.14603', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (141027, 141000, '浮山县', '浮山', '111.85004', '35.97136', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (141028, 141000, '吉县', '吉县', '110.68285', '36.099354', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (141029, 141000, '乡宁县', '乡宁', '110.85737', '35.975403', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (141030, 141000, '大宁县', '大宁', '110.75128', '36.46383', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (141031, 141000, '隰县', '隰县', '110.93581', '36.692677', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (141032, 141000, '永和县', '永和', '110.63128', '36.760612', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (141033, 141000, '蒲县', '蒲县', '111.09733', '36.411682', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (141034, 141000, '汾西县', '汾西', '111.56302', '36.65337', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (141081, 141000, '侯马市', '侯马', '111.37127', '35.6203', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (141082, 141000, '霍州市', '霍州', '111.72311', '36.57202', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (141100, 140000, '吕梁市', '吕梁', '111.13434', '37.524364', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (141102, 141100, '离石区', '离石', '111.13446', '37.524036', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (141121, 141100, '文水县', '文水', '112.03259', '37.436314', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (141122, 141100, '交城县', '交城', '112.15916', '37.555157', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (141123, 141100, '兴县', '兴县', '111.12482', '38.464134', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (141124, 141100, '临县', '临县', '110.995964', '37.960808', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (141125, 141100, '柳林县', '柳林', '110.89613', '37.431664', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (141126, 141100, '石楼县', '石楼', '110.83712', '36.999428', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (141127, 141100, '岚县', '岚县', '111.671555', '38.278652', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (141128, 141100, '方山县', '方山', '111.238884', '37.89263', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (141129, 141100, '中阳县', '中阳', '111.19332', '37.342052', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (141130, 141100, '交口县', '交口', '111.18319', '36.983067', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (141181, 141100, '孝义市', '孝义', '111.78157', '37.144474', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (141182, 141100, '汾阳市', '汾阳', '111.78527', '37.267742', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150000, 0, '内蒙古自治区', '内蒙古', '111.6708', '40.81831', 1, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150100, 150000, '呼和浩特市', '呼和浩特', '111.6708', '40.81831', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150102, 150100, '新城区', '新城', '111.68597', '40.826225', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150103, 150100, '回民区', '回民', '111.66216', '40.815147', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150104, 150100, '玉泉区', '玉泉', '111.66543', '40.79942', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150105, 150100, '赛罕区', '赛罕', '111.69846', '40.807835', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150121, 150100, '土默特左旗', '土默特左', '111.13361', '40.720417', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150122, 150100, '托克托县', '托克托', '111.19732', '40.27673', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150123, 150100, '和林格尔县', '和林格尔', '111.82414', '40.380287', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150124, 150100, '清水河县', '清水河', '111.67222', '39.91248', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150125, 150100, '武川县', '武川', '111.456566', '41.094482', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150200, 150000, '包头市', '包头', '109.84041', '40.65817', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150202, 150200, '东河区', '东河', '110.02689', '40.587055', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150203, 150200, '昆都仑区', '昆都仑', '109.82293', '40.661346', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150204, 150200, '青山区', '青山', '109.88005', '40.668556', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150205, 150200, '石拐区', '石拐', '110.27257', '40.672092', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150206, 150200, '白云鄂博矿区', '白云矿区', '109.97016', '41.769245', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150207, 150200, '九原区', '九原', '109.968124', '40.600582', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150221, 150200, '土默特右旗', '土默特右', '110.526764', '40.566433', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150222, 150200, '固阳县', '固阳', '110.06342', '41.030003', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150223, 150200, '达尔罕茂明安联合旗', '达尔罕茂明安联合', '109.84041', '40.65817', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150300, 150000, '乌海市', '乌海', '106.82556', '39.673733', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150302, 150300, '海勃湾区', '海勃湾', '106.817764', '39.673527', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150303, 150300, '海南区', '海南', '106.88479', '39.44153', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150304, 150300, '乌达区', '乌达', '106.72271', '39.50229', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150400, 150000, '赤峰市', '赤峰', '118.9568', '42.27532', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150402, 150400, '红山区', '红山', '118.96109', '42.269733', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150403, 150400, '元宝山区', '元宝山', '119.28988', '42.04117', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150404, 150400, '松山区', '松山', '118.93896', '42.281048', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150421, 150400, '阿鲁科尔沁旗', '阿鲁科尔沁', '120.09497', '43.87877', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150422, 150400, '巴林左旗', '巴林左', '119.39174', '43.980717', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150423, 150400, '巴林右旗', '巴林右', '118.678345', '43.52896', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150424, 150400, '林西县', '林西', '118.05775', '43.605328', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150425, 150400, '克什克腾旗', '克什克腾', '117.542465', '43.256233', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150426, 150400, '翁牛特旗', '翁牛特', '119.02262', '42.937126', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150428, 150400, '喀喇沁旗', '喀喇沁', '118.70857', '41.92778', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150429, 150400, '宁城县', '宁城', '119.33924', '41.598694', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150430, 150400, '敖汉旗', '敖汉', '119.90649', '42.28701', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150500, 150000, '通辽市', '通辽', '122.26312', '43.617428', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150502, 150500, '科尔沁区', '科尔沁', '122.264046', '43.61742', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150521, 150500, '科尔沁左翼中旗', '科尔沁左翼中', '123.31387', '44.127167', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150522, 150500, '科尔沁左翼后旗', '科尔沁左翼后', '122.355156', '42.954563', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150523, 150500, '开鲁县', '开鲁', '121.3088', '43.602432', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150524, 150500, '库伦旗', '库伦', '121.77489', '42.73469', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150525, 150500, '奈曼旗', '奈曼', '120.662544', '42.84685', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150526, 150500, '扎鲁特旗', '扎鲁特', '120.90527', '44.555294', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150581, 150500, '霍林郭勒市', '霍林郭勒', '119.65786', '45.53236', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150600, 150000, '鄂尔多斯市', '鄂尔多斯', '109.99029', '39.81718', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150602, 150600, '东胜区', '东胜', '109.98945', '39.81788', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150603, 150600, '康巴什区', '康巴什', '109.85851', '39.60837', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150621, 150600, '达拉特旗', '达拉特', '110.04028', '40.404076', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150622, 150600, '准格尔旗', '准格尔', '111.238335', '39.86522', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150623, 150600, '鄂托克前旗', '鄂托克前', '107.48172', '38.183258', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150624, 150600, '鄂托克旗', '鄂托克', '107.982605', '39.095753', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150625, 150600, '杭锦旗', '杭锦', '108.73632', '39.831787', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150626, 150600, '乌审旗', '乌审', '108.84245', '38.59661', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150627, 150600, '伊金霍洛旗', '伊金霍洛', '109.7874', '39.604313', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150700, 150000, '呼伦贝尔市', '呼伦贝尔', '119.75817', '49.215332', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150702, 150700, '海拉尔区', '海拉尔', '119.76492', '49.21389', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150703, 150700, '扎赉诺尔区', '扎赉诺尔', '117.7927', '49.486942', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150721, 150700, '阿荣旗', '阿荣', '123.464615', '48.130505', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150722, 150700, '莫力达瓦达斡尔族自治旗', '莫力达瓦', '124.5074', '48.478386', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150723, 150700, '鄂伦春自治旗', '鄂伦春', '123.725685', '50.590176', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150724, 150700, '鄂温克族自治旗', '鄂温克', '119.75404', '49.14329', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150725, 150700, '陈巴尔虎旗', '陈巴尔虎', '119.43761', '49.328423', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150726, 150700, '新巴尔虎左旗', '新巴尔虎左', '118.267456', '48.21657', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150727, 150700, '新巴尔虎右旗', '新巴尔虎右', '116.82599', '48.669132', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150781, 150700, '满洲里市', '满洲里', '117.45556', '49.59079', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150782, 150700, '牙克石市', '牙克石', '120.729004', '49.287025', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150783, 150700, '扎兰屯市', '扎兰屯', '122.7444', '48.007412', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150784, 150700, '额尔古纳市', '额尔古纳', '120.178635', '50.2439', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150785, 150700, '根河市', '根河', '121.53272', '50.780453', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150800, 150000, '巴彦淖尔市', '巴彦淖尔', '107.41696', '40.7574', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150802, 150800, '临河区', '临河', '107.417015', '40.75709', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150821, 150800, '五原县', '五原', '108.27066', '41.097637', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150822, 150800, '磴口县', '磴口', '107.00606', '40.33048', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150823, 150800, '乌拉特前旗', '乌拉特前', '108.656815', '40.72521', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150824, 150800, '乌拉特中旗', '乌拉特中', '108.51526', '41.57254', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150825, 150800, '乌拉特后旗', '乌拉特后', '107.07494', '41.08431', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150826, 150800, '杭锦后旗', '杭锦后', '107.14768', '40.888798', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150900, 150000, '乌兰察布市', '乌兰察布', '113.11454', '41.034126', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150902, 150900, '集宁区', '集宁', '113.116455', '41.034134', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150921, 150900, '卓资县', '卓资', '112.577705', '40.89576', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150922, 150900, '化德县', '化德', '114.01008', '41.899334', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150923, 150900, '商都县', '商都', '113.560646', '41.56016', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150924, 150900, '兴和县', '兴和', '113.83401', '40.872437', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150925, 150900, '凉城县', '凉城', '112.50091', '40.531628', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150926, 150900, '察哈尔右翼前旗', '察哈尔右翼前', '113.21196', '40.786858', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150927, 150900, '察哈尔右翼中旗', '察哈尔右翼中', '112.63356', '41.27421', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150928, 150900, '察哈尔右翼后旗', '察哈尔右翼后', '113.1906', '41.447212', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150929, 150900, '四子王旗', '四子王', '111.70123', '41.528114', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (150981, 150900, '丰镇市', '丰镇', '113.16346', '40.437534', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (152200, 150000, '兴安盟', '兴安', '122.07032', '46.076267', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (152201, 152200, '乌兰浩特市', '乌兰浩特', '122.06898', '46.077236', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (152202, 152200, '阿尔山市', '阿尔山', '119.94366', '47.177', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (152221, 152200, '科尔沁右翼前旗', '科尔沁右翼前', '121.95754', '46.076496', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (152222, 152200, '科尔沁右翼中旗', '科尔沁右翼中', '121.47282', '45.059647', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (152223, 152200, '扎赉特旗', '扎赉特', '122.90933', '46.725136', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (152224, 152200, '突泉县', '突泉', '121.56486', '45.380985', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (152500, 150000, '锡林郭勒盟', '锡林郭勒', '116.090996', '43.94402', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (152501, 152500, '二连浩特市', '二连浩特', '111.97981', '43.652897', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (152502, 152500, '锡林浩特市', '锡林浩特', '116.0919', '43.9443', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (152522, 152500, '阿巴嘎旗', '阿巴嘎', '114.97062', '44.022728', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (152523, 152500, '苏尼特左旗', '苏尼特左', '113.65341', '43.854107', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (152524, 152500, '苏尼特右旗', '苏尼特右', '112.65539', '42.746662', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (152525, 152500, '东乌珠穆沁旗', '东乌珠穆沁', '116.98002', '45.510307', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (152526, 152500, '西乌珠穆沁旗', '西乌珠穆沁', '117.61525', '44.586147', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (152527, 152500, '太仆寺旗', '太仆寺', '115.28728', '41.8952', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (152528, 152500, '镶黄旗', '镶黄', '113.84387', '42.239227', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (152529, 152500, '正镶白旗', '正镶白', '115.031425', '42.286808', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (152530, 152500, '正蓝旗', '正蓝', '116.00331', '42.245895', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (152531, 152500, '多伦县', '多伦', '116.47729', '42.197964', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (152900, 150000, '阿拉善盟', '阿拉善', '105.70642', '38.844814', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (152921, 152900, '阿拉善左旗', '阿拉善左', '105.70192', '38.84724', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (152922, 152900, '阿拉善右旗', '阿拉善右', '101.67198', '39.21159', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (152923, 152900, '额济纳旗', '额济纳', '101.06944', '41.958813', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210000, 0, '辽宁省', '辽宁', '123.42909', '41.79677', 1, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210100, 210000, '沈阳市', '沈阳', '123.42909', '41.79677', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210102, 210100, '和平区', '和平', '123.40666', '41.788074', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210103, 210100, '沈河区', '沈河', '123.445694', '41.79559', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210104, 210100, '大东区', '大东', '123.469955', '41.808502', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210105, 210100, '皇姑区', '皇姑', '123.40568', '41.822334', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210106, 210100, '铁西区', '铁西', '123.35066', '41.787807', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210111, 210100, '苏家屯区', '苏家屯', '123.341606', '41.665905', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210112, 210100, '浑南区', '东陵', '123.458984', '41.741947', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210113, 210100, '沈北新区', '沈北新', '123.58424', '41.91303', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210114, 210100, '于洪区', '于洪', '123.31083', '41.795834', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210115, 210100, '辽中区', '辽中', '122.76549', '41.51685', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210123, 210100, '康平县', '康平', '123.3527', '42.74153', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210124, 210100, '法库县', '法库', '123.416725', '42.507046', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210181, 210100, '新民市', '新民', '122.828865', '41.99651', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210200, 210000, '大连市', '大连', '121.61862', '38.91459', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210202, 210200, '中山区', '中山', '121.64376', '38.921555', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210203, 210200, '西岗区', '西岗', '121.61611', '38.914265', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210204, 210200, '沙河口区', '沙河口', '121.593704', '38.91286', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210211, 210200, '甘井子区', '甘井子', '121.58261', '38.975147', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210212, 210200, '旅顺口区', '旅顺口', '121.26713', '38.812042', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210213, 210200, '金州区', '金州', '121.78941', '39.052746', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210214, 210200, '普兰店区', '普兰店', '121.96323', '39.39443', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210224, 210200, '长海县', '长海', '122.58782', '39.2724', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210281, 210200, '瓦房店市', '瓦房店', '122.002655', '39.63065', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210283, 210200, '庄河市', '庄河', '122.97061', '39.69829', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210300, 210000, '鞍山市', '鞍山', '122.99563', '41.110626', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210302, 210300, '铁东区', '铁东', '122.99448', '41.110344', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210303, 210300, '铁西区', '铁西', '122.97183', '41.11069', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210304, 210300, '立山区', '立山', '123.0248', '41.150623', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210311, 210300, '千山区', '千山', '122.95788', '41.07072', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210321, 210300, '台安县', '台安', '122.42973', '41.38686', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210323, 210300, '岫岩满族自治县', '岫岩', '123.28833', '40.28151', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210381, 210300, '海城市', '海城', '122.7522', '40.85253', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210400, 210000, '抚顺市', '抚顺', '123.92111', '41.875957', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210402, 210400, '新抚区', '新抚', '123.902855', '41.86082', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210403, 210400, '东洲区', '东洲', '124.04722', '41.86683', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210404, 210400, '望花区', '望花', '123.801506', '41.851803', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210411, 210400, '顺城区', '顺城', '123.91717', '41.88113', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210421, 210400, '抚顺县', '抚顺', '124.09798', '41.922646', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210422, 210400, '新宾满族自治县', '新宾', '125.037544', '41.732456', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210423, 210400, '清原满族自治县', '清原', '124.92719', '42.10135', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210500, 210000, '本溪市', '本溪', '123.770515', '41.29791', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210502, 210500, '平山区', '平山', '123.76123', '41.29158', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210503, 210500, '溪湖区', '溪湖', '123.76523', '41.330055', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210504, 210500, '明山区', '明山', '123.76329', '41.30243', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210505, 210500, '南芬区', '南芬', '123.74838', '41.10409', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210521, 210500, '本溪满族自治县', '本溪', '124.12616', '41.300343', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210522, 210500, '桓仁满族自治县', '桓仁', '125.35919', '41.268997', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210600, 210000, '丹东市', '丹东', '124.38304', '40.124294', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210602, 210600, '元宝区', '元宝', '124.39781', '40.136482', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210603, 210600, '振兴区', '振兴', '124.36115', '40.102802', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210604, 210600, '振安区', '振安', '124.42771', '40.158558', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210624, 210600, '宽甸满族自治县', '宽甸', '124.78487', '40.73041', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210681, 210600, '东港市', '东港', '124.14944', '39.88347', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210682, 210600, '凤城市', '凤城', '124.07107', '40.457565', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210700, 210000, '锦州市', '锦州', '121.13574', '41.11927', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210702, 210700, '古塔区', '古塔', '121.13009', '41.11572', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210703, 210700, '凌河区', '凌河', '121.151306', '41.114662', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210711, 210700, '太和区', '太和', '121.1073', '41.105377', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210726, 210700, '黑山县', '黑山', '122.11791', '41.691803', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210727, 210700, '义县', '义县', '121.24283', '41.537224', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210781, 210700, '凌海市', '凌海', '121.364235', '41.171738', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210782, 210700, '北镇市', '北镇', '121.79596', '41.598763', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210800, 210000, '营口市', '营口', '122.23515', '40.66743', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210802, 210800, '站前区', '站前', '122.253235', '40.66995', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210803, 210800, '西市区', '西市', '122.21007', '40.663086', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210804, 210800, '鲅鱼圈区', '鲅鱼圈', '122.12724', '40.263645', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210811, 210800, '老边区', '老边', '122.38258', '40.682724', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210881, 210800, '盖州市', '盖州', '122.35554', '40.405235', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210882, 210800, '大石桥市', '大石桥', '122.5059', '40.633972', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210900, 210000, '阜新市', '阜新', '121.648964', '42.011795', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210902, 210900, '海州区', '海州', '121.65764', '42.01116', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210903, 210900, '新邱区', '新邱', '121.79054', '42.0866', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210904, 210900, '太平区', '太平', '121.677574', '42.011147', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210905, 210900, '清河门区', '清河门', '121.42018', '41.780476', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210911, 210900, '细河区', '细河', '121.65479', '42.01922', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210921, 210900, '阜新蒙古族自治县', '阜新', '121.743126', '42.058605', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (210922, 210900, '彰武县', '彰武', '122.537445', '42.384823', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211000, 210000, '辽阳市', '辽阳', '123.18152', '41.2694', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211002, 211000, '白塔区', '白塔', '123.17261', '41.26745', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211003, 211000, '文圣区', '文圣', '123.188225', '41.266766', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211004, 211000, '宏伟区', '宏伟', '123.20046', '41.205746', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211005, 211000, '弓长岭区', '弓长岭', '123.43163', '41.15783', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211011, 211000, '太子河区', '太子河', '123.18533', '41.251682', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211021, 211000, '辽阳县', '辽阳', '123.07967', '41.21648', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211081, 211000, '灯塔市', '灯塔', '123.32587', '41.427837', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211100, 210000, '盘锦市', '盘锦', '122.06957', '41.124485', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211102, 211100, '双台子区', '双台子', '122.05573', '41.190365', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211103, 211100, '兴隆台区', '兴隆台', '122.071625', '41.12242', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211104, 211100, '大洼区', '大洼', '122.08245', '41.00247', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211122, 211100, '盘山县', '盘山', '121.98528', '41.2407', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211200, 210000, '铁岭市', '铁岭', '123.84428', '42.290585', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211202, 211200, '银州区', '银州', '123.84488', '42.29228', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211204, 211200, '清河区', '清河', '124.14896', '42.542976', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211221, 211200, '铁岭县', '铁岭', '123.72567', '42.223316', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211223, 211200, '西丰县', '西丰', '124.72332', '42.73809', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211224, 211200, '昌图县', '昌图', '124.11017', '42.784443', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211281, 211200, '调兵山市', '调兵山', '123.545364', '42.450733', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211282, 211200, '开原市', '开原', '124.04555', '42.54214', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211300, 210000, '朝阳市', '朝阳', '120.45118', '41.57676', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211302, 211300, '双塔区', '双塔', '120.44877', '41.579388', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211303, 211300, '龙城区', '龙城', '120.413376', '41.576748', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211321, 211300, '朝阳县', '朝阳', '120.40422', '41.52634', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211322, 211300, '建平县', '建平', '119.642365', '41.402576', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211324, 211300, '喀喇沁左翼蒙古族自治县', '喀左', '119.74488', '41.125427', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211381, 211300, '北票市', '北票', '120.76695', '41.803288', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211382, 211300, '凌源市', '凌源', '119.40479', '41.243088', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211400, 210000, '葫芦岛市', '葫芦岛', '120.85639', '40.755573', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211402, 211400, '连山区', '连山', '120.85937', '40.755142', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211403, 211400, '龙港区', '龙港', '120.83857', '40.70999', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211404, 211400, '南票区', '南票', '120.75231', '41.098812', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211421, 211400, '绥中县', '绥中', '120.34211', '40.328407', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211422, 211400, '建昌县', '建昌', '119.80778', '40.81287', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (211481, 211400, '兴城市', '兴城', '120.72936', '40.61941', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220000, 0, '吉林省', '吉林', '125.3245', '43.88684', 1, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220100, 220000, '长春市', '长春', '125.3245', '43.88684', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220102, 220100, '南关区', '南关', '125.337234', '43.890236', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220103, 220100, '宽城区', '宽城', '125.34283', '43.903824', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220104, 220100, '朝阳区', '朝阳', '125.31804', '43.86491', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220105, 220100, '二道区', '二道', '125.38473', '43.870823', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220106, 220100, '绿园区', '绿园', '125.27247', '43.892178', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220112, 220100, '双阳区', '双阳', '125.65902', '43.52517', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220113, 220100, '九台区', '九台', '125.83949', '44.15174', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220122, 220100, '农安县', '农安', '125.175285', '44.43126', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220182, 220100, '榆树市', '榆树', '126.55011', '44.82764', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220183, 220100, '德惠市', '德惠', '125.70332', '44.53391', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220184, 220100, '公主岭市', '公主岭', '', '', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220200, 220000, '吉林市', '吉林', '126.55302', '43.84358', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220202, 220200, '昌邑区', '昌邑', '126.57076', '43.851116', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220203, 220200, '龙潭区', '龙潭', '126.56143', '43.909756', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220204, 220200, '船营区', '船营', '126.55239', '43.843803', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220211, 220200, '丰满区', '丰满', '126.56076', '43.816593', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220221, 220200, '永吉县', '永吉', '126.501625', '43.667416', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220281, 220200, '蛟河市', '蛟河', '127.342735', '43.720577', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220282, 220200, '桦甸市', '桦甸', '126.745445', '42.97209', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220283, 220200, '舒兰市', '舒兰', '126.947815', '44.410908', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220284, 220200, '磐石市', '磐石', '126.05993', '42.942474', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220300, 220000, '四平市', '四平', '124.37079', '43.170345', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220302, 220300, '铁西区', '铁西', '124.36089', '43.17626', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220303, 220300, '铁东区', '铁东', '124.388466', '43.16726', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220322, 220300, '梨树县', '梨树', '124.3358', '43.30831', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220323, 220300, '伊通满族自治县', '伊通', '125.30312', '43.345463', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220382, 220300, '双辽市', '双辽', '123.50528', '43.518276', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220400, 220000, '辽源市', '辽源', '125.14535', '42.90269', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220402, 220400, '龙山区', '龙山', '125.145164', '42.902702', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220403, 220400, '西安区', '西安', '125.15142', '42.920414', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220421, 220400, '东丰县', '东丰', '125.529625', '42.67523', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220422, 220400, '东辽县', '东辽', '124.992', '42.927723', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220500, 220000, '通化市', '通化', '125.9365', '41.721176', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220502, 220500, '东昌区', '东昌', '125.936714', '41.721233', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220503, 220500, '二道江区', '二道江', '126.04599', '41.777565', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220521, 220500, '通化县', '通化', '125.75312', '41.677917', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220523, 220500, '辉南县', '辉南', '126.04282', '42.68346', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220524, 220500, '柳河县', '柳河', '125.74054', '42.281483', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220581, 220500, '梅河口市', '梅河口', '125.68734', '42.530003', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220582, 220500, '集安市', '集安', '126.1862', '41.126274', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220600, 220000, '白山市', '白山', '126.42784', '41.942505', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220602, 220600, '浑江区', '浑江', '126.42803', '41.943066', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220605, 220600, '江源区', '江源', '126.59088', '42.05665', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220621, 220600, '抚松县', '抚松', '127.273796', '42.33264', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220622, 220600, '靖宇县', '靖宇', '126.80839', '42.38969', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220623, 220600, '长白朝鲜族自治县', '长白', '128.20338', '41.41936', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220681, 220600, '临江市', '临江', '126.9193', '41.810688', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220700, 220000, '松原市', '松原', '124.82361', '45.118244', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220702, 220700, '宁江区', '宁江', '124.82785', '45.1765', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220721, 220700, '前郭尔罗斯蒙古族自治县', '前郭', '124.826805', '45.116287', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220722, 220700, '长岭县', '长岭', '123.98518', '44.27658', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220723, 220700, '乾安县', '乾安', '124.02436', '45.006847', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220781, 220700, '扶余市', '扶余', '126.04972', '44.99014', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220800, 220000, '白城市', '白城', '122.84111', '45.619026', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220802, 220800, '洮北区', '洮北', '122.8425', '45.61925', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220821, 220800, '镇赉县', '镇赉', '123.20225', '45.84609', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220822, 220800, '通榆县', '通榆', '123.08855', '44.80915', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220881, 220800, '洮南市', '洮南', '122.783775', '45.33911', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (220882, 220800, '大安市', '大安', '124.29151', '45.50765', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (222400, 220000, '延边朝鲜族自治州', '延边朝鲜族', '129.51323', '42.904823', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (222401, 222400, '延吉市', '延吉', '129.5158', '42.906963', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (222402, 222400, '图们市', '图们', '129.8467', '42.96662', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (222403, 222400, '敦化市', '敦化', '128.22986', '43.36692', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (222404, 222400, '珲春市', '珲春', '130.36578', '42.871056', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (222405, 222400, '龙井市', '龙井', '129.42575', '42.77103', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (222406, 222400, '和龙市', '和龙', '129.00874', '42.547005', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (222424, 222400, '汪清县', '汪清', '129.76616', '43.315426', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (222426, 222400, '安图县', '安图', '128.90187', '43.110992', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230000, 0, '黑龙江省', '黑龙江', '126.64246', '45.756966', 1, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230100, 230000, '哈尔滨市', '哈尔滨', '126.64246', '45.756966', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230102, 230100, '道里区', '道里', '126.61253', '45.762035', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230103, 230100, '南岗区', '南岗', '126.6521', '45.75597', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230104, 230100, '道外区', '道外', '126.648834', '45.78454', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230108, 230100, '平房区', '平房', '126.62926', '45.605568', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230109, 230100, '松北区', '松北', '126.563065', '45.814655', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230110, 230100, '香坊区', '香坊', '126.66287', '45.70847', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230111, 230100, '呼兰区', '呼兰', '126.6033', '45.98423', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230112, 230100, '阿城区', '阿城', '126.95717', '45.54774', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230113, 230100, '双城区', '双城', '126.31227', '45.38355', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230123, 230100, '依兰县', '依兰', '129.5656', '46.315105', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230124, 230100, '方正县', '方正', '128.83614', '45.839535', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230125, 230100, '宾县', '宾县', '127.48594', '45.75937', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230126, 230100, '巴彦县', '巴彦', '127.4036', '46.08189', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230127, 230100, '木兰县', '木兰', '128.04268', '45.949825', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230128, 230100, '通河县', '通河', '128.74779', '45.97762', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230129, 230100, '延寿县', '延寿', '128.33188', '45.455647', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230183, 230100, '尚志市', '尚志', '127.96854', '45.214954', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230184, 230100, '五常市', '五常', '127.15759', '44.91942', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230200, 230000, '齐齐哈尔市', '齐齐哈尔', '123.95792', '47.34208', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230202, 230200, '龙沙区', '龙沙', '123.95734', '47.341736', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230203, 230200, '建华区', '建华', '123.95589', '47.354492', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230204, 230200, '铁锋区', '铁锋', '123.97356', '47.3395', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230205, 230200, '昂昂溪区', '昂昂溪', '123.81318', '47.156868', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230206, 230200, '富拉尔基区', '富拉尔基', '123.63887', '47.20697', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230207, 230200, '碾子山区', '碾子山', '122.88797', '47.51401', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230208, 230200, '梅里斯达斡尔族区', '梅里斯达斡尔族', '123.7546', '47.31111', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230221, 230200, '龙江县', '龙江', '123.187225', '47.336388', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230223, 230200, '依安县', '依安', '125.30756', '47.8901', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230224, 230200, '泰来县', '泰来', '123.41953', '46.39233', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230225, 230200, '甘南县', '甘南', '123.506035', '47.91784', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230227, 230200, '富裕县', '富裕', '124.46911', '47.797173', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230229, 230200, '克山县', '克山', '125.87435', '48.034344', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230230, 230200, '克东县', '克东', '126.24909', '48.03732', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230231, 230200, '拜泉县', '拜泉', '126.09191', '47.607365', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230281, 230200, '讷河市', '讷河', '124.88217', '48.481133', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230300, 230000, '鸡西市', '鸡西', '130.97597', '45.300045', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230302, 230300, '鸡冠区', '鸡冠', '130.97438', '45.30034', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230303, 230300, '恒山区', '恒山', '130.91063', '45.21324', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230304, 230300, '滴道区', '滴道', '130.84682', '45.348812', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230305, 230300, '梨树区', '梨树', '130.69778', '45.092194', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230306, 230300, '城子河区', '城子河', '131.0105', '45.33825', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230307, 230300, '麻山区', '麻山', '130.48112', '45.209606', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230321, 230300, '鸡东县', '鸡东', '131.14891', '45.250893', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230381, 230300, '虎林市', '虎林', '132.97388', '45.767986', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230382, 230300, '密山市', '密山', '131.87413', '45.54725', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230400, 230000, '鹤岗市', '鹤岗', '130.27748', '47.332085', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230402, 230400, '向阳区', '向阳', '130.29248', '47.34537', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230403, 230400, '工农区', '工农', '130.27666', '47.331676', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230404, 230400, '南山区', '南山', '130.27553', '47.31324', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230405, 230400, '兴安区', '兴安', '130.23618', '47.25291', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230406, 230400, '东山区', '东山', '130.31714', '47.337383', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230407, 230400, '兴山区', '兴山', '130.30534', '47.35997', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230421, 230400, '萝北县', '萝北', '130.82909', '47.577576', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230422, 230400, '绥滨县', '绥滨', '131.86052', '47.28989', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230500, 230000, '双鸭山市', '双鸭山', '131.1573', '46.64344', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230502, 230500, '尖山区', '尖山', '131.15897', '46.64296', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230503, 230500, '岭东区', '岭东', '131.16368', '46.591076', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230505, 230500, '四方台区', '四方台', '131.33318', '46.594345', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230506, 230500, '宝山区', '宝山', '131.4043', '46.573364', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230521, 230500, '集贤县', '集贤', '131.13933', '46.72898', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230522, 230500, '友谊县', '友谊', '131.81062', '46.775158', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230523, 230500, '宝清县', '宝清', '132.20642', '46.32878', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230524, 230500, '饶河县', '饶河', '134.02116', '46.80129', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230600, 230000, '大庆市', '大庆', '125.11272', '46.590733', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230602, 230600, '萨尔图区', '萨尔图', '125.11464', '46.596355', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230603, 230600, '龙凤区', '龙凤', '125.1458', '46.573948', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230604, 230600, '让胡路区', '让胡路', '124.86834', '46.653255', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230605, 230600, '红岗区', '红岗', '124.88953', '46.40305', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230606, 230600, '大同区', '大同', '124.81851', '46.034306', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230621, 230600, '肇州县', '肇州', '125.273254', '45.708687', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230622, 230600, '肇源县', '肇源', '125.08197', '45.518833', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230623, 230600, '林甸县', '林甸', '124.87774', '47.186413', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230624, 230600, '杜尔伯特蒙古族自治县', '杜尔伯特', '124.44626', '46.865974', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230700, 230000, '伊春市', '伊春', '128.8994', '47.724773', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230717, 230700, '伊美区', '伊美', '128.907302', '47.728208', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230718, 230700, '乌翠区', '乌翠', '128.66945', '47.726495', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230719, 230700, '友好区', '友好', '128.84071', '47.8538', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230722, 230700, '嘉荫县', '嘉荫', '130.39769', '48.891376', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230723, 230700, '汤旺县', '汤旺', '129.570968', '48.454691', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230724, 230700, '丰林县', '丰林', '129.53362', '48.29045', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230725, 230700, '大箐山县', '大箐山', '129.02057', '47.02834', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230726, 230700, '南岔县', '南岔', '129.28365', '47.13799', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230751, 230700, '金林区', '金林', '129.42899', '47.41303', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230781, 230700, '铁力市', '铁力', '128.03056', '46.98577', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230800, 230000, '佳木斯市', '佳木斯', '130.36163', '46.809605', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230803, 230800, '向阳区', '向阳', '130.36179', '46.809647', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230804, 230800, '前进区', '前进', '130.37769', '46.812344', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230805, 230800, '东风区', '东风', '130.40329', '46.822475', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230811, 230800, '郊区', '郊区', '130.36163', '46.809605', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230822, 230800, '桦南县', '桦南', '130.57011', '46.240116', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230826, 230800, '桦川县', '桦川', '130.72371', '47.02304', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230828, 230800, '汤原县', '汤原', '129.90446', '46.73005', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230881, 230800, '同江市', '同江', '132.51012', '47.65113', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230882, 230800, '富锦市', '富锦', '132.03795', '47.250748', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230883, 230800, '抚远市', '抚远', '134.30795', '48.36485', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230900, 230000, '七台河市', '七台河', '131.01558', '45.771267', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230902, 230900, '新兴区', '新兴', '130.88948', '45.79426', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230903, 230900, '桃山区', '桃山', '131.01585', '45.771217', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230904, 230900, '茄子河区', '茄子河', '131.07156', '45.77659', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (230921, 230900, '勃利县', '勃利', '130.57503', '45.75157', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (231000, 230000, '牡丹江市', '牡丹江', '129.6186', '44.582962', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (231002, 231000, '东安区', '东安', '129.62329', '44.582397', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (231003, 231000, '阳明区', '阳明', '129.63464', '44.59633', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (231004, 231000, '爱民区', '爱民', '129.60123', '44.595444', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (231005, 231000, '西安区', '西安', '129.61311', '44.58103', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (231025, 231000, '林口县', '林口', '130.2684', '45.286644', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (231081, 231000, '绥芬河市', '绥芬河', '131.16486', '44.396866', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (231083, 231000, '海林市', '海林', '129.38791', '44.57415', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (231084, 231000, '宁安市', '宁安', '129.47002', '44.346836', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (231085, 231000, '穆棱市', '穆棱', '130.52708', '44.91967', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (231086, 231000, '东宁市', '东宁', '131.12463', '44.08694', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (231100, 230000, '黑河市', '黑河', '127.49902', '50.249584', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (231102, 231100, '爱辉区', '爱辉', '127.49764', '50.249027', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (231123, 231100, '逊克县', '逊克', '128.47615', '49.582973', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (231124, 231100, '孙吴县', '孙吴', '127.32732', '49.423943', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (231181, 231100, '北安市', '北安', '126.508736', '48.245438', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (231182, 231100, '五大连池市', '五大连池', '126.19769', '48.512688', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (231183, 231100, '嫩江市', '嫩江', '125.22094', '49.18572', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (231200, 230000, '绥化市', '绥化', '126.99293', '46.637394', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (231202, 231200, '北林区', '北林', '126.99066', '46.63491', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (231221, 231200, '望奎县', '望奎', '126.48419', '46.83352', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (231222, 231200, '兰西县', '兰西', '126.289314', '46.259037', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (231223, 231200, '青冈县', '青冈', '126.11227', '46.686596', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (231224, 231200, '庆安县', '庆安', '127.510025', '46.879204', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (231225, 231200, '明水县', '明水', '125.90755', '47.18353', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (231226, 231200, '绥棱县', '绥棱', '127.11112', '47.247196', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (231281, 231200, '安达市', '安达', '125.329926', '46.410614', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (231282, 231200, '肇东市', '肇东', '125.9914', '46.06947', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (231283, 231200, '海伦市', '海伦', '126.96938', '47.460426', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (232700, 230000, '大兴安岭地区', '大兴安岭', '124.711525', '52.335262', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (232701, 232700, '漠河市', '漠河', '122.53864', '52.97209', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (232721, 232700, '呼玛县', '呼玛', '126.6621', '51.726997', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (232722, 232700, '塔河县', '塔河', '124.71052', '52.335228', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (310000, 0, '上海市', '上海', '121.47264', '31.231707', 1, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (310100, 310000, '上海市', '上海', '121.47264', '31.231707', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (310101, 310100, '黄浦区', '黄浦', '121.49032', '31.22277', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (310104, 310100, '徐汇区', '徐汇', '121.43752', '31.179974', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (310105, 310100, '长宁区', '长宁', '121.4222', '31.218122', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (310106, 310100, '静安区', '静安', '121.44823', '31.229004', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (310107, 310100, '普陀区', '普陀', '121.3925', '31.241701', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (310109, 310100, '虹口区', '虹口', '121.49183', '31.26097', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (310110, 310100, '杨浦区', '杨浦', '121.5228', '31.270756', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (310112, 310100, '闵行区', '闵行', '121.37597', '31.111658', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (310113, 310100, '宝山区', '宝山', '121.48994', '31.398895', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (310114, 310100, '嘉定区', '嘉定', '121.250336', '31.383524', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (310115, 310100, '浦东新区', '浦东', '121.5677', '31.245943', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (310116, 310100, '金山区', '金山', '121.330734', '30.724697', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (310117, 310100, '松江区', '松江', '121.22354', '31.03047', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (310118, 310100, '青浦区', '青浦', '121.11302', '31.151209', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (310120, 310100, '奉贤区', '奉贤', '121.45847', '30.912346', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (310151, 310100, '崇明区', '崇明', '121.3973', '31.6229', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320000, 0, '江苏省', '江苏', '118.76741', '32.041546', 1, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320100, 320000, '南京市', '南京', '118.76741', '32.041546', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320102, 320100, '玄武区', '玄武', '118.7922', '32.05068', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320104, 320100, '秦淮区', '秦淮', '118.78609', '32.033817', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320105, 320100, '建邺区', '建邺', '118.73269', '32.00454', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320106, 320100, '鼓楼区', '鼓楼', '118.76974', '32.066967', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320111, 320100, '浦口区', '浦口', '118.625305', '32.05839', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320113, 320100, '栖霞区', '栖霞', '118.8087', '32.102146', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320114, 320100, '雨花台区', '雨花台', '118.77207', '31.995947', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320115, 320100, '江宁区', '江宁', '118.850624', '31.953419', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320116, 320100, '六合区', '六合', '118.85065', '32.340656', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320117, 320100, '溧水区', '溧水', '119.0284', '31.651', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320118, 320100, '高淳区', '高淳', '118.8921', '31.32751', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320200, 320000, '无锡市', '无锡', '120.30167', '31.57473', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320205, 320200, '锡山区', '锡山', '120.3573', '31.58556', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320206, 320200, '惠山区', '惠山', '120.30354', '31.681019', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320211, 320200, '滨湖区', '滨湖', '120.26605', '31.550228', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320213, 320200, '梁溪区', '梁溪', '120.30297', '31.56597', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320214, 320200, '新吴区', '新吴', '120.36434', '31.49055', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320281, 320200, '江阴市', '江阴', '120.275894', '31.910984', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320282, 320200, '宜兴市', '宜兴', '119.82054', '31.364384', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320300, 320000, '徐州市', '徐州', '117.184814', '34.26179', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320302, 320300, '鼓楼区', '鼓楼', '117.19294', '34.269398', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320303, 320300, '云龙区', '云龙', '117.19459', '34.254807', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320305, 320300, '贾汪区', '贾汪', '117.45021', '34.441643', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320311, 320300, '泉山区', '泉山', '117.18223', '34.26225', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320312, 320300, '铜山区', '铜山', '117.16898', '34.18044', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320321, 320300, '丰县', '丰县', '116.59289', '34.696945', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320322, 320300, '沛县', '沛县', '116.93718', '34.729046', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320324, 320300, '睢宁县', '睢宁', '117.95066', '33.899223', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320381, 320300, '新沂市', '新沂', '118.345825', '34.36878', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320382, 320300, '邳州市', '邳州', '117.96392', '34.31471', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320400, 320000, '常州市', '常州', '119.946976', '31.772753', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320402, 320400, '天宁区', '天宁', '119.96378', '31.779633', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320404, 320400, '钟楼区', '钟楼', '119.94839', '31.78096', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320411, 320400, '新北区', '新北', '119.974655', '31.824663', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320412, 320400, '武进区', '武进', '119.95877', '31.718567', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320413, 320400, '金坛区', '金坛', '119.59794', '31.72322', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320481, 320400, '溧阳市', '溧阳', '119.487816', '31.42708', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320500, 320000, '苏州市', '苏州', '120.61958', '31.29938', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320505, 320500, '虎丘区', '虎丘', '120.56683', '31.294846', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320506, 320500, '吴中区', '吴中', '120.62462', '31.27084', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320507, 320500, '相城区', '相城', '120.61896', '31.396685', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320508, 320500, '姑苏区', '姑苏', '120.622246', '31.311415', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320509, 320500, '吴江区', '吴江', '120.64517', '31.13914', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320581, 320500, '常熟市', '常熟', '120.74852', '31.658155', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320582, 320500, '张家港市', '张家港', '120.54344', '31.865553', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320583, 320500, '昆山市', '昆山', '120.95814', '31.381926', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320585, 320500, '太仓市', '太仓', '121.112274', '31.452568', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320600, 320000, '南通市', '南通', '120.86461', '32.016212', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320602, 320600, '崇川区', '崇川', '120.86635', '32.015278', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320611, 320600, '港闸区', '港闸', '120.8339', '32.0403', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320612, 320600, '通州区', '通州', '121.07317', '32.084286', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320623, 320600, '如东县', '如东', '121.18609', '32.311832', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320681, 320600, '启东市', '启东', '121.65972', '31.810158', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320682, 320600, '如皋市', '如皋', '120.56632', '32.39159', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320684, 320600, '海门市', '海门', '121.176605', '31.893528', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320685, 320600, '海安市', '海安', '120.46759', '32.53308', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320700, 320000, '连云港市', '连云港', '119.17882', '34.600018', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320703, 320700, '连云区', '连云', '119.366486', '34.73953', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320706, 320700, '海州区', '海州', '119.137146', '34.57129', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320707, 320700, '赣榆区', '赣榆', '119.1773', '34.84065', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320722, 320700, '东海县', '东海', '118.76649', '34.522858', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320723, 320700, '灌云县', '灌云', '119.25574', '34.298435', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320724, 320700, '灌南县', '灌南', '119.35233', '34.092552', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320800, 320000, '淮安市', '淮安', '119.02126', '33.597507', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320803, 320800, '淮安区', '淮安', '119.14634', '33.5075', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320804, 320800, '淮阴区', '淮阴', '119.02082', '33.62245', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320812, 320800, '清江浦区', '清江浦', '119.02662', '33.55308', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320813, 320800, '洪泽区', '洪泽', '118.8735', '33.29433', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320826, 320800, '涟水县', '涟水', '119.266075', '33.77131', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320830, 320800, '盱眙县', '盱眙', '118.49382', '33.00439', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320831, 320800, '金湖县', '金湖', '119.01694', '33.01816', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320900, 320000, '盐城市', '盐城', '120.14', '33.377632', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320902, 320900, '亭湖区', '亭湖', '120.13608', '33.38391', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320903, 320900, '盐都区', '盐都', '120.139755', '33.34129', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320904, 320900, '大丰区', '大丰', '120.50102', '33.20107', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320921, 320900, '响水县', '响水', '119.579575', '34.19996', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320922, 320900, '滨海县', '滨海', '119.82844', '33.989887', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320923, 320900, '阜宁县', '阜宁', '119.805336', '33.78573', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320924, 320900, '射阳县', '射阳', '120.25745', '33.77378', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320925, 320900, '建湖县', '建湖', '119.793106', '33.472622', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (320981, 320900, '东台市', '东台', '120.3141', '32.853172', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (321000, 320000, '扬州市', '扬州', '119.421005', '32.393158', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (321002, 321000, '广陵区', '广陵', '119.44227', '32.392155', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (321003, 321000, '邗江区', '邗江', '119.39777', '32.3779', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (321012, 321000, '江都区', '江都', '119.57006', '32.43458', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (321023, 321000, '宝应县', '宝应', '119.32128', '33.23694', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (321081, 321000, '仪征市', '仪征', '119.18244', '32.271965', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (321084, 321000, '高邮市', '高邮', '119.44384', '32.785164', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (321100, 320000, '镇江市', '镇江', '119.45275', '32.204403', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (321102, 321100, '京口区', '京口', '119.454575', '32.206192', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (321111, 321100, '润州区', '润州', '119.41488', '32.2135', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (321112, 321100, '丹徒区', '丹徒', '119.43388', '32.12897', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (321181, 321100, '丹阳市', '丹阳', '119.58191', '31.991459', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (321182, 321100, '扬中市', '扬中', '119.82806', '32.237267', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (321183, 321100, '句容市', '句容', '119.16714', '31.947355', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (321200, 320000, '泰州市', '泰州', '119.91518', '32.484882', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (321202, 321200, '海陵区', '海陵', '119.92019', '32.488407', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (321203, 321200, '高港区', '高港', '119.88166', '32.3157', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (321204, 321200, '姜堰区', '姜堰', '120.12673', '32.50879', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (321281, 321200, '兴化市', '兴化', '119.840164', '32.938065', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (321282, 321200, '靖江市', '靖江', '120.26825', '32.01817', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (321283, 321200, '泰兴市', '泰兴', '120.020226', '32.168785', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (321300, 320000, '宿迁市', '宿迁', '118.27516', '33.96301', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (321302, 321300, '宿城区', '宿城', '118.278984', '33.937725', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (321311, 321300, '宿豫区', '宿豫', '118.33001', '33.94107', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (321322, 321300, '沭阳县', '沭阳', '118.77589', '34.129097', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (321323, 321300, '泗阳县', '泗阳', '118.68128', '33.711433', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (321324, 321300, '泗洪县', '泗洪', '118.21182', '33.45654', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330000, 0, '浙江省', '浙江', '120.15358', '30.287458', 1, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330100, 330000, '杭州市', '杭州', '120.15358', '30.287458', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330102, 330100, '上城区', '上城', '120.17146', '30.250237', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330103, 330100, '下城区', '下城', '120.17276', '30.276272', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330104, 330100, '江干区', '江干', '120.20264', '30.266603', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330105, 330100, '拱墅区', '拱墅', '120.150055', '30.314697', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330106, 330100, '西湖区', '西湖', '120.14738', '30.272934', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330108, 330100, '滨江区', '滨江', '120.21062', '30.206615', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330109, 330100, '萧山区', '萧山', '120.27069', '30.162931', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330110, 330100, '余杭区', '余杭', '120.301735', '30.421186', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330111, 330100, '富阳区', '富阳', '119.96043', '30.04885', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330112, 330100, '临安区', '临安', '119.7248', '30.23383', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330122, 330100, '桐庐县', '桐庐', '119.68504', '29.797438', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330127, 330100, '淳安县', '淳安', '119.04427', '29.604177', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330182, 330100, '建德市', '建德', '119.27909', '29.472284', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330200, 330000, '宁波市', '宁波', '121.54979', '29.868387', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330203, 330200, '海曙区', '海曙', '121.539696', '29.874453', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330205, 330200, '江北区', '江北', '121.55928', '29.888361', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330206, 330200, '北仑区', '北仑', '121.83131', '29.90944', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330211, 330200, '镇海区', '镇海', '121.713165', '29.952106', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330212, 330200, '鄞州区', '鄞州', '121.55843', '29.831661', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330213, 330200, '奉化区', '奉化', '121.40686', '29.65503', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330225, 330200, '象山县', '象山', '121.87709', '29.470205', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330226, 330200, '宁海县', '宁海', '121.43261', '29.299835', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330281, 330200, '余姚市', '余姚', '121.156296', '30.045404', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330282, 330200, '慈溪市', '慈溪', '121.248055', '30.177141', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330300, 330000, '温州市', '温州', '120.67211', '28.000574', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330302, 330300, '鹿城区', '鹿城', '120.67423', '28.003351', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330303, 330300, '龙湾区', '龙湾', '120.763466', '27.970255', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330304, 330300, '瓯海区', '瓯海', '120.637146', '28.006445', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330305, 330300, '洞头区', '洞头', '121.1572', '27.83616', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330324, 330300, '永嘉县', '永嘉', '120.69097', '28.153887', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330326, 330300, '平阳县', '平阳', '120.564384', '27.6693', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330327, 330300, '苍南县', '苍南', '120.40626', '27.507744', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330328, 330300, '文成县', '文成', '120.09245', '27.789133', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330329, 330300, '泰顺县', '泰顺', '119.71624', '27.557308', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330381, 330300, '瑞安市', '瑞安', '120.64617', '27.779322', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330382, 330300, '乐清市', '乐清', '120.96715', '28.116083', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330383, 330300, '龙港市', '龙港', '120.553102', '27.578205', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330400, 330000, '嘉兴市', '嘉兴', '120.75086', '30.762653', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330402, 330400, '南湖区', '南湖', '120.749954', '30.764652', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330411, 330400, '秀洲区', '秀洲', '120.72043', '30.763323', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330421, 330400, '嘉善县', '嘉善', '120.92187', '30.841352', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330424, 330400, '海盐县', '海盐', '120.94202', '30.522223', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330481, 330400, '海宁市', '海宁', '120.68882', '30.525543', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330482, 330400, '平湖市', '平湖', '121.01466', '30.698921', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330483, 330400, '桐乡市', '桐乡', '120.55109', '30.629065', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330500, 330000, '湖州市', '湖州', '120.1024', '30.867199', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330502, 330500, '吴兴区', '吴兴', '120.10142', '30.867252', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330503, 330500, '南浔区', '南浔', '120.4172', '30.872742', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330521, 330500, '德清县', '德清', '119.96766', '30.534927', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330522, 330500, '长兴县', '长兴', '119.910126', '31.00475', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330523, 330500, '安吉县', '安吉', '119.68789', '30.631973', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330600, 330000, '绍兴市', '绍兴', '120.582115', '29.997116', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330602, 330600, '越城区', '越城', '120.58531', '29.996992', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330603, 330600, '柯桥区', '柯桥', '120.49476', '30.08189', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330604, 330600, '上虞区', '上虞', '120.86858', '30.03227', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330624, 330600, '新昌县', '新昌', '120.90566', '29.501205', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330681, 330600, '诸暨市', '诸暨', '120.24432', '29.713661', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330683, 330600, '嵊州市', '嵊州', '120.82888', '29.586605', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330700, 330000, '金华市', '金华', '119.649506', '29.089523', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330702, 330700, '婺城区', '婺城', '119.65258', '29.082607', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330703, 330700, '金东区', '金东', '119.68127', '29.095835', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330723, 330700, '武义县', '武义', '119.81916', '28.896563', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330726, 330700, '浦江县', '浦江', '119.893364', '29.451254', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330727, 330700, '磐安县', '磐安', '120.44513', '29.052628', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330781, 330700, '兰溪市', '兰溪', '119.46052', '29.210066', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330782, 330700, '义乌市', '义乌', '120.07491', '29.306864', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330783, 330700, '东阳市', '东阳', '120.23334', '29.262547', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330784, 330700, '永康市', '永康', '120.03633', '28.895292', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330800, 330000, '衢州市', '衢州', '118.87263', '28.941708', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330802, 330800, '柯城区', '柯城', '118.87304', '28.944538', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330803, 330800, '衢江区', '衢江', '118.95768', '28.973194', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330822, 330800, '常山县', '常山', '118.52165', '28.90004', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330824, 330800, '开化县', '开化', '118.41444', '29.136503', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330825, 330800, '龙游县', '龙游', '119.17252', '29.031364', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330881, 330800, '江山市', '江山', '118.62788', '28.734674', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330900, 330000, '舟山市', '舟山', '122.106865', '30.016027', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330902, 330900, '定海区', '定海', '122.1085', '30.016422', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330903, 330900, '普陀区', '普陀', '122.301956', '29.945614', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330921, 330900, '岱山县', '岱山', '122.20113', '30.242865', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (330922, 330900, '嵊泗县', '嵊泗', '122.45781', '30.727165', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (331000, 330000, '台州市', '台州', '121.4286', '28.661379', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (331002, 331000, '椒江区', '椒江', '121.431046', '28.67615', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (331003, 331000, '黄岩区', '黄岩', '121.26214', '28.64488', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (331004, 331000, '路桥区', '路桥', '121.37292', '28.581799', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (331022, 331000, '三门县', '三门', '121.37643', '29.118956', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (331023, 331000, '天台县', '天台', '121.03123', '29.141127', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (331024, 331000, '仙居县', '仙居', '120.73508', '28.849213', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (331081, 331000, '温岭市', '温岭', '121.37361', '28.36878', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (331082, 331000, '临海市', '临海', '121.131226', '28.845442', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (331083, 331000, '玉环市', '玉环', '121.23164', '28.13589', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (331100, 330000, '丽水市', '丽水', '119.92178', '28.451994', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (331102, 331100, '莲都区', '莲都', '119.922295', '28.451103', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (331121, 331100, '青田县', '青田', '120.29194', '28.135246', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (331122, 331100, '缙云县', '缙云', '120.078964', '28.654207', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (331123, 331100, '遂昌县', '遂昌', '119.27589', '28.5924', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (331124, 331100, '松阳县', '松阳', '119.48529', '28.449938', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (331125, 331100, '云和县', '云和', '119.56946', '28.111076', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (331126, 331100, '庆元县', '庆元', '119.06723', '27.61823', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (331127, 331100, '景宁畲族自治县', '景宁', '119.63467', '27.977247', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (331181, 331100, '龙泉市', '龙泉', '119.13232', '28.069178', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340000, 0, '安徽省', '安徽', '117.28304', '31.86119', 1, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340100, 340000, '合肥市', '合肥', '117.28304', '31.86119', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340102, 340100, '瑶海区', '瑶海', '117.31536', '31.86961', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340103, 340100, '庐阳区', '庐阳', '117.283775', '31.86901', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340104, 340100, '蜀山区', '蜀山', '117.26207', '31.855867', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340111, 340100, '包河区', '包河', '117.28575', '31.82956', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340121, 340100, '长丰县', '长丰', '117.164696', '32.478546', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340122, 340100, '肥东县', '肥东', '117.46322', '31.883991', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340123, 340100, '肥西县', '肥西', '117.166115', '31.719646', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340124, 340100, '庐江县', '庐江', '117.28736', '31.25567', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340181, 340100, '巢湖市', '巢湖', '117.88937', '31.62329', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340200, 340000, '芜湖市', '芜湖', '118.37645', '31.326319', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340202, 340200, '镜湖区', '镜湖', '118.37634', '31.32559', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340207, 340200, '鸠江区', '鸠江', '118.40018', '31.362717', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340209, 340200, '弋江区', '弋江', '', '', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340210, 340200, '湾沚区', '湾沚', '', '', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340211, 340200, '繁昌区', '繁昌', '', '', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340223, 340200, '南陵县', '南陵', '118.337105', '30.919638', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340281, 340200, '无为市', '无为', '117.90224', '31.30317', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340300, 340000, '蚌埠市', '蚌埠', '117.36323', '32.939667', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340302, 340300, '龙子湖区', '龙子湖', '117.38231', '32.95045', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340303, 340300, '蚌山区', '蚌山', '117.35579', '32.938065', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340304, 340300, '禹会区', '禹会', '117.35259', '32.931934', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340311, 340300, '淮上区', '淮上', '117.34709', '32.963146', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340321, 340300, '怀远县', '怀远', '117.20017', '32.956936', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340322, 340300, '五河县', '五河', '117.88881', '33.146202', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340323, 340300, '固镇县', '固镇', '117.31596', '33.31868', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340400, 340000, '淮南市', '淮南', '117.018326', '32.647575', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340402, 340400, '大通区', '大通', '117.052925', '32.632065', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340403, 340400, '田家庵区', '田家庵', '117.01832', '32.64434', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340404, 340400, '谢家集区', '谢家集', '116.86536', '32.59829', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340405, 340400, '八公山区', '八公山', '116.84111', '32.628227', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340406, 340400, '潘集区', '潘集', '116.81688', '32.782116', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340421, 340400, '凤台县', '凤台', '116.72277', '32.705383', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340422, 340400, '寿县', '寿县', '116.78708', '32.57332', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340500, 340000, '马鞍山市', '马鞍山', '118.507904', '31.689362', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340503, 340500, '花山区', '花山', '118.51131', '31.69902', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340504, 340500, '雨山区', '雨山', '118.4931', '31.685911', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340506, 340500, '博望区', '博望', '118.84374', '31.56232', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340521, 340500, '当涂县', '当涂', '118.489876', '31.556168', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340522, 340500, '含山县', '含山', '118.10241', '31.73358', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340523, 340500, '和县', '和县', '118.35145', '31.74423', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340600, 340000, '淮北市', '淮北', '116.79466', '33.971706', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340602, 340600, '杜集区', '杜集', '116.83392', '33.99122', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340603, 340600, '相山区', '相山', '116.79077', '33.970917', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340604, 340600, '烈山区', '烈山', '116.80946', '33.88953', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340621, 340600, '濉溪县', '濉溪', '116.76743', '33.91641', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340700, 340000, '铜陵市', '铜陵', '117.816574', '30.929935', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340705, 340700, '铜官区', '铜官', '117.87431', '30.95614', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340706, 340700, '义安区', '义安', '117.79147', '30.95271', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340711, 340700, '郊区', '郊区', '117.816574', '30.929935', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340722, 340700, '枞阳县', '枞阳', '117.22019', '30.69961', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340800, 340000, '安庆市', '安庆', '117.04355', '30.50883', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340802, 340800, '迎江区', '迎江', '117.04497', '30.506374', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340803, 340800, '大观区', '大观', '117.034515', '30.505632', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340811, 340800, '宜秀区', '宜秀', '117.07', '30.541323', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340822, 340800, '怀宁县', '怀宁', '116.82867', '30.734995', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340825, 340800, '太湖县', '太湖', '116.30522', '30.451868', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340826, 340800, '宿松县', '宿松', '116.1202', '30.158327', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340827, 340800, '望江县', '望江', '116.690926', '30.12491', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340828, 340800, '岳西县', '岳西', '116.36048', '30.848501', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340881, 340800, '桐城市', '桐城', '116.959656', '31.050575', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (340882, 340800, '潜山市', '潜山', '116.58133', '30.63107', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341000, 340000, '黄山市', '黄山', '118.31732', '29.709238', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341002, 341000, '屯溪区', '屯溪', '118.31735', '29.709187', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341003, 341000, '黄山区', '黄山', '118.13664', '30.294518', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341004, 341000, '徽州区', '徽州', '118.339745', '29.825201', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341021, 341000, '歙县', '歙县', '118.428024', '29.867748', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341022, 341000, '休宁县', '休宁', '118.18853', '29.788877', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341023, 341000, '黟县', '黟县', '117.94291', '29.923813', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341024, 341000, '祁门县', '祁门', '117.71724', '29.853472', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341100, 340000, '滁州市', '滁州', '118.31626', '32.303627', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341102, 341100, '琅琊区', '琅琊', '118.316475', '32.3038', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341103, 341100, '南谯区', '南谯', '118.29695', '32.32984', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341122, 341100, '来安县', '来安', '118.4333', '32.45023', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341124, 341100, '全椒县', '全椒', '118.26858', '32.09385', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341125, 341100, '定远县', '定远', '117.683716', '32.527103', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341126, 341100, '凤阳县', '凤阳', '117.56246', '32.867146', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341181, 341100, '天长市', '天长', '119.011215', '32.6815', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341182, 341100, '明光市', '明光', '117.99805', '32.781204', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341200, 340000, '阜阳市', '阜阳', '115.81973', '32.89697', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341202, 341200, '颍州区', '颍州', '115.81391', '32.89124', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341203, 341200, '颍东区', '颍东', '115.85875', '32.90886', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341204, 341200, '颍泉区', '颍泉', '115.80453', '32.924797', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341221, 341200, '临泉县', '临泉', '115.26169', '33.0627', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341222, 341200, '太和县', '太和', '115.62724', '33.16229', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341225, 341200, '阜南县', '阜南', '115.59053', '32.638103', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341226, 341200, '颍上县', '颍上', '116.259125', '32.637066', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341282, 341200, '界首市', '界首', '115.362114', '33.26153', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341300, 340000, '宿州市', '宿州', '116.984085', '33.633892', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341302, 341300, '埇桥区', '埇桥', '116.98331', '33.633854', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341321, 341300, '砀山县', '砀山', '116.35111', '34.426247', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341322, 341300, '萧县', '萧县', '116.9454', '34.183266', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341323, 341300, '灵璧县', '灵璧', '117.55149', '33.54063', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341324, 341300, '泗县', '泗县', '117.885445', '33.47758', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341500, 340000, '六安市', '六安', '116.507675', '31.75289', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341502, 341500, '金安区', '金安', '116.50329', '31.754492', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341503, 341500, '裕安区', '裕安', '116.494545', '31.750692', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341504, 341500, '叶集区', '叶集', '115.9133', '31.85122', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341522, 341500, '霍邱县', '霍邱', '116.27888', '32.341305', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341523, 341500, '舒城县', '舒城', '116.94409', '31.462849', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341524, 341500, '金寨县', '金寨', '115.87852', '31.681623', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341525, 341500, '霍山县', '霍山', '116.33308', '31.402456', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341600, 340000, '亳州市', '亳州', '115.782936', '33.86934', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341602, 341600, '谯城区', '谯城', '115.78121', '33.869286', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341621, 341600, '涡阳县', '涡阳', '116.21155', '33.50283', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341622, 341600, '蒙城县', '蒙城', '116.56033', '33.260815', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341623, 341600, '利辛县', '利辛', '116.20778', '33.1435', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341700, 340000, '池州市', '池州', '117.48916', '30.656036', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341702, 341700, '贵池区', '贵池', '117.48834', '30.657377', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341721, 341700, '东至县', '东至', '117.02148', '30.096567', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341722, 341700, '石台县', '石台', '117.48291', '30.210323', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341723, 341700, '青阳县', '青阳', '117.85739', '30.63818', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341800, 340000, '宣城市', '宣城', '118.757996', '30.945667', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341802, 341800, '宣州区', '宣州', '118.758415', '30.946003', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341821, 341800, '郎溪县', '郎溪', '119.18502', '31.127834', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341823, 341800, '泾县', '泾县', '118.4124', '30.685974', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341824, 341800, '绩溪县', '绩溪', '118.5947', '30.065268', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341825, 341800, '旌德县', '旌德', '118.54308', '30.288057', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341881, 341800, '宁国市', '宁国', '118.983406', '30.62653', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (341882, 341800, '广德市', '广德', '119.41705', '30.8938', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350000, 0, '福建省', '福建', '119.30624', '26.075302', 1, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350100, 350000, '福州市', '福州', '119.30624', '26.075302', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350102, 350100, '鼓楼区', '鼓楼', '119.29929', '26.082285', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350103, 350100, '台江区', '台江', '119.31016', '26.058617', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350104, 350100, '仓山区', '仓山', '119.32099', '26.038912', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350105, 350100, '马尾区', '马尾', '119.458725', '25.991976', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350111, 350100, '晋安区', '晋安', '119.3286', '26.078836', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350112, 350100, '长乐区', '长乐', '119.52324', '25.96283', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350121, 350100, '闽侯县', '闽侯', '119.14512', '26.148567', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350122, 350100, '连江县', '连江', '119.53837', '26.202108', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350123, 350100, '罗源县', '罗源', '119.55264', '26.487234', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350124, 350100, '闽清县', '闽清', '118.868416', '26.223793', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350125, 350100, '永泰县', '永泰', '118.93909', '25.864824', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350128, 350100, '平潭县', '平潭', '119.7912', '25.503672', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350181, 350100, '福清市', '福清', '119.37699', '25.720402', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350200, 350000, '厦门市', '厦门', '118.11022', '24.490475', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350203, 350200, '思明区', '思明', '118.08783', '24.462059', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350205, 350200, '海沧区', '海沧', '118.03636', '24.492512', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350206, 350200, '湖里区', '湖里', '118.10943', '24.512764', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350211, 350200, '集美区', '集美', '118.10087', '24.572874', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350212, 350200, '同安区', '同安', '118.15045', '24.729334', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350213, 350200, '翔安区', '翔安', '118.24281', '24.63748', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350300, 350000, '莆田市', '莆田', '119.00756', '25.431011', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350302, 350300, '城厢区', '城厢', '119.00103', '25.433737', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350303, 350300, '涵江区', '涵江', '119.1191', '25.459272', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350304, 350300, '荔城区', '荔城', '119.02005', '25.430046', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350305, 350300, '秀屿区', '秀屿', '119.092606', '25.316141', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350322, 350300, '仙游县', '仙游', '118.69433', '25.35653', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350400, 350000, '三明市', '三明', '117.635', '26.265444', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350402, 350400, '梅列区', '梅列', '117.63687', '26.269209', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350403, 350400, '三元区', '三元', '117.607414', '26.234192', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350421, 350400, '明溪县', '明溪', '117.20184', '26.357374', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350423, 350400, '清流县', '清流', '116.81582', '26.17761', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350424, 350400, '宁化县', '宁化', '116.65972', '26.259932', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350425, 350400, '大田县', '大田', '117.84936', '25.690804', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350426, 350400, '尤溪县', '尤溪', '118.188576', '26.169262', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350427, 350400, '沙县', '沙县', '117.78909', '26.397362', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350428, 350400, '将乐县', '将乐', '117.47356', '26.728666', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350429, 350400, '泰宁县', '泰宁', '117.17752', '26.897995', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350430, 350400, '建宁县', '建宁', '116.84583', '26.831398', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350481, 350400, '永安市', '永安', '117.36445', '25.974075', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350500, 350000, '泉州市', '泉州', '118.589424', '24.908854', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350502, 350500, '鲤城区', '鲤城', '118.58893', '24.907644', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350503, 350500, '丰泽区', '丰泽', '118.60515', '24.896042', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350504, 350500, '洛江区', '洛江', '118.67031', '24.941153', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350505, 350500, '泉港区', '泉港', '118.912285', '25.12686', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350521, 350500, '惠安县', '惠安', '118.79895', '25.028719', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350524, 350500, '安溪县', '安溪', '118.18601', '25.056824', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350525, 350500, '永春县', '永春', '118.29503', '25.32072', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350526, 350500, '德化县', '德化', '118.24299', '25.489004', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350527, 350500, '金门县', '金门', '118.32322', '24.436417', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350581, 350500, '石狮市', '石狮', '118.6284', '24.731977', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350582, 350500, '晋江市', '晋江', '118.57734', '24.807322', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350583, 350500, '南安市', '南安', '118.38703', '24.959494', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350600, 350000, '漳州市', '漳州', '117.661804', '24.510897', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350602, 350600, '芗城区', '芗城', '117.65646', '24.509954', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350603, 350600, '龙文区', '龙文', '117.67139', '24.515656', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350622, 350600, '云霄县', '云霄', '117.34094', '23.950485', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350623, 350600, '漳浦县', '漳浦', '117.61402', '24.117907', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350624, 350600, '诏安县', '诏安', '117.17609', '23.710835', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350625, 350600, '长泰县', '长泰', '117.75591', '24.621475', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350626, 350600, '东山县', '东山', '117.42768', '23.702845', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350627, 350600, '南靖县', '南靖', '117.36546', '24.516424', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350628, 350600, '平和县', '平和', '117.313545', '24.366158', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350629, 350600, '华安县', '华安', '117.53631', '25.001415', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350681, 350600, '龙海市', '龙海', '117.81729', '24.445341', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350700, 350000, '南平市', '南平', '118.17846', '26.635628', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350702, 350700, '延平区', '延平', '118.17892', '26.63608', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350703, 350700, '建阳区', '建阳', '118.120427', '27.331749', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350721, 350700, '顺昌县', '顺昌', '117.80771', '26.79285', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350722, 350700, '浦城县', '浦城', '118.53682', '27.920412', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350723, 350700, '光泽县', '光泽', '117.3379', '27.542803', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350724, 350700, '松溪县', '松溪', '118.78349', '27.525785', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350725, 350700, '政和县', '政和', '118.85866', '27.365398', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350781, 350700, '邵武市', '邵武', '117.49155', '27.337952', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350782, 350700, '武夷山市', '武夷山', '118.0328', '27.751734', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350783, 350700, '建瓯市', '建瓯', '118.32176', '27.03502', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350800, 350000, '龙岩市', '龙岩', '117.02978', '25.091602', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350802, 350800, '新罗区', '新罗', '117.03072', '25.0918', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350803, 350800, '永定区', '永定', '116.73202', '24.72303', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350821, 350800, '长汀县', '长汀', '116.36101', '25.842278', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350823, 350800, '上杭县', '上杭', '116.424774', '25.050018', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350824, 350800, '武平县', '武平', '116.10093', '25.08865', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350825, 350800, '连城县', '连城', '116.75668', '25.708506', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350881, 350800, '漳平市', '漳平', '117.42073', '25.291597', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350900, 350000, '宁德市', '宁德', '119.527084', '26.65924', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350902, 350900, '蕉城区', '蕉城', '119.52722', '26.659252', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350921, 350900, '霞浦县', '霞浦', '120.00521', '26.882069', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350922, 350900, '古田县', '古田', '118.74316', '26.577492', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350923, 350900, '屏南县', '屏南', '118.98754', '26.910826', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350924, 350900, '寿宁县', '寿宁', '119.50674', '27.457798', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350925, 350900, '周宁县', '周宁', '119.33824', '27.103106', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350926, 350900, '柘荣县', '柘荣', '119.898224', '27.236162', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350981, 350900, '福安市', '福安', '119.650795', '27.084246', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (350982, 350900, '福鼎市', '福鼎', '120.219765', '27.318884', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360000, 0, '江西省', '江西', '115.89215', '28.676493', 1, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360100, 360000, '南昌市', '南昌', '115.89215', '28.676493', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360102, 360100, '东湖区', '东湖', '115.88967', '28.682987', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360103, 360100, '西湖区', '西湖', '115.91065', '28.6629', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360104, 360100, '青云谱区', '青云谱', '115.907295', '28.635723', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360111, 360100, '青山湖区', '青山湖', '115.94904', '28.689293', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360112, 360100, '新建区', '新建', '115.81529', '28.6925', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360113, 360100, '红谷滩区', '红谷滩', '115.858393', '28.698314', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360121, 360100, '南昌县', '南昌', '115.94247', '28.543781', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360123, 360100, '安义县', '安义', '115.55311', '28.841333', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360124, 360100, '进贤县', '进贤', '116.26767', '28.36568', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360200, 360000, '景德镇市', '景德镇', '117.21466', '29.29256', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360202, 360200, '昌江区', '昌江', '117.19502', '29.288465', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360203, 360200, '珠山区', '珠山', '117.21481', '29.292812', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360222, 360200, '浮梁县', '浮梁', '117.21761', '29.352251', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360281, 360200, '乐平市', '乐平', '117.12938', '28.967361', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360300, 360000, '萍乡市', '萍乡', '113.85219', '27.622946', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360302, 360300, '安源区', '安源', '113.85504', '27.625826', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360313, 360300, '湘东区', '湘东', '113.7456', '27.639318', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360321, 360300, '莲花县', '莲花', '113.95558', '27.127808', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360322, 360300, '上栗县', '上栗', '113.80052', '27.87704', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360323, 360300, '芦溪县', '芦溪', '114.04121', '27.633633', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360400, 360000, '九江市', '九江', '115.99281', '29.712034', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360402, 360400, '濂溪区', '庐山', '115.99012', '29.676174', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360403, 360400, '浔阳区', '浔阳', '115.99595', '29.72465', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360404, 360400, '柴桑区', '柴桑', '115.91135', '29.60855', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360423, 360400, '武宁县', '武宁', '115.105644', '29.260181', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360424, 360400, '修水县', '修水', '114.573425', '29.032728', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360425, 360400, '永修县', '永修', '115.80905', '29.018211', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360426, 360400, '德安县', '德安', '115.76261', '29.327475', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360428, 360400, '都昌县', '都昌', '116.20512', '29.275105', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360429, 360400, '湖口县', '湖口', '116.244316', '29.7263', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360430, 360400, '彭泽县', '彭泽', '116.55584', '29.898865', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360481, 360400, '瑞昌市', '瑞昌', '115.66908', '29.6766', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360482, 360400, '共青城市', '共青城', '115.81477', '29.24955', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360483, 360400, '庐山市', '共青城', '115.80571', '29.247885', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360500, 360000, '新余市', '新余', '114.93083', '27.810835', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360502, 360500, '渝水区', '渝水', '114.92392', '27.819172', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360521, 360500, '分宜县', '分宜', '114.67526', '27.8113', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360600, 360000, '鹰潭市', '鹰潭', '117.03384', '28.238638', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360602, 360600, '月湖区', '月湖', '117.03411', '28.239077', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360603, 360600, '余江区', '余江', '116.81834', '28.20991', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360681, 360600, '贵溪市', '贵溪', '117.212105', '28.283693', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360700, 360000, '赣州市', '赣州', '114.94028', '25.85097', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360702, 360700, '章贡区', '章贡', '114.93872', '25.851368', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360703, 360700, '南康区', '南康', '114.76535', '25.66144', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360704, 360700, '赣县区', '赣县', '115.01161', '25.86076', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360722, 360700, '信丰县', '信丰', '114.93089', '25.38023', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360723, 360700, '大余县', '大余', '114.36224', '25.395937', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360724, 360700, '上犹县', '上犹', '114.540535', '25.794285', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360725, 360700, '崇义县', '崇义', '114.30735', '25.68791', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360726, 360700, '安远县', '安远', '115.39233', '25.13459', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360728, 360700, '定南县', '定南', '115.03267', '24.774277', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360729, 360700, '全南县', '全南', '114.531586', '24.742651', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360730, 360700, '宁都县', '宁都', '116.01878', '26.472054', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360731, 360700, '于都县', '于都', '115.4112', '25.955032', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360732, 360700, '兴国县', '兴国', '115.3519', '26.330488', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360733, 360700, '会昌县', '会昌', '115.79116', '25.599125', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360734, 360700, '寻乌县', '寻乌', '115.6514', '24.954136', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360735, 360700, '石城县', '石城', '116.34225', '26.326582', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360781, 360700, '瑞金市', '瑞金', '116.03485', '25.875278', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360783, 360700, '龙南市', '龙南', '', '', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360800, 360000, '吉安市', '吉安', '114.986374', '27.111698', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360802, 360800, '吉州区', '吉州', '114.98733', '27.112368', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360803, 360800, '青原区', '青原', '115.016304', '27.105879', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360821, 360800, '吉安县', '吉安', '114.90511', '27.040043', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360822, 360800, '吉水县', '吉水', '115.13457', '27.213446', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360823, 360800, '峡江县', '峡江', '115.31933', '27.580862', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360824, 360800, '新干县', '新干', '115.39929', '27.755758', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360825, 360800, '永丰县', '永丰', '115.43556', '27.321087', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360826, 360800, '泰和县', '泰和', '114.90139', '26.790165', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360827, 360800, '遂川县', '遂川', '114.51689', '26.323706', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360828, 360800, '万安县', '万安', '114.78469', '26.462086', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360829, 360800, '安福县', '安福', '114.61384', '27.382746', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360830, 360800, '永新县', '永新', '114.24253', '26.944721', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360881, 360800, '井冈山市', '井冈山', '114.284424', '26.745918', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360900, 360000, '宜春市', '宜春', '114.391136', '27.8043', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360902, 360900, '袁州区', '袁州', '114.38738', '27.800117', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360921, 360900, '奉新县', '奉新', '115.3899', '28.700672', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360922, 360900, '万载县', '万载', '114.44901', '28.104528', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360923, 360900, '上高县', '上高', '114.932655', '28.234789', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360924, 360900, '宜丰县', '宜丰', '114.787384', '28.388288', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360925, 360900, '靖安县', '靖安', '115.36175', '28.86054', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360926, 360900, '铜鼓县', '铜鼓', '114.37014', '28.520956', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360981, 360900, '丰城市', '丰城', '115.786', '28.191584', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360982, 360900, '樟树市', '樟树', '115.54339', '28.055899', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (360983, 360900, '高安市', '高安', '115.38153', '28.420952', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (361000, 360000, '抚州市', '抚州', '116.35835', '27.98385', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (361002, 361000, '临川区', '临川', '116.361404', '27.981918', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (361003, 361000, '东乡区', '东乡', '116.60334', '28.24771', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (361021, 361000, '南城县', '南城', '116.63945', '27.55531', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (361022, 361000, '黎川县', '黎川', '116.91457', '27.29256', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (361023, 361000, '南丰县', '南丰', '116.533', '27.210133', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (361024, 361000, '崇仁县', '崇仁', '116.05911', '27.760906', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (361025, 361000, '乐安县', '乐安', '115.83843', '27.420101', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (361026, 361000, '宜黄县', '宜黄', '116.22302', '27.546513', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (361027, 361000, '金溪县', '金溪', '116.77875', '27.907387', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (361028, 361000, '资溪县', '资溪', '117.06609', '27.70653', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (361030, 361000, '广昌县', '广昌', '116.32729', '26.838427', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (361100, 360000, '上饶市', '上饶', '117.97118', '28.44442', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (361102, 361100, '信州区', '信州', '117.97052', '28.445377', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (361103, 361100, '广丰区', '广丰', '118.19133', '28.43631', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (361104, 361100, '广信区', '广信', '117.9096', '28.44923', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (361123, 361100, '玉山县', '玉山', '118.24441', '28.67348', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (361124, 361100, '铅山县', '铅山', '117.71191', '28.310892', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (361125, 361100, '横峰县', '横峰', '117.608246', '28.415104', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (361126, 361100, '弋阳县', '弋阳', '117.435005', '28.402391', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (361127, 361100, '余干县', '余干', '116.69107', '28.69173', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (361128, 361100, '鄱阳县', '鄱阳', '116.673744', '28.993374', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (361129, 361100, '万年县', '万年', '117.07015', '28.692589', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (361130, 361100, '婺源县', '婺源', '117.86219', '29.254015', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (361181, 361100, '德兴市', '德兴', '117.578735', '28.945034', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370000, 0, '山东省', '山东', '117.00092', '36.675808', 1, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370100, 370000, '济南市', '济南', '117.00092', '36.675808', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370102, 370100, '历下区', '历下', '117.03862', '36.66417', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370103, 370100, '市中区', '市中', '116.99898', '36.657352', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370104, 370100, '槐荫区', '槐荫', '116.94792', '36.668205', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370105, 370100, '天桥区', '天桥', '116.996086', '36.693375', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370112, 370100, '历城区', '历城', '117.06374', '36.681744', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370113, 370100, '长清区', '长清', '116.74588', '36.56105', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370114, 370100, '章丘区', '章丘', '117.52627', '36.68124', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370115, 370100, '济阳区', '济阳', '117.17333', '36.97847', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370116, 370100, '莱芜区', '莱芜', '117.65992', '36.20317', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370117, 370100, '钢城区', '钢城', '117.81107', '36.05866', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370124, 370100, '平阴县', '平阴', '116.455055', '36.286922', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370126, 370100, '商河县', '商河', '117.15637', '37.310543', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370200, 370000, '青岛市', '青岛', '120.35517', '36.08298', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370202, 370200, '市南区', '市南', '120.395966', '36.070892', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370203, 370200, '市北区', '市北', '120.35503', '36.08382', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370211, 370200, '黄岛区', '黄岛', '119.99552', '35.875137', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370212, 370200, '崂山区', '崂山', '120.46739', '36.10257', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370213, 370200, '李沧区', '李沧', '120.421234', '36.160023', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370214, 370200, '城阳区', '城阳', '120.38914', '36.30683', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370215, 370200, '即墨区', '即墨', '120.44715', '36.38932', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370281, 370200, '胶州市', '胶州', '120.0062', '36.285877', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370283, 370200, '平度市', '平度', '119.959015', '36.78883', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370285, 370200, '莱西市', '莱西', '120.52622', '36.86509', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370300, 370000, '淄博市', '淄博', '118.047646', '36.814938', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370302, 370300, '淄川区', '淄川', '117.9677', '36.64727', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370303, 370300, '张店区', '张店', '118.05352', '36.80705', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370304, 370300, '博山区', '博山', '117.85823', '36.497566', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370305, 370300, '临淄区', '临淄', '118.306015', '36.816658', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370306, 370300, '周村区', '周村', '117.851036', '36.8037', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370321, 370300, '桓台县', '桓台', '118.101555', '36.959774', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370322, 370300, '高青县', '高青', '117.82984', '37.169582', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370323, 370300, '沂源县', '沂源', '118.16616', '36.186283', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370400, 370000, '枣庄市', '枣庄', '117.55796', '34.856422', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370402, 370400, '市中区', '市中', '117.55728', '34.85665', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370403, 370400, '薛城区', '薛城', '117.26529', '34.79789', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370404, 370400, '峄城区', '峄城', '117.58632', '34.76771', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370405, 370400, '台儿庄区', '台儿庄', '117.73475', '34.564816', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370406, 370400, '山亭区', '山亭', '117.45897', '35.096077', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370481, 370400, '滕州市', '滕州', '117.1621', '35.088497', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370500, 370000, '东营市', '东营', '118.66471', '37.434563', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370502, 370500, '东营区', '东营', '118.507545', '37.461567', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370503, 370500, '河口区', '河口', '118.52961', '37.886017', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370505, 370500, '垦利区', '垦利', '118.54768', '37.58748', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370522, 370500, '利津县', '利津', '118.248856', '37.493366', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370523, 370500, '广饶县', '广饶', '118.407524', '37.05161', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370600, 370000, '烟台市', '烟台', '121.39138', '37.539295', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370602, 370600, '芝罘区', '芝罘', '121.38588', '37.540924', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370611, 370600, '福山区', '福山', '121.26474', '37.496876', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370612, 370600, '牟平区', '牟平', '121.60151', '37.388355', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370613, 370600, '莱山区', '莱山', '121.44887', '37.47355', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370614, 370600, '蓬莱区', '蓬莱', '', '', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370681, 370600, '龙口市', '龙口', '120.52833', '37.648445', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370682, 370600, '莱阳市', '莱阳', '120.71115', '36.977036', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370683, 370600, '莱州市', '莱州', '119.94214', '37.182724', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370685, 370600, '招远市', '招远', '120.403145', '37.364918', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370686, 370600, '栖霞市', '栖霞', '120.8341', '37.305855', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370687, 370600, '海阳市', '海阳', '121.16839', '36.78066', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370700, 370000, '潍坊市', '潍坊', '119.10708', '36.70925', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370702, 370700, '潍城区', '潍城', '119.10378', '36.71006', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370703, 370700, '寒亭区', '寒亭', '119.20786', '36.772102', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370704, 370700, '坊子区', '坊子', '119.16633', '36.654617', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370705, 370700, '奎文区', '奎文', '119.13736', '36.709496', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370724, 370700, '临朐县', '临朐', '118.53988', '36.516373', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370725, 370700, '昌乐县', '昌乐', '118.84', '36.703255', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370781, 370700, '青州市', '青州', '118.484695', '36.697857', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370782, 370700, '诸城市', '诸城', '119.40318', '35.997093', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370783, 370700, '寿光市', '寿光', '118.73645', '36.874413', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370784, 370700, '安丘市', '安丘', '119.20689', '36.427418', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370785, 370700, '高密市', '高密', '119.757034', '36.37754', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370786, 370700, '昌邑市', '昌邑', '119.3945', '36.85494', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370800, 370000, '济宁市', '济宁', '116.58724', '35.415394', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370811, 370800, '任城区', '任城', '116.63102', '35.431835', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370812, 370800, '兖州区', '兖州', '116.7857', '35.5526', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370826, 370800, '微山县', '微山', '117.12861', '34.809525', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370827, 370800, '鱼台县', '鱼台', '116.650024', '34.997707', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370828, 370800, '金乡县', '金乡', '116.31036', '35.06977', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370829, 370800, '嘉祥县', '嘉祥', '116.34289', '35.398098', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370830, 370800, '汶上县', '汶上', '116.487144', '35.721745', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370831, 370800, '泗水县', '泗水', '117.273605', '35.653217', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370832, 370800, '梁山县', '梁山', '116.08963', '35.80184', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370881, 370800, '曲阜市', '曲阜', '116.99188', '35.59279', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370883, 370800, '邹城市', '邹城', '116.96673', '35.40526', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370900, 370000, '泰安市', '泰安', '117.12907', '36.19497', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370902, 370900, '泰山区', '泰山', '117.12998', '36.189312', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370911, 370900, '岱岳区', '岱岳', '117.0418', '36.18752', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370921, 370900, '宁阳县', '宁阳', '116.79929', '35.76754', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370923, 370900, '东平县', '东平', '116.46105', '35.930466', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370982, 370900, '新泰市', '新泰', '117.76609', '35.910385', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (370983, 370900, '肥城市', '肥城', '116.7637', '36.1856', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371000, 370000, '威海市', '威海', '122.116394', '37.50969', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371002, 371000, '环翠区', '环翠', '122.11619', '37.510754', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371003, 371000, '文登区', '文登', '122.0581', '37.19397', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371082, 371000, '荣成市', '荣成', '122.4229', '37.160133', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371083, 371000, '乳山市', '乳山', '121.53635', '36.91962', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371100, 370000, '日照市', '日照', '119.461205', '35.42859', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371102, 371100, '东港区', '东港', '119.4577', '35.42615', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371103, 371100, '岚山区', '岚山', '119.31584', '35.119793', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371121, 371100, '五莲县', '五莲', '119.20674', '35.751938', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371122, 371100, '莒县', '莒县', '118.832855', '35.588116', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371300, 370000, '临沂市', '临沂', '118.32645', '35.06528', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371302, 371300, '兰山区', '兰山', '118.32767', '35.06163', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371311, 371300, '罗庄区', '罗庄', '118.2848', '34.997204', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371312, 371300, '河东区', '河东', '118.39829', '35.085003', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371321, 371300, '沂南县', '沂南', '118.4554', '35.547', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371322, 371300, '郯城县', '郯城', '118.342964', '34.614742', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371323, 371300, '沂水县', '沂水', '118.634544', '35.78703', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371324, 371300, '兰陵县', '苍山', '118.32645', '35.06528', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371325, 371300, '费县', '费县', '117.96887', '35.269173', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371326, 371300, '平邑县', '平邑', '117.63188', '35.51152', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371327, 371300, '莒南县', '莒南', '118.838326', '35.17591', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371328, 371300, '蒙阴县', '蒙阴', '117.94327', '35.712437', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371329, 371300, '临沭县', '临沭', '118.64838', '34.91706', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371400, 370000, '德州市', '德州', '116.30743', '37.453968', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371402, 371400, '德城区', '德城', '116.307076', '37.453922', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371403, 371400, '陵城区', '陵城', '116.57634', '37.33566', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371422, 371400, '宁津县', '宁津', '116.79372', '37.64962', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371423, 371400, '庆云县', '庆云', '117.39051', '37.777725', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371424, 371400, '临邑县', '临邑', '116.86703', '37.192043', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371425, 371400, '齐河县', '齐河', '116.75839', '36.795498', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371426, 371400, '平原县', '平原', '116.43391', '37.164467', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371427, 371400, '夏津县', '夏津', '116.003815', '36.9505', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371428, 371400, '武城县', '武城', '116.07863', '37.209526', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371481, 371400, '乐陵市', '乐陵', '117.21666', '37.729115', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371482, 371400, '禹城市', '禹城', '116.642555', '36.934486', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371500, 370000, '聊城市', '聊城', '115.98037', '36.456013', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371502, 371500, '东昌府区', '东昌府', '115.98003', '36.45606', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371503, 371500, '茌平区', '茌平', '116.25522', '36.58068', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371521, 371500, '阳谷县', '阳谷', '115.78429', '36.11371', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371522, 371500, '莘县', '莘县', '115.66729', '36.2376', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371524, 371500, '东阿县', '东阿', '116.248856', '36.336002', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371525, 371500, '冠县', '冠县', '115.44481', '36.483753', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371526, 371500, '高唐县', '高唐', '116.22966', '36.859756', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371581, 371500, '临清市', '临清', '115.71346', '36.842598', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371600, 370000, '滨州市', '滨州', '118.016975', '37.38354', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371602, 371600, '滨城区', '滨城', '118.02015', '37.384842', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371603, 371600, '沾化区', '沾化', '118.09882', '37.70058', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371621, 371600, '惠民县', '惠民', '117.50894', '37.483875', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371622, 371600, '阳信县', '阳信', '117.58133', '37.64049', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371623, 371600, '无棣县', '无棣', '117.616325', '37.74085', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371625, 371600, '博兴县', '博兴', '118.12309', '37.147003', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371681, 371600, '邹平市', '邹平', '117.74309', '36.86299', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371700, 370000, '菏泽市', '菏泽', '115.46938', '35.246532', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371702, 371700, '牡丹区', '牡丹', '115.47095', '35.24311', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371703, 371700, '定陶区', '定陶', '115.57298', '35.07095', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371721, 371700, '曹县', '曹县', '115.549484', '34.823254', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371722, 371700, '单县', '单县', '116.08262', '34.79085', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371723, 371700, '成武县', '成武', '115.89735', '34.947365', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371724, 371700, '巨野县', '巨野', '116.08934', '35.391', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371725, 371700, '郓城县', '郓城', '115.93885', '35.594772', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371726, 371700, '鄄城县', '鄄城', '115.51434', '35.560257', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (371728, 371700, '东明县', '东明', '115.09841', '35.28964', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410000, 0, '河南省', '河南', '113.66541', '34.757977', 1, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410100, 410000, '郑州市', '郑州', '113.66541', '34.757977', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410102, 410100, '中原区', '中原', '113.61157', '34.748287', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410103, 410100, '二七区', '二七', '113.645424', '34.730934', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410104, 410100, '管城回族区', '管城回族', '113.68531', '34.746452', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410105, 410100, '金水区', '金水', '113.686035', '34.775837', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410106, 410100, '上街区', '上街', '113.29828', '34.80869', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410108, 410100, '惠济区', '惠济', '113.61836', '34.82859', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410122, 410100, '中牟县', '中牟', '114.02252', '34.721977', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410181, 410100, '巩义市', '巩义', '112.98283', '34.75218', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410182, 410100, '荥阳市', '荥阳', '113.391525', '34.789078', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410183, 410100, '新密市', '新密', '113.380615', '34.537846', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410184, 410100, '新郑市', '新郑', '113.73967', '34.39422', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410185, 410100, '登封市', '登封', '113.037766', '34.459938', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410200, 410000, '开封市', '开封', '114.341446', '34.79705', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410202, 410200, '龙亭区', '龙亭', '114.35335', '34.79983', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410203, 410200, '顺河回族区', '顺河回族', '114.364876', '34.80046', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410204, 410200, '鼓楼区', '鼓楼', '114.3485', '34.79238', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410205, 410200, '禹王台区', '禹王台', '114.35024', '34.779728', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410212, 410200, '祥符区', '祥符', '114.44136', '34.757', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410221, 410200, '杞县', '杞县', '114.77047', '34.554585', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410222, 410200, '通许县', '通许', '114.467735', '34.477303', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410223, 410200, '尉氏县', '尉氏', '114.193924', '34.412254', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410225, 410200, '兰考县', '兰考', '114.82057', '34.8299', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410300, 410000, '洛阳市', '洛阳', '112.43447', '34.66304', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410302, 410300, '老城区', '老城', '112.477295', '34.682945', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410303, 410300, '西工区', '西工', '112.44323', '34.667847', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410304, 410300, '瀍河回族区', '瀍河回族', '112.49162', '34.68474', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410305, 410300, '涧西区', '涧西', '112.39925', '34.65425', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410306, 410300, '吉利区', '吉利', '112.58479', '34.899094', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410311, 410300, '洛龙区', '洛龙', '112.4647', '34.6196', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410322, 410300, '孟津县', '孟津', '112.44389', '34.826485', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410323, 410300, '新安县', '新安', '112.1414', '34.72868', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410324, 410300, '栾川县', '栾川', '111.618385', '33.783195', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410325, 410300, '嵩县', '嵩县', '112.08777', '34.13156', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410326, 410300, '汝阳县', '汝阳', '112.473785', '34.15323', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410327, 410300, '宜阳县', '宜阳', '112.17999', '34.51648', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410328, 410300, '洛宁县', '洛宁', '111.655396', '34.38718', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410329, 410300, '伊川县', '伊川', '112.42938', '34.423416', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410381, 410300, '偃师市', '偃师', '112.78774', '34.72304', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410400, 410000, '平顶山市', '平顶山', '113.30772', '33.73524', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410402, 410400, '新华区', '新华', '113.299065', '33.73758', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410403, 410400, '卫东区', '卫东', '113.310326', '33.739285', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410404, 410400, '石龙区', '石龙', '112.889885', '33.90154', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410411, 410400, '湛河区', '湛河', '113.32087', '33.72568', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410421, 410400, '宝丰县', '宝丰', '113.06681', '33.86636', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410422, 410400, '叶县', '叶县', '113.3583', '33.62125', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410423, 410400, '鲁山县', '鲁山', '112.9067', '33.740326', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410425, 410400, '郏县', '郏县', '113.22045', '33.971992', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410481, 410400, '舞钢市', '舞钢', '113.52625', '33.302082', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410482, 410400, '汝州市', '汝州', '112.84534', '34.167408', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410500, 410000, '安阳市', '安阳', '114.352486', '36.103443', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410502, 410500, '文峰区', '文峰', '114.35256', '36.098103', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410503, 410500, '北关区', '北关', '114.352646', '36.10978', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410505, 410500, '殷都区', '殷都', '114.300095', '36.108974', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410506, 410500, '龙安区', '龙安', '114.323524', '36.09557', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410522, 410500, '安阳县', '安阳', '114.1302', '36.130585', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410523, 410500, '汤阴县', '汤阴', '114.36236', '35.922348', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410526, 410500, '滑县', '滑县', '114.524', '35.574627', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410527, 410500, '内黄县', '内黄', '114.90458', '35.9537', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410581, 410500, '林州市', '林州', '113.82377', '36.063404', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410600, 410000, '鹤壁市', '鹤壁', '114.29544', '35.748238', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410602, 410600, '鹤山区', '鹤山', '114.16655', '35.936127', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410603, 410600, '山城区', '山城', '114.184204', '35.896057', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410611, 410600, '淇滨区', '淇滨', '114.293915', '35.748383', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410621, 410600, '浚县', '浚县', '114.55016', '35.671284', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410622, 410600, '淇县', '淇县', '114.20038', '35.609478', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410700, 410000, '新乡市', '新乡', '113.88399', '35.302616', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410702, 410700, '红旗区', '红旗', '113.87816', '35.302685', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410703, 410700, '卫滨区', '卫滨', '113.866066', '35.304905', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410704, 410700, '凤泉区', '凤泉', '113.906715', '35.379856', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410711, 410700, '牧野区', '牧野', '113.89716', '35.312973', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410721, 410700, '新乡县', '新乡', '113.80618', '35.19002', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410724, 410700, '获嘉县', '获嘉', '113.65725', '35.261684', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410725, 410700, '原阳县', '原阳', '113.965965', '35.054', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410726, 410700, '延津县', '延津', '114.20098', '35.149513', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410727, 410700, '封丘县', '封丘', '114.42341', '35.04057', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410781, 410700, '卫辉市', '卫辉', '114.06586', '35.404297', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410782, 410700, '辉县市', '辉县', '113.80252', '35.46132', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410783, 410700, '长垣市', '长垣', '114.66886', '35.20049', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410800, 410000, '焦作市', '焦作', '113.238266', '35.23904', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410802, 410800, '解放区', '解放', '113.22613', '35.241352', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410803, 410800, '中站区', '中站', '113.17548', '35.236145', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410804, 410800, '马村区', '马村', '113.3217', '35.265453', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410811, 410800, '山阳区', '山阳', '113.26766', '35.21476', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410821, 410800, '修武县', '修武', '113.447464', '35.229923', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410822, 410800, '博爱县', '博爱', '113.06931', '35.17035', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410823, 410800, '武陟县', '武陟', '113.40833', '35.09885', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410825, 410800, '温县', '温县', '113.07912', '34.941235', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410882, 410800, '沁阳市', '沁阳', '112.93454', '35.08901', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410883, 410800, '孟州市', '孟州', '112.78708', '34.90963', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410900, 410000, '濮阳市', '濮阳', '115.0413', '35.768234', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410902, 410900, '华龙区', '华龙', '115.03184', '35.76047', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410922, 410900, '清丰县', '清丰', '115.107285', '35.902412', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410923, 410900, '南乐县', '南乐', '115.20434', '36.075203', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410926, 410900, '范县', '范县', '115.50421', '35.85198', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410927, 410900, '台前县', '台前', '115.85568', '35.996475', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (410928, 410900, '濮阳县', '濮阳', '115.02384', '35.71035', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411000, 410000, '许昌市', '许昌', '113.826065', '34.022957', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411002, 411000, '魏都区', '魏都', '113.82831', '34.02711', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411003, 411000, '建安区', '建安', '', '', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411024, 411000, '鄢陵县', '鄢陵', '114.18851', '34.100502', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411025, 411000, '襄城县', '襄城', '113.493164', '33.85594', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411081, 411000, '禹州市', '禹州', '113.47131', '34.154404', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411082, 411000, '长葛市', '长葛', '113.76891', '34.219257', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411100, 410000, '漯河市', '漯河', '114.026405', '33.575855', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411102, 411100, '源汇区', '源汇', '114.017944', '33.56544', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411103, 411100, '郾城区', '郾城', '114.016815', '33.588898', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411104, 411100, '召陵区', '召陵', '114.05169', '33.567554', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411121, 411100, '舞阳县', '舞阳', '113.610565', '33.43628', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411122, 411100, '临颍县', '临颍', '113.93889', '33.80609', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411200, 410000, '三门峡市', '三门峡', '111.1941', '34.777336', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411202, 411200, '湖滨区', '湖滨', '111.19487', '34.77812', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411203, 411200, '陕州区', '陕州', '111.10338', '34.72054', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411221, 411200, '渑池县', '渑池', '111.76299', '34.76349', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411224, 411200, '卢氏县', '卢氏', '111.05265', '34.053993', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411281, 411200, '义马市', '义马', '111.869415', '34.74687', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411282, 411200, '灵宝市', '灵宝', '110.88577', '34.521263', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411300, 410000, '南阳市', '南阳', '112.54092', '32.99908', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411302, 411300, '宛城区', '宛城', '112.54459', '32.994858', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411303, 411300, '卧龙区', '卧龙', '112.528786', '32.989876', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411321, 411300, '南召县', '南召', '112.435585', '33.488617', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411322, 411300, '方城县', '方城', '113.01093', '33.25514', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411323, 411300, '西峡县', '西峡', '111.48577', '33.302982', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411324, 411300, '镇平县', '镇平', '112.23272', '33.03665', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411325, 411300, '内乡县', '内乡', '111.8438', '33.046356', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411326, 411300, '淅川县', '淅川', '111.48903', '33.136105', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411327, 411300, '社旗县', '社旗县', '112.93828', '33.056126', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411328, 411300, '唐河县', '唐河', '112.83849', '32.687893', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411329, 411300, '新野县', '新野', '112.36562', '32.524006', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411330, 411300, '桐柏县', '桐柏', '113.40606', '32.367153', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411381, 411300, '邓州市', '邓州', '112.09271', '32.68164', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411400, 410000, '商丘市', '商丘', '115.6505', '34.437054', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411402, 411400, '梁园区', '梁园', '115.65459', '34.436554', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411403, 411400, '睢阳区', '睢阳', '115.65382', '34.390537', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411421, 411400, '民权县', '民权', '115.14815', '34.648457', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411422, 411400, '睢县', '睢县', '115.07011', '34.428432', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411423, 411400, '宁陵县', '宁陵', '115.32005', '34.4493', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411424, 411400, '柘城县', '柘城', '115.307434', '34.075275', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411425, 411400, '虞城县', '虞城', '115.86381', '34.399635', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411426, 411400, '夏邑县', '夏邑', '116.13989', '34.240894', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411481, 411400, '永城市', '永城', '116.44967', '33.931316', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411500, 410000, '信阳市', '信阳', '114.07503', '32.123276', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411502, 411500, '浉河区', '浉河', '114.07503', '32.123276', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411503, 411500, '平桥区', '平桥', '114.12603', '32.098396', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411521, 411500, '罗山县', '罗山', '114.53342', '32.203205', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411522, 411500, '光山县', '光山', '114.90358', '32.0104', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411523, 411500, '新县', '新县', '114.87705', '31.63515', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411524, 411500, '商城县', '商城', '115.406296', '31.799982', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411525, 411500, '固始县', '固始', '115.66733', '32.183075', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411526, 411500, '潢川县', '潢川', '115.050125', '32.134026', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411527, 411500, '淮滨县', '淮滨', '115.41545', '32.45264', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411528, 411500, '息县', '息县', '114.740715', '32.344746', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411600, 410000, '周口市', '周口', '114.64965', '33.620358', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411602, 411600, '川汇区', '川汇', '114.65214', '33.614838', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411603, 411600, '淮阳区', '淮阳', '114.88614', '33.7315', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411621, 411600, '扶沟县', '扶沟', '114.392006', '34.05406', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411622, 411600, '西华县', '西华', '114.53007', '33.784378', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411623, 411600, '商水县', '商水', '114.60927', '33.543846', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411624, 411600, '沈丘县', '沈丘', '115.07838', '33.395515', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411625, 411600, '郸城县', '郸城', '115.189', '33.643852', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411627, 411600, '太康县', '太康', '114.853836', '34.06531', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411628, 411600, '鹿邑县', '鹿邑', '115.48639', '33.86107', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411681, 411600, '项城市', '项城', '114.89952', '33.443085', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411700, 410000, '驻马店市', '驻马店', '114.024734', '32.980167', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411702, 411700, '驿城区', '驿城', '114.02915', '32.97756', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411721, 411700, '西平县', '西平', '114.02686', '33.382317', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411722, 411700, '上蔡县', '上蔡', '114.26689', '33.264717', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411723, 411700, '平舆县', '平舆', '114.63711', '32.955627', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411724, 411700, '正阳县', '正阳', '114.38948', '32.601826', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411725, 411700, '确山县', '确山', '114.02668', '32.801537', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411726, 411700, '泌阳县', '泌阳', '113.32605', '32.72513', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411727, 411700, '汝南县', '汝南', '114.3595', '33.004536', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411728, 411700, '遂平县', '遂平', '114.00371', '33.14698', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (411729, 411700, '新蔡县', '新蔡', '114.97524', '32.749947', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (419000, 410000, '省直辖县', '', '', '', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (419001, 419000, '济源市', '济源', '112.60273', '35.06707', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420000, 0, '湖北省', '湖北', '114.29857', '30.584354', 1, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420100, 420000, '武汉市', '武汉', '114.29857', '30.584354', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420102, 420100, '江岸区', '江岸', '114.30304', '30.594912', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420103, 420100, '江汉区', '江汉', '114.28311', '30.578772', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420104, 420100, '硚口区', '硚口', '114.264565', '30.57061', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420105, 420100, '汉阳区', '汉阳', '114.26581', '30.549326', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420106, 420100, '武昌区', '武昌', '114.30734', '30.546535', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420107, 420100, '青山区', '青山', '114.39707', '30.634214', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420111, 420100, '洪山区', '洪山', '114.40072', '30.50426', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420112, 420100, '东西湖区', '东西湖', '114.14249', '30.622467', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420113, 420100, '汉南区', '汉南', '114.08124', '30.309637', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420114, 420100, '蔡甸区', '蔡甸', '114.02934', '30.582186', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420115, 420100, '江夏区', '江夏', '114.31396', '30.349045', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420116, 420100, '黄陂区', '黄陂', '114.37402', '30.874155', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420117, 420100, '新洲区', '新洲', '114.80211', '30.84215', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420200, 420000, '黄石市', '黄石', '115.07705', '30.220074', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420202, 420200, '黄石港区', '黄石港', '115.090164', '30.212086', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420203, 420200, '西塞山区', '西塞山', '115.09335', '30.205364', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420204, 420200, '下陆区', '下陆', '114.97575', '30.177845', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420205, 420200, '铁山区', '铁山', '114.90137', '30.20601', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420222, 420200, '阳新县', '阳新', '115.21288', '29.841572', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420281, 420200, '大冶市', '大冶', '114.97484', '30.098804', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420300, 420000, '十堰市', '十堰', '110.78792', '32.646908', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420302, 420300, '茅箭区', '茅箭', '110.78621', '32.644463', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420303, 420300, '张湾区', '张湾', '110.77236', '32.652515', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420304, 420300, '郧阳区', '郧阳', '110.81197', '32.83488', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420322, 420300, '郧西县', '郧西', '110.426476', '32.99146', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420323, 420300, '竹山县', '竹山', '110.2296', '32.22586', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420324, 420300, '竹溪县', '竹溪', '109.71719', '32.315342', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420325, 420300, '房县', '房县', '110.74197', '32.055', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420381, 420300, '丹江口市', '丹江口', '111.513794', '32.538837', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420500, 420000, '宜昌市', '宜昌', '111.29084', '30.702637', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420502, 420500, '西陵区', '西陵', '111.29547', '30.702477', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420503, 420500, '伍家岗区', '伍家岗', '111.30721', '30.679052', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420504, 420500, '点军区', '点军', '111.268166', '30.692322', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420505, 420500, '猇亭区', '猇亭', '111.29084', '30.702637', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420506, 420500, '夷陵区', '夷陵', '111.326744', '30.770199', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420525, 420500, '远安县', '远安', '111.64331', '31.059626', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420526, 420500, '兴山县', '兴山', '110.7545', '31.34795', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420527, 420500, '秭归县', '秭归', '110.97678', '30.823908', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420528, 420500, '长阳土家族自治县', '长阳', '111.19848', '30.466534', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420529, 420500, '五峰土家族自治县', '五峰', '110.674934', '30.199251', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420581, 420500, '宜都市', '宜都', '111.45437', '30.387234', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420582, 420500, '当阳市', '当阳', '111.79342', '30.824492', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420583, 420500, '枝江市', '枝江', '111.7518', '30.425364', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420600, 420000, '襄阳市', '襄阳', '112.14415', '32.042427', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420602, 420600, '襄城区', '襄城', '112.15033', '32.015087', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420606, 420600, '樊城区', '樊城', '112.13957', '32.05859', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420607, 420600, '襄州区', '襄州', '112.19738', '32.085518', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420624, 420600, '南漳县', '南漳', '111.84442', '31.77692', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420625, 420600, '谷城县', '谷城', '111.640144', '32.262676', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420626, 420600, '保康县', '保康', '111.26224', '31.873507', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420682, 420600, '老河口市', '老河口', '111.675735', '32.385437', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420683, 420600, '枣阳市', '枣阳', '112.76527', '32.12308', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420684, 420600, '宜城市', '宜城', '112.261444', '31.709204', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420700, 420000, '鄂州市', '鄂州', '114.890594', '30.396536', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420702, 420700, '梁子湖区', '梁子湖', '114.68197', '30.09819', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420703, 420700, '华容区', '华容', '114.74148', '30.534468', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420704, 420700, '鄂城区', '鄂城', '114.890015', '30.39669', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420800, 420000, '荆门市', '荆门', '112.204254', '31.03542', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420802, 420800, '东宝区', '东宝', '112.2048', '31.03346', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420804, 420800, '掇刀区', '掇刀', '112.19841', '30.980799', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420822, 420800, '沙洋县', '沙洋', '112.595215', '30.70359', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420881, 420800, '钟祥市', '钟祥', '112.587265', '31.165573', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420882, 420800, '京山市', '京山', '113.11953', '31.01848', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420900, 420000, '孝感市', '孝感', '113.92666', '30.926422', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420902, 420900, '孝南区', '孝南', '113.92585', '30.925966', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420921, 420900, '孝昌县', '孝昌', '113.98896', '31.251617', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420922, 420900, '大悟县', '大悟', '114.12625', '31.565483', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420923, 420900, '云梦县', '云梦', '113.75062', '31.02169', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420981, 420900, '应城市', '应城', '113.573845', '30.939037', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420982, 420900, '安陆市', '安陆', '113.6904', '31.26174', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (420984, 420900, '汉川市', '汉川', '113.835304', '30.652164', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (421000, 420000, '荆州市', '荆州', '112.23813', '30.326857', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (421002, 421000, '沙市区', '沙市', '112.25743', '30.315895', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (421003, 421000, '荆州区', '荆州', '112.19535', '30.350674', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (421022, 421000, '公安县', '公安', '112.23018', '30.059065', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (421023, 421000, '监利县', '监利', '112.90434', '29.82008', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (421024, 421000, '江陵县', '江陵', '112.41735', '30.033918', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (421081, 421000, '石首市', '石首', '112.40887', '29.716436', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (421083, 421000, '洪湖市', '洪湖', '113.47031', '29.81297', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (421087, 421000, '松滋市', '松滋', '111.77818', '30.176037', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (421100, 420000, '黄冈市', '黄冈', '114.879364', '30.447712', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (421102, 421100, '黄州区', '黄州', '114.87894', '30.447435', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (421121, 421100, '团风县', '团风', '114.87203', '30.63569', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (421122, 421100, '红安县', '红安', '114.6151', '31.284777', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (421123, 421100, '罗田县', '罗田', '115.39899', '30.78168', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (421124, 421100, '英山县', '英山', '115.67753', '30.735794', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (421125, 421100, '浠水县', '浠水', '115.26344', '30.454838', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (421126, 421100, '蕲春县', '蕲春', '115.43397', '30.234926', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (421127, 421100, '黄梅县', '黄梅', '115.94255', '30.075113', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (421181, 421100, '麻城市', '麻城', '115.02541', '31.177906', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (421182, 421100, '武穴市', '武穴', '115.56242', '29.849342', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (421200, 420000, '咸宁市', '咸宁', '114.328964', '29.832798', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (421202, 421200, '咸安区', '咸安', '114.33389', '29.824717', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (421221, 421200, '嘉鱼县', '嘉鱼', '113.92155', '29.973364', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (421222, 421200, '通城县', '通城', '113.81413', '29.246077', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (421223, 421200, '崇阳县', '崇阳', '114.04996', '29.54101', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (421224, 421200, '通山县', '通山', '114.493164', '29.604456', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (421281, 421200, '赤壁市', '赤壁', '113.88366', '29.716879', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (421300, 420000, '随州市', '随州', '113.37377', '31.717497', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (421303, 421300, '曾都区', '曾都', '113.3712', '31.71615', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (421321, 421300, '随县', '随县', '113.301384', '31.854246', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (421381, 421300, '广水市', '广水', '113.8266', '31.617731', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (422800, 420000, '恩施土家族苗族自治州', '恩施', '109.48699', '30.283113', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (422801, 422800, '恩施市', '恩施', '109.48676', '30.282406', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (422802, 422800, '利川市', '利川', '108.94349', '30.294247', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (422822, 422800, '建始县', '建始', '109.72382', '30.601631', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (422823, 422800, '巴东县', '巴东', '110.33666', '31.041403', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (422825, 422800, '宣恩县', '宣恩', '109.48282', '29.98867', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (422826, 422800, '咸丰县', '咸丰', '109.15041', '29.678967', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (422827, 422800, '来凤县', '来凤', '109.408325', '29.506945', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (422828, 422800, '鹤峰县', '鹤峰', '110.0337', '29.887299', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (429000, 420000, '省直辖县', '', '', '', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (429004, 429000, '仙桃市', '仙桃', '113.45397', '30.364952', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (429005, 429000, '潜江市', '潜江', '112.896866', '30.421215', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (429006, 429000, '天门市', '天门', '113.16586', '30.65306', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (429021, 429000, '神农架林区', '神农架', '114.29857', '30.584354', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430000, 0, '湖南省', '湖南', '112.98228', '28.19409', 1, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430100, 430000, '长沙市', '长沙', '112.98228', '28.19409', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430102, 430100, '芙蓉区', '芙蓉', '112.98809', '28.193106', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430103, 430100, '天心区', '天心', '112.97307', '28.192375', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430104, 430100, '岳麓区', '岳麓', '112.91159', '28.213043', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430105, 430100, '开福区', '开福', '112.98553', '28.201336', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430111, 430100, '雨花区', '雨花', '113.016335', '28.109938', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430112, 430100, '望城区', '望城', '112.8179', '28.36121', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430121, 430100, '长沙县', '长沙', '113.0801', '28.237888', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430181, 430100, '浏阳市', '浏阳', '113.6333', '28.141111', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430182, 430100, '宁乡市', '宁乡', '112.55183', '28.27741', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430200, 430000, '株洲市', '株洲', '113.15173', '27.835806', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430202, 430200, '荷塘区', '荷塘', '113.162544', '27.833036', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430203, 430200, '芦淞区', '芦淞', '113.15517', '27.827246', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430204, 430200, '石峰区', '石峰', '113.11295', '27.871944', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430211, 430200, '天元区', '天元', '113.13625', '27.826908', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430212, 430200, '渌口区', '渌口', '113.14398', '27.69938', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430223, 430200, '攸县', '攸县', '113.34577', '27.00007', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430224, 430200, '茶陵县', '茶陵', '113.54651', '26.789534', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430225, 430200, '炎陵县', '炎陵', '113.776886', '26.489458', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430281, 430200, '醴陵市', '醴陵', '113.50716', '27.657873', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430300, 430000, '湘潭市', '湘潭', '112.94405', '27.82973', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430302, 430300, '雨湖区', '雨湖', '112.907425', '27.86077', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430304, 430300, '岳塘区', '岳塘', '112.927704', '27.828854', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430321, 430300, '湘潭县', '湘潭', '112.95283', '27.7786', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430381, 430300, '湘乡市', '湘乡', '112.525215', '27.734919', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430382, 430300, '韶山市', '韶山', '112.52848', '27.922682', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430400, 430000, '衡阳市', '衡阳', '112.6077', '26.900358', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430405, 430400, '珠晖区', '珠晖', '112.62633', '26.891064', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430406, 430400, '雁峰区', '雁峰', '112.61224', '26.893694', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430407, 430400, '石鼓区', '石鼓', '112.607635', '26.903908', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430408, 430400, '蒸湘区', '蒸湘', '112.57061', '26.89087', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430412, 430400, '南岳区', '南岳', '112.734146', '27.240536', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430421, 430400, '衡阳县', '衡阳', '112.37965', '26.962387', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430422, 430400, '衡南县', '衡南', '112.67746', '26.739973', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430423, 430400, '衡山县', '衡山', '112.86971', '27.234808', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430424, 430400, '衡东县', '衡东', '112.95041', '27.08353', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430426, 430400, '祁东县', '祁东', '112.11119', '26.78711', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430481, 430400, '耒阳市', '耒阳', '112.84721', '26.414162', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430482, 430400, '常宁市', '常宁', '112.39682', '26.406773', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430500, 430000, '邵阳市', '邵阳', '111.46923', '27.237843', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430502, 430500, '双清区', '双清', '111.47976', '27.240002', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430503, 430500, '大祥区', '大祥', '111.46297', '27.233593', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430511, 430500, '北塔区', '北塔', '111.45232', '27.245687', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430522, 430500, '新邵县', '新邵', '111.45976', '27.311428', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430523, 430500, '邵阳县', '邵阳', '111.2757', '26.989714', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430524, 430500, '隆回县', '隆回', '111.03879', '27.116001', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430525, 430500, '洞口县', '洞口', '110.57921', '27.062286', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430527, 430500, '绥宁县', '绥宁', '110.155075', '26.580622', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430528, 430500, '新宁县', '新宁', '110.859116', '26.438911', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430529, 430500, '城步苗族自治县', '城步', '110.313225', '26.363575', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430581, 430500, '武冈市', '武冈', '110.6368', '26.732086', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430582, 430500, '邵东市', '邵东', '111.74446', '27.25844', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430600, 430000, '岳阳市', '岳阳', '113.13286', '29.37029', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430602, 430600, '岳阳楼区', '岳阳楼', '113.12075', '29.366783', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430603, 430600, '云溪区', '云溪', '113.27387', '29.473394', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430611, 430600, '君山区', '君山', '113.00408', '29.438063', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430621, 430600, '岳阳县', '岳阳', '113.11607', '29.144842', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430623, 430600, '华容县', '华容', '112.55937', '29.524107', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430624, 430600, '湘阴县', '湘阴', '112.88975', '28.677498', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430626, 430600, '平江县', '平江', '113.59375', '28.701523', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430681, 430600, '汨罗市', '汨罗', '113.07942', '28.803148', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430682, 430600, '临湘市', '临湘', '113.450806', '29.471594', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430700, 430000, '常德市', '常德', '111.691345', '29.040224', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430702, 430700, '武陵区', '武陵', '111.69072', '29.040478', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430703, 430700, '鼎城区', '鼎城', '111.685326', '29.014425', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430721, 430700, '安乡县', '安乡', '112.17229', '29.414482', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430722, 430700, '汉寿县', '汉寿', '111.968506', '28.907318', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430723, 430700, '澧县', '澧县', '111.76168', '29.64264', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430724, 430700, '临澧县', '临澧', '111.6456', '29.443216', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430725, 430700, '桃源县', '桃源', '111.484505', '28.902735', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430726, 430700, '石门县', '石门', '111.37909', '29.584703', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430781, 430700, '津市市', '津市', '111.87961', '29.630867', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430800, 430000, '张家界市', '张家界', '110.47992', '29.127401', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430802, 430800, '永定区', '永定', '110.48456', '29.125961', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430811, 430800, '武陵源区', '武陵源', '110.54758', '29.347828', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430821, 430800, '慈利县', '慈利', '111.132706', '29.423876', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430822, 430800, '桑植县', '桑植', '110.16404', '29.399939', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430900, 430000, '益阳市', '益阳', '112.35504', '28.570066', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430902, 430900, '资阳区', '资阳', '112.33084', '28.592772', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430903, 430900, '赫山区', '赫山', '112.36095', '28.568327', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430921, 430900, '南县', '南县', '112.4104', '29.37218', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430922, 430900, '桃江县', '桃江', '112.13973', '28.520992', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430923, 430900, '安化县', '安化', '111.221825', '28.37742', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (430981, 430900, '沅江市', '沅江', '112.36109', '28.839712', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431000, 430000, '郴州市', '郴州', '113.03207', '25.793589', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431002, 431000, '北湖区', '北湖', '113.03221', '25.792627', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431003, 431000, '苏仙区', '苏仙', '113.0387', '25.793158', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431021, 431000, '桂阳县', '桂阳', '112.73447', '25.737448', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431022, 431000, '宜章县', '宜章', '112.94788', '25.394344', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431023, 431000, '永兴县', '永兴', '113.11482', '26.129393', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431024, 431000, '嘉禾县', '嘉禾', '112.37062', '25.587309', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431025, 431000, '临武县', '临武', '112.56459', '25.27912', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431026, 431000, '汝城县', '汝城', '113.685684', '25.553759', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431027, 431000, '桂东县', '桂东', '113.94588', '26.073917', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431028, 431000, '安仁县', '安仁', '113.27217', '26.708626', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431081, 431000, '资兴市', '资兴', '113.23682', '25.974152', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431100, 430000, '永州市', '永州', '111.60802', '26.434517', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431102, 431100, '零陵区', '零陵', '111.62635', '26.223347', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431103, 431100, '冷水滩区', '冷水滩', '111.607155', '26.434364', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431121, 431100, '祁阳县', '祁阳', '111.85734', '26.58593', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431122, 431100, '东安县', '东安', '111.313034', '26.397278', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431123, 431100, '双牌县', '双牌', '111.66215', '25.959396', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431124, 431100, '道县', '道县', '111.59161', '25.518444', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431125, 431100, '江永县', '江永', '111.3468', '25.268154', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431126, 431100, '宁远县', '宁远', '111.94453', '25.584112', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431127, 431100, '蓝山县', '蓝山', '112.1942', '25.375256', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431128, 431100, '新田县', '新田', '112.220345', '25.906927', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431129, 431100, '江华瑶族自治县', '江华', '111.57728', '25.182596', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431200, 430000, '怀化市', '怀化', '109.97824', '27.550081', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431202, 431200, '鹤城区', '鹤城', '109.98224', '27.548473', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431221, 431200, '中方县', '中方', '109.94806', '27.43736', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431222, 431200, '沅陵县', '沅陵', '110.39916', '28.455553', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431223, 431200, '辰溪县', '辰溪', '110.19695', '28.005474', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431224, 431200, '溆浦县', '溆浦', '110.593376', '27.903803', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431225, 431200, '会同县', '会同', '109.72079', '26.870789', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431226, 431200, '麻阳苗族自治县', '麻阳', '109.80281', '27.865992', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431227, 431200, '新晃侗族自治县', '新晃', '109.174446', '27.359898', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431228, 431200, '芷江侗族自治县', '芷江', '109.687775', '27.437996', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431229, 431200, '靖州苗族侗族自治县', '靖州', '109.69116', '26.573511', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431230, 431200, '通道侗族自治县', '通道', '109.783356', '26.158348', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431281, 431200, '洪江市', '洪江', '109.831764', '27.201876', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431300, 430000, '娄底市', '娄底', '112.0085', '27.728136', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431302, 431300, '娄星区', '娄星', '112.008484', '27.726643', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431321, 431300, '双峰县', '双峰', '112.19824', '27.459126', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431322, 431300, '新化县', '新化', '111.30675', '27.737455', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431381, 431300, '冷水江市', '冷水江', '111.43468', '27.685759', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (431382, 431300, '涟源市', '涟源', '111.670845', '27.6923', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (433100, 430000, '湘西土家族苗族自治州', '湘西', '109.73974', '28.314297', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (433101, 433100, '吉首市', '吉首', '109.73827', '28.314827', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (433122, 433100, '泸溪县', '泸溪', '110.21443', '28.214516', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (433123, 433100, '凤凰县', '凤凰', '109.59919', '27.948309', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (433124, 433100, '花垣县', '花垣', '109.479065', '28.581352', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (433125, 433100, '保靖县', '保靖', '109.65144', '28.709604', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (433126, 433100, '古丈县', '古丈', '109.94959', '28.616974', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (433127, 433100, '永顺县', '永顺', '109.853294', '28.998068', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (433130, 433100, '龙山县', '龙山', '109.44119', '29.453438', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440000, 0, '广东省', '广东', '113.28064', '23.125177', 1, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440100, 440000, '广州市', '广州', '113.28064', '23.125177', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440103, 440100, '荔湾区', '荔湾', '113.243034', '23.124943', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440104, 440100, '越秀区', '越秀', '113.280716', '23.125624', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440105, 440100, '海珠区', '海珠', '113.26201', '23.10313', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440106, 440100, '天河区', '天河', '113.335365', '23.13559', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440111, 440100, '白云区', '白云', '113.26283', '23.162281', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440112, 440100, '黄埔区', '黄埔', '113.45076', '23.10324', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440113, 440100, '番禺区', '番禺', '113.36462', '22.938581', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440114, 440100, '花都区', '花都', '113.21118', '23.39205', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440115, 440100, '南沙区', '南沙', '113.53738', '22.79453', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440117, 440100, '从化区', '从化', '113.58646', '23.54835', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440118, 440100, '增城区', '增城', '113.8109', '23.26093', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440200, 440000, '韶关市', '韶关', '113.591545', '24.801323', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440203, 440200, '武江区', '武江', '113.58829', '24.80016', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440204, 440200, '浈江区', '浈江', '113.59922', '24.803976', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440205, 440200, '曲江区', '曲江', '113.60558', '24.680195', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440222, 440200, '始兴县', '始兴', '114.06721', '24.948364', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440224, 440200, '仁化县', '仁化', '113.74863', '25.088226', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440229, 440200, '翁源县', '翁源', '114.13129', '24.353888', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440232, 440200, '乳源瑶族自治县', '乳源', '113.27842', '24.77611', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440233, 440200, '新丰县', '新丰', '114.20703', '24.055412', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440281, 440200, '乐昌市', '乐昌', '113.35241', '25.128445', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440282, 440200, '南雄市', '南雄', '114.31123', '25.115328', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440300, 440000, '深圳市', '深圳', '114.085945', '22.547', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440303, 440300, '罗湖区', '罗湖', '114.123886', '22.555342', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440304, 440300, '福田区', '福田', '114.05096', '22.54101', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440305, 440300, '南山区', '南山', '113.92943', '22.531221', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440306, 440300, '宝安区', '宝安', '113.828674', '22.754742', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440307, 440300, '龙岗区', '龙岗', '114.25137', '22.721512', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440308, 440300, '盐田区', '盐田', '114.23537', '22.555069', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440309, 440300, '龙华区', '龙华', '114.06031', '22.72174', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440310, 440300, '坪山区', '坪山', '114.34632', '22.69084', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440311, 440300, '光明区', '光明', '113.93588', '22.74894', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440400, 440000, '珠海市', '珠海', '113.553986', '22.22498', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440402, 440400, '香洲区', '香洲', '113.55027', '22.27125', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440403, 440400, '斗门区', '斗门', '113.29774', '22.209118', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440404, 440400, '金湾区', '金湾', '113.34507', '22.139122', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440500, 440000, '汕头市', '汕头', '116.708466', '23.37102', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440507, 440500, '龙湖区', '龙湖', '116.73202', '23.373755', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440511, 440500, '金平区', '金平', '116.70358', '23.367071', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440512, 440500, '濠江区', '濠江', '116.72953', '23.279345', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440513, 440500, '潮阳区', '潮阳', '116.6026', '23.262337', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440514, 440500, '潮南区', '潮南', '116.42361', '23.249798', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440515, 440500, '澄海区', '澄海', '116.76336', '23.46844', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440523, 440500, '南澳县', '南澳', '117.02711', '23.419561', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440600, 440000, '佛山市', '佛山', '113.12272', '23.028763', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440604, 440600, '禅城区', '禅城', '113.11241', '23.019644', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440605, 440600, '南海区', '南海', '113.14558', '23.031563', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440606, 440600, '顺德区', '顺德', '113.28182', '22.75851', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440607, 440600, '三水区', '三水', '112.899414', '23.16504', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440608, 440600, '高明区', '高明', '112.882126', '22.893854', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440700, 440000, '江门市', '江门', '113.09494', '22.590431', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440703, 440700, '蓬江区', '蓬江', '113.07859', '22.59677', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440704, 440700, '江海区', '江海', '113.1206', '22.57221', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440705, 440700, '新会区', '新会', '113.03858', '22.520247', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440781, 440700, '台山市', '台山', '112.79341', '22.250713', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440783, 440700, '开平市', '开平', '112.69226', '22.366285', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440784, 440700, '鹤山市', '鹤山', '112.96179', '22.768105', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440785, 440700, '恩平市', '恩平', '112.31405', '22.182957', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440800, 440000, '湛江市', '湛江', '110.364975', '21.274899', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440802, 440800, '赤坎区', '赤坎', '110.36163', '21.273365', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440803, 440800, '霞山区', '霞山', '110.40638', '21.19423', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440804, 440800, '坡头区', '坡头', '110.455635', '21.24441', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440811, 440800, '麻章区', '麻章', '110.32917', '21.265997', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440823, 440800, '遂溪县', '遂溪', '110.25532', '21.376915', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440825, 440800, '徐闻县', '徐闻', '110.17572', '20.326082', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440881, 440800, '廉江市', '廉江', '110.28496', '21.61128', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440882, 440800, '雷州市', '雷州', '110.08827', '20.908524', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440883, 440800, '吴川市', '吴川', '110.78051', '21.428453', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440900, 440000, '茂名市', '茂名', '110.91923', '21.659752', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440902, 440900, '茂南区', '茂南', '110.92054', '21.660425', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440904, 440900, '电白区', '电白', '111.01636', '21.51428', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440981, 440900, '高州市', '高州', '110.85325', '21.915154', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440982, 440900, '化州市', '化州', '110.63839', '21.654953', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (440983, 440900, '信宜市', '信宜', '110.94166', '22.35268', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441200, 440000, '肇庆市', '肇庆', '112.47253', '23.051546', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441202, 441200, '端州区', '端州', '112.47233', '23.052662', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441203, 441200, '鼎湖区', '鼎湖', '112.56525', '23.155823', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441204, 441200, '高要区', '高要', '112.45839', '23.02581', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441223, 441200, '广宁县', '广宁', '112.44042', '23.631487', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441224, 441200, '怀集县', '怀集', '112.182465', '23.913073', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441225, 441200, '封开县', '封开', '111.502975', '23.43473', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441226, 441200, '德庆县', '德庆', '111.78156', '23.14171', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441284, 441200, '四会市', '四会', '112.69503', '23.340324', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441300, 440000, '惠州市', '惠州', '114.4126', '23.079405', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441302, 441300, '惠城区', '惠城', '114.41398', '23.079884', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441303, 441300, '惠阳区', '惠阳', '114.469444', '22.78851', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441322, 441300, '博罗县', '博罗', '114.284256', '23.167576', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441323, 441300, '惠东县', '惠东', '114.72309', '22.983036', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441324, 441300, '龙门县', '龙门', '114.25999', '23.723894', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441400, 440000, '梅州市', '梅州', '116.117584', '24.299112', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441402, 441400, '梅江区', '梅江', '116.12116', '24.302593', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441403, 441400, '梅县区', '梅县', '116.08245', '24.26539', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441422, 441400, '大埔县', '大埔', '116.69552', '24.351587', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441423, 441400, '丰顺县', '丰顺', '116.18442', '23.752771', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441424, 441400, '五华县', '五华', '115.775', '23.925425', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441426, 441400, '平远县', '平远', '115.89173', '24.56965', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441427, 441400, '蕉岭县', '蕉岭', '116.17053', '24.653313', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441481, 441400, '兴宁市', '兴宁', '115.73165', '24.138077', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441500, 440000, '汕尾市', '汕尾', '115.364235', '22.774485', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441502, 441500, '城区', '城区', '115.36367', '22.776228', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441521, 441500, '海丰县', '海丰', '115.337326', '22.971043', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441523, 441500, '陆河县', '陆河', '115.65756', '23.302683', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441581, 441500, '陆丰市', '陆丰', '115.6442', '22.946104', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441600, 440000, '河源市', '河源', '114.6978', '23.746265', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441602, 441600, '源城区', '源城', '114.69683', '23.746256', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441621, 441600, '紫金县', '紫金', '115.18438', '23.633743', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441622, 441600, '龙川县', '龙川', '115.25642', '24.101173', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441623, 441600, '连平县', '连平', '114.49595', '24.364227', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441624, 441600, '和平县', '和平', '114.941475', '24.44318', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441625, 441600, '东源县', '东源', '114.742714', '23.789093', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441700, 440000, '阳江市', '阳江', '111.975105', '21.859222', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441702, 441700, '江城区', '江城', '111.96891', '21.859182', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441704, 441700, '阳东区', '阳东', '112.0067', '21.86829', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441721, 441700, '阳西县', '阳西', '111.61755', '21.75367', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441781, 441700, '阳春市', '阳春', '111.7905', '22.169598', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441800, 440000, '清远市', '清远', '113.05122', '23.685022', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441802, 441800, '清城区', '清城', '113.0487', '23.688976', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441803, 441800, '清新区', '清新', '113.01658', '23.73474', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441821, 441800, '佛冈县', '佛冈', '113.534096', '23.86674', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441823, 441800, '阳山县', '阳山', '112.63402', '24.470285', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441825, 441800, '连山壮族瑶族自治县', '连山', '112.086555', '24.56727', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441826, 441800, '连南瑶族自治县', '连南', '112.29081', '24.719097', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441881, 441800, '英德市', '英德', '113.4054', '24.18612', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441882, 441800, '连州市', '连州', '112.37927', '24.783966', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (441900, 440000, '东莞市', '东莞', '113.74626', '23.046238', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (442000, 440000, '中山市', '中山', '113.38239', '22.521112', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (445100, 440000, '潮州市', '潮州', '116.6323', '23.661701', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (445102, 445100, '湘桥区', '湘桥', '116.63365', '23.664675', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (445103, 445100, '潮安区', '潮安', '116.67809', '23.46244', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (445122, 445100, '饶平县', '饶平', '117.00205', '23.66817', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (445200, 440000, '揭阳市', '揭阳', '116.355736', '23.543777', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (445202, 445200, '榕城区', '榕城', '116.35705', '23.535524', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (445203, 445200, '揭东区', '揭东', '116.41211', '23.56606', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (445222, 445200, '揭西县', '揭西', '115.83871', '23.4273', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (445224, 445200, '惠来县', '惠来', '116.29583', '23.029835', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (445281, 445200, '普宁市', '普宁', '116.165085', '23.29788', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (445300, 440000, '云浮市', '云浮', '112.04444', '22.929802', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (445302, 445300, '云城区', '云城', '112.04471', '22.930826', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (445303, 445300, '云安区', '云安', '112.00324', '23.07101', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (445321, 445300, '新兴县', '新兴', '112.23083', '22.703203', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (445322, 445300, '郁南县', '郁南', '111.53592', '23.237709', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (445381, 445300, '罗定市', '罗定', '111.5782', '22.765415', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450000, 0, '广西壮族自治区', '广西', '108.32001', '22.82402', 1, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450100, 450000, '南宁市', '南宁', '108.32001', '22.82402', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450102, 450100, '兴宁区', '兴宁', '108.32019', '22.819511', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450103, 450100, '青秀区', '青秀', '108.346115', '22.816614', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450105, 450100, '江南区', '江南', '108.31048', '22.799593', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450107, 450100, '西乡塘区', '西乡塘', '108.3069', '22.832779', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450108, 450100, '良庆区', '良庆', '108.322105', '22.75909', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450109, 450100, '邕宁区', '邕宁', '108.48425', '22.756598', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450110, 450100, '武鸣区', '武鸣', '108.27461', '23.15866', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450123, 450100, '隆安县', '隆安', '107.68866', '23.174763', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450124, 450100, '马山县', '马山', '108.172905', '23.711758', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450125, 450100, '上林县', '上林', '108.603935', '23.431768', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450126, 450100, '宾阳县', '宾阳', '108.816734', '23.216885', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450127, 450100, '横县', '横县', '109.27099', '22.68743', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450200, 450000, '柳州市', '柳州', '109.411705', '24.314617', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450202, 450200, '城中区', '城中', '109.41175', '24.312325', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450203, 450200, '鱼峰区', '鱼峰', '109.41537', '24.303848', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450204, 450200, '柳南区', '柳南', '109.395935', '24.287012', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450205, 450200, '柳北区', '柳北', '109.40658', '24.359144', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450206, 450200, '柳江区', '柳江', '109.32672', '24.25465', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450222, 450200, '柳城县', '柳城', '109.24581', '24.65512', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450223, 450200, '鹿寨县', '鹿寨', '109.74081', '24.483404', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450224, 450200, '融安县', '融安', '109.40362', '25.214703', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450225, 450200, '融水苗族自治县', '融水', '109.25275', '25.068811', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450226, 450200, '三江侗族自治县', '三江', '109.614845', '25.78553', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450300, 450000, '桂林市', '桂林', '110.29912', '25.274216', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450302, 450300, '秀峰区', '秀峰', '110.29244', '25.278543', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450303, 450300, '叠彩区', '叠彩', '110.30078', '25.301334', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450304, 450300, '象山区', '象山', '110.28488', '25.261986', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450305, 450300, '七星区', '七星', '110.31757', '25.25434', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450311, 450300, '雁山区', '雁山', '110.305664', '25.077646', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450312, 450300, '临桂区', '临桂', '110.2124', '25.23868', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450321, 450300, '阳朔县', '阳朔', '110.4947', '24.77534', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450323, 450300, '灵川县', '灵川', '110.325714', '25.40854', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450324, 450300, '全州县', '全州', '111.07299', '25.929897', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450325, 450300, '兴安县', '兴安', '110.670784', '25.609554', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450326, 450300, '永福县', '永福', '109.989204', '24.986692', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450327, 450300, '灌阳县', '灌阳', '111.16025', '25.489098', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450328, 450300, '龙胜各族自治县', '龙胜', '110.00942', '25.796429', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450329, 450300, '资源县', '资源', '110.642586', '26.0342', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450330, 450300, '平乐县', '平乐', '110.64282', '24.632215', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450332, 450300, '恭城瑶族自治县', '恭城', '110.82952', '24.833612', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450381, 450300, '荔浦市', '荔浦', '110.39517', '24.48887', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450400, 450000, '梧州市', '梧州', '111.29761', '23.474804', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450403, 450400, '万秀区', '万秀', '111.31582', '23.471317', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450405, 450400, '长洲区', '长洲', '111.27568', '23.4777', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450406, 450400, '龙圩区', '龙圩', '111.24603', '23.40996', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450421, 450400, '苍梧县', '苍梧', '111.54401', '23.845097', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450422, 450400, '藤县', '藤县', '110.93182', '23.373962', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450423, 450400, '蒙山县', '蒙山', '110.5226', '24.19983', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450481, 450400, '岑溪市', '岑溪', '110.998116', '22.918406', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450500, 450000, '北海市', '北海', '109.119255', '21.473343', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450502, 450500, '海城区', '海城', '109.10753', '21.468443', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450503, 450500, '银海区', '银海', '109.118706', '21.444908', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450512, 450500, '铁山港区', '铁山港', '109.45058', '21.5928', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450521, 450500, '合浦县', '合浦', '109.20069', '21.663553', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450600, 450000, '防城港市', '防城港', '108.345474', '21.614632', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450602, 450600, '港口区', '港口', '108.34628', '21.614407', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450603, 450600, '防城区', '防城', '108.35843', '21.764757', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450621, 450600, '上思县', '上思', '107.98214', '22.151423', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450681, 450600, '东兴市', '东兴', '107.97017', '21.541172', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450700, 450000, '钦州市', '钦州', '108.624176', '21.967127', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450702, 450700, '钦南区', '钦南', '108.62663', '21.966808', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450703, 450700, '钦北区', '钦北', '108.44911', '22.132761', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450721, 450700, '灵山县', '灵山', '109.293465', '22.418041', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450722, 450700, '浦北县', '浦北', '109.55634', '22.268335', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450800, 450000, '贵港市', '贵港', '109.60214', '23.0936', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450802, 450800, '港北区', '港北', '109.59481', '23.107677', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450803, 450800, '港南区', '港南', '109.60467', '23.067516', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450804, 450800, '覃塘区', '覃塘', '109.415695', '23.132814', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450821, 450800, '平南县', '平南', '110.397484', '23.544546', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450881, 450800, '桂平市', '桂平', '110.07467', '23.382473', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450900, 450000, '玉林市', '玉林', '110.154396', '22.63136', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450902, 450900, '玉州区', '玉州', '110.154915', '22.632132', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450903, 450900, '福绵区', '福绵', '110.05143', '22.579947', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450921, 450900, '容县', '容县', '110.55247', '22.856436', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450922, 450900, '陆川县', '陆川', '110.26484', '22.321054', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450923, 450900, '博白县', '博白', '109.98', '22.271284', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450924, 450900, '兴业县', '兴业', '109.87777', '22.74187', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (450981, 450900, '北流市', '北流', '110.34805', '22.701649', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451000, 450000, '百色市', '百色', '106.61629', '23.897741', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451002, 451000, '右江区', '右江', '106.61573', '23.897675', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451003, 451000, '田阳区', '田阳', '106.91567', '23.73567', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451022, 451000, '田东县', '田东', '107.12426', '23.600445', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451024, 451000, '德保县', '德保', '106.618164', '23.321465', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451026, 451000, '那坡县', '那坡', '105.83355', '23.400785', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451027, 451000, '凌云县', '凌云', '106.56487', '24.345642', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451028, 451000, '乐业县', '乐业', '106.55964', '24.782204', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451029, 451000, '田林县', '田林', '106.23505', '24.290262', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451030, 451000, '西林县', '西林', '105.095024', '24.49204', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451031, 451000, '隆林各族自治县', '隆林', '105.34236', '24.774319', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451081, 451000, '靖西市', '靖西', '106.41769', '23.13402', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451082, 451000, '平果市', '平果', '107.58988', '23.32934', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451100, 450000, '贺州市', '贺州', '111.552055', '24.41414', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451102, 451100, '八步区', '八步', '111.551994', '24.412445', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451103, 451100, '平桂区', '平桂', '111.47971', '24.45296', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451121, 451100, '昭平县', '昭平', '110.81087', '24.172958', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451122, 451100, '钟山县', '钟山', '111.30363', '24.528566', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451123, 451100, '富川瑶族自治县', '富川', '111.27723', '24.81896', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451200, 450000, '河池市', '河池', '108.0621', '24.695898', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451202, 451200, '金城江区', '金城江', '108.06213', '24.695625', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451203, 451200, '宜州区', '宜州', '108.63656', '24.48513', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451221, 451200, '南丹县', '南丹', '107.54661', '24.983192', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451222, 451200, '天峨县', '天峨', '107.17494', '24.985964', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451223, 451200, '凤山县', '凤山', '107.04459', '24.544561', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451224, 451200, '东兰县', '东兰', '107.373695', '24.509367', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451225, 451200, '罗城仫佬族自治县', '罗城', '108.90245', '24.779327', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451226, 451200, '环江毛南族自治县', '环江', '108.25867', '24.827627', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451227, 451200, '巴马瑶族自治县', '巴马', '107.25313', '24.139538', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451228, 451200, '都安瑶族自治县', '都安', '108.10276', '23.934963', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451229, 451200, '大化瑶族自治县', '大化', '107.9945', '23.739595', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451300, 450000, '来宾市', '来宾', '109.229774', '23.733767', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451302, 451300, '兴宾区', '兴宾', '109.23054', '23.732925', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451321, 451300, '忻城县', '忻城', '108.66736', '24.06478', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451322, 451300, '象州县', '象州', '109.684555', '23.959824', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451323, 451300, '武宣县', '武宣', '109.66287', '23.604162', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451324, 451300, '金秀瑶族自治县', '金秀', '110.18855', '24.134941', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451381, 451300, '合山市', '合山', '108.88858', '23.81311', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451400, 450000, '崇左市', '崇左', '107.35393', '22.404108', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451402, 451400, '江州区', '江州', '107.35445', '22.40469', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451421, 451400, '扶绥县', '扶绥', '107.91153', '22.63582', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451422, 451400, '宁明县', '宁明', '107.06762', '22.131353', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451423, 451400, '龙州县', '龙州', '106.857506', '22.343716', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451424, 451400, '大新县', '大新', '107.200806', '22.833368', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451425, 451400, '天等县', '天等', '107.14244', '23.082483', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (451481, 451400, '凭祥市', '凭祥', '106.75904', '22.108883', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (460000, 0, '海南省', '海南', '110.33119', '20.031971', 1, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (460100, 460000, '海口市', '海口', '110.33119', '20.031971', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (460105, 460100, '秀英区', '秀英', '110.282394', '20.008144', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (460106, 460100, '龙华区', '龙华', '110.330376', '20.031027', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (460107, 460100, '琼山区', '琼山', '110.35472', '20.00105', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (460108, 460100, '美兰区', '美兰', '110.35657', '20.03074', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (460200, 460000, '三亚市', '三亚', '109.50827', '18.247871', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (460202, 460200, '海棠区', '海棠', '109.7525', '18.40005', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (460203, 460200, '吉阳区', '吉阳', '109.57841', '18.28225', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (460204, 460200, '天涯区', '天涯', '109.45263', '18.29921', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (460205, 460200, '崖州区', '崖州', '109.17186', '18.35753', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (460300, 460000, '三沙市', '三沙', '112.34882', '16.83104', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (460321, 460300, '西沙群岛', '', '', '', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (460322, 460300, '南沙群岛', '', '', '', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (460323, 460300, '中沙群岛的岛礁及其海域', '', '', '', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (460400, 460000, '儋州市', '儋州', '109.58069', '19.52093', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (460401, 460400, '儋州全市', '', '', '', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (469000, 460000, '省直辖县', '', '', '', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (469001, 469000, '五指山市', '五指山', '109.51666', '18.77692', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (469002, 469000, '琼海市', '琼海', '110.46678', '19.246012', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (469005, 469000, '文昌市', '文昌', '110.753975', '19.612986', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (469006, 469000, '万宁市', '万宁', '110.388794', '18.796215', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (469007, 469000, '东方市', '东方', '108.653786', '19.10198', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (469021, 469000, '定安县', '定安', '110.3593', '19.68121', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (469022, 469000, '屯昌县', '屯昌', '110.10347', '19.35182', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (469023, 469000, '澄迈县', '澄迈', '110.00487', '19.73849', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (469024, 469000, '临高县', '临高', '109.69077', '19.91243', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (469025, 469000, '白沙黎族自治县', '定安', '110.349236', '19.684965', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (469026, 469000, '昌江黎族自治县', '屯昌', '110.102776', '19.362917', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (469027, 469000, '乐东黎族自治县', '澄迈', '110.00715', '19.737095', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (469028, 469000, '陵水黎族自治县', '临高', '109.6877', '19.908293', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (469029, 469000, '保亭黎族苗族自治县', '保亭黎族苗族自治县', '109.70259', '18.63905', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (469030, 469000, '琼中黎族苗族自治县', '白沙', '109.45261', '19.224585', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500000, 0, '重庆市', '重庆', '106.50496', '29.533155', 1, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500100, 500000, '重庆市', '重庆', '106.50496', '29.533155', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500101, 500100, '万州区', '万州', '108.38025', '30.807808', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500102, 500100, '涪陵区', '涪陵', '107.394905', '29.703651', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500103, 500100, '渝中区', '渝中', '106.56288', '29.556742', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500104, 500100, '大渡口区', '大渡口', '106.48613', '29.481003', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500105, 500100, '江北区', '江北', '106.532845', '29.575352', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500106, 500100, '沙坪坝区', '沙坪坝', '106.4542', '29.541224', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500107, 500100, '九龙坡区', '九龙坡', '106.48099', '29.523493', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500108, 500100, '南岸区', '南岸', '106.560814', '29.523993', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500109, 500100, '北碚区', '北碚', '106.43787', '29.82543', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500110, 500100, '綦江区', '綦江', '106.92852', '28.96463', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500111, 500100, '大足区', '大足', '105.78017', '29.48604', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500112, 500100, '渝北区', '渝北', '106.51285', '29.601452', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500113, 500100, '巴南区', '巴南', '106.519424', '29.38192', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500114, 500100, '黔江区', '黔江', '108.78258', '29.527548', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500115, 500100, '长寿区', '长寿', '107.07485', '29.833672', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500116, 500100, '江津区', '江津', '106.25936', '29.29014', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500117, 500100, '合川区', '合川', '106.27679', '29.97288', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500118, 500100, '永川区', '永川', '105.92709', '29.356', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500119, 500100, '南川区', '南川', '107.09896', '29.15788', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500120, 500100, '璧山区', '璧山', '106.22742', '29.59202', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500151, 500100, '铜梁区', '铜梁', '106.05638', '29.84475', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500152, 500100, '潼南区', '潼南', '105.83952', '30.19054', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500153, 500100, '荣昌区', '荣昌', '105.61188', '29.41671', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500154, 500100, '开州区', '开州', '108.39311', '31.16098', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500155, 500100, '梁平区', '梁平', '107.80235', '30.67373', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500156, 500100, '武隆区', '武隆', '107.75993', '29.32543', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500229, 500100, '城口县', '城口', '108.6649', '31.946293', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500230, 500100, '丰都县', '丰都', '107.73248', '29.866425', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500231, 500100, '垫江县', '垫江', '107.348694', '30.330011', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500233, 500100, '忠县', '忠县', '108.03752', '30.291536', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500235, 500100, '云阳县', '云阳', '108.6977', '30.930529', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500236, 500100, '奉节县', '奉节', '109.465775', '31.019966', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500237, 500100, '巫山县', '巫山', '109.87893', '31.074842', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500238, 500100, '巫溪县', '巫溪', '109.628914', '31.3966', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500240, 500100, '石柱土家族自治县', '石柱', '108.11245', '29.99853', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500241, 500100, '秀山土家族苗族自治县', '秀山', '108.99604', '28.444773', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500242, 500100, '酉阳土家族苗族自治县', '酉阳', '108.767204', '28.839828', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (500243, 500100, '彭水苗族土家族自治县', '彭水', '108.16655', '29.293856', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510000, 0, '四川省', '四川', '104.065735', '30.659462', 1, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510100, 510000, '成都市', '成都', '104.065735', '30.659462', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510104, 510100, '锦江区', '锦江', '104.080986', '30.657688', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510105, 510100, '青羊区', '青羊', '104.05573', '30.667648', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510106, 510100, '金牛区', '金牛', '104.04349', '30.692059', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510107, 510100, '武侯区', '武侯', '104.05167', '30.630861', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510108, 510100, '成华区', '成华', '104.10308', '30.660275', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510112, 510100, '龙泉驿区', '龙泉驿', '104.26918', '30.56065', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510113, 510100, '青白江区', '青白江', '104.25494', '30.883438', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510114, 510100, '新都区', '新都', '104.16022', '30.824223', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510115, 510100, '温江区', '温江', '103.83678', '30.697996', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510116, 510100, '双流区', '双流', '103.92377', '30.57447', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510117, 510100, '郫都区', '郫都', '103.90256', '30.79589', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510118, 510100, '新津区', '新津', '', '', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510121, 510100, '金堂县', '金堂', '104.4156', '30.858418', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510129, 510100, '大邑县', '大邑', '103.5224', '30.586601', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510131, 510100, '蒲江县', '蒲江', '103.51154', '30.194359', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510181, 510100, '都江堰市', '都江堰', '103.6279', '30.99114', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510182, 510100, '彭州市', '彭州', '103.94117', '30.98516', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510183, 510100, '邛崃市', '邛崃', '103.46143', '30.41327', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510184, 510100, '崇州市', '崇州', '103.67105', '30.631477', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510185, 510100, '简阳市', '简阳', '104.54733', '30.41133', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510300, 510000, '自贡市', '自贡', '104.773445', '29.352764', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510302, 510300, '自流井区', '自流井', '104.77819', '29.343231', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510303, 510300, '贡井区', '贡井', '104.71437', '29.345675', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510304, 510300, '大安区', '大安', '104.783226', '29.367136', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510311, 510300, '沿滩区', '沿滩', '104.87642', '29.27252', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510321, 510300, '荣县', '荣县', '104.423935', '29.454851', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510322, 510300, '富顺县', '富顺', '104.98425', '29.181282', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510400, 510000, '攀枝花市', '攀枝花', '101.716', '26.580446', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510402, 510400, '东区', '东区', '101.71513', '26.580887', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510403, 510400, '西区', '西区', '101.63797', '26.596775', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510411, 510400, '仁和区', '仁和', '101.737915', '26.497185', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510421, 510400, '米易县', '米易', '102.10988', '26.887474', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510422, 510400, '盐边县', '盐边', '101.851845', '26.67762', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510500, 510000, '泸州市', '泸州', '105.44335', '28.889137', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510502, 510500, '江阳区', '江阳', '105.44513', '28.882889', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510503, 510500, '纳溪区', '纳溪', '105.37721', '28.77631', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510504, 510500, '龙马潭区', '龙马潭', '105.43523', '28.897572', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510521, 510500, '泸县', '泸县', '105.376335', '29.151287', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510522, 510500, '合江县', '合江', '105.8341', '28.810326', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510524, 510500, '叙永县', '叙永', '105.437775', '28.16792', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510525, 510500, '古蔺县', '古蔺', '105.81336', '28.03948', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510600, 510000, '德阳市', '德阳', '104.39865', '31.12799', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510603, 510600, '旌阳区', '旌阳', '104.38965', '31.130428', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510604, 510600, '罗江区', '罗江', '104.51021', '31.31681', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510623, 510600, '中江县', '中江', '104.67783', '31.03681', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510681, 510600, '广汉市', '广汉', '104.281906', '30.97715', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510682, 510600, '什邡市', '什邡', '104.17365', '31.12688', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510683, 510600, '绵竹市', '绵竹', '104.200165', '31.343084', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510700, 510000, '绵阳市', '绵阳', '104.74172', '31.46402', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510703, 510700, '涪城区', '涪城', '104.740974', '31.463556', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510704, 510700, '游仙区', '游仙', '104.770004', '31.484772', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510705, 510700, '安州区', '安州', '104.56735', '31.53465', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510722, 510700, '三台县', '三台', '105.09032', '31.090908', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510723, 510700, '盐亭县', '盐亭', '105.39199', '31.22318', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510725, 510700, '梓潼县', '梓潼', '105.16353', '31.635225', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510726, 510700, '北川羌族自治县', '北川', '104.46807', '31.615864', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510727, 510700, '平武县', '平武', '104.530556', '32.40759', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510781, 510700, '江油市', '江油', '104.74443', '31.776386', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510800, 510000, '广元市', '广元', '105.82976', '32.433666', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510802, 510800, '利州区', '利州', '105.826195', '32.432278', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510811, 510800, '昭化区', '昭化', '105.96412', '32.32279', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510812, 510800, '朝天区', '朝天', '105.88917', '32.64263', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510821, 510800, '旺苍县', '旺苍', '106.29043', '32.22833', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510822, 510800, '青川县', '青川', '105.238846', '32.585655', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510823, 510800, '剑阁县', '剑阁', '105.52704', '32.28652', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510824, 510800, '苍溪县', '苍溪', '105.939705', '31.73225', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510900, 510000, '遂宁市', '遂宁', '105.57133', '30.513311', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510903, 510900, '船山区', '船山', '105.582214', '30.502647', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510904, 510900, '安居区', '安居', '105.45938', '30.34612', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510921, 510900, '蓬溪县', '蓬溪', '105.7137', '30.774883', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510923, 510900, '大英县', '大英', '105.25219', '30.581572', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (510981, 510900, '射洪市', '射洪', '105.38836', '30.87113', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511000, 510000, '内江市', '内江', '105.06614', '29.58708', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511002, 511000, '市中区', '市中', '105.06547', '29.585264', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511011, 511000, '东兴区', '东兴', '105.0672', '29.600107', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511024, 511000, '威远县', '威远', '104.66833', '29.52686', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511025, 511000, '资中县', '资中', '104.85246', '29.775295', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511083, 511000, '隆昌市', '隆昌', '105.28773', '29.33948', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511100, 510000, '乐山市', '乐山', '103.76126', '29.582024', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511102, 511100, '市中区', '市中', '103.75539', '29.588327', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511111, 511100, '沙湾区', '沙湾', '103.54996', '29.416536', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511112, 511100, '五通桥区', '五通桥', '103.81683', '29.406185', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511113, 511100, '金口河区', '金口河', '103.07783', '29.24602', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511123, 511100, '犍为县', '犍为', '103.94427', '29.209782', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511124, 511100, '井研县', '井研', '104.06885', '29.651646', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511126, 511100, '夹江县', '夹江', '103.578865', '29.741018', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511129, 511100, '沐川县', '沐川', '103.90211', '28.956339', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511132, 511100, '峨边彝族自治县', '峨边', '103.262146', '29.23027', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511133, 511100, '马边彝族自治县', '马边', '103.54685', '28.838934', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511181, 511100, '峨眉山市', '峨眉山', '103.492485', '29.597479', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511300, 510000, '南充市', '南充', '106.08298', '30.79528', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511302, 511300, '顺庆区', '顺庆', '106.08409', '30.795572', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511303, 511300, '高坪区', '高坪', '106.10899', '30.781809', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511304, 511300, '嘉陵区', '嘉陵', '106.067024', '30.762976', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511321, 511300, '南部县', '南部', '106.061134', '31.349407', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511322, 511300, '营山县', '营山', '106.564896', '31.075907', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511323, 511300, '蓬安县', '蓬安', '106.41349', '31.027979', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511324, 511300, '仪陇县', '仪陇', '106.29708', '31.271261', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511325, 511300, '西充县', '西充', '105.89302', '30.994616', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511381, 511300, '阆中市', '阆中', '105.975266', '31.580465', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511400, 510000, '眉山市', '眉山', '103.83179', '30.048319', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511402, 511400, '东坡区', '东坡', '103.83155', '30.048128', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511403, 511400, '彭山区', '彭山', '103.87283', '30.19299', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511421, 511400, '仁寿县', '仁寿', '104.147644', '29.996721', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511423, 511400, '洪雅县', '洪雅', '103.37501', '29.904867', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511424, 511400, '丹棱县', '丹棱', '103.51833', '30.01275', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511425, 511400, '青神县', '青神', '103.84613', '29.831469', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511500, 510000, '宜宾市', '宜宾', '104.63082', '28.76019', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511502, 511500, '翠屏区', '翠屏', '104.63023', '28.76018', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511503, 511500, '南溪区', '南溪', '104.96953', '28.84548', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511504, 511500, '叙州区', '叙州', '104.53316', '28.68998', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511523, 511500, '江安县', '江安', '105.068695', '28.728102', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511524, 511500, '长宁县', '长宁', '104.92112', '28.57727', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511525, 511500, '高县', '高县', '104.51919', '28.435677', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511526, 511500, '珙县', '珙县', '104.712265', '28.449041', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511527, 511500, '筠连县', '筠连', '104.50785', '28.162018', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511528, 511500, '兴文县', '兴文', '105.23655', '28.302988', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511529, 511500, '屏山县', '屏山', '104.16262', '28.64237', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511600, 510000, '广安市', '广安', '106.63337', '30.456398', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511602, 511600, '广安区', '广安', '106.632904', '30.456463', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511603, 511600, '前锋区', '前锋', '106.89328', '30.4963', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511621, 511600, '岳池县', '岳池', '106.44445', '30.533539', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511622, 511600, '武胜县', '武胜', '106.29247', '30.344292', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511623, 511600, '邻水县', '邻水', '106.93497', '30.334324', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511681, 511600, '华蓥市', '华蓥', '106.777885', '30.380573', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511700, 510000, '达州市', '达州', '107.50226', '31.209484', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511702, 511700, '通川区', '通川', '107.50106', '31.213522', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511703, 511700, '达川区', '达川', '107.51177', '31.19603', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511722, 511700, '宣汉县', '宣汉', '107.72225', '31.355024', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511723, 511700, '开江县', '开江', '107.864136', '31.085537', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511724, 511700, '大竹县', '大竹', '107.20742', '30.736288', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511725, 511700, '渠县', '渠县', '106.97075', '30.836348', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511781, 511700, '万源市', '万源', '108.037544', '32.06777', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511800, 510000, '雅安市', '雅安', '103.00103', '29.987722', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511802, 511800, '雨城区', '雨城', '103.003395', '29.98183', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511803, 511800, '名山区', '名山', '103.10954', '30.06982', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511822, 511800, '荥经县', '荥经', '102.84467', '29.795528', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511823, 511800, '汉源县', '汉源', '102.67715', '29.349915', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511824, 511800, '石棉县', '石棉', '102.35962', '29.234062', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511825, 511800, '天全县', '天全', '102.76346', '30.059956', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511826, 511800, '芦山县', '芦山', '102.92402', '30.152906', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511827, 511800, '宝兴县', '宝兴', '102.81338', '30.369026', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511900, 510000, '巴中市', '巴中', '106.75367', '31.858809', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511902, 511900, '巴州区', '巴州', '106.75367', '31.858366', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511903, 511900, '恩阳区', '恩阳', '106.63608', '31.789442', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511921, 511900, '通江县', '通江', '107.24762', '31.91212', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511922, 511900, '南江县', '南江', '106.843414', '32.353165', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (511923, 511900, '平昌县', '平昌', '107.10194', '31.562815', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (512000, 510000, '资阳市', '资阳', '104.641914', '30.122211', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (512002, 512000, '雁江区', '雁江', '104.64234', '30.121687', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (512021, 512000, '安岳县', '安岳', '105.33676', '30.099207', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (512022, 512000, '乐至县', '乐至', '105.03114', '30.27562', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513200, 510000, '阿坝藏族羌族自治州', '阿坝', '102.221375', '31.899792', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513201, 513200, '马尔康市', '马尔康', '102.20644', '31.90585', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513221, 513200, '汶川县', '汶川', '103.58067', '31.47463', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513222, 513200, '理县', '理县', '103.16549', '31.436764', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513223, 513200, '茂县', '茂县', '103.850685', '31.680407', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513224, 513200, '松潘县', '松潘', '103.599174', '32.63838', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513225, 513200, '九寨沟县', '九寨沟', '104.23634', '33.262096', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513226, 513200, '金川县', '金川', '102.064644', '31.476357', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513227, 513200, '小金县', '小金', '102.36319', '30.999016', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513228, 513200, '黑水县', '黑水', '102.99081', '32.06172', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513230, 513200, '壤塘县', '壤塘', '100.97913', '32.26489', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513231, 513200, '阿坝县', '阿坝', '101.70099', '32.904224', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513232, 513200, '若尔盖县', '若尔盖', '102.96372', '33.575935', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513233, 513200, '红原县', '红原', '102.54491', '32.793903', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513300, 510000, '甘孜藏族自治州', '甘孜', '101.96381', '30.050663', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513301, 513300, '康定市', '康定', '101.96308', '30.05441', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513322, 513300, '泸定县', '泸定', '102.23322', '29.912481', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513323, 513300, '丹巴县', '丹巴', '101.88612', '30.877083', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513324, 513300, '九龙县', '九龙', '101.50694', '29.001974', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513325, 513300, '雅江县', '雅江', '101.01573', '30.03225', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513326, 513300, '道孚县', '道孚', '101.12333', '30.978767', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513327, 513300, '炉霍县', '炉霍', '100.6795', '31.392673', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513328, 513300, '甘孜县', '甘孜', '99.99175', '31.61975', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513329, 513300, '新龙县', '新龙', '100.312096', '30.93896', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513330, 513300, '德格县', '德格', '98.57999', '31.806728', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513331, 513300, '白玉县', '白玉', '98.82434', '31.208805', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513332, 513300, '石渠县', '石渠', '98.10088', '32.975304', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513333, 513300, '色达县', '色达', '100.33166', '32.268776', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513334, 513300, '理塘县', '理塘', '100.26986', '29.991808', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513335, 513300, '巴塘县', '巴塘', '99.10904', '30.005724', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513336, 513300, '乡城县', '乡城', '99.79994', '28.930855', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513337, 513300, '稻城县', '稻城', '100.29669', '29.037544', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513338, 513300, '得荣县', '得荣', '99.28803', '28.71134', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513400, 510000, '凉山彝族自治州', '凉山', '102.25874', '27.886763', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513401, 513400, '西昌市', '西昌', '102.25876', '27.885786', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513422, 513400, '木里藏族自治县', '木里', '101.28018', '27.926859', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513423, 513400, '盐源县', '盐源', '101.50891', '27.423414', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513424, 513400, '德昌县', '德昌', '102.17885', '27.403828', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513425, 513400, '会理县', '会理', '102.24955', '26.658703', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513426, 513400, '会东县', '会东', '102.57899', '26.630713', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513427, 513400, '宁南县', '宁南', '102.75738', '27.065205', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513428, 513400, '普格县', '普格', '102.541084', '27.376827', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513429, 513400, '布拖县', '布拖', '102.8088', '27.709063', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513430, 513400, '金阳县', '金阳', '103.2487', '27.695915', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513431, 513400, '昭觉县', '昭觉', '102.843994', '28.010553', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513432, 513400, '喜德县', '喜德', '102.41234', '28.305487', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513433, 513400, '冕宁县', '冕宁', '102.170044', '28.550844', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513434, 513400, '越西县', '越西', '102.50887', '28.639631', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513435, 513400, '甘洛县', '甘洛', '102.775925', '28.977095', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513436, 513400, '美姑县', '美姑', '103.132', '28.327946', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (513437, 513400, '雷波县', '雷波', '103.57159', '28.262945', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520000, 0, '贵州省', '贵州', '106.71348', '26.578342', 1, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520100, 520000, '贵阳市', '贵阳', '106.71348', '26.578342', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520102, 520100, '南明区', '南明', '106.715965', '26.573744', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520103, 520100, '云岩区', '云岩', '106.713394', '26.58301', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520111, 520100, '花溪区', '花溪', '106.67079', '26.410463', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520112, 520100, '乌当区', '乌当', '106.76212', '26.630928', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520113, 520100, '白云区', '白云', '106.63303', '26.67685', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520115, 520100, '观山湖区', '观山湖', '106.62254', '26.6015', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520121, 520100, '开阳县', '开阳', '106.96944', '27.056793', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520122, 520100, '息烽县', '息烽', '106.73769', '27.092665', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520123, 520100, '修文县', '修文', '106.59922', '26.840672', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520181, 520100, '清镇市', '清镇', '106.470276', '26.551289', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520200, 520000, '六盘水市', '六盘水', '104.84674', '26.584642', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520201, 520200, '钟山区', '钟山', '104.846245', '26.584805', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520203, 520200, '六枝特区', '六枝特', '105.474236', '26.210663', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520221, 520200, '水城县', '水城', '104.95685', '26.540478', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520281, 520200, '盘州市', '盘州', '104.47158', '25.70993', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520300, 520000, '遵义市', '遵义', '106.93726', '27.706627', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520302, 520300, '红花岗区', '红花岗', '106.94379', '27.694395', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520303, 520300, '汇川区', '汇川', '106.93726', '27.706627', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520304, 520300, '播州区', '播州', '106.82922', '27.53625', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520322, 520300, '桐梓县', '桐梓', '106.82659', '28.13156', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520323, 520300, '绥阳县', '绥阳', '107.191025', '27.951342', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520324, 520300, '正安县', '正安', '107.44187', '28.550337', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520325, 520300, '道真仡佬族苗族自治县', '道真', '107.60534', '28.880089', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520326, 520300, '务川仡佬族苗族自治县', '务川', '107.887856', '28.521566', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520327, 520300, '凤冈县', '凤冈', '107.72202', '27.960857', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520328, 520300, '湄潭县', '湄潭', '107.485725', '27.765839', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520329, 520300, '余庆县', '余庆', '107.89256', '27.221552', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520330, 520300, '习水县', '习水', '106.20095', '28.327826', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520381, 520300, '赤水市', '赤水', '105.69811', '28.587057', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520382, 520300, '仁怀市', '仁怀', '106.412476', '27.803377', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520400, 520000, '安顺市', '安顺', '105.93219', '26.245544', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520402, 520400, '西秀区', '西秀', '105.94617', '26.248323', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520403, 520400, '平坝区', '平坝', '106.2553', '26.40574', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520422, 520400, '普定县', '普定', '105.745605', '26.305794', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520423, 520400, '镇宁布依族苗族自治县', '镇宁', '105.768654', '26.056095', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520424, 520400, '关岭布依族苗族自治县', '关岭', '105.618454', '25.944248', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520425, 520400, '紫云苗族布依族自治县', '紫云', '106.08452', '25.751568', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520500, 520000, '毕节市', '毕节', '', '', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520502, 520500, '七星关区', '七星关', '105.30504', '27.29847', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520521, 520500, '大方县', '大方', '105.613', '27.14161', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520522, 520500, '黔西县', '黔西', '106.0323', '27.00866', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520523, 520500, '金沙县', '金沙', '106.22014', '27.45922', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520524, 520500, '织金县', '织金', '105.77488', '26.66301', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520525, 520500, '纳雍县', '纳雍', '105.38269', '26.7777', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520526, 520500, '威宁彝族回族苗族自治县', '威宁彝族回族苗族自治县', '104.27872', '26.85641', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520527, 520500, '赫章县', '赫章', '104.7274', '27.12328', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520600, 520000, '铜仁市', '铜仁', '', '', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520602, 520600, '碧江区', '碧江', '109.26433', '27.81621', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520603, 520600, '万山区', '万山', '109.21369', '27.51796', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520621, 520600, '江口县', '江口', '108.83967', '27.69956', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520622, 520600, '玉屏侗族自治县', '玉屏侗族自治县', '108.91212', '27.23637', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520623, 520600, '石阡县', '石阡', '108.2233', '27.51382', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520624, 520600, '思南县', '思南', '108.2528', '27.93886', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520625, 520600, '印江土家族苗族自治县', '印江土家族苗族自治县', '108.40958', '27.9941', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520626, 520600, '德江县', '德江', '108.11987', '28.26408', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520627, 520600, '沿河土家族自治县', '沿河土家族自治县', '108.50301', '28.56397', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (520628, 520600, '松桃苗族自治县', '松桃苗族自治县', '109.20316', '28.15414', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522300, 520000, '黔西南布依族苗族自治州', '黔西南', '104.89797', '25.08812', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522301, 522300, '兴义市', '兴义', '104.89798', '25.088598', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522302, 522300, '兴仁市', '兴仁', '105.18639', '25.43511', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522323, 522300, '普安县', '普安', '104.955345', '25.786404', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522324, 522300, '晴隆县', '晴隆', '105.21877', '25.832882', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522325, 522300, '贞丰县', '贞丰', '105.65013', '25.385752', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522326, 522300, '望谟县', '望谟', '106.09156', '25.166668', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522327, 522300, '册亨县', '册亨', '105.81241', '24.983337', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522328, 522300, '安龙县', '安龙', '105.4715', '25.10896', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522600, 520000, '黔东南苗族侗族自治州', '黔东南', '107.977486', '26.583351', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522601, 522600, '凯里市', '凯里', '107.97754', '26.582964', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522622, 522600, '黄平县', '黄平', '107.90134', '26.896973', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522623, 522600, '施秉县', '施秉', '108.12678', '27.034657', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522624, 522600, '三穗县', '三穗', '108.68112', '26.959885', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522625, 522600, '镇远县', '镇远', '108.42365', '27.050234', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522626, 522600, '岑巩县', '岑巩', '108.81646', '27.173244', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522627, 522600, '天柱县', '天柱', '109.2128', '26.909683', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522628, 522600, '锦屏县', '锦屏', '109.20252', '26.680626', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522629, 522600, '剑河县', '剑河', '108.4405', '26.727348', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522630, 522600, '台江县', '台江', '108.31464', '26.669138', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522631, 522600, '黎平县', '黎平', '109.136505', '26.230637', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522632, 522600, '榕江县', '榕江', '108.52103', '25.931086', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522633, 522600, '从江县', '从江', '108.91265', '25.747059', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522634, 522600, '雷山县', '雷山', '108.07961', '26.381027', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522635, 522600, '麻江县', '麻江', '107.59317', '26.494802', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522636, 522600, '丹寨县', '丹寨', '107.79481', '26.199497', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522700, 520000, '黔南布依族苗族自治州', '黔南', '107.51716', '26.258219', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522701, 522700, '都匀市', '都匀', '107.51702', '26.258205', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522702, 522700, '福泉市', '福泉', '107.51351', '26.702509', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522722, 522700, '荔波县', '荔波', '107.8838', '25.41224', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522723, 522700, '贵定县', '贵定', '107.23359', '26.580807', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522725, 522700, '瓮安县', '瓮安', '107.47842', '27.06634', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522726, 522700, '独山县', '独山', '107.542755', '25.826283', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522727, 522700, '平塘县', '平塘', '107.32405', '25.831802', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522728, 522700, '罗甸县', '罗甸', '106.75001', '25.429893', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522729, 522700, '长顺县', '长顺', '106.44737', '26.022116', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522730, 522700, '龙里县', '龙里', '106.97773', '26.448809', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522731, 522700, '惠水县', '惠水', '106.657845', '26.128637', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (522732, 522700, '三都水族自治县', '三都', '107.87747', '25.985184', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530000, 0, '云南省', '云南', '102.71225', '25.04061', 1, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530100, 530000, '昆明市', '昆明', '102.71225', '25.04061', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530102, 530100, '五华区', '五华', '102.704414', '25.042166', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530103, 530100, '盘龙区', '盘龙', '102.72904', '25.070238', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530111, 530100, '官渡区', '官渡', '102.723434', '25.021212', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530112, 530100, '西山区', '西山', '102.7059', '25.02436', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530113, 530100, '东川区', '东川', '103.182', '26.08349', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530114, 530100, '呈贡区', '呈贡', '102.82147', '24.88554', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530115, 530100, '晋宁区', '晋宁', '102.59559', '24.66982', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530124, 530100, '富民县', '富民', '102.49789', '25.219667', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530125, 530100, '宜良县', '宜良', '103.14599', '24.918215', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530126, 530100, '石林彝族自治县', '石林', '103.271965', '24.754545', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530127, 530100, '嵩明县', '嵩明', '103.03878', '25.335087', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530128, 530100, '禄劝彝族苗族自治县', '禄劝', '102.46905', '25.556534', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530129, 530100, '寻甸回族彝族自治县', '寻甸', '103.25759', '25.559475', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530181, 530100, '安宁市', '安宁', '102.48554', '24.921785', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530300, 530000, '曲靖市', '曲靖', '103.79785', '25.501556', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530302, 530300, '麒麟区', '麒麟', '103.79806', '25.501268', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530303, 530300, '沾益区', '沾益', '103.82183', '25.60167', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530304, 530300, '马龙区', '马龙', '103.57834', '25.42807', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530322, 530300, '陆良县', '陆良', '103.655235', '25.022879', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530323, 530300, '师宗县', '师宗', '103.993805', '24.825682', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530324, 530300, '罗平县', '罗平', '104.309265', '24.885708', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530325, 530300, '富源县', '富源', '104.25692', '25.67064', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530326, 530300, '会泽县', '会泽', '103.30004', '26.41286', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530381, 530300, '宣威市', '宣威', '104.09554', '26.227777', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530400, 530000, '玉溪市', '玉溪', '102.54391', '24.35046', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530402, 530400, '红塔区', '红塔', '102.543465', '24.350754', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530403, 530400, '江川区', '江川', '102.75376', '24.28744', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530423, 530400, '通海县', '通海', '102.76004', '24.112206', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530424, 530400, '华宁县', '华宁', '102.928986', '24.189808', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530425, 530400, '易门县', '易门', '102.16211', '24.669598', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530426, 530400, '峨山彝族自治县', '峨山', '102.40436', '24.173256', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530427, 530400, '新平彝族傣族自治县', '新平', '101.990906', '24.0664', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530428, 530400, '元江哈尼族彝族傣族自治县', '元江', '101.99966', '23.597618', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530481, 530400, '澄江市', '澄江', '102.90819', '24.67379', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530500, 530000, '保山市', '保山', '99.16713', '25.111801', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530502, 530500, '隆阳区', '隆阳', '99.165825', '25.112144', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530521, 530500, '施甸县', '施甸', '99.18376', '24.730846', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530523, 530500, '龙陵县', '龙陵', '98.693565', '24.591911', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530524, 530500, '昌宁县', '昌宁', '99.61234', '24.823662', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530581, 530500, '腾冲市', '腾冲', '98.49097', '25.02053', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530600, 530000, '昭通市', '昭通', '103.71722', '27.337', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530602, 530600, '昭阳区', '昭阳', '103.71727', '27.336636', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530621, 530600, '鲁甸县', '鲁甸', '103.54933', '27.191637', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530622, 530600, '巧家县', '巧家', '102.92928', '26.9117', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530623, 530600, '盐津县', '盐津', '104.23506', '28.106922', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530624, 530600, '大关县', '大关', '103.89161', '27.747114', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530625, 530600, '永善县', '永善', '103.63732', '28.231525', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530626, 530600, '绥江县', '绥江', '103.9611', '28.599953', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530627, 530600, '镇雄县', '镇雄', '104.873055', '27.436268', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530628, 530600, '彝良县', '彝良', '104.04849', '27.627424', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530629, 530600, '威信县', '威信', '105.04869', '27.843382', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530681, 530600, '水富市', '水富', '104.41562', '28.63002', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530700, 530000, '丽江市', '丽江', '100.233025', '26.872108', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530702, 530700, '古城区', '古城', '100.23441', '26.872229', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530721, 530700, '玉龙纳西族自治县', '玉龙', '100.23831', '26.830593', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530722, 530700, '永胜县', '永胜', '100.7509', '26.685623', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530723, 530700, '华坪县', '华坪', '101.2678', '26.628834', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530724, 530700, '宁蒗彝族自治县', '宁蒗', '100.852425', '27.281109', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530800, 530000, '普洱市', '普洱', '100.97234', '22.77732', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530802, 530800, '思茅区', '思茅', '100.97323', '22.776594', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530821, 530800, '宁洱哈尼族彝族自治县', '宁洱', '101.04524', '23.062508', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530822, 530800, '墨江哈尼族自治县', '墨江', '101.68761', '23.428165', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530823, 530800, '景东彝族自治县', '景东', '100.84001', '24.448523', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530824, 530800, '景谷傣族彝族自治县', '景谷', '100.70142', '23.500278', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530825, 530800, '镇沅彝族哈尼族拉祜族自治县', '镇沅', '101.10851', '24.005713', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530826, 530800, '江城哈尼族彝族自治县', '江城', '101.859146', '22.58336', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530827, 530800, '孟连傣族拉祜族佤族自治县', '孟连', '99.5854', '22.325924', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530828, 530800, '澜沧拉祜族自治县', '澜沧', '99.9312', '22.553083', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530829, 530800, '西盟佤族自治县', '西盟', '99.594376', '22.644423', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530900, 530000, '临沧市', '临沧', '100.08697', '23.886566', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530902, 530900, '临翔区', '临翔', '100.08649', '23.886562', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530921, 530900, '凤庆县', '凤庆', '99.91871', '24.592737', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530922, 530900, '云县', '云县', '100.12563', '24.439026', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530923, 530900, '永德县', '永德', '99.25368', '24.028158', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530924, 530900, '镇康县', '镇康', '98.82743', '23.761415', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530925, 530900, '双江拉祜族佤族布朗族傣族自治县', '双江', '99.82442', '23.477476', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530926, 530900, '耿马傣族佤族自治县', '耿马', '99.4025', '23.534578', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (530927, 530900, '沧源佤族自治县', '沧源', '99.2474', '23.146887', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532300, 530000, '楚雄彝族自治州', '楚雄', '101.54604', '25.041988', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532301, 532300, '楚雄市', '楚雄', '101.54614', '25.040913', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532322, 532300, '双柏县', '双柏', '101.63824', '24.685095', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532323, 532300, '牟定县', '牟定', '101.543045', '25.31211', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532324, 532300, '南华县', '南华', '101.274994', '25.192408', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532325, 532300, '姚安县', '姚安', '101.238396', '25.505404', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532326, 532300, '大姚县', '大姚', '101.3236', '25.722347', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532327, 532300, '永仁县', '永仁', '101.67117', '26.056316', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532328, 532300, '元谋县', '元谋', '101.870834', '25.703314', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532329, 532300, '武定县', '武定', '102.406784', '25.5301', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532331, 532300, '禄丰县', '禄丰', '102.07569', '25.14327', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532500, 530000, '红河哈尼族彝族自治州', '红河', '103.384186', '23.366776', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532501, 532500, '个旧市', '个旧', '103.154755', '23.360382', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532502, 532500, '开远市', '开远', '103.25868', '23.713833', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532503, 532500, '蒙自市', '蒙自', '103.36481', '23.39622', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532504, 532500, '弥勒市', '弥勒', '103.41499', '24.41059', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532523, 532500, '屏边苗族自治县', '屏边', '103.687225', '22.987013', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532524, 532500, '建水县', '建水', '102.820496', '23.618387', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532525, 532500, '石屏县', '石屏', '102.48447', '23.712568', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532527, 532500, '泸西县', '泸西', '103.75962', '24.532368', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532528, 532500, '元阳县', '元阳', '102.83706', '23.219772', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532529, 532500, '红河县', '红河', '102.42121', '23.36919', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532530, 532500, '金平苗族瑶族傣族自治县', '金平', '103.228355', '22.779982', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532531, 532500, '绿春县', '绿春', '102.39286', '22.99352', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532532, 532500, '河口瑶族自治县', '河口', '103.96159', '22.507563', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532600, 530000, '文山壮族苗族自治州', '文山', '104.24401', '23.36951', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532601, 532600, '文山市', '文山', '104.233', '23.38678', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532622, 532600, '砚山县', '砚山', '104.34399', '23.6123', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532623, 532600, '西畴县', '西畴', '104.67571', '23.437439', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532624, 532600, '麻栗坡县', '麻栗坡', '104.7019', '23.124203', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532625, 532600, '马关县', '马关', '104.39862', '23.011723', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532626, 532600, '丘北县', '丘北', '104.19437', '24.040981', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532627, 532600, '广南县', '广南', '105.05669', '24.050272', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532628, 532600, '富宁县', '富宁', '105.62856', '23.626493', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532800, 530000, '西双版纳傣族自治州', '西双版纳', '100.79794', '22.001724', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532801, 532800, '景洪市', '景洪', '100.79795', '22.002087', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532822, 532800, '勐海县', '勐海', '100.44829', '21.955866', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532823, 532800, '勐腊县', '勐腊', '101.567055', '21.479448', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532900, 530000, '大理白族自治州', '大理', '100.22567', '25.589449', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532901, 532900, '大理市', '大理', '100.24137', '25.593067', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532922, 532900, '漾濞彝族自治县', '漾濞', '99.95797', '25.669542', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532923, 532900, '祥云县', '祥云', '100.55402', '25.477072', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532924, 532900, '宾川县', '宾川', '100.57896', '25.825905', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532925, 532900, '弥渡县', '弥渡', '100.49067', '25.342594', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532926, 532900, '南涧彝族自治县', '南涧', '100.518684', '25.041279', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532927, 532900, '巍山彝族回族自治县', '巍山', '100.30793', '25.23091', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532928, 532900, '永平县', '永平', '99.53354', '25.46128', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532929, 532900, '云龙县', '云龙', '99.3694', '25.884954', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532930, 532900, '洱源县', '洱源', '99.951706', '26.111183', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532931, 532900, '剑川县', '剑川', '99.90588', '26.530066', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (532932, 532900, '鹤庆县', '鹤庆', '100.17338', '26.55839', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (533100, 530000, '德宏傣族景颇族自治州', '德宏', '98.57836', '24.436693', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (533102, 533100, '瑞丽市', '瑞丽', '97.85588', '24.010735', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (533103, 533100, '芒市', '芒市', '98.57761', '24.436699', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (533122, 533100, '梁河县', '梁河', '98.298195', '24.80742', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (533123, 533100, '盈江县', '盈江', '97.93393', '24.709541', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (533124, 533100, '陇川县', '陇川', '97.79444', '24.184065', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (533300, 530000, '怒江傈僳族自治州', '怒江', '98.8543', '25.850948', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (533301, 533300, '泸水市', '泸水', '98.85804', '25.82306', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (533323, 533300, '福贡县', '福贡', '98.86742', '26.902739', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (533324, 533300, '贡山独龙族怒族自治县', '贡山', '98.66614', '27.738054', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (533325, 533300, '兰坪白族普米族自治县', '兰坪', '99.42138', '26.453838', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (533400, 530000, '迪庆藏族自治州', '迪庆', '99.70647', '27.826853', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (533401, 533400, '香格里拉市', '香格里拉', '99.74317', '27.84254', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (533422, 533400, '德钦县', '德钦', '98.91506', '28.483273', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (533423, 533400, '维西傈僳族自治县', '维西', '99.286354', '27.180948', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540000, 0, '西藏自治区', '西藏', '91.13221', '29.66036', 1, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540100, 540000, '拉萨市', '拉萨', '91.13221', '29.66036', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540102, 540100, '城关区', '城关', '91.13291', '29.659472', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540103, 540100, '堆龙德庆区', '堆龙德庆', '91.00338', '29.64602', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540104, 540100, '达孜区', '达孜', '91.34979', '29.66933', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540121, 540100, '林周县', '林周', '91.26184', '29.895754', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540122, 540100, '当雄县', '当雄', '91.10355', '30.47482', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540123, 540100, '尼木县', '尼木', '90.16554', '29.431347', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540124, 540100, '曲水县', '曲水', '90.73805', '29.349895', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540127, 540100, '墨竹工卡县', '墨竹工卡', '91.731155', '29.834658', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540200, 540000, '日喀则市', '日喀则', '', '', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540202, 540200, '桑珠孜区', '桑珠孜', '88.88697', '29.26969', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540221, 540200, '南木林县', '南木林', '89.09936', '29.68224', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540222, 540200, '江孜县', '江孜', '89.60558', '28.91152', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540223, 540200, '定日县', '定日', '87.12607', '28.65874', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540224, 540200, '萨迦县', '萨迦', '88.02172', '28.89919', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540225, 540200, '拉孜县', '拉孜', '87.63718', '29.08164', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540226, 540200, '昂仁县', '昂仁', '87.23617', '29.29482', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540227, 540200, '谢通门县', '谢通门', '88.26166', '29.43234', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540228, 540200, '白朗县', '白朗', '89.26156', '29.10919', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540229, 540200, '仁布县', '仁布', '89.842', '29.23089', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540230, 540200, '康马县', '康马', '89.68169', '28.55567', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540231, 540200, '定结县', '定结', '87.76606', '28.36408', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540232, 540200, '仲巴县', '仲巴', '84.02454', '29.72419', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540233, 540200, '亚东县', '亚东', '88.90708', '27.48592', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540234, 540200, '吉隆县', '吉隆', '85.29737', '28.85254', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540235, 540200, '聂拉木县', '聂拉木', '85.98232', '28.15499', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540236, 540200, '萨嘎县', '萨嘎', '85.23421', '29.32943', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540237, 540200, '岗巴县', '岗巴', '88.52015', '28.2746', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540300, 540000, '昌都市', '昌都', '', '', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540302, 540300, '卡若区', '卡若', '97.18039', '31.13831', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540321, 540300, '江达县', '江达', '98.21822', '31.49968', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540322, 540300, '贡觉县', '贡觉', '98.2708', '30.86016', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540323, 540300, '类乌齐县', '类乌齐', '96.6002', '31.21155', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540324, 540300, '丁青县', '丁青', '95.59572', '31.4125', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540325, 540300, '察雅县', '察雅', '97.56877', '30.65363', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540326, 540300, '八宿县', '八宿', '96.91785', '30.0532', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540327, 540300, '左贡县', '左贡', '97.84085', '29.67091', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540328, 540300, '芒康县', '芒康', '98.59312', '29.68008', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540329, 540300, '洛隆县', '洛隆', '95.82482', '30.74181', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540330, 540300, '边坝县', '边坝', '94.7079', '30.93345', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540400, 540000, '林芝市', '林芝', '', '', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540402, 540400, '巴宜区', '巴宜', '94.36119', '29.63654', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540421, 540400, '工布江达县', '工布江达', '93.24611', '29.88531', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540422, 540400, '米林县', '米林', '94.21315', '29.21607', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540423, 540400, '墨脱县', '墨脱', '95.33304', '29.32521', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540424, 540400, '波密县', '波密', '95.76761', '29.85903', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540425, 540400, '察隅县', '察隅', '97.46687', '28.66154', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540426, 540400, '朗县', '朗县', '93.07482', '29.04607', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540500, 540000, '山南市', '山南', '', '', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540502, 540500, '乃东区', '乃东', '91.76141', '29.22484', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540521, 540500, '扎囊县', '扎囊', '91.33735', '29.245', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540522, 540500, '贡嘎县', '贡嘎', '90.98421', '29.28947', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540523, 540500, '桑日县', '桑日', '92.01579', '29.25906', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540524, 540500, '琼结县', '琼结', '91.68385', '29.02464', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540525, 540500, '曲松县', '曲松', '92.20222', '29.06277', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540526, 540500, '措美县', '措美', '91.43361', '28.43793', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540527, 540500, '洛扎县', '洛扎', '90.85998', '28.38569', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540528, 540500, '加查县', '加查', '92.59387', '29.14023', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540529, 540500, '隆子县', '隆子', '92.46177', '28.40681', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540530, 540500, '错那县', '错那', '91.9571', '27.99099', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540531, 540500, '浪卡子县', '浪卡子', '90.40011', '28.96768', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540600, 540000, '那曲市', '那曲', '', '', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540602, 540600, '色尼区', '色尼', '92.05355', '31.46988', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540621, 540600, '嘉黎县', '嘉黎', '93.23236', '30.64087', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540622, 540600, '比如县', '比如', '93.6813', '31.47785', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540623, 540600, '聂荣县', '聂荣', '92.30327', '32.10784', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540624, 540600, '安多县', '安多', '91.68258', '32.265', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540625, 540600, '申扎县', '申扎', '88.70982', '30.93043', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540626, 540600, '索县', '索县', '93.78556', '31.88673', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540627, 540600, '班戈县', '班戈', '90.00987', '31.39199', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540628, 540600, '巴青县', '巴青', '94.05345', '31.9184', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540629, 540600, '尼玛县', '尼玛', '87.23691', '31.78448', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (540630, 540600, '双湖县', '双湖', '88.83691', '33.18763', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (542500, 540000, '阿里地区', '阿里', '80.1055', '32.503185', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (542521, 542500, '普兰县', '普兰', '81.17759', '30.291897', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (542522, 542500, '札达县', '札达', '79.80319', '31.478586', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (542523, 542500, '噶尔县', '噶尔', '80.105', '32.503372', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (542524, 542500, '日土县', '日土', '79.73193', '33.382454', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (542525, 542500, '革吉县', '革吉', '81.1429', '32.38919', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (542526, 542500, '改则县', '改则', '84.062386', '32.302074', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (542527, 542500, '措勤县', '措勤', '85.159256', '31.016773', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610000, 0, '陕西省', '陕西', '108.94802', '34.26316', 1, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610100, 610000, '西安市', '西安', '108.94802', '34.26316', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610102, 610100, '新城区', '新城', '108.9599', '34.26927', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610103, 610100, '碑林区', '碑林', '108.94699', '34.25106', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610104, 610100, '莲湖区', '莲湖', '108.9332', '34.2656', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610111, 610100, '灞桥区', '灞桥', '109.06726', '34.267452', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610112, 610100, '未央区', '未央', '108.94602', '34.30823', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610113, 610100, '雁塔区', '雁塔', '108.92659', '34.21339', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610114, 610100, '阎良区', '阎良', '109.22802', '34.66214', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610115, 610100, '临潼区', '临潼', '109.21399', '34.372066', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610116, 610100, '长安区', '长安', '108.94158', '34.157097', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610117, 610100, '高陵区', '高陵', '109.08822', '34.53487', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610118, 610100, '鄠邑区', '鄠邑', '108.60494', '34.10847', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610122, 610100, '蓝田县', '蓝田', '109.317635', '34.15619', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610124, 610100, '周至县', '周至', '108.21647', '34.161533', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610200, 610000, '铜川市', '铜川', '108.97961', '34.91658', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610202, 610200, '王益区', '王益', '109.07586', '35.0691', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610203, 610200, '印台区', '印台', '109.100815', '35.111927', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610204, 610200, '耀州区', '耀州', '108.96254', '34.910206', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610222, 610200, '宜君县', '宜君', '109.11828', '35.398766', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610300, 610000, '宝鸡市', '宝鸡', '107.14487', '34.369316', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610302, 610300, '渭滨区', '渭滨', '107.14447', '34.37101', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610303, 610300, '金台区', '金台', '107.14994', '34.37519', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610304, 610300, '陈仓区', '陈仓', '107.383644', '34.35275', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610322, 610300, '凤翔县', '凤翔', '107.40057', '34.521667', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610323, 610300, '岐山县', '岐山', '107.624466', '34.44296', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610324, 610300, '扶风县', '扶风', '107.89142', '34.375496', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610326, 610300, '眉县', '眉县', '107.75237', '34.272137', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610327, 610300, '陇县', '陇县', '106.85706', '34.89326', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610328, 610300, '千阳县', '千阳', '107.13299', '34.642586', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610329, 610300, '麟游县', '麟游', '107.79661', '34.677715', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610330, 610300, '凤县', '凤县', '106.525215', '33.912464', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610331, 610300, '太白县', '太白', '107.316536', '34.059216', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610400, 610000, '咸阳市', '咸阳', '108.70512', '34.33344', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610402, 610400, '秦都区', '秦都', '108.69864', '34.3298', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610403, 610400, '杨陵区', '杨陵', '108.08635', '34.27135', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610404, 610400, '渭城区', '渭城', '108.73096', '34.336845', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610422, 610400, '三原县', '三原', '108.94348', '34.613995', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610423, 610400, '泾阳县', '泾阳', '108.83784', '34.528492', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610424, 610400, '乾县', '乾县', '108.247406', '34.52726', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610425, 610400, '礼泉县', '礼泉', '108.428314', '34.482582', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610426, 610400, '永寿县', '永寿', '108.14313', '34.69262', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610428, 610400, '长武县', '长武', '107.79584', '35.206123', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610429, 610400, '旬邑县', '旬邑', '108.337234', '35.112232', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610430, 610400, '淳化县', '淳化', '108.58118', '34.79797', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610431, 610400, '武功县', '武功', '108.21286', '34.25973', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610481, 610400, '兴平市', '兴平', '108.488495', '34.297134', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610482, 610400, '彬州市', '彬州', '108.08108', '35.03565', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610500, 610000, '渭南市', '渭南', '109.502884', '34.499382', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610502, 610500, '临渭区', '临渭', '109.503296', '34.50127', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610503, 610500, '华州区', '华州', '109.7719', '34.51259', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610522, 610500, '潼关县', '潼关', '110.24726', '34.544514', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610523, 610500, '大荔县', '大荔', '109.94312', '34.79501', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610524, 610500, '合阳县', '合阳', '110.14798', '35.2371', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610525, 610500, '澄城县', '澄城', '109.93761', '35.184', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610526, 610500, '蒲城县', '蒲城', '109.58965', '34.956036', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610527, 610500, '白水县', '白水', '109.59431', '35.17729', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610528, 610500, '富平县', '富平', '109.18717', '34.746677', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610581, 610500, '韩城市', '韩城', '110.45239', '35.47524', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610582, 610500, '华阴市', '华阴', '110.08952', '34.565357', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610600, 610000, '延安市', '延安', '109.49081', '36.59654', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610602, 610600, '宝塔区', '宝塔', '109.49069', '36.59629', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610603, 610600, '安塞区', '安塞', '109.32897', '36.86373', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610621, 610600, '延长县', '延长', '110.01296', '36.578304', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610622, 610600, '延川县', '延川', '110.190315', '36.882065', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610625, 610600, '志丹县', '志丹', '108.7689', '36.823032', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610626, 610600, '吴起县', '吴起', '108.17698', '36.92485', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610627, 610600, '甘泉县', '甘泉', '109.34961', '36.27773', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610628, 610600, '富县', '富县', '109.38413', '35.996494', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610629, 610600, '洛川县', '洛川', '109.435715', '35.762135', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610630, 610600, '宜川县', '宜川', '110.17554', '36.050392', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610631, 610600, '黄龙县', '黄龙', '109.83502', '35.583275', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610632, 610600, '黄陵县', '黄陵', '109.26247', '35.580166', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610681, 610600, '子长市', '子长', '109.67538', '37.14258', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610700, 610000, '汉中市', '汉中', '107.02862', '33.077667', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610702, 610700, '汉台区', '汉台', '107.02824', '33.077675', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610703, 610700, '南郑区', '南郑', '106.93624', '32.99932', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610722, 610700, '城固县', '城固', '107.32989', '33.1531', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610723, 610700, '洋县', '洋县', '107.549965', '33.22328', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610724, 610700, '西乡县', '西乡', '107.76586', '32.98796', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610725, 610700, '勉县', '勉县', '106.680176', '33.155617', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610726, 610700, '宁强县', '宁强', '106.25739', '32.830807', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610727, 610700, '略阳县', '略阳', '106.1539', '33.32964', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610728, 610700, '镇巴县', '镇巴', '107.89531', '32.535854', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610729, 610700, '留坝县', '留坝', '106.92438', '33.61334', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610730, 610700, '佛坪县', '佛坪', '107.98858', '33.520744', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610800, 610000, '榆林市', '榆林', '109.741196', '38.29016', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610802, 610800, '榆阳区', '榆阳', '109.74791', '38.299267', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610803, 610800, '横山区', '横山', '109.29315', '37.95871', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610822, 610800, '府谷县', '府谷', '111.06965', '39.029243', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610824, 610800, '靖边县', '靖边', '108.80567', '37.596085', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610825, 610800, '定边县', '定边', '107.60128', '37.59523', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610826, 610800, '绥德县', '绥德', '110.26537', '37.5077', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610827, 610800, '米脂县', '米脂', '110.17868', '37.759083', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610828, 610800, '佳县', '佳县', '110.49337', '38.0216', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610829, 610800, '吴堡县', '吴堡', '110.73931', '37.451923', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610830, 610800, '清涧县', '清涧', '110.12146', '37.087704', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610831, 610800, '子洲县', '子洲', '110.03457', '37.611572', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610881, 610800, '神木市', '神木', '110.49896', '38.84239', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610900, 610000, '安康市', '安康', '109.029274', '32.6903', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610902, 610900, '汉滨区', '汉滨', '109.0291', '32.69082', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610921, 610900, '汉阴县', '汉阴', '108.51095', '32.89112', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610922, 610900, '石泉县', '石泉', '108.25051', '33.038513', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610923, 610900, '宁陕县', '宁陕', '108.31371', '33.312183', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610924, 610900, '紫阳县', '紫阳', '108.53779', '32.520176', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610925, 610900, '岚皋县', '岚皋', '108.900665', '32.31069', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610926, 610900, '平利县', '平利', '109.36186', '32.38793', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610927, 610900, '镇坪县', '镇坪', '109.526436', '31.883394', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610928, 610900, '旬阳县', '旬阳', '109.36815', '32.83357', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (610929, 610900, '白河县', '白河', '110.11419', '32.809483', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (611000, 610000, '商洛市', '商洛', '109.93977', '33.86832', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (611002, 611000, '商州区', '商州', '109.93768', '33.86921', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (611021, 611000, '洛南县', '洛南', '110.14571', '34.0885', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (611022, 611000, '丹凤县', '丹凤', '110.33191', '33.69471', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (611023, 611000, '商南县', '商南', '110.88544', '33.526367', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (611024, 611000, '山阳县', '山阳', '109.88043', '33.53041', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (611025, 611000, '镇安县', '镇安', '109.15108', '33.42398', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (611026, 611000, '柞水县', '柞水', '109.11125', '33.682774', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620000, 0, '甘肃省', '甘肃', '103.823555', '36.05804', 1, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620100, 620000, '兰州市', '兰州', '103.823555', '36.05804', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620102, 620100, '城关区', '城关', '103.841034', '36.049114', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620103, 620100, '七里河区', '七里河', '103.784325', '36.06673', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620104, 620100, '西固区', '西固', '103.62233', '36.10037', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620105, 620100, '安宁区', '安宁', '103.72404', '36.10329', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620111, 620100, '红古区', '红古', '102.86182', '36.344177', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620121, 620100, '永登县', '永登', '103.2622', '36.73443', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620122, 620100, '皋兰县', '皋兰', '103.94933', '36.331253', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620123, 620100, '榆中县', '榆中', '104.114975', '35.84443', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620200, 620000, '嘉峪关市', '嘉峪关', '98.277306', '39.78653', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620300, 620000, '金昌市', '金昌', '102.18789', '38.514236', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620302, 620300, '金川区', '金川', '102.18768', '38.513794', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620321, 620300, '永昌县', '永昌', '101.971954', '38.247353', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620400, 620000, '白银市', '白银', '104.17361', '36.54568', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620402, 620400, '白银区', '白银', '104.17425', '36.54565', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620403, 620400, '平川区', '平川', '104.81921', '36.72921', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620421, 620400, '靖远县', '靖远', '104.68697', '36.561424', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620422, 620400, '会宁县', '会宁', '105.05434', '35.692486', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620423, 620400, '景泰县', '景泰', '104.06639', '37.19352', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620500, 620000, '天水市', '天水', '105.725', '34.57853', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620502, 620500, '秦州区', '秦州', '105.72448', '34.578644', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620503, 620500, '麦积区', '麦积', '105.89763', '34.563503', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620521, 620500, '清水县', '清水', '106.13988', '34.75287', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620522, 620500, '秦安县', '秦安', '105.6733', '34.862354', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620523, 620500, '甘谷县', '甘谷', '105.332344', '34.747326', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620524, 620500, '武山县', '武山', '104.89169', '34.721954', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620525, 620500, '张家川回族自治县', '张家川', '106.21242', '34.993237', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620600, 620000, '武威市', '武威', '102.6347', '37.929996', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620602, 620600, '凉州区', '凉州', '102.63449', '37.93025', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620621, 620600, '民勤县', '民勤', '103.09065', '38.624622', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620622, 620600, '古浪县', '古浪', '102.89805', '37.47057', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620623, 620600, '天祝藏族自治县', '天祝', '103.14204', '36.97168', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620700, 620000, '张掖市', '张掖', '100.455475', '38.932896', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620702, 620700, '甘州区', '甘州', '100.454865', '38.931774', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620721, 620700, '肃南裕固族自治县', '肃南', '99.61709', '38.83727', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620722, 620700, '民乐县', '民乐', '100.81662', '38.434456', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620723, 620700, '临泽县', '临泽', '100.166336', '39.15215', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620724, 620700, '高台县', '高台', '99.81665', '39.37631', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620725, 620700, '山丹县', '山丹', '101.08844', '38.78484', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620800, 620000, '平凉市', '平凉', '106.68469', '35.54279', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620802, 620800, '崆峒区', '崆峒', '106.68422', '35.54173', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620821, 620800, '泾川县', '泾川', '107.36522', '35.33528', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620822, 620800, '灵台县', '灵台', '107.62059', '35.06401', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620823, 620800, '崇信县', '崇信', '107.03125', '35.30453', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620825, 620800, '庄浪县', '庄浪', '106.04198', '35.203426', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620826, 620800, '静宁县', '静宁', '105.73349', '35.52524', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620881, 620800, '华亭市', '华亭', '106.65352', '35.21756', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620900, 620000, '酒泉市', '酒泉', '98.510796', '39.744022', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620902, 620900, '肃州区', '肃州', '98.511154', '39.74386', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620921, 620900, '金塔县', '金塔', '98.90296', '39.983036', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620922, 620900, '瓜州县', '瓜州', '95.780594', '40.516525', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620923, 620900, '肃北蒙古族自治县', '肃北', '94.87728', '39.51224', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620924, 620900, '阿克塞哈萨克族自治县', '阿克塞', '94.33764', '39.63164', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620981, 620900, '玉门市', '玉门', '97.03721', '40.28682', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (620982, 620900, '敦煌市', '敦煌', '94.664276', '40.141117', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (621000, 620000, '庆阳市', '庆阳', '107.638374', '35.73422', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (621002, 621000, '西峰区', '西峰', '107.638824', '35.73371', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (621021, 621000, '庆城县', '庆城', '107.885666', '36.013504', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (621022, 621000, '环县', '环县', '107.308754', '36.56932', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (621023, 621000, '华池县', '华池', '107.98629', '36.457302', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (621024, 621000, '合水县', '合水', '108.01987', '35.819004', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (621025, 621000, '正宁县', '正宁', '108.36107', '35.490643', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (621026, 621000, '宁县', '宁县', '107.92118', '35.50201', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (621027, 621000, '镇原县', '镇原', '107.19571', '35.677807', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (621100, 620000, '定西市', '定西', '104.6263', '35.57958', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (621102, 621100, '安定区', '安定', '104.62577', '35.579765', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (621121, 621100, '通渭县', '通渭', '105.2501', '35.208923', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (621122, 621100, '陇西县', '陇西', '104.63755', '35.00341', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (621123, 621100, '渭源县', '渭源', '104.21174', '35.133022', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (621124, 621100, '临洮县', '临洮', '103.86218', '35.376232', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (621125, 621100, '漳县', '漳县', '104.46676', '34.84864', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (621126, 621100, '岷县', '岷县', '104.03988', '34.439106', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (621200, 620000, '陇南市', '陇南', '104.92938', '33.3886', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (621202, 621200, '武都区', '武都', '104.92986', '33.388157', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (621221, 621200, '成县', '成县', '105.734436', '33.739864', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (621222, 621200, '文县', '文县', '104.68245', '32.94217', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (621223, 621200, '宕昌县', '宕昌', '104.39448', '34.042656', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (621224, 621200, '康县', '康县', '105.609535', '33.328266', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (621225, 621200, '西和县', '西和', '105.299736', '34.013718', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (621226, 621200, '礼县', '礼县', '105.18162', '34.18939', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (621227, 621200, '徽县', '徽县', '106.08563', '33.767784', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (621228, 621200, '两当县', '两当', '106.30696', '33.91073', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (622900, 620000, '临夏回族自治州', '临夏', '103.212006', '35.599445', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (622901, 622900, '临夏市', '临夏市', '103.21163', '35.59941', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (622921, 622900, '临夏县', '临夏县', '102.99387', '35.49236', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (622922, 622900, '康乐县', '康乐', '103.709854', '35.371906', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (622923, 622900, '永靖县', '永靖', '103.31987', '35.938934', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (622924, 622900, '广河县', '广河', '103.57619', '35.48169', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (622925, 622900, '和政县', '和政', '103.35036', '35.425972', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (622926, 622900, '东乡族自治县', '东乡', '103.389565', '35.66383', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (622927, 622900, '积石山保安族东乡族撒拉族自治县', '积石山', '102.87747', '35.712906', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (623000, 620000, '甘南藏族自治州', '甘南', '102.91101', '34.986355', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (623001, 623000, '合作市', '合作', '102.91149', '34.985973', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (623021, 623000, '临潭县', '临潭', '103.35305', '34.69164', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (623022, 623000, '卓尼县', '卓尼', '103.50851', '34.588165', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (623023, 623000, '舟曲县', '舟曲', '104.37027', '33.782963', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (623024, 623000, '迭部县', '迭部', '103.22101', '34.055347', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (623025, 623000, '玛曲县', '玛曲', '102.07577', '33.99807', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (623026, 623000, '碌曲县', '碌曲', '102.488495', '34.589592', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (623027, 623000, '夏河县', '夏河', '102.520744', '35.20085', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (630000, 0, '青海省', '青海', '101.778915', '36.623177', 1, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (630100, 630000, '西宁市', '西宁', '101.778915', '36.623177', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (630102, 630100, '城东区', '城东', '101.7961', '36.616043', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (630103, 630100, '城中区', '城中', '101.78455', '36.62118', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (630104, 630100, '城西区', '城西', '101.76365', '36.628323', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (630105, 630100, '城北区', '城北', '101.7613', '36.64845', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (630106, 630100, '湟中区', '湟中', '101.57164', '36.50087', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (630121, 630100, '大通回族土族自治县', '大通', '101.68418', '36.931343', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (630123, 630100, '湟源县', '湟源', '101.263435', '36.68482', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (630200, 630000, '海东市', '海东', '', '', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (630202, 630200, '乐都区', '乐都', '102.40173', '36.48209', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (630203, 630200, '平安区', '平安', '102.10848', '36.50029', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (630222, 630200, '民和回族土族自治县', '民和回族土族自治县', '102.83087', '36.32026', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (630223, 630200, '互助土族自治县', '互助土族自治县', '101.95842', '36.84412', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (630224, 630200, '化隆回族自治县', '化隆回族自治县', '102.26404', '36.09493', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (630225, 630200, '循化撒拉族自治县', '循化撒拉族自治县', '102.4891', '35.8508', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632200, 630000, '海北藏族自治州', '海北', '100.90106', '36.959435', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632221, 632200, '门源回族自治县', '门源', '101.61846', '37.37663', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632222, 632200, '祁连县', '祁连', '100.24978', '38.175407', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632223, 632200, '海晏县', '海晏', '100.90049', '36.95954', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632224, 632200, '刚察县', '刚察', '100.13842', '37.326263', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632300, 630000, '黄南藏族自治州', '黄南', '102.01999', '35.517742', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632301, 632300, '同仁市', '同仁', '', '', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632322, 632300, '尖扎县', '尖扎', '102.03195', '35.938206', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632323, 632300, '泽库县', '泽库', '101.469345', '35.036842', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632324, 632300, '河南蒙古族自治县', '河南', '101.61188', '34.734524', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632500, 630000, '海南藏族自治州', '海南藏族', '100.619545', '36.280354', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632521, 632500, '共和县', '共和', '100.6196', '36.280285', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632522, 632500, '同德县', '同德', '100.57947', '35.254494', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632523, 632500, '贵德县', '贵德', '101.431854', '36.040455', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632524, 632500, '兴海县', '兴海', '99.98696', '35.58909', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632525, 632500, '贵南县', '贵南', '100.74792', '35.587086', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632600, 630000, '果洛藏族自治州', '果洛', '100.24214', '34.4736', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632621, 632600, '玛沁县', '玛沁', '100.24353', '34.473385', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632622, 632600, '班玛县', '班玛', '100.73795', '32.931587', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632623, 632600, '甘德县', '甘德', '99.90259', '33.966988', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632624, 632600, '达日县', '达日', '99.65172', '33.753258', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632625, 632600, '久治县', '久治', '101.484886', '33.430218', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632626, 632600, '玛多县', '玛多', '98.21134', '34.91528', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632700, 630000, '玉树藏族自治州', '玉树', '97.00852', '33.004047', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632701, 632700, '玉树市', '玉树', '97.00862', '32.99336', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632722, 632700, '杂多县', '杂多', '95.29343', '32.891888', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632723, 632700, '称多县', '称多', '97.11089', '33.367886', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632724, 632700, '治多县', '治多', '95.616844', '33.85232', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632725, 632700, '囊谦县', '囊谦', '96.4798', '32.203205', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632726, 632700, '曲麻莱县', '曲麻莱', '95.800674', '34.12654', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632800, 630000, '海西蒙古族藏族自治州', '海西', '97.37079', '37.374664', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632801, 632800, '格尔木市', '格尔木', '94.90578', '36.401543', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632802, 632800, '德令哈市', '德令哈', '97.37014', '37.374554', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632803, 632800, '茫崖市', '茫崖', '90.85616', '38.24763', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632821, 632800, '乌兰县', '乌兰', '98.47985', '36.93039', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632822, 632800, '都兰县', '都兰', '98.089165', '36.298553', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (632823, 632800, '天峻县', '天峻', '99.02078', '37.29906', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (640000, 0, '宁夏回族自治区', '宁夏', '106.278175', '38.46637', 1, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (640100, 640000, '银川市', '银川', '106.278175', '38.46637', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (640104, 640100, '兴庆区', '兴庆', '106.2784', '38.46747', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (640105, 640100, '西夏区', '西夏', '106.13212', '38.492424', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (640106, 640100, '金凤区', '金凤', '106.228485', '38.477352', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (640121, 640100, '永宁县', '永宁', '106.253784', '38.28043', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (640122, 640100, '贺兰县', '贺兰', '106.3459', '38.55456', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (640181, 640100, '灵武市', '灵武', '106.3347', '38.09406', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (640200, 640000, '石嘴山市', '石嘴山', '106.376175', '39.01333', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (640202, 640200, '大武口区', '大武口', '106.37665', '39.014156', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (640205, 640200, '惠农区', '惠农', '106.77551', '39.230095', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (640221, 640200, '平罗县', '平罗', '106.54489', '38.90674', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (640300, 640000, '吴忠市', '吴忠', '106.19941', '37.986164', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (640302, 640300, '利通区', '利通', '106.19942', '37.985966', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (640303, 640300, '红寺堡区', '红寺堡', '106.067314', '37.421616', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (640323, 640300, '盐池县', '盐池', '107.40541', '37.78422', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (640324, 640300, '同心县', '同心', '105.914764', '36.9829', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (640381, 640300, '青铜峡市', '青铜峡', '106.07539', '38.021507', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (640400, 640000, '固原市', '固原', '106.28524', '36.004562', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (640402, 640400, '原州区', '原州', '106.28477', '36.005337', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (640422, 640400, '西吉县', '西吉', '105.731804', '35.965385', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (640423, 640400, '隆德县', '隆德', '106.12344', '35.618233', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (640424, 640400, '泾源县', '泾源', '106.33868', '35.49344', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (640425, 640400, '彭阳县', '彭阳', '106.64151', '35.849976', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (640500, 640000, '中卫市', '中卫', '105.18957', '37.51495', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (640502, 640500, '沙坡头区', '沙坡头', '105.19054', '37.514565', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (640521, 640500, '中宁县', '中宁', '105.67578', '37.489735', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (640522, 640500, '海原县', '海原', '105.64732', '36.562008', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (650000, 0, '新疆维吾尔自治区', '新疆', '87.61773', '43.792816', 1, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (650100, 650000, '乌鲁木齐市', '乌鲁木齐', '87.61773', '43.792816', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (650102, 650100, '天山区', '天山', '87.62012', '43.79643', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (650103, 650100, '沙依巴克区', '沙依巴克', '87.59664', '43.78887', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (650104, 650100, '新市区', '新市', '87.56065', '43.87088', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (650105, 650100, '水磨沟区', '水磨沟', '87.61309', '43.816746', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (650106, 650100, '头屯河区', '头屯河', '87.42582', '43.876053', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (650107, 650100, '达坂城区', '达坂城', '88.30994', '43.36181', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (650109, 650100, '米东区', '米东', '87.6918', '43.960983', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (650121, 650100, '乌鲁木齐县', '乌鲁木齐', '1.0', '0.0', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (650200, 650000, '克拉玛依市', '克拉玛依', '84.87395', '45.595886', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (650202, 650200, '独山子区', '独山子', '84.88227', '44.327206', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (650203, 650200, '克拉玛依区', '克拉玛依', '84.86892', '45.600475', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (650204, 650200, '白碱滩区', '白碱滩', '85.12988', '45.689022', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (650205, 650200, '乌尔禾区', '乌尔禾', '85.69777', '46.08776', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (650400, 650000, '吐鲁番市', '吐鲁番', '', '', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (650402, 650400, '高昌区', '高昌', '89.18596', '42.94244', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (650421, 650400, '鄯善县', '鄯善', '90.21341', '42.86887', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (650422, 650400, '托克逊县', '托克逊', '88.65384', '42.79181', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (650500, 650000, '哈密市', '哈密', '', '', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (650502, 650500, '伊州区', '伊州', '93.51465', '42.82699', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (650521, 650500, '巴里坤哈萨克自治县', '巴里坤哈萨克自治县', '93.01654', '43.59873', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (650522, 650500, '伊吾县', '伊吾', '94.69741', '43.25451', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (652300, 650000, '昌吉回族自治州', '昌吉', '87.30401', '44.014576', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (652301, 652300, '昌吉市', '昌吉', '87.304115', '44.013184', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (652302, 652300, '阜康市', '阜康', '87.98384', '44.152153', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (652323, 652300, '呼图壁县', '呼图壁', '86.88861', '44.189342', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (652324, 652300, '玛纳斯县', '玛纳斯', '86.21769', '44.305626', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (652325, 652300, '奇台县', '奇台', '89.59144', '44.021996', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (652327, 652300, '吉木萨尔县', '吉木萨尔', '89.18129', '43.99716', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (652328, 652300, '木垒哈萨克自治县', '木垒', '90.28283', '43.832443', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (652700, 650000, '博尔塔拉蒙古自治州', '博尔塔拉', '82.074776', '44.90326', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (652701, 652700, '博乐市', '博乐', '82.072235', '44.903088', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (652702, 652700, '阿拉山口市', '阿拉山口', '82.074776', '44.90326', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (652722, 652700, '精河县', '精河', '82.89294', '44.605644', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (652723, 652700, '温泉县', '温泉', '81.03099', '44.97375', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (652800, 650000, '巴音郭楞蒙古自治州', '巴音郭楞', '86.15097', '41.76855', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (652801, 652800, '库尔勒市', '库尔勒', '86.14595', '41.763123', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (652822, 652800, '轮台县', '轮台', '84.24854', '41.781265', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (652823, 652800, '尉犁县', '尉犁', '86.26341', '41.33743', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (652824, 652800, '若羌县', '若羌', '88.16881', '39.023808', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (652825, 652800, '且末县', '且末', '85.53263', '38.13856', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (652826, 652800, '焉耆回族自治县', '焉耆', '86.5698', '42.06435', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (652827, 652800, '和静县', '和静', '86.39107', '42.31716', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (652828, 652800, '和硕县', '和硕', '86.864944', '42.268864', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (652829, 652800, '博湖县', '博湖', '86.63158', '41.980167', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (652900, 650000, '阿克苏地区', '阿克苏', '80.26507', '41.17071', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (652901, 652900, '阿克苏市', '阿克苏', '80.2629', '41.171272', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (652902, 652900, '库车市', '库车', '82.96212', '41.71741', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (652922, 652900, '温宿县', '温宿', '80.24327', '41.272995', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (652924, 652900, '沙雅县', '沙雅', '82.78077', '41.22627', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (652925, 652900, '新和县', '新和', '82.610825', '41.551174', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (652926, 652900, '拜城县', '拜城', '81.86988', '41.7961', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (652927, 652900, '乌什县', '乌什', '79.230804', '41.21587', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (652928, 652900, '阿瓦提县', '阿瓦提', '80.378426', '40.63842', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (652929, 652900, '柯坪县', '柯坪', '79.04785', '40.50624', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (653000, 650000, '克孜勒苏柯尔克孜自治州', '克孜勒苏柯尔克孜', '76.17283', '39.713432', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (653001, 653000, '阿图什市', '阿图什', '76.17394', '39.7129', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (653022, 653000, '阿克陶县', '阿克陶', '75.94516', '39.14708', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (653023, 653000, '阿合奇县', '阿合奇', '78.450165', '40.93757', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (653024, 653000, '乌恰县', '乌恰', '75.25969', '39.716633', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (653100, 650000, '喀什地区', '喀什', '75.989136', '39.467663', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (653101, 653100, '喀什市', '喀什', '75.98838', '39.46786', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (653121, 653100, '疏附县', '疏附', '75.863075', '39.378307', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (653122, 653100, '疏勒县', '疏勒', '76.05365', '39.39946', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (653123, 653100, '英吉沙县', '英吉沙', '76.17429', '38.92984', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (653124, 653100, '泽普县', '泽普', '77.27359', '38.191216', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (653125, 653100, '莎车县', '莎车', '77.248886', '38.414497', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (653126, 653100, '叶城县', '叶城', '77.42036', '37.884678', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (653127, 653100, '麦盖提县', '麦盖提', '77.651535', '38.903385', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (653128, 653100, '岳普湖县', '岳普湖', '76.7724', '39.23525', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (653129, 653100, '伽师县', '伽师', '76.74198', '39.494324', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (653130, 653100, '巴楚县', '巴楚', '78.55041', '39.783478', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (653131, 653100, '塔什库尔干塔吉克自治县', '塔什库尔干', '75.228065', '37.775436', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (653200, 650000, '和田地区', '和田', '79.92533', '37.110687', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (653201, 653200, '和田市', '和田市', '79.92754', '37.108944', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (653221, 653200, '和田县', '和田县', '79.81907', '37.12003', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (653222, 653200, '墨玉县', '墨玉', '79.736626', '37.27151', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (653223, 653200, '皮山县', '皮山', '78.2823', '37.616333', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (653224, 653200, '洛浦县', '洛浦', '80.18404', '37.074375', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (653225, 653200, '策勒县', '策勒', '80.80357', '37.00167', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (653226, 653200, '于田县', '于田', '81.66785', '36.85463', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (653227, 653200, '民丰县', '民丰', '82.69235', '37.06491', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (654000, 650000, '伊犁哈萨克自治州', '伊犁', '81.31795', '43.92186', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (654002, 654000, '伊宁市', '伊宁市', '81.316345', '43.92221', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (654003, 654000, '奎屯市', '奎屯', '84.9016', '44.423447', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (654004, 654000, '霍尔果斯市', '霍尔果斯', '80.41317', '44.19865', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (654021, 654000, '伊宁县', '伊宁县', '81.52467', '43.977875', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (654022, 654000, '察布查尔锡伯自治县', '察布查尔', '81.15087', '43.838882', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (654023, 654000, '霍城县', '霍城', '80.872505', '44.04991', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (654024, 654000, '巩留县', '巩留', '82.22704', '43.481617', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (654025, 654000, '新源县', '新源', '83.25849', '43.43425', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (654026, 654000, '昭苏县', '昭苏', '81.12603', '43.157764', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (654027, 654000, '特克斯县', '特克斯', '81.84006', '43.214863', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (654028, 654000, '尼勒克县', '尼勒克', '82.50412', '43.789738', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (654200, 650000, '塔城地区', '塔城', '82.98573', '46.7463', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (654201, 654200, '塔城市', '塔城', '82.983986', '46.74628', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (654202, 654200, '乌苏市', '乌苏', '84.67763', '44.430115', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (654221, 654200, '额敏县', '额敏', '83.622116', '46.522556', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (654223, 654200, '沙湾县', '沙湾', '85.622505', '44.329544', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (654224, 654200, '托里县', '托里', '83.60469', '45.935863', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (654225, 654200, '裕民县', '裕民', '82.982155', '46.20278', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (654226, 654200, '和布克赛尔蒙古自治县', '和布克赛尔', '85.73355', '46.793', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (654300, 650000, '阿勒泰地区', '阿勒泰', '88.13963', '47.848392', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (654301, 654300, '阿勒泰市', '阿勒泰', '88.13874', '47.84891', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (654321, 654300, '布尔津县', '布尔津', '86.86186', '47.70453', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (654322, 654300, '富蕴县', '富蕴', '89.524994', '46.993107', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (654323, 654300, '福海县', '福海', '87.49457', '47.11313', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (654324, 654300, '哈巴河县', '哈巴河', '86.41896', '48.059284', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (654325, 654300, '青河县', '青河', '90.38156', '46.672447', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (654326, 654300, '吉木乃县', '吉木乃', '85.87606', '47.43463', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (659000, 650000, '省直辖县', '', '', '', 2, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (659001, 659000, '石河子市', '石河子', '86.04108', '44.305885', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (659002, 659000, '阿拉尔市', '阿拉尔', '81.28588', '40.541916', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (659003, 659000, '图木舒克市', '图木舒克', '79.07798', '39.867317', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (659004, 659000, '五家渠市', '五家渠', '87.526886', '44.1674', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (659005, 659000, '北屯市', '北屯', '87.80014', '47.36327', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (659006, 659000, '铁门关市', '铁门关', '85.67583', '41.86868', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (659007, 659000, '双河市', '双河', '82.35501', '44.84418', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (659008, 659000, '可克达拉市', '可克达拉', '81.04476', '43.94799', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (659009, 659000, '昆玉市', '昆玉', '79.29133', '37.20948', 3, 0, 1);
INSERT INTO `{PREFIX}set_city` VALUES (659010, 659000, '胡杨河市', '胡杨河', '84.827387', '44.69295', 3, 0, 1);

DROP TABLE IF EXISTS `{PREFIX}set_express`;
CREATE TABLE `{PREFIX}set_express`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '物流公司id',
  `name` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '物流公司名称',
  `code` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '物流公司编码',
  `status` tinyint(2) NULL DEFAULT 1 COMMENT '状态 1:显示 2:隐藏',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '物流公司表' ROW_FORMAT = Compact;

INSERT INTO `{PREFIX}set_express` VALUES (1, '顺丰快运', 'SFEXPRESS', 1, '2022-07-10 20:02:43', NULL);
INSERT INTO `{PREFIX}set_express` VALUES (2, '圆通速递', 'YTO', 1, '2022-07-10 20:04:24', NULL);
INSERT INTO `{PREFIX}set_express` VALUES (3, '韵达快递', 'YUNDA', 1, '2022-07-10 20:04:51', NULL);
INSERT INTO `{PREFIX}set_express` VALUES (4, '申通快递', 'STO', 1, '2022-07-10 20:05:10', NULL);
INSERT INTO `{PREFIX}set_express` VALUES (5, '中通快递', 'ZTO', 1, '2022-07-10 20:05:24', NULL);
INSERT INTO `{PREFIX}set_express` VALUES (6, '极兔速递', 'JITU', 1, '2022-07-10 20:05:36', NULL);
INSERT INTO `{PREFIX}set_express` VALUES (7, '邮政快递包裹', 'CHINAPOST', 1, '2022-07-10 20:05:53', NULL);
INSERT INTO `{PREFIX}set_express` VALUES (8, 'EMS', 'EMS', 1, '2022-07-10 20:06:25', NULL);
INSERT INTO `{PREFIX}set_express` VALUES (9, '京东物流', 'JD', 1, '2022-07-10 20:06:41', NULL);
INSERT INTO `{PREFIX}set_express` VALUES (11, '百世快递', 'HTKY', 1, '2022-07-10 20:07:41', NULL);
INSERT INTO `{PREFIX}set_express` VALUES (13, '韵达快运', 'YUNDA56', 1, '2022-07-10 20:08:14', NULL);
INSERT INTO `{PREFIX}set_express` VALUES (14, '宅急送', 'ZJS', 1, '2022-07-10 20:08:41', NULL);
INSERT INTO `{PREFIX}set_express` VALUES (15, '天天快递', 'TTKDEX', 1, '2022-09-04 11:03:24', NULL);

DROP TABLE IF EXISTS `{PREFIX}shipping_templates`;
CREATE TABLE `{PREFIX}shipping_templates`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '模板id',
  `name` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '运费模板名',
  `type` tinyint(2) NULL DEFAULT 1 COMMENT '计费方式 1:按重量 2:按件数  3:按体积',
  `sort` int(4) NULL DEFAULT 1 COMMENT '排序值，值越大越靠前',
  `is_del` tinyint(2) NULL DEFAULT 1 COMMENT '1:正常 2:删除',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '运费模板' ROW_FORMAT = Dynamic;

INSERT INTO `{PREFIX}shipping_templates` VALUES (1, '通用模板', 1, 0, 1, '2023-04-13 23:42:49', NULL);

DROP TABLE IF EXISTS `{PREFIX}shipping_templates_region`;
CREATE TABLE `{PREFIX}shipping_templates_region`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `province_id` int(11) NULL DEFAULT 0 COMMENT '省ID',
  `tpl_id` int(11) NULL DEFAULT 0 COMMENT '模板ID',
  `city_id` int(11) NULL DEFAULT 0 COMMENT '城市ID',
  `first` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '首件',
  `first_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '首件运费',
  `continue` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '续件',
  `continue_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '续件运费',
  `type` tinyint(2) NULL DEFAULT 1 COMMENT '计费方式 1:按重量 2:按件数  3:按体积',
  `uniqid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '分组标识',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '运费模板指定城市运费表' ROW_FORMAT = Dynamic;

INSERT INTO `{PREFIX}shipping_templates_region` VALUES (1, 0, 1, 0, 3.00, 6.00, 1.00, 2.00, 1, '643822f96078d');

DROP TABLE IF EXISTS `{PREFIX}sys_setting`;
CREATE TABLE `{PREFIX}sys_setting`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '配置id',
  `type` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '配置类型',
  `text` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '配置名',
  `key` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '编号',
  `value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '配置的值',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_unique`(`key`) USING BTREE,
  INDEX `idx_search`(`type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 75 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '配置表' ROW_FORMAT = Compact;

INSERT INTO `{PREFIX}sys_setting` VALUES (1, 'base', '站点开启', 'is_open', '1');
INSERT INTO `{PREFIX}sys_setting` VALUES (2, 'base', '网站名称', 'website_title', 'SparkShop');
INSERT INTO `{PREFIX}sys_setting` VALUES (3, 'base', '网站地址', 'website_url', '{DOMAIN}');
INSERT INTO `{PREFIX}sys_setting` VALUES (4, 'base', '登录页logo', 'backend_login_logo', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (5, 'base', '后台logo', 'backend_logo', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (6, 'base', '移动端登录logo', 'mobile_logo', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (7, 'base', 'ICP备案号', 'icp_no', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (8, 'base', '公安备案号', 'police_no', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (9, 'base', '统计代码', 'census_code', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (10, 'shop_base', '自动收货时间', 'auto_receive_time', '7');
INSERT INTO `{PREFIX}sys_setting` VALUES (11, 'shop_base', '警戒库存数', 'warning_store', '2');
INSERT INTO `{PREFIX}sys_setting` VALUES (12, 'shop_base', '普通商品未支付取消订单时间', 'com_unpaid_cancel_time', '1');
INSERT INTO `{PREFIX}sys_setting` VALUES (13, 'shop_base', '活动商品未支付取消订单时间', 'activity_unpaid_cancel_time', '1');
INSERT INTO `{PREFIX}sys_setting` VALUES (14, 'shop_base', '砍价未支付取消订单时间', 'cut_unpaid_cancel_time', '1');
INSERT INTO `{PREFIX}sys_setting` VALUES (15, 'shop_base', '秒杀未支付订单取消时间', 'seckill_unpaid_cancel_time', '1');
INSERT INTO `{PREFIX}sys_setting` VALUES (16, 'shop_base', '拼团未支付取消订单时间', 'collage_unpaid_cancel_time', '1');
INSERT INTO `{PREFIX}sys_setting` VALUES (17, 'shop_user_level', '用户等级启用', 'user_level_open', '1');
INSERT INTO `{PREFIX}sys_setting` VALUES (18, 'shop_user_level', '每消费1元增送积分值', 'give_points', '10');
INSERT INTO `{PREFIX}sys_setting` VALUES (19, 'shop_user_level', '签到赠送积分', 'sign_give_points', '10');
INSERT INTO `{PREFIX}sys_setting` VALUES (20, 'shop_refund', '退货收货人姓名', 'receive_user', '南京星火燎原有限公司');
INSERT INTO `{PREFIX}sys_setting` VALUES (21, 'shop_refund', '退货收货人电话', 'receive_phone', '15695212893');
INSERT INTO `{PREFIX}sys_setting` VALUES (22, 'shop_refund', '退货收货人地址', 'receive_address', '江苏省南京市雨花台区软件大道1号');
INSERT INTO `{PREFIX}sys_setting` VALUES (23, 'shop_refund', '仅退款原因', 'only_refund', '活动/优惠未生效\n空包裹\n包裹丢失\n配送超时\n未按约定时间发货\n未送货上门\n物流显示签收但实际未收到货\n不喜欢/不想要');
INSERT INTO `{PREFIX}sys_setting` VALUES (24, 'shop_refund', '退货退款原因', 'goods_refund', '7天无理由退换货\n配送超时\n未按约定时间发货\n未送货上门\n卖家发错货\n少件/漏发\n包装/商品破损/污渍\n商品信息描述不符\n使用后过敏\n已过/临近保质期\n无法溶解/结块/有异物');
INSERT INTO `{PREFIX}sys_setting` VALUES (25, 'wechat_pay', '开启', 'wechat_pay_open', '1');
INSERT INTO `{PREFIX}sys_setting` VALUES (26, 'wechat_pay', 'app_id', 'wechat_pay_app_id', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (27, 'wechat_pay', 'miniapp_id', 'wechat_miniapp_id', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (28, 'wechat_pay', 'Mchid', 'wechat_pay_mchid', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (29, 'wechat_pay', 'Key', 'wechat_pay_key', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (30, 'wechat_pay', '微信支付证书', 'wechat_pay_cert', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (31, 'wechat_pay', '微信支付证书密钥', 'wechat_pay_pem', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (32, 'alipay', '开启', 'alipay_open', '1');
INSERT INTO `{PREFIX}sys_setting` VALUES (33, 'alipay', '支付应用Appid', 'alipay_app_id', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (34, 'alipay', '支付应用私钥', 'alipay_private_key', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (35, 'alipay', '支付应用公钥', 'alipay_public_key', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (36, 'sms', '短信KeyID', 'access_key_id', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (37, 'sms', '短信KeySecret', 'access_key_secret', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (38, 'sms', '短信签名', 'sign_name', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (39, 'sms', '通用模板ID', 'com_sms_code', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (40, 'sms', '用户登录模板ID', 'login_sms_code', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (41, 'sms', '用户注册模板ID', 'reg_sms_code', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (42, 'sms', '密码找回模板ID', 'forget_sms_code', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (43, 'sms', '手机号码绑定模板ID', 'bind_sms_code', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (44, 'express', 'AppKey', 'app_key', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (45, 'express', 'AppSecret', 'app_secret', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (46, 'express', 'AppCode', 'app_code', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (47, 'store', '存储位置', 'store_way', 'local');
INSERT INTO `{PREFIX}sys_setting` VALUES (48, 'store_oss', '空间域名 Domain', 'oss_domain', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (49, 'store_oss', 'AccessKey ID', 'accesskey_id', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (50, 'store_oss', 'AccessKey Secret', 'accesskey_secret', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (51, 'store_oss', 'Bucket', 'bucket', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (52, 'store_oss', 'Endpoint', 'endpoint', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (53, 'store_qiniu', '空间域名 Domain', 'qiniu_domain', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (54, 'store_qiniu', 'accessKey', 'accesskey', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (55, 'store_qiniu', 'secretKey', 'secretkey', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (57, 'store_qiniu', '空间名称', 'qiniu_bucket', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (58, 'store_qiniu', '存储区域', 'qiniu_endpoint', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (59, 'store_tencent', '腾讯云APPID', 'tencent_appid', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (60, 'store_tencent', '空间域名 Domain', 'tencent_domain', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (61, 'store_tencent', 'SecretId', 'secret_id', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (62, 'store_tencent', 'SecretKey', 'secret_key', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (63, 'store_tencent', '存储桶名称', 'tencent_bucket', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (64, 'store_tencent', '所属地域', 'tencent_endpoint', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (65, 'base', '地址', 'address', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (66, 'base', '联系电话', 'tel', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (67, 'base', '邮箱', 'email', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (68, 'base', '微信公众号', 'wechat_qrcode', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (69, 'shop_base', '自动好评时间', 'auto_goods_appraise', '3');
INSERT INTO `{PREFIX}sys_setting` VALUES (70, 'miniapp', 'appId', 'miniapp_app_id', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (71, 'miniapp', 'AppSecret', 'miniapp_app_secret', '');
INSERT INTO `{PREFIX}sys_setting` VALUES (72, 'balance_pay', '开启', 'balance_open', '1');
INSERT INTO `{PREFIX}sys_setting` VALUES (73, 'shop_refund', '退款有效期', 'refund_validate_day', '7');
INSERT INTO `{PREFIX}sys_setting` VALUES (74, 'shop_base', '余额充值未支付订单取消时间', 'recharge_balance_cancel_time', '1');
INSERT INTO `{PREFIX}sys_setting` VALUES (75, 'base', 'h5地址', 'h5_domain', '{DOMAIN}/h5');

DROP TABLE IF EXISTS `{PREFIX}user`;
CREATE TABLE `{PREFIX}user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '用户编号',
  `group_id` int(11) NULL DEFAULT 0 COMMENT '用户分组',
  `source_id` int(11) NULL DEFAULT 0 COMMENT '来源 1:微信公众号 2:微信小程序 3:PC 4:H5 5:APP',
  `open_id` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '微信的openid',
  `nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '昵称',
  `avatar` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '头像',
  `email` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '邮箱',
  `sex` tinyint(2) NULL DEFAULT 0 COMMENT '性别 0:未知 1:男  2:女',
  `real_name` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '真实姓名',
  `password` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '用户密码',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '手机号',
  `birthday` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '生日',
  `id_card` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '身份证',
  `address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '用户住址',
  `experience` int(11) NULL DEFAULT 0 COMMENT '用户经验值',
  `vip_level` int(11) NULL DEFAULT 0 COMMENT '用户等级',
  `balance` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '用户余额',
  `integral` int(11) NULL DEFAULT 0 COMMENT '可用的积分',
  `status` tinyint(2) NULL DEFAULT 1 COMMENT '状态 1:正常 2:禁用',
  `register_time` datetime(0) NULL DEFAULT NULL COMMENT '注册时间',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_reg`(`register_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '商城用户表' ROW_FORMAT = Compact;

INSERT INTO `{PREFIX}user` VALUES (1, '6449eb5bd753d', 0, 0, '', '小白', '{DOMAIN}/storage/local/20230414/fe83e6f100973dcb10ab7177d717b576.png', '', 0, '', '536656109e7e45204f6091d96eb68b49277543df', '15812345678', '', '', '', 0, 0, 10000.00, 0, 1, '2023-04-27 00:00:00', '2023-04-27 11:26:19', NULL);

DROP TABLE IF EXISTS `{PREFIX}user_address`;
CREATE TABLE `{PREFIX}user_address`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户地址id',
  `user_id` int(11) UNSIGNED NULL DEFAULT 0 COMMENT '用户id',
  `real_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '收货人姓名',
  `phone` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '收货人电话',
  `province` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '收货人所在省',
  `city` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '收货人所在市',
  `county` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '收货人所在区',
  `detail` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '收货人详细地址',
  `post_code` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '邮编',
  `longitude` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '经度',
  `latitude` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '纬度',
  `is_default` tinyint(2) UNSIGNED NULL DEFAULT 2 COMMENT '是否默认 1:是 2:否',
  `is_del` tinyint(2) UNSIGNED NULL DEFAULT 1 COMMENT '是否删除 1:正常 2:删除',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '添加时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  INDEX `is_default`(`is_default`) USING BTREE,
  INDEX `is_del`(`is_del`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '用户地址表' ROW_FORMAT = Compact;

DROP TABLE IF EXISTS `{PREFIX}user_agreement`;
CREATE TABLE `{PREFIX}user_agreement`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '协议id',
  `type` tinyint(2) NULL DEFAULT 1 COMMENT '协议类型 1:用户协议 2:隐私协议',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '协议内容',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_type`(`type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '用户协议' ROW_FORMAT = Compact;

DROP TABLE IF EXISTS `{PREFIX}user_balance_log`;
CREATE TABLE `{PREFIX}user_balance_log`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `type` tinyint(2) NULL DEFAULT 1 COMMENT '类型 1:购买消耗  2:退款退回 3:后台修改 4:自己充值',
  `user_id` int(11) NULL DEFAULT 0 COMMENT '用户id',
  `balance` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '变动余额',
  `order_id` int(11) NULL DEFAULT 0 COMMENT '关联的订单id',
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '订单号',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '变动事由',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user`(`user_id`) USING BTREE,
  INDEX `idx_total`(`type`, `balance`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '用户余额变动记录' ROW_FORMAT = Compact;

INSERT INTO `{PREFIX}user_balance_log` VALUES (1, 3, 1, 10000.00, 0, '', '后台修改余额', '2023-04-27 11:26:30');

DROP TABLE IF EXISTS `{PREFIX}user_balance_recharge`;
CREATE TABLE `{PREFIX}user_balance_recharge`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `recharge_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '充值订单号',
  `pay_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '支付订单号',
  `user_id` int(11) NULL DEFAULT 0 COMMENT '充值用户',
  `username` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '充值用户名',
  `amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '充值金额',
  `pay_way` tinyint(2) NULL DEFAULT 1 COMMENT '支付方式 1:微信 2:支付宝',
  `status` tinyint(2) NULL DEFAULT 1 COMMENT '状态 1:待支付 2:支付成功 3:支付失败 4:超时关闭',
  `third_no` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '三方订单号',
  `return_msg` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '三方返回信息',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order`(`recharge_no`, `user_id`) USING BTREE,
  INDEX `idx_notify`(`pay_no`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '用户余额充值订单' ROW_FORMAT = Compact;

DROP TABLE IF EXISTS `{PREFIX}user_collect`;
CREATE TABLE `{PREFIX}user_collect`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int(11) NULL DEFAULT 0 COMMENT '用户id',
  `goods_id` int(11) NULL DEFAULT 0 COMMENT '商品id',
  `goods_image` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '图片',
  `price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '价格',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '收藏时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '我的收藏' ROW_FORMAT = Compact;

DROP TABLE IF EXISTS `{PREFIX}user_collection`;
CREATE TABLE `{PREFIX}user_collection`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NULL DEFAULT 0 COMMENT '用户id',
  `goods_id` int(11) NULL DEFAULT 0 COMMENT '商品id',
  `goods_name` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '商品名称',
  `goods_pic` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '商品图片',
  `price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '商品的价格',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '收藏时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user`(`user_id`, `goods_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '用户收藏表' ROW_FORMAT = Compact;

DROP TABLE IF EXISTS `{PREFIX}user_experience_log`;
CREATE TABLE `{PREFIX}user_experience_log`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user_id` int(11) NULL DEFAULT 0 COMMENT '用户id',
  `experience` int(11) NULL DEFAULT 0 COMMENT '变动积分',
  `order_id` int(11) NULL DEFAULT 0 COMMENT '关联的订单id',
  `order_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '订单号',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '变动事由',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user`(`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '用户经验变动记录' ROW_FORMAT = Compact;

DROP TABLE IF EXISTS `{PREFIX}user_group`;
CREATE TABLE `{PREFIX}user_group`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '分组id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '分组名称',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '用户分组表' ROW_FORMAT = Dynamic;

INSERT INTO `{PREFIX}user_group` VALUES (1, '老客户', '2023-04-14 22:31:55', NULL);
INSERT INTO `{PREFIX}user_group` VALUES (2, '白领', '2023-04-14 22:32:03', NULL);

DROP TABLE IF EXISTS `{PREFIX}user_integral_log`;
CREATE TABLE `{PREFIX}user_integral_log`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `type` tinyint(2) NULL DEFAULT 1 COMMENT '方式 1:购物赠送 2:退款收回',
  `user_id` int(11) NULL DEFAULT 0 COMMENT '用户id',
  `integral` int(11) NULL DEFAULT 0 COMMENT '变动积分',
  `order_id` int(11) NULL DEFAULT 0 COMMENT '关联的订单id',
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '订单号',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '变动事由',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user`(`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '用户积分变动记录' ROW_FORMAT = Compact;

DROP TABLE IF EXISTS `{PREFIX}user_label`;
CREATE TABLE `{PREFIX}user_label`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '标签id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '标签名',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '用户标签表' ROW_FORMAT = Dynamic;

INSERT INTO `{PREFIX}user_label` VALUES (1, '高价值用户', '2023-04-14 00:00:28', NULL);

DROP TABLE IF EXISTS `{PREFIX}user_label_relation`;
CREATE TABLE `{PREFIX}user_label_relation`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NULL DEFAULT 0 COMMENT '用户id',
  `label_id` int(11) NULL DEFAULT 0 COMMENT '标签id',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_userlabel`(`user_id`, `label_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '用户和标签关联表' ROW_FORMAT = Compact;

DROP TABLE IF EXISTS `{PREFIX}user_level`;
CREATE TABLE `{PREFIX}user_level`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '等级ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '等级名称',
  `level` int(5) NULL DEFAULT 1 COMMENT '等级值',
  `discount` decimal(5, 2) NULL DEFAULT 100.00 COMMENT '享受折扣',
  `experience` int(11) NULL DEFAULT 0 COMMENT '经验值',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '图标',
  `card_bg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '会员等级背景图',
  `status` tinyint(2) NULL DEFAULT 1 COMMENT '是否显示 1:显示 2:隐藏',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '等级说明',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '用户等级表' ROW_FORMAT = Dynamic;

INSERT INTO `{PREFIX}user_level` VALUES (1, 'V1', 1, 99.99, 500, '{DOMAIN}/storage/local/20230414/00ddec748361149036c84352f301fbbb.jpeg', '{DOMAIN}/storage/local/20230414/a68b0bfffa7546a701eeebc512e12bc6.jpeg', 1, '会员1级', '2022-06-26 15:27:31', NULL);
INSERT INTO `{PREFIX}user_level` VALUES (2, 'V2', 2, 99.98, 4000, '{DOMAIN}/storage/local/20230414/381ce9c5bddfb2bab039cc8dd1a6d8cd.jpeg', '{DOMAIN}/storage/local/20230414/a4a26564db0a6e971e7d0ce3dfea063a.jpeg', 1, '销售98折', '2022-09-28 09:44:09', NULL);
INSERT INTO `{PREFIX}user_level` VALUES (3, 'V3', 3, 99.97, 8000, '{DOMAIN}/storage/local/20230414/993bc45e7e502306d586a08f723aefa9.jpeg', '{DOMAIN}/storage/local/20230414/2a4dcc669d6053ce15a6d689e1e09f6b.jpeg', 1, 'V3', '2023-03-15 22:21:04', NULL);

DROP TABLE IF EXISTS `{PREFIX}user_pv`;
CREATE TABLE `{PREFIX}user_pv`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `ip` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '访问ip',
  `user_agent` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '用户访问头',
  `user_id` int(11) NULL DEFAULT 0 COMMENT '访问者',
  `user_name` varchar(155) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '访问者名',
  `visitor` tinyint(2) NULL DEFAULT 1 COMMENT '是否是游客 1:是 2:否',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_time`(`create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '用户访问表' ROW_FORMAT = Compact;

DROP TABLE IF EXISTS `{PREFIX}website_links`;
CREATE TABLE `{PREFIX}website_links`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '友链id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '友链标题',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '友链地址',
  `target` tinyint(2) NULL DEFAULT 1 COMMENT '打开方式 1:新页面 2:本页面',
  `status` tinyint(2) NULL DEFAULT 1 COMMENT '状态 1:启用 2:禁用',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '友链管理' ROW_FORMAT = Compact;

DROP TABLE IF EXISTS `{PREFIX}website_slider`;
CREATE TABLE `{PREFIX}website_slider`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '轮播id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '轮播描述',
  `type` tinyint(2) NULL DEFAULT 1 COMMENT '链接方式 1:指向商品 2:自定义',
  `target_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '链接地址',
  `pic_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '图片地址',
  `sort` tinyint(2) NULL DEFAULT 0 COMMENT '排序值',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = 'pc端幻灯管理' ROW_FORMAT = Dynamic;

INSERT INTO `{PREFIX}website_slider` VALUES (1, '家电节', 1, '/pages/product/product?id=1&order_type=1', '{DOMAIN}/storage/local/20230413/96908ed9d2ebb154ecdb811ed0066c77.png', 0, '2023-04-14 00:02:14', NULL);
