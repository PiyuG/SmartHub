<%@ page import="java.util.*,java.io.*,java.sql.*,com.smart_hub.servlets.DBConection"%>
<%@ page import="jakarta.servlet.http.*"%>
<%
    String userName = (String) session.getAttribute("employeeName");
    String userEmail = (String) session.getAttribute("employeeEmail");
    String userDepartment = null;
    String userDesignation = null;
    String userAddress = null;
    String userDOB = null;
    String userDOJ = null;
    String profilePic = null;
    int userId=0;

    Connection conn = DBConection.getConnection();
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    // Fetch user details
    String query = "SELECT id,designation, department, address, dob, joining_date, image FROM users WHERE mail = ?";
    pstmt = conn.prepareStatement(query);
    pstmt.setString(1, userEmail);
    rs = pstmt.executeQuery();
    if (rs.next()) {
    	userId=rs.getInt("id");
        userDepartment = rs.getString("department");
        userDesignation = rs.getString("designation");
        userAddress = rs.getString("address");
        userDOB = rs.getString("dob");
        userDOJ = rs.getString("joining_date");
        profilePic = rs.getString("image");
    }
    rs.close();
    pstmt.close();
%>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    body {
        font-family: 'Arial', sans-serif;
        background-color: #f7f7f7;
    }

    .profile-container {
        max-width: 800px;
        margin: 90px auto;
        padding: 20px;
        background: white;
        border-radius: 10px;
        box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.1);
        animation: fadeIn 0.8s ease-out;
    }

    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .profile-header {
        text-align: center;
        margin-bottom: 30px;
    }

    .profile-header img {
        width: 150px;
        height: 150px;
        border-radius: 50%;
        border: 5px solid #fff;
        box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);
        margin-bottom: 15px;
    }

    .profile-header h3 {
        color: #333;
        margin-top: 10px;
    }

    .profile-header p {
        color: #666;
        font-size: 14px;
    }

    .profile-info {
        font-size: 16px;
        color: #333;
    }

    .profile-info .row {
        margin-bottom: 20px;
    }

    .profile-info .col-sm-4 {
        font-weight: bold;
        color: #007bff;
    }

    .profile-info .col-sm-8 {
        color: #555;
    }

    .profile-info .col-sm-8 i {
        color: #007bff;
    }

    .button-container {
        text-align: center;
        margin-top: 30px;
    }

    .edit-button {
        background-color: #007bff;
        color: white;
        padding: 10px 20px;
        border-radius: 5px;
        text-decoration: none;
        font-size: 16px;
        transition: background-color 0.3s ease;
    }

    .edit-button:hover {
        background-color: #0056b3;
    }

</style>
<%@ include file="navbar.jsp" %>
<jsp:include page="sidebar.jsp" />
<div class="profile-container">
    <div class="profile-header">
        <img src="<%= request.getContextPath() + "/" + (profilePic != null ? profilePic : "images/default-avatar.jpg") %>" alt="Profile Picture">
        <h3><%= userName %></h3>
        <p><%= userDesignation %>, <%= userDepartment %></p>
    </div>

    <div class="profile-info">
        <div class="row">
            <div class="col-sm-4">Employee ID:</div>
            <div class="col-sm-8"><%= userId %></div>
        </div>
        <div class="row">
            <div class="col-sm-4">Email:</div>
            <div class="col-sm-8"><%= userEmail %></div>
        </div>
        <div class="row">
            <div class="col-sm-4">Address:</div>
            <div class="col-sm-8"><%= userAddress %></div>
        </div>
        <div class="row">
            <div class="col-sm-4">Date of Birth:</div>
            <div class="col-sm-8"><%= userDOB %></div>
        </div>
        <div class="row">
            <div class="col-sm-4">Date of Joining:</div>
            <div class="col-sm-8"><%= userDOJ %></div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
