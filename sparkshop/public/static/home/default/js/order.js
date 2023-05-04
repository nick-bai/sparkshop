$(function () {

    $('.options-item').click(function () {
        $('.options-item').removeClass('pay_selected');
        $(this).removeClass('pay_selected').addClass('pay_selected')
        orderParam.pay_way = $(this).attr('data-way')
    });

    $('.cell_card:eq(0)').attr("style", "margin-left:50px")

    // 添加新地址
    $('.add-desc').click(function () {

        layui.use('layer', function () {
            var layer = layui.layer;

            layer.open({
                type: 2,
                title: '添加我的地址',
                shade: 0.4,
                area: ['800px', '550px'],
                content: '/index/address/add'
            });
        });
    })

    getAddressList();
    let totalTimes = 200; // 轮询最高 200次
    let nowStep = 0;
    let orderLock = 0;

    // 下单
    $('.submit-order').click(function () {

        if (orderLock == 1) {
            return false;
        }

        orderLock = 1;

        let that = $(this)
        $(this).text('正在创建订单...');
        $(this).attr('style', "background: #FFB800");
        $.post('/index/order/createOrder', orderParam, function (res) {
            if (res.code == 0) {
                that.text('立即下单');
                that.attr('style', "background: #E9332D");
                orderLock = 0;

                let title = '';
                if (orderParam.pay_way == 'wechat_pay') {
                    title = '微信';
                } else {
                    title = '支付宝';
                }

                $('.goods-title').text('订单号：' + res.data.out_trade_no);
                $('.pay-box .header span').text(title);
                $('.order-price').text('￥' + $('#goods-real-pay').text());

                // 生成二维码
                new QRCode(document.getElementById("qrcode"), {
                    text: res.data.qr_code,
                    width: 250,
                    height: 250,
                    correctLevel : QRCode.CorrectLevel.H
                });

                layer.open({
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
                            notify.success('支付成功');
                            setTimeout(function () {
                                window.location.href = '/index/user'
                            }, 1500)
                        }
                    })
                }, 3000);

            } else {
                notify.error(res.msg)
            }
        }, 'json');
    });

    // 我已支付
    $('.payed').click(function () {
        window.location.href = '/index/user'
    });
})

// 获取地址
function getAddressList() {
    layui.use('laytpl', function () {
        var laytpl = layui.laytpl;

        $.getJSON('/index/address/getUserAddress', function (res) {
            $.each(res.data, function (k, v) {
                if (v.is_default == 1) {
                    $('.address-name').text(v.real_name + ' ' + v.phone);
                    $('.address-desc').text(v.province + v.city + v.county + v.detail);
                    orderParam.address_id = v.id;
                }
            });
            var getTpl = addressItem.innerHTML;
            laytpl(getTpl).render(res, function(html) {
                $('#address-list').html(html);

                // 试算
                trial();

                // 设置默认的地址
                $('.address-item').click(function () {
                    let that = $(this)
                    let id = $(this).attr('data-id');
                    if (!id) {
                        return false;
                    }

                    $.getJSON('/index/address/setDefault', {id: id}, function (res) {
                        if (res.code == 0) {
                            $('.address-name').text(that.attr('data-name') + ' ' + that.attr('data-phone'));
                            $('.address-desc').text(that.attr('data-address'));
                            orderParam.address_id = that.attr('data-id');
                            getAddressList();
                        }
                    })
                });
            });
        });
    });
}

// 删除地址
function removeAddress(obj) {

    let layIndex = layer.confirm('您确定要删除该地址吗？', {
        title: '友情提示',
        icon: 3,
        btn: ['确定', '取消']
    }, function () {
        let addressId = $(obj).attr('data-id');
        $.getJSON('/index/address/del', {id: addressId}, function (res) {
            layer.close(layIndex);
            if (res.code == 0) {
                notify.success(res.msg)
                if (addressId == orderParam.address_id) {
                    $('.address-name').text('');
                    $('.address-desc').text('');
                }
                orderParam.address_id = 0;
                getAddressList();
            } else {
                notify.error(res.msg)
            }
        })
    }, function () {

    });
}

// 编辑地址
function editAddress(obj) {
    event.stopPropagation();
    layui.use('layer', function () {
        var layer = layui.layer;

        layer.open({
            type: 2,
            title: '编辑我的地址',
            shade: 0.4,
            area: ['800px', '550px'],
            content: '/index/address/edit/id/' + $(obj).attr('data-id')
        });
    });
}

// 试算
function trial() {
    $.post('/index/order/trial', orderParam, function (res) {
        if (res.code == 0) {
            $('#goods-num').text(res.data.count + '件');
            $('#goods-price').text(res.data.totalPrice + '元');
            $('#goods-coupon').text('-' + res.data.coupon + '元');
            $('#goods-vip').text('-' + res.data.vipDiscount + '元');
            $('#goods-postage').text(res.data.postage + '元');
            $('#goods-real-pay').text(res.data.realPay);
        } else {
            $('.count-detail').html('<div style="font-size: 24px;' +
                '    margin-left: 100px;' +
                '    margin-top: 60px;' +
                '    color: #E9332D;">系统异常</div>');
        }
    }, 'json')
}

// 选择优惠券
function checkCoupon() {
    layui.use('layer', function () {
        var layer = layui.layer;

        layer.open({
            type: 2,
            title: '选择优惠券',
            shade: 0.4,
            area: ['500px', '650px'],
            content: '/index/coupon/selectCoupon?order_param=' + urlencode(JSON.stringify(formatOrderParam))
        });
    });
}

function urlencode (str) {
    str = (str + '').toString();

    return encodeURIComponent(str).replace(/!/g, '%21').replace(/'/g, '%27').replace(/\(/g, '%28').
    replace(/\)/g, '%29').replace(/\*/g, '%2A').replace(/%20/g, '+');
}

// 优惠券选定
function couponSelected(coupon) {
    orderParam.coupon = coupon.code;
    let _html = '<div class="cell_card" style="margin-left: 50px">';
    _html += '<div class="cell-left">' + coupon.type + '</div>';
    _html += '<div class="cell-right">' + coupon.name + '</div>';
    _html += '</div>';
    $('#coupon_list').html(_html);
    // 重算
    trial();
}