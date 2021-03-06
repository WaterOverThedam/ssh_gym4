package com.thelittlegym.mobile.user.controller;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.sun.org.apache.xpath.internal.operations.Bool;
import com.thelittlegym.mobile.common.OasisService;
import com.thelittlegym.mobile.common.WeixinService;
import com.thelittlegym.mobile.entity.*;
import com.thelittlegym.mobile.service.IPointsService;
import com.thelittlegym.mobile.service.impl.CouponService;
import com.thelittlegym.mobile.user.model.User;
import com.thelittlegym.mobile.user.service.IUserService;
import com.thelittlegym.mobile.utils.test.InTesting;
import net.coobird.thumbnailator.Thumbnails;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.net.SocketException;
import java.text.SimpleDateFormat;
import java.util.*;

import static com.alibaba.fastjson.JSON.parseObject;

/**
 * Created by 汁 on 2017/3/25.
 */
@Controller
@RequestMapping("/index")
public class UserCtrl {
    @Autowired
    private IUserService userService;
    @Autowired
    private OasisService oasisService;
    @Autowired
    private WeixinService weixinService;
    @Autowired
    private CouponService couponService;
    @Autowired
    private IPointsService pointsService;

    @RequestMapping(value = "", method = RequestMethod.GET)
    public String index(HttpServletRequest request, Model model) throws Exception {
        HttpSession session = request.getSession();
        InTesting it = new InTesting();
        boolean ittest = it.isTrue(request);
        Object objSession = session.getAttribute("user");
        Object adminSession = session.getAttribute("admin");
        User user;

        if(!ittest && null == adminSession) {
            String linkId = request.getParameter("linkId");
            if (null != linkId && "1225".equals(linkId)) {
                session.setAttribute("hide", System.currentTimeMillis() / 1000);
                return "redirect:/index";
            }
            Object hideSession = session.getAttribute("hide");
            if (null == hideSession) {
                return "redirect:/noaccess.html";
            }
        }

        if (objSession == null) {
            return "redirect:/login.html";
        } else {
            user = (User) objSession;
        }
        Object listGymSelectedSession = session.getAttribute("listGymSelectedSession");
        List<Gym> listGym = new ArrayList<Gym>();
        List<Child> listChild = new ArrayList<Child>();
        List<Rank> listRank = new ArrayList<Rank>();
        Map<String, String> weixinMap = new HashMap<String, String>();

        //存储两个不同孩子的list的list
        List listGymClassAll = new ArrayList<ArrayList<GymClass>>();
        List<GymSelected> listGymSelected = new ArrayList<GymSelected>();

        if(!ittest){
            weixinMap = weixinService.getSignature(request.getRequestURL().toString());
        }

        Integer idFamily = user.getIdFamily();

        //孩子
        String   sqlUser = "declare @rest float=0,@dtend varchar(10)='';select @rest =sum(kss),@dtend =convert(varchar(10),max(dtend),120) from(select top 6 crmzdy_81739422 kss,ht.crmzdy_81733324 dtend from crm_zdytable_238592_25111_238592_view zx join crm_zdytable_238592_25115_238592_view bmksb on zx.crmzdy_81611091_id= " + idFamily +" and bmksb.crmzdy_81756836_id=zx.id " +
                " and bmksb.crmzdy_81733119='销售'  and bmksb.crmzdy_81739422/*rest*/>0 join crm_zdytable_238592_23796_238592_view ht on ht.id " +
                " =bmksb.crmzdy_81486464_id and datediff(d,getdate(),crmzdy_81733324/*dtDaoQi*/)>=0 order by bmksb.id " +
                "  desc)bmksb;select hz.id  idhz,hz.crm_name name,hz.crmzdy_81497217 age,replace(isnull(hz.crmzdy_82017585,''),'''','\\\"')ranking,isnull(@rest,0) rest,isnull(@dtend,'无')  dtend from crm_zdytable_238592_23893_238592_view hz where crmzdy_80653840_id=" + idFamily;
        sqlUser = "declare @rest float=0,@dtend varchar(10)='';select @rest =sum(kss),@dtend =convert(varchar(10),max(dtend),120) from(select top 6 case when ht.crmzdy_81733324<getdate() then 0 else bmksb.crmzdy_81739422 end kss,ht.crmzdy_81733324 dtend from crm_zdytable_238592_25111_238592_view zx join crm_zdytable_238592_25115_238592_view" +
                " bmksb on zx.crmzdy_81611091_id= "+idFamily+" and bmksb.crmzdy_81756836_id=zx.id  and bmksb.crmzdy_81733119='销售'  and bmksb.crmzdy_81739422/*rest*/>0 join crm_zdytable_238592_23796_238592_view" +
                " ht on ht.id  =bmksb.crmzdy_81486464_id and datediff(d,getdate(),crmzdy_81733324/*dtDaoQi*/)>=0 order by bmksb.id  desc)bmksb;select hz.id  idhz,hz.crm_name name,hz.crmzdy_81497217 age,replace(isnull(hz.crmzdy_82017585,''),'''','\\\"')ranking,isnull(@rest,0) rest,isnull(@dtend,'无') dtend from crm_zdytable_238592_23893_238592_view hz where crmzdy_80653840_id=" + idFamily;
        try {
            JSONArray childArray = oasisService.getResultJson(sqlUser);

            if (childArray != null) {
                for (Object childItem : childArray) {
                    List<GymClass> listGymClass = new ArrayList<GymClass>();

                    JSONObject childObj = JSONObject.parseObject(childItem.toString());
                    JSONObject rankAllObj = rankUtil(childObj.getString("ranking"), "all");
                    JSONObject rankLast3Obj = rankUtil(childObj.getString("ranking"), "last3");
                    Child child = JSONObject.parseObject(childItem.toString(), Child.class);
                    Rank rank = null;
                    if (rankAllObj != null && rankLast3Obj != null) {
                        rank = JSONObject.parseObject(rankAllObj.toString(), Rank.class);
                        //outpass为3月，其他为全部
                        rank.setOutpass(rankLast3Obj.getString("outpass"));
                    }

                    Gym gym = new Gym();
                    GymSelected gymSelected = new GymSelected();

                    String beginDate;
                    String endDate;
                    String gymId;
                    String gymName;
                    String idChild = child.getIdhz();
                    //孩子考勤
                    if (listGymSelectedSession != null) {
                        listGymSelected = (List<GymSelected>) listGymSelectedSession;
                        if (listGymSelected.size() > 0) {
                            gymSelected = listGymSelected.get(0);
                            beginDate = gymSelected.getBeginDate();
                            endDate = gymSelected.getEndDate();
                            gymId = gymSelected.getGym().getGymId();
                            gymName = gymSelected.getGym().getGymName();
                        } else {
                            return "redirect:/timeout.html";
                        }
                    } else {
                        beginDate = getInitDate().get(0);
                        endDate = getInitDate().get(1);
                        String sqlGym = "select crmzdy_81620171 gymName,crmzdy_81620171_id gymId from crm_zdytable_238592_25111_238592_view where crmzdy_81611091_id =" + idFamily;

                        if (null == session.getAttribute("listGym")) {
                            JSONArray gymArray = oasisService.getResultJson(sqlGym);
                            listGym = JSONObject.parseArray(gymArray.toString(), Gym.class);
                            gymId = gymArray.getJSONObject(0).getString("gymId");
                            gymName = gymArray.getJSONObject(0).getString("gymName");
                            gymSelected.setBeginDate(beginDate);
                            gymSelected.setEndDate(endDate);
                            gym.setGymId(gymId);
                            gym.setGymName(gymName);
                            gymSelected.setGym(gym);
                            //内循限制只查询一次
                            session.setAttribute("listGym", listGym);
                        } else {
                            listGym = (List<Gym>) session.getAttribute("listGym");
                            gymId = listGym.get(0).getGymId();
                            gymName = listGym.get(0).getGymName();
                            gymSelected.setBeginDate(beginDate);
                            gymSelected.setEndDate(endDate);
                            gym.setGymId(gymId);
                            gym.setGymName(gymName);
                            gymSelected.setGym(gym);
                        }
                    }

                    String sqlClass = "select bj.crmzdy_80620202_id idgym,rq.crm_name date,bj.crmzdy_80612384 time,bj.crmzdy_80612382 course,case when kq='未考勤' then '尚未开课' else kq  end kq from(select crmzdy_81486481 kq,crmzdy_81486480_id idrq from " +
                            "crm_zdytable_238592_25118_238592_view bmks where bmks.crmzdy_81618215_id=" + idChild + "/*idhz*/ and bmks.crmzdy_81636525>='" + beginDate + "'/*dtbegin*/ and bmks.crmzdy_81636525<='" + endDate + "'/*dtend*/ and crmzdy_81619234='已报名' union all select crmzdy_80652349,crmzdy_80652340_id from crm_zdytable_238592_23696_238592_view bk where crmzdy_80658051_id=3519 and bk.crmzdy_81761865>='" + beginDate + "'/*dtbegin*/ and bk.crmzdy_81761865<='" + endDate + "'/*dtend*/)ks join crm_zdytable_238592_23870_238592_view rq on ks.idrq=rq.id join crm_zdytable_238592_23583_238592_view bj on rq.crmzdy_80650267_id=bj.id and bj.crmzdy_80620202_id=" + gymId + "/*idgym*/order by date desc";

                    JSONArray classArray = oasisService.getResultJson(sqlClass);

                    if (classArray != null) {
                        listGymClass = JSONObject.parseArray(classArray.toString(), GymClass.class);
                    }
                    listChild.add(child);
                    listRank.add(rank);
                    listGymSelected.add(gymSelected);
                    listGymClassAll.add(listGymClass);
                }
            }
        } catch (SocketException e) {
            return "redirect:/timeout.html";
        }

        Boolean in3000 = userService.isNum(user.getTel(),3000);
        session.setAttribute("listGymSelectedSession", listGymSelected);
        model.addAttribute("listRank", listRank);
        model.addAttribute("listChild", listChild);
        model.addAttribute("listGymClassAll", listGymClassAll);
        model.addAttribute("weixinMap", weixinMap);
        model.addAttribute("in3000", in3000);
        return "/member/index";
    }

