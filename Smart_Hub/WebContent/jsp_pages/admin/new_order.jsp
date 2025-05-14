<%@ page import="java.sql.*" %>
<%@ page import="com.smart_hub.servlets.DBConection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    int newOrders = 0;

    try {
        conn = DBConection.getConnection();
        stmt = conn.prepareStatement("SELECT COUNT(*) AS newOrders FROM orders WHERE status = 'Processing'");
        rs = stmt.executeQuery();
        if (rs.next()) {
            newOrders = rs.getInt("newOrders");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>New Orders Notification</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        .main-content { margin-left: 260px; padding: 20px; transition: margin-left 0.3s; }
        .container { width: 70%; margin: 40px auto; padding: 20px; background: #fff; border-radius: 10px; box-shadow: 0px 4px 20px rgba(0, 0, 0, 0.1); }
    </style>
</head>
<body>
<jsp:include page="navbar.jsp" />
<jsp:include page="sidebar.jsp" />
<div class="main-content">
<div class="container mt-5">

    <h2 class="mb-4">New Order Notifications</h2>

    <% if (newOrders > 0) { %>
        <div class="alert alert-info d-flex justify-content-between align-items-center">
            <div>
                <i class="bi bi-bell-fill"></i> <strong>You have <%= newOrders %> new pending order(s).</strong>
            </div>
            <a href="<%= request.getContextPath() %>/jsp_pages/admin/admin_orders.jsp" class="btn btn-sm btn-primary mt-2">
    View Orders
</a>
            
        </div>
    <% } else { %>
        <div class="alert alert-success">
            <i class="bi bi-check-circle-fill"></i> No new orders at the moment.
        </div>
    <% } %>

</div>
</div>
</body>
</html>
