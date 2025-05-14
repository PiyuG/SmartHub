<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*,java.io.*,java.sql.*,com.smart_hub.servlets.DBConection"%>
<%@ page import="jakarta.servlet.http.*"%>

<%
int totalEmp = 0, totaldepartment = 0, totalCategory = 0, totalCustomer = 0;
PreparedStatement pstmt = null;
// Get Database Connection
Connection conn = DBConection.getConnection();
Statement stmt = conn.createStatement();
Statement stmt2 = conn.createStatement(); // Separate Statement for rsBirthday

// Queries
String query = "SELECT COUNT(*) AS total FROM users";
String query2 = "SELECT COUNT(*) AS total FROM department";
String query3 = "SELECT COUNT(*) AS total FROM category";
String query4 = "SELECT COUNT(*) AS total FROM customer";
String birthdayQuery = "SELECT name, dob, image FROM users WHERE DATE_FORMAT(dob, '%m-%d') = DATE_FORMAT(CURDATE(), '%m-%d') AND status='Active'";

// Execute count queries
ResultSet rs1 = stmt.executeQuery(query);
if (rs1.next()) totalEmp = rs1.getInt("total");
rs1.close();

ResultSet rs2 = stmt.executeQuery(query2);
if (rs2.next()) totaldepartment = rs2.getInt("total");
rs2.close();

ResultSet rs3 = stmt.executeQuery(query3);
if (rs3.next()) totalCategory = rs3.getInt("total");
rs3.close();

ResultSet rs4 = stmt.executeQuery(query4);
if (rs4.next()) totalCustomer = rs4.getInt("total");
rs4.close();


pstmt = conn.prepareStatement(birthdayQuery);
ResultSet rsBirthday = pstmt.executeQuery();
stmt.close(); // Close stmt, but keep stmt2 open for rsBirthday
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        .container { width: 100%; max-width: 600px; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); }
        .main-content { margin-left: 260px; padding: 20px; transition: margin-left 0.3s; }
        .stats-card { display: flex; justify-content: space-between; align-items: center; padding: 10px; height:175px; }
        .stats-card .icon { font-size: 30px; }
        .stats-card h5 { margin: 0; }
        .card { border: none; border-radius: 10px; box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1); padding: 35px; background: #ffffff; position: relative; overflow: hidden; }
        .card .bottom-bar { position: absolute; bottom: 0; left: 0; width: 100%; height: 30px; border-radius: 0 0 10px 10px; }
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
                    <div class="bottom-bar bg-primary"></div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card">
                    <div><h5><%= totaldepartment %></h5><p>Total Department</p></div>
                    <i class="fas fa-file-alt icon"></i>
                    <div class="bottom-bar bg-success"></div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card">
                    <div><h5><%= totalCustomer %></h5><p>Total Customer</p></div>
                    <i class="fa-solid fa-user-group icon"></i>
                    <div class="bottom-bar bg-danger"></div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card">
                    <div><h5><%= totalCategory %></h5><p>Total Categories</p></div>
                    <i class="fas fa-download icon"></i>
                    <div class="bottom-bar bg-info"></div>
                </div>
            </div>
        </div>

        <div class="row mt-4">
            <div class="col-md-8">
                <div class="card p-3">
                    <h5>Today's Birthdays</h5>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Employee Name</th>
                            </tr>
                        </thead>
                        <tbody>
							<%
							    boolean hasBirthdays = false;
							    while (rsBirthday.next()) {
							        hasBirthdays = true;
							        String staffName = rsBirthday.getString("name");
							        String profilePic = rsBirthday.getString("image");
							%>
							    <tr>
							        <td><img src="<%= request.getContextPath() + "/" + profilePic %>" class="profile-pic" width="30" height="30" style="border-radius: 50%;"> <%= staffName %></td>
							    </tr>
							<%
							    }
							    if (!hasBirthdays) {
							%>
							    <tr>
							        <td colspan="2" class="text-center">No Birthdays Today</td>
							    </tr>
							<%
							    }
							%>
						</tbody>
                        
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<%
    rsBirthday.close();
    stmt2.close();
    conn.close();
%>

</body>
</html>
