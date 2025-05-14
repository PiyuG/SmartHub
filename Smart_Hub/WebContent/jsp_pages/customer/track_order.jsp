<%@ page import="java.sql.*, jakarta.servlet.*, jakarta.servlet.http.*, java.util.*" %>
<%@ page import="com.smart_hub.servlets.DBConection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String orderId = request.getParameter("order_id");
    String status = "Processed";
    Connection conn = DBConection.getConnection();
    PreparedStatement ps = conn.prepareStatement("SELECT status FROM orders WHERE order_id = ?");
    ps.setString(1, orderId);
    ResultSet rs = ps.executeQuery();
    if (rs.next()) {
        status = rs.getString("status");
    }
    rs.close();
    ps.close();
    conn.close();

    List<String> steps = java.util.Arrays.asList("Processing", "Shipped", "Out for Delivery", "Delivered");
%>
<html>
<head>
    <title>Track Order</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css"/>
    <style>
        body { background-color: #f0f4ff; font-family: 'Segoe UI'; }
        .tracker-container {
            max-width: 800px;
            margin: 40px auto;
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        }
        .stepper {
            display: flex;
            justify-content: space-between;
            position: relative;
            margin: 40px 0;
        }
        .stepper::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 15%;
            right: 15%;
            height: 4px;
            background: #ccc;
            z-index: 0;
        }
        .step {
            position: relative;
            text-align: center;
            z-index: 1;
            flex: 1;
        }
        .circle {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            background: #ccc;
            margin: 0 auto;
            display: flex;
            justify-content: center;
            align-items: center;
            font-weight: bold;
            color: white;
        }
        .step.active .circle,
        .step.done .circle {
            background: #7b2cbf;
        }
        .step.done .circle::after {
            content: '✓';
        }
        .step p {
            margin-top: 8px;
            font-size: 14px;
            font-weight: 500;
        }
    </style>
</head>
<body>
<div class="tracker-container">
    <h3 class="mb-4">Tracking Order #<%= orderId %></h3>
    <div class="stepper">
        <%
            for (String step : steps) {
                String className = "";
                if (steps.indexOf(step) < steps.indexOf(status)) {
                    className = "step done";
                } else if (steps.indexOf(step) == steps.indexOf(status)) {
                    className = "step active";
                } else {
                    className = "step";
                }
        %>
        <div class="<%= className %>">
            <div class="circle"></div>
            <p>Order <%= step %></p>
        </div>
        <%
            }
        %>
    </div>
    <div class="text-center">
        <a href="orderHistory.jsp" class="btn btn-secondary">Back to Orders</a>
    </div>
</div>
</body>
</html>
