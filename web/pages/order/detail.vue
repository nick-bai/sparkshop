<template>
	<view>
		<!-- 地址 -->
		<view class="address-section" style="background: #fff;">
			<view class="order-content">
				<view class="cen">
					<view class="top">
						<text class="set-address" v-if="!addressData.name"></text>
						<text class="name">{{addressData.name}}</text>
						<text class="mobile">{{addressData.mobile}}</text>
					</view>
					<text class="address">{{addressData.address}} {{addressData.area}}</text>
				</view>
			</view>
			<image class="a-bg" src="@/static/bg_line.png"></image>
		</view>
		<view class="goods-section">
			<!-- 商品列表 -->
			<view v-for="item,index in orderInfo.detail" :key="index">
				<view class="g-item">
					<image :src="item.logo"></image>
					<view class="right">
						<text class="title clamp" style="font-size: 26rpx;">{{ item.goods_name }}</text>
						<text class="spec">
							<text  v-if="item.rule != 0">{{ item.rule.split('※').join(' ') }}</text>
						</text>
						<view class="price-box">
							<text class="price" style="color:#e93323">￥ {{ item.price }}</text>
							<text class="number">x {{ item.cart_num }}</text>
						</view>
					</view>
					<view class="left" style="font-size: 12px;color:#e93323;padding: 10rpx 30rpx;" v-if="orderInfo.refund && orderInfo.refund.status == 1">
						{{ item.apply_refund_num }} 件退款中
					</view>
				</view>
				<view class="action-box b-t" v-if="orderInfo.pay_status == 2 || orderInfo.status == 6">
					<button class="action-btn" @click="refund(item)" v-if="orderInfo.pay_status == 2 && item.refunded_flag == 1 && !orderInfo.refund && orderInfo.can_refund">申请退款</button>
					<button class="action-btn recom" @click="appraise(item)" v-if="orderInfo.status == 6 && item.user_comments == 1">去评价</button>
					<button class="action-btn recom" @click="appraise(item)" v-if="orderInfo.status == 6 && item.user_comments == 2">查看评价</button>
				</view>
			</view>
		</view>

		<view class="yt-list">
			<view class="yt-list-cell">
				<text class="cell-tit clamp">下单编号:</text>
				<text class="cell-tip">{{ orderInfo.order_no }}</text>
			</view>
			<view class="yt-list-cell">
				<text class="cell-tit clamp">下单时间:</text>
				<text class="cell-tip">{{ orderInfo.create_time }}</text>
			</view>
			<view class="yt-list-cell">
				<text class="cell-tit clamp">支付状态:</text>
				<text class="cell-tip">{{ orderInfo.status_txt }}</text>
			</view>
		</view>
		
		<view class="yt-list">
			<view class="yt-list-cell">
				<text class="cell-tit clamp">商品总价:</text>
				<text class="cell-tip">￥{{ orderInfo.order_price }}</text>
			</view>
			<view class="yt-list-cell">
				<text class="cell-tit clamp">配送运费:</text>
				<text class="cell-tip">￥{{ orderInfo.pay_postage }}</text>
			</view>
			<view class="yt-list-cell" v-if="couponOpen == 1">
				<text class="cell-tit clamp">优惠券抵扣:</text>
				<text class="cell-tip">-￥{{ orderInfo.coupon_amount }}</text>
			</view>
			<view class="yt-list-cell" v-if="userVipOpen == 1">
				<text class="cell-tit clamp">会员折扣:</text>
				<text class="cell-tip">-￥{{ orderInfo.vip_discount }}</text>
			</view>
			<view class="yt-list-cell" v-if="orderInfo.status != 2 && orderInfo.status != 3">
				<text class="cell-tit clamp"></text>
				<text class="cell-tip">实际支付:   <text class="real_pay">￥{{ orderInfo.pay_price }}</text></text>
			</view>
		</view>
		
		<view class="yt-list" v-if="orderInfo.status == 4 || orderInfo.status == 6">
			<view class="yt-list-cell">
				<text class="cell-tit clamp">快递公司:</text>
				<text class="cell-tip">{{ orderInfo.delivery_name }}</text>
			</view>
			<view class="yt-list-cell">
				<text class="cell-tit clamp">快递单号:</text>
				<text class="cell-tip">{{ orderInfo.delivery_no }}</text>
			</view>
		</view>
		
		<!-- 底部 -->
		<view class="footer" v-if="!payBoxShow">
			<view class="price-content" v-if="orderInfo.status == 2 || orderInfo.status == 3">
				<text>实付款</text>
				<text class="price-tip">￥</text>
				<text class="price">{{ orderInfo.pay_price }}</text>
			</view>
			<view class="action-box b-t" v-if="orderInfo.status == 2">
				<button class="action-btn" @click="cancel()">取消订单</button>
				<button class="action-btn recom" @click="showPay(orderInfo)">立即支付</button>
			</view>
			<view class="action-box b-t" v-if="orderInfo.refund_status == 1 && orderInfo.detail.length > 1">
				<button class="action-btn" @click="refundAll()">批量退款</button>
			</view>
			<view class="price-content" v-if="orderInfo.status == 4"></view>
			<view class="action-box b-t" v-if="orderInfo.status == 4">
				<button class="action-btn" @click="express()" v-if="orderInfo.goods_type == 1">查看物流</button>
				<button class="action-btn recom" @click="received()">确认收货</button>
			</view>
		</view>
		
		<view>
			<!-- 普通弹窗 -->
			<uni-popup ref="popup" background-color="#fff" type="bottom">
				<view class="popup-content"style="height: 300px">
					<view class="yt-list">
						<text class="cell-tit clamp pay-way-title">选择支付方式</text>
						<uni-icons type="closeempty" size="24" class="close-btn" @click="closePayBox"></uni-icons>
					</view>
					<view class="yt-list" style="margin-top: 0;">
						<view class="yt-list-cell b-b" @click="changePayType('wechat_pay')" v-if="payWayConf.wechat_pay == 1">
							<uni-icons custom-prefix="iconfont" type="icon-weixinzhifu" size="25" color="#09bb07" class="icon-class"></uni-icons>
							<text class="cell-tit clamp" style="margin-left: 10px;">微信</text>
							<label class="radio">
								<radio value="" color="#e93323" :checked="pay_way == 'wechat_pay'" /></radio>
							</label>
						</view>
						<view class="yt-list-cell b-b" v-if="canAlipay && payWayConf.alipay == 1" @click="changePayType('alipay')">
							<uni-icons custom-prefix="iconfont" type="icon-zhifubao" size="25" color="#00aaea" class="icon-class"></uni-icons>
							<text class="cell-tit clamp"style="margin-left: 10px;">支付宝</text>
							<label class="radio">
								<radio value="" color="#e93323" :checked="pay_way == 'alipay'" /></radio>
							</label>
						</view>
						<view class="yt-list-cell b-b"@click="changePayType('balance')" v-if="payWayConf.balance_pay == 1">
							<uni-icons custom-prefix="iconfont" type="icon-jifen" size="25" color="#f90" class="icon-class"></uni-icons>
							<text class="cell-tit clamp" style="margin-left: 10px;">余额  <text style="color:#e93323;margin-left: 10px;">(可用：￥ {{balance}})</text></text>
							<label class="radio">
								<radio value="" color="#e93323" :checked="pay_way == 'balance'" /></radio>
							</label>
						</view>
						<view class="pay-detail">支付：<text>￥</text><text style="color:#e93323;font-size: 20px;">{{ order_price }}</text></view>
						<button type="default" class="do-appraise" @click="goPay">去付款</button>
					</view>	
				</view>
			</uni-popup>
		</view>
		
		
	</view>
