package model;

import java.sql.Date;
import java.sql.Timestamp;

public class Register {
    private int id;
    private int seminarId;           // seminar_id (FK → seminar.id)
    private Date registerDate;       // register_date
    private String registrationCode; // registration_code
    private boolean vip;             // is_vip
    private Timestamp checkinTime;   // checkin_time

    private String name;             // name
    private String email;            // email
    private String password;         // password
    private String phone;            // phone
    private String userType;         // user_type

    public Register() {}

    // Constructor tiện để insert nhanh
    public Register(int seminarId, String name, String email, String phone, String userType) {
        this.seminarId = seminarId;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.userType = userType;
    }

    // Getter - Setter
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

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
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
}
