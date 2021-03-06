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
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>宝宝信息</title>
    <link rel="stylesheet" href="/css/sm.min.css">
    <link rel="stylesheet" href="/css/gym.css">
    <link href="https://cdn.bootcss.com/font-awesome/4.7.0/css/font-awesome.css" rel="stylesheet">
    <style>
        /* 阿里巴巴 矢量图引用*/
        @font-face {
            font-family: 'iconfont';  /* project id 260152 */
            src: url('//at.alicdn.com/t/font_onv8iq82tziod2t9.eot');
            src: url('//at.alicdn.com/t/font_onv8iq82tziod2t9.eot?#iefix') format('embedded-opentype'),
            url('//at.alicdn.com/t/font_onv8iq82tziod2t9.woff') format('woff'),
            url('//at.alicdn.com/t/font_onv8iq82tziod2t9.ttf') format('truetype'),
            url('//at.alicdn.com/t/font_onv8iq82tziod2t9.svg#iconfont') format('svg');
        }
        .iconfont{
            font-family:"iconfont" !important;
            font-size:1.5rem;font-style:normal;
            line-height: 1.5rem;
            -webkit-font-smoothing: antialiased;
            -webkit-text-stroke-width: 0.2px;
            -moz-osx-font-smoothing: grayscale;}
        .iconfont:active{
            color:#000099;
            -webkit-transition-duration: 0ms;
            transition-duration: 0ms;
            opacity: 0.6;
            }

    </style>
</head>

