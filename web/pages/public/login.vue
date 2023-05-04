<template>
	<view class="container">
		<view class="left-bottom-sign"></view>
		<view class="right-top-sign"></view>
		<!-- 设置白色背景防止软键盘把下部绝对定位元素顶上来盖住输入框等 -->
		<view class="wrapper">
			<view class="left-top-sign">SparkShop</view>
			<view class="welcome">
				欢迎使用！
			</view>
			<view class="input-content" v-if="login_type == 1">
				<view class="input-item">
					<text class="tit">手机号码</text>
					<input 
						type="text"
						maxlength="11"
						v-model="phone"
						autocomplete="off"
					/>
				</view>
				<view class="input-item">
					<text class="tit">密码</text>
					<input 
						type="text" 
						placeholder-class="input-empty"
						maxlength="20"
						password
						v-model="password"
						@input="inputChange"
						autocomplete="off"
					/>
				</view>
			</view>
			<view class="input-content" v-if="login_type == 2">
				<view class="input-item">
					<text class="tit">手机号码</text>
					<input 
						type="text" 
						maxlength="11"
						v-model="phone"
						autocomplete="off"
					/>
				</view>
				<view class="input-item">
					<text class="tit">验证码</text>
					<input 
						type="text" 
						placeholder-class="input-empty"
						maxlength="20"
						v-model="code"
						style="width: 75%;"
						autocomplete="off"
					/>
					<view class="text-box" @click="sendMsg">
						<text>{{ text }}</text>
					</view>
				</view>
			</view>
			<view class="input-content" v-if="login_type == 3">
				<view class="input-item">
					<text class="tit">手机号码</text>
					<input 
						type="text" 
						maxlength="11"
						v-model="phone"
						autocomplete="off"
					/>
				</view>
				<view class="input-item">
					<text class="tit">密码</text>
					<input 
						type="text" 
						placeholder-class="input-empty"
						maxlength="20"
						password
						v-model="password"
						@input="inputChange"
						autocomplete="off"
					/>
				</view>
				<view class="input-item">
					<text class="tit">验证码</text>
					<input 
						type="text" 
						placeholder-class="input-empty"
						maxlength="20"
						v-model="code"
						style="width: 75%;"
						autocomplete="off"
					/>
					<view class="text-box" @click="sendMsg">
						<text>{{ text }}</text>
					</view>
				</view>
			</view>
			<button class="confirm-btn" @click="goLogin" :loading="logining">{{ btnTxt }}</button>
			<view class="uni-padding-wrap uni-common-mt">
				 <view class="uni-flex uni-row">
					<view class="flex-item forget-section" @click="changeLoginType">{{ login_type_text }}</view>
					<view class="flex-item forget-section" v-show="login_type == 3" @click="accountLogin">账号密码登录</view>
				</view>
			</view>
		</view>
		<view class="register-section">
			还没有账号?
			<text @click="goRegist">马上注册</text>
		</view>
	</view>
</template>

