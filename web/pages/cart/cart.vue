<template>
	<view class="container">
		<!-- 空白页 -->
		<view v-if="!isLogin || empty === true" class="empty">
			<image src="/static/emptyCart.jpg" mode="aspectFit"></image>
			<view v-if="isLogin" class="empty-tips">
				空空如也
				<navigator class="navigator" url="../index/index" open-type="switchTab">随便逛逛></navigator>
			</view>
			<view v-else class="empty-tips">
				空空如也
				<view class="navigator" @click="navToLogin">去登陆></view>
			</view>
		</view>
		<view v-else>
			<!-- 列表 -->
			<view class="cart-list">
				<block v-for="(item, index) in cartList" :key="item.id">
					<view
						class="cart-item" 
						:class="{'b-b': index!==cartList.length-1}"
					>
						<view class="image-wrapper" style="height: 80px;width: 80px;">
							<image :src="item.images" mode="aspectFill" style="opacity:1;height: 80px;width: 80px;"></image>
							<uni-icons type="checkbox-filled" size="25" color="#909399" class="checkbox" :class="{checked: item.checked}" @click="check('item', index)"></uni-icons>
						</view>
						<view class="item-right">
							<text class="clamp title">{{item.title}}</text>
							<text class="attr" v-if="item.rule_text != null">{{item.rule_text}}</text>
							<text class="attr" v-else></text>
							<text class="price">¥{{item.price}}</text>
							<uni-number-box 
								class="step"
								:min="1"
								:value="item.goods_num"
								:index="index"
								@change="numberChange($event, index)"
							></uni-number-box>
						</view>
						
						<uni-icons type="closeempty" size="17" color="#909399" @click="deleteCartItem(index)"></uni-icons>
					</view>
				</block>
			</view>
			<uni-load-more :status="loadingType" v-if="showLoad"></uni-load-more>
			<!-- 底部菜单栏 -->
			<view class="action-section">
				<view class="checkbox">
					<image 
						:src="allChecked?'/static/selected.png':'/static/select.png'" 
						mode="aspectFit"
						@click="check('all')"
					></image>
					<view class="clear-btn" :class="{show: allChecked}" @click="clearCart">
						清空
					</view>
				</view>
				<view class="total-box">
					<text class="price">¥{{total}}</text>
					<!--<text class="coupon">
						已优惠
						<text>74.35</text>
						元
					</text>-->
				</view>
				<button type="primary" class="no-border confirm-btn" @click="createOrder">去结算</button>
			</view>
		</view>
	</view>
</template>

<script>
	export default {
		
		data() {
			return {
				showLoad: true,
				total: 0, // 总价格
				allChecked: false, // 全选状态  true|false
				empty: false, // 空白页现实  true|false
				cartList: [],
				isLogin: false,
				limit: 10,
				nowPage: 0,
				pages: 1,
				loadingType: 'more' // 加载更多状态
			};
		},
		onShow() {
			this.nowPage = 0
			this.pages = 1
			this.loadData();
		},
		watch: {
			// 显示空白页
			cartList(e) {
				let empty = e.length === 0 ? true: false;
				if(this.empty !== empty){
					this.empty = empty;
				}
			}
		},
		created() {
			this.isLogin = this.$store.getters.isLogin
		},
		methods: {
			//请求数据
			async loadData(type) {
				this.loadingType = 'loading'
				if (this.nowPage >= this.pages) {
					this.loadingType = 'noMore'
					return;
				}
				
				this.nowPage += 1
				let res = await this.$api.cart.myCartList.get({
					limit: this.limit,
					page: this.nowPage
				})
				
				let list = res.data.data
				let cartList = list.map(item => {
					item.checked = false;
					return item;
				});
			
				if (type == 'more') {
					this.cartList = this.cartList.concat(cartList);
				} else {
					this.pages = Math.ceil(res.data.total / res.data.per_page)
					this.cartList = cartList;
					if (this.pages == this.nowPage) {
						this.showLoad = false;
					}
				}
				this.calcTotal();  // 计算总价
			},
			navToLogin() {
				uni.navigateTo({
					url: '/pages/public/login'
				})
			},
			 // 选中状态处理
			check(type, index) {
				if (type === 'item') {
					this.cartList[index].checked = !this.cartList[index].checked;
				} else {
					const checked = !this.allChecked
					const list = this.cartList;
					list.forEach(item=>{
						item.checked = checked;
					})
					this.allChecked = checked;
				}
				this.calcTotal(type);
			},
			// 数量
			numberChange(num, index) {
				this.cartList[index].goods_num = num;
				this.calcTotal();
			},
			// 删除
			async deleteCartItem(index) {
				let list = this.cartList;
				let row = list[index];
				let id = row.id;
				
				let res = this.$api.cart.remove.get({
					id: id
				})

				if (res.code != 0) {
					this.$tool.msg(res.msg);
				}
				
				this.cartList.splice(index, 1);
				this.calcTotal();
				uni.hideLoading();
			},
			// 清空
			clearCart() {
				uni.showModal({
					content: '清空购物车？',
					success: async (e) => {
						let res = await this.$api.cart.clearCart.get()
						if (res.code == 0) {
							this.$tool.msg('操作成功')
							this.nowPage = 0
							setTimeout(() => {
								this.loadData()
							}, 800)
						} else {
							this.$tool.msg(res.msg)
						}
					}
				})
			},
			// 计算总价
			calcTotal() {
				let list = this.cartList;
				if (list.length === 0) {
					this.empty = true;
					return;
				}
				
				let total = 0;
				let checked = true;
				list.forEach(item => {
					if (item.checked === true) {
						total += item.price * item.goods_num;
					} else if (checked === true) {
						checked = false;
					}
				})
				this.allChecked = checked;
				this.total = Number(total.toFixed(2));
			},
			// 创建订单
			createOrder() {
				let list = this.cartList;
				let goodsData = [];
				list.forEach(item => {
					if (item.checked) {
						goodsData.push({
							id: item.goods_id,
							cart_id: item.id,
							price: item.price,
							num: item.goods_num,
							rule_id: item.rule_id,
							type: 1
						})
					}
				})
				
				if (goodsData.length == 0) {
					this.$tool.msg('请选择商品')
					return
				}
				
				uni.setStorage({
					key: 'CREATE_ORDER',
					data: JSON.stringify(goodsData)
				})
				
				uni.navigateTo({
					url: `/pages/order/createOrder`
				})
			},
			// 加载更多
			onReachBottom() {
				this.loadData('more')
			},
		}
	}
</script>

<style lang='scss'>
	.container{
		padding-bottom: 134upx;
		/* 空白页 */
		.empty{
			position:fixed;
			left: 0;
			top:0;
			width: 100%;
			height: 100vh;
			padding-bottom:100upx;
			display:flex;
			justify-content: center;
			flex-direction: column;
			align-items:center;
			background: #fff;
			image{
				width: 240upx;
				height: 160upx;
				margin-bottom:30upx;
			}
			.empty-tips{
				display:flex;
				font-size: $font-sm+2upx;
				color: $font-color-disabled;
				.navigator{
					color: $uni-color-primary;
					margin-left: 16upx;
				}
			}
		}
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
	.cart-item .checkbox.checked {
		color: $uni-color-primary !important;
	}
	.cart-item .checked .uniui-checkbox-filled {
		color: $uni-color-primary !important;
	}
	
	.cart-list {
		background: #fff;
	}
</style>
