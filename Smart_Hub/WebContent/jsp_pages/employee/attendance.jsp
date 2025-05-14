<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, java.time.LocalDate, java.time.format.DateTimeFormatter,com.smart_hub.servlets.DBConection"%>

<%
    Connection conn = DBConection.getConnection();
    String email = (String) session.getAttribute("employeeEmail");

    LocalDate today = LocalDate.now();
    String formattedDate = today.format(DateTimeFormatter.ofPattern("dd MMMM yyyy"));

    PreparedStatement ps = conn.prepareStatement("SELECT check_in, check_out FROM attendance WHERE email = ? AND date = CURDATE()");
    ps.setString(1, email);
    ResultSet rs = ps.executeQuery();

    String checkInTime = "--:--", checkOutTime = "--:--";
    if (rs.next()) {
        checkInTime = (rs.getString("check_in") != null) ? rs.getString("check_in") : "--:--";
        checkOutTime = (rs.getString("check_out") != null) ? rs.getString("check_out") : "--:--";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="ISO-8859-1">
    <title>Employee Attendance</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .container { max-width: 500px; margin-top: 100px; text-align: center; margin-left:300 px;}
        .card { border-radius: 15px; box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1); padding: 25px; transition: 0.3s; }
        .card:hover { transform: translateY(-5px); }
        .btn { font-size: 18px; padding: 12px 20px; border-radius: 8px; transition: 0.3s; }
        .btn:hover { transform: scale(1.05); }
        .time-display { font-size: 22px; font-weight: bold; color: #343a40; margin-top: 15px; }
        .fade-in { animation: fadeIn 1s ease-in-out; }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
<%@ include file="navbar.jsp" %>
<jsp:include page="sidebar.jsp" />

<div class="container">
    <div class="card fade-in">
        <h3 class="mb-4">Employee Attendance</h3>
        
        <h5><i class="fas fa-calendar-day"></i> <%= formattedDate %></h5> <!-- Displays Today's Date -->

        <p class="time-display">Check-In Time: <span id="checkIn"><%= checkInTime %></span></p>
        <p class="time-display">Check-Out Time: <span id="checkOut"><%= checkOutTime %></span></p>
        
        <form action="${pageContext.request.contextPath}/attendance" method="post">
            <button type="submit" name="action" value="checkin" class="btn btn-success w-100 mb-2" <%= (checkInTime.equals("--:--")) ? "" : "disabled" %>>
                <i class="fas fa-sign-in-alt"></i> Check In
            </button>
            <button type="submit" name="action" value="checkout" class="btn btn-danger w-100" <%= (checkInTime.equals("--:--") || !checkOutTime.equals("--:--")) ? "disabled" : "" %>>
                <i class="fas fa-sign-out-alt"></i> Check Out
            </button>
        </form>
    </div>
</div>

</body>
</html>
