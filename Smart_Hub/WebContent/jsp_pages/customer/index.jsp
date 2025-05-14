<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.Date" %>
<%@ page import="com.smart_hub.servlets.DBConection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .container { max-width: 1100px; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); }
        .main-content { margin-left: 260px; padding: 20px; transition: margin-left 0.3s; }

        .card {
            border: none;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
            border-radius: 10px;
        }

        .card:hover {
            transform: scale(1.05);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.15);
        }

        .card-img-top {
            width: 100%;
            max-height: 300px;
            object-fit: contain;
        }

        .card-body {
            text-align: center;
        }

        .card-title {
            font-size: 1.2rem;
            font-weight: bold;
            color: #333;
        }

        .card-text {
            font-size: 0.9rem;
            color: #666;
        }

        .text-danger {
            font-size: 1.2rem;
            font-weight: bold;
            color: #d9534f;
        }

        .text-success {
            font-size: 1.2rem;
            font-weight: bold;
            color: #28a745;
        }

        input[type="number"] {
            width: 60px;
            text-align: center;
            border: 1px solid #ddd;
            border-radius: 5px;
            margin: 10px 0;
        }

        .btn {
            padding: 8px 15px;
            font-size: 0.9rem;
            border-radius: 5px;
        }

        .btn-success:hover { background-color: #218838; }
    </style>
</head>
<body>
<%@ include file="navbar.jsp" %>
<jsp:include page="sidebar.jsp" />
<div class="main-content">
    <div class="container">
        <!-- Filter UI -->
        <div class="row mb-4">
            <div class="col-md-3">
                <form method="get" action="">
                    <select name="category" class="form-select" onchange="this.form.submit()">
                        <option value="">All Categories</option>
                        <%
                            Connection catConn = DBConection.getConnection();
                            PreparedStatement catStmt = catConn.prepareStatement("SELECT * FROM category");
                            ResultSet catRs = catStmt.executeQuery();
                            while (catRs.next()) {
                                int catId = catRs.getInt("category_id");
                                String catName = catRs.getString("category_name");
                                String selected = (request.getParameter("category") != null &&
                                                    request.getParameter("category").equals(String.valueOf(catId))) ? "selected" : "";
                        %>
                            <option value="<%= catId %>" <%= selected %>><%= catName %></option>
                        <%
                            }
                            catRs.close();
                            catStmt.close();
                            catConn.close();
                        %>
                    </select>
                </form>
            </div>

            <div class="col-md-3">
                <form method="get" action="">
                    <select name="discount" class="form-select" onchange="this.form.submit()">
                        <option value="">All Offers</option>
                        <option value="1" <%= "1".equals(request.getParameter("discount")) ? "selected" : "" %>>With Offer</option>
                        <option value="0" <%= "0".equals(request.getParameter("discount")) ? "selected" : "" %>>Without Offer</option>
                    </select>
                </form>
            </div>

            <div class="col-md-3">
                <a href="index.jsp" class="btn btn-outline-secondary">Clear Filters</a>
            </div>
        </div>

        <div class="row">
        <%
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String today = sdf.format(new Date());

            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                conn = DBConection.getConnection();

                String categoryFilter = request.getParameter("category");
                String discountFilter = request.getParameter("discount");

                StringBuilder sql = new StringBuilder(
                    "SELECT p.prod_id, p.name, p.price, p.description, p.image, p.category, " +
                    "o.discount_type, o.discount_value, o.start_date, o.end_date " +
                    "FROM products p " +
                    "LEFT JOIN offers o ON p.prod_id = o.prod_id " +
                    "AND o.start_date <= ? AND o.end_date >= ? WHERE 1=1"
                );

                if (categoryFilter != null && !categoryFilter.isEmpty()) {
                    sql.append(" AND p.category = ?");
                }
                if ("1".equals(discountFilter)) {
                    sql.append(" AND o.discount_type IS NOT NULL");
                } else if ("0".equals(discountFilter)) {
                    sql.append(" AND o.discount_type IS NULL");
                }

                stmt = conn.prepareStatement(sql.toString());
                stmt.setString(1, today);
                stmt.setString(2, today);

                int paramIndex = 3;
                if (categoryFilter != null && !categoryFilter.isEmpty()) {
                    stmt.setInt(paramIndex++, Integer.parseInt(categoryFilter));
                }

                rs = stmt.executeQuery();

                while (rs.next()) {
                    int productId = rs.getInt("prod_id");
                    String name = rs.getString("name");
                    double originalPrice = rs.getDouble("price");
                    String description = rs.getString("description");
                    String imagePath = rs.getString("image");

                    String discountType = rs.getString("discount_type");
                    double discountValue = rs.getDouble("discount_value");
                    boolean hasOffer = (discountType != null);

                    double finalPrice = originalPrice;
                    if (hasOffer) {
                        if ("percentage".equalsIgnoreCase(discountType)) {
                            finalPrice = originalPrice - (originalPrice * (discountValue / 100));
                        } else if ("fixed".equalsIgnoreCase(discountType)) {
                            finalPrice = originalPrice - discountValue;
                        }
                        finalPrice = Math.max(finalPrice, 0);
                    }
        %>
            <div class="col-md-4 mb-4">
                <div class="card">
                    <img src="<%= request.getContextPath() + "/" + imagePath %>" class="card-img-top" alt="<%= name %>">
                    <div class="card-body">
                        <h5 class="card-title"><%= name %></h5>
                        <p class="card-text"><%= description %></p>
                        <% if (hasOffer) { %>
                            <p class="text-danger">
                                <span class="text-muted" style="text-decoration: line-through;">Rs.<%= originalPrice %></span>
                                Rs.<%= String.format("%.2f", finalPrice) %> (Offer!)
                            </p>
                        <% } else { %>
                            <p class="text-success">Rs.<%= originalPrice %></p>
                        <% } %>
                        <form action="${pageContext.request.contextPath}/cartServlet" method="post">
                            <input type="hidden" name="product_id" value="<%= productId %>">
                            <input type="hidden" name="product_name" value="<%= name %>">
                            <input type="hidden" name="price" value="<%= finalPrice %>">
                            <input type="hidden" name="image" value="<%= imagePath %>">
                            <label for="quantity_<%= productId %>">Qty:</label>
                            <input type="number" name="quantity" min="1" value="1" required>
                            <button type="submit" class="btn btn-success mt-2">Add to Cart</button>
                        </form>
                    </div>
                </div>
            </div>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        %>
        </div>
    </div>
</div>

</body>
</html>
