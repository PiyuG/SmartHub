<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.smart_hub.servlets.DBConection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    Connection conn = DBConection.getConnection();
    PreparedStatement stmt = conn.prepareStatement("SELECT * FROM products WHERE stock < 10 ORDER BY stock ASC");
    ResultSet rs = stmt.executeQuery();

    List<Map<String, Object>> lowStockProducts = new ArrayList<>();
    while (rs.next()) {
        Map<String, Object> p = new HashMap<>();
        p.put("name", rs.getString("name"));
        p.put("stock", rs.getInt("stock"));
        lowStockProducts.add(p);
    }

    rs.close();
    stmt.close();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Low Stock Alerts</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
    .main-content { margin-left: 260px; padding: 20px; transition: margin-left 0.3s; }
        .container { width: 70%; margin: 40px auto; padding: 20px; background: #fff; border-radius: 10px; box-shadow: 0px 4px 20px rgba(0, 0, 0, 0.1); }
        
        .notif-unread {
            background-color: #f8f9fa;
            border-left: 4px solid #0d6efd;
        }
        .notif-read {
            background-color: #fff;
        }
    </style>
</head>
<body>
<jsp:include page="navbar.jsp" />
<jsp:include page="sidebar.jsp" />
<div class="main-content">
<div class="container mt-5">
    <h2 class="mb-4">Low Stock Products</h2>

    <% if (lowStockProducts.isEmpty()) { %>
        <div class="alert alert-success">
            All products have sufficient stock.
        </div>
    <% } else { %>
        <div class="alert alert-warning">
            <strong>Warning!</strong> The following products are low in stock:
        </div>

        <table class="table table-bordered table-striped">
            <thead class="table-dark">
                <tr>
                    <th>Product Name</th>
                    <th>Stock Remaining</th>
                </tr>
            </thead>
            <tbody>
            <% for (Map<String, Object> product : lowStockProducts) { %>
                <tr>
                    <td><%= product.get("name") %></td>
                    <td><%= product.get("stock") %></td>
                </tr>
            <% } %>
            </tbody>
        </table>
    <% } %>
</div>
</div>
</body>
</html>
