<template>
	<view>
		<view class="yt-list">
			<uni-view class="item acea-row row-between-wrapper">
				<uni-view>物流公司</uni-view>
				<uni-view><input class="uni-input" focus placeholder="请输入物流公司" v-model="form.refund_express_name" /></uni-view>
			</uni-view>
			<uni-view class="item acea-row row-between-wrapper">
				<uni-view>物流单号</uni-view>
				<uni-view><input class="uni-input" placeholder="请输入物流单号" v-model="form.refund_express" /></uni-view>
			</uni-view>
		</view>
		<button type="default" class="do-appraise" @click="apply">提交</button>
	</view>
</template>

<script>
	export default {
	
		data() {
			return {
				form: {
					id: 0,
					refund_express_name: '',
					refund_express: ''
				}
			}
		},
		onLoad(options) {
			this.form.id = options.refund_id
		},
		mounted() {
			
		},
		methods: {
			// 申请退款
			async apply() {
				uni.showLoading({
					title: '处理中'
				});
				let res = await this.$api.orderRefund.refundExpress.post(this.form)
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
			}
		}
	}
</script>

<style lang="scss">
	
	.yt-list {
		margin-top: 16upx;
		background: #fff;
	}
	
	.yt-list .item {
		margin-left: 15px;
		padding-right: 15px;
		min-height: 45px;
		border-bottom: 1px solid #eee;
		font-size: 15px;
		color: #333;
	}
	.acea-row {
	    flex-wrap: nowrap;
		display: flex;
	}
	.acea-row.row-between-wrapper {
		-webkit-box-align: center;
		align-items: center;
		-webkit-box-pack: justify;
		justify-content: space-between;
	}
	.yt-list .item .num {
	    color: #282828;
	    width: 213px;
	    text-align: right;
	}
	.do-appraise {width: 90% !important;background: #e93323 !important;color: #fff !important;margin-top: 20px !important;font-size: 15px !important;}
</style>
