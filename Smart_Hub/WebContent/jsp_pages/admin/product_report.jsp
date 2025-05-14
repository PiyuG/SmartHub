<%@ page import="java.sql.*, java.util.*, com.smart_hub.servlets.DBConection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    Connection conn = DBConection.getConnection();

    PreparedStatement salesStmt = conn.prepareStatement(
        "SELECT p.prod_id, p.name, p.price, SUM(oi.quantity) AS total_sold, SUM(oi.quantity * p.price) AS revenue " +
        "FROM order_items oi JOIN products p ON oi.product_id = p.prod_id GROUP BY p.prod_id, p.name, p.price ORDER BY revenue DESC");

    ResultSet salesRs = salesStmt.executeQuery();

    PreparedStatement totalRevenueStmt = conn.prepareStatement(
        "SELECT SUM(oi.quantity * p.price) AS total_revenue " +
        "FROM order_items oi JOIN products p ON oi.product_id = p.prod_id");
    ResultSet revRs = totalRevenueStmt.executeQuery();
    double totalRevenue = 0;
    if (revRs.next()) totalRevenue = revRs.getDouble("total_revenue");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Product Analytics & Report</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
    .main-content {
    margin-left: 260px; /* Adjust based on sidebar width */
    padding: 20px;
    transition: margin-left 0.3s;
}
        .container {
        	width:300px;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            margin: 30px;
        }
        .report-box { background: #f8f9fa; padding: 30px; border-radius: 10px; margin-top: 30px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .highlight { font-weight: bold; font-size: 20px; color: #198754; }
    </style>
</head>
<body>
<jsp:include page="navbar.jsp"/>
<jsp:include page="sidebar.jsp"/>
<div class="main-content">
<div class="container report-box">
    <h2 class="mb-4">📊 Product Analytics Report</h2>
    <p>Total Revenue Generated: <span class="highlight">₹<%= totalRevenue %></span></p>

    <table class="table table-bordered mt-4">
        <thead class="table-dark">
            <tr>
                <th>Product ID</th>
                <th>Name</th>
                <th>Price</th>
                <th>Total Sold</th>
                <th>Revenue</th>
            </tr>
        </thead>
        <tbody>
        <% while (salesRs.next()) { %>
            <tr>
                <td><%= salesRs.getInt("prod_id") %></td>
                <td><%= salesRs.getString("name") %></td>
                <td>₹<%= salesRs.getDouble("price") %></td>
                <td><%= salesRs.getInt("total_sold") %></td>
                <td>₹<%= salesRs.getDouble("revenue") %></td>
            </tr>
        <% } %>
        </tbody>
    </table>
</div>

</body>
</html>
