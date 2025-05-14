<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, java.util.*, com.smart_hub.servlets.DBConection" %>

<%
    String email = (String) session.getAttribute("email");
    String employeeName = request.getParameter("employee_name");
    String filter = request.getParameter("filter");

    Connection conn = DBConection.getConnection();
    String query = "SELECT users.name, attendance.date, MIN(attendance.check_in) as check_in, MAX(attendance.check_out) as check_out " +
            "FROM attendance INNER JOIN users ON attendance.email = users.mail WHERE 1=1 ";

    if (employeeName != null && !employeeName.trim().isEmpty()) {
        query += " AND users.name LIKE ?";
    } else {
        query += " AND attendance.email=?";
    }

    if ("today".equals(filter)) {
        query += " AND attendance.date = CURDATE()";
    } else if ("week".equals(filter)) {
        query += " AND WEEK(attendance.date) = WEEK(CURDATE())";
    } else if ("month".equals(filter)) {
        query += " AND MONTH(attendance.date) = MONTH(CURDATE())";
    } else if ("year".equals(filter)) {
        query += " AND YEAR(attendance.date) = YEAR(CURDATE())";
    }

    query += " GROUP BY users.name, attendance.date"; // Ensures proper grouping

    PreparedStatement stmt = conn.prepareStatement(query);
    
    if (employeeName != null && !employeeName.trim().isEmpty()) {
        stmt.setString(1, "%" + employeeName + "%");
    } else {
        stmt.setString(1, email);
    }

    ResultSet rs = stmt.executeQuery();
    boolean hasRecords = false;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>View Attendance</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .main-content { margin-left: 260px; padding: 20px; transition: margin-left 0.3s; }
        .container { max-width: 1000px; margin: auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); }
        .card { padding: 20px; border-radius: 10px; box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1); background: #fff; }
        h2 { font-size: 24px; font-weight: bold; margin-bottom: 15px; color: #333; }
        .table { margin-top: 20px; background: white; border-radius: 8px; overflow: hidden; }
        .table thead { background: #007bff; color: white; }
        .table tbody tr:hover { background: #f1f1f1; }
        .form-select, .form-control { width: 200px; display: inline-block; margin-right: 10px; }
        .btn { border-radius: 6px; }
    </style>
</head>
<body>
<%@ include file="navbar.jsp" %>
<jsp:include page="sidebar.jsp" />

<div class="main-content">
<div class="container">
    <div class="card">
        <h2>View Attendance</h2>

        <form method="GET" action="attendance.jsp">
            <label for="filter">Filter:</label>
            <select name="filter" class="form-select">
                <option value="">All</option>
                <option value="today">Today</option>
                <option value="week">This Week</option>
                <option value="month">This Month</option>
                <option value="year">This Year</option>
            </select>

            <input type="text" name="employee_name" class="form-control" placeholder="Search by Employee Name" 
                   value="<%= (employeeName != null) ? employeeName : "" %>">

            <button type="submit" class="btn btn-primary btn-sm">Apply</button>
        </form>

        <table class="table table-bordered mt-3">
            <thead>
                <tr>
                    <th>Employee Name</th>
                    <th>Date</th>
                    <th>Check-in Time</th>
                    <th>Check-out Time</th>
                </tr>
            </thead>
            <tbody>
                <% while (rs.next()) { hasRecords = true; %>
                <tr>
                    <td><%= rs.getString("name") %></td>
                    <td><%= rs.getString("date") %></td>
                    <td><%= (rs.getString("check_in") != null) ? rs.getString("check_in") : "Not Checked-in" %></td>
                    <td><%= (rs.getString("check_out") != null) ? rs.getString("check_out") : "Not Checked-out" %></td>
                </tr>
                <% } 
                if (!hasRecords) { // Show message if no records exist %>
                <tr>
                    <td colspan="4" class="text-center text-muted">No attendance records found</td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>
</div>

</body>
</html>
