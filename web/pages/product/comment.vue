<template>
	<view class="container">
		<div class="menu-bar">
			<div class="type-btn" :class="{'type-active': commentForm.type == 0}" @click="checkComment(0)">全部({{ type[0] }})</div>
			<div class="type-btn" :class="{'type-active': commentForm.type == 1}" @click="checkComment(1)">好评({{ type[1] }})</div>
			<div class="type-btn" :class="{'type-active': commentForm.type == 2}" @click="checkComment(2)">中评({{ type[2] }})</div>
			<div class="type-btn" :class="{'type-active': commentForm.type == 3}" @click="checkComment(3)">差评({{ type[3] }})</div>
		</div>
		<xw-empty :isShow="commentList.length == 0" text="暂无评价" textColor="#777777"></xw-empty>
		<view class="eva-box" v-for="comments in commentList" :key="comments.id">
			<image class="portrait" :src="comments.user_avatar" mode="aspectFill"></image>
			<view class="right">
				<div style="display: flex;font-size: 14px;">
					<text class="name">{{ comments.user_name }}</text>
					<div style="display: flex;margin-left: auto;">评分 <uni-rate v-model="comments.desc_match" color="#bbb" active-color="#e93323" size="14px"/></div>
				</div>
				<text class="con">{{ comments.content }}</text>
				<view class="bot">
					<text class="attr">购买规格：{{ comments.sku }}</text>
					<text class="time">{{ comments.create_time }}</text>
				</view>
				<div class="comment-img" v-for="pic in comments.pictures" :key="pic">
					<image :src="pic" style="width: 60px;height: 60px;"></image>
				</div>
			</view>
		</view>
		<view class="loadmore" @click="more()" style="background: #fff;"  v-if="loadingType == 'more'">
			<uni-text style="font-size: 14px;color: rgb(144, 147, 153);">点击加载更多</uni-text>
		</view>
		<view class="loadmore" v-if="loadingType == 'noMore' && commentList.length > 0">
			<uni-text style="font-size: 14px;color: rgb(144, 147, 153);">我是有底线的</uni-text>
		</view>
	</view>
</template>

<script>
	import xwEmpty from '@/components/xw-empty/xw-empty';
	import {
		goLogin,
		checkLogin
	} from '@/libs/login';
	
	export default {
		data() {
			return {
				commentList: [],
				commentForm: {
					goods_id: 0,
					page: 1,
					limit: 8,
					type: 0
				},
				totalPage: 1,
				loadingType: 'more',
				type: [0, 0, 0, 0]
			}
		},
		onShow() {
			if (!checkLogin()) {
				goLogin()
			}
		},
		async onLoad(options) {
			if (!checkLogin()) {
				goLogin()
			}
			
			this.commentForm.goods_id = options.goods_id
		},
		mounted() {
			this.getCommentList()
		},
		methods: {
			// 获取评价详情
			async getCommentList(type) {
				uni.showLoading({
					title: '请求中..',
				})
				let res = await this.$api.goods.comments.get(this.commentForm)
				uni.hideLoading()
				if (this.commentForm.page == this.totalPage) {
					this.loadingType = 'noMore'
				}
				
				if (type == 'more') {
					this.commentList = res.data.data.concat(this.commentList)
				} else {
					this.totalPage = res.data.list.last_page
					this.commentList = res.data.list.data
					
					let sum = 0
					for (let key in res.data.num) {
						this.type[key] = res.data.num[key]
						sum += parseInt(res.data.num[key])
					}
					this.type[0] = sum
				}
			},
			// 加载更多
			more() {
				this.commentForm.page += 1
				this.getCommentList('more')
			},
			// 切换状态
			checkComment(type) {
				this.commentForm.page = 1
				this.commentForm.type = type
				
				this.getCommentList()
			}
		}
	}
</script>

<style lang="scss">
	.container {
		background-color: #fff;
		padding: 16px 15px 17px 15px;
		margin-bottom: 7px;
		height: 100%;
		width: 100%;
		position: absolute;
	}
	.loadmore {
		display: flex;
		flex-direction: row;
		height: 41px;
		align-items: center;
		justify-content: center;
		margin-top: 10px;
	}
	.eva-box{
		display: flex;
		padding: 20upx 0;
		border-bottom: 1px solid #f5f5f5;
		.portrait{
			flex-shrink: 0;
			width: 80upx;
			height: 80upx;
			border-radius: 100px;
		}
		.right{
			flex: 1;
			display: flex;
			flex-direction: column;
			font-size: $font-base;
			color: $font-color-base;
			padding-left: 26upx;
			.con{
				font-size: $font-base;
				color: $font-color-dark;
				padding: 20upx 0;
			}
			.bot{
				display: flex;
				justify-content: space-between;
				font-size: $font-sm;
				color:$font-color-light;
			}
		}
	}
	.menu-bar {
		width: 100%;
		height: 40px;
		text-align: center;
		border-bottom: 1px solid #f5f5f5;
		display: flex;
		
		.type-btn {
			font-size: 12px;
			color: #282828;
			border-radius: 3px;
			height: 28px;
			padding: 0 10px;
			background-color: #f4f4f4;
			line-height: 28px;
			margin-right: 8px;
		}
		.type-active {
			background: $uni-color-primary;
			color: #fff;
		}
	}
	.comment-img {
		margin-top: 10px;
		width: 100%;
		height: 60px;
		display: flex;
	}
</style>