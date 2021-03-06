package com.thelittlegym.mobile.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.thelittlegym.mobile.base.model.Page;
import com.thelittlegym.mobile.dao.impl.ActivityDaoImpl;
import com.thelittlegym.mobile.dao.impl.ParticipatorImpl;
import com.thelittlegym.mobile.entity.Activity;
import com.thelittlegym.mobile.entity.Participator;
import com.thelittlegym.mobile.service.IParticipatorService;
import com.thelittlegym.mobile.user.model.User;
import com.thelittlegym.mobile.utils.msg.lib.MESSAGEXsend;
import com.thelittlegym.mobile.utils.msg.send.ValNum;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by hibernate on 2017/5/3.
 */
@Controller
@RequestMapping("/activity")
public class ActivityCtrl {

    @Autowired
    private ActivityDaoImpl activityDao;
    @Autowired
    private ParticipatorImpl participatorDao;
    @Autowired
    private IParticipatorService participatorService;

    @RequestMapping(value = "", method = RequestMethod.GET)
    public String activities(HttpServletRequest request, Model model) throws Exception {
        HttpSession session = request.getSession();
        Object objSession = session.getAttribute("user");
        User user;
        if (objSession != null) {

        } else {
            user = (User) objSession;
        }

        return "/activity/activities";
    }

    @RequestMapping(value = "/search", method = RequestMethod.POST)
    @ResponseBody
    public JSONArray search(HttpServletRequest request, Integer index, Integer size, String keyword) throws Exception {
        HttpSession session = request.getSession();
        Object objSession = session.getAttribute("user");
        User user;
        if (objSession != null) {

        } else {
            user = (User) objSession;
        }
        JSONArray jsonArray = getItems(request, index, size, keyword);
        return jsonArray;
    }



    @RequestMapping(value = "/myinfo", method = RequestMethod.GET)
    public String info(HttpServletRequest request) throws Exception {
        HttpSession session = request.getSession();
        Object objSession = session.getAttribute("user");
        User user;
        if (objSession != null) {

        } else {
            user = (User) objSession;
        }

        return "/activity/myinfo";
    }

    @RequestMapping(value = "/getItems", method = RequestMethod.POST)
    @ResponseBody
    public JSONArray getItems(HttpServletRequest request, Integer size, Integer index, String keyword) throws Exception {
        HttpSession session = request.getSession();
        Object objSession = session.getAttribute("user");
        User user;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.hh");
        if (objSession != null) {

        } else {
            user = (User) objSession;
        }
        index = index % size > 0 ? index / size + 2 : index / size + 1;
        JSONArray jsonArray = new JSONArray();

        String queryHql = "from Activity where isDelete = 0  order by createTime desc ";
        String countHql = "select count(id) from Activity where isDelete = 0 ";
        if (!"".equals(keyword)) {
            queryHql = "from Activity where isDelete = 0 and name like '%" + keyword + "%'  order by createTime desc ";
            countHql = "select count(id) from Activity where isDelete = 0 and name like '%" + keyword + "%' ";
        }
        Page<Activity> page = activityDao.findPage(index, size, queryHql, countHql);
        List<Activity> activityList = page.getList();
        if (null != activityList && activityList.size() > 0) {
            for (Activity a : activityList) {
                JSONObject jsonObj = (JSONObject) JSON.toJSON(a);
                jsonObj.put("beginDate", sdf.format(a.getBeginDate()));
                jsonObj.put("endDate", sdf.format(a.getEndDate()));
                jsonArray.add(jsonObj);
            }
        }
        return jsonArray;
    }

    @RequestMapping(value = "/view", method = RequestMethod.POST)
    @ResponseBody
    public JSONObject activityView(HttpServletRequest request, Integer id) throws Exception {
        HttpSession session = request.getSession();
        Object objSession = session.getAttribute("user");
        User user;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.hh");
        if (objSession != null) {

        } else {
            user = (User) objSession;
        }
        Activity activity = activityDao.getOne(id);
        JSONObject jsonObject = (JSONObject) JSON.toJSON(activity);
        jsonObject.put("beginDate", sdf.format(activity.getBeginDate()));
        jsonObject.put("endDate", sdf.format(activity.getEndDate()));
        return jsonObject;
    }

    @RequestMapping(value = "/add", method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> add(HttpServletRequest request, String actId, String name, String tel, String num) throws Exception {
        Participator p = new Participator();
        HttpSession session = request.getSession();
        Object objValMap = session.getAttribute("addValMap");
        Map<String,Object> returnMap = new HashMap<String, Object>();
        if (null != objValMap){
            Map<String,Object> valMap = (HashMap<String, Object>)objValMap;
            if (participatorService.valPar(valMap,num)){
                returnMap = participatorService.addPar(tel,name,actId);
                session.removeAttribute("addValMap");
                session.setAttribute("participator",p);
            }else{
                returnMap.put("success",false);
                returnMap.put("message","报名失败:验证码错误或者失效");
            }
        }else{
            returnMap.put("success",false);
            returnMap.put("message","报名失败:验证码过期");
        }
        return returnMap;
    }

    @RequestMapping(value = "/val", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> validateNum(HttpServletRequest request, String tel) {
        ValNum valNum = new ValNum();
        HttpSession session = request.getSession();
        //发送验证码
//        Map<String,Object> returnMap = valNum.sendVal(tel);
        Map<String, Object> returnMap = new HashMap<String, Object>();
        returnMap.put("success", true);
        returnMap.put("message", "2121");
        returnMap.put("timestamp", new Date());
        session.setAttribute("addValMap", returnMap);
        return returnMap;
    }


}

