<template>
	<view class="container">
		<!-- 小程序头部兼容 -->
		<!-- #ifdef MP -->
		<view class="mp-search-box">
			<input class="ser-input" type="text" placeholder="输入关键字搜索" disabled @click="search"/>
		</view>
		<!-- #endif -->
		
		<!-- 头部轮播 -->
		<view class="carousel-section">
			<!-- 标题栏和状态栏占位符 -->
			<view class="titleNview-placing"></view>
			<!-- 背景色区域 -->
			<view class="titleNview-background" :style="{backgroundColor:titleNViewBackground}"></view>
			<swiper class="carousel" circular @change="swiperChange">
				<swiper-item v-for="(item, index) in carouselList" :key="index" class="carousel-item" @click="sliderToDetailPage(item)">
					<image :src="item.pic_url" />
				</swiper-item>
			</swiper>
			<!-- 自定义swiper指示器 -->
			<view class="swiper-dots">
				<text class="num">{{swiperCurrent+1}}</text>
				<text class="sign">/</text>
				<text class="num">{{swiperLength}}</text>
			</view>
		</view>
		<!-- 分类 -->
		<view class="cate-section">
			<view class="cate-item" @click="navTo('/pages/category/category')" >
				<uni-icons custom-prefix="iconfont" type="icon-fenlei" size="35" color="$icon-color" class="icon-class"></uni-icons>
				<text>分类</text>
			</view>
			<view class="cate-item" @click="navTo('/pages/user/collection')">
				<uni-icons custom-prefix="iconfont" type="icon-shoucang" size="35" color="$icon-color" class="icon-class"></uni-icons>
				<text>收藏</text>
			</view>
			<view class="cate-item" @click="navTo('/pages/coupon/index')" v-if="couponInstalled">
				<uni-icons custom-prefix="iconfont" type="icon-youhuiquan" size="35" color="$icon-color" class="icon-class"></uni-icons>
				<text>优惠券</text>
			</view>
			<view class="cate-item" @click="navTo('/pages/seckill/index')" v-if="seckillInstalled">
				<uni-icons custom-prefix="iconfont" type="icon-miaosha" size="35" color="$icon-color" class="icon-class"></uni-icons>
				<text>秒杀</text>
			</view>
			<view class="cate-item" @click="navTo('/pages/order/order?status=-1')">
				<uni-icons custom-prefix="iconfont" type="icon-dingdan" size="35" color="$icon-color" class="icon-class"></uni-icons>
				<text>订单</text>
			</view>
		</view>

		<!-- 秒杀楼层 -->
		<view class="seckill-section m-t" v-if="seckillInstalled">
			<view class="s-header">
				<text>限时秒杀</text>
				<text class="tip">{{ seckillHour }}点场</text>
				<text class="hour timer">{{ timer.hour }}</text>
				<text class="minute timer">{{ timer.minute }}</text>
				<text class="second timer">{{ timer.seconds }}</text>
				<text class="more-goods" @click="moreSeckill()">查看更多 &gt;</text>
			</view>
			<view class="seckill-goods-list" v-if="seckillGoods.length > 0">
				<view class="seckill-goods-item" v-for="item in seckillGoods" :key="item.id" @click="navToSeckillDetailPage(item)">
					<image :src="item.pic" style="width: 100%;height: 110px;margin-top: 5px;"></image>
					<uni-text class="title clamp"><span>{{ item.name }}</span></uni-text>
					<uni-text class="price"><span>￥{{ item.seckill_price }}</span></uni-text>
				</view>
			</view>
			<view style="background: #fff;" v-else>
				<xw-empty :isShow="seckillGoods.length == 0" text="暂无秒杀商品" textColor="#777777" style="margin: 0 auto;"></xw-empty>
			</view>
		</view>
		
		<!-- 精品热销 -->
		<view class="f-header">
			<view class="tit-box">
				<text class="tit">精品热销</text>
			</view>
		</view>
		<view class="guess-section">
			<view 
				v-for="(item, index) in goodsList" :key="index"
				class="guess-item"
				@click="navToDetailPage(item)"
			>
				<view class="image-wrapper">
					<image :src="item.pic" mode="aspectFill"></image>
				</view>
				<text class="title clamp">{{ item.name }}</text>
				<text class="price">￥{{ item.price }}</text>
			</view>
		</view>
		
		<!-- 新品首发 -->
		<view class="f-header m-t">
			<view class="tit-box">
				<text class="tit">新品首发</text>
			</view>
		</view>
		<view class="guess-section">
			<view 
				v-for="(item, index) in newGoodsList" :key="index"
				class="guess-item"
				@click="navToDetailPage(item)"
			>
				<view class="image-wrapper">
					<image :src="item.pic" mode="aspectFill"></image>
				</view>
				<text class="title clamp">{{ item.name }}</text>
				<text class="price">￥{{ item.price }}</text>
			</view>
		</view>
		<view style="width:100%;height:20px;"></view>
	</view>
