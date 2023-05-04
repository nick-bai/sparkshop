<template>
	<view style="background: #fff;">
		<empty v-if="errorFlag === true" text="该订单不可评价"></empty>
		<view class="goods-section" v-if="errorFlag === false">
			<!-- 商品列表 -->
			<view class="g-item">
				<image :src="goodsInfo.logo"></image>
				<view class="right">
					<text class="title clamp" style="font-size: 26rpx;">{{ goodsInfo.goods_name }}</text>
					<text class="spec">{{ goodsInfo.rule.split('※').join(' ') }}</text>
					<view class="price-box">
						<text class="price" style="color:#e93323">￥ {{ goodsInfo.price }}</text>
						<text class="number">x {{ goodsInfo.cart_num }}</text>
					</view>
				</view>
			</view>
			<view v-if="goodsInfo.user_comments == 1">
				<view class="uni-padding-wrap">
					<view class="appraise-type">
						<radio-group @change="handleChange">
							评价类型
							<label class="radio" key="1" style="margin-left: 35px;"><radio value="1" checked/>好评</label>
							<label class="radio" key="2"><radio value="2"/>中评</label>
							<label class="radio" key="3"><radio value="3"/>差评</label>
						</radio-group>
					</view>
				</view>
				<view class="appraise-type uni-flow">
					<view class="flex-item">描述符合度</view>
					<view class="flex-item" style="margin-left: 20px;"><uni-rate v-model="form.desc_match" color="#bbb" active-color="red" /></view>
				</view>
				<view class="uni-textarea">
					<textarea placeholder-style="font-size:13px;color:#bbb;" placeholder="商品满足你的期待么？说说你的想法，分享给想买的他们吧" v-model="form.content"/>
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
				<button type="default" class="do-appraise" @click="doAppraise">立即评价</button>
			</view>	
			
			<view v-if="goodsInfo.user_comments == 2">
				<view class="uni-padding-wrap">
					<view class="appraise-type">
						评价类型
						<uni-tag text="好评" :inverted="true" type="success" v-if="goodsInfo.comment.type == 1" style="margin-left: 36px;"></uni-tag>
						<uni-tag text="中评" :inverted="true" type="primary" v-if="goodsInfo.comment.type == 2" style="margin-left: 36px;"></uni-tag>
						<uni-tag text="差评" :inverted="true" type="default" v-if="goodsInfo.comment.type == 3" style="margin-left: 36px;"></uni-tag>
					</view>
				</view>
				<view class="appraise-type uni-flow">
					<view class="flex-item">描述符合度</view>
					<view class="flex-item" style="margin-left: 20px;"><uni-rate v-model="goodsInfo.comment.desc_match" color="#bbb" active-color="red" :readonly="true"/></view>
				</view>
				<view class="appraise-type appraise-content-div">
					<view class="flex-item appraise-content">评价内容</view>
					<view class="flex-item appraise-content-detail">{{ goodsInfo.comment.content }}</view>
				</view>
				<view class="comment-img">
					<view style="margin-left: 20px;" v-for="item,index in appraisePic" :key="index">
						<img :src="item" class="appeaise-pic"/>
					</view>
				</view>
			</view>
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
				goodsInfo: {
					rule: ''
				},
				orderId: 0,
				orderDetailId: 0,
				form: {
					order_id: 0,
					order_detail_id: 0,
					pictures: [],
					type: 1,
					desc_match: 5,
					content: ''
				},
				appraisePic: [],
				errorFlag: false,
				pictures: new Map(),
				fileUploadEnd: true
			}
		},
		onLoad(options) {
			this.orderId = options.order_id
			this.orderDetailId = options.order_detail_id
			this.form.order_id = this.orderId
			this.form.order_detail_id = this.orderDetailId
		},
		mounted() {
			this.getInfo()
		},
		methods: {
			// 获取订单信息
			async getInfo() {
				let res = await this.$api.userOrder.appraise.get({order_id: this.orderId, order_detail_id: this.orderDetailId})
				this.goodsInfo = res.data.info
	
				if (this.goodsInfo.comment) {
					this.appraisePic = this.goodsInfo.comment.pictures ? this.goodsInfo.comment.pictures.split(',') : []
				}
			},
			deleteFile(file) {
				this.pictures.delete(file.tempFilePath)
			},
			// 选择文件
			selectFile(file) {
				this.fileUploadEnd = false
				uni.showLoading({
					title: '上传中...'
				});
				uni.uploadFile({
					url: BASE_URL + '/api/Common/uploadFile',
					filePath: file.tempFilePaths[0],
					name: 'file',
					success: (res) => {
						setTimeout(() => {
							uni.hideLoading();
						}, 2000);
						let resFile = JSON.parse(res.data)
						this.pictures.set(file.tempFilePaths[0], resFile.data.url)
						this.fileUploadEnd = true
						this.$tool.msg('上传成功')
					}
				});
			},
			// 单选按钮选择
			handleChange(val) {
				this.form.type = val.detail.value;
			},
			// 提交评价
			async doAppraise() {
				if (!this.fileUploadEnd) {
					this.$tool.msg('图片尚未传输完成，请稍后')
					return false
				}
				
				let imgMap = []
				for (let [k, v] of this.pictures) {
					imgMap.push(v)
				}
				this.form.pictures = imgMap.join(',')
				
				let res = await this.$api.userOrder.doAppraise.post(this.form)
				if (res.code == 0) {
					this.$tool.msg(res.msg);
					setTimeout(() => {
						this.getInfo()
					}, 800)
				} else {
					this.$tool.msg(res.msg);
				}
			},
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
	.comment-img {margin-top: 20px;height: 500px;}
	.comment-img view {float: left;}
	.radio {margin-left: 10px;}
	.appraise-type {margin-left: 20px;margin-top: 20px;font-size: 14px;}
	.uni-flow {display: flex;flex-direction: row;}
	radio {transform:scale(0.7)}
	.uni-textarea {background: #fafafa;margin-left: 20px;width: 90%;margin-top: 20px;padding: 5px;}
	.uni-file-picker__header {width: 80%;}
	.uni-file-picker {width:80%;margin-left: 30px;}
	.icon-add {width: 30px !important;}
	.icon-del-box {width: 20px !important;height: 20px !important;}
	.icon-del {width: 10px !important;}
	.file-picker__box {width: 80px !important;padding-top: 80px !important;}
	.do-appraise {width: 90% !important;background: #e93323 !important;color: #fff !important;margin-top: 20px !important;font-size: 15px !important;margin-bottom: 50px;}
	.appraise-content{width: 90px;float: left;background: #fff;min-height: 50px;}
	.appraise-content-detail {float: left;color:#303133;background: #fff;}
	.appraise-content-div {min-height: 50px;}
	.appeaise-pic {width: 100px;height: 100px;max-width: 100%;max-height: 100%;}
</style>