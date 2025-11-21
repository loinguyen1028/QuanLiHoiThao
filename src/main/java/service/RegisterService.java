package service;

import dto.ChartDataDTO;
import dto.GuestStatDTO;
import model.PageRequest;
import model.Register;

import java.util.List;

public interface RegisterService {
    List<ChartDataDTO> getRegistrationStatsByDate();
    List<GuestStatDTO> getGuestStatistics();
    boolean toggleVip(int id);

    // --- HÀM CHECK-IN ---
    Register findByCheckInId(String checkInId);
    boolean checkInUser(String checkInId);

    List<Register> findAllByCategoryId(int categoryId, int seminarIdFilter, int vipStatus);
    List<Register> findAll();
    List<Register> findAll(PageRequest pageRequest);
    Register findById(int id);
    Register create(Register register);
    boolean update(Register register);
    boolean delete(int id);

}