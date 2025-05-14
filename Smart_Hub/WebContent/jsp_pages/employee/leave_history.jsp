<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, com.smart_hub.servlets.DBConection" %>

<%
    String email = (String) session.getAttribute("employeeEmail");
    Connection conn = DBConection.getConnection();
    
    String filter = request.getParameter("filter");
    String historyQuery = "SELECT start_date, end_date, leave_reason, status FROM leave_requests WHERE email=?";

    if ("month".equals(filter)) {
        historyQuery += " AND MONTH(start_date) = MONTH(CURDATE())";
    } else if ("week".equals(filter)) {
        historyQuery += " AND WEEK(start_date) = WEEK(CURDATE())";
    } else if ("year".equals(filter)) {
        historyQuery += " AND YEAR(start_date) = YEAR(CURDATE())";
    }

    PreparedStatement historyStmt = conn.prepareStatement(historyQuery);
    historyStmt.setString(1, email);
    ResultSet rsHistory = historyStmt.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Leave History</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f4;
        }
                .main-content { margin-left: 300px; padding: 20px; transition: margin-left 0.3s; }
        
        
        .container {
            margin-left: 300px; padding: 20px; 
        }

        .card {
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
            background: #fff;
        }

        h2 {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 15px;
            color: #333;
        }

        .form-select {
            width: 200px;
            display: inline-block;
            margin-right: 10px;
        }

        .table {
            margin-top: 20px;
            background: white;
            border-radius: 8px;
            overflow: hidden;
        }

        .table thead {
            background: #007bff;
            color: white;
        }

        .table tbody tr:hover {
            background: #f1f1f1;
        }

        .btn {
            border-radius: 6px;
        }

        .btn-primary {
            background: #007bff;
            border-color: #007bff;
        }

        .btn-secondary {
            background: #6c757d;
            border-color: #6c757d;
        }

    </style>
</head>
<body>

<%@ include file="navbar.jsp" %>
<jsp:include page="sidebar.jsp" />

<div class="main-content">
<div class="container">
    <div class="card">
        <h2>Leave History</h2>

        <form method="GET" action="leave_history.jsp">
            <label for="filter">Filter:</label>
            <select name="filter" class="form-select">
                <option value="">All</option>
                <option value="month">This Month</option>
                <option value="week">This Week</option>
                <option value="year">This Year</option>
            </select>
            <button type="submit" class="btn btn-primary btn-sm">Apply</button>
        </form>

        <table class="table table-bordered mt-3">
            <thead>
                <tr>
                    <th>Start Date</th>
                    <th>End Date</th>
                    <th>Reason</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <% while (rsHistory.next()) { %>
                <tr>
                    <td><%= rsHistory.getString("start_date") %></td>
                    <td><%= rsHistory.getString("end_date") %></td>
                    <td><%= rsHistory.getString("leave_reason") %></td>
                    <td><%= rsHistory.getString("status") %></td>
                </tr>
                <% } %>
            </tbody>
        </table>

        <a href="leave_dashboard.jsp" class="btn btn-secondary mt-3">Back to Dashboard</a>
    </div>
</div>
</div>

</body>
</html>
