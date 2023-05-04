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
	// 首页数据
	home: {
		get: async function(data = {}) {
			return await request.get('index/index', data);
		}
	},
	// 信息搜索
	search: {
		post: async function(data = {}) {
			return await request.post('index/search', data);
		}
	}
}