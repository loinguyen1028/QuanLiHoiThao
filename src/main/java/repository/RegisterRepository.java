package repository;

import dto.ChartDataDTO;
import dto.GuestStatDTO;
import model.Register;

import java.util.List;

public interface RegisterRepository extends Repository<Register> {

    // --- Các hàm Thống kê cũ ---
    List<ChartDataDTO> getRegistrationStatsByDate();
    List<GuestStatDTO> getGuestStatistics();

    // --- CÁC HÀM MỚI CẦN THÊM VÀO ĐÂY (Để sửa lỗi) ---

    // 1. Tìm danh sách theo ID hội thảo
    List<Register> findBySeminarId(int seminarId);

    // 2. Tìm người dùng để sửa (Mã bí mật)
    Register findByEmailAndCode(String email, String registrationCode);

    // 3. Tìm người dùng để check-in (Mã công khai)
    Register findByCheckInId(String checkInId);

    // 4. Cập nhật giờ check-in
    boolean setCheckInTime(String checkInId);
}