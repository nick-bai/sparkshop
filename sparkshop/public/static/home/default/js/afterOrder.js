$(function () {

    getOrderList();
})

let param = {
    status: 0,
    limit: 5,
    keywords: ""
};
let nowPage = 1;

function getOrderList() {
    layui.use(['layer', 'laytpl', 'laypage'], function () {
        var layer = layui.layer;
        var laytpl = layui.laytpl;
        var laypage = layui.laypage;

        var index = layer.load(0, {shade: false});

        param.keywords = $('#search-order').val();
        param.page = nowPage;
        $.getJSON('/index/afterOrder', param, function (res) {
            layer.close(index);
            if (res.code === 0) {

                if (res.data.total == 0) {
                    var getTpl = orderEmpty.innerHTML
                        , view = document.getElementById('refund_order_list');
                    laytpl(getTpl).render(res.data, function (html) {
                        view.innerHTML = html;
                    });
                    $('#pages').html('');
                } else {
                    var getTpl = orderList.innerHTML
                        , view = document.getElementById('refund_order_list');
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

function orderStatus(obj) {
    $(obj).parent('li').addClass('active').siblings('li').removeClass('active')
    param.status = $(obj).attr('data-status');
    nowPage = 1;
    getOrderList();
}