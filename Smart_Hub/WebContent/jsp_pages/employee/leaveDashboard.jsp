<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, com.smart_hub.servlets.DBConection" %>

<%
    String email = (String) session.getAttribute("employeeEmail");
    Connection conn = DBConection.getConnection();

    // Fetch Leave Balance
    PreparedStatement stmt = conn.prepareStatement("SELECT total_leaves, used_leaves, remaining_leaves FROM leave_balance WHERE email=?");
    stmt.setString(1, email);
    ResultSet rs = stmt.executeQuery();
    
    int totalLeaves = 20, usedLeaves = 0, remainingLeaves = 20;
    if (rs.next()) {
        totalLeaves = rs.getInt("total_leaves");
        usedLeaves = rs.getInt("used_leaves");
        remainingLeaves = rs.getInt("remaining_leaves");
    }

    // Fetch Recent Leave Requests
    PreparedStatement leaveStmt = conn.prepareStatement("SELECT start_date, end_date, leave_reason, status FROM leave_requests WHERE email=? ORDER BY start_date DESC LIMIT 5");
    leaveStmt.setString(1, email);
    ResultSet rsLeaves = leaveStmt.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="ISO-8859-1">
    <title>Leave Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body { background-color: #f8f9fa; }
        .main-content { margin-left: 300px; padding: 20px; transition: margin-left 0.3s; }
        .card { border-radius: 10px; box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1); }
        .card:hover { transform: translateY(-5px); box-shadow: 0px 6px 12px rgba(0, 0, 0, 0.15); }
        .table th, .table td { text-align: center; }
        .chart-container { width: 100%; max-width: 400px; margin: auto; }
    </style>
</head>
<body>

<%@ include file="navbar.jsp" %>
<jsp:include page="sidebar.jsp" />

<div class="main-content">
    <h2><i class="fa-solid fa-calendar-check"></i> Leave Dashboard</h2>

    <!-- Leave Summary -->
    <div class="row mt-4">
        <div class="col-md-4">
            <div class="card p-3 text-center bg-primary text-white">
                <h5>Total Leaves</h5>
                <h3><%= totalLeaves %></h3>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card p-3 text-center bg-warning text-white">
                <h5>Used Leaves</h5>
                <h3><%= usedLeaves %></h3>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card p-3 text-center bg-success text-white">
                <h5>Remaining Leaves</h5>
                <h3><%= remainingLeaves %></h3>
            </div>
        </div>
    </div>

    <!-- Leave Utilization Chart -->
    <div class="card mt-4 p-4 text-center">
        <h4><i class="fa-solid fa-chart-pie"></i> Leave Utilization</h4>
        <div class="chart-container">
            <canvas id="leaveChart"></canvas>
        </div>
    </div>

    <!-- Recent Leave Requests -->
    <div class="card mt-4 p-4">
        <h4><i class="fa-solid fa-clock-rotate-left"></i> Recent Leave Requests</h4>
        <table class="table table-bordered">
            <thead class="table-dark">
                <tr>
                    <th>Start Date</th>
                    <th>End Date</th>
                    <th>Reason</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <% while (rsLeaves.next()) { %>
                <tr>
                    <td><%= rsLeaves.getString("start_date") %></td>
                    <td><%= rsLeaves.getString("end_date") %></td>
                    <td><%= rsLeaves.getString("leave_reason") %></td>
                    <td>
                        <% 
                            String status = rsLeaves.getString("status");
                            String badgeClass = status.equals("Approved") ? "success" : status.equals("Rejected") ? "danger" : "warning";
                        %>
                        <span class="badge bg-<%= badgeClass %>"><%= status %></span>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

</div>

<!-- Chart Script -->
<script>
    var ctx = document.getElementById("leaveChart").getContext("2d");
    var leaveChart = new Chart(ctx, {
        type: "doughnut",
        data: {
            labels: ["Used Leaves", "Remaining Leaves"],
            datasets: [{
                data: [<%= usedLeaves %>, <%= remainingLeaves %>],
                backgroundColor: ["#FFC107", "#28A745"]
            }]
        }
    });
</script>

</body>
</html>
