package com.thelittlegym.mobile.service.impl;

import com.thelittlegym.mobile.base.model.Page;
import com.thelittlegym.mobile.dao.impl.FeedBackDaoImpl;
import com.thelittlegym.mobile.entity.Feedback;
import com.thelittlegym.mobile.service.IFeedbackService;
import com.thelittlegym.mobile.user.dao.impl.UserDaoImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.Map;

/**
 * Created by hibernate on 2017/4/21.
 */
@Component
public class FeedbackService implements IFeedbackService {
    @Autowired
    private FeedBackDaoImpl feedBackDao;

    @Override
    public void save(Feedback feedback) throws Exception {
            feedBackDao.save(feedback);
    }

    @Override
    public Page<Feedback> getPageList(Integer pageNow ,Integer pageSize,String type) throws Exception {
        String whereSql = "IFNULL(handled,0) != 1";
        switch(type) {
            case "0":
                //未处理
                whereSql = "IFNULL(handled,0) != 1";
                break;
            case "1":
                //已处理
                whereSql = "IFNULL(handled,0) != 0";
                break;
            case "-1":
                //全部
                whereSql = " 1= 1 ";
            default:break;
        }
        String queryHql =  "from Feedback where " + whereSql + "  order by createTime desc";
        String countHql = "select count(id) from Feedback where " + whereSql ;
        Page<Feedback> page = feedBackDao.findPage(pageNow,pageSize,queryHql,countHql);
        return page;
    }

    @Override
    public Feedback getOne(Integer id) throws Exception {
        return feedBackDao.getOne(id);
    }

    @Override
    public void hand(Integer id) throws Exception {
        Feedback feedback = feedBackDao.getOne(id);
        if (feedback != null){
            feedback.setHandled(true);
            feedback.setHandledTime(new Date());
            feedBackDao.update(feedback);
        }
    }

    @Override
    public long handledCount() throws Exception {
        String countHql = "select count(id) from Feedback where IFNULL(handled,0) != 0 " ;
        return feedBackDao.findCount(countHql);
    }
}
