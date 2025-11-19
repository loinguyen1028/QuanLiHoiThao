package repository;

import model.PageRequest;

import java.util.List;

public interface Repository<T> {
    List<T> findAll();
    List<T> findAll(PageRequest pageRequest);
    T findById(int id);
    T create(T entity);
    boolean update(T entity);
    boolean delete(int id);
}