<script>

	export default{
		data() {
			return {
				phone: '',
				password: '',
				code: '',
				btnTxt: '登录',
				login_type_text: '短信登录',
				reg_text: '马上注册',
				logining: false,
				login_type: 1,
				text: '获取验证码',
				timeInterval: null,
				msg_type: "login_sms_code"
			}
		},
		onLoad(){
			
		},
		mounted() {
			if (this.login_type == 2) {
				this.countdown()
			}
		},
		methods: {
			inputChange(e){
				const key = e.currentTarget.dataset.key;
				this[key] = e.detail.value;
			},
			navBack(){
				uni.navigateBack();
			},
			goRegist(){
				this.login_type = 3
				this.btnTxt = '注册'
				this.msg_type = 'reg_sms_code'
			},
			accountLogin() {
				this.login_type = 1
				this.btnTxt = '登录'
			},
			// 改变登录方式
			changeLoginType() {
				this.btnTxt = '登录'
				if (this.login_type == 1) {
					this.login_type = 2;
					this.login_type_text = '账号密码登录';
				} else {
					this.login_type = 1;
					this.login_type_text = '短信登录';
					this.msg_type = 'login_sms_code'
				}
			},
			// 短信倒计时
			async sendMsg() {
				
				if (this.phone == '') {
					this.$tool.msg('请输入手机号');
					return false;
				}
				
				let res = await this.$api.common.sendSms.post({
					phone: this.phone,
					type: this.msg_type
				});
				
				if (res.code == 0) {
					localStorage.setItem('send-msg-time', 60)
					this.countdown()
					this.$tool.msg(res.msg);
				} else {
					this.$tool.msg(res.msg);
				}
			},
			// 倒计时
			countdown() {
				let localTime = localStorage.getItem('send-msg-time');
				if (parseInt(localTime) == 0) {
					localTime = null;
					return ;
				}
				
				let time = (localTime == null) ? 60 : parseInt(localTime);
				this.timeInterval = setInterval(() => {
					time -= 1;
					localStorage.setItem('send-msg-time', time)
					if (time == 0) {
						this.text = '获取验证码';
						clearInterval(this.timeInterval)
					} else {
						this.text = time + ' 秒';
					}
				}, 1000);
			},
			async goLogin() {
				this.logining = true;
				
				if (this.phone == '') {
					this.$tool.msg('请输入手机号');
					return false;
				}
				
				if (this.code == '' && this.login_type == 2) {
					this.$tool.msg('请输入验证码');
					return false;
				}
				
				let res = null;
				if (this.login_type == 2) {
					res = await this.$api.login.loginBySms.post({
						phone: this.phone,
						code: this.code,
						type: this.msg_type
					});
				} else if (this.login_type == 1) {
					
					if (this.password == "") {
						this.$tool.msg('请输入密码');
						return false;
					}
					
					res = await this.$api.login.loginByAccount.post({
						phone: this.phone,
						password: this.password
					});
				} else {
					
					if (this.password == "") {
						this.$tool.msg('请输入密码');
						return false;
					}
					
					res = await this.$api.login.regAccount.post({
						phone: this.phone,
						code: this.code,
						password: this.password,
						type: this.msg_type
					});
					
					if (res.code == 0) {
						this.$tool.msg(res.msg);
						localStorage.removeItem('send-msg-time')
						this.logining = false;
						this.login_type = 1
					} else {
						this.logining = false;
						this.$tool.msg(res.msg);
					}
					
					return false;
				}
				
				localStorage.removeItem('send-msg-time')
				if (res.code === 0) {
					// 设置store
					this.$store
					  .dispatch('login', res)
					  .then(() => {
						this.$router.push({ path: '/' })
						this.loading = false
					  })
					  .catch(() => {
						this.loading = false
					  })
					
				} else {
					this.$tool.msg(res.msg);
					this.logining = false;
				}
				
				return false;
			}
		},

	}
</script>

<style lang='scss'>
	page{
		background: #fff;
	}
	.uni-row {
	    flex-direction: row;
	}
	.text-box {
		font-size: 13px;
		position: absolute;
		color: #FF5722;
		right: 50px;
		margin-top: 5px;
	}
	.uni-flex {
	    display: flex;
	    flex-direction: row;
	}
	.flex-item {
	    width: 50%;
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
	.input-content{
		padding: 0 60upx;
	}
	.input-item{
		display:flex;
		flex-direction: column;
		align-items:flex-start;
		justify-content: center;
		padding: 0 30upx;
		background:$page-color-light;
		height: 120upx;
		border-radius: 4px;
		margin-bottom: 50upx;
		&:last-child{
			margin-bottom: 0;
		}
		.tit{
			height: 50upx;
			line-height: 56upx;
			font-size: $font-sm+2upx;
			color: $font-color-base;
		}
		input{
			height: 60upx;
			font-size: $font-base + 2upx;
			color: $font-color-dark;
			width: 100%;
		}	
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
	.forget-section{
		font-size: $font-sm+2upx;
		color: $font-color-spec;
		text-align: center;
		margin-top: 40upx;
	}
	.register-section{
		position:absolute;
		left: 0;
		bottom: 50upx;
		width: 100%;
		font-size: $font-sm+2upx;
		color: $font-color-base;
		text-align: center;
		text{
			color: $font-color-spec;
			margin-left: 10upx;
		}
	}
</style>
