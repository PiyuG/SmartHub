<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*, java.io.*, java.sql.*, com.smart_hub.servlets.DBConection"%>
<%@ page import="jakarta.servlet.http.*"%>

<%
    // Retrieve email from session
    String userEmail = (String) session.getAttribute("employeeEmail");
    String userDepartment = null;

    Connection conn = DBConection.getConnection();
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    // Fetch user's department
    String deptQuery = "SELECT department FROM users WHERE mail = ?";
    pstmt = conn.prepareStatement(deptQuery);
    pstmt.setString(1, userEmail);
    rs = pstmt.executeQuery();
    if (rs.next()) {
        userDepartment = rs.getString("department");
    }
    rs.close();
    pstmt.close();

    int totalEmp = 0, totalDepartment = 0, totalCategory = 0, totalCustomer = 0;
    Statement stmt = conn.createStatement();

    // Count Queries
    String query = "SELECT COUNT(*) AS total FROM users where status='Active'";
    String query2 = "SELECT COUNT(*) AS total FROM department";
    String query3 = "SELECT COUNT(*) AS total FROM category";
    String query4 = "SELECT COUNT(*) AS total FROM customer";

    ResultSet rs1 = stmt.executeQuery(query);
    if (rs1.next()) totalEmp = rs1.getInt("total");
    rs1.close();

    ResultSet rs2 = stmt.executeQuery(query2);
    if (rs2.next()) totalDepartment = rs2.getInt("total");
    rs2.close();

    ResultSet rs3 = stmt.executeQuery(query3);
    if (rs3.next()) totalCategory = rs3.getInt("total");
    rs3.close();

    ResultSet rs4 = stmt.executeQuery(query4);
    if (rs4.next()) totalCustomer = rs4.getInt("total");
    rs4.close();

    // Birthday Query (Same Department)
    String birthdayQuery = "SELECT name, dob, image FROM users WHERE department = ? AND DATE_FORMAT(dob, '%m-%d') = DATE_FORMAT(CURDATE(), '%m-%d') AND status='Active'";
    pstmt = conn.prepareStatement(birthdayQuery);
    pstmt.setString(1, userDepartment);
    ResultSet rsBirthday = pstmt.executeQuery();

    // Team Members Query (Same Department)
    String teamQuery = "SELECT name, image FROM users WHERE department = ? AND status='Active' LIMIT 5";
    pstmt = conn.prepareStatement(teamQuery);
    pstmt.setString(1, userDepartment);
    ResultSet rsTeam = pstmt.executeQuery();

 // Employees on Leave Today (Same Department)
    String leaveQuery = "SELECT u.name, u.image FROM leave_requests lr JOIN users u ON lr.email = u.mail WHERE u.department = ? AND lr.status='Approved' AND CURDATE() BETWEEN lr.start_date AND lr.end_date";
    pstmt = conn.prepareStatement(leaveQuery);
    pstmt.setString(1, userDepartment);
    ResultSet rsLeave = pstmt.executeQuery();

%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="ISO-8859-1">
    <title>Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .container { width: 100%; max-width: 900px; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); }
        .main-content { margin-left: 260px; padding: 20px; transition: margin-left 0.3s; }
        .stats-card { display: flex; justify-content: space-between; align-items: center; padding: 10px; height: 175px; }
        .stats-card .icon { font-size: 30px; }
        .stats-card h5 { margin: 0; }
        .card { border: none; border-radius: 10px; box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1); padding: 25px; background: #ffffff; position: relative; overflow: hidden; transition: 0.3s; }
        .card:hover { transform: translateY(-5px); box-shadow: 0px 6px 12px rgba(0, 0, 0, 0.15); }
        .profile-pic { width: 40px; height: 40px; border-radius: 50%; margin-right: 10px; }
        .list-group-item { display: flex; align-items: center; }
    </style>
</head>
<body>

<%@ include file="navbar.jsp" %>
<jsp:include page="sidebar.jsp" />

<div class="main-content">
    <div class="container">
        <div class="row mt-4">
            <div class="col-md-3">
                <div class="card stats-card">
                    <div><h5><%= totalEmp %></h5><p>Total Employee</p></div>
                    <i class="fas fa-user-tie icon"></i>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card">
                    <div><h5><%= totalDepartment %></h5><p>Total Department</p></div>
                    <i class="fas fa-file-alt icon"></i>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card">
                    <div><h5><%= totalCustomer %></h5><p>Total Customer</p></div>
                    <i class="fa-solid fa-user-group icon"></i>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card">
                    <div><h5><%= totalCategory %></h5><p>Total Categories</p></div>
                    <i class="fas fa-download icon"></i>
                </div>
            </div>
        </div>

        <div class="row mt-4">
            <div class="col-md-6">
                <div class="card p-3">
                    <h5>Today's Birthdays (Same Department)</h5>
                    <table class="table">
                        <tbody>
                            <%
                            while (rsBirthday.next()) {
                                String staffName = rsBirthday.getString("name");
                                String profilePic = rsBirthday.getString("image");
                            %>
                            <tr>
                                <td><img src="<%= request.getContextPath() + "/" + profilePic %>" class="profile-pic"> <%= staffName %></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="col-md-6">
                <div class="card p-3">
                    <h5>Team Members (Same Department)</h5>
                    <ul class="list-group">
                        <%
                        while (rsTeam.next()) {
                            String teamMember = rsTeam.getString("name");
                            String profilePic = rsTeam.getString("image");
                        %>
                        <li class="list-group-item"><img src="<%= request.getContextPath() + "/" + profilePic %>" class="profile-pic"> <%= teamMember %></li>
                        <% } %>
                    </ul>
                </div>
            </div>

            <div class="col-md-6 mt-3">
                <div class="card p-3">
                    <h5>Employees on Leave (Same Department)</h5>
                    <ul class="list-group">
                        <%
                        while (rsLeave.next()) {
                            String leaveEmp = rsLeave.getString("name");
                            String profilePic = rsLeave.getString("image");
                        %>
                        <li class="list-group-item"><img src="<%= request.getContextPath() + "/" + profilePic %>" class="profile-pic"> <%= leaveEmp %></li>
                        <% } %>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<%
    rsBirthday.close();
    rsTeam.close();
    rsLeave.close();
    conn.close();
%>

</body>
</html>
