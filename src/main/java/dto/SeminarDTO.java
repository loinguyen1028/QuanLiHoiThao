package dto;

import java.time.LocalDateTime;

public class SeminarDTO {
    private int id;
    private String name;
    private String description;
    private LocalDateTime start_date;
    private LocalDateTime end_date;
    private String location;
    private String speaker;
    private int categoryId;
    private String categoryName;
    private int maxAttendance;
    private String status;
    private String image;

    public SeminarDTO() {
    }

    public SeminarDTO(String name, String description, LocalDateTime start_date, LocalDateTime end_date, String location, String speaker,
                      int categoryId, String categoryName, int maxAttendance, String status, String image) {
        this.name = name;
        this.description = description;
        this.start_date = start_date;
        this.end_date = end_date;
        this.location = location;
        this.speaker = speaker;
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.maxAttendance = maxAttendance;
        this.status = status;
        this.image = image;
    }

    public SeminarDTO(int id, String name, String description, LocalDateTime start_date, LocalDateTime end_date, String location, String speaker,
                      int categoryId, String categoryName, int maxAttendance, String status, String image) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.start_date = start_date;
        this.end_date = end_date;
        this.location = location;
        this.speaker = speaker;
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.maxAttendance = maxAttendance;
        this.status = status;
        this.image = image;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDateTime getStart_date() {
        return start_date;
    }

    public void setStart_date(LocalDateTime start_date) {
        this.start_date = start_date;
    }

    public LocalDateTime getEnd_date() {
        return end_date;
    }

    public void setEnd_date(LocalDateTime end_date) {
        this.end_date = end_date;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getSpeaker() {
        return speaker;
    }

    public void setSpeaker(String speaker) {
        this.speaker = speaker;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public int getMaxAttendance() {
        return maxAttendance;
    }

    public void setMaxAttendance(int maxAttendance) {
        this.maxAttendance = maxAttendance;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }
}