</template>

<script>
	export default {
		data() {
			return {
				orderId: 0,
				orderInfo: {},
				userVipOpen: 0,
				couponOpen: 0,
				payWayConf: {},
				canAlipay: false,
				payBoxShow: false,
				pay_way: 'wechat_pay',
				balance: 0,
				order_price: 0,
				addressData: {
					name: '',
					mobile: '',
					address: '',
					area: '',
					default: false,
				}
			}
		},
		onLoad(option) {
			//#ifdef H5
			this.canAlipay = true
			//#endif
			//#ifdef APP-VUE
			this.canAlipay = true	
			//#endif
			
			this.orderId = option.id
			this.getConfig()
			this.getOrderInfo()
			this.getPayConfig()
		},
		methods: {
			// 获取支付配置
			async getPayConfig() {
				let res = await this.$api.order.getPayConf.get()
				this.payWayConf = res.data.config
				this.balance = res.data.balance
			},
			// 获取基础配置
			async getConfig() {
				let res = await this.$api.order.getConfig.get()
				this.userVipOpen = res.data.userVip
				this.couponOpen = res.data.coupon
			},
			// 展示支付方式
			showPay(item) {
				this.order_price = item.pay_price
				this.nowOrder = item
				this.payBoxShow = true
				
				this.$refs.popup.open()
			},
			changePayType(type){
				this.pay_way = type
			},
			// 关闭支付弹窗
			closePayBox() {
				this.payBoxShow = false
				this.$refs.popup.close()
			},
			// 订单信息
			async getOrderInfo() {
				let res = await this.$api.userOrder.detail.get({
					id: this.orderId
				});
				
				if (res.code == 0) {
					let order = res.data.order
					let address = order.address
					this.addressData = {
						name: address.user_name,
						mobile: address.phone,
						address: address.province + address.city + address.county,
						area: address.detail
					}
					
					this.orderInfo = order
				} else {
					this.$tool.msg(res.msg);
				}
			},
			// 去付款
			async goPay() {
			
				let res = await this.$api.userOrder.goPay.post({
					order_id: this.nowOrder.id,
					pay_way: this.pay_way
				})
				
				if (res.code == 0) {
					let data = res.data
					let self = this
					
					if (this.pay_way == 'wechat_pay') {
						//#ifdef H5
						window.location.href = data
						//#endif
						//#ifdef MP
						uni.requestPayment({
						    "provider": "wxpay", 
						    "appId": data.appId,
							"timeStamp": data.timeStamp,
							"nonceStr": data.nonceStr,
							"package": data.package,
							"signType": data.signType,
							"paySign": data.paySign,
						    success(data) {
								self.$tool.msg('支付成功');
								uni.redirectTo({
									url: '/pages/money/result?order_no=' + res.msg
								})
							},
						    fail(e) {
								self.$tool.msg('支付失败');
								uni.redirectTo({
									url: '/pages/money/result?order_no=' + res.msg
								})
							}
						})
						//#endif
					} else if (this.pay_way == 'alipay') {
						//#ifdef H5
						document.querySelector('body').innerHTML = data
						document.forms[0].submit()
						//#endif
					} else { // 余额支付
						if (res.code == 0) {
							self.$tool.msg('支付成功');
							uni.redirectTo({
								url: '/pages/money/result?order_no=' + res.msg
							})
						} else {
							this.$tool.msg(data.msg, 3000);
						}
					}
					
				} else {
					this.$tool.msg(res.msg);
				}
			},
			// 去评价
			appraise(item) {
				uni.navigateTo({
					url: `/pages/order/appraise?order_id=${item.order_id}&order_detail_id=${item.id}`,
				})
			},
			// 退款
			refund(item) {
				let orderNumData = []
				orderNumData.push({
					order_detail_id: item.id,
					num: item.cart_num
				})
				
				uni.setStorage({
					key: 'REFUND_ORDER',
					data: JSON.stringify({ 
							order_id: item.order_id,
							order_detail_id: item.id,
							order_num_data: orderNumData
						})
				})
				
				uni.navigateTo({
					url: `/pages/refund/refund`
				})
			},
			// 取消订单
			async cancel() {
				uni.showLoading({
					title: '处理中'
				});
				let res = await this.$api.userOrder.cancel.get({
					id: this.orderId
				})
				uni.hideLoading()
				if (res.code == 0) {
					this.$tool.msg(res.msg);
					setTimeout(() => {
						uni.$emit('refreshData');
						uni.navigateBack(1)
					}, 800)
				} else {
					this.$tool.msg(res.msg);
				}
			},
			// 物流详情
			express() {
				uni.navigateTo({
					url: `/pages/order/express?order_id=` + this.orderId
				})
			},
			// 申请全部退款
			refundAll() {
				uni.navigateTo({
					url: `/pages/refund/select?order_id=` + this.orderId
				})
			},
			// 确认收货
			async received() {
				uni.showLoading({
					title: '处理中'
				});
				let res = await this.$api.userOrder.received.get({id: this.orderId})
				uni.hideLoading()
				if (res.code == 0) {
					this.$tool.msg(res.msg);
					this.getOrderInfo()
				} else {
					this.$tool.msg(res.msg);
				}
			}
		}
	}
