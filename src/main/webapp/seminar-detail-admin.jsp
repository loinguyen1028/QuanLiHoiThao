<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Seminar" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Category" %>
<jsp:include page="admin-header.jsp" />
<%
    Seminar seminar = (Seminar) request.getAttribute("seminar");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HH:mm 'ngày' dd/MM/yyyy");
%>
<div class="container-fluid mt-4">
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">Chi tiết Hội thảo</h1>
        <a href="seminar_management" class="btn btn-sm btn-secondary shadow-sm">
            <i class="fas fa-arrow-left fa-sm text-white-50"></i> Quay lại danh sách
        </a>
    </div>

    <div class="row">
        <div class="col-lg-8">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary"><%= seminar.getName() %></h6>
                </div>
                <div class="card-body">
                    <h5 class="font-weight-bold">Mô tả chi tiết</h5>
                    <pre style="font-family: inherit; font-size: inherit; white-space: pre-wrap; background: none; border: none; padding: 0; margin: 0;"><%= seminar.getDescription() %></pre>
                </div>
            </div>


            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Banner Hội thảo</h6>
                </div>
                <div class="card-body text-center">
                    <%
                        if (seminar != null && seminar.getImage() != null && !seminar.getImage().isEmpty()) {
                    %>
                        <img id="immage" class="image" src="<%= request.getContextPath() + "/" + seminar.getImage()%>"
                             style="width: 100%; height: auto; border-radius: 0.25rem; border: 1px solid #ddd; margin-top: 10px;">
                    <%
                        }else{
                    %>
                    <img class="img-fluid rounded"
                         src="https://placehold.co/800x400?text=No+Banner"
                         alt="Banner Hội thảo"
                         style="width: 100%; height: auto; border-radius: 0.25rem; border: 1px solid #ddd; margin-top: 10px;"
                         onerror="this.src='https://placehold.co/800x400/E8E8E8/999?text=Image+Error';">
                    <%
                        }
                    %>
                </div>
            </div>

        </div>

        <div class="col-lg-4">

            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Thông tin chi tiết</h6>
                </div>
                <div class="card-body">
                    <div class="mb-2">
                        <i class="fas fa-user-tie fa-fw mr-2 text-gray-400"></i>
                        <strong>Diễn giả:</strong> <%= seminar.getSpeaker() %>
                    </div>
                    <div class="mb-2">
                        <i class="fas fa-calendar-alt fa-fw mr-2 text-gray-400"></i>
                        <strong>Bắt đầu:</strong> <%= seminar.getStart_date().format(dtf) %>
                    </div>
                    <div class="mb-2">
                        <i class="far fa-calendar-alt fa-fw mr-2 text-gray-400"></i>
                        <strong>Kết thúc:</strong> <%= seminar.getEnd_date().format(dtf) %>
                    </div>
                    <div class="mb-2">
                        <i class="fas fa-map-marker-alt fa-fw mr-2 text-gray-400"></i>
                        <strong>Địa điểm:</strong> <%= seminar.getLocation() %>
                    </div>
                    <div class="mb-2">
                        <i class="fas fa-tag fa-fw mr-2 text-gray-400"></i>
                        <%
                            //System.out.println(seminar.getCategoryId());
                            if(categories != null){
                                for(Category category : categories){
                                    if(seminar.getCategoryId() == category.getId()){
                        %>
                        <strong>Loại: </strong> <%= category.getName()%>
                        <%
                                    }
                                }
                            }
                        %>
                    </div>
                    <div class="mb-2">
                        <i class="fas fa-users fa-fw mr-2 text-gray-400"></i>
                        <strong>Số lượng:</strong> <%= seminar.getMaxAttendance()%>
                    </div>
                </div>
            </div>

            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Hành động</h6>
                </div>
                <div class="card-body">
                    <p>Quản lý thông tin hội thảo này.</p>
                    <a href="edit_seminar?id=<%= seminar.getId() %>" class="btn btn-primary btn-icon-split btn-block mb-2">
                        <span class="icon text-white-50">
                            <i class="fas fa-edit"></i>
                        </span>
                        <span class="text">Chỉnh sửa thông tin</span>
                    </a>

                    <a href="#" class="btn btn-danger btn-icon-split btn-block" data-toggle="modal" data-target="#deleteModal">
                        <span class="icon text-white-50">
                            <i class="fas fa-trash"></i>
                        </span>
                        <span class="text">Xoá hội thảo này</span>
                    </a>
                </div>
            </div>

        </div>
    </div>
</div>

<div class="modal fade" id="deleteModal" tabindex="-1" role="dialog" aria-labelledby="deleteModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteModalLabel">Xác nhận Xoá Hội thảo?</h5>
                <button class="close" type="button" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span>
                </button>
            </div>
            <div class="modal-body">
                Bạn có chắc chắn muốn xoá hội thảo: <strong id="deleteSeminarName"></strong>?
                Hành động này không thể hoàn tác.
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" type="button" data-dismiss="modal">Huỷ</button>
                <a class="btn btn-danger" id="confirmDeleteButton" href="<%= request.getContextPath()%>/delete_seminar?id=<%=seminar.getId()%>">Xoá</a>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        $('#deleteModal').on('show.bs.modal', function (event) {
            var button = $(event.relatedTarget);
            var seminarId = button.data('id');
            var seminarName = button.data('name');

            var modal = $(this);

            modal.find('.modal-body #deleteSeminarName').text(seminarName);

            modal.find('#confirmDeleteButton').attr('href', 'delete_seminar?id=' + seminarId);
        });
    });
</script>
<jsp:include page="admin-footer.jsp" />
