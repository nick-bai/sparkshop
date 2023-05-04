$(function () {

    getAddressList();

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
})

function getAddressList() {
    layui.use('laytpl', function () {
        var laytpl = layui.laytpl;

        $.getJSON('/index/address/getUserAddress', function (res) {
            $.each(res.data, function (k, v) {
                if (v.is_default == 1) {
                    $('.address-name').text(v.real_name + ' ' + v.phone);
                    $('.address-desc').text(v.province + v.city + v.county + v.detail);
                }
            });
            var getTpl = addressItem.innerHTML;
            laytpl(getTpl).render(res, function(html) {
                $('#address-list').html(html);

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
                            getAddressList();
                        }
                    })
                });
            });
        });
    });
}

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