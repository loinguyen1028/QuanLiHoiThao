package QRCode;

import com.google.zxing.*;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Base64;

public class QRCodeGenerator {

    // 1. Tạo QR dạng chuỗi Base64 (Để hiển thị trên trang web success.jsp)
    public static String generateQRCodeBase64(String text, int width, int height)
            throws WriterException, IOException {

        BitMatrix bitMatrix = new MultiFormatWriter().encode(
                text, BarcodeFormat.QR_CODE, width, height);

        ByteArrayOutputStream pngOutputStream = new ByteArrayOutputStream();
        MatrixToImageWriter.writeToStream(bitMatrix, "PNG", pngOutputStream);

        return Base64.getEncoder().encodeToString(pngOutputStream.toByteArray());
    }

    // 2. Tạo QR dạng mảng byte[] (Để gửi đính kèm trong Email)
    public static byte[] generateQRCodeImage(String text, int width, int height)
            throws WriterException, IOException {

        BitMatrix bitMatrix = new MultiFormatWriter().encode(
                text, BarcodeFormat.QR_CODE, width, height);

        ByteArrayOutputStream pngOutputStream = new ByteArrayOutputStream();
        MatrixToImageWriter.writeToStream(bitMatrix, "PNG", pngOutputStream);

        return pngOutputStream.toByteArray();
    }
}