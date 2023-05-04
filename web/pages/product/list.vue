<template>
	<view class="content">
		<view class="navbar" :style="{position:headerPosition,top:headerTop}">
			<view class="nav-item" :class="{current: filterIndex === 0}" @click="tabClick(0)">
				综合排序
			</view>
			<view class="nav-item" :class="{current: filterIndex === 1}" @click="tabClick(1)">
				销量优先
			</view>
			<view class="nav-item" :class="{current: filterIndex === 2}" @click="tabClick(2)">
				<text>价格</text>
				<view class="p-box">
					<text :class="{active: priceOrder === 1 && filterIndex === 2}" class="yticon icon-shang"></text>
					<text :class="{active: priceOrder === 2 && filterIndex === 2}" class="yticon icon-shang xia"></text>
				</view>
			</view>
		</view>
		<view class="goods-list">
			<view 
				v-for="(item, index) in goodsList" :key="index"
				class="goods-item"
				@click="navToDetailPage(item)"
			>
				<view class="image-wrapper">
					<image :src="item.cover" mode="aspectFill"></image>
				</view>
				<text class="title clamp" style="padding-left: 20rpx;">{{item.name}}</text>
				<view class="price-box">
					<text class="price">{{item.price}}</text>
					<text>已售 {{item.sales}}</text>
				</view>
			</view>
			<xw-empty :isShow="loadingType == 'empty'" text="暂无相关数据" textColor="#777777" style="margin: 0 auto;"></xw-empty>
		</view>
		<uni-load-more :status="loadingType"></uni-load-more>
	</view>
</template>

<script>
	import uniLoadMore from '@/components/uni-load-more/uni-load-more.vue';
	import xwEmpty from '@/components/xw-empty/xw-empty';
	export default {
		components: {
			uniLoadMore,
			xwEmpty
		},
		data() {
			return {
				headerPosition:"fixed",
				headerTop:"0px",
				loadingType: 'more', // 加载更多状态
				priceOrder: 0, // 1 价格从低到高 2价格从高到低
				goodsList: [],
				filterIndex: 0,
				cateId: 0,
				limit: 6,
				nowPage: 0,
				pages: 1,
				orderBySales: 0
			};
		},
		
		onLoad(options) {
			// #ifdef H5
			this.headerTop = document.getElementsByTagName('uni-page-head')[0].offsetHeight+'px';
			// #endif
			this.cateId = options.id;
			this.loadData();
		},
		onPageScroll(e) {
			// 兼容iOS端下拉时顶部漂移
			if (e.scrollTop >=0) {
				this.headerPosition = "fixed";
			} else {
				this.headerPosition = "absolute";
			}
		},
		// 下拉刷新
		onPullDownRefresh() {
			this.loadData('refresh');
		},
		// 加载更多
		onReachBottom() {
			this.loadData();
		},
		methods: {
			// 加载商品 ，带下拉刷新和上滑加载
			async loadData(type='add') {
				this.loadingType = 'loading';
				if(type === 'refresh') {
					this.nowPage = 0;
					this.pages = 1
				}
				
				if (this.nowPage >= this.pages) {
					this.loadingType = 'noMore'
					return;
				}
			
				this.nowPage += 1;
				let res = await this.$api.goods.cateGoods.get({
					cate_id: this.cateId,
					limit: this.limit,
					page: this.nowPage,
					order_by_sales: this.orderBySales,
					order_by_price: this.priceOrder
				});
				uni.hideLoading()
				if (type == 'refresh') {
					uni.stopPullDownRefresh();
				}
				
				let goodsList = res.data.data;
				goodsList.map(item => {
					item.cover = JSON.parse(item.slider_image)[0]
					return item;
				});
				
				if (type === 'add') {
					this.goodsList = this.goodsList.concat(goodsList)
				} else {
					this.goodsList = goodsList
				}
				
				this.pages = Math.ceil(res.data.total / this.limit)
				
				if (this.pages == 0 || this.pages == this.nowPage) {
					if (this.pages > 1) {
						this.loadingType = 'nomore'
					} else {
						this.loadingType = (res.data.total == 0) ? 'empty' : 'nomore2'
					} 
				} else {
					this.loadingType = 'more'
				}
			},
			// 筛选点击
			tabClick(index) {
				this.nowPage = 0;
				this.pages = 1;
	
				if (this.filterIndex === index && index !== 2) {
					return;
				}
				
				this.filterIndex = index;
				if (index === 2) {
					this.priceOrder = this.priceOrder === 1 ? 2: 1;
					this.orderBySales = 0
				} else {
					this.priceOrder = 0;
				}
				
				if (index === 1) {
					this.orderBySales = 1
				}
				
				uni.pageScrollTo({
					duration: 300,
					scrollTop: 0
				})
				
				this.loadData('tab');
				uni.showLoading({
					title: '正在加载'
				})
			},
			// 详情
			navToDetailPage(item) {
				let id = item.id;
				let order_type = item.type
				uni.navigateTo({
					url: `/pages/product/product?id=${id}&order_type=${order_type}`
				})
			},
			stopPrevent(){}
		},
	}
