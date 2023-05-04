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
				<text>库存: {{ goodsInfo.stock }}</text>
				<text>浏览量: {{ goodsInfo.views }}</text>
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
			<view class="c-row b-b" v-if="couponOpen == 1 && couponList.length > 0" @click="toggleMask('show')" @click.stop.prevent="stopPrevent">
				<text class="tit">优惠券</text>
				<text class="con t-r red">领取优惠券</text>
				<text class="yticon icon-you"></text>
			</view>
			<view class="c-row b-b" v-if="goodsAttr.length > 0">
				<text class="tit">参数</text>
				<view class="con-list">
					<text v-for="(item, index) in goodsAttr" :key="index">{{ item.name }}: {{ item.value }}</text>
				</view>
			</view>
			<view class="c-row b-b">
				<text class="tit">服务</text>
				<view class="bz-list con">
					<text>7天无理由退换货 ·</text>
					<text>假一赔十 ·</text>
				</view>
			</view>
		</view>
		
		<!-- 评价 -->
		<view class="eva-section">
			<view class="e-header">
				<text class="tit">评价</text>
				<text>({{ commentTotal }})</text>
				<text class="tip" @click="goComment">好评率 {{ goodPercent }}%</text>
				<uni-icons type="forward" size="14" color="#909399"></uni-icons>
			</view> 
			<view class="eva-box" v-if="comments.content">
				<image class="portrait" :src="comments.user_avatar" mode="aspectFill"></image>
				<view class="right">
					<text class="name">{{ comments.user_name }}</text>
					<text class="con">{{ comments.content }}</text>
					<view class="bot">
						<text class="attr">购买规格：{{ comments.sku }}</text>
						<text class="time">{{ comments.create_time }}</text>
					</view>
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
			<navigator url="/pages/cart/cart" open-type="switchTab" class="p-b-btn">
				<uni-badge class="uni-badge-left-margin" :text="cartNum" absolute="rightTop" size="small" :customStyle="{background: '#e93323'}">
					<uni-icons custom-prefix="iconfont" type="icon-gouwuche" size="22" color="#909399" class="icon-class"></uni-icons>
				</uni-badge>
				<text>购物车</text>
			</navigator>
			<view class="p-b-btn" @click="toFavorite">
				<uni-icons custom-prefix="iconfont" type="icon-shoucang" size="20" color="#e93323" class="icon-class" v-if="favorite"></uni-icons>
				<uni-icons custom-prefix="iconfont" type="icon-shoucang" size="20" color="#909399" class="icon-class" v-else></uni-icons>
				<text style="margin-top: 2px;">收藏</text>
			</view>
			
			<view class="action-btn-group">
				<button type="primary" class="action-btn no-border buy-now-btn" @click="addCart">加入购物车</button>
				<button type="primary" class="action-btn no-border add-cart-btn" @click="buy">立即购买</button>
			</view>
		</view>
		
		<!-- 优惠券面板 -->
		<view class="mask" :class="maskState===0 ? 'none' : maskState===1 ? 'show' : ''" @click="toggleMask">
			<view class="mask-content" @click.stop.prevent="stopPrevent">
				<!-- 优惠券页面，仿mt -->
				<view class="coupon-item" v-for="(item,index) in couponList" :key="index">
					<view class="con">
						<view class="left">
							<text class="title">{{item.name}}</text>
							<text class="time" v-if="item.validity_type == 1">{{ item.start_time }}至{{ item.end_time }}</text>
							<text class="time" v-else>领取后{{ item.receive_useful_day }}日内可用</text>
						</view>
						<view class="right">
							<text class="price" v-if="item.type == 1">{{parseFloat(item.amount)}}</text>
							<text class="discount" v-else>{{item.discount * 100}}折</text>
							<text v-if="item.is_threshold == 1">满{{ parseFloat(item.threshold_amount) }}元可用</text>
							<text v-else>无门槛</text>
						</view>
						
						<view class="circle l"></view>
						<view class="circle r"></view>
					</view>
					<view class="tips">
						<view class="btn" v-if="item.received == 0" @click="receive(item.id)" style="width: 60px;">领取</view>
						<view class="btn gray" v-else style="width: 60px;">领取</view>
					</view>
				</view>
				
				<xw-empty :isShow="couponList.length == 0" text="暂无可用的优惠券" textColor="#777777"></xw-empty>
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
						<text class="price">¥ {{ skuInfo.price }}</text>
						<text class="stock">库存：{{ skuInfo.stock }} {{ goodsInfo.unit }}</text>
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
						<uni-number-box :min="1" :max="skuInfo.stock" @change="changeNum" v-model="buyNum"/>
					</view>
				</view>
				<button class="buy-btn" @click="confirm" v-if="canBuy && optType == 2">立即购买</button>
				<button class="buy-btn" @click="confirm" v-else-if="optType == 1">加入购物车</button>
				<button class="buy-btn" style="background: #bbb!important;" v-else>暂无产品</button> 
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
				maskState: 0, //优惠券面板显示状态
				couponList: [], // 优惠券
				specClass: 'none',
				favorite: false, // 收藏
				specSelected:[], // 已选择的规格
				imgList: [],
				goodsInfo: {}, // 商品数据
				goodsRuleMap: {}, // 规格数据
				skuInfo: {}, // 规格信息
				desc: '',
				specList: [], // 商品规格数据
				goodsAttr: [], // 参数
				specChildList: [], // 子规格
				commentTotal: 0, // 累计评价数量
				goodPercent: 0,
				goodsId: 0,
				comments: {
					content: ''
				},
				height: 40,
				cartNum: 0,
				couponOpen: 1, // 是否打开优惠券
				order_type: 1,
				spec: 1, // 1:单规格 2:多规格
				buyNum: 1,
				canBuy: true,
				optType: 1 // 1:加入购物车 2:购买
			};
		},
		// 分享给好友
		onShareAppMessage(res) {
			return {
				title: this.goodsInfo.name,
				path: '/pages/product/product?id=' + this.goodsId
			}
		},
		// 分享到朋友圈
		onShareTimeline() {
			return {
				title: this.goodsInfo.name,
				path: '/pages/product/product?id=' + this.goodsId,
				imageUrl: this.imgList[0]
			};
		},
		async onLoad(options) {
		
			let id = options.id;
			this.goodsId = id
			
			this.getConfig()
			this.getGoodsDetail(id)
			this.getComments()
			this.getCarNum()
		},
		methods: {
			// 获取基础配置
			async getConfig() {
				let res = await this.$api.order.getConfig.get()
				this.couponOpen = res.data.coupon
				if (this.couponOpen == 1) {
					this.getCouponList()
				}
			},
			// 商品详情
			async getGoodsDetail(goodsId) {
				let res = await this.$api.goods.detail.get({id: goodsId})
				if (res.code != 0) {
					this.$tool.msg(res.msg)
					setTimeout(() => {
						window.location.href = '/'
					}, 1000)
					return ;
				}
				this.imgList = res.data.goodsDetail.slider_image
				this.goodsInfo = res.data.goodsDetail
				this.spec = res.data.goodsDetail.spec
				
				if (this.spec == 2) {
					this.height = 40
				} else {
					this.height = 25
					this.skuInfo.image = res.data.goodsDetail.slider_image[0]
					this.skuInfo.price = res.data.goodsDetail.price
					this.skuInfo.stock = res.data.goodsDetail.stock
				}
				
				// 如果是多规格
				if (res.data.goodsRule) {
					let index = 1;
					res.data.goodsRule.rule.forEach(item => {
						
						this.specList.push({
							id: index,
							name: item.title
						});
						
						item.item.forEach(item2 => {
							this.specChildList.push({
								pid: index,
								name: item2
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
					
					this.goodsInfo.price = this.skuInfo.price
					this.goodsInfo.original_price = this.skuInfo.original_price
				}
				
				this.goodsAttr = res.data.goodsAttr
				this.desc = res.data.goodsContent.content.replace(/\<img/gi, '<img style="max-width:100%;height:auto"')
				this.commentTotal = res.data.commentTotal
				this.goodPercent = res.data.goodPercent
				this.favorite = res.data.favorite
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
				let list = this.specChildList;
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
					this.goodsInfo.price = this.skuInfo.price
					this.goodsInfo.original_price = this.skuInfo.original_price
					this.canBuy = true
				} else {
					this.canBuy = false // 不可购买
				}
			},
			// 优惠券
			toggleMask(type) {
				let timer = type === 'show' ? 10 : 300;
				let	state = type === 'show' ? 1 : 0;
				this.maskState = 2;
				setTimeout(() => {
					this.maskState = state;
				}, timer)
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
			// 收藏
			async toFavorite() {
				if (this.favorite) {
					let res = await this.$api.collect.removeByGoods.get({goods_id: this.goodsId})
					if (res.code == 0) {
						this.favorite = false
					} else {
						this.$tool.msg(res.msg);
					}
					return ;
				}
				
				let res = await this.$api.collect.add.post({
					goods_id: this.goodsId,
					goods_name: this.goodsInfo.name,
					goods_pic: this.goodsInfo.slider_image[0],
					price: this.goodsInfo.price
				})
				
				if (res.code == 0) {
					this.$tool.msg(res.msg)
					this.favorite = true
				} else {
					this.$tool.msg(res.msg)
				}
			},
			// 获取评论
			async getComments() {
				let res = await this.$api.goods.comments.get({
					limit: 1,
					goods_id: this.goodsId,
					type: 0
				})
				
				if (res.data.list.data[0]) {
					this.comments = res.data.list.data[0]
				}
			},
			// 获取购物车数量
			async getCarNum() {
				let res = await this.$api.cart.num.get();
				this.cartNum = res.data
			},
			// 增加购物车
			async addCart() {
				this.optType = 1
				this.specClass = 'show';
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
				
				// 加入购物车
				if (this.optType == 1) {
					
					let res = await this.$api.cart.add.post({
						goods_id: this.goodsId,
						rule: rule,
						num: this.buyNum
					});
					
					this.$tool.msg(res.msg);
					this.getCarNum()
					this.buyNum = 1
				} else { // 购买
					
					let param = [];
					// 多规格
					if (this.spec == 2) {
						let res = await this.$api.goods.sku.get({
							goods_id: this.goodsId,
							sku: rule.join('※')
						})
						
						if (res.code == 0) {
							param = [{id: parseInt(this.goodsId), num: this.buyNum, rule_id: res.data.id}];
						} else {
							this.$tool.msg(res.msg);
						}
					} else if (this.spec == 1) { // 单规格
						param = [{id: parseInt(this.goodsId), num: this.buyNum, rule_id: 0}];
					}
					
					uni.setStorage({
						key: 'CREATE_ORDER',
						data: JSON.stringify(param)
					})
					
					uni.navigateTo({
						url: `/pages/order/createOrder`
					})
				}
			},
			// 获取优惠券列表
			async getCouponList() {
				let res = await this.$api.coupon.couponList.get({
					goods_id: this.goodsId
				})
				this.couponList = res.data
				console.log('可领取的优惠券', this.couponList)
			},
			// 领取优惠券
			async receive(id) {
				
				let res = await this.$api.coupon.receive.post({id: id})
				if (res.code == 0) {
					this.$tool.msg(res.msg)
					this.getCouponList()
				} else {
					this.$tool.msg(res.msg, 3000, false, 'error')
				}
			},
			stopPrevent() {},
			// 商品评价
			goComment() {
				uni.navigateTo({
					url: `/pages/product/comment?goods_id=` + this.goodsId
				})
			}
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
	
	/* 评价 */
	.eva-section{
		display: flex;
		flex-direction: column;
		padding: 20upx 30upx;
		background: #fff;
		margin-top: 16upx;
		.e-header{
			display: flex;
			align-items: center;
			height: 70upx;
			font-size: $font-sm + 2upx;
			color: $font-color-light;
			.tit{
				font-size: $font-base + 2upx;
				color: $font-color-dark;
				margin-right: 4upx;
			}
			.tip{
				flex: 1;
				text-align: right;
			}
			.icon-you{
				margin-left: 10upx;
			}
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
			.buy-btn{
				height: 66upx;
				line-height: 66upx;
				border-radius: 10upx;
				background: $uni-color-primary;
				font-size: $font-base + 2upx;
				color: #fff;
				margin: 0 auto;
				margin-top: 15px;
				margin-bottom: 20px;
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
		justify-content: center;
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
	/* 优惠券面板 */
	.mask{
		display: flex;
		align-items: flex-end;
		position: fixed;
		left: 0;
		top: var(--window-top);
		bottom: 0;
		width: 100%;
		background: rgba(0,0,0,0);
		z-index: 99;
		transition: .3s;
		
		.mask-content{
			width: 100%;
			min-height: 50vh;
			max-height: 100vh;
			background: #f3f3f3;
			transform: translateY(100%);
			transition: .3s;
			overflow-y:scroll;
		}
		&.none{
			display: none;
		}
		&.show{
			background: rgba(0,0,0,.4);
			
			.mask-content{
				transform: translateY(0);
			}
		}
	}
	
	/* 优惠券列表 */
	.coupon-item{
		display: flex;
		flex-direction: column;
		margin: 20upx 24upx;
		background: #fff;
		.con{
			display: flex;
			align-items: center;
			position: relative;
			height: 120upx;
			padding: 0 30upx;
			&:after{
				position: absolute;
				left: 0;
				bottom: 0;
				content: '';
				width: 100%;
				height: 0;
				border-bottom: 1px dashed #f3f3f3;
				transform: scaleY(50%);
			}
		}
		.left{
			display: flex;
			flex-direction: column;
			justify-content: center;
			flex: 1;
			overflow: hidden;
			height: 100upx;
		}
		.title{
			font-size: 32upx;
			color: $font-color-dark;
			margin-bottom: 10upx;
		}
		.time{
			font-size: 24upx;
			color: $font-color-light;
		}
		.right{
			display: flex;
			flex-direction: column;
			justify-content: center;
			align-items: center;
			font-size: 26upx;
			color: $font-color-base;
			height: 100upx;
		}
		.price{
			font-size: 44upx;
			color: $base-color;
			&:before{
				content: '￥';
				font-size: 34upx;
			}
		}
		.tips{
			font-size: 24upx;
			color: $font-color-light;
			line-height: 60upx;
			padding-left: 30upx;
		}
		.circle{
			position: absolute;
			left: -6upx;
			bottom: 22upx;
			z-index: 10;
			width: 20upx;
			height: 20upx;
			background: #f3f3f3;
			border-radius: 100px;
			&.r{
				left: auto;
				right: -6upx;
			}
		}
	}
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
	.coupon-item .discount{
	    font-size: 22px;
	    color: #e93323;
	}
</style>
