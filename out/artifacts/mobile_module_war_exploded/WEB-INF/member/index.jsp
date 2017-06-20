<%--
  Created by IntelliJ IDEA.
  User: 汁
  Date: 2017/3/25
  Time: 19:00
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <%--<title>会员主页</title>--%>
    <link rel="stylesheet" href="css/sm.min.css">
    <link rel="stylesheet" href="css/gym.css">
    <link rel="stylesheet" href="css/animate.css">
    <link href="https://cdn.bootcss.com/font-awesome/4.7.0/css/font-awesome.css" rel="stylesheet">

</head>
<body>
<div class="page-group">
    <c:forEach items="${listChild}" var="child" varStatus="status">
        <div class="page <c:if test="${status.index==0}">page-current</c:if>" child-index="${status.index}"
             child-name=${child['name']}  child-id="${child['idhz']}"
             id="child${status.index}">
            <div class="content">
                <div class="card">
                    <div class="card-header no-border gym-card-title">
                        <c:choose>
                            <c:when test="${status.index==0}">
                                <label class="child-name">${child['name']} </label>
                                <c:if test="${listChild.size() > 1}">
                                    <a href="#child${status.index==0?1:0}">
                                        <small>查询另一位宝宝</small>
                                        <i class="fa fa-angle-double-right"></i></a>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <a href="#child${status.index==0?1:0}">
                                    <i class="fa fa-angle-double-left"></i>
                                    <small>查询另一位宝宝</small>
                                </a>
                                <label>${child['name']} </label>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="card">
                    <div class="card-header no-padding no-border card-backinfo">
                        <i></i>
                        <div class="gym-header">
                            <div class="header-img">
                                        <img src="${sessionScope.user.head_src}" onerror="this.src='/images/member/head.png'"/>
                            </div>
                            <a class="header-text external"
                               href="/index/myinfo?idhz=${child['idhz']}&name=${child['name']}&age=${child['age']}">
                                <div class="header-p">
                                    <p>年龄：${child['age']}</p>
                                    <p>剩余课时：${child['rest']}节课</p>
                                </div>
                                <div class="header-row-right">
                                    <i class="fa fa-angle-right fa-3x "></i>
                                </div>
                            </a>
                        </div>
                        <%--<div class="inform">--%>
                            <%--<div class="inform-title">活动通知：</div>--%>
                            <%--<div class="activity-info">植树节活动|4月1号全面涨价</div>--%>
                        <%--</div>--%>
                        <i></i>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header gym-card-title">
                        <label>我的运动</label>
                        <i></i>
                    </div>
                    <div class="card-content">
                        <c:choose>
                            <c:when test="${not empty listRank[status.index]}">
                                <div class="card-content-inner exercise-content">
                                    <div class="row no-gutter  row-box">
                                        <div class="col-33 ">
                                            <div class="sign-first">过去三月超过全国</div>
                                            <label class="big outpass">${listRank[status.index]['outpass']}</label>%会员
                                        </div>
                                        <div class="col-33 c">
                                            <div class="sign-first">总共运动</div>
                                            <label class="big mins">${listRank[status.index]['mins']}</label>分钟
                                        </div>
                                        <div class="col-33">
                                            <div class="sign-first">全国会员中排第</div>
                                            <label class="big ranking">${listRank[status.index]['ranking']}</label>名<i
                                                class="fa fa-angle-double-right"></i></div>
                                    </div>
                                    <div class="exercise-text">
                                        <p><label class="big tian">${listRank[status.index]['tian']}</label>天您已加入小小运动馆</p>
                                        <p><label class="big times_per_week"><fmt:formatNumber
                                                value="${listRank[status.index]['times_per_week']}"
                                                pattern="0.0"/></label>次您孩子平均每周锻炼次数<br/>（全国运动量前100名会员每周平均运动<label class="big">1.94</label>次）
                                        </p>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="card-content-inner">
                                    <p class="text-center">暂时还没有排名</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header gym-card-title">
                        <a class="gym-select"
                           gym-id="${listGymSelectedSession[status.index].gym['gymId']}">${listGymSelectedSession[status.index].gym['gymName']}</a>
                    </div>
                    <div class="card-content-inner">
                        <div>
                            <div class="gym-datepicker">
                                <i class="fa fa-angle-double-left beginDate-i"></i>
                                <input type="text" readonly class="beginDate"
                                       value="${listGymSelectedSession[status.index]['beginDate']}"
                                       data-toggle="date"/> -
                                <input type="text" readonly class="endDate"
                                       value="${listGymSelectedSession[status.index]['endDate']}"
                                       data-toggle="date"/>
                                <i class="fa fa-angle-double-right endDate-i"></i>
                            </div>
                            <div class="row no-gutter gym-icon-list">
                                <div class="col-20  text-center"><i class="fa fa-calendar fa-lg"></i>
                                    <p>日期</p>
                                </div>
                                <div class="col-20 text-center"><i class="fa fa-clock-o fa-lg"></i>
                                    <p>时间</p>
                                </div>
                                <div class="col-20 text-center"><i class="fa fa-users fa-lg"></i>
                                    <p>班级</p>
                                </div>
                                <div class="col-20 text-center"><i class="fa fa-check-square fa-lg"></i>
                                    <p>状态</p>
                                </div>
                                <div class="col-20 text-center"><i class="fa fa-bar-chart-o fa-lg"></i>
                                    <p>课程详情</p>
                                </div>
                            </div>
                            <section
                                    class="swiper-container-dlist swiper-container-vertical swiper-container-free-mode">
                                <div class="swiper-wrapper">
                                    <div class="swiper-slide swiper-slide-active">
                                        <ul class="details_list">
                                            <c:choose>
                                                <c:when test="${not empty listGymClassAll[status.index]}">
                                                    <c:forEach items="${listGymClassAll[status.index]}" var="gymClass">
                                                        <li class="row no-gutter">
                                                <span class="col-20  date"><fmt:formatDate value="${gymClass['date']}"
                                                                                           pattern="yyyy.MM.dd"/></span>
                                                            <span class="col-20  time">${gymClass['time']}</span>
                                                            <span class="col-20  class">${gymClass['course']}</span>
                                                        <span class="col-20  state <c:if test="${gymClass['kq'] == '尚未开课'}"> text-danger</c:if>">
                                                                ${gymClass['kq']}</span>
                                                            <a onclick="toTopic()"><span
                                                                    class="col-20 details">课程亮点</span></a>
                                                        </li>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <p class="text-center">没有查询到课程</p>
                                                </c:otherwise>
                                            </c:choose>
                                        </ul>
                                    </div>
                                </div>
                            </section>
                        </div>
                    </div>
                </div>


            </div>
        </div>
    </c:forEach>
