<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title><<title>></title>
    <link rel="stylesheet" type="text/css" href="{__CSS__}/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="{__CSS__}/style.css">
    <link rel="stylesheet" type="text/css" href="/static/layui/css/layui.css">
    <link rel="stylesheet" type="text/css" href="{__CSS__}/my-style.css">
    <link rel="stylesheet" type="text/css" href="{__JS__}/message/message.css">
</head>
<body  style="padding: 10px">
<div class="row">
    <div class="colxl-12 col-lg-12 col-md-12 col-sm-12 col-12">
        <div class="page-title-wrapper">
            <div class="page-title-box ad-title-box-use">
                <h4 class="page-title"></h4>
            </div>
            <div class="ad-breadcrumb" style="width: 100%;">
                <ul>
                    <li>
                        <div class="ad-user-btn">
                            <input class="form-control" type="text" placeholder="名称" id="text-input">
                        </div>
                    </li>
                    <li>
                        <div class="add-group">
                            <a class="sm-btn btn-primary" style="color:#fff" id="search"> <i class="layui-icon layui-icon-search"></i> 查询</a>
                        </div>
                    </li>
                </ul>
            </div>

            <div style="width: 100%">
                <div class="add-group">
                    <a class="sm-btn btn-primary" style="color:#fff" id="add"> <i class="layui-icon layui-icon-add-1"></i> 添加</a>
                    <a class="sm-btn btn-primary" style="color:#fff;" onclick="window.location.reload()"> <i class="layui-icon layui-icon-refresh"></i></a>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Table Start -->
<div class="row">
    <!-- Styled Table Card-->
    <div class="col-xl-12 col-lg-12 col-md-12 col-sm-12 col-12">
        <div class="card table-card">
            <div class="card-header pb-0">
                <h4><<title>></h4>
            </div>
            <div class="card-body">
                <div class="chart-holder">
                    <div class="table-responsive">
                        <table class="table table-hover table-styled mb-0">
                            <thead>
                            <tr>
                                <<tableHeader>>
                                <th>操作</th>
                            </tr>
                            </thead>
                            <tbody id="table-view">

                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="text-right pt-2">
                    <nav class="d-inline-block" id="pages">

                    </nav>
                </div>
            </div>
        </div>
    </div>
</div>
<script id="tableData" type="text/html">
    {{#  layui.each(d.data, function(index, item){ }}
    <tr>
        <<tableData>>
        <td class="relative">
            <a class="action-btn" href="javascript:void(0);" style="color:#11a1fd" onclick="edit({{ item.id }})">
                编辑
            </a>
            &nbsp;&nbsp;
            <a class="action-btn " href="javascript:void(0);" style="color:#11a1fd" onclick="del({{ item.id }})">
                删除
            </a>
        </td>
    </tr>
    {{#  }); }}
</script>
<script src="{__JS__}/jquery.min.js"></script>
<script src="{__JS__}/message/message.js"></script>
<script src="/static/layui/layui.js"></script>
<script>
    Qmsg.config({
        timeout: 1500
    })

    let param = {
        name: '',
        limit: 15,
        page: 1
    };

    $(function () {
        getList(1);

        $('#add').click(function () {

            layui.use('layer', function () {

                var layer = layui.layer;

                layer.open({
                    type: 2,
                    title: '添加',
                    shade: 0.2,
                    maxmin: true,
                    offset: ['100px'],
                    area: ['600px', '68%'],
                    content: '<<addUrl>>'
                });
            })
        });

        // 查询
        $('#search').click(function () {
            getList(1)
        })
    });

    function getList(page) {
        layui.use(['layer', 'laytpl', 'laypage'], function () {
            var layer = layui.layer;
            var laytpl = layui.laytpl;
            var laypage = layui.laypage;

            var index = layer.load(0, {shade: false});
            param.page = page;
            param.name = $('#text-input').val();
            $.getJSON('<<listUrl>>', param, function (res) {
                layer.close(index);
                if (res.code === 0) {

                    var getTpl = tableData.innerHTML
                        ,view = document.getElementById('table-view');
                    laytpl(getTpl).render(res.data, function(html){
                        view.innerHTML = html;
                    });

                    laypage.render({
                        elem: 'pages'
                        ,limit: param.limit
                        ,curr: res.data.current_page
                        ,count: res.data.total
                        , jump: function(obj, first) {
                            // 首次不执行
                            if (!first) {
                                getList(obj.curr)
                            }
                        }
                    });
                } else {
                    layer.msg(res.msg);
                }
            })
        })
    }

    function showSuccess(msg) {
        Qmsg['success'](msg)
    }

    function showError(msg) {
        Qmsg['error'](msg)
    }

    function edit(id) {

        layui.use('layer', function () {

            var layer = layui.layer;

            layer.open({
                type: 2,
                title: '编辑',
                shade: 0.2,
                maxmin: true,
                offset: ['100px'],
                area: ['600px', '68%'],
                content: '<<editUrl>>/id/' + id
            });
        })
    }

    function del(id) {
        layui.use('layer', function () {

            var layer = layui.layer;
            var index = 0;
            index = layer.confirm('确定删除该数据？', {
                title: '友情提示',
                icon: 3,
                btn: ['确定', '取消']
            }, function() {
                $.getJSON('<<delUrl>>', {id: id}, function (res) {
                    if (res.code === 0) {
                        showSuccess(res.msg)
                        setTimeout(function () {
                            layer.close(index);
                            getList(1);
                        }, 800)
                    } else {
                        showError(res.msg)
                    }
                })
            }, function(){

            });
        })
    }
    // 请求拦截
    $.ajaxSetup({
        complete: function (xhr, settings) {
            if (xhr.responseJSON.code == 401) {
                window.location.href = "{:myUrl('login/index')}";
                return false;
            }
            return true;
        },
    });
</script>
</body>
</html>
