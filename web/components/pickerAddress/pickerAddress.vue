<template>
	<picker @change="bindPickerChange" @columnchange="columnchange" :range="array" range-key="name" :value="value" mode="multiSelector">
		<slot></slot>
	</picker>
</template>

<script>
	// import AllAddress from './data.js'
	let selectVal = ['', '', '']
	let selectCode = ['', '', '']
	
	export default {
		data() {
			return{
				value: [0,0,0],
				array: [],
				index: 0,
				allAddress: []
			}
		},
		created() {
			this.getAreaData()
		},
		methods:{
			// 初始化地址选项
			initSelect() {
				this.updateSourceData() // 更新源数据
				.updateAddressData() // 更新结果数据
				.$forceUpdate()  // 触发双向绑定
			},
			// 地址控件改变控件
			columnchange(d) {
				this.updateSelectIndex(d.detail.column, d.detail.value) // 更新选择索引
				.updateSourceData() // 更新源数据
				.updateAddressData() // 更新结果数据
				.$forceUpdate()  // 触发双向绑定
			},
			async getAreaData() {
				let res = await this.$api.address.area.get()
				this.allAddress = res.data
				this.initSelect()
			},
			/**
			 * 更新源数据
			 * */
			updateSourceData() {
				this.array = []
				this.array[0] = this.allAddress.map(obj => {
					return {
						code: obj.id,
						name: obj.name
					}
				})
				this.array[1] = this.allAddress[this.value[0]].child.map(obj => {
					return {
						code: obj.id,
						name: obj.name
					}
				})
				if (this.allAddress[this.value[0]].child[this.value[1]].child) {
					this.array[2] = this.allAddress[this.value[0]].child[this.value[1]].child.map(obj => {
						return {
							code: obj.id,
							name: obj.name
						}
					})
				}
				return this
			},
			
			/**
			 * 更新索引
			 * */
			updateSelectIndex(column, value){
				let arr = JSON.parse(JSON.stringify(this.value)) 
				arr[column] = value
				if(column === 0 ) {
					arr[1] = 0
					arr[2] = 0
				}
				if(column === 1 ) {
					arr[2] = 0
				}
				this.value = arr
				return this
			},
			
			/**
			 * 更新结果数据 
			 * */
			updateAddressData() {
				selectVal[0] = this.array[0][this.value[0]].name
				selectVal[1] = this.array[1][this.value[1]].name 
				if (this.array[2]) {
					selectVal[2] = this.array[2][this.value[2]].name
				}
				
				selectCode[0] = this.array[0][this.value[0]].code
				selectCode[1] = this.array[1][this.value[1]].code
				if (this.array[2]) {
					selectCode[2] = this.array[2][this.value[2]].code
				}

				return this
			},
			
			/**
			 * 点击确定
			 * */
			bindPickerChange(e) {
				this.$emit('change', {
					index: this.value,
					data: selectVal,
					code: selectCode
				})
				return this
			}
			
		}
	}
</script>

<style>
	.uni-picker-item {
		font-size: 16px;
	}
</style>
