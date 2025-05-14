<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, com.smart_hub.servlets.DBConection" %>

<%
    Connection conn = DBConection.getConnection();
	String query = "SELECT DISTINCT leave_requests.id, users.name, leave_requests.start_date, leave_requests.end_date, leave_requests.leave_reason FROM leave_requests INNER JOIN users ON leave_requests.email = users.mail WHERE leave_requests.status = 'Pending'GROUP BY leave_requests.id, users.name, leave_requests.start_date, leave_requests.end_date, leave_requests.leave_reason";
    PreparedStatement stmt = conn.prepareStatement(query);
    ResultSet rs = stmt.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Approve Leave</title>
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
	    <h2>Approve or Reject Leave Requests</h2>
	    
	    <table class="table table-bordered">
	        <thead>
	            <tr>
	                <th>Employee Name</th>
	                <th>Start Date</th>
	                <th>End Date</th>
	                <th>Reason</th>
	                <th>Action</th>
	            </tr>
	        </thead>
	        <tbody>
	            <% while (rs.next()) { %>
	            <tr>
	                <td><%= rs.getString("name") %></td>
	                <td><%= rs.getString("start_date") %></td>
	                <td><%= rs.getString("end_date") %></td>
	                <td><%= rs.getString("leave_reason") %></td>
	                <td>
	                    <form method="POST" action="approve_reject_leave.jsp">
	                        <input type="hidden" name="leave_id" value="<%= rs.getInt("id") %>">
	                        <button type="submit" name="action" value="approve" class="btn btn-success btn-sm">Approve</button>
	                        <button type="submit" name="action" value="reject" class="btn btn-danger btn-sm">Reject</button>
	                    </form>
	                </td>
	            </tr>
	            <% } %>
	        </tbody>
	    </table>
	</div>
	<button type="button" class="btn btn-primary mt-3" onclick="window.location.href='leave_history.jsp'">History</button>
</div>
</body>
</html>
