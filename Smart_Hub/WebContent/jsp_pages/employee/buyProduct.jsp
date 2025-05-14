<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.io.*, java.sql.*, com.smart_hub.servlets.DBConection" %>
<%@ page import="jakarta.servlet.http.*" %>
<html>
<head>
    <title>SmartHub Products - Filter & Buy</title>
    <!-- ✅ Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .main-content { margin-left: 260px; padding: 30px; transition: margin-left 0.3s; }
        .table thead { background-color: #f8f9fa; }
    </style>
</head>
<body style="background-color: #f5f5f5;">
<%@ include file="navbar.jsp" %>
<jsp:include page="sidebar.jsp" />

<div class="main-content">
    <div class="container bg-white p-4 rounded shadow">
        <h2 class="mb-4 text-center">SmartHub Product Billing (Filter & Buy)</h2>
		
		<%
		    String message = (String) request.getAttribute("message");
		    String error = (String) request.getAttribute("error");
		%>
		<% if (message != null) { %>
		    <div class="alert alert-success alert-dismissible fade show" role="alert">
		        <%= message %>
		        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
		    </div>
		<% } else if (error != null) { %>
		    <div class="alert alert-danger alert-dismissible fade show" role="alert">
		        <%= error %>
		        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
		    </div>
		<% } %>
		
        <!-- ✅ Filter Form -->
        <form method="get" action="" class="row g-3 mb-4">
            <div class="col-md-4">
                <label class="form-label">Category</label>
                <select class="form-select" name="category" onchange="this.form.submit()">
                    <option value="">--Select--</option>
                    <%
                        Connection conn = DBConection.getConnection();
                        Statement catStmt = conn.createStatement();
                        ResultSet catRs = catStmt.executeQuery("SELECT * FROM category");

                        String selectedCategory = request.getParameter("category");
                        while (catRs.next()) {
                            String catIdStr = String.valueOf(catRs.getInt("category_id"));
                            String selected = catIdStr.equals(selectedCategory) ? "selected" : "";
                    %>
                    <option value="<%= catIdStr %>" <%= selected %>><%= catRs.getString("category_name") %></option>
                    <% } %>
                </select>
            </div>

            <div class="col-md-4">
                <label class="form-label">Subcategory</label>
                <select class="form-select" name="subcategory">
                    <option value="">--Select--</option>
                    <%
                        if (selectedCategory != null && !selectedCategory.isEmpty()) {
                            PreparedStatement subStmt = conn.prepareStatement("SELECT * FROM subcategories WHERE category_id = ?");
                            subStmt.setInt(1, Integer.parseInt(selectedCategory));
                            ResultSet subRs = subStmt.executeQuery();

                            String selectedSubcategory = request.getParameter("subcategory");
                            while (subRs.next()) {
                                String subIdStr = String.valueOf(subRs.getInt("subcategory_id"));
                                String selected = subIdStr.equals(selectedSubcategory) ? "selected" : "";
                    %>
                    <option value="<%= subIdStr %>" <%= selected %>><%= subRs.getString("subcategory_name") %></option>
                    <%       }
                        }
                    %>
                </select>
            </div>

            <div class="col-md-4 d-flex align-items-end">
                <input type="submit" class="btn btn-primary" value="Filter"/>
            </div>
        </form>

        <!-- ✅ Product Table -->
        <div class="table-responsive">
            <table class="table table-bordered table-hover">
                <thead class="table-light">
                    <tr>
                        <th>Product</th>
                        <th>Price</th>
                        <th>Stock</th>
                        <th>Quantity</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    String catFilter = request.getParameter("category");
                    String subFilter = request.getParameter("subcategory");

                    String query = "SELECT * FROM products WHERE 1=1";
                    if (catFilter != null && !catFilter.isEmpty()) {
                        query += " AND category = " + catFilter;
                    }
                    if (subFilter != null && !subFilter.isEmpty()) {
                        query += " AND subcategory_id = " + subFilter;
                    }

                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery(query);

                    boolean hasData = false;
                    while (rs.next()) {
                        hasData = true;
                        int pid = rs.getInt("prod_id");
                        int stock = rs.getInt("stock");
                %>
                <tr>
                    <form action="${pageContext.request.contextPath}/buyProductServlet" method="post">
                        <td><%= rs.getString("name") %></td>
                        <td>₹<%= rs.getInt("price") %></td>
                        <td><%= stock %></td>
                        <td>
                            <input type="number" class="form-control" name="quantity" value="1" min="1" max="<%= stock %>"/>
                        </td>
                        <td>
                            <button type="submit" class="btn btn-success btn-sm" name="productId" value="<%= pid %>">Buy</button>
                        </td>
                    </form>
                </tr>
                <% } %>
                <% if (!hasData) { %>
                <tr>
                    <td colspan="5" class="text-center text-muted">No products found for the selected filter.</td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- ✅ Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
