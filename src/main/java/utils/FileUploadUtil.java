package utils;

import jakarta.servlet.http.Part;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.*;
import java.nio.file.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.logging.Logger;
import javax.imageio.ImageIO;

/**
 * File Upload Utility - Optimized
 * Tự động Resize ảnh sau khi upload để tiết kiệm dung lượng.
 */
public class FileUploadUtil {
    private static final Logger log = Logger.getLogger(FileUploadUtil.class.getName());

    // Tên thư mục gốc để lưu file
    private static final String BASE_UPLOAD_DIR = "uploads";

    // Giới hạn file
    private static final long MAX_IMAGE_SIZE = 10 * 1024 * 1024; // 10MB (cho phép upload ảnh to, sau đó sẽ resize)
    private static final long MAX_FILE_SIZE = 20 * 1024 * 1024; // 20MB cho tài liệu
    private static final int MAX_FILENAME_LENGTH = 255;

    // Cấu hình Resize ảnh (Quan trọng)
    private static final int MAX_RESIZE_WIDTH = 1200; // Ảnh sẽ được resize về chiều rộng tối đa 1200px

    // Cấu hình Thumbnail
    private static final int THUMB_WIDTH = 300;
    private static final int THUMB_HEIGHT = 300;

    // Các định dạng ảnh cho phép
    private static final Set<String> IMAGE_MIME_TYPES = Set.of(
            "image/jpeg", "image/jpg", "image/png", "image/gif", "image/webp"
    );

    // Các định dạng tài liệu cho phép
    private static final Set<String> DOCUMENT_MIME_TYPES = Set.of(
            "application/pdf",
            "application/msword",
            "application/vnd.openxmlformats-officedocument.wordprocessingml.document", // .docx
            "application/vnd.ms-excel",
            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", // .xlsx
            "text/plain", "text/csv"
    );

    // Magic bytes để kiểm tra file thật (chống đổi đuôi file)
    private static final Map<String, byte[][]> MAGIC_BYTES = Map.of(
            "jpg", new byte[][]{{(byte)0xFF, (byte)0xD8, (byte)0xFF}},
            "png", new byte[][]{{(byte)0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A}},
            "gif", new byte[][]{{0x47, 0x49, 0x46, 0x38, 0x37, 0x61}, {0x47, 0x49, 0x46, 0x38, 0x39, 0x61}},
            "webp", new byte[][]{{0x52, 0x49, 0x46, 0x46}},
            "pdf", new byte[][]{{0x25, 0x50, 0x44, 0x46}}
    );

    private static final AtomicInteger counter = new AtomicInteger(0);

    // Custom Exception
    public static class FileUploadException extends IOException {
        public enum ErrorType { FILE_TOO_LARGE, INVALID_TYPE, SECURITY_VIOLATION, INVALID_FORMAT, IO_ERROR, EMPTY_FILE }
        private final ErrorType type;
        public FileUploadException(ErrorType type, String message) {
            super(message);
            this.type = type;
        }
    }

    /**
     * UPLOAD IMAGE - Có Resize và tạo Thumbnail
     */
    public static Map<String, String> uploadImage(Part part, String folderName, String appRealPath, boolean createThumbnail)
            throws FileUploadException {

        validatePart(part, true, MAX_IMAGE_SIZE);

        // Validate MIME type
        if (!IMAGE_MIME_TYPES.contains(part.getContentType().toLowerCase())) {
            throw new FileUploadException(FileUploadException.ErrorType.INVALID_TYPE, "Chỉ chấp nhận file ảnh: JPG, PNG, GIF, WebP");
        }

        // Tạo tên file unique
        String fileName = sanitizeFileName(getSubmittedFileName(part));
        fileName = uniqueName(fileName);

        // Tạo đường dẫn lưu
        String uploadDir = BASE_UPLOAD_DIR + "/" + sanitizeFolderName(folderName);
        Path uploadRoot = Path.of(appRealPath, uploadDir);
        Map<String, String> result = new HashMap<>();

        try {
            Files.createDirectories(uploadRoot);
            Path dest = uploadRoot.resolve(fileName);

            // 1. Lưu file gốc vào ổ cứng
            try (InputStream in = part.getInputStream()) {
                Files.copy(in, dest, StandardCopyOption.REPLACE_EXISTING);
            }

            // 2. TỰ ĐỘNG RESIZE ẢNH (Để giảm dung lượng)
            try {
                // Resize đè lên file gốc, chiều rộng tối đa 1200px
                resizeImage(dest, dest, MAX_RESIZE_WIDTH);
            } catch (IOException e) {
                log.warning("Resize failed (keeping original): " + e.getMessage());
            }

            String originalPath = uploadDir + "/" + fileName;
            result.put("original", originalPath);
            log.info("Image uploaded & resized: " + originalPath);

            // 3. Tạo thumbnail (nếu cần)
            if (createThumbnail) {
                try {
                    String thumbPath = createThumbnail(originalPath, folderName, appRealPath);
                    result.put("thumbnail", thumbPath);
                } catch (IOException e) {
                    log.warning("Failed to create thumbnail: " + e.getMessage());
                }
            }

        } catch (IOException e) {
            throw new FileUploadException(FileUploadException.ErrorType.IO_ERROR, "Không thể lưu ảnh: " + e.getMessage());
        }

        return result;
    }

    // Helper gọi nhanh (chỉ trả về đường dẫn ảnh gốc/đã resize)
    public static String uploadImageReturnPath(Part part, String folderName, String appRealPath) throws FileUploadException {
        Map<String, String> map = uploadImage(part, folderName, appRealPath, false);
        return map.get("original");
    }

