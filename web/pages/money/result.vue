<template>
	<view class="order-result">
		<uni-icons type="checkbox-filled" size="70" color="#67C23A" class="order-success-icon" v-if="pay_status == 2"></uni-icons>
		<uni-icons type="clear" size="70" class="order-success-icon" v-else></uni-icons>
		<uni-card>
			<h2 class="result-title" v-if="pay_status == 2">订单支付成功</h2>
			<h2 class="result-title" v-else>订单支付失败</h2>
			<view class="wrapper">
				<view class="item">
					<view>订单号</view>
					<view class="itemCom">{{ order_no }}</view>
				</view>
				<view class="item">
					<view>下单时间</view>
					<view class="itemCom">{{ order_time }}</view>
				</view>
				<view class="item">
					<view>支付方式</view>
					<view class="itemCom">{{ pay_way }}</view>
				</view>
				<view class="item">
					<view>支付金额</view>
					<view class="itemCom">{{ pay_price }}</view>
				</view>
			</view>
			<view class="btn-group">
				<navigator url="/pages/order/order?state=0" open-type="redirect" class="mix-btn">查看订单</navigator>
				<navigator url="/pages/index/index" open-type="switchTab" class="mix-btn hollow">返回首页</navigator>
			</view>
		</uni-card>
	</view>
	
</template>

<script>
	export default {
		data() {
			return {
				pay_status: 2,
				order_no: '',
				order_time: '',
				pay_way: '',
				pay_price: '',
			}
		},
		onLoad(option) {
			this.order_no = option.order_no
			this.getOrderInfo()
		},
		methods: {
			goto(url) {
				uni.redirectTo({
					url: url
				})
			},
			async getOrderInfo() {
				let res = await this.$api.order.getOrderInfo.get({order_no: this.order_no})
				this.order_time = res.data.create_time
				this.pay_way = (res.data.pay_way == 1) ? '微信' : (res.data.pay_way == 2) ? '支付宝' : '余额'
				this.pay_price = res.data.pay_price
				this.pay_status = res.data.pay_status
			}
		}
	}
</script>

<style lang="scss">
.order-result {
	height: 100vh;
	margin: 10% auto;
}
.order-success-icon {
	position: relative;
	top: 49px;
	z-index: 99;
	left: 43%;
}
.result-title {
	font-size: 16px;
	font-weight: 700;
	text-align: center;
	margin: 25px 0 18px 0;
	color: #333;
}
.wrapper {
	border: 1px solid #eee;
	margin: 0 15px 23px 15px;
	padding: 17px 0;
	border-left: 0;
	border-right: 0;
}
.wrapper .item {
	margin-top: 10px;
	font-size: 14px;
	color: #282828;
	-webkit-box-align: center;
	align-items: center;
	-webkit-box-pack: justify;
	display: flex;
	justify-content: space-between;
}
.wrapper .item .itemCom {
	color: #666;
}

.mix-btn {
	margin-top: 30upx;
	display: flex;
	align-items: center;
	justify-content: center;
	width: 600upx;
	height: 80upx;
	font-size: $font-lg;
	color: #fff;
	background-color: $base-color;
	border-radius: 10upx;
	&.hollow{
		background: #fff;
		color: #303133;
		border: 1px solid #ccc;
	}
}
</style>
