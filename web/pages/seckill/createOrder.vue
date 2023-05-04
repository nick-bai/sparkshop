<template>
	<view>
		<!-- 地址 -->
		<navigator url="/pages/address/address" class="address-section">
			<view class="order-content">
				<view class="cen">
					<view class="top">
						<text class="set-address" v-if="!addressData.name">设置收货地址</text>
						<text class="name">{{addressData.name}}</text>
						<text class="mobile">{{addressData.mobile}}</text>
					</view>
					<text class="address">{{addressData.address}} {{addressData.area}}</text>
				</view>
				<text class="yticon icon-you"></text>
			</view>

			<image class="a-bg" src="@/static/bg_line.png"></image>
		</navigator>		
		<view class="goods-section">
			<!-- 商品列表 -->
			<view class="g-item" v-for="item,index in goodsList" :key="index">
				<image :src="item.image"></image>
				<view class="right">
					<text class="title clamp">{{ item.name }}</text>
					<text class="spec" v-if="item.sku">{{ item.sku.split('※').join(' ') }}</text>
					<view class="price-box">
						<text class="price" style="color:#e93323">￥ {{ item.price }}</text>
						<text class="number">x {{ item.num }}</text>
					</view>
				</view>
			</view>
			
		</view>
		
		<!-- 金额明细 -->
		<view class="yt-list">
			<view class="yt-list-cell b-b">
				<text class="cell-tit clamp">秒杀价格</text>
				<text class="cell-tip">￥{{ orderInfo.totalPrice }}</text>
			</view>
			<!--<view class="yt-list-cell b-b">
				<text class="cell-tit clamp">运费</text>
				<text class="cell-tip red">{{ orderInfo.postage }}</text>
			</view>-->
		</view>
		<view class="yt-list">
			<text class="cell-tit clamp pay-way-title">选择支付方式</text>
		</view>
		<view class="yt-list" style="margin-top: 0;">
			<view class="yt-list-cell b-b" @click="changePayType('wechat_pay')" v-if="payWay.wechat_pay == 1">
				<uni-icons custom-prefix="iconfont" type="icon-weixinzhifu" size="25" color="#09bb07" class="icon-class"></uni-icons>
				<text class="cell-tit clamp" style="margin-left: 10px;">微信</text>
				<label class="radio">
					<radio value="" color="#e93323" :checked="trailData.pay_way == 'wechat_pay'" />
					</radio>
				</label>
			</view>
			<view class="yt-list-cell b-b" v-if="canAlipay && payWay.alipay == 1" @click="changePayType('alipay')">
				<uni-icons custom-prefix="iconfont" type="icon-zhifubao" size="25" color="#00aaea" class="icon-class"></uni-icons>
				<text class="cell-tit clamp"style="margin-left: 10px;">支付宝</text>
				<label class="radio">
					<radio value="" color="#e93323" :checked="trailData.pay_way == 'alipay'" />
					</radio>
				</label>
			</view>
			<view class="yt-list-cell b-b"@click="changePayType('balance')" v-if="payWay.balance_pay == 1">
				<uni-icons custom-prefix="iconfont" type="icon-jifen" size="25" color="#f90" class="icon-class"></uni-icons>
				<text class="cell-tit clamp" style="margin-left: 10px;">余额  <text style="color:#e93323;margin-left: 10px;">(可用：￥{{ orderInfo.userBalance }})</text></text>
				<label class="radio">
					<radio value="" color="#e93323" :checked="trailData.pay_way == 'balance'" />
					</radio>
				</label>
			</view>
		</view>	
		<!-- 底部 -->
		<view class="footer">
			<view class="price-content">
				<text>实付款</text>
				<text class="price-tip">￥</text>
				<text class="price">{{ orderInfo.realPay }}</text>
			</view>
			<text class="submit" @click="submit">提交订单</text>
		</view>

	</view>
</template>

