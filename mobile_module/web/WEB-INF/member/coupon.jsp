<%--
  Created by IntelliJ IDEA.
  User: 汁
  Date: 2017/4/5
  Time: 20:16
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
    <title>我的优惠</title>
    <link rel="stylesheet" href="/css/sm.min.css">
    <link rel="stylesheet" href="/css/gym.css">
    <link href="https://cdn.bootcss.com/font-awesome/4.7.0/css/font-awesome.css" rel="stylesheet">
</head>

<body>
<div class="page-group">
    <div class="page" id="page_coupon">
        <header class="bar bar-nav">
            <a class="icon icon-left pull-left back"></a>
            <h1 class="title">我的优惠</h1>
        </header>
        <div class="content">
            <div class="buttons-tab">
                <a href="#coupon_1" class="tab-link button">优惠券</a>
                <a href="#coupon_2" class="tab-link active button">兑换券</a>
            </div>
            <div class="content-block">
                <div class="tabs">
                    <div id="coupon_1" class="tab">
                        <!-- 我的优惠券 -->
                        <div class="card">
                            <div class="card-header no-border no-padding ">
                                <c:choose>
                                    <c:when test="${not empty coupon && coupon.success == true}">
                                        <div class="coupon-box">
                                            <c:choose>
                                                <c:when test="${coupon['value']['used']==false}">
                                                    <a href="javascript:;" class="coupon" data-value="1"
                                                       data-type="${coupon['value']['type']}"> <img
                                                            src="/images/member/coupon_unused.png">
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="javascript:;" class="coupon" data-value="0"><img
                                                            src="/images/member/coupon_used.png"> </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </c:when>

                                    <c:otherwise>
                                        <div class="coupon-box">
                                            <div class="no-coupon text-center">
                                                <img src="/images/member/no_coupon.png"/>
                                                <p>您目前没有优惠券可用</p>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <c:if test="${not empty coupon && coupon.success == true}">
                            <div class="card-footer">
                                <i></i>
                                <div> <span
                                        class="fa fa-question-circle coupon-rule open-popup" data-value="1"
                                        data-popup=".popup-coupon-rule">&nbsp;优惠券说明</span></div>
                            </div>
                            </c:if>
                        </div>
                    </div>
                    <div id="coupon_2" class="tab  active">
                        <!-- 我的兑换券 -->
                        <div class="card">
                            <div class="card-header no-border no-padding ">
                                <c:choose>
                                    <c:when test="${not empty coupon2 }">
                                        <div class="coupon-box">
                                            <c:choose>
                                                <c:when test="${coupon2['value']['used']==false}">
                                                    <a href="javascript:;" class="coupon" data-value="1"
                                                       data-type="${coupon2['value']['type']}"><img
                                                            src="/images/member/coupon_2_unused.jpg">
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="javascript:;" class="coupon" data-value="0"><img
                                                            src="/images/member/coupon_2_used.jpg"> </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="coupon-box">
                                            <div class="no-coupon text-center">
                                                <img src="/images/member/no_coupon.png"/>
                                                <p>您目前没有兑换券可用</p>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <c:if test="${not empty coupon2 }">
                                <div class="card-footer">
                                    <i></i>
                                    <div> <span
                                            class="fa fa-question-circle coupon-rule open-popup" data-value="2"
                                            data-popup=".popup-coupon2-rule">&nbsp;兑换券说明</span></div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%--<div class="popup popup-coupon-rule">--%>

<%--<div class="content">--%>
<%--<h1 class="title">活动规则</h1>--%>
<%--<div class="content-block">--%>
<%--<p>1、获得优惠券之日起，有限期为一年，用于会员本人续报课程</p>--%>
<%--<p>2、此券不与其他优惠共享</p>--%>
<%--<p>3、不支持兑换现金</p>--%>
<%--<p><a href="javascript:;" class="close-popup">关闭</a></p>--%>
<%--</div>--%>
<%--</div>--%>
<%--</div>--%>

<script type='text/javascript' src='/js/zepto.min.js' charset='utf-8'></script>
<script type='text/javascript' src='/js/sm.min.js' charset='utf-8'></script>
<script>
    $(".coupon").on('click', function () {
        if ($(this).data("value") == "0") {
            return;
        }
        var type = $(this).data("type");
        if (type == "2" && !timeLimit("2017-09-23","2017-10-17")){
            $.alert("不在兑换日期内，详情参考兑换券说明");
            return;
        }
        $.prompt('请输入核销码', function (value) {
                    if ($.trim(value) == "") {
                        $.alert("核销码值不能为空");
                        return;
                    }
                    ajax_useCoupon(value, type);
                }
        );
    })

    function ajax_useCoupon(code, type) {
        this.code = code;
        this.type = type;

        $.ajax({
            url: '/coupon/use',
            type: 'POST',
            data: {'code': this.code, 'type': this.type},
//            async: false,
            contentType: "application/x-www-form-urlencoded",
            dataType: "json",
            beforeSend: function () {
                $.showIndicator();
            },
            success: function (data) {
                if (data.success == true) {
                    $.toast("使用成功");
                    setTimeout(function () {
                                location.reload();
                            },
                            2000);
                } else if (data.success == false) {
                    $.alert("使用失败," + data.message);
                }
            },
            complete: function () {
                $.hideIndicator();
            },
            error: function (data) {
                $.alert("异常错误,稍后再试");
            }
        });
    }

    $(".coupon-rule").on('click', function () {
        var type = $(this).data("value");
        var alertText = "";
        if (type == 1) {
            alertText = '<div class="content-block"><p class="coupon-rule-detail">1、获得优惠券之日起，有限期为一年，用于会员本人续报课程</p>' +
                    '<p class="coupon-rule-detail">2、此券不与其他优惠共享</p><p class="coupon-rule-detail">3、不支持兑换现金</p> </div>';
        } else {
            alertText = '<div class="content-block"><p class="coupon-rule-detail">1、此券使用时间：2017.9.23-10.17</p>' +
                    '<p class="coupon-rule-detail">2、请向中心工作人员领取“核销码”</p><p class="coupon-rule-detail">3、此券不与其他优惠共享</p><p class="coupon-rule-detail">4、不支持兑换现金</p><p class="coupon-rule-detail">5、此券领取截止时间：2017.9.10</p></div>';
        }
        $.modal({
            title: '<h1 class="title">活动规则</h1>',
            text: alertText,
            buttons: [
                {
                    text: '我知道了',
                }
            ]
        })
    });

    //兑换券活动领取时间
    function timeLimit(begin,end){
        var today = new Date();
        var beginDate = new Date(begin.replace(/-/g,"\/"));
        var endDate = new Date(end.replace(/-/g,"\/"));
        if (today < beginDate || today > endDate){
            return false;
        }
        return true;
    }
    $.init();
</script>
</body>

</html>