let param = {
    limit: 10,
    page: 1
};

$(function () {
    getList(1)

    // 立即结算
    $('.settlement').click(function () {
        $('#order_data').val(JSON.stringify(checkedGoods));
        $('#buy_goods').click();
    });
});

// 移除购物车中的物品
function remove(id) {
    layui.use('layer', function () {

        var layer = layui.layer;

        var index = layer.load(0, {shade: false});
        $.getJSON('/index/cart/remove', {id: id}, function (res) {
            layer.close(index);
            if (res.code == 0) {
                notify.success(res.msg)
                setTimeout(function () {
                    window.location.reload();
                }, 800)
            } else {
                notify.error(res.msg)
            }
        });
    });
}

function sub(obj) {
    let num = $(obj).parents('.count').find('.input-num').val();
    if (num == 0) {
        num = 0;
    } else {
        num -= 1;
    }

    let price = $(obj).parents('.row-content').find('.cart-check').attr('data-price')
    let nowId = $(obj).parents('.row-content').find('.cart-check').attr('data-id')
    $(obj).parents('.row-content').find('.cart-list-total').text('￥' + numberFormat(price * parseInt(num), 2));
    $(obj).parents('.count').find('.input-num').val(num);
    $(obj).parents('.row-content').find('.cart-check').attr('data-num', num)

    for (var i = 0; i < checkedGoods.length; i++) {
        if (checkedGoods[i].cart_id == nowId) {
            checkedGoods[i].num = num;
        }
    }

    showSettlement()
}

function add(obj) {
    let num = $(obj).parents('.count').find('.input-num').val();
    num = parseInt(num) + 1;

    let price = $(obj).parents('.row-content').find('.cart-check').attr('data-price')
    let nowId = $(obj).parents('.row-content').find('.cart-check').attr('data-id')
    $(obj).parents('.row-content').find('.cart-list-total').text('￥' + numberFormat(price * parseInt(num), 2));
    $(obj).parents('.count').find('.input-num').val(num);
    $(obj).parents('.row-content').find('.cart-check').attr('data-num', num)

    for (var i = 0; i < checkedGoods.length; i++) {
        if (checkedGoods[i].cart_id == nowId) {
            checkedGoods[i].num = num;
        }
    }

    showSettlement()
}

let checkedGoods = [];

function getList(page) {
    layui.use(['layer', 'laytpl', 'laypage'], function () {
        var layer = layui.layer;
        var laytpl = layui.laytpl;
        var laypage = layui.laypage;

        var index = layer.load(0, {shade: false});
        param.page = page;
        $.getJSON('/index/cart/detail', param, function (res) {
            layer.close(index);
            if (res.code === 0) {

                var getTpl = cartTpl.innerHTML
                    ,view = document.getElementById('cart-list');
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

                // 监听选则
                $(":checkbox").on("change",function(){
                    var $checkbox = $(this);
                    let item = {
                        id: $checkbox.attr('data-goods'),
                        cart_id: $checkbox.attr('data-id'),
                        price: $checkbox.attr('data-price'),
                        num: $checkbox.attr('data-num'),
                        rule_id: $checkbox.attr('data-rule')
                    };
                    if ($checkbox.prop("checked")) {
                        addCheckedGoods(item);
                    } else {
                        delCheckedGoods(item);
                    }

                    showSettlement();
                });

                // 监听数量
                $('.input-num').change(function () {
                    if ($(this).val() == '' || $(this).val() < 0) {
                        $(this).val(0);
                    }

                    $(this).parents('.row-content').find('.cart-check').attr('data-num', $(this).val())
                    let price = $(this).parents('.row-content').find('.cart-check').attr('data-price')
                    $(this).parents('.row-content').find('.cart-list-total').text('￥' + numberFormat(price * parseInt($(this).val()), 2));

                    if ($(this).parents('.row-content').find('.cart-check').prop("checked")) {
                        let $this = $(this).parents('.row-content').find('.cart-check');
                        let id = $this.attr('data-id')

                        for (var i = 0; i < checkedGoods.length; i++) {

                            if (checkedGoods[i].cart_id == id) {
                                checkedGoods[i].num = $(this).val();
                            }
                        }

                        showSettlement();
                    }
                });
            } else {
                notify.error(res.msg);
            }
        })
    })
}

// 增加订单
function addCheckedGoods(item) {
    checkedGoods.push(item);
}

// 删除选中的订单
function delCheckedGoods(item) {
    for (var i = 0; i < checkedGoods.length; i++) {
        if (checkedGoods[i].cart_id == item.cart_id) {
            checkedGoods.splice(i, 1);
            return false;
        }
    }
}

// 结算
function showSettlement() {
    let totalNum = 0;
    let totalAmount = 0;

    for (var i = 0; i < checkedGoods.length; i++) {
        totalNum = totalNum + parseInt(checkedGoods[i].num);
        totalAmount = totalAmount + checkedGoods[i].price * parseInt(checkedGoods[i].num);
    }

    $('.total-number').text(totalNum);
    $('.total-amount').text('￥' + numberFormat(totalAmount, 2))
}