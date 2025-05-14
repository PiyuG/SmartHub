<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, java.util.*, com.smart_hub.servlets.DBConection" %>
<%
    // Ensure user is logged in
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("employeeEmail") == null) {
        response.sendRedirect("jsp_pages/employee/login.jsp");
        return;
    }

    String loggedInEmail = (String) userSession.getAttribute("employeeEmail"); // Get user email from session

    Connection conn = DBConection.getConnection();
    PreparedStatement stmt = conn.prepareStatement("SELECT * FROM attendance WHERE email = ? ORDER BY date DESC");
    stmt.setString(1, loggedInEmail);
    ResultSet rs = stmt.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Attendance</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <style>
        body {
            background-color: #f8f9fa;
        }

        .main-content {
            margin-left: 300px; /* Left Margin */
            padding: 20px;
            transition: margin-left 0.3s ease-in-out;
        }

        .container {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        .table {
            margin-top: 20px;
        }

        .fade-in {
            animation: fadeIn 0.5s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
    </style>
</head>
<body>

<!-- Sidebar Include -->
<%@ include file="navbar.jsp" %>
<jsp:include page="sidebar.jsp" />

<div class="main-content">
    <div class="container mt-4 fade-in">
        <h3 class="text-center">My Attendance</h3>

        <!-- Filter Buttons -->
        <div class="d-flex justify-content-between mt-3">
            <input type="text" id="search" class="form-control w-25" placeholder="🔍 Search Date">
            <div>
                <button class="btn btn-primary" onclick="filterAttendance('all')">All</button>
                <button class="btn btn-success" onclick="filterAttendance('month')">Month</button>
                <button class="btn btn-warning" onclick="filterAttendance('week')">Week</button>
                <button class="btn btn-danger" onclick="filterAttendance('year')">Year</button>
            </div>
        </div>

        <!-- Attendance Table -->
        <table class="table table-bordered table-striped mt-3">
            <thead class="table-dark">
                <tr>
                    <th>Date</th>
                    <th>Check-In</th>
                    <th>Check-Out</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody id="attendanceTable">
                <%
                    while (rs.next()) {
                        String date = rs.getString("date");
                        String checkIn = rs.getString("check_in");
                        String checkOut = rs.getString("check_out");
                        String status = (checkOut == null) ? "<span class='text-warning'>Pending</span>" : "<span class='text-success'>Completed</span>";
                %>
                <tr>
                    <td><%= date %></td>
                    <td><%= checkIn %></td>
                    <td><%= checkOut %></td>
                    <td><%= status %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<script>
    // 🔹 Filter Attendance Data
    function filterAttendance(type) {
        let rows = document.querySelectorAll("#attendanceTable tr");
        let today = new Date();
        
        rows.forEach(row => {
            let date = new Date(row.children[0].textContent);
            row.style.display = "table-row";

            if (type === "month" && (today.getMonth() !== date.getMonth() || today.getFullYear() !== date.getFullYear())) {
                row.style.display = "none";
            }
            if (type === "week") {
                let weekAgo = new Date();
                weekAgo.setDate(today.getDate() - 7);
                if (date < weekAgo || today.getFullYear() !== date.getFullYear()) {
                    row.style.display = "none";
                }
            }
            if (type === "year" && today.getFullYear() !== date.getFullYear()) {
                row.style.display = "none";
            }
        });
    }

    // 🔹 Live Search Feature
    document.getElementById("search").addEventListener("keyup", function () {
        let value = this.value.toLowerCase();
        document.querySelectorAll("#attendanceTable tr").forEach(row => {
            let text = row.children[0].textContent.toLowerCase();
            row.style.display = text.includes(value) ? "table-row" : "none";
        });
    });
</script>

</body>
</html>

<%
    rs.close();
    conn.close();
%>
