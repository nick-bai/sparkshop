// +----------------------------------------------------------------------
// | SparkShop 坚持做优秀的商城系统
// +----------------------------------------------------------------------
// | Copyright (c) 2022~2099 http://sparkshop.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://opensource.org/licenses/mit-license.php )
// +----------------------------------------------------------------------
// | Author: NickBai
// +----------------------------------------------------------------------

import store from '../store';
import {
	BASE_URL,
	HEADER,
	TOKEN
} from '@/config/app';
import {
	goLogin,
	checkLogin
} from '../libs/login';

/**
 * 发送请求
 */
function baseRequest(url, method, data, {
	noAuth = false,
	noVerify = false
}) {
	let header = HEADER;

	if (store.state.app.token) header[TOKEN] = 'Bearer ' + store.state.app.token;

	return new Promise((reslove, reject) => {
	
		uni.request({
			url: BASE_URL + '/api/' + url,
			method: method || 'GET',
			header: header,
			data: data || {},
			success: (res) => {
				if ([403].indexOf(res.data.code) !== -1) {
					goLogin();
					reject(res.data);
				} else {
					reslove(res.data);
				}	
			},
			fail: (msg) => {
				let data = {
					mag: `请求失败`,
					status: -1
				}
				// #ifdef APP-PLUS
				reject(data);
				// #endif
				// #ifndef APP-PLUS
				reject(`请求失败`);
				// #endif
			}
		})
	});
}

const request = {};

['options', 'get', 'post', 'put', 'head', 'delete', 'trace', 'connect'].forEach((method) => {
	request[method] = (api, data, opt) => baseRequest(api, method, data, opt || {})
});

export default request;
