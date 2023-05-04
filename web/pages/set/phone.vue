<template>
	<view class="container">
		<div class="form">
			<uni-forms ref="baseForm" :modelValue="userForm" :label-position="alignment">
				<uni-forms-item label="原手机号">
					{{ userForm.old_phone }}
				</uni-forms-item>
				<uni-forms-item label="新手机号">
					<uni-easyinput type="text" v-model="userForm.new_phone" />
				</uni-forms-item>
				<uni-forms-item label="验证码">
					<div class="input-group">
						<uni-easyinput type="text" v-model="userForm.code" style="width: 100px;"/>
						<span class="code" @click="sendMsg">{{ text }}</span>
					</div>
				</uni-forms-item>
				<button @click="submit" type="primary" style="background: #e93323;">确认更换</button>
			</uni-forms>
		</div>
	</view>
</template>

<script>
	export default {
		data() {
			return {
				userForm: {
					old_phone: '',
					new_phone: '',
					code: '',
					type: 'bind_sms_code'
				},
				alignment: 'top',
				text: '发送验证码'
			}
		},
		mounted() {
			this.getUserInfo()
		},
		methods: {
			// 获取用户信息
			async getUserInfo() {
				let res = await this.$api.user.getUserInfo.get()
				this.userForm.old_phone = res.data.userInfo.phone
			},
			// 保存
			async submit() {
				
				if (this.userForm.new_phone == '') {
					this.$tool.msg('请输入手机号');
					return false;
				}
				
				if (this.userForm.code == '') {
					this.$tool.msg('请输入验证码');
					return false;
				}
				
				let res = await this.$api.user.changePhone.post(this.userForm)
				if (res.code == 0) {
					this.$tool.msg('更换成功');
					setTimeout(() => {
						uni.navigateTo({
							url: '/pages/set/set'
						}) 
					}, 800)
				} else {
					this.$tool.msg(res.msg);
				}
			},
			// 短信倒计时
			async sendMsg() {
	
				if (this.userForm.new_phone == '') {
					this.$tool.msg('请输入手机号');
					return false;
				}
				
				let res = await this.$api.common.sendSms.post({
					phone: this.userForm.new_phone,
					type: this.userForm.type
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
		}
	}
</script>

<style>
	page {
		height: 100%;
		background: #f5f5f5;
	}
	.container {
		height: 100%;
		width: 100%;
		padding-top: 30px;
	}
	.form {
		width: 85%;
		height: 400px;
		background: #fff;
		margin: 0 auto;
		border-radius: 5px;
		padding: 20px 20px 10px 10px
	}
	.input-group {
		display: flex;
	}
	.code {
		margin-left: 5px;
		border: 1px solid #e2e2e2;
		line-height: 35px;
		text-align: center;
		font-size: 12px;
		padding: 0px 5px 0px 5px;
		border-radius: 5px;
	}
</style>