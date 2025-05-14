<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, com.smart_hub.servlets.DBConection,java.sql.Date" %>
<%
    String deliveryEmail = (String) session.getAttribute("employeeEmail");
    Connection conn = DBConection.getConnection();

    PreparedStatement ps = conn.prepareStatement(
        "SELECT o.*, c.name AS customer_name, c.phone, c.address FROM orders o " +
        "JOIN customer c ON o.customer_id = c.id " +
        "WHERE o.delivery_boy_email = ? AND o.status IN ('Shipped', 'Out for Delivery') ORDER BY o.order_date ASC");
    ps.setString(1, deliveryEmail);
    ResultSet rs = ps.executeQuery();

    PreparedStatement itemStmt = conn.prepareStatement(
        "SELECT p.name, p.image, p.price, oi.quantity FROM order_items oi " +
        "JOIN products p ON oi.product_id = p.prod_id WHERE oi.order_id = ?");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Assigned Deliveries</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
    	.main-content { margin-left: 260px; padding: 20px; transition: margin-left 0.3s; }
        .container { width: 70%; margin: 40px auto; padding: 20px; background: #fff; border-radius: 10px; box-shadow: 0px 4px 20px rgba(0, 0, 0, 0.1); }
        .card { margin-bottom: 20px; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .card-header { background-color: #f0f0f0; font-weight: bold; }
        .product-img { width: 60px; height: 60px; object-fit: cover; border-radius: 8px; }
        .btn-download { background-color: teal; color: white; }
    </style>
</head>
<body>
<jsp:include page="navbar.jsp" />
<jsp:include page="sidebar.jsp" />
<div class="main-content">
<div class="container mt-4">
    <h3 class="text-center mb-4">Assigned Deliveries</h3>

    <%
        while (rs.next()) {
            int orderId = rs.getInt("order_id");
            Date orderDate = rs.getDate("order_date");
            String status = rs.getString("status");
            String customerName = rs.getString("customer_name");
            String phone = rs.getString("phone");
            String address = rs.getString("address");
            String paymentMode = rs.getString("payment_mode");

            itemStmt.setInt(1, orderId);
            ResultSet itemsRs = itemStmt.executeQuery();

            double total = 0;
    %>

    <div class="card">
        <div class="card-header d-flex justify-content-between">
            <span>Order ID: <%= orderId %></span>
            <span>Status: <%= status %></span>
        </div>
        <div class="card-body">
            <p><strong>Order Date:</strong> <%= orderDate %></p>
            <p><strong>Customer:</strong> <%= customerName %></p>
            <p><strong>Phone:</strong> <%= phone %></p>
            <p><strong>Address:</strong> <%= address %></p>
            <p><strong>Payment Mode:</strong> <%= paymentMode %></p>

            <h5 class="mt-3">Products:</h5>
            <table class="table table-sm">
                <thead>
                    <tr>
                        <th>Product</th>
                        <th>Name</th>
                        <th>Price</th>
                        <th>Qty</th>
                        <th>Subtotal</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    while (itemsRs.next()) {
                        String name = itemsRs.getString("name");
                        String img = itemsRs.getString("image");
                        double price = itemsRs.getDouble("price");
                        int qty = itemsRs.getInt("quantity");
                        double subtotal = price * qty;
                        total += subtotal;
                %>
                    <tr>
                        <td><img src="<%= request.getContextPath() + "/" + img %>" class="product-img" /></td>
                        <td><%= name %></td>
                        <td>₹<%= price %></td>
                        <td><%= qty %></td>
                        <td>₹<%= subtotal %></td>
                    </tr>
                <%
                    }
                    itemsRs.close();
                %>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="4" class="text-end"><strong>Total:</strong></td>
                        <td><strong>₹<%= total %></strong></td>
                    </tr>
                </tfoot>
            </table>

            <div class="d-flex justify-content-between mt-3">
                <form action="${pageContext.request.contextPath}/UpdateOrderStatusShipped" method="post">
                    <input type="hidden" name="orderId" value="<%= orderId %>">
                    <input type="hidden" name="status" value="Delivered">
                    <button type="submit" class="btn btn-success">Mark as Delivered</button>
                </form>

                <a href="<%= request.getContextPath() + "/jsp_pages/admin/print_invoice.jsp?orderId=" + orderId %>" target="_blank" class="btn btn-download">Download Invoice</a>
            </div>
        </div>
    </div>

    <% } %>
</div>
</div>
</body>
</html>
