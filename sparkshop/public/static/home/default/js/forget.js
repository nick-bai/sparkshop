var time = 60;
var lock = false;

Qmsg.config({
    timeout: 1000
})

document.onkeydown = function (event) {
    var e = event || window.event;
    if (e && e.keyCode == 13) {
        $('.reg_btn').click();
    }
}

$(function () {

    // 获取验证码
    $('.code').click(function () {
        if (!lock) {
            let phone = $('.login_phone').val();
            let type = 'forget_sms_code';

            if (phone == '') {
                Qmsg['error']('请输入手机号')
                return false;
            }
            lock = true
            layui.use('layer', function() {

                layer.open({
                    type: 2,
                    title: '',
                    shadeClose: true,
                    shade: 0.6,
                    area: ['320px', '450px'],
                    content: '/index/login/captcha?phone=' + phone + '&type=' + type
                });
            })
        }

        return false;
    });

    // 登录
    $('.login_btn').click(function () {

        let forgetForm = {
            phone: $('.login_phone').val(),
            code: $('.login_code').val(),
            password: $('.login_pwd').val(),
            type: 'forget_sms_code'
        };

        $.post('/index/login/forget', forgetForm, function (res) {
            if (res.code == 0) {
                Qmsg['success']('操作成功')
                setTimeout(function () {
                    window.location.href = '/index/login'
                }, 1000)
            } else {
                Qmsg['error'](res.msg)
            }
        }, 'json')
    })
})

function countDown(msg) {
    if (msg != '短信发送成功') {
        Qmsg['error'](msg)
        return false;
    }

    Qmsg['success'](msg)
    let timeInterval = setInterval(function () {
        time = time - 1;
        $('.code').text(time + '秒');
        if (time == 0) {
            $('.code').text('获取验证码');
            clearInterval(timeInterval);
            time = 60;
            lock = false
        }
    }, 1000)
}