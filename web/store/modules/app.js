// +----------------------------------------------------------------------
// | SparkShop 坚持做优秀的商城系统
// +----------------------------------------------------------------------
// | Copyright (c) 2022~2099 http://sparkshop.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://opensource.org/licenses/mit-license.php )
// +----------------------------------------------------------------------
// | Author: NickBai
// +----------------------------------------------------------------------

import {
	LOGIN_TOKEN,
	UID,
	USER_INFO
} from '../../config/cache';
import Cache from '../../utils/cache';

const state = {
	token: Cache.get(LOGIN_TOKEN) || false,
	userInfo: Cache.get(USER_INFO) || {},
	uid: Cache.get(UID) || 0
};

const mutations = {
	LOGIN(state, opt) {
		state.token = opt.token;
		Cache.set(LOGIN_TOKEN, opt.token, opt.time);
	},
	SET_UID(state, val) {
		state.uid = val;
		Cache.set(UID, val);
	},
	UPDATE_LOGIN(state, token) {
		state.token = token;
	},
	LOGOUT(state) {
		state.token = false;
		state.uid = 0
		Cache.clear(LOGIN_TOKEN);
		Cache.clear(USER_INFO);
		Cache.clear(UID);
	},
	UPDATE_USERINFO(state, userInfo) {
		state.userInfo = userInfo;
		Cache.set(USER_INFO, userInfo);
	}
};

const actions = {
	login({ commit }, res) {
		return new Promise((resolve, reject) => {
		  commit('LOGIN', res.data)
		  commit('UPDATE_USERINFO', res.data.userInfo)
		  commit('SET_UID', res.data.userInfo.id)
		  resolve()
		})
	},
};

export default {
	state,
	mutations,
	actions
};
