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
	// 获取余额记录
	getList: {
		get: async function(data = {}) {
			return await request.get('balanceLog/index', data);
		}
	},
	// 基础信息
	getBaseInfo: {
		get: async function(data = {}) {
			return await request.get('balanceLog/getTotalInfo', data);
		}
	}
}