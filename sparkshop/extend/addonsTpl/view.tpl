<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>插件后台</title>
  <link rel="stylesheet" href="{__CSS__}/element_ui.css"/>
  <link rel="stylesheet" href="{__CSS__}/style.css"/>
  <script src="{__JS__}/vue2.js"></script>
  <script src="{__JS__}/element_ui.js"></script>
  <script src="{__JS__}/axios.min.js"></script>
  <script src="{__JS__}/request.js"></script>
</head>
<body>
<div id="app">
  <div class="app-loading" v-if="pageLoading">
    <div class="app-loading__logo">
      <img src="{__IMG__}/logo.png"/>
    </div>
    <div class="app-loading__loader"></div>
    <div class="app-loading__title">SparkShop</div>
  </div>
  <el-card class="box-card" v-else>
    <div slot="header" class="clearfix">
      <span>插件后台</span>
    </div>
    <div class="search-box">
      <el-form :inline="true" :model="searchForm" class="demo-form-inline">
        <el-form-item label="名称">
          <el-input v-model="searchForm.name" placeholder="" clearable size="small"></el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="onSubmit" size="small" icon="el-icon-search" >查询</el-button>
        </el-form-item>
      </el-form>
    </div>
    <div style="width:100%;height:0;border-bottom:#E4E7ED 1px dashed;margin-bottom: 10px"></div>
    <el-button type="primary" icon="el-icon-plus" size="small" @click="add" style="margin-top: 10px">添加</el-button>
    <div style="width:100%;height:0;border-bottom:#E4E7ED 1px dashed;margin-top: 15px"></div>
    <el-table
            :data="tableData"
            style="width: 100%">
      <el-table-column
              prop="date"
              label="日期"
              width="180">
      </el-table-column>
      <el-table-column
              prop="name"
              label="姓名"
              width="180">
      </el-table-column>
      <el-table-column
              prop="address"
              label="地址">
      </el-table-column>
    </el-table>
  </el-card>
</div>

<script>
  new Vue({
    el: '#app',
    data: function () {
      return {
        pageLoading: true
        searchForm: {
          name: ''
        },
        tableData: []
      }
    },
    mounted() {
      this.getList()
      this.pageLoading = false
    },
    methods: {
      // 获取列表
      async getList() {
        this.tableData = [{
          date: '2016-05-02',
          name: '王小虎',
          address: '上海市普陀区金沙江路 1518 弄'
        }, {
          date: '2016-05-04',
          name: '王小虎',
          address: '上海市普陀区金沙江路 1517 弄'
        }];
      },
      onSubmit() {
        this.getList()
      },
      add() {

      }
    }
  });
</script>
<style>

</style>
</body>
</html>