</script>

<style lang="scss">
	page, .content{
		background: $page-color-base;
	}
	.content{
		padding-top: 96upx;
	}

	.navbar{
		position: fixed;
		left: 0;
		top: var(--window-top);
		display: flex;
		width: 100%;
		height: 80upx;
		background: #fff;
		box-shadow: 0 2upx 10upx rgba(0,0,0,.06);
		z-index: 10;
		.nav-item{
			flex: 1;
			display: flex;
			justify-content: center;
			align-items: center;
			height: 100%;
			font-size: 30upx;
			color: $font-color-dark;
			position: relative;
			&.current{
				color: $base-color;
				&:after{
					content: '';
					position: absolute;
					left: 50%;
					bottom: 0;
					transform: translateX(-50%);
					width: 120upx;
					height: 0;
					border-bottom: 4upx solid $base-color;
				}
			}
		}
		.p-box{
			display: flex;
			flex-direction: column;
			.yticon{
				display: flex;
				align-items: center;
				justify-content: center;
				width: 30upx;
				height: 14upx;
				line-height: 1;
				margin-left: 4upx;
				font-size: 26upx;
				color: #888;
				&.active{
					color: $base-color;
				}
			}
			.xia{
				transform: scaleY(-1);
			}
		}
		.cate-item{
			display: flex;
			justify-content: center;
			align-items: center;
			height: 100%;
			width: 80upx;
			position: relative;
			font-size: 44upx;
			&:after{
				content: '';
				position: absolute;
				left: 0;
				top: 50%;
				transform: translateY(-50%);
				border-left: 1px solid #ddd;
				width: 0;
				height: 36upx;
			}
		}
	}

	/* 分类 */
	.cate-mask{
		position: fixed;
		left: 0;
		top: var(--window-top);
		bottom: 0;
		width: 100%;
		background: rgba(0,0,0,0);
		z-index: 95;
		transition: .3s;
		
		.cate-content{
			width: 630upx;
			height: 100%;
			background: #fff;
			float:right;
			transform: translateX(100%);
			transition: .3s;
		}
		&.none{
			display: none;
		}
		&.show{
			background: rgba(0,0,0,.4);
			
			.cate-content{
				transform: translateX(0);
			}
		}
	}
	.cate-list{
		display: flex;
		flex-direction: column;
		height: 100%;
		.cate-item{
			display: flex;
			align-items: center;
			height: 90upx;
			padding-left: 30upx;
 			font-size: 28upx;
			color: #555;
			position: relative;
		}
		.two{
			height: 64upx;
			color: #303133;
			font-size: 30upx;
			background: #f8f8f8;
		}
		.active{
			color: $base-color;
		}
	}

	/* 商品列表 */
	.goods-list{
		display:flex;
		flex-wrap:wrap;
		padding: 0 30upx;
		.goods-item{
			display:flex;
			flex-direction: column;
			width: 48%;
			background: #fff;
			margin-top: 20rpx;
			padding-bottom: 40upx;
			&:nth-child(2n+1){
				margin-right: 4%;
			}
		}
		.image-wrapper{
			width: 100%;
			height: 330upx;
			border-radius: 3px;
			overflow: hidden;
			image{
				width: 100%;
				height: 100%;
				opacity: 1;
			}
		}
		.title{
			font-size: $font-sm;
			color: $font-color-dark;
			line-height: 80upx;
		}
		.price-box{
			display: flex;
			align-items: center;
			justify-content: space-between;
			padding-right: 10upx;
			font-size: 24upx;
			color: $font-color-light;
		}
		.price{
			font-size: $font-lg;
			color: #e93323;
			font-weight: 500;
			padding-left: 20rpx;
			line-height: 1;
			&:before{
				content: '￥';
				font-size: 26upx;
			}
		}
	}
</style>
