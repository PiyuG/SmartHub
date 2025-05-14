<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.Date" %>
<%@ page import="com.smart_hub.servlets.DBConection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SmartHub - Products</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; font-family: Arial, sans-serif; }
        .main-content { padding: 20px; margin-top:30px; }
        .product-container { display: flex; flex-wrap: wrap; justify-content: center; gap: 20px; }
        .product-box {
            background: white; width: 300px; padding: 15px; border-radius: 15px;
            box-shadow: 0 10px 20px rgba(0,0,0,0.1); text-align: center; position: relative;
            height: 470px; transition: transform 0.3s ease; animation: fadeInUp 0.5s ease-out;
        }
        .product-box:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 30px rgba(0,0,0,0.15);
        }
        .product-box img {
            width: 100%; height: 220px; object-fit: contain;
        }
        .product-name { font-size: 17px; font-weight: bold; margin: 10px 0; }
        .product-category { font-size: 14px; color: #6c757d; }
        .product-price, .offer-price { font-size: 18px; font-weight: bold; }
        .offer-price { color: red; }
        .original-price { text-decoration: line-through; color: gray; margin-right: 5px; }
        .product-buttons {
            margin-top: 15px; display: flex; justify-content: center;
            opacity: 0; transition: opacity 0.3s ease;
        }
        .product-box:hover .product-buttons {
            opacity: 1;
        }
        .btn-buy, .btn-cart {
            padding: 8px 16px; border-radius: 5px; border: none;
        }
        .btn-buy { background: #007bff; color: white; }
        .btn-cart { background: #28a745; color: white; }

        .carousel-inner img {
            width: 100%;
            max-height: 350px;
            object-fit: cover;
            border-radius: 10px;
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @media (max-width: 767px) {
            .filter-toggle-btn {
                display: block;
                margin-bottom: 15px;
            }
        }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<!-- Banner Carousel -->
<div id="bannerCarousel" class="carousel slide" data-bs-ride="carousel" style="margin-top: 45px;">
  <div class="carousel-inner">
    <div class="carousel-item active">
      <img src="https://media.starquik.com/bannerslider/s/t/starquik_summerfl25_1400x400.jpg" class="d-block w-100" alt="Banner 1">
    </div>
    <div class="carousel-item">
      <img src="https://media.starquik.com/bannerslider/s/t/startquik_mms_25_post_1400x400.jpg" class="d-block w-100" alt="Banner 2">
    </div>
    <div class="carousel-item">
      <img src="https://media.starquik.com/bannerslider/s/t/starquik_fl_web_halfprice_1400x400.jpg" class="d-block w-100" alt="Banner 3">
    </div>
  </div>
  <button class="carousel-control-prev" type="button" data-bs-target="#bannerCarousel" data-bs-slide="prev">
    <span class="carousel-control-prev-icon"></span>
  </button>
  <button class="carousel-control-next" type="button" data-bs-target="#bannerCarousel" data-bs-slide="next">
    <span class="carousel-control-next-icon"></span>
  </button>
</div>

<!-- Main Content -->
<div class="container-fluid main-content">
    <button class="btn btn-outline-primary filter-toggle-btn" type="button" data-bs-toggle="collapse" data-bs-target="#filterSection" aria-expanded="false" aria-controls="filterSection">
        Toggle Filters
    </button>

    <div class="row">
        <!-- Filter Section -->
        <div class="col-md-3 collapse" id="filterSection">
            <form method="get">
                <div class="card p-3 shadow-sm mb-4">
                    <h5>Filter by Category</h5>
                    <%
                        Connection conn = null;
                        PreparedStatement stmt = null;
                        ResultSet rs = null;
                        String selectedCatId = request.getParameter("category");
                        try {
                            conn = DBConection.getConnection();
                            stmt = conn.prepareStatement("SELECT category_id, category_name FROM category");
                            rs = stmt.executeQuery();
                            while (rs.next()) {
                                String catId = rs.getString("category_id");
                                String catName = rs.getString("category_name");
                    %>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="category" value="<%= catId %>" <%= catId.equals(selectedCatId) ? "checked" : "" %>>
                        <label class="form-check-label"><%= catName %></label>
                    </div>
                    <%
                            }
                        } catch (Exception e) {
                            out.print("Error loading categories: " + e.getMessage());
                        } finally {
                            try { if (rs != null) rs.close(); } catch (Exception e) {}
                            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
                        }
                    %>

                    <hr>
                    <h5>Offer</h5>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" name="offer" value="1" <%= "1".equals(request.getParameter("offer")) ? "checked" : "" %>>
                        <label class="form-check-label">Only with offers</label>
                    </div>

                    <hr>
                    <h5>Price Range</h5>
                    <input type="number" class="form-control mb-2" name="minPrice" placeholder="Min" value="<%= request.getParameter("minPrice") != null ? request.getParameter("minPrice") : "" %>">
                    <input type="number" class="form-control mb-2" name="maxPrice" placeholder="Max" value="<%= request.getParameter("maxPrice") != null ? request.getParameter("maxPrice") : "" %>">

                    <button type="submit" class="btn btn-primary w-100 mt-2">Apply Filter</button>
                </div>
            </form>
        </div>

        <!-- Product Section -->
        <div class="col-md-12" id="productColumn">
            <h3 class="mb-4 text-center">Our Products</h3>
            <div class="product-container">
                <%
                    PreparedStatement ps = null;
                    ResultSet prs = null;

                    try {
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                        String today = sdf.format(new Date());

                        String selectedSearch = request.getParameter("search");
                        String minPrice = request.getParameter("minPrice");
                        String maxPrice = request.getParameter("maxPrice");
                        String offerOnly = request.getParameter("offer");

                        StringBuilder sql = new StringBuilder(
                            "SELECT p.*, c.category_name, o.discount_type, o.discount_value, o.start_date, o.end_date " +
                            "FROM products p " +
                            "JOIN category c ON p.category = c.category_id " +
                            "LEFT JOIN offers o ON p.prod_id = o.prod_id AND o.start_date <= ? AND o.end_date >= ? " +
                            "WHERE 1=1 "
                        );

                        if (selectedCatId != null && !selectedCatId.trim().isEmpty()) {
                            sql.append(" AND p.category = ?");
                        }
                        if (selectedSearch != null && !selectedSearch.trim().isEmpty()) {
                            sql.append(" AND p.name LIKE ?");
                        }
                        if ("1".equals(offerOnly)) {
                            sql.append(" AND o.discount_type IS NOT NULL ");
                        }
                        if (minPrice != null && !minPrice.trim().isEmpty()) {
                            sql.append(" AND p.price >= ?");
                        }
                        if (maxPrice != null && !maxPrice.trim().isEmpty()) {
                            sql.append(" AND p.price <= ?");
                        }

                        ps = conn.prepareStatement(sql.toString());

                        int i = 1;
                        ps.setString(i++, today);
                        ps.setString(i++, today);
                        if (selectedCatId != null && !selectedCatId.trim().isEmpty()) {
                            ps.setString(i++, selectedCatId);
                        }
                        if (selectedSearch != null && !selectedSearch.trim().isEmpty()) {
                            ps.setString(i++, "%" + selectedSearch + "%");
                        }
                        if (minPrice != null && !minPrice.trim().isEmpty()) {
                            ps.setDouble(i++, Double.parseDouble(minPrice));
                        }
                        if (maxPrice != null && !maxPrice.trim().isEmpty()) {
                            ps.setDouble(i++, Double.parseDouble(maxPrice));
                        }

                        prs = ps.executeQuery();
                        boolean found = false;

                        while (prs.next()) {
                            found = true;
                            String name = prs.getString("name");
                            String catName = prs.getString("category_name");
                            String img = prs.getString("image");
                            double price = prs.getDouble("price");

                            String discountType = prs.getString("discount_type");
                            double discountValue = prs.getDouble("discount_value");

                            boolean hasOffer = (discountType != null);
                            double finalPrice = price;

                            if (hasOffer) {
                                if ("percentage".equalsIgnoreCase(discountType)) {
                                    finalPrice = price - (price * discountValue / 100);
                                } else if ("fixed".equalsIgnoreCase(discountType)) {
                                    finalPrice = price - discountValue;
                                }
                                finalPrice = Math.max(0, finalPrice);
                            }
                %>
                <div class="product-box">
                    <img src="<%= request.getContextPath() + "/" + img %>" alt="<%= name %>">
                    <div class="product-name"><%= name %></div>
                    <div class="product-category"><i class="fas fa-tag"></i> <%= catName %></div>

                    <% if (hasOffer) { %>
                        <div class="product-price">
                            <span class="original-price">Rs. <%= price %></span>
                            <span class="offer-price">Rs. <%= String.format("%.2f", finalPrice) %> (Offer!)</span>
                        </div>
                    <% } else { %>
                        <div class="product-price">Rs. <%= price %></div>
                    <% } %>

                    <div class="product-buttons">
                        <a href="<%= request.getContextPath() %>/jsp_pages/index/product_detail.jsp?pid=<%= prs.getInt("prod_id") %>" class="btn btn-primary">View All</a>
                    </div>
                </div>
                <%
                        }

                        if (!found) {
                            out.print("<p class='text-center text-muted'>No products found.</p>");
                        }

                    } catch (Exception e) {
                        out.print("<p class='text-danger'>Error loading products: " + e.getMessage() + "</p>");
                    } finally {
                        try { if (prs != null) prs.close(); } catch (Exception e) {}
                        try { if (ps != null) ps.close(); } catch (Exception e) {}
                        try { if (conn != null) conn.close(); } catch (Exception e) {}
                    }
                %>
            </div>
        </div>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const filterSection = document.getElementById("filterSection");
        const productColumn = document.getElementById("productColumn");

        filterSection.addEventListener('shown.bs.collapse', function () {
            productColumn.classList.remove("col-md-12");
            productColumn.classList.add("col-md-9");
        });

        filterSection.addEventListener('hidden.bs.collapse', function () {
            productColumn.classList.remove("col-md-9");
            productColumn.classList.add("col-md-12");
        });
    });
</script>

</body>
</html>
