let canSend = true;
// 编辑昵称
function editNickname() {
    layui.use('layer', function () {
        var layer = layui.layer;

        layer.open({
            title: '编辑信息',
            type: 1,
            area: ['420px', '240px'],
            content: $('#nickname-box')
        });
    });
}

// 编辑性别
function editSex() {
    layui.use('layer', function () {
        var layer = layui.layer;

        layer.open({
            title: '编辑信息',
            type: 1,
            area: ['420px', '240px'],
            content: $('#sex-box')
        });
    });
}

// 编辑生日
function editBirthday() {
    layui.use('layer', function () {
        var layer = layui.layer;

        layer.open({
            title: '编辑信息',
            type: 1,
            area: ['420px', '240px'],
            content: $('#birthday-box')
        });
    });
}

// 编辑手机号
function editPhone() {
    layui.use('layer', function () {
        var layer = layui.layer;

        layer.open({
            title: '编辑信息',
            type: 1,
            area: ['420px', '280px'],
            content: $('#phone-box')
        });
    });
}

$(function () {
    $('#code').click(function () {
        if (!canSend) {
            return false;
        }

        layui.use('layer', function () {
            var layer = layui.layer;

            var phone = $('#phone').val();
            if (phone == '') {
                layer.msg('请输入手机号');
                return false;
            }

            new RotateVerify('#rotateWrap1', {
                initText: '滑动将图片转正',
                slideImage: ['/default/static/image/captcha/1.png', '/default//static/image/captcha/2.png',
                    '/default//static/image/captcha/4.png', '/default//static/image/captcha/5.png'],
                initUrl: "/captcha/initData",
                verifyUrl: "/captcha/verify",
                verifyParam: {phone: phone, type: 'bind_sms_code'},
                getSuccessState: function (res) {
                    layer.msg(res.msg);
                    $('.captcha-bg').hide();
                    $('#captcha-box').hide();
                    canSend = false;

                    let timerDesc = 60; // 倒计时
                    var timer = setInterval(function () {
                        if (timerDesc == 0) {
                            clearInterval(timer)
                            canSend = true;
                            $('#code').text('获取验证码');
                        } else {
                            timerDesc--;
                            $('#code').text(timerDesc + '秒');
                        }

                    }, 1000);
                }
            })

            $('.captcha-bg').show();
            $('#captcha-box').show();
        })
    });

    $('.cuo').click(function () {
        $('.captcha-bg').hide();
        $('#captcha-box').hide();
    });
})

layui.use('laydate', function(){
    var laydate = layui.laydate;

    laydate.render({
        elem: '#birthday'
    });
});

// 上传
layui.use(['upload', 'layer'], function(){
    var upload = layui.upload;
    var layer = layui.layer;

    upload.render({
        elem: '#avatar'
        ,url: '/index/upload/img'
        ,done: function(res){
            // 上传完毕回调
            if (res.code == 0) {
                $.post('/index/user/personal', {avatar: res.data.url}, function (res) {
                    if (res.code == 0) {
                        layer.msg('上传成功');
                        setTimeout(function () {
                            window.location.reload();
                        }, 1000)
                    }
                }, 'json')
            } else {
                layer.msg(res.msg);
            }
        }
        ,error: function(){
            //请求异常回调
        }
    });
});

layui.use(['form', 'layer'], function () {

    var form = layui.form;
    var layer = layui.layer;

    form.on('submit(personal)', function (data) {

        $.post('/index/user/personal', data.field, function (res) {
            if (res.code == 0) {
                layer.msg(res.msg);
                setTimeout(function () {
                    window.location.reload();
                }, 1000)
            } else {
                layer.msg(res.msg);
            }
        }, 'json');

        return false;
    })
})