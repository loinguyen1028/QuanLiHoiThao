<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="dto.GuestStatDTO" %>
<%@ page import="java.util.List" %>
<jsp:include page="admin-header.jsp" />
<div class="container-fluid">
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">Dashboard Thống Kê</h1>
        <a href="<%= request.getContextPath() %>/export_csv" class="d-none d-sm-inline-block btn btn-sm btn-success shadow-sm">
            <i class="fas fa-download fa-sm text-white-50"></i> Xuất báo cáo (.csv)
        </a>
    </div>

    <div class="row">
        <div class="col-xl-12 col-lg-12">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Xu hướng đăng ký theo thời gian</h6>
                </div>
                <div class="card-body">
                    <div class="chart-area">
                        <canvas id="myAreaChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-lg-12">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Thống kê theo Loại khách & Check-in</h6>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered" width="100%" cellspacing="0">
                            <thead>
                            <tr class="bg-light">
                                <th>Loại khách</th>
                                <th>Tổng đăng ký</th>
                                <th>Đã Check-in</th>
                                <th>Tỷ lệ Check-in</th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                List<GuestStatDTO> list = (List<GuestStatDTO>) request.getAttribute("guestStats");
                                if(list != null) {
                                    for(GuestStatDTO item : list) {
                                        double rate = item.getTotalRegistered() > 0 ?
                                                ((double)item.getTotalCheckedIn() / item.getTotalRegistered() * 100) : 0;
                            %>
                            <tr>
                                <td><%= item.getGuestType() %></td>
                                <td><strong><%= item.getTotalRegistered() %></strong></td>
                                <td><%= item.getTotalCheckedIn() %></td>
                                <td>
                                    <div class="progress">
                                        <div class="progress-bar bg-info" role="progressbar"
                                             style="width: <%= (int)rate %>%">
                                            <%=String.format("%.1f", rate)%>%
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <% }} else { %>
                            <tr><td colspan="4" class="text-center">Chưa có dữ liệu</td></tr>
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
            // Dữ liệu được tiêm từ Servlet
            labels: <%= request.getAttribute("dateLabels") %>,
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
                // Dữ liệu số lượng
                data: <%= request.getAttribute("dateValues") %>,
            }],
        },
        options: {
            maintainAspectRatio: false,
            layout: {
                padding: {
                    left: 10,
                    right: 25,
                    top: 25,
                    bottom: 0
                }
            },
            scales: {
                xAxes: [{
                    time: {
                        unit: 'date'
                    },
                    gridLines: {
                        display: false,
                        drawBorder: false
                    },
                    ticks: {
                        maxTicksLimit: 7
                    }
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
            legend: {
                display: false
            },
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
                caretPadding: 10,
                callbacks: {

                }
            }
        }
    });
</script>
<jsp:include page="admin-footer.jsp" />