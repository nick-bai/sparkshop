<template>
	<view class="flash-sale">
		<view class="seckillList acea-row row-between-wrapper">
			<view class="priceTag">
				<image src="../../static/hotsale.png"></image>
			</view>
			<view class='timeLsit'>
				<scroll-view class="scroll-view_x" scroll-x scroll-with-animation :scroll-left="scrollLeft"
					style="height:106rpx;overflow: auto;">
					<block v-for="(item,index) in timeList" :key='index'>
						<view @tap='setTimeList(item, index)' class='item' :class="active == index ? 'on' : ''"
							:id='"sort" + index'>
							<view class='time'>{{ item.start_hour }}</view>
							<view class="state" v-if="item.status == 2">进行中</view>
							<view class="state" v-else-if="item.status == 1">即将开始</view>
							<view class="state" v-else>已结束</view>
						</view>
					</block>
				</scroll-view>
			</view>
		</view>
		
		<view class='list' :style="{background: seckillList.length == 0 ? '#fff' : ''}">
			<block v-for="(item,index) in seckillList" :key='index' v-if="seckillList.length > 0">
				<view class='item acea-row row-between-wrapper'>
					<view class='pictrue'>
						<image :src='item.pic'></image>
					</view>
					<view class='text acea-row row-column-around'>
						<view class='name line1'>{{ item.name }}</view>
						<view class='money' style="width: 100%;">￥
							<text class='num font-color'>{{ item.seckill_price }}</text>
							<text class="y_money">￥{{ item.original_price }}</text>
						</view>
						<view class="limit" style="width: 100%;"> 限量 <text class="limitPrice">{{ item.stock }}</text></view>
						<view class="progress" style="height: 16px;">
							<view class='bg-reds' :style="'width:' + (Math.ceil(item.sales / item.stock)) + '%;'"></view>
							<view class='piece'>已抢 {{ (Math.ceil(item.sales / item.stock)) }}%</view>
						</view>
					</view>
					<view class='grab bg-color running' v-if="nowStatus == 2" @tap='seckillDetailPage(item)'>抢购中</view>
					<view class='grab bg-color ' v-else-if="nowStatus == 1">未开始</view>
					<view class='grab bg-color-hui' v-else>已结束</view>
				</view>
			</block>
			
			<xw-empty :isShow="seckillList.length == 0" text="暂无秒杀商品" textColor="#777777" style="margin: 0 auto;"></xw-empty>
		</view>
		<uni-load-more :status="loadingType"></uni-load-more>
	</view>
</template>

<script>
	import uniLoadMore from '@/components/uni-load-more/uni-load-more.vue';
	export default {
		components: {
			uniLoadMore
		},
		data() {
			return {
				loadingType: 'more', // 加载更多状态
				timeList: [],
				active: 1,
				scrollLeft: 0,
				seckillList: [],
				seachForm: {
					page: 1,
					limit: 6,
					time: ''
				},
				nowStatus: 2
			}
		},
		// 分享给好友
		onShareAppMessage(res) {
			return {
				title: 'SparkShop商城',
				path: '/pages/seckill/index'
			}
		},
		// 分享到朋友圈
		onShareTimeline() {
			return {
				title: 'SparkShop商城',
				path: '/pages/seckill/index'
			};
		},
		mounted() {
			this.getSeckillGoods()
		},
		methods: {
			// 设置样式
			setTimeList(item) {
				this.nowStatus = item.status
				this.seachForm.time = item.start_hour
				this.getSeckillGoods()
			},
			// 去购物
			seckillDetailPage(item) {
				uni.navigateTo({
					url: '/pages/seckill/product?id=' + item.id
				})
			},
			// 获取秒杀商品
			async getSeckillGoods(type) {
				let res = await this.$api.seckill.list.get(this.seachForm)
				if (type == 'refresh') {
					uni.stopPullDownRefresh()
				}
				
				if (type == 'more') {
					if ( res.data.list.data.length > 0) {
						this.seckillList = this.seckillList.concat(res.data.list.data)
					} else {
						this.loadingType = 'empty'
					}
				} else {
					this.seckillList = res.data.list.data
					if (this.seckillList.length == 0) {
						this.loadingType = 'empty'
					}
					this.timeList = res.data.time_line
					this.active = res.data.active
				}
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
				this.seachForm.page = 1
				this.getSeckillGoods('refresh')
			},
			// 加载更多
			onReachBottom() {
				this.seachForm.page += 1
				this.getSeckillGoods('more')
			},
		}
	}
</script>
	