<script>
	export default {
		data() {
			return {
				desc: '', //备注
				canAlipay: false,
				orderInfo: {
					postage: 0,
					realPay: 0,
					totalPrice: 0
				},
				addressData: {
					name: '',
					mobile: '',
					address: '',
					area: '',
					default: false,
				},
				orderData: [],
				goodsList: [] , // 购买商品的列表
				trailData: { // 试算数据
					goods: {},
					pay_way: '',
					address_id: 0,
					remark: '',
				},
				payWay: {}
			}
		},
		onLoad(option) {
			uni.getStorage({
				key: 'SECKILL_ORDER',
				success: (res) => {
					this.orderData = res.data
					this.trailData.goods = res.data
					
					this.getOrderInfo()
				}
			})
	
			uni.$on('checkAddress', (data) => {
				this.addressData = data
				this.trail()
			})
			
			//#ifdef H5
				this.canAlipay = true
			//#endif
			//#ifdef APP-VUE
				this.canAlipay = true	
			//#endif
		},
		methods: {
			async submit() {
				uni.showLoading({
					title: '支付中...'
				})
				let res = await this.$api.seckill.createOrder.post(this.trailData)
				uni.hideLoading()
				if (res.code == 0) {
					let data = res.data
					let self = this
	
					if (this.trailData.pay_way == 'wechat_pay') {
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
					} else if (this.trailData.pay_way == 'alipay') {
						uni.getProvider({
						    service: 'payment',
						    success: function (res) {
						        if (~res.provider.indexOf('alipay')) {
						            uni.requestPayment({
						                "provider": "alipay",   // 固定值为"alipay"
						                "orderInfo": orderInfo, // 此处为服务器返回的订单信息字符串
						                success: function (res) {
						                    var rawdata = JSON.parse(res.rawdata);
						                    console.log("支付成功");
						                },
						                fail: function (err) {
						                    this.$tool.msg('支付失败');
						                }
						            });
						        }
						    }
						});
					} else { // 余额支付
						if (res.code == 0) {
							self.$tool.msg('支付成功');
							uni.redirectTo({
								url: '/pages/money/result?order_no=' + res.msg
							})
						} else {
							this.$tool.msg(res.msg, 3000);
						}
					}
				} else {
					this.$tool.msg(res.msg, 3000);
				}
			},
			// 获取订单信息
			async getOrderInfo() {
				let res = await this.$api.seckill.goodsInfo.post({order_data: this.orderData})
				this.goodsList = res.data.goodsList
				this.payWay = res.data.payWayMap
				
				// 选择默认的支付
				if (this.payWay.wechat_pay == 1) {
					this.trailData.pay_way = 'wechat_pay'
				} else if (this.canAlipay && this.payWay.alipay == 1) {
					this.trailData.pay_way = 'alipay'
				} else if (this.payWay.balance_pay == 1) {
					this.trailData.pay_way = 'balance'
				}
				
				this.getAddress()
			},
			// 获取收获地址
			async getAddress() {
				let res = await this.$api.address.defaultAddress.get();
				if (res.code == 0 && res.data) {
					this.addressData.name = res.data.real_name
					this.addressData.mobile = res.data.phone
					this.addressData.address = res.data.province + res.data.city + res.data.county  
					this.addressData.area = res.data.detail
					this.addressData.default = true
					this.trailData.address_id = res.data.id
				}
				
				this.trail()
			},
			// 试算
			async trail(type) {
				let res = await this.$api.seckill.trail.post(this.trailData)
				if (res.code == 0) {
					this.orderInfo = res.data
				} else {
					this.$tool.msg(res.msg);
				}
			},
			//选择支付方式
			changePayType(type) {
				this.trailData.pay_way = type;
			},
			stopPrevent(){}
		}
	}
</script>

<style lang="scss">
	page {
		background: $page-color-base;
		padding-bottom: 100upx;
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
			padding-top: 10px;
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
				font-size: 26upx;
				color: $font-color-light;
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
		line-height: 70upx;
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
			color: $font-color-light;
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
	
	radio {transform:scale(0.8)}
	.icon-class {color: $icon-color}
	.pay-way-title {
		font-size: 13px;
		padding: 10px 0px 10px 20px;
		color: #909399;
	}
</style>
