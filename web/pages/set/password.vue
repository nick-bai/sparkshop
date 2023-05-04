<template>
	<view class="container">
		<div class="form">
			<uni-forms ref="baseForm" :modelValue="userForm" :label-position="alignment">
				<uni-forms-item label="旧密码">
					<uni-easyinput type="password" v-model="userForm.old_pwd"/>
				</uni-forms-item>
				<uni-forms-item label="新密码">
					<uni-easyinput type="password" v-model="userForm.new_pwd"/>
				</uni-forms-item>
				<uni-forms-item label="重复新密码" label-width="200px">
					<uni-easyinput type="password" v-model="userForm.re_pwd"/>
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
					old_pwd: '',
					new_pwd: '',
					re_pwd: ''
				},
				alignment: 'top',
				showPassword: true
			}
		},
		mounted() {
		},
		methods: {
			// 保存
			async submit() {
				
				if (this.userForm.old_pwd == '') {
					this.$tool.msg('请输入旧密码');
					return false;
				}
				
				if (this.userForm.new_pwd == '') {
					this.$tool.msg('请输入新密码');
					return false;
				}
				
				if (this.userForm.re_pwd == '') {
					this.$tool.msg('请再次输入新密码');
					return false;
				}
				
				if (this.userForm.new_pwd != this.userForm.re_pwd) {
					this.$tool.msg('两次密码输入不一致');
					return false;
				}
				
				let res = await this.$api.user.changePassword.post(this.userForm)
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
			}
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
</style>