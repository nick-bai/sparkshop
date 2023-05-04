<template>  
    <view class="container">  
		
		<view class="user-section">
			<view class="user-info-box">
				<view class="portrait-box">
					<image class="portrait" :src="userInfo.avatar || '/static/missing-face.png'"></image>
				</view>
				<view class="info-box">
					<text class="username">{{userInfo.nickname || '游客'}}</text>
					<br/>
					<text style="font-size: 14px;" class="username">ID: {{userInfo.id}}</text>
				</view>
			</view>
			<view class="vip-card-box" v-if="sysConfig.userVip == 1" :style='vipCardBg'>
				<view class="b-btn" style="font-weight: 700;font-size: 15px;">
					V{{ levelInfo.level }}
				</view>
				<view class="tit">
				   会员等级
				</view>
				<progress :percent="vipPercent" stroke-width="4" activeColor="#e93323" backgroundColor="#fff" style="margin-top: 40px;width:200px"/>
				{{ userInfo.experience }}/{{ levelInfo.next_experience }}
			</view>
		</view>
		
		<view 
			class="cover-container"
			:style="[{
				transform: coverTransform,
				transition: coverTransition
			}]"
			@touchstart="coverTouchstart"
			@touchmove="coverTouchmove"
			@touchend="coverTouchend"
		>
			<image class="arc" src="/static/arc.png"></image>
			
			<view class="tj-sction">
				<view class="tj-item" @click="navTo('/pages/mine/balance')">
					<text class="num">{{ userInfo.balance }}</text>
					<text>余额</text>
				</view>
				<view class="tj-item" v-if="sysConfig.coupon == 1">
					<text class="num">0</text>
					<text>优惠券</text>
				</view>
				<view class="tj-item" v-else>
					<text class="num">{{ orderNum }}</text>
					<text>订单数</text>
				</view>
				<view class="tj-item" v-if="sysConfig.integral == 1">
					<text class="num">20</text>
					<text>积分</text>
				</view>
				<view class="tj-item" v-else>
					<text class="num">{{ userCollection }}</text>
					<text>收藏数</text>
				</view>
			</view>
			<!-- 订单 -->
			<view style="background: #fff;margin-top: 10px;">
				<view class="status-title">
					<text style="font-weight: 500;">订单中心</text>
					<view @click="navTo('/pages/order/order?status=-1')" hover-class="common-hover"  :hover-stay-time="50">
						<text style="color: #666;font-size: 13px;">全部</text>
						<uni-icons type="right" size="13"color="#666"></uni-icons>
					</view>
				</view>
				<view class="order-section">
					<uni-badge :text="orderBar.unPaid" absolute="rightTop" size="small" :custom-style="badgeStyle">
						<view class="order-item" @click="navTo('/pages/order/order?status=2')"  hover-class="common-hover" :hover-stay-time="50">
							<uni-icons custom-prefix="iconfont" type="icon-daifukuan" size="30" color="$icon-color" class="icon-class"></uni-icons>
							<text>待付款</text>
						</view>
					</uni-badge>
					<uni-badge :text="orderBar.unExpress" absolute="rightTop" size="small" :custom-style="badgeStyle">
						<view class="order-item" @click="navTo('/pages/order/order?status=3')" hover-class="common-hover"  :hover-stay-time="50">
							<uni-icons custom-prefix="iconfont" type="icon-daifahuo" size="30" color="$icon-color" class="icon-class"></uni-icons>
							<text>待发货</text>
						</view>
					</uni-badge>
					<uni-badge :text="orderBar.unReceive" absolute="rightTop" size="small" :custom-style="badgeStyle">
						<view class="order-item" @click="navTo('/pages/order/order?status=4')" hover-class="common-hover"  :hover-stay-time="50">
							<uni-icons custom-prefix="iconfont" type="icon-daishouhuo" size="30" color="$icon-color" class="icon-class"></uni-icons>
							<text>待收货</text>
						</view>
					</uni-badge>
					<uni-badge :text="orderBar.unAppraise" absolute="rightTop" size="small" :custom-style="badgeStyle">
						<view class="order-item" @click="navTo('/pages/order/order?status=0')" hover-class="common-hover"  :hover-stay-time="50">
							<uni-icons custom-prefix="iconfont" type="icon-daipingjia" size="30" color="$icon-color" class="icon-class"></uni-icons>
							<text>待评价</text>
						</view>
					</uni-badge>
					<uni-badge :text="orderBar.refund" absolute="rightTop" size="small" :custom-style="badgeStyle">
						<view class="order-item" @click="navTo('/pages/refund/refundList')" hover-class="common-hover"  :hover-stay-time="50">
							<uni-icons custom-prefix="iconfont" type="icon-shouhou" size="30" color="$icon-color" class="icon-class"></uni-icons>
							<text>退款/售后</text>
						</view>
					</uni-badge>
				</view>
			</view>
			<!-- 浏览历史 -->
			<view style="background: #fff;margin-top: 10px;">
				<text style="position: relative;top: 10px;left: 10px;">我的服务</text>
				<view class="user-menus">
					<view class="user-item" @click="navTo('/pages/coupon/index')" hover-class="common-hover" :hover-stay-time="50" v-if="sysConfig.coupon == 1">
						<uni-icons custom-prefix="iconfont" type="icon-youhuiquan" size="30" color="$icon-color" class="icon-class"></uni-icons>
						<text>我的卡券</text>
					</view>
					<view class="user-item" @click="navTo('/pages/address/address')" hover-class="common-hover" :hover-stay-time="50">
						<uni-icons custom-prefix="iconfont" type="icon-dizhi" size="30" color="$icon-color" class="icon-class"></uni-icons>
						<text>我的地址</text>
					</view>
					<view class="user-item" @click="navTo('/pages/order/order?status=2')" hover-class="common-hover" :hover-stay-time="50" v-if="sysConfig.integral == 1">
						<uni-icons custom-prefix="iconfont" type="icon-jifen" size="30" color="$icon-color" class="icon-class"></uni-icons>
						<text>积分记录</text>
					</view>
					<!--<view class="user-item" @click="navTo('/pages/address/address')" hover-class="common-hover" :hover-stay-time="50">
						<uni-icons custom-prefix="iconfont" type="icon-huiyuanzhongxin" size="30" color="$icon-color" class="icon-class"></uni-icons>
						<text>我的会员</text>
					</view>-->
					<view class="user-item" @click="navTo('/pages/user/collection')" hover-class="common-hover" :hover-stay-time="50">
						<uni-icons custom-prefix="iconfont" type="icon-shoucang" size="30" color="$icon-color" class="icon-class"></uni-icons>
						<text>我的收藏</text>
					</view>
					<view class="user-item" @click="navTo('/pages/mine/balance')" hover-class="common-hover" :hover-stay-time="50">
						<uni-icons type="wallet-filled" size="30" color="$icon-color" class="icon-class"></uni-icons>
						<text>我的余额</text>
					</view>
					
					<view class="user-item" @click="navTo('/pages/set/set')"  hover-class="common-hover" :hover-stay-time="50">
						<uni-icons custom-prefix="iconfont" type="icon-shezhi" size="30" color="$icon-color" class="icon-class"></uni-icons>
						<text>设置</text>
					</view>
				</view>
			</view>
		</view>
		<view class="copyright">本系统由 SparkShop 强力驱动</view>
    </view>  
