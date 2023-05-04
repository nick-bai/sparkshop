<template>
	<view class="content">
		<view class="row b-b">
			<text class="tit">联系人</text>
			<input class="input" type="text" v-model="addressData.name" placeholder="收货人姓名" placeholder-class="placeholder" />
		</view>
		<view class="row b-b">
			<text class="tit">手机号</text>
			<input class="input" type="number" v-model="addressData.mobile" placeholder="收货人手机号码" placeholder-class="placeholder" />
		</view>
		<view class="row b-b">
			<text class="tit">省市区</text>
			<pickerAddress @change="chooseLocation" style="width: 78%;height: 22px;">
				<span style="font-size: 30upx;color:#8f939c" v-if="addressData.address =='选择省市区'">{{ addressData.address }}</span>
				<span style="font-size: 30upx;color:#303133" v-else>{{ addressData.address }}</span>
			</pickerAddress>
			<text class="yticon icon-shouhuodizhi"></text>
		</view>
		<view class="row b-b"> 
			<text class="tit">详细地址</text>
			<input class="input" type="text" v-model="addressData.area" placeholder="楼号、门牌" placeholder-class="placeholder" />
		</view>
		
		<view class="row default-row">
			<text class="tit">设为默认</text>
			<switch :checked="addressData.default" color="#e93323" @change="switchChange" />
		</view>
		<button class="add-btn" @click="confirm">提交</button>
		
	</view>
</template>

<script>
	import pickerAddress from '@/components/pickerAddress/pickerAddress';
	
	export default {
		components: {
			pickerAddress
		},
		data() {
			return {
				addressData: {
					name: '',
					mobile: '',
					area: '在地图选择',
					address: '选择省市区',
					area: '',
					default: false
				}
			}
		},
		onLoad(option){
			let title = '新增收货地址';
			if(option.type === 'edit'){
				title = '编辑收货地址'
				
				this.addressData = JSON.parse(option.data)
				this.addressData.province = ''
				this.addressData.city = ''
				this.addressData.county = ''
			}
			this.manageType = option.type;
			uni.setNavigationBarTitle({
				title
			})
		},
		methods: {
			switchChange(e){
				this.addressData.default = e.detail.value;
			},
			// 地图选择地址
			chooseLocation(val) {
				this.addressData.address = ''
				this.addressData.province = val.data[0]
				this.addressData.city = val.data[1]
				this.addressData.county = val.data[2]
				
				val.data.forEach(item => {
					this.addressData.address += item
				})
			},
			// 提交
			async confirm() {
				let data = this.addressData;
				if (!data.name) {
					this.$tool.msg('请填写收货人姓名');
					return;
				}
				if(!/(^1[3|4|5|7|8][0-9]{9}$)/.test(data.mobile)){
					this.$tool.msg('请输入正确的手机号码');
					return;
				}
				if(!data.address || data.address == '选择省市区'){
					this.$tool.msg('请选择省市区');
					return;
				}
				if(!data.area){
					this.$tool.msg('请填写门牌号信息');
					return;
				}
				
				let param = {
					id: this.addressData.id,
					real_name: this.addressData.name,
					phone: this.addressData.mobile,
					detail: this.addressData.area,
					is_default: this.addressData.default ? 1 : 2
				};
				
				if (this.addressData.province != '') {
					param.province = this.addressData.province
				}
				
				if (this.addressData.city != '') {
					param.city = this.addressData.city
				}
				
				if (this.addressData.county != '') {
					param.county = this.addressData.county
				}
				
				let res;
				if (this.manageType === 'edit') {
					res = await this.$api.address.edit.post(param)
				} else {
					res = await this.$api.address.add.post(param)
				}
				
				if (res.code === 0) {
					this.$tool.msg('操作成功');
					uni.$emit('refreshData');
					setTimeout(()=>{
						uni.navigateBack()
					}, 800)
				} else {
					this.$tool.msg(res.msg);
				}
			}
		}
	}
</script>

<style lang="scss">
	page{
		background: $page-color-base;
		padding-top: 16upx;
	}

	.row{
		display: flex;
		align-items: center;
		position: relative;
		padding:0 30upx;
		height: 110upx;
		background: #fff;
		
		.tit{
			flex-shrink: 0;
			font-size: 30upx;
			color: $font-color-dark;
			width: 150upx;
		}
		.input{
			flex: 1;
			font-size: 30upx;
			color: $font-color-dark;
		}
		.icon-shouhuodizhi{
			font-size: 36upx;
			color: $font-color-light;
		}
	}
	.default-row{
		margin-top: 16upx;
		.tit{
			flex: 1;
		}
		switch{
			transform: translateX(16upx) scale(.9);
		}
	}
	.add-btn{
		display: flex;
		align-items: center;
		justify-content: center;
		width: 690upx;
		height: 80upx;
		margin: 60upx auto;
		font-size: $font-lg;
		color: #fff;
		background-color: $base-color;
		border-radius: 10upx;
		box-shadow: 1px 2px 5px rgba(219, 63, 96, 0.4);
	}
	.title {
		font-size: 14px;
		font-weight: bold;
		margin: 20px 0 5px 0;
	}

	.data-pickerview {
		height: 400px;
		border: 1px #e5e5e5 solid;
	}

	.popper__arrow {
		top: -6px;
		left: 50%;
		margin-right: 3px;
		border-top-width: 0;
		border-bottom-color: #EBEEF5;
	}
	 .popper__arrow {
	    top: -6px;
	    left: 50%;
	    margin-right: 3px;
	    border-top-width: 0;
	    border-bottom-color: #EBEEF5;
	}
</style>
