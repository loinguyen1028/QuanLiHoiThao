<%@ page import="java.util.*, model.Register" %>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<jsp:include page="admin-header.jsp" />

<%
    List<Register> list = (List<Register>) request.getAttribute("list");
    String categoryName = (String) request.getAttribute("categoryName");
    String type = (String) request.getAttribute("type");
%>

<!-- Custom UI styles -->
<style>
    .btn-rounded {
        border-radius: 12px !important;
        padding-left: 18px !important;
        padding-right: 18px !important;
        font-weight: 500;
    }
    .btn-reload {
        background-color: #4e73df;
        color: white;
        border: none;
        border-radius: 12px;
        box-shadow: 0 3px 8px rgba(78,115,223,0.25);
        transition: 0.2s ease-in-out;
    }
    .btn-reload:hover {
        background-color: #3b5cc4;
        box-shadow: 0 4px 12px rgba(78,115,223,0.35);
        color: white;
    }
    .spin {
        display: inline-block;
        animation: spin 1s linear infinite;
    }
    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }

    .table-rounded { border-radius: 12px !important; overflow: hidden !important; }
    .card-rounded { border-radius: 18px !important; overflow: hidden !important; }
    .card-header-rounded { border-radius: 18px 18px 0 0 !important; }
</style>


<div class="container-fluid">

    <!-- ⭐ Grid Bootstrap 5 -->
    <div class="row align-items-center mb-4">
        <div class="col-12 col-md-7">
            <h3 class="text-gray-800 m-0">Quản lí đăng ký – <%= categoryName %></h3>
        </div>

        <div class="col-12 col-md-5 text-md-end mt-3 mt-md-0">
            <form action="list-user" method="get" onsubmit="startLoading()">
                <input type="hidden" name="type" value="<%= type %>">
                <button id="reloadBtn" class="btn btn-reload btn-rounded">
                    <span id="reloadIcon"></span> Tải lại dữ liệu
                </button>
            </form>
        </div>
    </div>

    <!-- ⭐ Card -->
    <div class="card shadow-sm border-0 card-rounded">

        <div class="card-header bg-primary text-white card-header-rounded">
            <h5 class="mb-0">Danh sách người đăng ký</h5>
        </div>

        <div class="card-body">

            <!-- ⭐ Table -->
            <table class="table table-hover table-bordered table-rounded">
                <thead class="table-primary">
                <tr>
                    <th>ID</th>
                    <th>Họ và tên</th>
                    <th>Email</th>
                    <th>Điện thoại</th>
                    <th>Loại khách</th>
                    <th>Loại hội thảo</th>
                </tr>
                </thead>

                <tbody>
                <%
                    if (list != null && !list.isEmpty()) {
                        for (Register r : list) {
                %>
                <tr>
                    <td><%= r.getId() %></td>
                    <td><%= r.getName() %></td>
                    <td><%= r.getEmail() %></td>
                    <td><%= r.getPhone() %></td>
                    <td><%= r.getUserType() %></td>
                    <td><%= categoryName %></td>
                </tr>
                <%
                    }
                } else {
                %>
                <tr>
                    <td colspan="6" class="text-center py-3">
                        Chưa có ai đăng ký
                    </td>
                </tr>
                <% } %>
                </tbody>

            </table>

        </div>
    </div>
</div>


<script>
    function startLoading() {
        let icon = document.getElementById("reloadIcon");
        let btn = document.getElementById("reloadBtn");

        icon.classList.add("spin");
        btn.disabled = true;
        btn.style.opacity = "0.7";
    }
</script>

<jsp:include page="admin-footer.jsp" />
