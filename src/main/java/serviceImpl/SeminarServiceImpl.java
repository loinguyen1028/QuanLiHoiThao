package serviceImpl;

import dto.SeminarDTO;
import model.Page;
import model.PageRequest;
import model.Seminar;
import repository.SeminarRepository;
import repositoryImpl.SeminarRepositoryImpl;
import service.SeminarService;

import javax.sql.DataSource;
import java.util.List;

public class SeminarServiceImpl implements SeminarService {

    private final SeminarRepository seminarRepository;

    public SeminarServiceImpl(DataSource ds) {
        this.seminarRepository = new SeminarRepositoryImpl(ds);
    }

    @Override
    public List<Seminar> findByCategoryId(int categoryId) {
        return seminarRepository.findByCategoryId(categoryId);
    }
    @Override
    public List<Seminar> findAll() {
        return this.seminarRepository.findAll();
    }

    @Override
    public Page<Seminar> findAll(PageRequest pageRequest) {
        List<Seminar> seminars = this.seminarRepository.findAll(pageRequest);
        int totalItem = seminarRepository.count(pageRequest.getKeyword());
        return new Page<>(seminars, pageRequest.getPage(), pageRequest.getPageSize(), totalItem);
    }

    @Override
    public Page<SeminarDTO> findAllToDTO(PageRequest pageRequest) {
        List<SeminarDTO> seminars = this.seminarRepository.findAllToDTO(pageRequest);
        int totalItem = seminarRepository.count(pageRequest.getKeyword());
        return new Page<>(seminars, pageRequest.getPage(), pageRequest.getPageSize(), totalItem);
    }

    @Override
    public int count(String keyword) {
        return seminarRepository.count(keyword);
    }

    @Override
    public Seminar findById(int id) {
        return seminarRepository.findById(id);
    }

    @Override
    public Seminar create(Seminar seminar) {
        return seminarRepository.create(seminar);
    }

    @Override
    public boolean update(Seminar seminar) {
        return seminarRepository.update(seminar);
    }

    @Override
    public boolean delete(int id) {
        return seminarRepository.delete(id);
    }

    @Override
    public int countUpcomingSeminars() {
        return seminarRepository.countUpcomingSeminars();
    }
}