</template>

<script>
	
	export default {

		data() {
			return {
				titleNViewBackground: '',
				swiperCurrent: 0,
				swiperLength: 0,
				carouselList: [],
				goodsList: [],
				newGoodsList: [],
				couponInstalled: false,
				seckillInstalled: false,
				seckillGoods: [],
				seckillHour: 0,
				timer: {
					hour: 0,
					minute: 0,
					seconds: 0
				}
			};
		},
		// 分享给好友
		onShareAppMessage(res) {
			return {
				title: 'SparkShop商城',
				path: '/pages/index/index'
			}
		},
		// 分享到朋友圈
		onShareTimeline() {
			return {
				title: 'SparkShop商城',
				path: '/pages/index/index'
			};
		},
		onShow() {
			this.loadData()
			this.timeShow()
		},
		methods: {
			
			async loadData() {
				
				let res = await this.$api.home.home.get();
				
				let carouselList = res.data.slider
				if (carouselList.length > 0) {
					this.titleNViewBackground = carouselList[0].pic_url;
					this.swiperLength = carouselList.length;
					this.carouselList = carouselList;
				}
				
				let goodsList = res.data.hotSale;
				this.goodsList = goodsList || [];
				this.newGoodsList = res.data.newGoods
				this.couponInstalled = res.data.couponInstalled
				this.seckillInstalled = res.data.seckillInstalled
				this.seckillHour = res.data.seckillHour
				this.seckillGoods = res.data.seckillList;
			},
			//轮播图切换修改背景色
			swiperChange(e) {
				const index = e.detail.current;
				this.swiperCurrent = index;
				this.titleNViewBackground = this.carouselList[index].background;
			},
			// 普通商品详情页
			navToDetailPage(item) {
				let id = item.id;
				uni.navigateTo({
					url: `/pages/product/product?id=${id}`
				})
			},
			// 秒杀商品详情
			navToSeckillDetailPage(item) {
				uni.navigateTo({
					url: '/pages/seckill/product?id=' + item.id
				})
			},
			// 导航跳转
			sliderToDetailPage(item) {
				if (item.type == 1) {
					console.log('/#' + item.target_url)
					uni.navigateTo({
						url: `${item.target_url}`
					})
				} else {
					window.location.href = item.target_url
				}
			},
			// 页面跳转
			navTo(url) {
				if (url == '/pages/category/category') {
					uni.switchTab({
						url
					})
				}
				
				uni.navigateTo({
					url
				})
			},
			// 更多的秒杀商品
			moreSeckill() {
				uni.navigateTo({
					url: `/pages/seckill/index`
				})
			},
			// 当前时间
			timeShow() {
				var t = null;
				let self = this
				t = setTimeout(time, 1000); //开始运行
				function time() {
				  clearTimeout(t);  // 清除定时器
				  let dt = new Date();
		
				  self.timer.hour = (dt.getHours() < 10) ? '0' + dt.getHours() : dt.getHours()
				  self.timer.minute = (dt.getMinutes() < 10) ? '0' + dt.getMinutes() : dt.getMinutes()
				  self.timer.seconds = (dt.getSeconds() < 10) ? '0' + dt.getSeconds() : dt.getSeconds()
				  
				  t = setTimeout(time, 1000); //设置定时器，循环运行
				}
			},
			// h5 搜索
			onNavigationBarSearchInputClicked: async function(e) {
				uni.navigateTo({
					url: `/pages/index/search`
				})
			},
			// 小程序搜索
			search() {
				uni.navigateTo({
					url: `/pages/index/search`
				})
			}
		},
	}
</script>

