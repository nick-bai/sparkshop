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
	// 收藏列表
	myCollect: {
		get: async function(data = {}) {
			return await request.get('userCollect/myCollect', data);
		}
	},
	// 添加收藏
	add: {
		post: async function(data = {}) {
			return await request.post('userCollect/add', data);
		}
	},
	// 删除收藏
	remove: {
		get: async function(data = {}) {
			return await request.get('userCollect/remove', data);
		}
	},
	// 根据商品id移除
	removeByGoods: {
		get: async function(data = {}) {
			return await request.get('userCollect/removeByGoodsId', data);
		}
	}
}