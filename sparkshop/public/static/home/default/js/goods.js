var type = 0;
$(function () {

    let checkedGoods = [{
            id: goods_id,
            price: 0,
            num: 1,
            rule_id: 0,
            type: orderType
    }];

    $('.content-bar div').click(function () {
        let index = $(this).index()
        $('.tab-content').hide();
        $('#tab-' + index).show();
        $(this).siblings().removeClass('bar-active');
        $(this).removeClass('bar-active').addClass('bar-active');
    });

    $('.goods-imgs .swiper-slide').hover(function () {
        $(this).addClass('slider-active').siblings().removeClass('slider-active');
        $(this).parents('.goods-imgs').siblings('.carousel').find('img').attr('src', $(this).find('img').attr('src'))
    });

    var mySwiper = new Swiper ('.swiper', {
        loop: false,
        slidesPerView: 4,
        spaceBetween: 12,
        navigation: {
            nextEl: ".swiper-button-next",
            prevEl: ".swiper-button-prev",
        },
    });

    // 选择规格
    $('.item-items li').click(function () {
        if ($(this).hasClass('item-disabled')) {
            return false; // 暂时不让选禁用的
        }

        let index = $(this).parent().attr('data-idx');
        if (index == 0) {
            selectedMap = [];
            $('.item-items li').removeClass('item-active');
        }

        $(this).removeClass('item-active').addClass('item-active').siblings().removeClass('item-active');
        selectedMap[index]  = $(this).attr('data-item');
        let nextIndex = (parseInt(index) + 1)
        if (ruleJson[nextIndex]) {
            let item = ruleJson[nextIndex]
            for (var i = 0; i < item.length; i++) {
                let itemKey = null;
                if (selectedMap.length == 1) {
                    itemKey = selectedMap.join("※") + "※" + item[i];
                } else {
                    itemKey = selectedMap.join("※") + item[i];
                }
                let $item = $('.item-items').filter('[data-idx="' + nextIndex + '"]').find('[data-item="' + item[i] + '"]');
                if (goodsRuleDetail[itemKey]) {
                    $item.removeClass('item-disabled');
                } else {
                    $item.removeClass('item-disabled').addClass('item-disabled');
                }
            }
        }

        if (selectedMap.length == totalItem) {
            $.getJSON(goodsRuleUrl, {
                goods_id: goods_id,
                sku: selectedMap.join("※")
            }, function (res) {
                if (res.code == 0) {
                    $('.attribute').removeClass('attribute-warning')
                    $('#del-price').text('￥' + res.data.original_price);
                    $('#price').text(res.data.price);
                    if (res.data.image != '') {
                        $('.carousel img').attr('src', res.data.image);
                    }
                    $('#stock').text(res.data.stock);
                    stock = res.data.stock;
                    checkedGoods[0].rule_id = res.data.id;
                }
            })
        }

    });

    // 加数量
    $('#num-jia').click(function () {
        let num = parseInt($('#input-num').val());
        num += 1;
        $('#input-num').val(num);
        checkedGoods[0].num = num
    });

    // 减数量
    $('#num-jian').click(function () {
        let num = parseInt($('#input-num').val());
        if (num == 1) {
            num = 1;
        } else {
            num -= 1;
        }
        $('#input-num').val(num);
        checkedGoods[0].num = num
    });

    // 购物车数量变动
    $('#input-num').change(function () {
        if ($(this).val() == '' || $(this).val() < 0) {
            $(this).val(1);
        }
    })

    // 加入购物车
    $('#addCart').click(function () {
        if (selectedMap.length < totalItem) {
            $('.attribute').addClass('attribute-warning')
              .addClass('animate-bounce-up');

            notify.error('请选择规格！')
            return false;
        }

        if ($('#input-num').val() <= 0 || $('#input-num').val() == '') {
            notify.error('请选择正确的数量！')
            return false;
        }

        if ($('#input-num').val() > stock) {
            notify.error('您要购买的数量大于该商品的库存数量，请重新选择！')
            return false;
        }

        $.post('/index/cart/add', {goods_id: goods_id, rule: selectedMap, num: $('#input-num').val()}, function (res) {
            if (res.code == 0) {
                notify.success(res.msg)
                $('#cartCount').text(res.data.cartNum);
                $('#totalAmount').text('￥' + res.data.cartAmount);
            } else if (res.code == 403) {
                notify.error(res.msg)
                setTimeout(function () {
                    window.location.href = '/index/login/index?back=/index/goods/' + goods_id
                }, 1000)
            }
        }, 'json')
    });

    // 开始购买
    $('#buyNow').click(function () {

        if (selectedMap.length < totalItem) {
            $('.attribute').addClass('attribute-warning')
                .addClass('animate-bounce-up');

            notify.error('请选择规格！')
            return false;
        }

        if ($('#input-num').val() <= 0 || $('#input-num').val() == '') {
            notify.error('请选择正确的数量！')
            return false;
        }

        if ($('#input-num').val() > stock) {
            notify.error('您要购买的数量大于该商品的库存数量，请重新选择！')
            return false;
        }

        $('#order_data').val(JSON.stringify(checkedGoods));
        $('#buy_goods').click();
    });

    // 获取评论数据
    getCommentsList(1, 0);

    // 评论类型
    $('.comments li').click(function () {
        $(this).addClass('current').siblings().removeClass('current');
        type = $(this).attr('data-type');
        $('#moreComment').attr('data-page', 1)
        $('#user-comments-div').html('');
        getCommentsList(1, type);
    });

    // 获取可用的优惠券
    getValidCoupon();
})

