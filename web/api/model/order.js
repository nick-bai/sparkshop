// +----------------------------------------------------------------------
// | SparkShop 坚持做优秀的商城系统
// +----------------------------------------------------------------------
// | Copyright (c) 2022~2099 http://sparkshop.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://opensource.org/licenses/mit-license.php )
// +----------------------------------------------------------------------
// | Author: NickBai
// +----------------------------------------------------------------------

import request from "@/utils/request.js";

export default {
	// 准备下单
	index: {
		post: async function(data = {}) {
			return await request.post('order/index', data);
		}
	},
	// 开始试算
	trail: {
		post: async function(data = {}) {
			return await request.post('order/trail', data);
		}
	},
	// 创建订单
	createOrder: {
		post: async function(data = {}) {
			return await request.post('order/createOrder', data);
		}
	},
	// 获取基础配置
	getConfig: {
		get: async function(data = {}) {
			return await request.get('index/marketingConfig', data);
		}
	},
	// 获取订单详情
	getOrderInfo: {
		get: async function(data = {}) {
			return await request.get('order/getOrderInfo', data);
		}
	},
	// 获取支付基础配置
	getPayConf: {
		get: async function(data = {}) {
			return await request.get('order/getPayConf', data);
		}
	}
}