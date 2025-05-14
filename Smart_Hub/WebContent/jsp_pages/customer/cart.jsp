<%@ page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<%@ page import="com.smart_hub.servlets.DBConection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Shopping Cart</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f9f9f9;
            font-family: 'Segoe UI', sans-serif;
        }
        .main-content { margin-left: 260px; padding: 20px; transition: margin-left 0.3s; }
        .container { width: 100%; max-width: 900px; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); }
        h2 {
            color: #333;
            font-weight: 600;
        }

        .table {
            border-radius: 8px;
            overflow: hidden;
        }

        .table th {
            background-color: #f1f1f1;
            color: #333;
            text-align: center;
        }

        .table td {
            vertical-align: middle;
            text-align: center;
        }

        .table tbody tr:hover {
            background-color: #f8f9fa;
        }

        .btn-danger, .btn-success {
            border-radius: 6px;
            padding: 6px 16px;
            font-weight: 500;
        }

        img.product-image {
            width: 80px;
            height: auto;
            border-radius: 8px;
        }
        .product-pic { width: 40px; height: 40px; border-radius: 50%; margin-right: 10px; }

        .text-end, .float-end {
            margin-top: 20px;
            font-size: 18px;
            font-weight: 600;
        }

        /* Message Box Styling */
        .message-container {
            width: 300px;
            margin: 20px auto;
            padding: 20px;
            text-align: center;
            border-radius: 20px;
            background-color: #fff;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            font-family: 'Segoe UI', sans-serif;
        }
        .message-container .icon {
            font-size: 36px;
            color: white;
            width: 70px;
            height: 70px;
            margin: 0 auto 10px;
            border-radius: 50%;
            line-height: 70px;
            font-weight: bold;
        }
        .message-container.success .icon {
            background-color: #28a745;
            box-shadow: 0 0 15px #28a74588;
        }
        .message-container.error .icon {
            background-color: #dc3545;
            box-shadow: 0 0 15px #dc354588;
        }
        .message-container .title {
            color: #888;
            margin: 5px 0;
        }
        .message-container .message {
            font-size: 18px;
            font-weight: 600;
        }
        .message-container.success {
            border-bottom: 8px solid #28a745;
        }
        .message-container.error {
            border-bottom: 8px solid #dc3545;
        }
        .message-container {
    		opacity: 1;
		}

        @media (max-width: 768px) {
            .container {
                margin-left: 0;
                padding: 20px;
            }
            .table {
                font-size: 14px;
            }
        }
    </style>
</head>
<body>
<%@ include file="navbar.jsp" %>
<jsp:include page="sidebar.jsp" />
<div class="main-content">
<div class="container">

    <!-- Order Status Message -->
    <%
        String orderStatus = request.getParameter("order");
    %>

    <% if ("success".equals(orderStatus)) { %>
        <div class="message-container success">
            <div class="icon">&#10004;</div>
            <p class="title">Order Status</p>
            <p class="message">Order Successfully Placed</p>
        </div>
    <% } else if ("error".equals(orderStatus)) { %>
        <div class="message-container error">
            <div class="icon">&#10006;</div>
            <p class="title">Order Status</p>
            <p class="message">Something Went Wrong</p>
        </div>
    <% } %>

    <h2 class="text-center my-4">Your Cart</h2>
    <table class="table table-bordered">
        <thead>
        <tr>
            <th>Product</th>
            <th>Price</th>
            <th>Quantity</th>
            <th>Total</th>
            <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <%
            int userId = (int) session.getAttribute("user_id"); // Assuming user is logged in
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            double grandTotal = 0;

            try {
                conn = DBConection.getConnection();
                String sql = "SELECT c.id, p.name, p.price, c.quantity,c.image, (p.price * c.quantity) AS total " +
                        "FROM cart c JOIN products p ON c.product_id = p.prod_id WHERE c.user_id=?";
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, userId);
                rs = stmt.executeQuery();

                while (rs.next()) {
                    int cartId = rs.getInt("id");
                    String image = rs.getString("image");
                    String productName = rs.getString("name");
                    double price = rs.getDouble("price");
                    int quantity = rs.getInt("quantity");
                    double total = rs.getDouble("total");
                    grandTotal += total;
        %>
        <tr>
            <td><img src="<%= request.getContextPath() + "/" + image %>" class="product-pic"></td>
            <td><%= productName %></td>
            <td>₹<%= price %></td>
            <td><%= quantity %></td>
            <td>₹<%= total %></td>
            <td>
                <form action="${pageContext.request.contextPath}/removeFromCartServlet" method="post">
                    <input type="hidden" name="cart_id" value="<%= cartId %>">
                    <button type="submit" class="btn btn-danger">Remove</button>
                </form>
            </td>
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
    <a href="checkout.jsp" class="btn btn-success float-end">Proceed to Checkout</a>
</div>
</div>
<script>
    setTimeout(() => {
        const msg = document.querySelector('.message-container');
        if (msg) {
            msg.style.transition = 'opacity 0.8s ease';
            msg.style.opacity = '0';
            setTimeout(() => msg.style.display = 'none', 800);
        }
    }, 5000); // 5 seconds
</script>
</body>
</html>
