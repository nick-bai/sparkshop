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
	// 获取用户订单列表
	orderList: {
		get: async function(data = {}) {
			return await request.get('userOrder/index', data);
		}
	},
	// 订单详情
	detail: {
		get: async function(data = {}) {
			return await request.get('userOrder/detail', data);
		}
	},
	// 取消订单
	cancel: {
		get: async function(data = {}) {
			return await request.get('userOrder/cancel', data);
		}
	},
	// 去支付
	goPay: {
		post: async function(data = {}) {
			return await request.post('userOrder/goPay', data);
		}
	},
	// 确认收货
	received: {
		get: async function(data = {}) {
			return await request.get('userOrder/received', data);
		}
	},
	// 获取评价信息
	appraise: {
		get: async function(data = {}) {
			return await request.get('userOrder/appraise', data);
		}
	},
	// 提交评价信息
	doAppraise: {
		post: async function(data = {}) {
			return await request.post('userOrder/appraise', data);
		}
	},
	// 物流信息
	express: {
		get: async function(data = {}) {
			return await request.get('userOrder/express', data);
		}
	}
}