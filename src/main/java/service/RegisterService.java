package service;

import dto.ChartDataDTO;
import dto.GuestStatDTO;
import model.Register;

import java.util.List;

public interface RegisterService {
    List<ChartDataDTO> getRegistrationStatsByDate();
    List<GuestStatDTO> getGuestStatistics();
    boolean toggleVip(int id);

    // --- HÀM CHECK-IN ---
    Register findByCheckInId(String checkInId);
    boolean checkInUser(String checkInId);

    List<Register> findAllByCategoryId(int categoryId);
}