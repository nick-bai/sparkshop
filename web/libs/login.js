// +----------------------------------------------------------------------
// | SparkShop 坚持做优秀的商城系统
// +----------------------------------------------------------------------
// | Copyright (c) 2022~2099 http://sparkshop.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://opensource.org/licenses/mit-license.php )
// +----------------------------------------------------------------------
// | Author: NickBai
// +----------------------------------------------------------------------

import store from "@/store";
import Cache from '@/utils/cache';
import {
	debounce
} from '@/utils/validate.js'
// #ifdef H5 || APP-PLUS
import {
	isWeixin
} from "@/utils/validate.js";
// #endif

import {
	LOGIN_TOKEN,
	USER_INFO,
	EXPIRES_TIME
} from './../config/cache';

export const goLogin = debounce(_goLogin, 800)

function _goLogin(push, pathLogin) {
	// #ifdef H5
	uni.navigateTo({
		url: '/pages/public/login'
	})
	// #endif

	// #ifdef MP
	uni.navigateTo({
		url: '/pages/public/wechat_login'
	})
	// #endif

	// #ifdef APP-PLUS
	uni.navigateTo({
		url: '/pages/public/login'
	})
	// #endif
}

export function checkLogin() {
	let token = Cache.get(LOGIN_TOKEN);
	let expiresTime = Cache.get(EXPIRES_TIME);

	if (!token) {
		Cache.clear(LOGIN_TOKEN);
		Cache.clear(EXPIRES_TIME);
		Cache.clear(USER_INFO);
		return false;
	} else {
		store.commit('UPDATE_LOGIN', token);
		let userInfo = Cache.get(USER_INFO, true);
		if (userInfo) {
			store.commit('UPDATE_USERINFO', userInfo);
		}
		return true;
	}
}

export function loginOut() {
	Cache.clear(LOGIN_TOKEN);
	Cache.clear(EXPIRES_TIME);
	Cache.clear(USER_INFO);
	
	return true
}
