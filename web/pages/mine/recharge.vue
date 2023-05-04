<template>
	<view class="price-bg">
		<div class="price">
			<div class="title">我的余额</div>
			<span class="price-font">
				<span class="num">￥</span>
				{{ nowBalance }}
			</span>
		</div>
		
		<view class="tip picList" style="padding: 30px 10px 20px 20px;border-top-right-radius: 19px;border-top-left-radius: 19px;">
			<view class="pic-box pic-box-color acea-row row-center-wrapper row-column" :class="{'pic-box-color-active': ckAmount == 10}">
				<view class="pic-number-pic" @click="checkMoney(10)">10<span class="pic-number">元</span></view>
			</view>
			<view class="pic-box pic-box-color acea-row row-center-wrapper row-column" :class="{'pic-box-color-active': ckAmount == 30}">
				<view class="pic-number-pic" @click="checkMoney(30)">30<span class="pic-number">元</span></view>
			</view>
			<view class="pic-box pic-box-color acea-row row-center-wrapper row-column" :class="{'pic-box-color-active': ckAmount == 50}">
				<view class="pic-number-pic" @click="checkMoney(50)">50<span class="pic-number">元</span></view>
			</view>
			<view class="pic-box pic-box-color acea-row row-center-wrapper row-column" :class="{'pic-box-color-active': ckAmount == 100}">
				<view class="pic-number-pic" @click="checkMoney(100)">100<span class="pic-number">元</span></view>
			</view>
			<view class="pic-box pic-box-color acea-row row-center-wrapper row-column" :class="{'pic-box-color-active': ckAmount == 200}">
				<view class="pic-number-pic" @click="checkMoney(200)">200<span class="pic-number">元</span></view>
			</view>
			<view class="pic-box pic-box-color acea-row row-center-wrapper row-column" :class="{'pic-box-color-active': ckAmount == 300}">
				<view class="pic-number-pic" @click="checkMoney(300)">300<span class="pic-number">元</span></view>
			</view>
			<view class="pic-box pic-box-color acea-row row-center-wrapper" :class="{'pic-box-color-active': showDiyAmount == true}" @click="ckDiy()">
				<uni-input class="pic-box-money pic-number-pic">
					<div class="uni-input-wrapper">
						<div class="uni-input-placeholder input-placeholder" :class="{'hide': showDiyAmount == true}">其他</div>
						<input maxlength="140" step="0.000000000000000001" enterkeyhint="done" pattern="[0-9]*" autocomplete="off" type="number" class="uni-input-input" v-model="diyAmount">
					</div>
				</uni-input>
			</view>
			<view class="tips-box">
				<view class="tips mt-30">注意事项：</view>
				<view class="tips-samll">充值后帐户的金额不能提现，可用于商城消费使用</view>
				<view class="tips-samll">账户充值出现问题可联系商城客服</view>
			</view>
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
		</view>
		
		<button class="btn" @click="submit()" :loading="loading">立即充值</button>
	</view>
</template>

<script>
	export default {
		data() {
			return {
				payWay: {
					wechat_pay: 1,
					alipay: 1
				},
				trailData: {
					pay_way: 'wechat_pay',
					amount: 10
				},
				ckAmount: 10,
				showDiyAmount: false,
				canAlipay: false,
				nowBalance: 0,
				diyAmount: '',
				loading: false
			}
		},
		onLoad(option) {
			//#ifdef H5
				this.canAlipay = true
			//#endif
			//#ifdef APP-VUE
				this.canAlipay = true	
			//#endif
		},
		mounted() {
			this.getPayConfig()
		},
		methods: {
			// 获取支付配置
			async getPayConfig() {
				let res = await this.$api.order.getPayConf.get()
				this.nowBalance = res.data.balance
				this.payWay = res.data.config
			},
			// 选择支付方式
			changePayType(type) {
				this.trailData.pay_way = type;
			},
			// 选择支付金额
			checkMoney(amount) {
				this.ckAmount = amount
				this.trailData.amount = amount
				this.showDiyAmount = false
			},
			// 选择自定义
			ckDiy() {
				this.ckAmount = 0
				this.showDiyAmount = true
			},
			// 提交支付订单
			async submit() {
				if (this.showDiyAmount) {
					this.trailData.amount = this.diyAmount
				}
				
				this.loading = true
				let res = await this.$api.balance.createRechargeOrder.post(this.trailData)
				this.loading = false
				if (res.code == 0) {
					let data = res.data
					let self = this
					
					if (this.trailData.pay_way == 'wechat_pay') {
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
								self.$tool.msg('充值成功');
								uni.redirectTo({
									url: '/pages/mine/balance'
								})
							},
						    fail(e) {
								self.$tool.msg('充值失败');
								uni.redirectTo({
									url: '/pages/mine/balance'
								})
							}
						})
						//#endif
					} else if (this.trailData.pay_way == 'alipay') {
						//#ifdef H5
						document.querySelector('body').innerHTML = data
						document.forms[0].submit()
						//#endif
					}
				} else {
					this.$tool.msg(res.msg, 3000);
				}
			}
		}
	}
