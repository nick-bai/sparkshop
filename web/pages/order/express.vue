<template>
	<logistics :wlInfo="wlInfo" v-if='wlInfo.list.length > 0'></logistics>
	<xw-empty :isShow="wlInfo.list.length == 0" text="暂无物流信息" textColor="#777777" v-else ></xw-empty>
</template>

<script>
	import xwEmpty from '@/components/xw-empty/xw-empty';
	import logistics from '@/components/xinyu-logistics/xinyu-logistics.vue'
	export default {
		components: {
			logistics,
			xwEmpty
		},
		onLoad(option) {
			this.orderId = option.order_id
		},
		mounted() {
			this.getExpressInfo()
		},
		data() {
			return {
				orderId: 0,
				wlInfo: {
				    delivery_status: 2, // 快递状态 1已签收 2配送中
				    post_name: '', // 快递名称
				    logo: '', // 快递logo
				    exp_phone: '', // 快递电话
				    post_no: '', // 快递单号
				    addr: '', // 收货地址
				    // 物流信息
				    list: []
				}
			}
		},
		methods: {
			// 获取物流信息
			async getExpressInfo() {
				uni.showLoading({
					title: '加载中..',
				})
				let res = await this.$api.userOrder.express.get({id: this.orderId})
				uni.hideLoading()
				if (res.code == 0) {
					let data = res.data.detail.result
					this.wlInfo.delivery_status = data.deliverystatus >= 3 ? 1 : 2
					this.wlInfo.post_name = data.expName
					this.wlInfo.logo = data.logo
					this.wlInfo.exp_phone = data.courierPhone
					this.wlInfo.post_no = data.number
					this.wlInfo.list = data.list
					this.wlInfo.addr = res.data.address
				} else {
					this.$tool.msg(res.msg)
				}
			}
		}
	}
</script>

<style>
</style>