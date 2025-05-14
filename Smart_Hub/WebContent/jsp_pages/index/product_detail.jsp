<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ page import="com.smart_hub.servlets.DBConection" %>
<%
    String pid = request.getParameter("pid");
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Product Details</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <style>
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background-color: #f7f8fa;
    }

    .container1 {
        background-color: white;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.07);
        margin-top:150px;
    }

    .img-fluid {
        border-radius: 10px;
        max-height: 400px;
        object-fit: contain;
        border: 1px solid #ddd;
        padding: 10px;
        background-color: #fff;
    }

    h2 {
        font-weight: 600;
        margin-bottom: 20px;
    }

    p {
        font-size: 16px;
        margin-bottom: 10px;
    }

    .text-danger {
        font-size: 20px;
        font-weight: bold;
    }

    del {
        color: #888;
        font-size: 16px;
    }

    .btn-success {
        font-size: 16px;
        padding: 10px 20px;
        border-radius: 8px;
        margin-top: 20px;
    }

    .btn-success:hover {
        background-color: #218838;
    }

    .product-info {
        padding: 20px;
        background-color: #fafafa;
        border-radius: 10px;
        border: 1px solid #eee;
    }
</style>
    
</head>
<body>
<%@ include file="header.jsp" %>
<div class="container1 my-5">
    <%
        try {
            conn = DBConection.getConnection();
            String sql = "SELECT p.*, c.category_name, o.discount_type, o.discount_value, o.start_date, o.end_date " +
                         "FROM products p " +
                         "JOIN category c ON p.category = c.category_id " +
                         "LEFT JOIN offers o ON p.prod_id = o.prod_id " +
                         "WHERE p.prod_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, pid);
            rs = ps.executeQuery();
            if (rs.next()) {
                String name = rs.getString("name");
                String image = rs.getString("image");
                String cat = rs.getString("category_name");
                double price = rs.getDouble("price");

                String discountType = rs.getString("discount_type");
                double discountValue = rs.getDouble("discount_value");
                double finalPrice = price;

                boolean hasOffer = discountType != null;

                if (hasOffer) {
                    if ("percentage".equalsIgnoreCase(discountType)) {
                        finalPrice = price - (price * discountValue / 100);
                    } else if ("fixed".equalsIgnoreCase(discountType)) {
                        finalPrice = price - discountValue;
                    }
                }
    %>
    <div class="row">
        <div class="col-md-6">
            <img src="<%= request.getContextPath() + "/" + image %>" class="img-fluid" alt="<%= name %>">
        </div>
        <div class="col-md-6 product-info">
            <h2><%= name %></h2>
            <p><strong>Category:</strong> <%= cat %></p>
            <% if (hasOffer) { %>
                <p><strong>Original Price:</strong> <del>Rs. <%= price %></del></p>
                <p><strong>Offer Price:</strong> <span class="text-danger">Rs. <%= String.format("%.2f", finalPrice) %></span></p>
            <% } else { %>
                <p><strong>Price:</strong> Rs. <%= price %></p>
            <% } %>
            <p><strong>Description:</strong> <%= rs.getString("description") %></p>

            <a href="customerlogin.jsp" class="btn btn-success">Add to Cart</a>
        </div>
    </div>
    <%
            } else {
                out.println("<div class='alert alert-warning'>Product not found!</div>");
            }
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    %>
</div>
<a href="<%= request.getContextPath() %>/jsp_pages/index/index.jsp" class="btn btn-outline-secondary mb-4">Back to Products</a>

</body>
</html>