<body>
<div class="page-group">
    <div class="page page-current" id="page_myinfo">
        <div class="content">
            <div class="card">
                <div class="card-header no-padding no-border gym-myinfo">
                    <a href="/index" class="gym-banner-left external"><i class="fa fa-angle-double-left fa-3x"></i></a>
                    <div class="gym-banner-title">我的信息</div>
                    <i></i>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <div class="facebook-avatar">
                        <a class="open-avatar" data-popup="popup popup-avatar">
                            <img id="avatar" src="${fn:toLowerCase(sessionScope.user.head_src)}"
                                 onerror="this.src='/images/member/head.png'"/>
                        </a>
                        <div class="gym-myinfo-info">
                            <p class="avatar-name">${childObj['name']}</p>
                            <p class="avatar-detail">年龄：${childObj['age']}</p>
                        </div>
                    </div>
                    <a href="/exit" class="button">退出登录</a>
                </div>

                <div class="card-content">
                    <div class="card-content-inner" id="contract" data-value="0">
                        <div class="row">
                            <div class="col-33 ">
                                <div class="list-icon"><a class="external" href="/coupon"><i class="iconfont">&#xe665;</i>
                                    <div class="list-icon-title">我的优惠</div>
                                </a>
                                </div>

                            </div>
                            <div class="col-33 ">
                                <div class="list-icon"><a id="view" href="javascript:;"><i class="iconfont">&#xe60a;</i>
                                    <div class="list-icon-title">我的所有合同</div>
                                </a></div>

                            </div>
                            <div class="col-33 ">
                                <div class="list-icon"><a class="external activity" > <i class="iconfont">&#xe6c5;</i>
                                    <div class="list-icon-title">活动中心</div>
                                </a></div>

                            </div>
                        </div>
                        <c:choose>
                            <c:when test="${not empty listContract}">
                                <div class="row row-box-9 f">
                                    <div class="col-33">
                                        <label  id="c_regDate">${listContract[0]['报名日期']}</label>
                                        <div>报名日期</div>
                                    </div>
                                    <div class="col-33 c">
                                        <label id="c_validity">${listContract[0]['有效期']}</label>
                                        <div>有效期</div>
                                    </div>
                                    <div class="col-33">
                                        <label id="c_give">
                                            <c:choose>
                                                <c:when test="${listContract[0]['赠课'] == ''}">无</c:when>
                                                <c:otherwise>
                                                    ${listContract[0]['赠课']}
                                                </c:otherwise>
                                            </c:choose>
                                        </label>
                                        <div>赠课</div>
                                    </div>
                                </div>
                                <div class="row row-box-9">
                                    <div class="col-33">
                                        <label id="c_regPeriods">${listContract[0]['报名课时数']}节 </label>
                                        <div >报名课时数</div>
                                    </div>
                                    <div class="col-33 c">
                                        <label id="c_residuePeriods">${listContract[0]['剩余课时数']}节</label>
                                        <div>剩余课时数</div>
                                    </div>
                                    <div class="col-33">
                                        <label id="c_score">${listContract[0]['积分']}</label>
                                        <div >积分</div>
                                    </div>
                                </div>
                                <%--<div class="row row-box-9">--%>
                                    <%--<div class="col-33">--%>
                                        <%--<label id="c_actKss">${listContract[0]['活动扣课数']}节 </label>--%>
                                        <%--<div >活动扣课数</div>--%>
                                    <%--</div>--%>
                                    <%--<div class="col-33 c">--%>
                                        <%--<label id="c_totalLeave">${listContract[0]['累计请假数']}节</label>--%>
                                        <%--<div>累计请假数</div>--%>
                                    <%--</div>--%>
                                    <%--<div class="col-33">--%>
                                        <%--<label id="c_class">${listContract[0]['课程']}</label>--%>
                                        <%--<div >课程</div>--%>
                                    <%--</div>--%>
                                <%--</div>--%>
                                <div class="list-block gym-list">
                                    <ul>
                                        <!-- 反馈 -->
                                        <li class="item-content  open-popup" data-popup=".popup-feedback">
                                            <div class="item-media">
                                                <i class="fa fa-meh-o fa-2x" aria-hidden="true"></i>
                                            </div>
                                            <div class="item-inner">
                                                <div class="item-title">数据有问题？点击此处向我们反馈</div>
                                                <div class="item-after"><i
                                                        class="fa fa-angle-double-right fa-2x"
                                                        aria-hidden="true"></i></div>
                                            </div>
                                        </li>
                                    </ul>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <p class="color-danger text-center">没有找到有效期内的合同~</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <div class="card activity">
                <div class="card-header no-border no-padding gym-month-activity">
                    <i></i>
                    <div class="gym-banner-title">
                        <small>中心本月活动</small>
                    </div>
                    <i></i>
                </div>
            </div>
        </div>

    </div>
    <div class="page" id="page_contract">
        <div class="content">
            <div class="list-block media-list">
                <ul>
                    <c:choose>
                        <c:when test="${not empty listContract}">
                            <c:forEach items="${listContract}" var="contract">
                                <li>
                                    <a href="#" class="item-link item-content">
                                        <div class="item-media"><img
                                                src="http://gqianniu.alicdn.com/bao/uploaded/i4//tfscom/i3/TB10LfcHFXXXXXKXpXXXXXXXXXX_!!0-item_pic.jpg_250x250q60.jpg"
                                                style='width: 4rem;'></div>
                                        <div class="item-inner">
                                            <div class="item-title-row">
                                                <div class="item-title">${listContract[0]['报名日期']}</div>
                                            </div>
                                            <div class="item-subtitle">标题</div>
                                            <div class="item-text">此处是文本内容...</div>
                                        </div>
                                    </a>
                                </li>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p class="color-danger text-center">没有找到有效期内的合同~</p>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </div>
</div>

<!-- Avatar Popup -->
<div class="popup popup-avatar">
    <form id="uploadForm" enctype="multipart/form-data">
        <div class="card facebook-card no-border">
            <div class="card-content">
                <img src="${sessionScope.user.head_src}" id="pre_avatar" class="pre-avatar">
            </div>
        </div>
        <div class="content-block">
            <p><a href="javascript:;" class="button  button-big file"><input type="file" name="file" id="avatarFile"
                                                                             accept="image/jpg,image/png,image/jpeg">更换头像</a>
            </p>
            <p><a href="javascript:;" class="button  button-big" id="updateAvatar">确定</a></p>
            <p><a href="javascript:;" class="button  button-danger button-big close-popup" id="cancelUpdate">取消</a></p>
        </div>
    </form>
