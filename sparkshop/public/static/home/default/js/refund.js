$(function () {

    // 退款方式
    $('.refund').click(function () {

        var id = $(this).attr('data-type');
        $(this).addClass('refund-active').siblings().removeClass('refund-active')
        if (id == 'refund-money-box') {
            $('#refund-money-box').show();
            $('#refund-goods-box').hide();
        } else {
            $('#refund-money-box').hide();
            $('#refund-goods-box').show();
        }
    });
})

let onlyRefundImg = 0;
let refundGoodsImg = 0;

// 执行退款
function doRefund(param) {
    $.post('/index/userOrder/refund', param, function (res) {
        if (res.code == 0) {
            notify.success(res.msg);
            setTimeout(function () {
                window.location.href = '/index/refundDetail/' + res.data;
            }, 1500);
        } else {
            notify.error(res.msg);
        }
    }, 'json');
}

layui.use(['upload', 'form'], function () {

    var upload = layui.upload;
    var form = layui.form;

    // 退款申请
    form.on('submit(submit-money)', function (data) {
        doRefund(data.field);
        return false;
    });

    // 退款退货申请
    form.on('submit(submit-goods)', function (data) {
        doRefund(data.field);
        return false;
    });

    // 仅退款
    upload.render({
        elem: '#refund-money-upload'
        ,url: '/index/upload/img'
        ,multiple: true
        ,before: function(obj) {
            if (onlyRefundImg >= 3) {
                notify.error('最多上传3张凭证');
                return false;
            }
        }
        ,done: function (res) {
            onlyRefundImg += 1;
            var _html = '<div class="refund-preview"><i class="layui-icon layui-icon-close-fill" style="cursor: pointer"></i>';
            _html += '<input type="hidden" name="refund_img[]" value="' + res.data.url + '"/>';
            _html += '<img src="'+ res.data.url +'" alt="'+ res.data.url +'" class="layui-upload-img" style="margin-left: 10px" height="80px" width="80px">';
            _html += '</div>';
            $('#refund-money-pic').append(_html);

            $('.layui-icon-close-fill').click(function () {
                $(this).parent().remove();
                onlyRefundImg -= 1;
            });
        }
    });

    // 退款退货
    upload.render({
        elem: '#refund-goods-upload'
        ,url: '/index/upload/img'
        ,multiple: true
        ,before: function(obj) {
            if (refundGoodsImg >= 3) {
                notify.error('最多上传3张凭证');
                return false;
            }
        }
        ,done: function (res) {
            refundGoodsImg += 1;
            var _html = '<div class="refund-preview"><i class="layui-icon layui-icon-close-fill" style="cursor: pointer"></i>';
            _html += '<input type="hidden" name="refund_img[]" value="' + res.data.url + '"/>';
            _html += '<img src="'+ res.data.url +'" alt="'+ res.data.url +'" class="layui-upload-img" style="margin-left: 10px" height="80px" width="80px">';
            _html += '</div>';
            $('#refund-goods-pic').append(_html);

            $('.layui-icon-close-fill').click(function () {
                $(this).parent().remove();
                refundGoodsImg -= 1;
            });
        }
    });
});



