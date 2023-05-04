<template>
	<view class="container">
		<view class="carousel">
			<swiper indicator-dots circular=true duration="400">
				<swiper-item class="swiper-item" v-for="(item,index) in imgList" :key="index">
					<view class="image-wrapper">
						<image
							:src="item" 
							class="loaded" 
							mode="aspectFill"
						></image>
					</view>
				</swiper-item>
			</swiper>
		</view>
		
		<view class="introduce-section">
			<text class="title">{{ goodsInfo.name }}</text>
			<view class="price-box">
				<text class="price-tip">¥</text>
				<text class="price">{{ goodsInfo.price }}</text>
				<text class="m-price">¥ {{ goodsInfo.original_price }} </text>
				<!--<text class="coupon-tip">7折</text>-->
			</view>
			<view class="bot-row">
				<text>销量: {{ goodsInfo.sales }}</text>
				<text>限量: {{ goodsInfo.stock }}</text>
			</view>
		</view>
		
		<view class="c-list">
			<view class="c-row b-b" @click="toggleSpec" v-if="specChildList.length > 0">
				<text class="tit">选择</text>
				<view class="con">
					<text class="selected-text" v-for="(sItem, sIndex) in specSelected" :key="sIndex">
						{{sItem.name}}
					</text>
				</view>
				<text class="yticon icon-you"></text>
			</view>
			<view class="c-row b-b">
				<text class="tit">服务</text>
				<view class="bz-list con">
					<text>7天无理由退换货 ·</text>
					<text>假一赔十 </text>
				</view>
			</view>
		</view>
		
		<view class="detail-desc">
			<view class="d-header">
				<text>详情</text>
			</view>
			<rich-text :nodes="desc"></rich-text>
		</view>
		
		<!-- 底部操作菜单 -->
		<view class="page-bottom">
			<navigator url="/pages/index/index" open-type="switchTab" class="p-b-btn">
				<uni-icons custom-prefix="iconfont" type="icon-shangpu" size="20" color="#909399" class="icon-class"></uni-icons>
				<text>首页</text>
			</navigator>
			<view style="">
				<button type="primary" class="action-btn no-border add-cart-btn" @click="buy" style="background: #e93323;margin-left: 203px;">立即购买</button>
			</view>
		</view>
		
		<!-- 多规格-模态层弹窗 -->
		<view 
			class="popup spec" 
			:class="specClass"
			@touchmove.stop.prevent="stopPrevent"
			@click="toggleSpec"
		>
			<!-- 遮罩层 -->
			<view class="mask"></view>
			<view class="layer attr-content" @click.stop="stopPrevent" :style="{'min-height':height + 'vh'}">
				<view class="a-t">
					<image :src="skuInfo.image"></image>
					<view class="right">
						<text class="price">¥ {{ skuInfo.seckill_price }}</text>
						<text class="stock">库存：{{ skuInfo.stock }}</text>
						<view class="selected" v-if="spec == 2">
							已选：
							<text class="selected-text" v-for="(sItem, sIndex) in specSelected" :key="sIndex">
								{{sItem.name}}
							</text>
						</view>
					</view>
				</view>
				<view v-for="(item,index) in specList" :key="index" class="attr-list" v-if="spec == 2">
					<text>{{item.name}}</text>
					<view class="item-list">
						<text 
							v-for="(childItem, childIndex) in specChildList" 
							v-if="childItem.pid === item.id"
							:key="childIndex" class="tit"
							:class="{selected: childItem.selected}"
							@click="selectSpec(childIndex, childItem.pid)"
						>
							{{childItem.name}}
						</text>
					</view>
				</view>
				<view class="attr-list" style="margin-top: 16upx;">
					<text style="width: 20%;">数量</text>
					<view style="margin-left:70%;margin-top: -34upx;">
						<uni-number-box :min="1" :max="goodsInfo.once_buy_num" @change="changeNum" v-model="buyNum"/>
					</view>
				</view>
				<button class="btn" @click="confirm" v-if="canBuy">立即购买</button>
				<button class="btn" style="background: #bbb!important;" v-else>已售罄</button> 
			</view>
		</view>
	</view>
</template>

