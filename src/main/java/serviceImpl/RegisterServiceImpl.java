package serviceImpl;

import dto.ChartDataDTO;
import dto.GuestStatDTO;
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
}
