package dto;

import java.sql.Timestamp;
import java.util.Date;

public class RegisterDTO {
    private int id;
    private int seminarId;
    private Date registerDate;
    private String registrationCode;
    private String checkInId;
    private boolean vip;
    private Timestamp checkinTime;

    private String name;
    private String email;
    private String phone;
    private String userType;

    // TRƯỜNG MỚI: Tên hội thảo (để hiển thị ra bảng)
    private String eventName;

    public RegisterDTO() {
    }

    public RegisterDTO(int seminarId, Date registerDate, String registrationCode, String checkInId, boolean vip,
                       Timestamp checkinTime, String name, String email, String phone, String userType, String eventName) {
        this.seminarId = seminarId;
        this.registerDate = registerDate;
        this.registrationCode = registrationCode;
        this.checkInId = checkInId;
        this.vip = vip;
        this.checkinTime = checkinTime;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.userType = userType;
        this.eventName = eventName;
    }

    public RegisterDTO(int id, int seminarId, Date registerDate, String registrationCode, String checkInId, boolean vip,
                       Timestamp checkinTime, String name, String email, String phone, String userType, String eventName) {
        this.id = id;
        this.seminarId = seminarId;
        this.registerDate = registerDate;
        this.registrationCode = registrationCode;
        this.checkInId = checkInId;
        this.vip = vip;
        this.checkinTime = checkinTime;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.userType = userType;
        this.eventName = eventName;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getSeminarId() {
        return seminarId;
    }

    public void setSeminarId(int seminarId) {
        this.seminarId = seminarId;
    }

    public Date getRegisterDate() {
        return registerDate;
    }

    public void setRegisterDate(Date registerDate) {
        this.registerDate = registerDate;
    }

    public String getRegistrationCode() {
        return registrationCode;
    }

    public void setRegistrationCode(String registrationCode) {
        this.registrationCode = registrationCode;
    }

    public String getCheckInId() {
        return checkInId;
    }

    public void setCheckInId(String checkInId) {
        this.checkInId = checkInId;
    }

    public boolean isVip() {
        return vip;
    }

    public void setVip(boolean vip) {
        this.vip = vip;
    }

    public Timestamp getCheckinTime() {
        return checkinTime;
    }

    public void setCheckinTime(Timestamp checkinTime) {
        this.checkinTime = checkinTime;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getUserType() {
        return userType;
    }

    public void setUserType(String userType) {
        this.userType = userType;
    }

    public String getEventName() {
        return eventName;
    }

    public void setEventName(String eventName) {
        this.eventName = eventName;
    }
}
