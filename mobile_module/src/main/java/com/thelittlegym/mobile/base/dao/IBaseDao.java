package com.thelittlegym.mobile.base.dao;

import com.thelittlegym.mobile.base.model.Page;
import com.thelittlegym.mobile.base.vo.Parameter;
import org.hibernate.HibernateException;

import java.math.BigInteger;
import java.sql.SQLException;
import java.util.Collection;
import java.util.List;

/**
 * Created by hibernate on 2017/3/21.
 */
public interface IBaseDao<T> {
    //单个CRUD
    public void save(final T entity) throws Exception;
    public void delete(final T entity) throws Exception;
    public void deleteWithHql(final String hql) throws Exception;
    public void update(final T entity) throws Exception;
    public T getOne(final int id) throws Exception;

    //批处理
    public int batchSave(final List<T> list) throws Exception;
    public void deleteAll(final Collection entities) throws Exception;

    //createQuery（Query）
    public T findOne(final String hql) throws Exception;
    public T findOne(final String hql, final Parameter parameter) throws Exception;

    //list查询
    public List<T> findList(final String hql) throws Exception;
    public List<T> findList(final String hql, final Parameter parameter) throws Exception;

    //分页查询
    public Page<T> findPage(final int currentPage, final int pageSize, final String queryHql, final String countHql, final Object[] values)
            throws HibernateException,SQLException;
    public Page<T> findPage(final int currentPage, final int pageSize, final String queryHql, final String countHql)
            throws HibernateException,SQLException;

    //查询满足条件的记录数
    public long findCount(final String hql);
    public long findCount(final String hql, final Object[] values);

    //查询固定条数的记录数
    public List<T> findMaxRes(final String hql,final Integer num);

    public BigInteger findCountBySql(final String sql);
}
