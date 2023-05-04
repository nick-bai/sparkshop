<template>
	<view>
		<view class="collect-list">
			<view class="collect-item" v-for="item in collectMap" :key="item.id">
				<view class="goods-img"  @click="navToDetailPage(item)">
					<image :src="item.goods_pic" style="width:67px;height: 67px;"/>
				</view>
				<view class="goods-content"  @click="navToDetailPage(item)">
					<view class="goods-title">
						{{ item.goods_name }}
					</view>
					<view class="goods-price">￥{{ item.price }}</view>
				</view>
				<view class="operate">
					<uni-icons type="trash-filled" size="20" color="#e93323" @click="rmCollect(item)"></uni-icons>
				</view>
			</view>
		</view>
		<xw-empty :isShow="collectMap.length == 0" text="暂无收藏商品" textColor="#777777" style="margin: 0 auto;"></xw-empty>
		<view class="loadmore" @click="more()" style="background: #fff;"  v-if="loadingType == 'more'"><uni-text style="font-size: 14px;color: rgb(144, 147, 153);">点击加载更多</uni-text></view>
		<view class="loadmore" v-if="loadingType == 'noMore'"><uni-text style="font-size: 14px;color: rgb(144, 147, 153);">我是有底线的</uni-text></view>
	</view>
</template>

<script>
	import {
		goLogin,
		checkLogin
	} from '@/libs/login';
	export default {
		data() {
			return {
				loadingType: 'more', // 加载更多状态
				collectMap: [], // 收藏商品
				form: {
					page: 1,
					limit: 10
				},
				totalPage: 1
			}
		},
		onShow() {
			if (!checkLogin()) {
				goLogin()
			}
		},
		mounted() {
			this.getMyCollect()
		},
		methods: {
			// 获取我的收藏
			async getMyCollect(type) {
				uni.showLoading({
					title: '请求中..',
				})
				let res = await this.$api.collect.myCollect.get(this.form)
				if (this.form.page == this.totalPage) {
					this.loadingType = 'noMore'
				}
				
				uni.hideLoading()
				if (type == 'more') {
					this.collectMap = res.data.data.concat(this.collectMap)
				} else {
					this.totalPage = res.data.last_page
					this.collectMap = res.data.data
				}
			},
			// 删除收藏
			async rmCollect(item) {
				uni.showLoading({
					title: '请求中..',
				})
				let res = await this.$api.collect.remove.get({id: item.id})
				uni.hideLoading()
				if (res.code == 0) {
					this.$tool.msg(res.msg)
					this.getMyCollect()
				} else {
					this.$tool.msg(res.msg)
				}
			},
			// 普通商品详情页
			navToDetailPage(item) {
				let id = item.id;
				uni.navigateTo({
					url: `/pages/product/product?id=${id}`
				})
			},
			// 加载更多
			more() {
				this.form.page += 1
				this.getMyCollect('more')
			}
		}
	}
</script>

<style lang="scss" scoped>
	.collect-list {
		height: 100%;
		width: 100%;
		background: #fff;
		border-top: 1px solid #eee;
	}
	.collect-item {
		margin-left: 15px;
		border-bottom: 1px solid #eee;
		height: 93px;
		display: flex;
		align-items: center;
		flex-wrap: nowrap;		
	}
	.goods-img {
		height: 67px;
		width: 67px;
		text-align: center;
	}
	.goods-content {
		width: calc(100% - 127px);
		height: 100%;
		padding: 10px 0px 5px 10px;
		.goods-title {
			text-overflow: -o-ellipsis-lastline;
			overflow: hidden;
			text-overflow: ellipsis;
			display: -webkit-box;
			-webkit-line-clamp: 2;
			line-clamp: 2;					
			-webkit-box-orient: vertical;
			font-size: 14px;
		}
		.goods-price {
			margin-top: 20px;
			color: #e93323;
		}
	}
	.operate {
		width: 60px;
		height: 60px;
		text-align: center;
		line-height: 60px;
	}
	.loadmore {
		display: flex;
		flex-direction: row;
		height: 41px;
		align-items: center;
		justify-content: center;
		margin-top: 10px;
	}
</style>