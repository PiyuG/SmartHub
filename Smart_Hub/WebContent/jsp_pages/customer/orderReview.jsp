<%@ page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<%@ page import="com.smart_hub.servlets.DBConection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Review Your Order</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <style>
    	.main-content { margin-left: 260px; padding: 20px; transition: margin-left 0.3s; }
        .container { width: 100%; max-width: 900px; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); }
        .container { max-width: 900px; margin-top: 150px; margin-left: 260px; background: #fff; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .address-box { background-color: #f8f9fa; padding: 15px; border-radius: 8px; margin-bottom: 20px; }
        .product-img { width: 50px; height: 50px; object-fit: cover; border-radius: 5px; }
        .text-end { text-align: right; font-weight: 500; font-size: 18px; }
    </style>
</head>
<body>
<%@ include file="navbar.jsp" %>
<jsp:include page="sidebar.jsp" />

<div class="main-content">
    <div class="container">
        <h2 class="mb-4 text-center">Review Your Order</h2>

        <div class="address-box">
            <h5>Shipping Address</h5>
            <p>
                <strong>Name:</strong> <%= request.getParameter("name") %><br>
                <strong>Phone:</strong> <%= request.getParameter("phone") %><br>
                <strong>Pincode:</strong> <%= request.getParameter("pincode") %><br>
                <strong>Address:</strong> <%= request.getParameter("address") %>
            </p>
        </div>

        <form id="orderForm" action="${pageContext.request.contextPath}/placeOrderServlet" method="post">
            <input type="hidden" name="fullname" value="<%= request.getParameter("name") %>">
            <input type="hidden" name="phone" value="<%= request.getParameter("phone") %>">
            <input type="hidden" name="pincode" value="<%= request.getParameter("pincode") %>">
            <input type="hidden" name="address" value="<%= request.getParameter("address") %>">

            <table class="table table-bordered">
                <thead>
                <tr>
                    <th>Image</th>
                    <th>Product</th>
                    <th>Price</th>
                    <th>Qty</th>
                    <th>Total</th>
                </tr>
                </thead>
                <tbody>
                <%
                    int userId = (int) session.getAttribute("user_id");
                    Connection conn = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;
                    double grandTotal = 0;

                    try {
                        conn = DBConection.getConnection();
                        String sql = "SELECT p.name, p.price, c.quantity, c.image, (p.price * c.quantity) AS total " +
                                     "FROM cart c JOIN products p ON c.product_id = p.prod_id WHERE c.user_id=?";
                        stmt = conn.prepareStatement(sql);
                        stmt.setInt(1, userId);
                        rs = stmt.executeQuery();

                        while (rs.next()) {
                            String product = rs.getString("name");
                            double price = rs.getDouble("price");
                            int qty = rs.getInt("quantity");
                            double total = rs.getDouble("total");
                            String image = rs.getString("image");
                            grandTotal += total;
                %>
                    <tr>
                        <td><img src="<%= request.getContextPath() + "/" + image %>" class="product-img"></td>
                        <td><%= product %></td>
                        <td>₹<%= price %></td>
                        <td><%= qty %></td>
                        <td>₹<%= total %></td>
                    </tr>
                <%
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    } finally {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    }
                %>
                </tbody>
            </table>

            <h4 class="text-end">Grand Total: ₹<%= grandTotal %></h4>

            <div class="mb-3">
                <label>Select Payment Mode</label>
                <select class="form-select" name="paymentMode" id="paymentMode" required>
                    <option value="">-- Select --</option>
                    <option value="cod">Cash on Delivery</option>
                    <option value="online">Online Payment</option>
                </select>
            </div>

            <div class="text-end">
                <button type="submit" class="btn btn-primary">Proceed</button>
            </div>
        </form>

        <form id="paymentRedirectForm" action="payment.jsp" method="post" style="display:none;">
            <input type="hidden" name="fullname" value="<%= request.getParameter("name") %>">
            <input type="hidden" name="phone" value="<%= request.getParameter("phone") %>">
            <input type="hidden" name="pincode" value="<%= request.getParameter("pincode") %>">
            <input type="hidden" name="address" value="<%= request.getParameter("address") %>">
        </form>

    </div>
</div>

<script>
    document.getElementById('orderForm').addEventListener('submit', function (e) {
        const paymentMode = document.getElementById('paymentMode').value;
        if (paymentMode === 'online') {
            e.preventDefault();
            document.getElementById('paymentRedirectForm').submit();
        }
    });
</script>
</body>
</html>