</script>

<style lang="scss">
	page {
		background: $page-color-base;
		padding-bottom: 100upx;
	}
	.set-address {
		margin-left: 50px;
		font-size: 30rpx;
		color:#606266;
	}
	.address-section {
		padding: 30upx 0;
		background: #fff;
		position: relative;

		.order-content {
			display: flex;
			align-items: center;
		}

		.icon-shouhuodizhi {
			flex-shrink: 0;
			display: flex;
			align-items: center;
			justify-content: center;
			width: 90upx;
			color: #888;
			font-size: 44upx;
		}

		.cen {
			display: flex;
			flex-direction: column;
			flex: 1;
			width: 90%;
			font-size: 28upx;
			color: $font-color-dark;
		}

		.name {
			font-size: 34upx;
			margin-right: 24upx;
			margin-left: 30px;
		}

		.address {
			margin-top: 16upx;
			margin-right: 20upx;
			margin-left: 30px;
			overflow: hidden;
			text-overflow: ellipsis;
			white-space: nowrap;
			display: block;
			color: $font-color-light;
		}

		.icon-you {
			font-size: 32upx;
			color: $font-color-light;
			margin-right: 30upx;
		}

		.a-bg {
			position: absolute;
			left: 0;
			bottom: 0;
			display: block;
			width: 100%;
			height: 5upx;
		}
	}

	.goods-section {
		margin-top: 16upx;
		background: #fff;
		padding-bottom: 1px;

		.g-header {
			display: flex;
			align-items: center;
			height: 84upx;
			padding: 0 30upx;
			position: relative;
		}

		.logo {
			display: block;
			width: 50upx;
			height: 50upx;
			border-radius: 100px;
		}

		.name {
			font-size: 30upx;
			color: $font-color-base;
			margin-left: 24upx;
		}

		.g-item {
			display: flex;
			margin: 20upx 30upx;

			image {
				flex-shrink: 0;
				display: block;
				width: 140upx;
				height: 140upx;
				border-radius: 4upx;
			}

			.right {
				flex: 1;
				padding-left: 24upx;
				overflow: hidden;
			}

			.title {
				font-size: 30upx;
				color: $font-color-dark;
			}

			.spec {
				color: $font-color-light;
				font-size:24rpx;
				height: 30rpx;
				display: block;
			}

			.price-box {
				display: flex;
				align-items: center;
				font-size: 32upx;
				color: $font-color-dark;
				padding-top: 10upx;

				.price {
					margin-bottom: 4upx;
				}
				.number{
					font-size: 26upx;
					color: $font-color-base;
					margin-left: 20upx;
				}
			}

			.step-box {
				position: relative;
			}
		}
	}
	.yt-list {
		margin-top: 16upx;
		background: #fff;
	}

	.yt-list-cell {
		display: flex;
		align-items: center;
		padding: 10upx 30upx 10upx 40upx;
		line-height: 50upx;
		position: relative;

		&.cell-hover {
			background: #fafafa;
		}

		&.b-b:after {
			left: 30upx;
		}

		.cell-icon {
			height: 32upx;
			width: 32upx;
			font-size: 22upx;
			color: #fff;
			text-align: center;
			line-height: 32upx;
			background: #f85e52;
			border-radius: 4upx;
			margin-right: 12upx;

			&.hb {
				background: #ffaa0e;
			}

			&.lpk {
				background: #3ab54a;
			}

		}

		.cell-more {
			align-self: center;
			font-size: 24upx;
			color: $font-color-light;
			margin-left: 8upx;
			margin-right: -10upx;
		}

		.cell-tit {
			flex: 1;
			font-size: 26upx;
			color: $font-color-dark;
			margin-right: 10upx;
		}

		.cell-tip {
			font-size: 26upx;
			color: $font-color-dark;

			&.disabled {
				color: $font-color-light;
			}

			&.active {
				color: $base-color;
			}
			&.red{
				color: $base-color;
			}
		}

		&.desc-cell {
			.cell-tit {
				max-width: 90upx;
			}
		}

		.desc {
			flex: 1;
			font-size: $font-base;
			color: $font-color-dark;
		}
	}
	
	/* 支付列表 */
	.pay-list{
		padding-left: 40upx;
		margin-top: 16upx;
		background: #fff;
		.pay-item{
			display: flex;
			align-items: center;
			padding-right: 20upx;
			line-height: 1;
			height: 110upx;	
			position: relative;
		}
		.icon-weixinzhifu{
			width: 80upx;
			font-size: 40upx;
			color: #6BCC03;
		}
		.icon-alipay{
			width: 80upx;
			font-size: 40upx;
			color: #06B4FD;
		}
		.icon-xuanzhong2{
			display: flex;
			align-items: center;
			justify-content: center;
			width: 60upx;
			height: 60upx;
			font-size: 40upx;
			color: $base-color;
		}
		.tit{
			font-size: 32upx;
			color: $font-color-dark;
			flex: 1;
		}
	}
	
	.footer{
		position: fixed;
		left: 0;
		bottom: 0;
		z-index: 995;
		display: flex;
		align-items: center;
		width: 100%;
		height: 90upx;
		justify-content: space-between;
		font-size: 30upx;
		background-color: #fff;
		z-index: 998;
		color: $font-color-base;
		box-shadow: 0 -1px 5px rgba(0,0,0,.1);
		.price-content{
			padding-left: 30upx;
		}
		.price-tip{
			color: $base-color;
			margin-left: 8upx;
		}
		.price{
			font-size: 36upx;
			color: $base-color;
		}
		.submit{
			display:flex;
			align-items:center;
			justify-content: center;
			width: 280upx;
			height: 100%;
			color: #fff;
			font-size: 32upx;
			background-color: $base-color;
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
		height: 59upx;
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
				border-color: #e93323;
			}
		}
	}
	.real_pay {
		color: #e93323 !important;
		font-weight: 700;
		margin-left: 10px;
		font-size: 15px !important;
	}
	.yt-list-cell {
		display: flex;
		align-items: center;
		padding: 5px 15px 5px 20px;
		line-height: 35px;
		position: relative;
	}
	.yt-list-cell .cell-tit{
	    flex: 1;
	    font-size: 13px;
	    color: #909399;
	    margin-right: 5px;
	}
	.clamp {
	    overflow: hidden;
	    text-overflow: ellipsis;
	    white-space: nowrap;
	    display: block;
	}
	radio {transform:scale(0.8)}
	.icon-class {color: $icon-color}
	.pay-way-title {
		font-size: 16px;
		padding: 10px 0px 10px 20px;
		color: #282828;
		width: 200px;
	}
	.close-btn {
		color: #909399 !important;
		font-size: 24px;
		position: absolute;
		right: 5px;
		top: 0px;
	}
	.pay-detail {text-align: center;margin-top: 10px;font-size: 13px;}
	.do-appraise {width: 90% !important;background: #e93323 !important;color: #fff !important;margin-top: 10px !important;font-size: 15px !important;}
</style>
