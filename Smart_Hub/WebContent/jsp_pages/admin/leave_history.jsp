<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, com.smart_hub.servlets.DBConection" %>

<%
    String employeeName = request.getParameter("employee_name");
    String statusFilter = request.getParameter("status");
    String dateFilter = request.getParameter("date");

    Connection conn = DBConection.getConnection();
    String query = "SELECT DISTINCT users.name, leave_requests.start_date, leave_requests.end_date, leave_requests.status FROM leave_requests INNER JOIN users ON leave_requests.email = users.mail WHERE 1=1";
    
    if (employeeName != null && !employeeName.isEmpty()) {
        query += " AND users.name LIKE ?";
    }
    if (statusFilter != null && !statusFilter.isEmpty()) {
        query += " AND leave_requests.status = ?";
    }
    if (dateFilter != null && !dateFilter.isEmpty()) {
        query += " AND leave_requests.start_date >= ?";
    }

    PreparedStatement stmt = conn.prepareStatement(query);
    int paramIndex = 1;

    if (employeeName != null && !employeeName.isEmpty()) {
        stmt.setString(paramIndex++, "%" + employeeName + "%");
    }
    if (statusFilter != null && !statusFilter.isEmpty()) {
        stmt.setString(paramIndex++, statusFilter);
    }
    if (dateFilter != null && !dateFilter.isEmpty()) {
        stmt.setString(paramIndex++, dateFilter);
    }

    ResultSet rs = stmt.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Leave History</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .main-content { margin-left: 260px; padding: 20px; transition: margin-left 0.3s; }
    </style>
</head>
<body>
<%@ include file="navbar.jsp" %>
<jsp:include page="sidebar.jsp" />
<div class="main-content">
	<div class="container mt-4">
	    <h2>Leave History</h2>
	
	    <form method="GET" action="leave_history.jsp" class="mb-3">
	        <input type="text" name="employee_name" class="form-control d-inline-block w-25" placeholder="Search by Employee Name">
	        <select name="status" class="form-select d-inline-block w-25">
	            <option value="">All</option>
	            <option value="Approved">Approved</option>
	            <option value="Rejected">Rejected</option>
	        </select>
	        <input type="date" name="date" class="form-control d-inline-block w-25">
	        <button type="submit" class="btn btn-primary btn-sm">Filter</button>
	    </form>
	
	    <table class="table table-bordered">
	        <thead>
	            <tr>
	                <th>Employee Name</th>
	                <th>Start Date</th>
	                <th>End Date</th>
	                <th>Status</th>
	            </tr>
	        </thead>
	        <tbody>
	            <% while (rs.next()) { %>
	            <tr>
	                <td><%= rs.getString("name") %></td>
	                <td><%= rs.getString("start_date") %></td>
	                <td><%= rs.getString("end_date") %></td>
	                <td><%= rs.getString("status") %></td>
	            </tr>
	            <% } %>
	        </tbody>
	    </table>
	</div>
</div>
</body>
</html>
