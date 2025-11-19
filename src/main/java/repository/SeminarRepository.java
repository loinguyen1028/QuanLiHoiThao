package repository;

import dto.SeminarDTO;
import model.PageRequest;
import model.Seminar;

import java.util.List;

public interface SeminarRepository extends Repository<Seminar>{
    List<SeminarDTO> findAllToDTO(PageRequest pageRequest);
    int count(String keyword);
    List<Seminar> findByCategoryId(int categoryId);
    int countUpcomingSeminars();
}
