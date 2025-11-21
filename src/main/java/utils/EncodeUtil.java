package utils;

import java.util.Base64;

public class EncodeUtil {
    public static String encodeId(int id) {
        return Base64.getUrlEncoder().encodeToString(String.valueOf(id).getBytes());
    }

    public static int decodeId(String encoded) {
        try {
            String decoded = new String(Base64.getUrlDecoder().decode(encoded));
            return Integer.parseInt(decoded);
        } catch (Exception e) {
            return -1;
        }
    }
}
