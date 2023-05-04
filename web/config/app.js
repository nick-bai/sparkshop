// +----------------------------------------------------------------------
// | SparkShop 坚持做优秀的商城系统
// +----------------------------------------------------------------------
// | Copyright (c) 2022~2099 http://sparkshop.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://opensource.org/licenses/mit-license.php )
// +----------------------------------------------------------------------
// | Author: NickBai
// +----------------------------------------------------------------------

module.exports = {
	// 请求域名
	BASE_URL: `http://www.mysp.com`,
	// BASE_URL: `https://sparkshop.pfecms.com`,
	// 以下配置在不做二开的前提下,不需要做任何的修改
	HEADER: {
		'Content-type': 'application/json',
		//#ifdef H5
		'X-CSRF-TOKEN': navigator.userAgent.toLowerCase().indexOf("micromessenger") !== -1 ? 'wechat' : 'h5',
		//#endif
		//#ifdef MP
		'X-CSRF-TOKEN': 'miniapp',
		//#endif
		//#ifdef APP-VUE
		'X-CSRF-TOKEN': 'app',
		//#endif
	},
	// 会话token
	TOKEN: 'Authorization',
	
	// 缓存时间 0 永久
	EXPIRE: 0,
	
	// 分页最多显示条数
	LIMIT: 10
}
