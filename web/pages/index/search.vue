<template>
	<div class="container">
		<div class="search">
			<div class="search-input" :class="{'search-h5-input': platform == 'web'}">
				<uni-search-bar class="uni-mt-10" radius="5" placeholder="请输入商品" clearButton="auto" cancelButton="none" v-model="form.keywords"/>
			</div>
			<div class="search-btn" @click="doSearch">搜索</div>
		</div>
		
		<div class="search-content">
			<div class="no-result" v-if="searchRes.length == 0" >
				<image src="@/static/noSearch.png" style="width: 215px;height: 174px;">
			</div>
			<view class="collect-list" v-else>
				<span class="result-txt">搜索结果：</span>
				<view class="collect-item" v-for="item in searchRes" :key="item.id">
					<view class="goods-img"  @click="navToDetailPage(item)">
						<image :src="item.pic" style="width:67px;height: 67px;"/>
					</view>
					<view class="goods-content"  @click="navToDetailPage(item)">
						<view class="goods-title">
							{{ item.name }}
						</view>
						<view class="goods-price">￥{{ item.price }}</view>
					</view>
				</view>
			</view>
			<view class="loadmore" @click="more()" style="background: #fff;"  v-if="loadingType == 'more' && searchRes.length > 0">
				<uni-text style="font-size: 14px;color: rgb(144, 147, 153);">点击加载更多</uni-text>
			</view>
			<view class="loadmore" v-if="loadingType == 'noMore' && searchRes.length > 0">
				<uni-text style="font-size: 12px;color: rgb(144, 147, 153);">我是有底线的</uni-text>
			</view>
		</div>
	</div>
</template>

<script>
	export default {
		data() {
			return {
				searchRes: [],
				form: {
					keywords: '',
					page: 1,
					limit: 10
				},
				totalPage: 1,
				platform: '',
				loadingType: 'more'
			}
		},
		onShow() {
			this.platform = uni.getSystemInfoSync().uniPlatform
		},
		methods: {
			// 搜索
			async doSearch(type) {
				if (type == 'more') {
					this.form.page = 1
				}
				
				uni.showLoading({
					title: '搜索中..',
				})
				let res = await this.$api.home.search.post(this.form)
				uni.hideLoading()
				
				if (this.form.page == this.totalPage) {
					this.loadingType = 'noMore'
				}
				
				if (type == 'more') {
					this.searchRes = res.data.data.concat(this.searchRes)
				} else {
					this.totalPage = res.data.last_page
					this.searchRes = res.data.data
				}
			},
			// 加载更多
			more() {
				this.form.page += 1
				this.doSearch('more')
			},
			// 前往商品
			navToDetailPage(item) {
				let id = item.id;
				uni.navigateTo({
					url: `/pages/product/product?id=${id}`
				})
			}
		}
	}
</script>

<style lang="scss">
	.search {
		display: flex;
		height: 34px;
		width: 100%;
		.search-input {
			height: 34px;
			width: calc(100% - 65px);
		}
		.search-h5-input {
			width: calc(100% - 90px) !important;
		}
		.search-btn {
			height: 34px;
			width: 62px;
			font-size: 14px;
			line-height: 34px;
			text-align: center;
			background: $uni-color-primary;
			color: #fff;
			margin-top: 10px;
			border-radius: 10px 0px;
		}
	}
	.container {
		background-color: #fff;
		padding: 16px 15px 17px 15px;
		margin-bottom: 7px;
		height: 100%;
		width: 100%;
		position: absolute;
	}
	.no-result {
		text-align: center;
		margin-top: 50px;
	}
	.loadmore {
		display: flex;
		flex-direction: row;
		height: 41px;
		align-items: center;
		justify-content: center;
		margin-top: 10px;
	}
	.collect-list {
		height: 100%;
		width: 100%;
		background: #fff;
		margin-top: 30px;
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
	.result-txt {
		font-size: 12px;
		color: #909399;
		margin-bottom:10px;
		margin-left:20px;
	}
</style>