<style lang="scss">
	.nav-icon {
	  width: 78rpx;
	  height: 78rpx;
	  vertical-align: -0.15em;
	  fill: currentColor;
	  overflow: hidden;
	  margin-bottom: 14rpx;
	}
	/* #ifdef MP */
	.mp-search-box{
		position:absolute;
		left: 0;
		top: 30upx;
		z-index: 9999;
		width: 100%;
		padding: 0 80upx;
		.ser-input{
			flex:1;
			height: 56upx;
			line-height: 56upx;
			text-align: center;
			font-size: 28upx;
			color:$font-color-base;
			border-radius: 20px;
			background: rgba(255,255,255,.6);
		}
	}
	page{
		.cate-section{
			position:relative;
			z-index:5;
			border-radius:16upx 16upx 0 0;
			margin-top:-20upx;
		}
		.carousel-section{
			padding: 0;
			.titleNview-placing {
				padding-top: 0;
				height: 0;
			}
			.carousel{
				.carousel-item{
					padding: 0;
				}
			}
			.swiper-dots{
				left:45upx;
				bottom:40upx;
			}
		}
	}
	/* #endif */
	
	
	page {
		background: #f5f5f5;
	}
	.m-t{
		margin-top: 16upx;
	}
	/* 头部 轮播图 */
	.carousel-section {
		position: relative;
		padding-top: 10px;

		.titleNview-placing {
			height: var(--status-bar-height);
			padding-top: 44px;
			box-sizing: content-box;
		}

		.titleNview-background {
			position: absolute;
			top: 0;
			left: 0;
			width: 100%;
			height: 426upx;
			transition: .4s;
		}
	}
	.carousel {
		width: 100%;
		height: 350upx;

		.carousel-item {
			width: 100%;
			height: 100%;
			//padding: 0 28upx;
			overflow: hidden;
		}

		image {
			width: 100%;
			height: 100%;
			border-radius: 10upx;
		}
	}
	.swiper-dots {
		display: flex;
		position: absolute;
		left: 60upx;
		bottom: 15upx;
		width: 72upx;
		height: 36upx;
		background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAMgAAABkCAYAAADDhn8LAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNi1jMTMyIDc5LjE1OTI4NCwgMjAxNi8wNC8xOS0xMzoxMzo0MCAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6OTk4MzlBNjE0NjU1MTFFOUExNjRFQ0I3RTQ0NEExQjMiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6OTk4MzlBNjA0NjU1MTFFOUExNjRFQ0I3RTQ0NEExQjMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIDIwMTcgKFdpbmRvd3MpIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6Q0E3RUNERkE0NjExMTFFOTg5NzI4MTM2Rjg0OUQwOEUiIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6Q0E3RUNERkI0NjExMTFFOTg5NzI4MTM2Rjg0OUQwOEUiLz4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1ldGE+IDw/eHBhY2tldCBlbmQ9InIiPz4Gh5BPAAACTUlEQVR42uzcQW7jQAwFUdN306l1uWwNww5kqdsmm6/2MwtVCp8CosQtP9vg/2+/gY+DRAMBgqnjIp2PaCxCLLldpPARRIiFj1yBbMV+cHZh9PURRLQNhY8kgWyL/WDtwujjI8hoE8rKLqb5CDJaRMJHokC6yKgSCR9JAukmokIknCQJpLOIrJFwMsBJELFcKHwM9BFkLBMKFxNcBCHlQ+FhoocgpVwwnv0Xn30QBJGMC0QcaBVJiAMiec/dcwKuL4j1QMsVCXFAJE4s4NQA3K/8Y6DzO4g40P7UcmIBJxbEesCKWBDg8wWxHrAiFgT4fEGsB/CwIhYE+AeBAAdPLOcV8HRmWRDAiQVcO7GcV8CLM8uCAE4sQCDAlHcQ7x+ABQEEAggEEAggEEAggEAAgQACASAQQCCAQACBAAIBBAIIBBAIIBBAIABe4e9iAe/xd7EAJxYgEGDeO4j3EODp/cOCAE4sYMyJ5cwCHs4rCwI4sYBxJ5YzC84rCwKcXxArAuthQYDzC2JF0H49LAhwYUGsCFqvx5EF2T07dMaJBetx4cRyaqFtHJ8EIhK0i8OJBQxcECuCVutxJhCRoE0cZwMRyRcFefa/ffZBVPogePihhyCnbBhcfMFFEFM+DD4m+ghSlgmDkwlOgpAl4+BkkJMgZdk4+EgaSCcpVX7bmY9kgXQQU+1TgE0c+QJZUUz1b2T4SBbIKmJW+3iMj2SBVBWz+leVfCQLpIqYbp8b85EskIxyfIOfK5Sf+wiCRJEsllQ+oqEkQfBxmD8BBgA5hVjXyrBNUQAAAABJRU5ErkJggg==);
		background-size: 100% 100%;

		.num {
			width: 36upx;
			height: 36upx;
			border-radius: 50px;
			font-size: 24upx;
			color: #fff;
			text-align: center;
			line-height: 36upx;
		}

		.sign {
			position: absolute;
			top: 0;
			left: 50%;
			line-height: 36upx;
			font-size: 12upx;
			color: #fff;
			transform: translateX(-50%);
		}
	}
	/* 分类 */
	.cate-section {
		display: flex;
		justify-content: space-around;
		align-items: center;
		flex-wrap:wrap;
		padding: 30upx 22upx; 
		background: #fff;
		.cate-item {
			display: flex;
			flex-direction: column;
			align-items: center;
			font-size: $font-sm + 2upx;
			color: $font-color-dark;
		}
		/* 原图标颜色太深,不想改图了,所以加了透明度 */
		image {
			width: 88upx;
			height: 88upx;
			margin-bottom: 14upx;
			border-radius: 50%;
			opacity: .7;
			box-shadow: 4upx 4upx 20upx rgba(250, 67, 106, 0.3);
		}
	}
	/* 秒杀专区 */
	.seckill-section{
		.s-header{
			display:flex;
			align-items:center;
			background: #fff;
			height: 92upx;
			line-height: 1;
			.s-img{
				width: 140upx;
				height: 30upx;
			}
			padding: 3px 15px 4px;
			.tip{
				font-size: $font-base;
				color: $font-color-light;
				margin: 0 20upx 0 40upx;
			}
			.timer{
				display:inline-block;
				width: 40upx;
				height: 36upx;
				text-align:center;
				line-height: 36upx;
				margin-right: 14upx;
				font-size: $font-sm+2upx;
				color: #fff;
				border-radius: 2px;
				background: rgba(0,0,0,.8);
			}
			.icon-you{
				font-size: $font-lg;
				color: $font-color-light;
				flex: 1;
				text-align: right;
			}
		}
	}
	.seckill-goods-list {
		display: flex;
		justify-content: space-between;
		padding: 10px 15px 10px 15px;
		.seckill-goods-item {
			width: 115px;
			height: 168px;
			background: #fff;
			.title {
				font-size: 13px !important;
				padding-left: 3px !important;
			}
			.price {
				font-size: 16px;
				color: #e93323;
				line-height: 2;
				font-weight: 500;
				padding-left: 3px;
				margin-top: 10px;
			}
			
		}
	}
	.more-goods {
		font-size: 12px;
		margin-left: auto;
		margin-right: -5px;
		color: #909399;
	}
	
	.f-header{
		display:flex;
		align-items:center;
		height: 100upx;
		padding: 6upx 30upx 8upx;
		background: #fff;
		image{
			flex-shrink: 0;
			width: 80upx;
			height: 80upx;
			margin-right: 20upx;
		}
		.tit-box{
			flex: 1;
			display: flex;
			flex-direction: column;
		}
		.tit{
			font-size: $font-lg +2upx;
			color: #font-color-dark;
			line-height: 1.3;
		}
		.tit2{
			font-size: $font-sm;
			color: $font-color-light;
		}
		.icon-you{
			font-size: $font-lg +2upx;
			color: $font-color-light;
		}
	}
	/* 猜你喜欢 */
	.guess-section{
		display:flex;
		flex-wrap:wrap;
		padding: 0 30upx;
		.guess-item{
			display:flex;
			flex-direction: column;
			width: 48%;
			margin-top: 20upx;
			background: #fff;
			border-radius: 10upx;
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
			background: #fff;
		}
		.title{
			font-size: $font-sm + 2upx;
			color: $font-color-dark;
			line-height: 80upx;
			padding-left: 10px;
			height: 80upx;
		}
		.price{
			font-size: $font-lg;
			color: $uni-color-primary;
			line-height: 1;
			font-weight: 500;
			padding-left: 20upx;
		}
	}
	.icon-class {color: $icon-color}

</style>
