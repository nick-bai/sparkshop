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
	// 获取商品信息
	detail: {
		get: async function(data = {}) {
			return await request.get('goods/detail', data);
		}
	},
	// 规格详情
	sku: {
		get: async function(data = {}) {
			return await request.get('goods/goodsRuleDetail', data);
		}
	},
	// 获取评论
	comments: {
		get: async function(data = {}) {
			return await request.get('goods/getComments', data);
		}
	},
	// 商品分类
	goodsCate: {
		get: async function(data = {}) {
			return await request.get('goodsCate/index', data);
		}
	},
	// 分类下的商品
	cateGoods: {
		get: async function(data = {}) {
			return await request.get('goods/getGoodsByCateInfo', data);
		}
	}
}