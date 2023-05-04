<template>
	<view class="content b-t">
		<view class="list b-b" v-for="(item, index) in addressList" :key="index" @click="checkAddress(item)">
			<view class="wrapper">
				<view class="address-box">
					<text class="address">{{item.address}} {{item.area}}</text>
				</view>
				<view class="u-box">
					<text class="name">{{item.name}}</text>
					<text class="mobile">{{item.mobile}}</text>
					<text v-if="item.default" class="tag" style="float: right;">默认</text>
				</view>
			</view>
			<text class="yticon icon-bianji" @click.stop="addAddress('edit', item)"></text>
		</view>
		
		<button class="add-btn" @click="addAddress('add')">新增地址</button>
	</view>
</template>

<script>
	export default {
		data() {
			return {
				source: 0,
				addressList: []
			}
		},
		onLoad(option) {
			this.getAddressList()
		},
		created() {
			uni.$on('refreshData', () => {
				this.getAddressList()
			})
		},
		methods: {
			//选择地址
			checkAddress(item) {
				uni.$emit('checkAddress', item);
				uni.navigateBack()
			},
			addAddress(type, item){
				uni.navigateTo({
					url: `/pages/address/addressManage?type=${type}&data=${JSON.stringify(item)}`
				})
			},
			// 获取我的地址
			async getAddressList() {
				let res = await this.$api.address.info.get()
				let addressList = [];
				res.data.forEach(item => {
					addressList.push({
						id: item.id,
						name: item.real_name,
						mobile: item.phone,
						address: item.province + item.city + item.county,
						area: item.detail,
						default: (item.is_default == 1)
					})
				})
				
				this.addressList = addressList
			},
			// 添加或修改成功之后回调
			refreshList(data, type){
				//添加或修改后事件，这里直接在最前面添加了一条数据，实际应用中直接刷新地址列表即可
				this.addressList.unshift(data);
				
				console.log(data, type);
			}
		}
	}
</script>

<style lang='scss'>
	page{
		padding-bottom: 120upx;
	}
	.content{
		position: relative;
	}
	.list{
		display: flex;
		align-items: center;
		padding: 20upx 30upx;;
		background: #fff;
		position: relative;
	}
	.wrapper{
		display: flex;
		flex-direction: column;
		flex: 1;
	}
	.tag{
		font-size: 24upx;
		color: $base-color;
		margin-right: 10upx;
		background: #fffafb;
		border: 1px solid #ffb4c7;
		border-radius: 4upx;
		padding: 4upx 10upx;
		line-height: 1;
	}
	.address-box{
		display: flex;
		align-items: center;
		
		.address{
			font-size: 30upx;
			color: $font-color-dark;
		}
	}
	.u-box{
		font-size: 28upx;
		color: $font-color-light;
		margin-top: 16upx;
		.name{
			margin-right: 30upx;
		}
	}
	.icon-bianji{
		display: flex;
		align-items: center;
		height: 80upx;
		font-size: 40upx;
		color: $font-color-light;
		padding-left: 30upx;
	}
	
	.add-btn{
		position: fixed;
		left: 30upx;
		right: 30upx;
		bottom: 16upx;
		z-index: 95;
		display: flex;
		align-items: center;
		justify-content: center;
		width: 690upx;
		height: 80upx;
		font-size: 32upx;
		color: #fff;
		background-color: $base-color;
		border-radius: 10upx;
		box-shadow: 1px 2px 5px rgba(219, 63, 96, 0.4);		
	}
</style>