    /**
     * UPLOAD FILE TÀI LIỆU (PDF, DOC...)
     */
    public static String uploadFile(Part part, String folderName, String appRealPath) throws FileUploadException {
        validatePart(part, false, MAX_FILE_SIZE);

        if (!DOCUMENT_MIME_TYPES.contains(part.getContentType().toLowerCase())) {
            throw new FileUploadException(FileUploadException.ErrorType.INVALID_TYPE, "File không được hỗ trợ");
        }

        String fileName = uniqueName(sanitizeFileName(getSubmittedFileName(part)));
        String uploadDir = BASE_UPLOAD_DIR + "/" + sanitizeFolderName(folderName);
        Path uploadRoot = Path.of(appRealPath, uploadDir);

        try {
            Files.createDirectories(uploadRoot);
            Path dest = uploadRoot.resolve(fileName);
            try (InputStream in = part.getInputStream()) {
                Files.copy(in, dest, StandardCopyOption.REPLACE_EXISTING);
            }
            return uploadDir + "/" + fileName;
        } catch (IOException e) {
            throw new FileUploadException(FileUploadException.ErrorType.IO_ERROR, "Lỗi lưu file: " + e.getMessage());
        }
    }

    /**
     * HÀM RESIZE ẢNH (QUAN TRỌNG)
     * Tự động tính chiều cao theo tỉ lệ.
     */
    public static void resizeImage(Path originalPath, Path targetPath, int targetWidth) throws IOException {
        BufferedImage originalImage = ImageIO.read(originalPath.toFile());
        if (originalImage == null) return; // Không phải ảnh hợp lệ

        int originalWidth = originalImage.getWidth();
        int originalHeight = originalImage.getHeight();

        // Nếu ảnh nhỏ hơn kích thước yêu cầu thì không cần resize
        if (originalWidth <= targetWidth) {
            if (!originalPath.equals(targetPath)) {
                Files.copy(originalPath, targetPath, StandardCopyOption.REPLACE_EXISTING);
            }
            return;
        }

        // Tính chiều cao mới giữ nguyên tỉ lệ (Aspect Ratio)
        int targetHeight = (int) ((double) originalHeight / originalWidth * targetWidth);

        // Tạo ảnh mới
        int type = (originalImage.getType() == 0) ? BufferedImage.TYPE_INT_ARGB : originalImage.getType();
        BufferedImage resizedImage = new BufferedImage(targetWidth, targetHeight, type);

        // Vẽ ảnh (Scale chất lượng cao)
        Graphics2D g = resizedImage.createGraphics();
        g.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
        g.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);

        g.drawImage(originalImage, 0, 0, targetWidth, targetHeight, null);
        g.dispose();

        // Lưu file (ghi đè hoặc tạo mới)
        String ext = getExtension(targetPath.getFileName().toString());
        if (ext.isBlank()) ext = "jpg";
        ImageIO.write(resizedImage, ext, targetPath.toFile());
    }

    // --- CÁC HÀM VALIDATE & HELPER KHÁC ---

    private static void validatePart(Part part, boolean isImage, long maxSize) throws FileUploadException {
        if (part == null || part.getSize() == 0) throw new FileUploadException(FileUploadException.ErrorType.EMPTY_FILE, "File rỗng");
        if (part.getSize() > maxSize) throw new FileUploadException(FileUploadException.ErrorType.FILE_TOO_LARGE, "File quá lớn");
        String fileName = sanitizeFileName(getSubmittedFileName(part));
        validateSecurePath(fileName);
    }

    private static String createThumbnail(String originalPath, String folderName, String appRealPath) throws IOException {
        Path original = Path.of(appRealPath, originalPath);
        String thumbDir = BASE_UPLOAD_DIR + "/" + sanitizeFolderName(folderName) + "/thumbs";
        Path thumbRoot = Path.of(appRealPath, thumbDir);
        Files.createDirectories(thumbRoot);

        String fileName = Path.of(originalPath).getFileName().toString();
        Path thumbPath = thumbRoot.resolve(fileName);

        // Dùng hàm resize có sẵn để tạo thumbnail (300px)
        resizeImage(original, thumbPath, THUMB_WIDTH);

        return thumbDir + "/" + fileName;
    }

    private static String sanitizeFileName(String name) {
        if (name == null) return null;
        name = name.replace("\\", "/");
        int lastSlash = name.lastIndexOf('/');
        if (lastSlash >= 0) name = name.substring(lastSlash + 1);
        return name.replaceAll("[^a-zA-Z0-9._-]", "_");
    }

    private static void validateSecurePath(String fileName) throws FileUploadException {
        if (fileName.contains("..") || fileName.contains("/") || fileName.contains("\\")) {
            throw new FileUploadException(FileUploadException.ErrorType.SECURITY_VIOLATION, "Tên file không an toàn");
        }
    }

    private static String uniqueName(String base) {
        String ts = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss_SSS"));
        int count = counter.incrementAndGet() % 1000;
        int dot = base.lastIndexOf('.');
        return (dot > 0) ? base.substring(0, dot) + "_" + ts + "_" + count + base.substring(dot) : base + "_" + ts + "_" + count;
    }

    private static String getExtension(String fileName) {
        int dot = fileName.lastIndexOf('.');
        return dot > 0 ? fileName.substring(dot + 1) : "";
    }

    private static String getSubmittedFileName(Part part) {
        return part.getSubmittedFileName();
    }

    private static String sanitizeFolderName(String folderName) {
        return (folderName == null || folderName.isBlank()) ? "general" : folderName.replaceAll("[^a-zA-Z0-9_-]", "_").toLowerCase();
    }

    public static String safeAppRealPath(jakarta.servlet.ServletContext ctx) {
        String real = null;
        try { real = ctx.getRealPath(""); } catch (Exception e) {}
        return (real == null) ? System.getProperty("java.io.tmpdir") : real;
    }
}