    @RequestMapping(value = "/topic", method = RequestMethod.GET)
    public String details(HttpServletRequest request) throws Exception {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user != null) {
            return "/member/topic";
        } else {
            return "redirect:/login.html";
        }
    }

    @RequestMapping(value = "/share", method = RequestMethod.GET)
    public String share(HttpServletRequest request, Model model) throws Exception {
        Map<String, String> returnMap = new HashMap<String, String>();
        String tian = request.getParameter("tian");
        String mins = request.getParameter("mins");
        String ranking = request.getParameter("ranking");
        String outpass = request.getParameter("outpass");
        String times_per_week = request.getParameter("times_per_week");
        String name = request.getParameter("name");
        String avatar = request.getParameter("avatar");

        returnMap.put("tian", tian);
        returnMap.put("mins", mins);
        returnMap.put("ranking", ranking);
        returnMap.put("outpass", outpass);
        returnMap.put("times_per_week", times_per_week);
        returnMap.put("name", name);
        returnMap.put("avatar", avatar);
//        for (Map.Entry entry : returnMap.entrySet()) {
//            System.out.println(entry.getKey() + ", " + entry.getValue());
//        }
        model.addAttribute("shareMap", returnMap);
        return "/member/share";
    }


    @RequestMapping(value = "/myinfo", method = RequestMethod.GET)
    public String myinfo(HttpServletRequest request, String idhz, String name, String age, Model model) throws Exception {
        HttpSession session = request.getSession();
        Object objSession = session.getAttribute("user");
        User user;
        if (objSession != null) {
            user = (User) objSession;
        } else {
            return "redirect:/login.html";
        }
        //我的信息
        Integer idFamily = user.getIdFamily();
        String tel = user.getTel();
        String sqlMyInfo = " select top 6 convert(varchar(10),ht.crmzdy_80646021,111) 报名日期,ht.crmzdy_80646031  报名课时数,ht.crmzdy_81636090 合同金额,convert(varchar(10),crmzdy_81733324,111)   有效期,bmksb.crmzdy_81739422 剩余课时数,bmksb.crmzdy_81768505 活动扣课数,bmksb.crmzdy_81739425 累计请假数,isnull(bjap.kc,'暂未排课') 课程,ht.crmzdy_81733120 赠课,zx.crmzdy_81802626 积分 from crm_zdytable_238592_25111_238592_view zx join crm_zdytable_238592_25115_238592_view bmksb on zx.crmzdy_81611091_id= " + idFamily + " and bmksb.crmzdy_81756836_id=zx.id join crm_zdytable_238592_23796_238592_view ht on ht.id =bmksb.crmzdy_81486464_id  outer apply(select top 1 bj.crmzdy_80612382 kc from crm_zdytable_238592_25117_238592_view bjap join crm_zdytable_238592_23583_238592_view bj on bj.id =bjap.crmzdy_81486476_id where ht.id =bjap.crmzdy_81598938_id)bjap where bmksb.crmzdy_81733119='销售'  and bmksb.crmzdy_81739422/*rest*/>0 and datediff(d,getdate(),ht.crmzdy_81733324/*dtDaoQi*/)>=0";
        sqlMyInfo = " select top 6 convert(varchar(10),ht.crmzdy_80646021,111) 报名日期,ht.crmzdy_80646031  报名课时数,ht.crmzdy_81636090 合同金额,convert(varchar(10),crmzdy_81733324,111)有效期,case when ht.crmzdy_81733324<getdate() then 0 else bmksb.crmzdy_81739422 end 剩余课时数,bmksb.crmzdy_81768505 活动扣课数,bmksb.crmzdy_81739425 累计请假数,isnull(bjap.kc,'暂未排课') 课程,ht.crmzdy_81733120 赠课,zx.crmzdy_81802626 积分 from crm_zdytable_238592_25111_238592_view zx join crm_zdytable_238592_25115_238592_view bmksb on zx.crmzdy_81611091_id="+ idFamily+" and bmksb.crmzdy_81756836_id=zx.id  join crm_zdytable_238592_23796_238592_view" +
                " ht on ht.id  =bmksb.crmzdy_81486464_id  outer apply(select top 1 bj.crmzdy_80612382 kc from crm_zdytable_238592_25117_238592_view bjap join crm_zdytable_238592_23583_238592_view bj on bj.id  =bjap.crmzdy_81486476_id where ht.id  =bjap.crmzdy_81598938_id)bjap where bmksb.crmzdy_81733119='销售'  and bmksb.crmzdy_81739422/*rest*/>0 and datediff(d,getdate(),ht.crmzdy_81733324/*dtDaoQi*/)>=0";
        JSONArray contractArr = oasisService.getResultJson(sqlMyInfo);
//        Map<String, Object> couponMap = couponService.getCoupon_http(tel);
        //18751609081
        pointsService.updatePoints_http(tel);
        //孩子id查询信息
//        String sqlChild = "select  crm_name name,crmzdy_81497217 age from crm_zdytable_238592_23893_238592_view where id = " + idhz;
//        JSONObject childObj = oasisService.getObject(sqlChild,0);
        JSONObject childObj = new JSONObject();

        childObj.put("idhz", idhz);
        childObj.put("name", name);
        childObj.put("age", age);
        model.addAttribute("listContract", contractArr);
        model.addAttribute("childObj", childObj);

        return "/member/myinfo";
    }




    //考勤查询
    @RequestMapping(value = "/attend", method = RequestMethod.GET)
    @ResponseBody
    public JSONArray getAttend(HttpServletRequest request, String idGym, String nameGym, Integer idChild, String beginDate, String endDate, Integer child_index) {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        JSONObject jsonObject = new JSONObject();
        JSONArray classArray = new JSONArray();
        List<GymSelected> listGymSelected = new ArrayList<GymSelected>();
        if (user == null) {
            jsonObject.put("success", false);
            classArray.add(jsonObject);
            return classArray;
        }
        Object listGymSelectedSession = session.getAttribute("listGymSelectedSession");
        if (listGymSelectedSession != null) {
            listGymSelected = (List<GymSelected>) listGymSelectedSession;
            GymSelected gymSelected = new GymSelected();
            Gym gym = new Gym();
            gym.setGymId(idGym);
            gym.setGymName(nameGym);
            gymSelected.setGym(gym);
            gymSelected.setBeginDate(beginDate);
            gymSelected.setEndDate(endDate);
            listGymSelected.set(child_index, gymSelected);
        }
        String sqlClass = "select bj.crmzdy_80620202_id idgym,rq.crm_name date,bj.crmzdy_80612384 time,bj.crmzdy_80612382 course,case when kq='未考勤' then '尚未开课' else kq  end kq from(select crmzdy_81486481 kq,crmzdy_81486480_id idrq " +
                "from crm_zdytable_238592_25118_238592_view bmks where bmks.crmzdy_81618215_id=" + idChild + " /*idhz*/ and bmks.crmzdy_81636525>='" + beginDate + "'/*dtbegin*/ and bmks.crmzdy_81636525<='" + endDate + "'/*dtend*/ and crmzdy_81619234='已报名' union all select crmzdy_80652349,crmzdy_80652340_id from crm_zdytable_238592_23696_238592_view bk where crmzdy_80658051_id=" + idChild + "  and bk.crmzdy_81761865>='" + beginDate + "'/*dtbegin*/ and bk.crmzdy_81761865<='" + endDate + "'/*dtend*/)ks join crm_zdytable_238592_23870_238592_view rq on ks.idrq=rq.id join crm_zdytable_238592_23583_238592_view bj on rq.crmzdy_80650267_id=bj.id and bj.crmzdy_80620202_id=" + idGym + "/*idgym*/order by date desc";
        classArray = oasisService.getResultJson(sqlClass);
        session.setAttribute("listGymSelectedSession", listGymSelectedSession);

        return classArray;
    }

    //头像上传
    @RequestMapping(value = "/upload", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getAttend(HttpServletRequest request, MultipartFile file) {
        HashMap<String, Object> returnMap = new HashMap<String, Object>();
        HttpSession session = request.getSession();
        Object objSession = session.getAttribute("user");
        User user = null;
        if (objSession != null) {
            user = (User) objSession;
        } else {
            returnMap.put("success", false);
            returnMap.put("message", "请重新登录后再试");
            return returnMap;
        }
        String tel = user.getTel();
        try {
            // 获取图片原始文件名
            String originalFilename = file.getOriginalFilename();

            // 文件名使用当前时间
//            String name = new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date());
            String name = "avatar";
            // 获取上传图片的扩展名(jpg/png/...)
            String extension = FilenameUtils.getExtension(originalFilename);

            // 图片上传的相对路径（因为相对路径放到页面上就可以显示图片）
            String path = "/upload/avatar/" + tel + "/" + name + "." + extension.toUpperCase();
            String originalPath = "/upload/avatar/" + tel + "/" + name + "Original" + "." + extension;
            // 图片上传的绝对路径
            String url = request.getSession().getServletContext().getRealPath("") + path;
            String originalUrl = request.getSession().getServletContext().getRealPath("") + originalPath;
            String urlNoExtension = request.getSession().getServletContext().getRealPath("") + "/upload/avatar/" + tel + "/" + name;
            String urlHttp = "/upload/avatar/" + tel + "/" + name + "." + "JPG";
            File dir = new File(originalUrl);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            // 上传图片
            file.transferTo(new File(originalUrl));
            //压缩
            Thumbnails.of(originalUrl).size(200, 200).outputFormat("jpg").toFile(urlNoExtension);
            user.setHead_src(urlHttp);
            userService.updateUser(user);
            session.setAttribute("user", user);
            returnMap.put("success", true);
            returnMap.put("message", path);
        } catch (Exception e) {
            e.printStackTrace();
            returnMap.put("success", false);
            returnMap.put("message", "请重新登录后再试");
        }
        return returnMap;
    }

    /*
    ranking转化jsonobject
     */
    public JSONObject rankUtil(String ranking, String text) throws Exception {
        JSONObject returnObj = null;
        if (ranking != null && !ranking.equals("")) {
            JSONObject jsonObject = parseObject(ranking);
            JSONArray jsonArray = jsonObject.getJSONArray(text);
            returnObj = jsonArray.getJSONObject(0);
        }
        return returnObj;
    }

    //获得查询开始结束日期
    public static ArrayList<String> getInitDate() {
        ArrayList<String> list = new ArrayList<String>();
        Calendar cal = Calendar.getInstance();
        String beginDate = "";
        String endDate = "";
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        cal.setFirstDayOfWeek(Calendar.MONDAY);
        cal.add(Calendar.WEEK_OF_MONTH, -1);
        cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
        beginDate = sdf.format(cal.getTime());

        //下下周
        cal.add(Calendar.WEEK_OF_MONTH, 3);
        cal.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
        endDate = sdf.format(cal.getTime());
        list.add(beginDate);
        list.add(endDate);
        return list;
    }
}
