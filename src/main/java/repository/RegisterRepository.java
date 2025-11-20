package repository;

import dto.ChartDataDTO;
import dto.GuestStatDTO;
import model.Register;

import java.util.List;

public interface RegisterRepository extends Repository<Register> {

    // --- Các hàm Thống kê (Cũ) ---
    List<ChartDataDTO> getRegistrationStatsByDate();
    List<GuestStatDTO> getGuestStatistics();

    // --- Các hàm Nghiệp vụ (Cũ) ---
    List<Register> findBySeminarId(int seminarId);
    Register findByEmailAndCode(String email, String registrationCode);
    boolean toggleVip(int id);

    // --- HÀM MỚI CHO CHECK-IN (BẮT BUỘC PHẢI CÓ) ---
    Register findByCheckInId(String checkInId);
    boolean setCheckInTime(String checkInId);

    List<Register> findAllByCategoryId(int categoryId);
}