</div>


<div class="popup popup-feedback">
    <header class="bar bar-nav">

        <h1 class="title">提交反馈</h1>
    </header>
    <div class="content">
        <div class="list-block">
            <ul>
                <!-- Text inputs -->
                <li>
                    <div class="item-content">
                        <div class="item-inner">
                            <div class="item-title label">姓名</div>
                            <div class="item-input">
                                <input type="text" id="feedback_name">
                            </div>
                        </div>
                    </div>
                </li>
                <li>
                    <div class="item-content">
                        <div class="item-inner">
                            <div class="item-title label">中心</div>
                            <div class="item-input">
                                <input type="text" id="feedback_fs" value="${listGymSelectedSession[0].gym['gymName']}">
                            </div>
                        </div>
                    </div>
                </li>
                <li>
                    <div class="item-content">
                        <div class="item-inner">
                            <div class="item-title label">手机</div>
                            <div class="item-input">
                                <input type="text" id="feedback_tel" placeholder="手机" value="${sessionScope.user.tel}">
                            </div>
                        </div>
                    </div>
                </li>
                <li>
                    <div class="item-content">
                        <div class="item-inner">
                            <div class="item-title label">类型</div>
                            <div class="item-input">
                                <select id="feedback_type">
                                    <option value="剩余课时数">剩余课时数</option>
                                    <option value="报名课时数">报名课时数</option>
                                    <%--<option value="活动扣课数">活动扣课数</option>--%>
                                </select>
                            </div>
                        </div>
                    </div>
                </li>

                <li class="align-top">
                    <div class="item-content">
                        <div class="item-inner">
                            <div class="item-title label">问题详情</div>
                            <div class="item-input">
                                <textarea id="feedback_details"></textarea>
                            </div>
                        </div>
                    </div>
                </li>
            </ul>
        </div>
        <div class="content-block">
            <div class="row">
                <div class="col-50"><a href="javascript:;"
                                       class="button button-big button-fill button-danger close-popup">取消</a>
                </div>
                <div class="col-50"><a href="javascript:;" id="feedback_sub"
                                       class="button button-big button-fill button-success">提交</a>
                </div>
            </div>
        </div>
    </div>

</div>

<script type='text/javascript' src='/js/zepto.min.js' charset='utf-8'></script>
<script type='text/javascript' src='/js/sm.min.js' charset='utf-8'></script>

