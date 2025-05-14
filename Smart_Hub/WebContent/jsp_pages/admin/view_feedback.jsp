<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ page import="com.smart_hub.servlets.DBConection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>View Customer Feedback</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" />
    <style>
        body { background: #f8f9fa; font-family: 'Segoe UI', sans-serif; }
        .main-content {
            margin-left: 260px;
            padding: 20px;
            transition: margin-left 0.3s;
        }
        .container {
            max-width: 900px;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            margin: 30px auto;
        }
        .rating { color: #ffc107; font-size: 18px; }
        .comment-box { border: 1px solid #ddd; padding: 15px; border-radius: 8px; background: #f9f9f9; }
        .product-info {
            display: flex;
            align-items: center;
            margin-top: 10px;
        }
        .product-img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            margin-right: 15px;
            border-radius: 8px;
            border: 1px solid #ccc;
        }
    </style>
</head>
<body>
<%@ include file="navbar.jsp" %>
<jsp:include page="sidebar.jsp" />
<div class="main-content">
    <div class="container">
        <h2 class="mb-4">Customer Feedback</h2>

        <%
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                conn = DBConection.getConnection();
                String sql = "SELECT f.*, c.name, o.order_date, p.name as pname, p.image " +
                             "FROM feedback f " +
                             "JOIN customer c ON f.customer_id = c.id " +
                             "JOIN orders o ON f.order_id = o.order_id " +
                             "JOIN order_items oi ON oi.order_id = o.order_id " +
                             "JOIN products p ON oi.product_id = p.prod_id " +
                             "ORDER BY f.created_at DESC";

                stmt = conn.prepareStatement(sql);
                rs = stmt.executeQuery();

                SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy hh:mm a");

                while (rs.next()) {
                    int orderId = rs.getInt("order_id");
                    String name = rs.getString("name");
                    int rating = rs.getInt("rating");
                    String comments = rs.getString("comments");
                    Timestamp createdAt = rs.getTimestamp("created_at");
                    Date orderDate = rs.getDate("order_date");
                    String productName = rs.getString("pname");
                    String productImage = rs.getString("image");
        %>

        <div class="mb-4">
            <h5>Order ID: <%= orderId %> | Customer: <%= name %></h5>
            <div class="rating">Rating:
                <% for (int i = 1; i <= 5; i++) { %>
                    <i class="bi <%= i <= rating ? "bi-star-fill" : "bi-star" %>"></i>
                <% } %>
            </div>
            <p><small>Submitted on: <%= sdf.format(createdAt) %> | Ordered on: <%= orderDate %></small></p>

            <!-- Product Info -->
            <div class="product-info">
				<img src="<%= request.getContextPath() + "/" + productImage %>" class="product-img" alt="Product Image" />
                <div><strong>Product:</strong> <%= productName %></div>
            </div>

            <!-- Comment -->
            <div class="comment-box mt-2"><%= comments %></div>
        </div>
        <hr />
        <%
                }
            } catch (Exception e) {
                out.println("<p class='text-danger'>Error loading feedback: " + e.getMessage() + "</p>");
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        %>
    </div>
</div>
</body>
</html>
