<%@ page import="java.sql.*, java.util.*, com.smart_hub.servlets.DBConection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    Connection conn = DBConection.getConnection();

    PreparedStatement orderStmt = conn.prepareStatement(
        "SELECT o.*, c.mail AS customer_email FROM orders o JOIN customer c ON o.customer_id = c.id ORDER BY o.order_date DESC");
    ResultSet orderRs = orderStmt.executeQuery();

    PreparedStatement deliveryStmt = conn.prepareStatement("SELECT mail, name FROM users WHERE designation = 'Delivery Boy'");
    ResultSet deliveryRs = deliveryStmt.executeQuery();

    List<Map<String, String>> deliveryBoys = new ArrayList<>();
    while (deliveryRs.next()) {
        Map<String, String> map = new HashMap<>();
        map.put("email", deliveryRs.getString("mail"));
        map.put("name", deliveryRs.getString("name"));
        deliveryBoys.add(map);
    }

    PreparedStatement totalStmt = conn.prepareStatement(
        "SELECT SUM(oi.quantity * p.price) AS total FROM order_items oi JOIN products p ON oi.product_id = p.prod_id WHERE oi.order_id = ?");
    PreparedStatement itemStmt = conn.prepareStatement(
        "SELECT p.name, p.image, p.price, oi.quantity FROM order_items oi JOIN products p ON oi.product_id = p.prod_id WHERE oi.order_id = ?");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .order-items { display: none; margin-top: 15px; background: #f1f1f1; padding: 10px; border-radius: 8px; }
        .order-items img { width: 60px; height: 60px; object-fit: cover; }
        .main-content { margin-left: 250px; padding: 20px; }
        .btn-print { background-color: teal; color: white; }
        .message-box {
            width: 300px;
            margin: 20px auto;
            border-radius: 20px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            background: #fff;
            text-align: center;
            padding: 20px;
            position: relative;
            transition: 0.3s;
            transition: opacity 0.5s ease, transform 0.5s ease;
        }
        .message-box.success { border-top: 8px solid #28a745; }
        .message-box.error { border-top: 8px solid #dc3545; }
        .message-icon {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            margin: -60px auto 10px;
            background-color: #28a745;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 0 25px rgba(40, 167, 69, 0.6);
        }
        .message-box.error .message-icon {
            background-color: #dc3545;
            box-shadow: 0 0 25px rgba(220, 53, 69, 0.6);
        }
        .message-icon i {
            color: #fff;
            font-size: 36px;
        }
        .message-box h3 { color: #888; margin: 10px 0 5px; }
        .message-box p { font-size: 18px; font-weight: 500; }
    </style>
</head>
<body>
<jsp:include page="navbar.jsp" />
<jsp:include page="sidebar.jsp" />
<div class="main-content">
    <div class="container">
    <%
        String assignMessage = (String) request.getAttribute("assignMessage");
        if (assignMessage != null) {
            boolean isSuccess = assignMessage.toLowerCase().contains("success");
    %>
        <div class="message-box <%= isSuccess ? "success" : "error" %>">
            <div class="message-icon">
                <i class="fas <%= isSuccess ? "fa-check" : "fa-times" %>"></i>
            </div>
            <h3>Order Assignment</h3>
            <p><%= assignMessage %></p>
        </div>
    <%
        }
    %>
        <h2 class="text-center">Orders Management</h2>
        <div class="table-responsive">
            <table class="table table-bordered table-hover mt-4">
                <thead class="table-dark">
                    <tr>
                        <th>Order ID</th>
                        <th>Customer Email</th>
                        <th>Date</th>
                        <th>Total</th>
                        <th>Status</th>
                        <th>Delivery Boy</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    while (orderRs.next()) {
                        int orderId = orderRs.getInt("order_id");

                        totalStmt.setInt(1, orderId);
                        ResultSet totalRs = totalStmt.executeQuery();
                        double totalAmount = 0;
                        if (totalRs.next()) totalAmount = totalRs.getDouble("total");

                        itemStmt.setInt(1, orderId);
                        ResultSet itemsRs = itemStmt.executeQuery();

                        String assigned = orderRs.getString("delivery_boy_email");
                        boolean isAssigned = assigned != null && !assigned.trim().isEmpty();
                %>
                    <tr>
                        <td><%= orderId %></td>
                        <td><%= orderRs.getString("customer_email") %></td>
                        <td><%= orderRs.getDate("order_date") %></td>
                        <td>₹<%= totalAmount %></td>
                        <td><%= orderRs.getString("status") %></td>
                        <td>
                            <span class="badge <%= isAssigned ? "bg-success" : "bg-secondary" %>">
                                <%= isAssigned ? assigned : "Not Assigned" %>
                            </span>
                        </td>
                        <td>
                            <form action="${pageContext.request.contextPath}/AssignOrderServlet" method="post" class="d-flex mb-1">
                                <input type="hidden" name="orderId" value="<%= orderId %>">
                                <select name="deliveryEmail" class="form-select me-1" required <%= isAssigned ? "disabled" : "" %>>
                                    <option value="">Select</option>
                                    <% for (Map<String, String> boy : deliveryBoys) { %>
                                        <option value="<%= boy.get("email") %>"><%= boy.get("name") %></option>
                                    <% } %>
                                </select>
                                <button class="btn btn-primary btn-sm" <%= isAssigned ? "disabled" : "" %>>Assign</button>
                            </form>
                            <button class="btn btn-info btn-sm mb-1" onclick="toggleDetails('<%= orderId %>')">View</button>
                            <button class="btn btn-print btn-sm" onclick="printInvoice('<%= orderId %>')">Print Invoice</button>
                            <%
                                String currentStatus = orderRs.getString("status");
                                if (!"Shipped".equalsIgnoreCase(currentStatus) && !"Out for Delivery".equalsIgnoreCase(currentStatus) && !"Delivered".equalsIgnoreCase(currentStatus)) {
                            %>
                                <form action="${pageContext.request.contextPath}/UpdateOrderStatusServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="orderId" value="<%= orderId %>">
                                    <input type="hidden" name="status" value="Shipped">
                                    <button class="btn btn-warning btn-sm mt-1" type="submit">Mark as Shipped</button>
                                </form>
                            <%
                                }
                            %>
                        </td>
                    </tr>
                    <tr class="order-items" id="details-<%= orderId %>">
                        <td colspan="7">
                            <strong>Product Details:</strong>
                            <table class="table table-sm mt-2">
                                <thead>
                                    <tr>
                                        <th>Image</th>
                                        <th>Name</th>
                                        <th>Price</th>
                                        <th>Quantity</th>
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
                                %>
                                    <tr>
                                        <td><img src="<%= request.getContextPath() + "/" + img %>" alt="Product Image"></td>
                                        <td><%= name %></td>
                                        <td>₹<%= price %></td>
                                        <td><%= qty %></td>
                                        <td>₹<%= price * qty %></td>
                                    </tr>
                                <%
                                    }
                                    itemsRs.close();
                                %>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    function toggleDetails(id) {
        const row = document.getElementById("details-" + id);
        row.style.display = row.style.display === "table-row" ? "none" : "table-row";
    }

    const contextPath = '<%= request.getContextPath() %>';

    function printInvoice(orderId) {
        window.open(contextPath + '/jsp_pages/admin/print_invoice.jsp?orderId=' + orderId, '_blank');
    }

    setTimeout(function () {
        const box = document.querySelector('.message-box');
        if (box) {
            box.style.opacity = '0';
            box.style.transform = 'translateY(-20px)';
            setTimeout(() => box.remove(), 500);
        }
    }, 5000);
</script>
</body>
</html>
