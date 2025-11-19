package utils;

import jakarta.servlet.http.HttpServletRequest;

public class RequestUtil {
    public static int getInt(HttpServletRequest request, String name, int defaultValue) {
        try {
            int value = Integer.parseInt(request.getParameter(name));
            return value > 0 ? value : defaultValue;
        }catch (Exception e){
            return defaultValue;
        }
    }

    public static String getString(HttpServletRequest request, String name, String defaultValue) {
        String value = request.getParameter(name);
        return (value == null  || value.isBlank()) ? defaultValue : value.trim();
    }
}
