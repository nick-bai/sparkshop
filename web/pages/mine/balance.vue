<template>
	<view class="container">
		<div class="header-card">
			<div class="headerCon">
				<div class="account acea-row row-top row-between">
					<div class="assets">
						<div class="title-color">总余额(元)</div>
						<div class="money">{{ baseInfo.balance }}</div>
					</div>
					<div class="recharge" @click="recharge()">充值</div>
				</div>
				<div class="cumulative acea-row row-top">
					<div class="item">
						<div class="title-color">累计充值(元)</div>
						<div class="money">{{ baseInfo.rechargeAmount }}</div>
					</div>
					<div class="item">
						<div class="title-color">累计消费(元)</div>
						<div class="money">{{ baseInfo.spendAmount }}</div>
					</div>
				</div>
			</div>
		</div>
		<div class="navbar">
			<div class="nav-item" :class="{current: filterIndex === 0}" @click="tabClick(0)">
				全部
			</div>
			<div class="nav-item" :class="{current: filterIndex === 1}" @click="tabClick(1)">
				消费
			</div>
			<div class="nav-item" :class="{current: filterIndex === 2}" @click="tabClick(2)">
				充值
			</div>
		</div>
		<div class="balance-list">
			<div class="itemn acea-row row-between-wrapper" v-for="item in balanceList" :key="item.id">
				<div>
					<div class="name line1">{{ item.remark }}</div>
					<div>{{ item.create_time }}</div>
				</div>
				<div class="num font-color" v-if="item.type == 1">{{ item.balance }}</div>
				<div class="num" v-else>{{ item.balance }}</div>
			</div>
			<xw-empty :isShow="loadingType == 'empty'" text="暂无相关数据" textColor="#777777" style="margin: 0 auto;"></xw-empty>
		</div>
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
				baseInfo: {
					balance: 0,
					rechargeAmount: 0,
					spendAmount: 0
				},
				filterIndex: 0,
				limit: 10,
				nowPage: 0,
				pages: 1,
				balanceList: [],
				loadingType: 'more', // 加载更多状态
			}
		},
		onLoad(options) {
			this.loadData()
			this.getBaseInfo()
		},
		// 下拉刷新
		onPullDownRefresh() {
			this.loadData('refresh')
		},
		// 加载更多
		onReachBottom() {
			this.loadData()
		},
		methods: {
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
			// 加载商品 ，带下拉刷新和上滑加载
			async loadData(type = 'add') {
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
				let res = await this.$api.balanceLog.getList.get({
					page: this.nowPage,
					limit: this.limit,
					type: this.filterIndex
				});
				uni.hideLoading()
				if (type == 'refresh') {
					uni.stopPullDownRefresh();
				}
				
				let balanceList = res.data.data
				
				if (type === 'add') {
					this.balanceList = this.balanceList.concat(balanceList);
				} else {
					this.balanceList = balanceList
				}
				
				this.pages = res.data.last_page
				
				if (this.pages == 0 || this.pages == this.nowPage) {
					if (this.pages > 1) {
						this.loadingType = 'nomore'
					} else {
						this.loadingType = (res.data.total == 0) ? 'empty' : 'nomore2';
					} 
				} else {
					this.loadingType = 'more'
				}
			},
			// 充值
			recharge() {
				uni.navigateTo({
					url: '/pages/mine/recharge'
				})
			},
			// 获取基础信息
			async getBaseInfo() {
				let res = await this.$api.balanceLog.getBaseInfo.get()
				this.baseInfo = res.data
			},
			stopPrevent(){}
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
	.header-card {
		height: 170px;
		width: 100%;
		background: #e93323;
		border-radius: 10px;
	}
	.header-card .headerCon {
	    background-image: url('@/static/balance_bg.png');
		background-repeat: no-repeat;
	    background-size: 100%;
	    height: 100%;
	    width: 100%;
	    padding: 18px 0 14px 0;
	    box-sizing: border-box;
	}
	.headerCon .account {
	    padding: 0 17px;
	}
	.acea-row.row-between {
		justify-content: space-between;
		-webkit-box-pack: justify;
	}
	.acea-row.row-top {
		-webkit-box-align: start;
		align-items: flex-start;
	}
	.acea-row {
		display: flex;
		flex-wrap: wrap;
	}
	.title-color {color: hsla(0,0%,100%,.6);font-size: 13px;}
	.assets .money {
	    font-size: 24px;
		font-family: Guildford Pro;
		color: #fff !important;
		margin-top: 3px;
	}
	.headerCon .cumulative {
	    margin-top: 23px;
	}
	.cumulative .item {
	    flex: 1;
	    padding-left: 17px;
	}
	.cumulative .item .money {color: #fff;font-size: 24px;}
	.account .recharge {
	    font-size: 14px;
	    width: 75px;
	    height: 27px;
	    border-radius: 13px;
	    background-color: #fff9f8;
	    text-align: center;
	    line-height: 27px;
	    color: #e93323;
	}
	.navbar{
		margin-top: 20px;
		display: flex;
		width: 100%;
		height: 80upx;
		background: #fff;
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
					width: 100%;
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
	.balance-list {
		background-color: #fff;
	    font-size: 12px;
	    color: #999;
	}
	.balance-list .itemn {
		border-bottom: 1px solid #eee;
		padding: 15px;
	}
	.acea-row.row-between-wrapper {
		-webkit-box-align: center;
		align-items: center;
		-webkit-box-pack: justify;
		justify-content: space-between;
		display: flex;
		flex-wrap: wrap;
	}
	.balance-list .name {
	    font-size: 14px;
	    color: #282828;
		width: 195px;
	    margin-bottom: 5px;
	}
	
	.line1 {
	    overflow: hidden;
	    text-overflow: ellipsis;
	    white-space: nowrap;
	}
	.font-color {font-size: 18px;color: #e93323 !important}
	.num {
		font-size: 18px;
		font-family: Guildford Pro;
		color: #16ac57;
	}
</style>