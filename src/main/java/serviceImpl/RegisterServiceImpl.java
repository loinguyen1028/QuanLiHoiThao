package serviceImpl;

import dto.ChartDataDTO;
import dto.GuestStatDTO;
import model.PageRequest;
import model.Register;
import repository.RegisterRepository;
import repositoryImpl.RegisterRepositoryImpl;
import service.RegisterService;

import javax.sql.DataSource;
import java.util.List;

public class RegisterServiceImpl implements RegisterService {

    private final RegisterRepository registerRepository;

    public RegisterServiceImpl(DataSource ds) {
        this.registerRepository = new RegisterRepositoryImpl(ds);
    }

    @Override
    public List<ChartDataDTO> getRegistrationStatsByDate() {
        return this.registerRepository.getRegistrationStatsByDate();
    }

    @Override
    public List<GuestStatDTO> getGuestStatistics() {
        return this.registerRepository.getGuestStatistics();
    }
    @Override
    public boolean toggleVip(int id) {
        return registerRepository.toggleVip(id);
    }

    // --- TRIỂN KHAI CHECK-IN ---
    @Override
    public Register findByCheckInId(String checkInId) {
        return registerRepository.findByCheckInId(checkInId);
    }

    @Override
    public boolean checkInUser(String checkInId) {
        return registerRepository.setCheckInTime(checkInId);
    }

    @Override
    public List<Register> findAllByCategoryId(int categoryId, int seminarIdFilter, int vipStatus, String userType, int checkInStatus, int page, int pageSize) {
        return registerRepository.findAllByCategoryId(categoryId, seminarIdFilter, vipStatus, userType, checkInStatus, page, pageSize);
    }

    @Override
    public int countByFilter(int categoryId, int seminarIdFilter, int vipStatus) {
        return registerRepository.countByFilter(categoryId, seminarIdFilter, vipStatus);
    }

    @Override
    public List<Register> findAll() {
        return registerRepository.findAll();
    }

    @Override
    public List<Register> findAll(PageRequest pageRequest) {
        return registerRepository.findAll(pageRequest);
    }

    @Override
    public Register findById(int id) {
        return this.registerRepository.findById(id);
    }

    @Override
    public Register create(Register register) {
        return this.registerRepository.create(register);
    }

    @Override
    public boolean update(Register register) {
        return registerRepository.update(register);
    }

    @Override
    public boolean delete(int id) {
        return registerRepository.delete(id);
    }

    @Override
    public List<Register> findBySeminarId(int seminarId) {
        return registerRepository.findBySeminarId(seminarId);
    }
}