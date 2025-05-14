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

    // Fetch Leave Requests
    PreparedStatement leaveStmt = conn.prepareStatement("SELECT start_date, end_date, leave_reason, status FROM leave_requests WHERE email=? ORDER BY start_date DESC");
    leaveStmt.setString(1, email);
    ResultSet rsLeaves = leaveStmt.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="ISO-8859-1">
    <title>Leave Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .main-content { margin-left: 300px; padding: 20px; transition: margin-left 0.3s; }
        .card { border-radius: 10px; box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1); }
        .card:hover { transform: translateY(-5px); box-shadow: 0px 6px 12px rgba(0, 0, 0, 0.15); }
        .leave-table th, .leave-table td { text-align: center; }
        .btn-apply { transition: all 0.3s; }
        .btn-apply:hover { transform: scale(1.05); }
        .custom-alert {position: relative; margin-top: 20px; font-size: 1rem; border-radius: 8px;padding: 15px 20px; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05); transition: all 0.3s ease-in-out;}
		@media (max-width: 768px) {
        .custom-alert { font-size: 0.9rem; padding: 12px 16px; }
    }}
    </style>
</head>
<body>
<%@ include file="navbar.jsp" %>
<jsp:include page="sidebar.jsp" />

<div class="main-content">
    <h2><i class="fa-solid fa-calendar-check"></i> Leave Management</h2>
    
    <%
    String statusMsg = (String) request.getAttribute("status");
    String message = (String) request.getAttribute("message");
    if (statusMsg != null && message != null) {
        String alertClass = "info";
        if ("success".equals(statusMsg)) alertClass = "success";
        else if ("error".equals(statusMsg)) alertClass = "danger";
	%>
	    <div class="alert alert-<%= alertClass %> alert-dismissible fade show custom-alert" role="alert">
	        <%= message %>
	        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
	    </div>
	<%
	    }
	%>
    
    
    <!-- Leave Balance Section -->
    <div class="row mt-4">
        <div class="col-md-4">
            <div class="card p-3 text-center">
                <h5>Total Leaves</h5>
                <h3><%= totalLeaves %></h3>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card p-3 text-center">
                <h5>Used Leaves</h5>
                <h3><%= usedLeaves %></h3>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card p-3 text-center">
                <h5>Remaining Leaves</h5>
                <h3><%= remainingLeaves %></h3>
            </div>
        </div>
    </div>

    <!-- Apply for Leave Form -->
    <div class="card mt-4 p-4">
        <h4><i class="fa-solid fa-user-clock"></i> Apply for Leave</h4>
        <form action="${pageContext.request.contextPath}/leave" method="post">
            <input type="hidden" name="email" value="<%= email %>">
            <div class="mb-3">
                <label class="form-label">Start Date</label>
                <input type="date" class="form-control" name="startDate" required>
            </div>
            <div class="mb-3">
                <label class="form-label">End Date</label>
                <input type="date" class="form-control" name="endDate" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Leave Reason</label>
                <select class="form-select" name="leaveReason">
                    <option value="Sick Leave">Sick Leave</option>
                    <option value="Casual Leave">Casual Leave</option>
                    <option value="Paid Leave">Paid Leave</option>
                    <option value="Emergency">Emergency</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary btn-apply"><i class="fa-solid fa-paper-plane"></i> Apply</button>
        </form>
    </div>

    <!-- Leave History -->
    <div class="card mt-4 p-4">
        <h4><i class="fa-solid fa-clock-rotate-left"></i> Leave History</h4>
        <table class="table leave-table">
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
	<script>
    // Auto-dismiss alert after 5 seconds
    window.addEventListener('DOMContentLoaded', () => {
        const alert = document.querySelector('.custom-alert');
        if (alert) {
            setTimeout(() => {
                alert.classList.remove('show');
                alert.classList.add('fade');
            }, 5000); // 5 seconds
        }
    });
	</script>
	
</body>
</html>
