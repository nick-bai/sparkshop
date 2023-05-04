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
	// 获取个人中心基础信息
	getUserBaseInfo: {
		get: async function(data = {}) {
			return await request.get('user/index', data);
		}
	},
	// 获取个人基础信息
	getUserInfo: {
		get: async function(data = {}) {
			return await request.get('user/info', data);
		}
	},
	// 更新基础信息
	update: {
		post: async function(data = {}) {
			return await request.post('user/update', data);
		}
	},
	// 更换手机号
	changePhone: {
		post: async function(data = {}) {
			return await request.post('user/changePhone', data);
		}
	},
	// 更改密码
	changePassword: {
		post: async function(data = {}) {
			return await request.post('user/changePassword', data);
		}
	},
}