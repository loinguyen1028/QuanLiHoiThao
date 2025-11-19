package dto;

public class GuestStatDTO {
    private String guestType;
    private int totalRegistered; // Tổng đăng ký
    private int totalCheckedIn;  // Đã check-in

    public GuestStatDTO(String guestType, int totalRegistered, int totalCheckedIn) {
        this.guestType = guestType;
        this.totalRegistered = totalRegistered;
        this.totalCheckedIn = totalCheckedIn;
    }

    // Getter & Setter
    public String getGuestType() { return guestType; }
    public int getTotalRegistered() { return totalRegistered; }
    public int getTotalCheckedIn() { return totalCheckedIn; }
}