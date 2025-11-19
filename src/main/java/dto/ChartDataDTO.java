package dto;

public class ChartDataDTO {
    private String label; // Ngày (VD: "2025-11-14")
    private int value;    // Số lượng đăng ký

    public ChartDataDTO(String label, int value) {
        this.label = label;
        this.value = value;
    }
    // Getter & Setter
    public String getLabel() { return label; }
    public int getValue() { return value; }
}