</script>
	
<style>
	page {
		height: 100%;
		background: #f5f5f5;
	}
	.price-bg {
		padding: 16px 15px 17px 15px;
		margin-bottom: 7px;
		height: 100%;
		width: 100%;
		margin: 0 atuo;
	}
	.hide {
		display: none;
	}
	.price {
		height: 100px;
		width: 100%;
		background: #e93323;
		border-radius: 10px;
		text-align: center;
	}
	.price-font .num {
		font-size: 28px;
	}
	.price .title {
		font-size: 13px;
		color: hsla(0,0%,100%,.8);
		margin-bottom: 10px;
		padding-top: 13px;
	}
	.price-font {
		font-size: 39px;
		color: #fff;
	}
	.payment .tip {
	    font-size: 13px;
	    color: #888;
	    margin-top: 12px;
	}
	.picList {
	    display: flex;
	    flex-wrap: wrap;
	    margin: 15px 0;
		background: #fff;
	}
	.picList .pic-box-color-active {
	    background-color: #e93323 !important;
	    color: #fff!important;
	}
	.picList .pic-box-color {
	    background-color: #f4f4f4;
	    color: #656565;
	}
	.picList .pic-box {
	    width: 31%;
	    height: auto;
	    border-radius: 10px;
	    margin-top: 10px;
	    padding: 10px 0;
	    margin-right: 5px;
	}
	.acea-row.row-center-wrapper {
	    -webkit-box-align: center;
	    -moz-box-align: center;
	    -o-box-align: center;
	    -ms-flex-align: center;
	    -webkit-align-items: center;
	    align-items: center;
	    -webkit-box-pack: center;
	    -moz-box-pack: center;
	    -o-box-pack: center;
	    -ms-flex-pack: center;
	    -webkit-justify-content: center;
	    justify-content: center;
	}
	.acea-row.row-column {
	    -webkit-box-orient: vertical;
	    -moz-box-orient: vertical;
	    -o-box-orient: vertical;
	    -webkit-flex-direction: column;
	    -ms-flex-direction: column;
	    flex-direction: column;
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
	.picList .pic-number-pic {
	    font-size: 19px;
	    margin-right: 5px;
	    text-align: center;
	}
	.picList .pic-number {
	    font-size: 11px;
	}
	.payment .tip {
	    font-size: 13px;
	    color: #888;
	    padding: 0 15px;
	    margin-top: 12px;
	}
	.tips-box {
		margin-top: 20px;
	}
	.tips-box .tips {
		font-size: 14px;
		color: #333;
		font-weight: 800;
		margin-bottom: 7px;
		margin-top: 10px;
	}
	.tips-box .tips-samll {
	    font-size: 12px;
	    color: #333;
	    margin-bottom: 7px;
	}
	.btn {
		height: 40px;
		line-height: 40px;
		border-radius: 8px;
		background: #e93323;
		font-size: 15px;
		color: #fff;
		margin: 15px auto 10px;
		width: 100%;
	}
	.yt-list {
	    margin-top: 8px;
	    background: #fff;
	}
	.pay-way-title {
	    font-size: 13px;
	    padding: 10px 0px 10px 20px;
		color: #333;
		font-weight: 800;
	}
	.clamp {
	    overflow: hidden;
	    text-overflow: ellipsis;
	    white-space: nowrap;
	    display: block;
	}
	.yt-list-cell {
	    display: flex;
	    align-items: center;
	    padding: 5px 15px 5px 20px;
	    line-height: 36px;
	    position: relative;
	}
	.yt-list-cell .cell-tit {
	    flex: 1;
	    font-size: 13px;
	    color: #909399;
	    margin-right: 5px;
	}
	radio {transform:scale(0.8)}
</style>
