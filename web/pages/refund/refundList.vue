<template>
	<view class="content">
		<view class="navbar">
			<view 
				v-for="(item, index) in navList" :key="index" 
				class="nav-item" 
				:class="{current: tabCurrentIndex === index}"
				@click="tabClick(index)"
			>
				{{ item.text }}
			</view>
		</view>

		<swiper :current="tabCurrentIndex" class="swiper-box" duration="300">
			<swiper-item class="tab-content" v-for="(tabItem,tabIndex) in navList" :key="tabIndex">
				<scroll-view 
					class="list-scroll-content" 
					scroll-y
					@scrolltolower="loadData"
				>
					<!-- 空白页 -->
					<empty v-if="tabItem.loaded === true && tabItem.orderList.length === 0"></empty>
					
					<!-- 订单列表 -->
					<view 
						v-for="(item,index) in tabItem.orderList" :key="index"
						class="order-item"
						@click="orderDetail(item)"
					>
						<view class="i-top b-b">
							<text class="time">{{item.create_time}}</text>
							<text class="state">{{item.status_txt}}</text>
						</view>
						
						<scroll-view v-if="item.goodsList.length > 1" class="goods-box" scroll-x>
							<view
								v-for="(goodsItem, goodsIndex) in item.goodsList" :key="goodsIndex"
								class="goods-item"
							>
								<image class="goods-img" :src="goodsItem.logo" mode="aspectFill"></image>
							</view>
						</scroll-view>
						<view 
							v-if="item.goodsList.length === 1" 
							class="goods-box-single"
							v-for="(goodsItem, goodsIndex) in item.goodsList" :key="goodsIndex"
						>
							<image class="goods-img" :src="goodsItem.logo" mode="aspectFill"></image>
							<view class="right">
								<text class="title clamp">{{goodsItem.goods_name}}</text>
								<text class="attr-box" v-if="goodsItem.rule_text.length > 0">{{goodsItem.rule_text}}  x {{item.refund_num}}</text>
								<text class="attr-box" style="height: 56rpx;" v-else></text>
								<text class="price">{{goodsItem.price}}</text>
							</view>
						</view>
						
						<view class="price-box">
							共
							<text class="num">{{ item.refund_num }}</text>
							件商品 总金额
							<text class="price" style="color:#e93323">{{ item.refund_price }}</text>
						</view>
					</view>
					 
					<uni-load-more :status="tabItem.loadingType"></uni-load-more>
					
				</scroll-view>
			</swiper-item>
		</swiper>
	</view>
</template> 

