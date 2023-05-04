<template>
	<view class="container">
		<view class="cart-list">
			<block v-for="(item, index) in cartList" :key="item.id">
				<view
					class="cart-item" 
					:class="{'b-b': index!==cartList.length-1}"
				>
					<view class="image-wrapper" style="height: 80px;width: 80px;">
						<image :src="item.logo" mode="aspectFill" style="opacity:1;height: 80px;width: 80px;"></image>
						<uni-icons type="checkbox-filled" size="25" color="#909399" class="checkbox" :class="{checked: item.checked}" @click="check('item', index)"></uni-icons>
					</view>
					<view class="item-right">
						<text class="clamp title">{{item.goods_name}}</text>
						<text class="attr" v-if="item.rule != 0">{{item.rule.split("※").join(' ')}}</text>
						<text class="attr" v-else></text>
						<text class="price">¥{{item.price}}</text>
						<uni-number-box 
							class="step"
							:min="1"
							:value="item.cart_num"
							:index="index"
							@change="numberChange($event, index)"
						></uni-number-box>
					</view>
				</view>
			</block>
		</view>

		<button type="default" class="do-appraise" @click="applyRefund">申请退款</button>
	</view>
</template>

<script>
	export default {
		
		data() {
			return {
				cartList: [],
				orderId: 0
			};
		},
		onLoad(options) {
			this.orderId = options.order_id
		},
		onShow() {
			this.getList();
		},
		methods: {
			//请求数据
			async getList() {
				let res = await this.$api.userOrder.detail.get({id: this.orderId})
				let list = res.data.order.detail
				
				this.cartList = []
				list.forEach((item) => {
					item.checked = false
					this.cartList.push(item)
				})
			},
			 // 选中状态处理
			check(type, index) {
				if (type === 'item') {
					this.cartList[index].checked = !this.cartList[index].checked;
				} else {
					const checked = !this.allChecked
					const list = this.cartList
					list.forEach(item => {
						item.checked = checked
					})
					this.allChecked = checked
				}
			},
			// 数量
			numberChange(num, index) {
				this.cartList[index].cart_num = num;
			},
			// 创建订单
			applyRefund() {
				
				let orderNumData = []
				let detailIds = []
				this.cartList.forEach(item => {
					if (item.checked) {
						orderNumData.push({
							order_detail_id: item.id,
							num: item.cart_num
						})
						
						detailIds.push(item.id)
					}
				})
				
				uni.setStorage({
					key: 'REFUND_ORDER',
					data: JSON.stringify({
						order_id: this.orderId,
						order_detail_id: detailIds.join(','),
						order_num_data: orderNumData
					})
				})
				
				uni.navigateTo({
					url: `/pages/refund/refund`
				})
			}
		}
	}
</script>

<style lang='scss'>
	.container{
		padding-bottom: 134upx;
		background: #fff;
	}
	/* 购物车列表项 */
	.cart-item{
		display:flex;
		position:relative;
		padding:30upx 40upx;
		.image-wrapper{
			width: 230upx;
			height: 230upx;
			flex-shrink: 0;
			position:relative;
			image{
				border-radius:8upx;
			}
		}
		.checkbox{
			position:absolute;
			left:-16upx;
			top: -16upx;
			z-index: 8;
			font-size: 44upx;
			line-height: 1;
			padding: 4upx;
			color: $font-color-disabled;
			background:#fff;
			border-radius: 50px;
		}
		.item-right{
			display:flex;
			flex-direction: column;
			flex: 1;
			overflow: hidden;
			position:relative;
			padding-left: 30upx;
			.title,.price{
				font-size:$font-base + 2upx;
				color: $font-color-dark;
				height: 40upx;
				line-height: 40upx;
			}
			.attr{
				font-size: $font-sm + 2upx;
				color: $font-color-light;
				overflow:hidden;
				text-overflow:ellipsis;
				display:-webkit-box;
				-webkit-box-orient:vertical;
				-webkit-line-clamp:2;
			}
			.price{
				height: 50upx;
				line-height:50upx;
				color: #e93323
			}
		}
		.del-btn{
			padding:4upx 10upx;
			font-size:34upx; 
			height: 50upx;
			color: $font-color-light;
		}
	}
	/* 底部栏 */
	.action-section{
		/* #ifdef H5 */
		margin-bottom:100upx;
		/* #endif */
		position:fixed;
		left: 30upx;
		bottom:30upx;
		z-index: 95;
		display: flex;
		align-items: center;
		width: 690upx;
		height: 100upx;
		padding: 0 30upx;
		background: rgba(255,255,255,.9);
		box-shadow: 0 0 20upx 0 rgba(0,0,0,.5);
		border-radius: 16upx;
		.checkbox{
			height:52upx;
			position:relative;
			image{
				width: 52upx;
				height: 100%;
				position:relative;
				z-index: 5;
			}
		}
		.clear-btn{
			position:absolute;
			left: 26upx;
			top: 0;
			z-index: 4;
			width: 0;
			height: 52upx;
			line-height: 52upx;
			padding-left: 38upx;
			font-size: $font-base;
			color: #fff;
			background: $font-color-disabled;
			border-radius:0 50px 50px 0;
			opacity: 0;
			transition: .2s;
			&.show{
				opacity: 1;
				width: 120upx;
			}
		}
		.total-box{
			flex: 1;
			display:flex;
			flex-direction: column;
			text-align:right;
			padding-right: 40upx;
			.price{
				font-size: $font-lg;
				color: $font-color-dark;
			}
			.coupon{
				font-size: $font-sm;
				color: $font-color-light;
				text{
					color: $font-color-dark;
				}
			}
		}
		.confirm-btn{
			padding: 0 38upx;
			margin: 0;
			border-radius: 16upx;
			height: 76upx;
			line-height: 76upx;
			font-size: $font-base + 2upx;
			background: $uni-color-primary;
			box-shadow: 1px 2px 5px rgba(217, 60, 93, 0.72)
		}
	}
	/* 复选框选中状态 */
	.action-section .checkbox.checked,
	.cart-item .checkbox.checked{
		color: $uni-color-primary !important;
	}
	.cart-list {
		background: #fff;
	}
	.do-appraise {width: 90% !important;background: #e93323 !important;color: #fff !important;margin-top: 20px !important;font-size: 15px !important;}
</style>
