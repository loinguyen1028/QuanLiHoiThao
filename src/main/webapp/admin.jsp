<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="dto.GuestStatDTO" %>
<%@ page import="java.util.List" %>
<jsp:include page="admin-header.jsp" />

<style>
    body {
        font-family: 'Nunito', sans-serif;
        background-color: #f8f9fc;
    }

    .page-title-icon {
        width: 42px;
        height: 42px;
        border-radius: 50%;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        background: linear-gradient(135deg, #4e73df, #1cc88a);
        color: #fff;
        margin-right: 12px;
        font-size: 18px;
    }

    .btn-export {
        border-radius: 20px;
        font-size: 0.85rem;
        font-weight: 600;
        padding: 6px 18px;
        background: #1cc88a;
        border: none;
    }

    .btn-export:hover {
        background: #17a673;
        color: #fff;
        transform: translateY(-1px);
    }

    .card-dashboard {
        border-radius: 15px;
        border: none;
        box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.1);
    }

    .card-dashboard .card-header {
        border-bottom: 1px solid #e3e6f0;
        background-color: #ffffff;
        border-radius: 15px 15px 0 0 !important;
    }

    .card-dashboard .card-header h6 {
        font-weight: 700;
        color: #4e73df;
        text-transform: uppercase;
        font-size: 0.85rem;
    }

    .table-dashboard thead th {
        background-color: #f8f9fc;
        color: #4e73df;
        font-weight: 700;
        text-transform: uppercase;
        font-size: 0.8rem;
        border-bottom: 2px solid #e3e6f0;
        white-space: nowrap;
    }

    .table-dashboard td {
        vertical-align: middle;
        font-size: 0.9rem;
        padding: 12px;
    }

    .progress {
        height: 18px;
        border-radius: 999px;
        background-color: #eef1f7;
    }

    .progress-bar {
        border-radius: 999px;
        font-size: 0.75rem;
        font-weight: 600;
    }
</style>

<div class="container-fluid">

    <!-- Tiêu đề + nút export -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4 mt-2">
        <div class="d-flex align-items-center">
            <div class="page-title-icon">
                <i class="fas fa-chart-line"></i>
            </div>
            <div>
                <h1 class="h3 mb-1 text-gray-800">Dashboard Thống Kê</h1>
                <div class="text-muted small">
                    Tổng quan xu hướng đăng ký và hiệu quả check-in theo từng nhóm khách.
                </div>
            </div>
        </div>

        <a href="<%= request.getContextPath() %>/export_csv"
           class="d-none d-sm-inline-block btn btn-sm btn-export shadow-sm">
            <i class="fas fa-download fa-sm text-white-50"></i> Xuất báo cáo (.csv)
        </a>
    </div>

    <!-- Chart xu hướng -->
    <div class="row">
        <div class="col-xl-12 col-lg-12">
            <div class="card card-dashboard mb-4">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold text-primary">
                        Xu hướng đăng ký theo thời gian
                    </h6>
                </div>
                <div class="card-body">
                    <div class="chart-area" style="height: 320px;">
                        <canvas id="myAreaChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bảng thống kê loại khách -->
    <div class="row">
        <div class="col-lg-12">
            <div class="card card-dashboard mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">
                        Thống kê theo Loại khách &amp; Check-in
                    </h6>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered table-dashboard" width="100%" cellspacing="0">
                            <thead>
                            <tr>
                                <th>Loại khách</th>
                                <th>Tổng đăng ký</th>
                                <th>Đã Check-in</th>
                                <th>Tỷ lệ Check-in</th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                List<GuestStatDTO> list = (List<GuestStatDTO>) request.getAttribute("guestStats");
                                if(list != null && !list.isEmpty()) {
                                    for(GuestStatDTO item : list) {
                                        double rate = item.getTotalRegistered() > 0
                                                ? ((double)item.getTotalCheckedIn() / item.getTotalRegistered() * 100)
                                                : 0;
                            %>
                            <tr>
                                <td><strong><%= item.getGuestType() %></strong></td>
                                <td><span class="text-primary fw-bold"><%= item.getTotalRegistered() %></span></td>
                                <td><%= item.getTotalCheckedIn() %></td>
                                <td>
                                    <div class="progress">
                                        <div class="progress-bar bg-info" role="progressbar"
                                             style="width: <%= (int)rate %>%">
                                            <%= String.format("%.1f", rate) %>%
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <% }} else { %>
                            <tr>
                                <td colspan="4" class="text-center text-muted py-4">
                                    Chưa có dữ liệu
                                </td>
                            </tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="<%= request.getContextPath() %>/vendor/chart.js/Chart.min.js?v=2"></script>
<script>
    // Set font
    Chart.defaults.global.defaultFontFamily = 'Nunito';
    Chart.defaults.global.defaultFontColor = '#858796';

    var ctx = document.getElementById("myAreaChart");
    var myLineChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: <%= request.getAttribute("dateLabels") %>, // mảng ngày từ Servlet
            datasets: [{
                label: "Lượt đăng ký",
                lineTension: 0.3,
                backgroundColor: "rgba(78, 115, 223, 0.05)",
                borderColor: "rgba(78, 115, 223, 1)",
                pointRadius: 3,
                pointBackgroundColor: "rgba(78, 115, 223, 1)",
                pointBorderColor: "rgba(78, 115, 223, 1)",
                pointHoverRadius: 3,
                pointHoverBackgroundColor: "rgba(78, 115, 223, 1)",
                pointHoverBorderColor: "rgba(78, 115, 223, 1)",
                pointHitRadius: 10,
                pointBorderWidth: 2,
                data: <%= request.getAttribute("dateValues") %>, // mảng số lượng từ Servlet
            }],
        },
        options: {
            maintainAspectRatio: false,
            layout: {
                padding: { left: 10, right: 25, top: 25, bottom: 0 }
            },
            scales: {
                xAxes: [{
                    time: { unit: 'date' },
                    gridLines: { display: false, drawBorder: false },
                    ticks: { maxTicksLimit: 7 }
                }],
                yAxes: [{
                    ticks: {
                        maxTicksLimit: 5,
                        padding: 10,
                        callback: function(value, index, values) {
                            return value;
                        }
                    },
                    gridLines: {
                        color: "rgb(234, 236, 244)",
                        zeroLineColor: "rgb(234, 236, 244)",
                        drawBorder: false,
                        borderDash: [2],
                        zeroLineBorderDash: [2]
                    }
                }],
            },
            legend: { display: false },
            tooltips: {
                backgroundColor: "rgb(255,255,255)",
                bodyFontColor: "#858796",
                titleMarginBottom: 10,
                titleFontColor: '#6e707e',
                titleFontSize: 14,
                borderColor: '#dddfeb',
                borderWidth: 1,
                xPadding: 15,
                yPadding: 15,
                displayColors: false,
                intersect: false,
                mode: 'index',
                caretPadding: 10
            }
        }
    });
</script>

<jsp:include page="admin-footer.jsp" />