</div>

<script type='text/javascript' src='/js/zepto.min.js' charset='utf-8'></script>
<script type='text/javascript' src='/js/sm.min.js' charset='utf-8'></script>
<script src="/js/swiper-3.4.2.jquery.min.js"></script>
<script type='text/javascript' src="https://res.wx.qq.com/open/js/jweixin-1.2.0.js"></script>
<script>
    /*全局孩子标识*/
    var PAGE_ID = $(".page-current").attr("id") ? $(".page-current").attr("id") : 'child1';
    var CHILD_ID = $("#" + PAGE_ID).attr("child-id");
    var CHILD_INDEX = $("#" + PAGE_ID).attr("child-index");
    $(document).on("pageInit", function (e, pageId, $page) {
        CHILD_ID = $page.attr("child-id");
        PAGE_ID = pageId;
        CHILD_INDEX = $page.attr("child-index");
        document.title = $page.attr("child-name") + "的主页";
    });

    wx.config({
        debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
        appId: 'wxc82d50af409223ad', // 必填，公众号的唯一标识
        timestamp: '${weixinMap['timestamp']}', // 必填，生成签名的时间戳
        nonceStr: '${weixinMap['nonceStr']}', // 必填，生成签名的随机串
        signature: '${weixinMap['signature']}',// 必填，签名，见附录1
        jsApiList: ['onMenuShareTimeline','onMenuShareAppMessage','onMenuShareQQ'] // 必填，需要使用的JS接口列表，所有JS接口列表见附录2
    });
    wx.ready(function(){
        var outpass = $('#'+PAGE_ID + ' .outpass').text();
        var title = '我在小小运动馆过去三月超过全国' + outpass + '%会员，你也来看一下吧！';

        var link = shareLink();
        wx.onMenuShareTimeline({
            title: title, // 分享标题
            link: link, // 分享链接，该链接域名或路径必须与当前页面对应的公众号JS安全域名一致
            imgUrl: 'http://test.thelittlegym.com.cn/images/member/head.jpg', // 分享图标
            success: function () {
                $.toast("分享成功");
            },
            cancel: function () {
            }
        });
        wx.onMenuShareAppMessage({
            title: title, // 分享标题
            desc: '测试描述', // 分享描述
            link:link, // 分享链接，该链接域名或路径必须与当前页面对应的公众号JS安全域名一致
            imgUrl: 'http://test.thelittlegym.com.cn/images/member/head.jpg', // 分享图标
            type: 'link', // 分享类型,music、video或link，不填默认为link
            dataUrl: '', // 如果type是music或video，则要提供数据链接，默认为空
        });
        wx.onMenuShareQQ({
            title: '测试看一下', // 分享标题
            desc: '', // 分享描述
            link: link, // 分享链接
            imgUrl: '', // 分享图标
            success: function () {
                // 用户确认分享后执行的回调函数
            },
            cancel: function () {
                // 用户取消分享后执行的回调函数
            }
        });
    });



    //手动处理
    $(".endDate-i").on('click', function () {
        var next_week = getNewDay($("#" + PAGE_ID + " .endDate").val(), 7);
        $("#" + PAGE_ID + " .endDate").val(next_week);
        updateCalendar(next_week);
        $("#" + PAGE_ID + " .endDate").trigger('change');
    })
    $(".beginDate-i").on('click', function () {
        var pre_week = getNewDay($("#" + PAGE_ID + " .beginDate").val(), -7);
        $("#" + PAGE_ID + " .beginDate").val(pre_week);
        $("#" + PAGE_ID + " .beginDate").trigger('change');
    })
    function updateCalendar(date){
        var dateValue = date.replace(/-0/g,"-");//格式化
        $("#"+PAGE_ID+".picker-calendar").find(".picker-calendar-day-selected").remove(".picker-calendar-day-selected");
        $("#"+PAGE_ID+".picker-calendar").find('.picker-calendar-day[data-date="' + dateValue + '"]').addClass('picker-calendar-day-selected');

    }
    //日期加减
    function getNewDay(dateTemp, days) {
        var nDate = new Date(Date.parse(dateTemp.replace(/-/g, "/"))); //转换格式
        var millSeconds = Math.abs(nDate) + (days * 24 * 60 * 60 * 1000);
        var rDate = new Date(millSeconds);
        var year = rDate.getFullYear();
        var month = rDate.getMonth() + 1;
        if (month < 10) {
            month = "0" + month;
        }
        var date = rDate.getDate();
        if (date < 10) {
            date = "0" + date;
        }
        return (year + "-" + month + "-" + date);
    }
    if ($('.swiper-container-dlist').size()) {
        $('.swiper-container-dlist').find('.swiper-slide').height('auto');
        var swiper_dList = new Swiper('.swiper-container-dlist', {
            direction: 'vertical',
            slidesPerView: 'auto',
            mousewheelControl: true,
            freeMode: true,
            scrollbarHide: false,
        })
    }

    $(".beginDate,.endDate").on('change', function () {
        var gymId = $("#" + PAGE_ID + " .gym-select").attr('gym-id');
        var gymName = $("#" + PAGE_ID + " .gym-select").text();
        var beginDate = $("#" + PAGE_ID + " .beginDate").val();
        var endDate = $("#" + PAGE_ID + " .endDate").val();
        attend_ajax(gymId, gymName, CHILD_ID, beginDate, endDate);
    })

    //考勤明细
    function attend_ajax(idGym, nameGym, idChild, beginDate, endDate) {
        $.ajax({
            type: "GET",
            url: "/index/attend",
            data: {
                "idGym": idGym,
                "nameGym": nameGym,
                "idChild": idChild,
                "beginDate": beginDate,
                "endDate": endDate,
                "child_index": CHILD_INDEX
            },
            contentType: "application/x-www-form-urlencoded",
            dataType: "json",
            beforeSend: function () {
                $("#" + PAGE_ID + " .details_list").html('<p class="text-center  animated slideInDown "><i class="fa fa-circle-o-notch fa-2x fa-spin"></i></p>');
            },
            success: function (data) {
                var divGymClass = "";
                if (data != null && data.length > 0) {
                    $.each(data, function (index, content) {
                        divGymClass += "<li class='row no-gutter'>"
                        divGymClass += "<span class='col-20  date'>" + content.date + "</span>";
                        divGymClass += "<span class='col-20  time'>" + content.time + "</span>";
                        divGymClass += "<span class='col-20  class'>" + content.course + "</span>";
                        if (content.kq == "尚未开课") {
                            divGymClass += "<span class='col-20  state text-danger'>";
                        } else {
                            divGymClass += "<span class='col-20  state'>";
                        }
                        divGymClass += content.kq + "</span>";
                        divGymClass += "<a onclick='toTopic()'><span class='col-20 details'>课程亮点</span></a>";
                        divGymClass += "</li>";
                    });
                } else {
                    divGymClass = '<p class="text-center">没有查询到课程</p>';
                }
                $("#" + PAGE_ID + " .details_list").html(divGymClass);
            },
        });
    }

    //    gyms绑定到actions上
    $('.gym-select').on('click', function () {
        var selectedGymId = $("#" + PAGE_ID + " .gym-select").attr("gym-id");
        var buttons1 = [
            {
                text: '请选择中心',
                label: true
            }
        ];
        var buttons2 = [
            {
                text: '取消',
                bg: 'danger'
            }
        ];
        var gymId = "";
        var gymName = "";

        <c:forEach items="${sessionScope.listGym}" var="mygym">
        gymName = "${mygym['gymName']}";
        gymId = "${mygym['gymId']}";
        var button_json = {
            text: gymName,
            disabled: selectedGymId == gymId,
            id: gymId,
            onClick: function () {
                if (!this.disabled) {
                    gym_change(this.text, this.id);
                }
            }
        };

        buttons1.push(button_json);
        </c:forEach>
        var groups = [buttons1, buttons2];
        $.actions(groups);
    });



    function gym_change(gymName, gymId) {
        $("#" + PAGE_ID + " .gym-select").text(gymName);
        $("#" + PAGE_ID + " .gym-select").attr("gym-id", gymId);
        attend_ajax(gymId, gymName, CHILD_ID, $("#" + PAGE_ID + " .beginDate").val(), $("#" + PAGE_ID + " .endDate").val());
    }

    function toTopic() {
        $.alert("敬请期待...");
        return;
    }

    function shareLink(){
        var link =location.href + '/share';
        var mins = $('#'+PAGE_ID + ' .mins').text();
        var outpass = $('#'+PAGE_ID + ' .outpass').text();
        var tian = $('#'+PAGE_ID + ' .tian').text();
        var ranking = $('#'+PAGE_ID + ' .ranking').text();
        var name = encodeURI($('#'+PAGE_ID).attr("child-name"));
        var avatar = $('#'+PAGE_ID + ' .header-img img').attr("src");
        var times_per_weenk = $('#'+PAGE_ID + ' .times_per_week').text();
        var params = link + '?mins=' + mins + '&outpass=' + outpass + '&times_per_week=' + times_per_weenk + '&tian=' + tian + '&ranking=' + ranking + '&name=' + name + '&avatar=' + avatar;
        return params;
    }
    $.init();
</script>
</body>

</html>