<script>
	import uniLoadMore from '@/components/uni-load-more/uni-load-more.vue';
	import empty from "@/components/empty";
	export default {
		components: {
			uniLoadMore,
			empty
		},
		data() {
			return {
				loaded: false,
				pages: 1,
				param: {
					limit: 5,
					page: 1,
					status: 0
				},
				loading: false,
				tabCurrentIndex: 0,
				navList: [
					{
						status: 0,
						text: '全部',
						loadingType: 'more',
						orderList: []
					},
					{
						status: 1,
						text: '申请中',
						loadingType: 'more',
						orderList: []
					},
					{
						status: 2,
						text: '已退款',
						loadingType: 'more',
						orderList: []
					}
				],
			};
		},
		
		onLoad(options) {
			// 订单返回刷新
			uni.$on('refreshData', () => {
				this.initData()
				this.loadData();
			})
			/**
			 * 修复app端点击除全部订单外的按钮进入时不加载数据的问题
			 * 替换onLoad下代码即可
			 */
			switch (options.status) {
				case '0':
					this.tabCurrentIndex = 0;
					break;
				case '1':
					this.tabCurrentIndex = 1;
					break;
				case '2':
					this.tabCurrentIndex = 2;
					break;	
			}
			
			this.loadData()
		},
		methods: {
			// 初始化
			initData(index = 0) {
				this.tabCurrentIndex = index;
				this.navList[this.tabCurrentIndex].loadingType = 'more'
				this.pages = 1
				this.param.page = 1
			},
			// 获取订单列表
			async loadData(source) {
				uni.showLoading({
					title: '加载中...'
				})
				let index = this.tabCurrentIndex;
				let navItem = this.navList[index];
				if (navItem.loadingType == "noMore") {
					navItem.loaded = true
					uni.hideLoading()
					return ;
				}
				
				if (this.loaded) {
					uni.hideLoading();
					return ;
				}
				this.loaded = true
				
				// 如果页码是1 则还原数据
				if (this.param.page == 1) {
					navItem.orderList = [];
				}
				
				let status = navItem.status;
				this.param.status = status;
				navItem.loadingType = 'loading';
				this.loading = true
				
				let res = await this.$api.orderRefund.orderList.get(this.param);
				uni.hideLoading();
				this.pages = res.data.last_page
		
				res.data.data.forEach(item => {
					item.goodsList.forEach((item2, index) => {
						
						let rule_text = '';
						if (item2.rule != '0') {
							rule_text = item2.rule.split('※').join(' ')
						}
						
						if (rule_text.length > 25) {
							item.goodsList[index].rule_text = rule_text.substr(0, 20) + '..'
						} else {
							item.goodsList[index].rule_text = rule_text
						}
					})
					
					navItem.orderList.push(item);
				})
				
				if (this.param.page >= this.pages) {
					navItem.loaded = true
					navItem.loadingType = 'noMore';
				} else {
					navItem.loaded = true
					navItem.loadingType = 'more';
					this.param.page += 1;
					this.navList[index] = navItem
				}
				
				this.loading = false
				this.loaded = false
			},
			// 订单详情
			orderDetail(item) {
				uni.navigateTo({
					url: `/pages/refund/refundDetail?refund_id=${item.id}`
				})
			},
			// 顶部tab点击
			tabClick(index) {
				this.initData(index)
				this.loadData()
			},
		}
	}
</script>