</template>  
<script>  
	import listCell from '@/components/mix-list-cell';
	import store from '@/store';
	import {
		goLogin,
		checkLogin
	} from '@/libs/login';
	let startY = 0, moveY = 0, pageAtTop = true;
    export default {
		components: {
			listCell
		},
		data() {
			return {
				orderBar: {
					unPaid: 0,
					unExpress: 0,
					unReceive: 0,
					unAppraise: 0,
					refund: 0,
				},
				coverTransform: 'translateY(0px)',
				coverTransition: '0s',
				moving: false,
				userInfo: {
					id: 0,
					avatar: "",
					nickname: ""
				},
				vipPercent: '',
				levelInfo: {},
				vipCardBg: '',
				sysConfig: {},
				userCollection: 0,
				orderNum: 0,
				badgeStyle: {'background': '#fff', 'border': '1px solid #e93323', 'color': '#e93323', 'top': '-2px', 'right': '2px'}
			}
		},
		onLoad() {
		},
		onShow() {
			this.getUserInfo()
			this.getUserBaseInfo()
		},
        methods: {
			/**
			 * 统一跳转接口,拦截未登录路由
			 * navigator标签现在默认没有转场动画，所以用view
			 */
			navTo(url) {
				if(!this.isLogin) {
					url = '/pages/public/login';
				}
				
				uni.navigateTo({  
					url
				})  
			}, 
			// 获取用户信息
			async getUserInfo() {
				// 登录过期自动登录
				this.isLogin = this.$store.getters.isLogin
				if (!this.isLogin) {
					goLogin();
				}
			},
			// 获取用户基础信息
			async getUserBaseInfo() {
				let res = await this.$api.user.getUserBaseInfo.get()
				this.sysConfig = res.data.config
				this.userCollection = res.data.userCollection
				this.orderNum = res.data.orderNum
				this.orderBar = res.data.orderBar
				
				if (this.sysConfig.userVip == 1) {
					if (res.data.levelInfo.level == 0) {
						this.vipCardBg = 'background: linear-gradient(-90deg,#e7b667,#ffeab5);'
					} else {
						this.vipCardBg = 'background: url(' + res.data.levelInfo.card_bg + ') no-repeat center;'
					}
				}
				
				this.levelInfo = res.data.levelInfo
				this.userInfo = res.data.userInfo
				
				let percent = 0
				if (this.levelInfo.next_experience > 0) {
					percent = (this.userInfo.experience / this.levelInfo.next_experience).toFixed(2)
				}
				
				this.vipPercent = percent > 1 ? 100 : percent * 100
			},
	
			/**
			 *  会员卡下拉和回弹
			 *  1.关闭bounce避免ios端下拉冲突
			 *  2.由于touchmove事件的缺陷（以前做小程序就遇到，比如20跳到40，h5反而好很多），下拉的时候会有掉帧的感觉
			 *    transition设置0.1秒延迟，让css来过渡这段空窗期
			 *  3.回弹效果可修改曲线值来调整效果，推荐一个好用的bezier生成工具 http://cubic-bezier.com/
			 */
			coverTouchstart(e) {
				if (pageAtTop === false) {
					return;
				}
				
				this.coverTransition = 'transform .1s linear';
				startY = e.touches[0].clientY;
			},
			coverTouchmove(e) {
				moveY = e.touches[0].clientY;
				let moveDistance = moveY - startY;
				if(moveDistance < 0){
					this.moving = false;
					return;
				}
				
				this.moving = true;
				if(moveDistance >= 80 && moveDistance < 100) {
					moveDistance = 80;
				}
		
				if(moveDistance > 0 && moveDistance <= 80) {
					this.coverTransform = `translateY(${moveDistance}px)`;
				}
			},
			coverTouchend() {
				if(this.moving === false) {
					return;
				}
				
				this.moving = false;
				this.coverTransition = 'transform 0.3s cubic-bezier(.21,1.93,.53,.64)';
				this.coverTransform = 'translateY(0px)';
			}
        }  
    }  