<script>
	import xwEmpty from '@/components/xw-empty/xw-empty';
	export default{
		components: {
			xwEmpty
		},
		data() {
			return {
				specSelected:[],
				imgList: [],
				goodsInfo: {},
				goodsRuleMap: {},
				skuInfo: {},
				desc: '',
				specList: [],
				goodsAttr: [],
				specChildList: [],
				seckillId: 0,
				height: 40,
				cartNum: 0,
				spec: 1, // 1:单规格 2:多规格
				buyNum: 1,
				canBuy: true,
				specClass: 'none',
			};
		},
		// 分享给好友
		onShareAppMessage(res) {
			return {
				title: this.goodsInfo.name,
				path: '/pages/seckill/product?id=' + this.seckillId
			}
		},
		// 分享到朋友圈
		onShareTimeline() {
			return {
				title: this.goodsInfo.name,
				path: '/pages/seckill/product?id=' + this.seckillId,
				imageUrl: this.imgList[0]
			};
		},
		async onLoad(options) {
			let id = options.id;
			this.seckillId = id
			
			this.getGoodsDetail(id)
		},
		methods: {
			// 商品详情
			async getGoodsDetail(seckillId) {
				let res = await this.$api.seckill.detail.get({seckill_id: seckillId})
				if (res.code != 0) {
					this.$tool.msg(res.msg)
					setTimeout(() => {
						window.location.href = '/'
					}, 1000)
					return ;
				}
				
				this.imgList = []
				res.data.goodsRuleMap.forEach(item => {
					this.imgList.push(item.image)
				})
				
				this.goodsInfo = res.data.activity
				this.spec = res.data.activity.spec
				
				if (this.spec == 2) {
					this.height = 40
					
					// 如果是多规格
					if (res.data.goodsRule) {
						let index = 1;
						res.data.goodsRule.rule.forEach(child => {
							
							this.specList.push({
								id: index,
								name: child.title
							});
							
							child.item.forEach(item => {
								this.specChildList.push({
									pid: index,
									name: item
								});
							})
							index++;
						});
						
						this.goodsRuleMap = res.data.goodsRuleMap
						
						// 规格 默认选中第一条
						let sku = this.goodsRuleMap[0].sku
						let skuMap = sku.split('※')
						skuMap.forEach(item => {
							for (let cItem of this.specChildList) {
								if (cItem.name === item) {
									this.$set(cItem, 'selected', true);
									this.specSelected.push(cItem);
									break;
								}
							}
						})
						
						this.goodsRuleMap.forEach (item => {
							if (item.sku == sku) {
								this.skuInfo = item
							}
						})
						
						this.goodsInfo.price = this.skuInfo.seckill_price
						this.goodsInfo.original_price = this.skuInfo.goods_price
					}
				} else {
					this.height = 25
					this.skuInfo.image = res.data.goodsRuleMap[0].image
					this.goodsInfo.price = this.skuInfo.price = res.data.goodsRuleMap[0].seckill_price
					this.skuInfo.stock = res.data.goodsRuleMap[0].stock
					this.goodsInfo.original_price = res.data.goodsRuleMap[0].goods_price
				}
				
				this.desc = res.data.content.replace(/\<img/gi, '<img style="max-width:100%;height:auto"')
			},
			// 规格弹窗开关
			toggleSpec() {
				if (this.specClass === 'show') {
					this.specClass = 'hide';
					setTimeout(() => {
						this.specClass = 'none';
					}, 250);
				} else if (this.specClass === 'none') {
					this.specClass = 'show';
				}
			},
			//选择规格
			selectSpec(index, pid) {
				let list = this.specChildList
				list.forEach(item => {
					if (item.pid === pid) {
						this.$set(item, 'selected', false);
					}
				})

				this.$set(list[index], 'selected', true);
				// 存储已选择
				this.specSelected = []; 
				let sku = '';
				list.forEach(item => { 
					if(item.selected === true){ 
						sku += item.name + '※'
						this.specSelected.push(item); 
					} 
				})
				
				sku = sku.substr(0, sku.length - 1)
				
				let hasRule = false
				this.goodsRuleMap.forEach (item => {
					if (item.sku == sku) {
						hasRule = true
						this.skuInfo = item
					}
				})
				
				if (hasRule) {
					this.goodsInfo.price = this.skuInfo.seckill_price
					this.goodsInfo.original_price = this.skuInfo.goods_price
					if (this.skuInfo.stock == 0) {
						this.canBuy = false
					} else {
						this.canBuy = true
					}
				} else {
					this.canBuy = false // 不可购买
				}
			},
			
			// 购买
			buy() {
				this.optType = 2
				this.specClass = 'show';
			},
			// 选择数量
			changeNum(val) {
				this.buyNum = val
			},
			// 规格选择确定
			async confirm() {
				let rule = [];
				this.specSelected.forEach(item => {
					rule.push(item.name)
				})
				
				this.specClass = 'hide';
				setTimeout(() => {
					this.specClass = 'none';
				}, 250);
				
				let param = [];
				// 多规格
				if (this.spec == 2) {
					param = [{id: parseInt(this.seckillId), num: this.buyNum, rule: rule.join('※')}];
				} else if (this.spec == 1) { // 单规格
					param = [{id: parseInt(this.seckillId), num: this.buyNum, rule: ''}];
				}
				
				uni.setStorage({
					key: 'SECKILL_ORDER',
					data: JSON.stringify(param)
				})
				
				uni.navigateTo({
					url: `/pages/seckill/createOrder`
				})
			},
			stopPrevent() {}
		},

	}
