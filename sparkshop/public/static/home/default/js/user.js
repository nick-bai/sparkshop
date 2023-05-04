
$(function () {

    // 获取用户订单
    getOrderList();

    $('.search_btn').click(function () {
        nowPage = 1;
        getOrderList();
    });

    // 去支付
    layui.use(['form', 'layer'], function () {
        let layer = layui.layer;
        let form = layui.form;
        let totalTimes = 200; // 轮询最高 200次
        let nowStep = 0;
        let orderLock = 0;

        form.on('submit(goPay)', function (data) {
            if (orderLock == 1) {
                return false;
            }

            layer.closeAll();
            var index = layer.load(0, {shade: false});
            orderLock = 1;
            $.post('/index/userOrder/goPay', data.field, function (res) {
                orderLock = 0;
                layer.close(index);
                if (res.code == 0) {

                    let title = '';
                    if (data.field.pay_way == 'wechat_pay') {
                        title = '微信';
                    } else {
                        title = '支付宝';
                    }

                    $('.goods-title').text('订单号：' + res.data.out_trade_no);
                    $('.pay-box .header span').text(title);
                    $('.order-price').text('￥' + res.data.pay_price);

                    // 生成二维码
                    new QRCode(document.getElementById("qrcode"), {
                        text: res.data.qr_code,
                        width: 250,
                        height: 250,
                        correctLevel : QRCode.CorrectLevel.H
                    });

                    payIndex = layer.open({
                        title: '',
                        id: 1,
                        type: 1,
                        area: ['550px', '550px'],
                        content: $('#pay-box')
                    });

                    let timer = setInterval(function () {

                        nowStep += 1;
                        if (nowStep > totalTimes) {
                            clearInterval(timer);
                        }

                        $.getJSON('/index/order/checkOrderStatus', {order: res.data.out_trade_no}, function (res) {
                            if (res.data.pay_status && res.data.pay_status != 1) {
                                layer.close(payIndex);
                                notify.success('支付成功');
                                clearInterval(timer);
                                setTimeout(function () {
                                    getOrderList()
                                }, 1500)
                            }
                        })
                    }, 3000);

                } else {
                    notify.error(res.msg);
                }
            }, 'json')
            return false;
        })
    });

    // 我已支付
    $('.payed').click(function () {
        window.location.href = '/index/user'
    });
})

let param = {
    status: 0,
    limit: 5,
    keywords: ""
};
let nowPage = 1;

function orderStatus(obj) {
    $(obj).parent('li').addClass('active').siblings('li').removeClass('active')
    param.status = $(obj).attr('data-status');
    nowPage = 1;
    getOrderList();
}

function getOrderList() {
    layui.use(['layer', 'laytpl', 'laypage'], function () {
        var layer = layui.layer;
        var laytpl = layui.laytpl;
        var laypage = layui.laypage;

        var index = layer.load(0, {shade: false});

        param.keywords = $('#search-order').val();
        param.page = nowPage;
        $.getJSON('/index/user/index', param, function (res) {
            layer.close(index);
            if (res.code === 0) {

                if (res.data.total == 0) {
                    var getTpl = orderEmpty.innerHTML
                        , view = document.getElementById('user_order_list');
                    laytpl(getTpl).render(res.data, function (html) {
                        view.innerHTML = html;
                    });
                    $('#pages').html('');
                } else {
                    var getTpl = orderList.innerHTML
                        , view = document.getElementById('user_order_list');
                    laytpl(getTpl).render(res.data, function (html) {
                        view.innerHTML = html;
                    });

                    if (res.data.total > param.limit) {
                        laypage.render({
                            elem: 'pages'
                            , limit: param.limit
                            , curr: res.data.current_page
                            , count: res.data.total
                            , jump: function (obj, first) {
                                // 首次不执行
                                if (!first) {
                                    nowPage = obj.curr
                                    getOrderList()
                                }
                            }
                        });
                    } else {
                        $('#pages').html('');
                    }
                }

            } else {
                notify.error(res.msg);
            }
        })
    })
}

// 商品退货退款
function refund(id) {
    window.location.href = '/index/refund/2/' + id;
}

// 评价
function comment(id) {
    window.location.href = '/index/appraise/' + id
}

// 取消订单
function cancel(id) {
    layui.use('layer', function () {
        var layer = layui.layer;

        let layIndex = layer.confirm('确定取消该订单吗？', {
            title: '友情提示',
            icon: 3,
            btn: ['确定', '取消']
        }, function() {
            layer.close(layIndex);
            $.getJSON('/index/userOrder/cancel', {id: id}, function (res) {
                if (res.code == 0) {
                    notify.success(res.msg);
                    setTimeout(function () {
                        getOrderList();
                    }, 1000)
                } else {
                    notify.error(res.msg);
                }
            });
        }, function() {

        });
    })
}

// 去支付
function goPay(id) {

    $('#order-id').val(id);
    layer.open({
        title: '请选择支付方式',
        type: 1,
        area: ['320px', '200px'],
        content: $('#pay_way')
    });
}

// 订单退款
function goRefund(id) {
    window.location.href = '/index/refund/1/' + id;
}

// 订单收货
function received(id) {
    layui.use('layer', function () {
        var layer = layui.layer;

        let layIndex = layer.confirm('确定收货吗？', {
            title: '友情提示',
            icon: 3,
            btn: ['确定', '取消']
        }, function() {
            layer.close(layIndex);
            $.getJSON('/index/userOrder/received', {id: id}, function (res) {
                if (res.code == 0) {
                    notify.success('操作成功');
                    setTimeout(function () {
                        getOrderList();
                    }, 1000)
                } else {
                    notify.error(res.msg);
                }
            });
        }, function() {

        });
    })
}

// 物流信息
function express(id) {
    window.location.href = '/index/express/' + id;
}

// 删除订单
function delOrder(id) {

    layui.use('layer', function () {

        var layer = layui.layer;

        layer.confirm('您确定要关闭该订单吗？', {
            title: '友情提示',
            icon: 3,
            btn: ['确定', '取消']
        }, function() {
            var index = layer.load(0, {shade: false});
            $.post('/index/userOrder/close', {id: id}, function (res) {
                layer.close(index);
                if (res.code == 0) {
                    notify.success('操作成功');
                    setTimeout(function () {
                        window.location.reload();
                    }, 1000);
                } else {
                    notify.error(res.msg);
                }
            }, 'json')
        }, function() {

        });
    })
}

// 退款进度
function refundDetail(id) {
    window.location.href = '/index/refundDetail/' + id;
}

// 取消退款
function cancelRefund(id) {
    layui.use('layer', function () {
        var layer = layui.layer;

        let layIndex = layer.confirm('确定取消退款吗？', {
            title: '友情提示',
            icon: 3,
            btn: ['确定', '取消']
        }, function() {
            layer.close(layIndex);
            $.getJSON('/index/userOrder/cancelRefund', {id: id}, function (res) {
                if (res.code == 0) {
                    notify.success('操作成功');
                    setTimeout(function () {
                        getOrderList();
                    }, 1000)
                } else {
                    notify.error(res.msg);
                }
            });
        }, function() {

        });
    })
}