</script>  
<style lang='scss'>
	page {
		width: 100%;
		height: 100%;
		position: absolute;
		background: #f5f5f5;
	}
	%flex-center {
	 display:flex;
	 flex-direction: column;
	 justify-content: center;
	 align-items: center;
	}
	%section {
	  display:flex;
	  justify-content: space-around;
	  align-content: center;
	  background: #fff;
	  border-radius: 10upx;
	}
	.container {
		height: 100%;
		width: 100%;
	}
	.nav-icon {
	  width: 48rpx;
	  height: 52rpx;
	  vertical-align: -0.15em;
	  fill: currentColor;
	  overflow: hidden;
	  margin-bottom: 14rpx;
	}
	.t-icon-jifen {
		height: 43rpx !important;
		margin-bottom: 8rpx !important;
	}
	.t-icon-huiyuan {
		height: 43rpx !important;
		margin-bottom: 8rpx !important;
	}
	.user-section{
		height: 520upx;
		padding: 100upx 30upx 0;
		position:relative;
		background: $uni-color-primary;
		.bg{
			position:absolute;
			left: 0;
			top: 0;
			width: 100%;
			height: 100%;
			filter: blur(1px);
			opacity: .7;
		}
	}
	.user-info-box{
		height: 180upx;
		display:flex;
		align-items:center;
		position:relative;
		z-index: 1;
		.portrait{
			width: 130upx;
			height: 130upx;
			border:5upx solid #fff;
			border-radius: 50%;
		}
		.username{
			font-size: $font-lg + 6upx;
			color: #fff;
			margin-left: 20upx;
		}
	}

	.vip-card-box{
		display:flex;
		flex-direction: column;
		color: #ae5a2a;
		background: #f7d680;
		height: 240upx;
		overflow: hidden;
		position: relative;
		padding: 20upx 24upx;
		border-radius: 10px;
		.card-bg{
			position:absolute;
			top: 20upx;
			right: 0;
			width: 380upx;
			height: 260upx;
		}
		.b-btn{
			position: absolute;
			right: 20upx;
			top: 16upx;
			width: 132upx;
			height: 40upx;
			text-align: center;
			line-height: 40upx;
			font-size: 28upx;
			border-radius: 20px;
			background: linear-gradient(left, #f9e6af, #ffd465);
			z-index: 1;
		}
		.tit{
			font-size: $font-base+2upx;
			color: #ae5a2a;
			margin-bottom: 28upx;
			.yticon{
				color: #f7d680;
				margin-right: 16upx;
			}
		}
		.e-b{
			font-size: $font-sm;
			color: #d8cba9;
			margin-top: 10upx;
		}
	}
	.cover-container{
		background: $page-color-base;
		margin-top: -150upx;
		padding: 0 30upx;
		position:relative;
		background: #f5f5f5;
		padding-bottom: 20upx;
		.arc{
			position:absolute;
			left: 0;
			top: -34upx;
			width: 100%;
			height: 36upx;
		}
	}
	.tj-sction{
		@extend %section;
		.tj-item{
			@extend %flex-center;
			flex-direction: column;
			height: 140upx;
			font-size: $font-sm;
			color: #75787d;
		}
		.num{
			font-size: $font-lg;
			color: $font-color-dark;
			margin-bottom: 8upx;
		}
	}
	.order-section{
		@extend %section;
		padding: 28upx 0;
		.order-item{
			@extend %flex-center;
			width: 120upx;
			height: 120upx;
			border-radius: 10upx;
			font-size: $font-sm;
			color: $font-color-dark;
		}
		.yticon{
			font-size: 48upx;
			margin-bottom: 18upx;
			color: $uni-color-primary;
		}
		.icon-shouhoutuikuan{
			font-size:44upx;
		}
	}
	.history-section{
		padding: 30upx 0 0;
		margin-top: 20upx;
		background: #fff;
		border-radius:10upx;
		.sec-header{
			display:flex;
			align-items: center;
			font-size: $font-base;
			color: $font-color-dark;
			line-height: 40upx;
			margin-left: 30upx;
			.yticon{
				font-size: 44upx;
				color: $uni-color-primary;
				margin-right: 16upx;
				line-height: 40upx;
			}
		}
		.h-list{
			white-space: nowrap;
			padding: 30upx 30upx 0;
			image{
				display:inline-block;
				width: 160upx;
				height: 160upx;
				margin-right: 20upx;
				border-radius: 10upx;
			}
		}
	}
	.copyright {
		font-size: 12px;
		color:#909399;
		position: absolute;
		bottom: 15px;
		left: 28%;
	}
	.user-menus {
		margin-top: 25px;
		display: flex;
		flex-wrap: wrap;
		padding: 0;
	}
	.user-menus .user-item {
	    position: relative;
	    display: flex;
	    align-items: center;
	    justify-content: space-between;
	    flex-direction: column;
	    width: 25%;
	    margin-bottom: 23px;
	    font-size: 13px;
	    color: #333;
	}
	.icon-class {color: $icon-color}
	.status-title {
		justify-content: space-between;
		padding: 15px 10px 5px 15px;
		margin-top: 12px;
		font-size: 15px;
		color: #282828;
		display: flex;
	}
</style>