<style>
	page {
		background: #f5f5f5;
	}
	.acea-row.row-between-wrapper {
	    -webkit-box-align: center;
	    -moz-box-align: center;
	    -o-box-align: center;
	    -ms-flex-align: center;
	    -webkit-align-items: center;
	    align-items: center;
	    -webkit-box-pack: justify;
	    -moz-box-pack: justify;
	    -o-box-pack: justify;
	    -ms-flex-pack: justify;
	    -webkit-justify-content: space-between;
	    justify-content: space-between;
	}
	
	.acea-row {
	    display: -webkit-box;
	    display: -moz-box;
	    display: -webkit-flex;
	    display: -ms-flexbox;
	    display: flex;
	    -webkit-box-lines: multiple;
	    -moz-box-lines: multiple;
	    -o-box-lines: multiple;
	    -webkit-flex-wrap: wrap;
	    -ms-flex-wrap: wrap;
	    flex-wrap: wrap;
	}
	.flash-sale {
		margin-bottom: 50px;
		background: #f5f5f5;
	}
	.flash-sale .seckillList {
		padding: 0 20rpx;
	}

	.flash-sale .seckillList .priceTag {
		width: 75rpx;
		height: 70rpx;
	}

	.flash-sale .seckillList .priceTag image {
		width: 100%;
		height: 100%;
	}

	.flash-sale .timeLsit {
		width: 610rpx;
		white-space: nowrap;
		margin: 10rpx 0;
	}

	.flash-sale .timeLsit .item {
		display: inline-block;
		font-size: 20rpx;
		color: #666;
		text-align: center;
		padding: 11rpx 0;
		box-sizing: border-box;
		height: 96rpx;
		margin-right: 34rpx;
	}

	.flash-sale .timeLsit .item .time {
		width: 120rpx;
		font-size: 36rpx;
		font-weight: 600;
		color: #333;
	}

	.flash-sale .timeLsit .item.on .time {
		color: #FF4500;
	}

	.flash-sale .timeLsit .item.on .state {
		width: 120rpx;
		height: 30rpx;
		line-height: 30rpx;
		border-radius: 15rpx;
		background: #FF4500;
		color: #fff;
	}

	.flash-sale .countDown {
		height: 92rpx;
		border-bottom: 1rpx solid #f0f0f0;
		margin-top: -14rpx;
		font-size: 28rpx;
		color: #282828;
	}

	.flash-sale .countDown .num {
		font-size: 28rpx;
		font-weight: bold;
		background-color: #ffcfcb;
		padding: 4rpx 7rpx;
		border-radius: 3rpx;
	}

	.flash-sale .countDown .text {
		font-size: 28rpx;
		color: #282828;
		margin-right: 13rpx;
	}

	.flash-sale .list .item {
		height: 230rpx;
		position: relative;
		width: 710rpx;
		margin: 0 auto 20rpx auto;
		background-color: #fff;
		border-radius: 20rpx;
		padding: 0 25rpx;
	}

	.flash-sale .list .item .pictrue {
		width: 180rpx;
		height: 180rpx;
		border-radius: 10rpx;
	}

	.flash-sale .list .item .pictrue image {
		width: 100%;
		height: 100%;
		border-radius: 10rpx;
	}

	.flash-sale .list .item .text {
		width: 460rpx;
		font-size: 30rpx;
		color: #333;
		height: 166rpx;
	}

	.flash-sale .list .item .text .name {
		width: 100%;
	}

	.flash-sale .list .item .text .money {
		font-size: 30rpx;
		color: #E93323;
	}

	.flash-sale .list .item .text .money .num {
		font-size: 40rpx;
		font-weight: 500;
		font-family: 'Guildford Pro';
	}

	.flash-sale .list .item .text .money .y_money {
		font-size: 24rpx;
		color: #999;
		text-decoration-line: line-through;
		margin-left: 15rpx;
	}

	.flash-sale .list .item .text .limit {
		font-size: 22rpx;
		color: #999;
		margin-bottom: 5rpx;
	}

	.flash-sale .list .item .text .limit .limitPrice {
		margin-left: 10rpx;
	}

	.flash-sale .list .item .text .progress {
		overflow: hidden;
		background-color: #FFEFEF;
		width: 260rpx;
		border-radius: 18rpx;
		height: 18rpx;
		position: relative;
	}

	.flash-sale .list .item .text .progress .bg-reds {
		width: 0;
		height: 100%;
		transition: width 0.6s ease;
		background: linear-gradient(90deg, rgba(233, 51, 35, 1) 0%, rgba(255, 137, 51, 1) 100%);
	}

	.flash-sale .list .item .text .progress .piece {
		position: absolute;
		left: 8%;
		transform: translate(0%, -50%);
		top: 49%;
		font-size: 16rpx;
		color: #FFB9B9;
	}

	.flash-sale .list .item .grab {
		font-size: 28rpx;
		color: #fff;
		width: 150rpx;
		height: 54rpx;
		border-radius: 27rpx;
		text-align: center;
		line-height: 54rpx;
		position: absolute;
		right: 30rpx;
		bottom: 30rpx;
		background: #bbbbbb;
	}

	.flash-sale .saleBox {
		width: 100%;
		height: 230rpx;
		background: var(--view-theme);
		border-radius: 0 0 50rpx 50rpx;
	}
	.line1 {
	    overflow: hidden;
	    text-overflow: ellipsis;
	    white-space: nowrap;
	}
	.running {
		background: #FF4500 !important;
	}
</style>