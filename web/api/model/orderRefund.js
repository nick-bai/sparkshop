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
			return await request.get('orderRefund/index', data);
		}
	},
	// 订单详情
	orderDetail: {
		get: async function(data = {}) {
			return await request.get('orderRefund/getDetail', data);
		}
	},
	// 退款试算
	refundTrail: {
		post: async function(data = {}) {
			return await request.post('orderRefund/refundTrail', data);
		}
	},
	// 提交退款
	refund: {
		post: async function(data = {}) {
			return await request.post('orderRefund/refund', data);
		}
	},
	// 取消退款
	cancelRefund: {
		get: async function(data = {}) {
			return await request.get('orderRefund/cancelRefund', data);
		}
	},
	// 退款物流
	refundExpress: {
		post: async function(data = {}) {
			return await request.post('orderRefund/refundExpress', data);
		}
	},
}