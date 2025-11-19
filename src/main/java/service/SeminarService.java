package service;

import dto.SeminarDTO;
import model.Page;
import model.PageRequest;
import model.Seminar;

import java.awt.print.Pageable;
import java.util.List;

public interface SeminarService {
    List<Seminar> findAll();
    Page<Seminar> findAll(PageRequest pageRequest);
    Page<SeminarDTO> findAllToDTO(PageRequest pageRequest);
    int count(String keyword);
    Seminar findById(int id);
    Seminar create(Seminar seminar);
    boolean update(Seminar seminar);
    boolean delete(int id);
    int countUpcomingSeminars();
    List<Seminar> findByCategoryId(int categoryId);
}
