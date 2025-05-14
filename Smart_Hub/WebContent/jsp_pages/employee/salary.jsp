<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.smart_hub.servlets.DBConection" %>
<%
    Integer employeeId = (session != null) ? (Integer) session.getAttribute("empId") : null;
    if (employeeId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SmartHub Payslip</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script>window.jsPDF = window.jspdf.jsPDF;</script>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f4f6f9; margin: 0; color: #333; }
        .main-content { margin-left: 260px; padding: 20px; }
        .invoice-box {
            width: 80%; margin: 40px auto; padding: 30px;
            background: #fff; border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        .header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
        }
        .title {
            font-size: 24px;
            font-weight: bold;
        }
        .right-header {
            text-align: right;
            line-height: 1.6;
        }
        .details {
            margin: 20px 0;
            border-top: 1px solid #ccc;
            padding-top: 20px;
        }
        .details p {
            margin: 4px 0;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            border: 1px solid #ddd;
        }
        th {
            background: #f3f4f6;
            text-align: left;
        }
        .total-row {
            background: #f3f4f6;
            font-weight: bold;
        }
        .note {
            margin-top: 30px;
            text-align: center;
            font-size: 14px;
            color: #555;
        }
        .btn {
            display: block;
            margin: 30px auto 0;
            padding: 12px 24px;
            background-color: #007bff;
            color: white;
            font-size: 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }
        .btn:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
<%
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    try {
        conn = DBConection.getConnection();
        stmt = conn.prepareStatement("SELECT u.name, u.mail, u.mobno, u.address, s.* FROM users u JOIN salary_payments s ON u.id = s.employee_id WHERE u.id = ? ORDER BY s.date DESC LIMIT 1");
        stmt.setInt(1, employeeId);
        rs = stmt.executeQuery();
        if (rs.next()) {
            int invoiceId = rs.getInt("id");
%>
<%@ include file="navbar.jsp" %>
<jsp:include page="sidebar.jsp" />

<div class="main-content">
<div class="container" id="payslip">
    <div class="header">
        <div class="title">
            SmartHub Payslip<br>
            <small>Invoice ID: <strong>#<%= invoiceId %></strong></small><br>
            <small>Date: <strong><%= rs.getDate("date") %></strong></small>
        </div>
        <div class="right-header">
            <strong>Mahalakshmi Store</strong><br>
            admin@smarthub.com<br>
            +91-9876543210
        </div>
    </div>
    <div class="details">
        <h4>Bill To:</h4>
        <p><%= rs.getString("name") %></p>
        <p><%= rs.getString("mail") %></p>
        <p><%= rs.getString("mobno") %></p>
        <p><%= rs.getString("address") %></p>
    </div>
    <table>
        <thead>
            <tr>
                <th>#</th>
                <th>Description</th>
                <th>Amount (₹)</th>
            </tr>
        </thead>
        <tbody>
            <tr><td>1</td><td>Base Salary</td><td>₹<%= rs.getDouble("base_salary") %></td></tr>
            <tr><td>2</td><td>Overtime</td><td>₹<%= rs.getDouble("overtime") %></td></tr>
            <tr><td>3</td><td>Deductions</td><td>- ₹<%= rs.getDouble("deductions") %></td></tr>
            <tr class="total-row"><td colspan="2">Net Salary</td><td>₹<%= rs.getDouble("net_salary") %></td></tr>
        </tbody>
    </table>
    <div class="note">
        Thank you for your hard work and dedication!<br>
        This is a system-generated payslip.
    </div>
</div>
<button class="btn" onclick="downloadPDF()">Download Payslip</button>
</div>
<script>
    function downloadPDF() {
        html2canvas(document.getElementById("payslip"), { scale: 2 }).then(canvas => {
            const imgData = canvas.toDataURL("image/png");
            const pdf = new jsPDF('p', 'mm', 'a4');
            const imgWidth = 210;
            const imgHeight = (canvas.height * imgWidth) / canvas.width;
            pdf.addImage(imgData, 'PNG', 0, 10, imgWidth, imgHeight);
            pdf.save("SmartHub_Payslip.pdf");
        });
    }
</script>
<%
        } else {
            out.println("<p style='color:red;text-align:center;'>No payslip data available.</p>");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
</body>
</html>
