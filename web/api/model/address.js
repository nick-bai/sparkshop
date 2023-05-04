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
	// 获取用户地址
	info: {
		get: async function(data = {}) {
			return await request.get('address/getUserAddress', data);
		}
	},
	// 添加地址
	add: {
		post: async function(data = {}) {
			return await request.post('address/add', data);
		}
	},
	// 编辑地址
	edit: {
		post: async function(data = {}) {
			return await request.post('address/edit', data);
		}
	},
	// 省市区
	area: {
		get: async function(data = {}) {
			return await request.get('address/area', data);
		}
	},
	// 获取默认地址
	defaultAddress: {
		get: async function(data = {}) {
			return await request.get('address/getDefaultAddress', data);
		}
	}
}