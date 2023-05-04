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
		<xw-empty :isShow="navList[tabCurrentIndex].couponList.length == 0" text="暂无优惠券" textColor="#777777" style="margin: 0 auto;"></xw-empty>
		<swiper :current="tabCurrentIndex" class="swiper-box" duration="300">
			<swiper-item class="tab-content" v-for="(tabItem,tabIndex) in navList" :key="tabIndex">
				<scroll-view 
					class="list-scroll-content" 
					scroll-y
					@scrolltolower="loadData"
				>
					<view class="coupon-item" v-for="(item,index) in tabItem.couponList" :key="index">
						<view class="con">
							<view class="left">
								<text class="title">{{item.name}}</text>
								<text class="time" v-if="item.validity_type == 1">{{ item.start_time }}至{{ item.end_time }}</text>
								<text class="time" v-else>领取后{{ item.receive_useful_day }}日内可用</text>
							</view>
							<view class="right">
								<text class="price" v-if="item.type == 1">{{parseFloat(item.amount)}}</text>
								<text class="discount" v-else>{{item.discount * 100}}折</text>
								<text v-if="item.is_threshold == 1">满{{ parseFloat(item.threshold_amount) }}元可用</text>
								<text v-else>无门槛</text>
							</view>
							
							<view class="circle l"></view>
							<view class="circle r"></view>
						</view>
						<view class="tips">
							<uni-view class="btn" @click="goToUse()" v-if="item.status == 1">使用</uni-view>
							<uni-view class="btn gray" v-if="item.status == 2">已使用</uni-view>
							<uni-view class="btn gray" v-if="item.status == 3">已过期</uni-view>
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
	import {
		goLogin,
		checkLogin
	} from '@/libs/login';
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
					limit: 8,
					page: 1,
					status: 2
				},
				couponList: [],
				loading: false,
				tabCurrentIndex: 0,
				navList: [
					{
						status: 1,
						text: '未使用',
						loadingType: 'more',
						couponList: []
					},
					{
						status: 2,
						text: '已使用/过期',
						loadingType: 'more',
						couponList: []
					}
				],
			};
		},
		onLoad(options) {
			if (!checkLogin()) {
				goLogin()
			}
			
			this.initData(0)
			this.loadData()
		},
		onShow() {
			if (!checkLogin()) {
				goLogin()
			}
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
					navItem.couponList = [];
				}
				
				let status = navItem.status;
				this.param.status = status;
				navItem.loadingType = 'loading';
				this.loading = true
				
				let res = await this.$api.coupon.myCouponList.get(this.param)
				navItem.couponList = navItem.couponList.concat(res.data.data)
				uni.hideLoading();
				this.pages = res.data.last_page

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
			// 顶部tab点击
			tabClick(index) {
				this.initData(index)
				this.loadData()
			},
			// 前往使用
			goToUse() {
				window.location.href = '/'
			}
		},
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

	/* 优惠券面板 */
	.mask{
		display: flex;
		align-items: flex-end;
		position: fixed;
		left: 0;
		top: var(--window-top);
		bottom: 0;
		width: 100%;
		background: rgba(0,0,0,0);
		z-index: 9995;
		transition: .3s;
		
		.mask-content{
			width: 100%;
			min-height: 30vh;
			max-height: 70vh;
			background: #f3f3f3;
			transform: translateY(100%);
			transition: .3s;
			overflow-y:scroll;
		}
		&.none{
			display: none;
		}
		&.show{
			background: rgba(0,0,0,.4);
			
			.mask-content{
				transform: translateY(0);
			}
		}
	}

	/* 优惠券列表 */
	.coupon-item{
		display: flex;
		flex-direction: column;
		margin: 20upx 24upx;
		background: #fff;
		.con{
			display: flex;
			align-items: center;
			position: relative;
			height: 120upx;
			padding: 0 30upx;
			&:after{
				position: absolute;
				left: 0;
				bottom: 0;
				content: '';
				width: 100%;
				height: 0;
				border-bottom: 1px dashed #f3f3f3;
				transform: scaleY(50%);
			}
		}
		.left{
			display: flex;
			flex-direction: column;
			justify-content: center;
			flex: 1;
			overflow: hidden;
			height: 100upx;
		}
		.title{
			font-size: 32upx;
			color: $font-color-dark;
			margin-bottom: 10upx;
		}
		.time{
			font-size: 24upx;
			color: $font-color-light;
		}
		.right{
			display: flex;
			flex-direction: column;
			justify-content: center;
			align-items: center;
			font-size: 26upx;
			color: $font-color-base;
			height: 100upx;
		}
		.price{
			font-size: 44upx;
			color: $base-color;
			&:before{
				content: '￥';
				font-size: 34upx;
			}
		}
		.tips{
			font-size: 24upx;
			color: $font-color-light;
			line-height: 60upx;
			padding-left: 30upx;
		}
		.circle{
			position: absolute;
			left: -6upx;
			bottom: 22upx;
			z-index: 10;
			width: 20upx;
			height: 20upx;
			background: #f3f3f3;
			border-radius: 100px;
			&.r{
				left: auto;
				right: -6upx;
			}
		}
	}
	.btn {
	    width: 70px;
	    height: 22px;
	    border-radius: 11px;
	    font-size: 11px;
	    text-align: center;
	    line-height: 22px;
	    color: #fff;
		background: #e93323;
		float: right;
		margin-right: 15px;
		margin-bottom: 10px;
	}
	.coupon-item .discount {
	    font-size: 22px;
	    color: #e93323;
	}
	.gray {
	    background: #888 !important;
	}
</style>