<script>
    $("#feedback_sub").on('click', function () {
        var feedbackName = $('#feedback_name').val();
        var feedFs = $('#feedback_fs').val();
        var feedTel = $('#feedback_tel').val();
        var feedDetails = $('#feedback_details').val();
        var type = $('#feedback_type').val();
        ajax_feedback(feedFs, feedbackName, feedDetails, feedTel, type);
    })

    $(document).on('open', '.popup-feedback', function () {
        $('#feedback_details').val("");
    });


    $(".open-avatar").on('click', function () {
        $.popup('.popup-avatar');
    });
    $(".activity").on('click', function () {
        $.alert("敬请期待...");
        return;
    });

    $("#cancelUpdate").on('click', function () {
        $("#pre_avatar").attr("src", $("#avatar").attr("src"));
        $("#avatarFile").val("");
    })
    $("#updateAvatar").on('click', function () {
        upload_ajax();
    })
    $("#avatarFile").on('change', function () {
        var objUrl = getObjectURL($("#avatarFile")[0].files[0]);
        if (objUrl) {
            $("#pre_avatar").attr("src", objUrl);
        }
    });

    function upload_ajax() {
        var uploadFile = $("#avatarFile");
        if (uploadFile.val() == "") {
            $.closeModal(".popup-avatar");
            return false;
        }
        var fileExtension = uploadFile.val().substring(uploadFile.val().lastIndexOf("."), uploadFile.val().length);
        var extensions = ".jpg,.JPG,.jpeg,.JPEG,.png,.PNG";
        if (extensions.indexOf(fileExtension) < 0) {
            $.alert("请选择正确的图片格式!");
            return false;
        }
        var formData = new FormData();
        formData.append('file', uploadFile[0].files[0]);
        var imageSize = uploadFile[0].files[0].size;

        if (imageSize > 1024 * 1024 * 3) {
            $.alert("图片大于3M,请重新选择！")
            return;
        }
        $.ajax({
            url: '/index/upload',
            type: 'POST',
            data: formData,
            async: false,
//            cache: false,
            contentType: false,
            processData: false,
            beforeSend: function () {
                $.showIndicator();
            },
            success: function (data) {
                if (data.success == true) {
                    $.toast("上传成功");
                    location.reload();
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

    //获得文件的网络路径
    function getObjectURL(file) {
        var url = null;
        if (window.createObjectURL != undefined) { // basic
            url = window.createObjectURL(file);
        } else if (window.URL != undefined) { // mozilla(firefox)
            url = window.URL.createObjectURL(file);
        } else if (window.webkitURL != undefined) { // webkit or chrome
            url = window.webkitURL.createObjectURL(file);
        }
        return url;
    }

    //全局
    var jsonArrayContract = '';
    <c:if test="${not empty listContract}">
    jsonArrayContract = ${listContract};
    </c:if>

    $('#view').on('click', function () {
        var selectedContractId = $("#contract").attr("data-value");
        var buttons1 = [
            {
                text: '请选择合同',
                label: true
            }
        ];
        var buttons2 = [
            {
                text: '取消',
                bg: 'danger'
            }
        ];
        var contractName = "";
        var contractIndex = "";

        $.each(jsonArrayContract, function (index, contract) {
            contractName = contract['报名日期'] + '报名合同';
            contractIndex = index;
            var button_json = {
                text: contractName,
                id: contractIndex,
                disabled: selectedContractId == contractIndex,
                onClick: function () {
                    if (!this.disabled) {
                        contract_change(this.id);
                    }
                }
            };
            buttons1.push(button_json);
        })
        var groups = [buttons1, buttons2];
        $.actions(groups);
    });
    function contract_change(index) {
        $("#contract").attr('data-value', index);
        $("#c_regDate").text(jsonArrayContract[index]['报名日期']);
        $("#c_validity").text(jsonArrayContract[index]['有效期']);
        $("#c_residuePeriods").text(jsonArrayContract[index]['剩余课时数']);
        $("#c_regPeriods").text(jsonArrayContract[index]['报名课时数']);
        $("#c_totalLeave").text(jsonArrayContract[index]['累计请假数']);
        $("#c_regSum").text(jsonArrayContract[index]['合同金额']);
        $("#c_class").text(jsonArrayContract[index]['课程']);
        $("#c_actKss").text(jsonArrayContract[index]['活动扣课数']);
        $("#c_give").text(jsonArrayContract[index]['赠课']);
        $("#c_score").text(jsonArrayContract[index]['积分']);
    }



    function ajax_feedback(Franchisee, feedbackName, details, contactTel, type) {
        $.ajax({
            type: "POST",
            url: "/login/feedback",
            data: {
                "Franchisee": Franchisee,
                "name": feedbackName,
                "details": details,
                "contactTel": contactTel,
                "type": type
            },
            contentType: "application/x-www-form-urlencoded",
            dataType: "json",
            success: function (data) {
                $.toast('已提交，谢谢你的反馈');
                $.closeModal('.popup-feedback');
            }
        })
    }
    $.init();
</script>
</body>

</html>