package model;

import java.sql.Date;
import java.sql.Timestamp;

public class Register {
    private int id;
    private int seminarId;
    private Date registerDate;
    private String registrationCode; // Mã bí mật (để sửa)
    private String checkInId;        // Mã công khai (để check-in/QR) --> CỘT MỚI
    private boolean vip;
    private Timestamp checkinTime;

    private String name;
    private String email;
    private String password;
    private String phone;
    private String userType;

    // Biến phụ để hiển thị tên hội thảo
    private String eventName;

    public Register() {}

    // --- Getters & Setters ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getSeminarId() { return seminarId; }
    public void setSeminarId(int seminarId) { this.seminarId = seminarId; }

    public Date getRegisterDate() { return registerDate; }
    public void setRegisterDate(Date registerDate) { this.registerDate = registerDate; }

    public String getRegistrationCode() { return registrationCode; }
    public void setRegistrationCode(String registrationCode) { this.registrationCode = registrationCode; }

    public String getCheckInId() { return checkInId; }
    public void setCheckInId(String checkInId) { this.checkInId = checkInId; }

    public boolean isVip() { return vip; }
    public void setVip(boolean vip) { this.vip = vip; }

    public Timestamp getCheckinTime() { return checkinTime; }
    public void setCheckinTime(Timestamp checkinTime) { this.checkinTime = checkinTime; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getUserType() { return userType; }
    public void setUserType(String userType) { this.userType = userType; }

    public String getEventName() { return eventName; }
    public void setEventName(String eventName) { this.eventName = eventName; }
}