<style lang="scss">
	page, .content{
		background: $page-color-base;
		height: 100%;
	}
	
	.swiper-box{
		height: calc(100% - 40px);
	}
	.list-scroll-content{
		height: 100%;
	}
	
	.navbar{
		display: flex;
		height: 40px;
		padding: 0 5px;
		background: #fff;
		box-shadow: 0 1px 5px rgba(0,0,0,.06);
		position: relative;
		z-index: 10;
		.nav-item{
			flex: 1;
			display: flex;
			justify-content: center;
			align-items: center;
			height: 100%;
			font-size: 15px;
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
					width: 44px;
					height: 0;
					border-bottom: 2px solid $base-color;
				}
			}
		}
	}

	.uni-swiper-item{
		height: auto;
	}
	.order-item{
		display: flex;
		flex-direction: column;
		padding-left: 30upx;
		background: #fff;
		margin-top: 16upx;
		.i-top{
			display: flex;
			align-items: center;
			height: 80upx;
			padding-right:30upx;
			font-size: $font-base;
			color: $font-color-dark;
			position: relative;
			.time{
				flex: 1;
			}
			.state{
				color: $base-color;
			}
			.del-btn{
				padding: 10upx 0 10upx 36upx;
				font-size: $font-lg;
				color: $font-color-light;
				position: relative;
				&:after{
					content: '';
					width: 0;
					height: 30upx;
					border-left: 1px solid $border-color-dark;
					position: absolute;
					left: 20upx;
					top: 50%;
					transform: translateY(-50%);
				}
			}
		}
		/* 多条商品 */
		.goods-box{
			height: 160upx;
			padding: 20upx 0;
			white-space: nowrap;
			.goods-item{
				width: 120upx;
				height: 120upx;
				display: inline-block;
				margin-right: 24upx;
			}
			.goods-img{
				display: block;
				width: 100%;
				height: 100%;
			}
		}
		/* 单条商品 */
		.goods-box-single{
			display: flex;
			padding: 20upx 0;
			.goods-img{
				display: block;
				width: 120upx;
				height: 120upx;
			}
			.right{
				flex: 1;
				display: flex;
				flex-direction: column;
				padding: 0 30upx 0 24upx;
				overflow: hidden;
				.title{
					font-size: $font-base + 2upx;
					color: $font-color-dark;
					line-height: 1;
				}
				.attr-box{
					font-size: $font-sm + 2upx;
					color: $font-color-light;
					padding: 10upx 12upx;
				}
				.price{
					font-size: $font-base + 2upx;
					color: $font-color-dark;
					&:before{
						content: '￥';
						font-size: $font-sm;
						margin: 0 2upx 0 8upx;
					}
				}
			}
		}
		
		.price-box{
			display: flex;
			justify-content: flex-end;
			align-items: baseline;
			padding: 20upx 30upx;
			font-size: $font-sm + 2upx;
			color: $font-color-light;
			.num{
				margin: 0 8upx;
				color: $font-color-dark;
			}
			.price{
				font-size: $font-lg;
				color: $font-color-dark;
				&:before{
					content: '￥';
					font-size: $font-sm;
					margin: 0 2upx 0 8upx;
				}
			}
		}
		.action-box{
			display: flex;
			justify-content: flex-end;
			align-items: center;
			height: 100upx;
			position: relative;
			padding-right: 30upx;
		}
		.action-btn{
			width: 160upx;
			height: 60upx;
			margin: 0;
			margin-left: 24upx;
			padding: 0;
			text-align: center;
			line-height: 60upx;
			font-size: $font-sm + 2upx;
			color: $font-color-dark;
			background: #fff;
			border-radius: 100px;
			&:after{
				border-radius: 100px;
			}
			&.recom{
				background: #fff9f9;
				color: $base-color;
				&:after{
					border-color: #f7bcc8;
				}
			}
		}
	}
	
	
	/* load-more */
	.uni-load-more {
		display: flex;
		flex-direction: row;
		height: 80upx;
		align-items: center;
		justify-content: center
	}
	
	.uni-load-more__text {
		font-size: 28upx;
		color: #999
	}
	
	.uni-load-more__img {
		height: 24px;
		width: 24px;
		margin-right: 10px
	}
	
	.uni-load-more__img>view {
		position: absolute
	}
	
	.uni-load-more__img>view view {
		width: 6px;
		height: 2px;
		border-top-left-radius: 1px;
		border-bottom-left-radius: 1px;
		background: #999;
		position: absolute;
		opacity: .2;
		transform-origin: 50%;
		animation: load 1.56s ease infinite
	}
	
	.uni-load-more__img>view view:nth-child(1) {
		transform: rotate(90deg);
		top: 2px;
		left: 9px
	}
	
	.uni-load-more__img>view view:nth-child(2) {
		transform: rotate(180deg);
		top: 11px;
		right: 0
	}
	
	.uni-load-more__img>view view:nth-child(3) {
		transform: rotate(270deg);
		bottom: 2px;
		left: 9px
	}
	
	.uni-load-more__img>view view:nth-child(4) {
		top: 11px;
		left: 0
	}
	
	.load1,
	.load2,
	.load3 {
		height: 24px;
		width: 24px
	}
	
	.load2 {
		transform: rotate(30deg)
	}
	
	.load3 {
		transform: rotate(60deg)
	}
	
	.load1 view:nth-child(1) {
		animation-delay: 0s
	}
	
	.load2 view:nth-child(1) {
		animation-delay: .13s
	}
	
	.load3 view:nth-child(1) {
		animation-delay: .26s
	}
	
	.load1 view:nth-child(2) {
		animation-delay: .39s
	}
	
	.load2 view:nth-child(2) {
		animation-delay: .52s
	}
	
	.load3 view:nth-child(2) {
		animation-delay: .65s
	}
	
	.load1 view:nth-child(3) {
		animation-delay: .78s
	}
	
	.load2 view:nth-child(3) {
		animation-delay: .91s
	}
	
	.load3 view:nth-child(3) {
		animation-delay: 1.04s
	}
	
	.load1 view:nth-child(4) {
		animation-delay: 1.17s
	}
	
	.load2 view:nth-child(4) {
		animation-delay: 1.3s
	}
	
	.load3 view:nth-child(4) {
		animation-delay: 1.43s
	}
	
	@-webkit-keyframes load {
		0% {
			opacity: 1
		}
	
		100% {
			opacity: .2
		}
	}
</style>
