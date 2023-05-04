(function ($) {

    'use strict';
    // Mean Menu
    $('.mean-menu').meanmenu({
        meanScreenWidth: "991"
    });

    // Header Sticky, Go To Top JS
    $(window).on('scroll', function () {
        // Go To Top JS
        var scrolled = $(window).scrollTop();

        if (scrolled > 300) $('.go-top').addClass('active');
        if (scrolled < 300) $('.go-top').removeClass('active');
    });

    // Click Event JS
    $('.go-top').on('click', function () {
        $("html, body").animate({scrollTop: "0"}, 50);
    });
})(jQuery);

function numberFormat(nums, s) {
    var num;
    var result = '';
    var dot = '';
    var minus = '';
    if (nums || Number(nums) === 0) {
        num = (nums * 1).toFixed(s).toString();
        if (num.indexOf('-') > -1) {
            minus = '-';
            num = num.split('-')[1];
        }
        if (num.indexOf('.') > -1) {
            var newnum = num.split('.');
            num = newnum[0];
            dot = newnum[1];
        }
        while (num.length > 3) {
            result = ',' + num.slice(-3) + result;
            num = num.slice(0, num.length - 3);
        }
        if (num) {
            s ? (result = minus + num + result + '.' + dot) : (result = minus + num + result);
        }
    }
    return result;
}

function addFavorite() {
    var url = window.location;
    var title = document.title;
    var ua = navigator.userAgent.toLowerCase();
    if (ua.indexOf("360se") > -1) {
        alert("由于360浏览器功能限制，请按 Ctrl+D 手动收藏！");
    } else if (ua.indexOf("msie 8") > -1) {
        window.external.AddToFavoritesBar(url, title); //IE8
    } else if (document.all) {
        try {
            window.external.addFavorite(url, title);
        } catch (e) {
            alert('您的浏览器不支持,请按 Ctrl+D 手动收藏!');
        }
    } else if (window.sidebar) {
        window.sidebar.addPanel(title, url, "");
    } else {
        alert('您的浏览器不支持,请按 Ctrl+D 手动收藏!');
    }
}
