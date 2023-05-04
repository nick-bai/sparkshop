var time = 60;
var lock = false;
$(function () {
    let search = window.location.search;

    Qmsg.config({
        timeout: 1000
    })

    $('.login_label').click(function () {

        let index = $(this).index()
        $('.login_label').removeClass('label_active')
        $(this).removeClass('label_active').addClass('label_active')

        if (index == 0) {
            $('.login_form_box').show();
            $('.reg_form_box').hide();
            nowFormType = 1;
        } else {
            $('.login_form_box').hide();
            $('.reg_form_box').show();
            nowFormType = 2;
        }
    });

    document.onkeydown = function (event) {
        var e = event || window.event;
        if (e && e.keyCode == 13) {
            if (nowFormType == 1) {
                $('.login_btn').click();
            } else {
                $('.reg_btn').click();
            }
        }
    }

    $('#login_type').click(function () {

        if (nowLoginType == 1) {
            $('#phone_login').hide();
            $('#phone_code_login').show();
            $(this).text('账号密码登录');
            nowLoginType = 2;
        } else {
            $('#phone_login').show();
            $('#phone_code_login').hide();
            nowLoginType = 1;
            $(this).text('快速登录');
        }
    });

    // 登录
    $('.login_btn').click(function () {
        layui.use('layer', function () {
            var layer = layui.layer;
            let loginForm = {};
            if (nowLoginType == 1) {
                loginForm = {
                    phone: $('.login_phone').val(),
                    password: $('.login_pwd').val(),
                    loginType: 1,
                    type: 'login_sms_code'
                };

                if (loginForm.phone == '') {
                    Qmsg['error']('请输入手机号')
                    return false;
                }

                if (loginForm.password == '') {
                    Qmsg['error']('请输入密码')
                    return false;
                }
            } else {
                loginForm = {
                    phone: $('.login_code_phone').val(),
                    code: $('.login_code').val(),
                    loginType: 2,
                    type: 'login_sms_code'
                };

                if (loginForm.phone == '') {
                    Qmsg['error']('请输入手机号')
                    return false;
                }

                if (loginForm.code == '') {
                    Qmsg['error']('请输入验证码')
                    return false;
                }
            }

            $.post(loginUrl, loginForm, function (res) {
                if (res.code == 0) {
                    Qmsg['success'](res.msg)
                    setTimeout(function () {
                        if (search) {
                            window.location.href = search.split('=')[1]
                        } else {
                            window.location.href = '/';
                        }
                    }, 1000);
                } else {
                    Qmsg['error'](res.msg)
                }
            }, 'json')
        })
    });

    // 注册
    $('.reg_btn').click(function () {
        layui.use('layer', function () {
            var layer = layui.layer;
            let phone = $('.reg_phone').val();
            let password = $('.reg_pwd').val();
            let code = $('.reg_code').val();

            if (phone == '') {
                Qmsg['error']('请输入手机号')
                return false;
            }

            if (password == '') {
                Qmsg['error']('请输入密码')
                return false;
            }

            if (code == '') {
                Qmsg['error']('请输入验证码')
                return false;
            }

            if (!$('.agree').is(":checked")) {
                Qmsg['error']('请同意 用户协议 和 隐私政策')
                return false;
            }

            $.post(regUrl, {
                phone: phone,
                password: password,
                code: code,
                type: 'reg_sms_code'
            }, function (res) {
                if (res.code == 0) {
                    Qmsg['success'](res.msg)
                    setTimeout(function () {
                        window.location.reload();
                    }, 1000)
                } else {
                    Qmsg['error'](res.msg)
                }
            }, 'json');
        })

    });

    // 获取验证码
    $('.code').click(function () {
        if (!lock) {
            let phone = '';
            let type = '';
            if (nowFormType == 1) {
                phone = $('.login_code_phone').val();
                type = 'login_sms_code';
            } else {
                phone = $('.reg_phone').val();
                type = 'reg_sms_code';
            }

            if (phone == '') {
                Qmsg['error']('请输入手机号')
                return false;
            }
            lock = true;

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