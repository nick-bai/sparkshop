<template>
	<empty v-if="errorFlag === true" text="该订单不可退款"></empty>
	<view v-else-if="errorFlag === false">
		<view class="goods-section">
			<view class="g-item" v-for="goodsInfo,index in orderList" :key="index">
				<image :src="goodsInfo.logo"></image>
				<view class="right">
					<text class="title clamp" style="font-size: 26rpx;">{{ goodsInfo.goods_name }}</text>
					<text class="spec">
						<text v-if="goodsInfo.rule != 0">{{ goodsInfo.rule.split('※').join(' ') }}</text>
					</text>
					<view class="price-box">
						<text class="price" style="color:#e93323">￥ {{ goodsInfo.price }}</text>
						<text class="number">x {{ goodsInfo.cart_num }}</text>
					</view>
				</view>
			</view>
		</view>
		
		<view class="yt-list">
			<uni-view class="item acea-row row-between-wrapper">
				<uni-view>退货件数</uni-view>
				<uni-view class="num" v-if="!canSelectNum">{{ refund_num }}</uni-view>
				<uni-view class="num" v-else>
					<picker @change="bindPickerNumChange" :value="refundIndex" :range="refundNumMap">
						<text style="margin-right: 5px;">{{ refundNumMap[refundIndex] }}</text> <uni-icons type="right" size="15"></uni-icons>
					</picker>
				</uni-view>
			</uni-view>
			<uni-view class="item acea-row row-between-wrapper">
				<uni-view>退款类型</uni-view>
				<uni-view class="num" v-if="[4, 5, 6].indexOf(orderInfo.status) == -1">{{ refundType }}</uni-view>
				<uni-view class="num" v-else>
					<picker @change="bindPickerTypeChange" :value="index" :range="refundTypeMap">
						<text style="margin-right: 5px;">{{ refundTypeMap[index] }}</text> <uni-icons type="right" size="15"></uni-icons>
					</picker>
				</uni-view>
			</uni-view>
			<uni-view class="item acea-row row-between-wrapper">
				<uni-view>退款原因</uni-view>
				<uni-view class="num">
					<picker @change="bindPickerReasonChange" :value="reasonIndex" :range="reasonMap">
						<text style="margin-right: 5px;">{{ reasonMap[reasonIndex] }}</text> <uni-icons type="right" size="15"></uni-icons>
					</picker>
				</uni-view>
			</uni-view>
		</view>
		<view style="background:#fff;padding-top: 10px;">
			<view class="uni-textarea">
				<textarea placeholder-style="font-size:13px;color:#bbb;" placeholder="填写备注信息，100字以内" maxlength="140" v-model="form.remark"/>
			</view>
			<view>
				<uni-file-picker
					fileMediatype="image"
					limit="3"
					@delete="deleteFile"
					@select="selectFile"
					title="最多选择3张图片">
				</uni-file-picker>
			</view>
			<button type="default" class="do-appraise" @click="apply">申请退款</button>
		</view>
	</view>
</template>

