<%@ page import="java.sql.*, com.smart_hub.servlets.DBConection" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String orderIdParam = request.getParameter("orderId");
    int orderId = Integer.parseInt(orderIdParam);

    Connection conn = DBConection.getConnection();

    PreparedStatement orderStmt = conn.prepareStatement(
        "SELECT o.*, c.name, c.mail, c.phone, c.address FROM orders o JOIN customer c ON o.customer_id = c.id WHERE o.order_id = ?");
    orderStmt.setInt(1, orderId);
    ResultSet orderRs = orderStmt.executeQuery();

    PreparedStatement itemStmt = conn.prepareStatement(
        "SELECT p.name, p.price, oi.quantity FROM order_items oi JOIN products p ON oi.product_id = p.prod_id WHERE oi.order_id = ?");
    itemStmt.setInt(1, orderId);
    ResultSet itemRs = itemStmt.executeQuery();

    double total = 0;
    String customerName = "", email = "", phone = "", address = "", orderDate = "";
    if (orderRs.next()) {
        customerName = orderRs.getString("name");
        email = orderRs.getString("mail");
        phone = orderRs.getString("phone");
        address = orderRs.getString("address");
        orderDate = new SimpleDateFormat("yyyy-MM-dd").format(orderRs.getDate("order_date"));
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Invoice #<%= orderId %></title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { padding: 40px; font-family: Arial, sans-serif; }
        .invoice-box { border: 1px solid #ddd; padding: 30px; border-radius: 10px; }
        .invoice-header { border-bottom: 2px solid #333; padding-bottom: 10px; margin-bottom: 30px; }
        .invoice-title { font-size: 28px; font-weight: bold; }
        .table th, .table td { vertical-align: middle; }
        .no-print { display: none; }
        @media print {
            .no-print { display: none; }
        }
    </style>
</head>
<body onload="window.print()">
<div class="invoice-box">
    <div class="invoice-header d-flex justify-content-between">
        <div>
            <div class="invoice-title">SmartHub Invoice</div>
            <div>Invoice ID: <strong>#<%= orderId %></strong></div>
            <div>Date: <strong><%= orderDate %></strong></div>
        </div>
        <div class="text-end">
            <strong>Mahalakshmi Store</strong><br>
            admin@smarthub.com<br>
            +91-9876543210
        </div>
    </div>

    <div class="mb-4">
        <strong>Bill To:</strong><br>
        <%= customerName %><br>
        <%= email %><br>
        <%= phone %><br>
        <%= address %>
    </div>

    <table class="table table-bordered">
        <thead class="table-light">
        <tr>
            <th>#</th>
            <th>Product</th>
            <th>Price</th>
            <th>Qty</th>
            <th>Subtotal</th>
        </tr>
        </thead>
        <tbody>
        <%
            int count = 1;
            while (itemRs.next()) {
                String pname = itemRs.getString("name");
                double price = itemRs.getDouble("price");
                int qty = itemRs.getInt("quantity");
                double subtotal = price * qty;
                total += subtotal;
        %>
        <tr>
            <td><%= count++ %></td>
            <td><%= pname %></td>
            <td>₹<%= price %></td>
            <td><%= qty %></td>
            <td>₹<%= subtotal %></td>
        </tr>
        <% } %>
        </tbody>
        <tfoot>
        <tr>
            <th colspan="4" class="text-end">Total</th>
            <th>₹<%= total %></th>
        </tr>
        </tfoot>
    </table>

    <p class="text-center mt-4">Thank you for shopping with SmartHub!</p>
</div>

</body>
</html>
