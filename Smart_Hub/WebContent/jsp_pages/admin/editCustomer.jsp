<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="java.sql.*, java.text.SimpleDateFormat, com.smart_hub.servlets.DBConection" %>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    String name = "", mail = "", phone = "", address = "";

    try {
        conn = DBConection.getConnection();
        String sql = "SELECT * FROM customer WHERE id=?";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, id);
        rs = stmt.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            mail = rs.getString("mail");
            phone = rs.getString("phone");
            address = rs.getString("address");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="ISO-8859-1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Employee</title>
    <style>
        .main-content { margin-left: 350px; padding: 20px; width:700px; }
        .container { background: white; padding: 30px; width: 450px; border-radius: 10px; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1); }
        h2 { text-align: center; color: #333; margin-bottom: 20px; }
        .form-group { margin-bottom: 15px; }
        label { display: block; font-weight: bold; margin-bottom: 5px; color: #333; }
        input { width: 100%; padding: 10px; font-size: 14px; border: 1px solid #ccc; border-radius: 5px; transition: border-color 0.3s; }
        input:focus { border-color: #007bff; outline: none; }
        #btn-group { display: flex; justify-content: space-between; }
        #btn { width: 48%; padding: 10px; font-size: 16px; border: none; border-radius: 5px; cursor: pointer; transition: background 0.3s; }
        #btn-save { background: green; color: white; }
        #btn-save:hover { background: darkgreen; }
        #btn-cancel { background: red; color: white; }
        #btn-cancel:hover { background: darkred; }
    </style>
</head>
<body>
    <%@ include file="navbar.jsp" %>
    <jsp:include page="sidebar.jsp" />
    <div class="main-content">
        <div class="container">
            <h2>Edit Employee</h2>
            <form action="${pageContext.request.contextPath}/manageCustomer" method="post">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="id" value="<%= id %>">
                
                <div class="form-group">
                    <label>Name:</label>
                    <input type="text" name="name" value="<%= name %>" required>
                </div>

                <div class="form-group">
                    <label>Email:</label>
                    <input type="email" name="mail" value="<%= mail %>" required>
                </div>

                <div class="form-group">
                    <label>Mobile No:</label>
                    <input type="text" name="phone" value="<%= phone %>" required>
                </div>

                <div class="form-group">
                    <label>Address:</label>
                    <input type="text" name="address" value="<%= address %>" required>
                </div>

                <div id="btn-group">
                    <button type="submit" id="btn btn-save">Save Changes</button>
                    <button type="button" id="btn btn-cancel" onclick="window.location.href='manageCustomer.jsp'">Cancel</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