// 获取可用的优惠券
function getValidCoupon() {
    $.getJSON('/index/goods/coupon', {goods_id: goods_id}, function (res) {
        if (res.code == 0 && (res.data.comCouponList.length > 0 || res.data.goodsCouponList.length > 0)) {
            let _html = '';
            $.each(res.data.comCouponList, function (k, v) {
               _html += '<li>';
               _html += '<div class="cell">' +
                   '        <div class="cell-left">' + v.type_txt + '</div>' +
                   '          <div class="cell-right">' + v.name + '</div>' +
                   '     </div>';
                if (v.received == 2) {
                    _html += '<span class="take" style="color:#999;border-bottom:none">已领取</span>';
                } else {
                    _html += '<span class="take" onclick="receive(' + v.id + ')">领取</span>';
                }
               _html += '</li>';
            });

            $.each(res.data.goodsCouponList, function (k, v) {
                _html += '<li>';
                _html += '<div class="cell">' +
                    '        <div class="cell-left">' + v.type_txt + '</div>' +
                    '          <div class="cell-right">' + v.name + '</div>' +
                    '     </div>';
                if (v.received == 2) {
                    _html += '<span class="take" style="color:#999;border-bottom:none">已领取</span>';
                } else {
                    _html += '<span class="take" onclick="receive(' + v.id + ')">领取</span>';
                }
                _html += '</li>';
            });

            $('.quan').html(_html);
            $('#coupon-list').show();
        }
    }, 'json')
}

// 领取优惠券
function receive(couponId) {

    $.getJSON('/index/coupon/receive', {coupon_id: couponId, goods_id: goods_id}, function (res) {
        if (res.code == 0) {
            notify.success(res.msg);
            getValidCoupon();
        } else if (res.code == 403) {
            notify.error(res.msg);
            setTimeout(function () {
                window.location.href = '/index/login/index?back=/index/goods/' + goods_id
            }, 1000)
        } else {
           notify.error(res.msg);
        }
    })
}

// 评论列表
function getCommentsList(page, type) {
    layui.use(['laytpl'], function () {
        var laytpl = layui.laytpl;

        var index = layer.load(0, {shade: false});
        $.getJSON('/index/goods/getComments', {
            page: page,
            limit: 10,
            type: type,
            goods_id: goods_id
        }, function (res) {
            layer.close(index);
            if (res.code == 0) {
                var getTpl = comments.innerHTML;
                laytpl(getTpl).render(res.data, function(html){
                    $('#user-comments-div').append(html)
                });

                $('#moreComment').attr('data-page', res.data.current_page)
                if (res.data.last_page == page || res.data.total == 0) {
                    $('#moreComment').hide();
                } else {
                    $('#moreComment').show();
                }
            }
        })
    })
}

// 更多评论
function getMore(obj) {
    let page = $(obj).attr('data-page')
    getCommentsList(parseInt(page) + 1, type);
}

function showBigPic(img) {

    let photos = {
        "title": "评论图片",
        "id": 1,
        "start": 0,
        "data": [
            {
                "alt": "图1",
                "pid": 1,
                "src": img,
                "thumb": ""
            }
        ]
    }

    layui.use('layer', function () {
        var layer = layui.layer;
        layer.photos({
            photos: photos
            , anim: 5
            , shade: 0.4
        });
    });
}