let limit = 12;
$(function () {
    getSeckillList(1);
})

function getSeckillList(page) {

    $.getJSON('/index/Seckill/index', {page: page, limit: limit}, function (res) {

        if (res.code == 0) {
            $('#seckill_time').text(res.data.start_hour);
            clock(res.data.left_seconds);

            layui.use(['laytpl', 'element', 'laypage'], function () {

                var laytpl =  layui.laytpl;
                var element = layui.element;
                var laypage = layui.laypage;

                var getTpl = goodsTpl.innerHTML
                    ,view = document.getElementById('goods-content');
                laytpl(getTpl).render(res.data.list, function(html){
                    view.innerHTML = html;
                    element.init();
                });

                if (res.data.list.last_page > 1) {
                    laypage.render({
                        elem: 'pages'
                        , limit: limit
                        , curr: res.data.list.current_page
                        , count: res.data.list.total
                        , jump: function (obj, first) {
                            // 首次不执行
                            if (!first) {
                                getSeckillList(obj.curr)
                            }
                        }
                    });
                }
            });
        }
    })
}

function clock(times) {
    // 页面加载时设置需要倒计时的秒数，计算小时
    var hour = parseInt(times / 3600);
    //  计算分钟
    var minutes = parseInt((times % 3600) / 60);
    // 计算秒
    var seconds = (times % 3600) % 60;
    //  写入页面显示
    if (hour < 10) {
        $('#hour').text('0' + hour);
    } else {
        $('#minutes').text(minutes);
    }

    if (minutes < 10) {
        $('#minutes').text('0' + minutes);
    } else {
        $('#minutes').text(minutes);
    }

    if (seconds < 10) {
        $('#seconds').text('0' + seconds);
    } else {
        $('#seconds').text(seconds);
    }

    if (times > 0) {
        times = times - 1;
        setTimeout(function () {
            clock(times);
        }, 1000);
    }
}