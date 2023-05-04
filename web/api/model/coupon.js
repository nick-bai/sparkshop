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
	// 获取可领取的优惠券列表
	couponList: {
		get: async function(data = {}) {
			return await request.get('addons/coupon/api.index/getCouponList', data);
		}
	},
	// 获取我的优惠券
	validCoupon: {
		post: async function(data = {}) {
			return await request.post('addons/coupon/api.userCoupon/getMyValid', data);
		}
	},
	// 领取优惠券
	receive: {
		post: async function(data = {}) {
			return await request.post('addons/coupon/api.userCoupon/receive', data);
		}
	},
	// 我的优惠券
	myCouponList: {
		get: async function(data = {}) {
			return await request.get('addons/coupon/api.userCoupon/myCoupon', data);
		}
	},
}