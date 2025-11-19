package repository;

import dto.ChartDataDTO;
import dto.GuestStatDTO;
import model.Register;

import java.util.List;

public interface RegisterRepository extends Repository<Register>{
    List<ChartDataDTO> getRegistrationStatsByDate(); //Thống kê số lượng đăng ký theo NGÀY
    List<GuestStatDTO> getGuestStatistics(); //Thống kê theo Loại khách
}