<script>
	import {
		BASE_URL
	} from '@/config/app';
	import empty from "@/components/empty";
	
	export default {
		components: {
			empty
		},
		data() {
			return {
				canSelectNum: false,
				errorFlag: false,
				orderList: [],
				form: {
					order_id: 0,
					order_detail_id: '', // 形如: 1,2
					remark: '',
					refund_type: 1,
					apply_refund_reason: '',
					refund_img: [],
					order_num_data: [] // 本次申请的数量
				},
				order_num_data: [], // 订单的原始详情数量
				refund_num: 1,
				refundType: '仅退款',
				refundTypeMap: ["仅退款", "退货并退款"],
				reasonMap: [],
				reasonIndex: 0,
				index: 0,
				refundNumMap: [],
				refundIndex: 0,
				goodsRefund: [],
				onlyRefund: [],
				pictures: new Map(),
				orderInfo: {}
			}
		},
		onLoad(options) {
		
			uni.getStorage({
				key: 'REFUND_ORDER',
				success: (res) => {
					let data = JSON.parse(res.data)
					this.form.order_id = data.order_id
					this.form.order_detail_id = data.order_detail_id
					this.order_num_data = data.order_num_data
					this.form.order_num_data = JSON.stringify(data.order_num_data)
				}
			})
		},
		mounted() {
			this.getOrderInfo()
		},
		methods: {
			async getOrderInfo() {
				let param = {
					order_id: this.form.order_id,
					order_detail_id: this.form.order_detail_id,
					order_num_data: this.order_num_data
				}
				let res = await this.$api.orderRefund.refundTrail.post(param)
				if (res.code != 0) {
					this.$tool.msg(res.msg);
					setTimeout(() => {
						uni.navigateBack(1)
					}, 2000)
					return false
				}
				this.orderList = res.data.orderList
				this.orderInfo = res.data.orderInfo
				this.canSelectNum = res.data.canSelectNum
				
				if (res.data.totalNum > 1) {
					for (let i = 1; i <= res.data.totalNum; i++) {
						this.refundNumMap.push(i)
					}
				}
				
				this.reasonMap = this.only_refund = res.data.refundConf.only_refund.split('\n')
				this.form.apply_refund_reason = this.reasonMap[0]
				this.goods_refund = res.data.refundConf.goods_refund.split('\n')
				this.refundIndex = this.refundNumMap.length - 1
				
				this.refund_num = res.data.totalNum
			},
			// 选择退款数量
			bindPickerNumChange(val) {
				this.refundIndex = parseInt(val.detail.value)
				this.refund_num = this.refundNumMap[this.refundIndex]
			},
			// 选择退款类型
			bindPickerTypeChange(val) {
				this.index = parseInt(val.detail.value) 
				this.form.refund_type = this.index + 1
				if (val.detail.value == 0) {
					this.reasonMap = this.only_refund
				} else {
					this.reasonMap = this.goods_refund
				}
			},
			// 选择退款原因
			bindPickerReasonChange(val) {
				this.reasonIndex = parseInt(val.detail.value)
				this.form.apply_refund_reason = this.reasonMap[this.reasonIndex]
			},
			// 删除文件
			deleteFile(file) {
				this.pictures.delete(file.tempFilePath)
			},
			// 选择文件
			selectFile(file) {
				uni.uploadFile({
					url: BASE_URL + '/api/Common/uploadFile',
					filePath: file.tempFilePaths[0],
					name: 'file',
					success: (res) => {
						let resFile = JSON.parse(res.data)
						this.pictures.set(file.tempFilePaths[0], resFile.data.url)
					}
				});
			},
			// 申请退款
			async apply() {
				
				let imgMap = []
				for (let [k, v] of this.pictures) {
					imgMap.push(v)
				}
				this.form.refund_img = imgMap.join(',')
			
				// 如果是退部分 -- 重置数量
				if (!isNaN(this.form.order_detail_id)) {
					let newApplyNumData = [];
					JSON.parse(this.form.order_num_data).forEach(item => {
						newApplyNumData.push({'order_detail_id': item.order_detail_id, 'num': this.refund_num})
					})
					
					this.form.order_num_data = JSON.stringify(newApplyNumData)
				}
			
				let res = await this.$api.orderRefund.refund.post(this.form)
				if (res.code == 0) {
					this.$tool.msg(res.msg);
					// 跳转到售后页面
					setTimeout(() => {
						uni.navigateTo({
							url: `/pages/refund/refundList`,
						})
					}, 800)
				} else {
					this.$tool.msg(res.msg);
					setTimeout(() => {
						window.location.href = '/'
					}, 800)
				}
			}
		}
	}
</script>

<style lang="scss">
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
				margin-top: 5px;
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
	page {
	    background: #f8f8f8;
	    padding-bottom: 100rpx;
	}
	.uni-textarea {background: #fafafa;margin-left: 20px;width: 90%;margin-top: 10px;padding: 5px;}
	.uni-file-picker__header {width: 80%;}
	.uni-file-picker {width:80%;margin-left: 30px;}
	.icon-add {width: 30px !important;}
	.icon-del-box {width: 20px !important;height: 20px !important;}
	.icon-del {width: 10px !important;}
	.file-picker__box {width: 80px !important;padding-top: 80px !important;}
	.do-appraise {width: 90% !important;background: #e93323 !important;color: #fff !important;margin-top: 20px !important;font-size: 15px !important;}
</style>