</script>

<style lang='scss'>
	page{
		background: $page-color-base;
		padding-bottom: 160upx;
	}
	.icon-you{
		font-size: $font-base + 2upx;
		color: #888;
	}
	.carousel {
		height: 722upx;
		position:relative;
		swiper{
			height: 100%;
		}
		.image-wrapper{
			width: 100%;
			height: 100%;
		}
		.swiper-item {
			display: flex;
			justify-content: center;
			align-content: center;
			height: 750upx;
			overflow: hidden;
			image {
				width: 100%;
				height: 100%;
			}
		}
		
	}
	
	/* 标题简介 */
	.introduce-section{
		background: #fff;
		padding: 20upx 30upx;
		
		.title{
			font-size: 32upx;
			color: $font-color-dark;
			height: 50upx;
			line-height: 50upx;
		}
		.price-box{
			display:flex;
			align-items:baseline;
			height: 64upx;
			padding: 10upx 0;
			font-size: 26upx;
			color:$uni-color-primary;
		}
		.price{
			font-size: $font-lg + 2upx;
		}
		.m-price{
			margin:0 12upx;
			color: $font-color-light;
			text-decoration: line-through;
		}
		.coupon-tip{
			align-items: center;
			padding: 4upx 10upx;
			background: $uni-color-primary;
			font-size: $font-sm;
			color: #fff;
			border-radius: 6upx;
			line-height: 1;
			transform: translateY(-4upx); 
		}
		.bot-row{
			display:flex;
			align-items:center;
			height: 50upx;
			font-size: $font-sm;
			color: $font-color-light;
			text{
				flex: 1;
			}
		}
	}
	
	.c-list{
		font-size: $font-sm + 2upx;
		color: $font-color-base;
		background: #fff;
		margin-top: 16rpx;
		.c-row{
			display:flex;
			align-items:center;
			padding: 20upx 30upx;
			position:relative;
		}
		.tit{
			width: 140upx;
		}
		.con{
			flex: 1;
			color: $font-color-dark;
			.selected-text{
				margin-right: 10upx;
			}
		}
		.bz-list{
			height: 40upx;
			font-size: $font-sm+2upx;
			color: $font-color-dark;
			text{
				display: inline-block;
				margin-right: 30upx;
			}
		}
		.con-list{
			flex: 1;
			display:flex;
			flex-direction: column;
			color: $font-color-dark;
			line-height: 40upx;
		}
		.red{
			color: $uni-color-primary;
		}
	}
	
	.eva-box{
		display: flex;
		padding: 20upx 0;
		.portrait{
			flex-shrink: 0;
			width: 80upx;
			height: 80upx;
			border-radius: 100px;
		}
		.right{
			flex: 1;
			display: flex;
			flex-direction: column;
			font-size: $font-base;
			color: $font-color-base;
			padding-left: 26upx;
			.con{
				font-size: $font-base;
				color: $font-color-dark;
				padding: 20upx 0;
			}
			.bot{
				display: flex;
				justify-content: space-between;
				font-size: $font-sm;
				color:$font-color-light;
			}
		}
	}
	/*  详情 */
	.detail-desc{
		background: #fff;
		margin-top: 16upx;
		.d-header{
			display: flex;
			justify-content: center;
			align-items: center;
			height: 80upx;
			font-size: $font-base + 2upx;
			color: $font-color-dark;
			position: relative;
				
			text{
				padding: 0 20upx;
				background: #fff;
				position: relative;
				z-index: 1;
			}
			&:after{
				position: absolute;
				left: 50%;
				top: 50%;
				transform: translateX(-50%);
				width: 300upx;
				height: 0;
				content: '';
				border-bottom: 1px solid #ccc; 
			}
		}
	}
	
	/* 规格选择弹窗 */
	.attr-content{
		padding: 10upx 30upx;
		.a-t{
			display: flex;
			image{
				width: 170upx;
				height: 170upx;
				flex-shrink: 0;
				margin-top: -40upx;
				border-radius: 8upx;;
			}
			.right{
				display: flex;
				flex-direction: column;
				padding-left: 24upx;
				font-size: $font-sm + 2upx;
				color: $font-color-base;
				line-height: 42upx;
				.price{
					font-size: $font-lg;
					color: $uni-color-primary;
					margin-bottom: 10upx;
				}
				.selected-text{
					margin-right: 10upx;
				}
			}
		}
		.attr-list{
			display: flex;
			flex-direction: column;
			font-size: $font-base + 2upx;
			color: $font-color-base;
			padding-top: 30upx;
			padding-left: 10upx;
		}
		.item-list{
			padding: 20upx 0 0;
			display: flex;
			flex-wrap: wrap;
			text{
				display: flex;
				align-items: center;
				justify-content: center;
				background: #eee;
				margin-right: 20upx;
				margin-bottom: 20upx;
				border-radius: 16upx;
				min-width: 60upx;
				height: 60upx;
				padding: 0 20upx;
				font-size: $font-base;
				color: $font-color-dark;
			}
			.selected{
				background: #fbebee;
				color: $uni-color-primary;
			}
		}
	}
	
	/*  弹出层 */
	.popup {
		position: fixed;
		left: 0;
		top: 0;
		right: 0;
		bottom: 0;
		z-index: 99;
		
		&.show {
			display: block;
			.mask{
				animation: showPopup 0.2s linear both;
			}
			.layer {
				animation: showLayer 0.2s linear both;
			}
		}
		&.hide {
			.mask{
				animation: hidePopup 0.2s linear both;
			}
			.layer {
				animation: hideLayer 0.2s linear both;
			}
		}
		&.none {
			display: none;
		}
		.mask{
			position: fixed;
			top: 0;
			width: 100%;
			height: 100%;
			z-index: 1;
			background-color: rgba(0, 0, 0, 0.4);
		}
		.layer {
			position: fixed;
			z-index: 99;
			bottom: 0;
			width: 100%;
			min-height: 40vh;
			border-radius: 10upx 10upx 0 0;
			background-color: #fff;
			.btn{
				height: 66upx;
				line-height: 66upx;
				border-radius: 10upx;
				background: $uni-color-primary;
				font-size: $font-base + 2upx;
				color: #fff;
				margin: 30upx auto 20upx;
			}
		}
		@keyframes showPopup {
			0% {
				opacity: 0;
			}
			100% {
				opacity: 1;
			}
		}
		@keyframes hidePopup {
			0% {
				opacity: 1;
			}
			100% {
				opacity: 0;
			}
		}
		@keyframes showLayer {
			0% {
				transform: translateY(120%);
			}
			100% {
				transform: translateY(0%);
			}
		}
		@keyframes hideLayer {
			0% {
				transform: translateY(0);
			}
			100% {
				transform: translateY(120%);
			}
		}
	}
	
	/* 底部操作菜单 */
	.page-bottom{
		position:fixed;
		left: 30upx;
		bottom:30upx;
		z-index: 95;
		display: flex;
		align-items: center;
		width: 690upx;
		height: 100upx;
		background: rgba(255,255,255,.9);
		box-shadow: 0 0 20upx 0 rgba(0,0,0,.5);
		border-radius: 16upx;
		
		.p-b-btn{
			display:flex;
			flex-direction: column;
			align-items: center;
			justify-content: center;
			font-size: $font-sm;
			color: $font-color-base;
			width: 96upx;
			height: 80upx;
			.yticon{
				font-size: 40upx;
				line-height: 48upx;
				color: $font-color-light;
			}
			&.active, &.active .yticon{
				color: $uni-color-primary;
			}
			.icon-fenxiang2{
				font-size: 42upx;
				transform: translateY(-2upx);
			}
			.icon-shoucang{
				font-size: 46upx;
			}
		}
		.action-btn-group{
			display: flex;
			height: 76upx;
			border-radius: 16upx;
			overflow: hidden;
			background: #e93323;;
			margin-left: 20upx;
			position:relative;
			&:after{
				content: '';
				position:absolute;
				top: 50%;
				right: 50%;
				transform: translateY(-50%);
				height: 28upx;
				width: 0;
				border-right: 1px solid rgba(255,255,255,.5);
			}
			.action-btn{
				display:flex;
				align-items: center;
				justify-content: center;
				width: 180upx;
				height: 100%;
				font-size: $font-sm + 2upx;
				padding: 0;
				border-radius: 0;
				background: transparent;
			}
		}
	}
	.icon-class {color: $icon-color}
	
	.btn {
	    width: 358px;
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
	.gray {
		background: #888 !important;
	}
</style>
