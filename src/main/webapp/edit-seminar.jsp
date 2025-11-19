<%@ page import="model.Seminar" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Category" %>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<jsp:include page="admin-header.jsp" />
<%
    Seminar seminar = (Seminar) request.getAttribute("seminar");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    System.out.println(request.getContextPath());
%>

<!-- BẮT ĐẦU NỘI DUNG TRANG -->
<div class="container-fluid mt-4">

    <!-- Tiêu đề trang -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800"></h1>
        <a href="seminar_management" class="btn btn-sm btn-secondary shadow-sm">
            <i class="fas fa-arrow-left fa-sm text-white-50"></i> Quay lại danh sách
        </a>
    </div>

    <div class="row">
        <div class="col-lg-12">
            <!-- Card Form -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Thông tin hội thảo</h6>
                </div>
                <div class="card-body">
                    <form action="edit_seminar" method="POST" enctype="multipart/form-data">

<%--                        <% if (isEditMode) { %>--%>
                        <input type="hidden" name="seminarId" value="<%= seminar.getId()%>">
<%--                        <% } %>--%>


                        <div class="row">
                            <!-- Cột trái (Ảnh Banner) -->
                            <div class="col-md-5">
                                <div class="form-group">
                                    <label for="image"><strong>Tải lên ảnh Banner</strong></label>
                                    <input type="file" class="form-control-file" id="image" name="image" accept="image/*">
                                </div>

                                <div class="form-group">
                                    <label>Xem trước Banner:</label>
                                    <div>
                                        <%
                                            if (seminar != null && seminar.getImage() != null && !seminar.getImage().isEmpty()) {
                                                System.out.println(request.getContextPath() + "/" + seminar.getImage());
                                        %>
                                        <img id="imagePreview" class="image" src="<%= request.getContextPath() + "/" + seminar.getImage()%>"
                                             style="width: 100%; height: auto; border-radius: 0.25rem; border: 1px solid #ddd; margin-top: 10px;"
                                        >
                                        <%
                                        }else{
                                        %>
                                        <img id="imagePreview"
                                             src="https://placehold.co/400x200?text=Ch%E1%BB%8Dn+ảnh"
                                             alt="Banner Preview"
                                             style="width: 100%; height: auto; border-radius: 0.25rem; border: 1px solid #ddd; margin-top: 10px;"
                                             onerror="this.src='https://placehold.co/400x200/E8E8E8/999?text=L%E1%BB%97i+%E1%BA%A3nh'; this.style.border='none';">
                                        <%
                                            }
                                        %>
                                    </div>

<%--                                    <% if (isEditMode && bannerUrl != null && !bannerUrl.isEmpty()) { %>--%>
                                    <input type="hidden" name="existingBannerUrl" value="">
<%--                                    <% } %>--%>
                                </div>
                            </div>

                            <div class="col-md-7">
                                <div class="form-group">
                                    <label for="seminarName"><strong>Tên hội thảo <span class="text-danger">*</span></strong></label>
                                    <input type="text" class="form-control" id="seminarName" name="seminarName"
                                           value="<%= seminar.getName()%>" required>
                                </div>

                                <div class="form-group">
                                    <label for="speaker"><strong>Diễn giả <span class="text-danger">*</span></strong></label>
                                    <input type="text" class="form-control" id="speaker" name="speaker"
                                           value="<%= seminar.getSpeaker()%>" required>
                                </div>

                                <div class="form-group">
                                    <label for="location"><strong>Địa điểm <span class="text-danger">*</span></strong></label>
                                    <input type="text" class="form-control" id="location" name="location"
                                           value="<%= seminar.getLocation()%>" required>
                                </div>

                                <div class="form-group">
                                    <label for="category"><strong>Phân loại</strong></label>
                                    <select class="form-select" id="categoryId" name="categoryId" required>
                                        <option selected>Open this select menu</option>
                                        <%
                                            //System.out.println(book.getCategoryId());
                                            if(categories != null){
                                                for(Category category : categories){
                                                    boolean isSelected = seminar.getCategoryId() == category.getId();
                                                    //System.out.println(category.getId());

                                        %>
                                        <option value="<%= category.getId()%>" <%= isSelected ? "selected" : ""%>><%=category.getName()%></option>
                                        <%
                                                }
                                            }
                                        %>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="maxAttendance"><strong>Số lượng tối đa <span class="text-danger">*</span></strong></label>
                                    <input type="number" class="form-control" id="maxAttendance" name="maxAttendance"
                                           value="<%= seminar.getMaxAttendance()%>" min="1" required>
                                </div>

                                <div class="form-group">
                                    <label for="startDate"><strong>Thời gian bắt đầu <span class="text-danger">*</span></strong></label>
                                    <input type="datetime-local" class="form-control" id="startDate" name="startDate"
                                           value="<%= seminar.getStart_date()%>" required>
                                </div>

                                <div class="form-group">
                                    <label for="endDate"><strong>Thời gian kết thúc <span class="text-danger">*</span></strong></label>
                                    <input type="datetime-local" class="form-control" id="endDate" name="endDate"
                                           value="<%= seminar.getEnd_date()%>" required>
                                </div>
                            </div>
                        </div>

                        <div class="row mt-3">
                            <div class="col-12">
                                <div class="form-group">
                                    <label for="description"><strong>Mô tả chi tiết <span class="text-danger">*</span></strong></label>
                                    <textarea id="description" name="description" class="form-control" id="description" name="description" rows="10"
                                              required><%= seminar.getDescription()%></textarea>
                                </div>
                            </div>
                        </div>


                        <hr>

                        <div class="row">
                            <div class="col-12 text-right">
                                <a href="seminar_management" class="btn btn-secondary mr-2">
                                    <i class="fas fa-times"></i> Huỷ
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i>
                                </button>
                            </div>
                        </div>

                    </form>
                </div>
            </div>
        </div>
    </div>

</div>
<script src="https://cdn.ckeditor.com/4.22.1/standard/ckeditor.js"></script>
<script>
    CKEDITOR.replace('description', {
        // Đường dẫn servlet upload (ảnh & file)
        filebrowserUploadUrl: '${pageContext.request.contextPath}/upload-image',      // cho dialog "Upload"
        imageUploadUrl:       '${pageContext.request.contextPath}/upload-image',      // cho kéo-thả/dán ảnh (plugin uploadimage)

        // Tuỳ chọn, chỉnh toolbar ảnh
        extraPlugins: 'uploadimage',
        removePlugins: 'imagebase64', // đảm bảo không dùng base64
        image2_alignClasses: [ 'image-align-left', 'image-align-center', 'image-align-right' ],
        height: 320
    });
</script>

<script>
    const input = document.getElementById('image');
    const preview = document.getElementById('imagePreview');

    if (input && preview) {
        input.addEventListener('change', function (e) {
            const file = e.target.files && e.target.files[0];
            if (!file) return;

            // Tạo URL tạm thời cho ảnh để xem trước
            const url = URL.createObjectURL(file);
            preview.src = url;

            // Đảm bảo style không bị vỡ khi load ảnh mới
            preview.style.width = "100%";
            preview.style.height = "auto";
            preview.style.maxHeight = "300px"; // Giới hạn chiều cao
            preview.style.objectFit = "contain";
            preview.style.border = "1px solid #ddd";
            preview.style.marginTop = "10px";
        });
    }
</script>
<jsp:include page="admin-footer.jsp" />