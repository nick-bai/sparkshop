<template>
	<view class="container">
		<view class="list-cell b-b">
			<text class="cell-tit">头像</text>
			<view class="cell-more" @click="changeAvatar">
				<image :src="form.avatar" style="width:32px;height: 32px;"/>
			</view>
		</view>
		<view class="list-cell b-b">
			<text class="cell-tit">昵称</text>
			<view class="cell-more">
				<uni-easyinput class="uni-mt-5" suffixIcon="compose" v-model="form.nickname" style="text-align: right;" :styles="nickStyle"></uni-easyinput>
			</view>
		</view>
		<view class="list-cell b-b">
			<text class="cell-tit">手机号</text>
			<view class="cell-more " @click="setPhone">点击修改 <uni-icons type="forward" size="14" color="#909399"></uni-icons></view>
		</view>
		<view class="list-cell b-b">
			<text class="cell-tit">修改密码</text>
			<view class="cell-more " @click="setPassword">点击修改 <uni-icons type="forward" size="14" color="#909399"></uni-icons></view>
		</view>
		<view class="list-cell b-b">
			<text class="cell-tit">当前版本</text>
			<text class="cell-tip">{{ version }}</text>
			<text class="cell-more"></text>
		</view>
		<view class="list-cell log-out-btn" @click="save">
			<text class="cell-tit">保存修改</text>
		</view>
		<view class="list-cell log-out-btn" @click="toLogout">
			<text class="cell-tit">退出登录</text>
		</view>
	</view>
</template>

<script>
	import {
		BASE_URL,
		HEADER,
		TOKEN
	} from '@/config/app';
	import store from '@/store';
	import {
		goLogin,
		loginOut
	} from '@/libs/login';
	
	export default {
		data() {
			return {
				nickStyle: {
					borderColor: '#fff',
					color: '#909399'
				},
				version: '', // 版本
				form: {
					avatar: '',
					nickname: ''
				}
			};
		},
		mounted() {
			this.getUserInfo()
		},
		methods:{
			// 获取用户信息
			async getUserInfo() {
				let res = await this.$api.user.getUserInfo.get()
				let userInfo = res.data.userInfo
				this.version = res.data.version
				
				this.form.avatar = userInfo.avatar
				this.form.nickname = userInfo.nickname
			},
			// 保存用户信息
			async save() {
				uni.showLoading({
					title: '上传中...'
				});
				let res = await this.$api.user.update.post(this.form)
				uni.hideLoading();
				if (res.code == 0) {
					this.$tool.msg(res.msg)
				} else {
					this.$tool.msg(res.msg)
				}
			},
			// 头像上传
			changeAvatar() {
				uni.chooseImage({
					count: 1,
					sizeType: ['compressed'],
					sourceType: ['album'],
					success: (file) => {
						uni.showLoading({
							title: '上传中...'
						});
						uni.uploadFile({
							url: BASE_URL + '/api/Common/uploadFile',
							filePath: file.tempFilePaths[0],
							name: 'file',
							success: (result) => {
								uni.hideLoading();
								let res = JSON.parse(result.data)
								if (res.code != 0) {
									this.$tool.msg(res.msg)
									return 
								}
								this.form.avatar = res.data.url
							}
						});
					}
				});
			},
			// 设置新手机号
			setPhone() {
				uni.navigateTo({
					url: '/pages/set/phone'
				}) 
			},
			// 设置密码
			setPassword() {
				uni.navigateTo({
					url: '/pages/set/password'
				}) 
			},
			// 退出
			toLogout() {
				uni.showLoading({
					title: '操作中...'
				});
				if (loginOut()) {
					uni.hideLoading();
					this.$tool.msg('退出成功')
					setTimeout(() => {
						goLogin()
					}, 800)
					
				}
			},
		}
	}
</script>

<style lang='scss'>
	page{
		background: $page-color-base;
	}
	.list-cell{
		display:flex;
		align-items:baseline;
		padding: 20upx $page-row-spacing;
		line-height:60upx;
		position:relative;
		background: #fff;
		justify-content: center;
		&.log-out-btn{
			margin-top: 40upx;
			.cell-tit{
				color: $uni-color-primary;
				text-align: center;
				margin-right: 0;
			}
		}
		&.cell-hover{
			background:#fafafa;
		}
		&.b-b:after{
			left: 30upx;
		}
		&.m-t{
			margin-top: 16upx; 
		}
		.cell-more{
			align-self: baseline;
			font-size:$font-lg;
			color:$font-color-light;
			margin-left:10upx;
		}
		.cell-tit{
			flex: 1;
			font-size: $font-base + 2upx;
			color: $font-color-dark;
			margin-right:10upx;
		}
		.cell-tip{
			font-size: $font-base;
			color: $font-color-light;
		}
		switch{
			transform: translateX(16upx) scale(.84);
		}
	}
	.uni-easyinput__content-input {text-align: right;}
</style>
