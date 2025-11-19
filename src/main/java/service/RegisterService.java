package service;

import dto.ChartDataDTO;
import dto.GuestStatDTO;

import java.util.List;

public interface RegisterService {
    List<ChartDataDTO> getRegistrationStatsByDate();
    List<GuestStatDTO> getGuestStatistics();
}
