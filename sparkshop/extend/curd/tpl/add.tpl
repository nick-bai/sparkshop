<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>添加</title>
    <link rel="stylesheet" type="text/css" href="{__CSS__}/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="{__CSS__}/style.css">
    <link rel="stylesheet" type="text/css" href="/static/layui/css/layui.css">
    <link rel="stylesheet" type="text/css" href="{__CSS__}/my-style.css">
</head>
<body>
<div class="card">
    <div class="card-body">
        <form class="layui-form" action="">
            <<formField>>
            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button class="btn btn-primary squer-btn mt-2 mr-2" lay-submit lay-filter="form">立即提交</button>
                </div>
            </div>
        </form>
    </div>
</div>
<script src="{__JS__}/jquery.min.js"></script>
<script src="/static/layui/layui.js"></script>
<script>

    layui.use('form', function () {
        var form = layui.form;

        form.on('submit(form)', function (data) {
            var index = layer.load(0, {shade: false});
            $.post('<<addUrl>>', data.field, function (res) {
                layer.close(index);
                if (res.code === 0) {
                    parent.showSuccess(res.msg)
                    setTimeout(function () {
                        var index = parent.layer.getFrameIndex(window.name);
                        parent.layer.close(index);
                        parent.getList(1);
                    }, 800);
                } else {
                    parent.showError(res.msg)
                }
            }, 'json');
            return false;
        });
    });

    // 请求拦截
    $.ajaxSetup({
        complete: function (xhr, settings) {
            if (xhr.responseJSON.code == 401) {
                window.location.href = "{:url('login/index')}";
                return false;
            }
            return true;
        },
    });
</script>
</body>
</html>