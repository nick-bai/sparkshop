<template>
	<view class="container">
		<view class="left-bottom-sign"></view>
		<view class="right-top-sign"></view>
		<!-- 设置白色背景防止软键盘把下部绝对定位元素顶上来盖住输入框等 -->
		<view class="wrapper">
			<view class="left-top-sign">SparkShop</view>
			<view class="welcome">
				{{ loginTitle }}
			</view>
			<button class="confirm-btn" open-type="getPhoneNumber" @getphonenumber="loginByAuth" style="background: #5FB878;margin-top: 40%;">微信授权登录</button>
		</view>
	</view>
</template>

<script>
	import {
		BASE_URL
	} from '@/config/app';
	
	export default{
		data() {
			return {
				logining: false,
				loginTitle: '欢迎使用',
			}
		},
		onLoad(){
			
		},
		methods: {
			navBack(){
				uni.navigateBack();
			},
			// 授权登录
			loginByAuth(data) {
				wx.login({  
					success: async (wxRes) => {
						uni.showLoading({
							title: '登陆中'
						});
						let res2 = await this.$api.login.miniappAuth.post({code: data.detail.code, login_code: wxRes.code})
						uni.hideLoading();
						if (res2.code == 0) {
							this.$tool.msg(res2.msg);
							setTimeout(() => {
								// 设置store
								this.$store
								  .dispatch('login', res2)
								  .then(() => {
									uni.reLaunch({ url: '/pages/user/user' })
									this.loading = false
								  })
								  .catch(() => {
									this.loading = false
								  })
							}, 1000)
							
						} else {
							this.$tool.msg(res.msg);
						}
					}  
				})
			}
		},

	}
</script>

<style lang='scss'>
	page{
		background: #fff;
	}
	.text-box {
		font-size: 13px;
		position: absolute;
		color: #FF5722;
		right: 50px;
		margin-top: 5px;
	}
	.container{
		padding-top: 115px;
		position:relative;
		width: 100vw;
		height: 100vh;
		overflow: hidden;
		background: #fff;
	}
	.wrapper{
		position:relative;
		z-index: 90;
		background: #fff;
		padding-bottom: 40upx;
	}
	.back-btn{
		position:absolute;
		left: 40upx;
		z-index: 9999;
		padding-top: var(--status-bar-height);
		top: 40upx;
		font-size: 40upx;
		color: $font-color-dark;
	}
	.left-top-sign{
		font-size: 120upx;
		color: $page-color-base;
		position:relative;
		left: -16upx;
	}
	.right-top-sign{
		position:absolute;
		top: 80upx;
		right: -30upx;
		z-index: 95;
		&:before, &:after{
			display:block;
			content:"";
			width: 400upx;
			height: 80upx;
			background: #b4f3e2;
		}
		&:before{
			transform: rotate(50deg);
			border-radius: 0 50px 0 0;
		}
		&:after{
			position: absolute;
			right: -198upx;
			top: 0;
			transform: rotate(-50deg);
			border-radius: 50px 0 0 0;
			/* background: pink; */
		}
	}
	.left-bottom-sign{
		position:absolute;
		left: -270upx;
		bottom: -320upx;
		border: 100upx solid #d0d1fd;
		border-radius: 50%;
		padding: 180upx;
	}
	.welcome{
		position:relative;
		left: 50upx;
		top: -90upx;
		font-size: 46upx;
		color: #555;
		text-shadow: 1px 0px 1px rgba(0,0,0,.3);
	}
	.confirm-btn{
		width: 630upx;
		height: 76upx;
		line-height: 76upx;
		border-radius: 50px;
		margin-top: 70upx;
		background: $uni-color-primary;
		color: #fff;
		font-size: $font-lg;
		&:after{
			border-radius: 100px;
		}
	}
</style>
