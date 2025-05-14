<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.smart_hub.servlets.DBConection" %>
<%
    int prodId = Integer.parseInt(request.getParameter("id"));
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    String name = "", image = "";
    double price = 0;
    int stock = 0;

    try {
        conn = DBConection.getConnection();
        String sql = "SELECT * FROM products WHERE prod_id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, prodId);
        rs = stmt.executeQuery();
        if (rs.next()) {
            name = rs.getString("name");
            stock = rs.getInt("stock");
            price = rs.getDouble("price");
            image = rs.getString("image");
        }
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Product</title>
    <style>
        .form-container {
            max-width: 600px;
            margin: auto;
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 8px 16px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            color: #007bff;
        }
        input[type="text"], input[type="number"], input[type="file"] {
            width: 100%;
            padding: 10px;
            margin: 10px 0 20px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        label {
            font-weight: bold;
            color: #333;
        }
        #btn {
            background-color: #007bff;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            width: 100%;
            font-size: 16px;
        }
        .btn:hover {
            background-color: #0056b3;
        }
        .current-image {
            text-align: center;
            margin-top: 10px;
        }
    </style>
</head>
<body>
<%@ include file="navbar.jsp" %>
<jsp:include page="sidebar.jsp" />
    <div class="form-container">
        <h2>Edit Product</h2>
        <form action="<%= request.getContextPath() %>/UpdateProductServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="prod_id" value="<%= prodId %>">

            <label for="name">Product Name:</label>
            <input type="text" id="name" name="name" value="<%= name %>" required>

            <label for="stock">Stock:</label>
            <input type="number" id="stock" name="stock" value="<%= stock %>" required>

            <label for="price">Price (per item):</label>
            <input type="number" step="0.01" id="price" name="price" value="<%= price %>" required>

            <label for="image">Change Image:</label>
            <input type="file" id="image" name="image">

            <div class="current-image">
                <p>Current Image:</p>
                <img src="<%= request.getContextPath() + "/" + image %>" width="120">
            </div>

            <br>
            <button type="submit" id="btn">Update Product</button>
        </form>
    </div>
</body>
</html>
