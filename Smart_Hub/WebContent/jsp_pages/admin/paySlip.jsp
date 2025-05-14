<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.smart_hub.servlets.DBConection" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>SmartHub Payslip</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f1f3f5;
            margin: 0;
            padding: 40px;
        }
        .payslip-container {
            max-width: 800px;
            background: white;
            margin: auto;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.1);
        }
        .header, .footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .title {
            font-size: 26px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .info {
            font-size: 14px;
            margin-top: 10px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 25px;
        }
        table th, table td {
            padding: 12px;
            text-align: left;
            border: 1px solid #dee2e6;
        }
        table th {
            background-color: #f8f9fa;
        }
        .total-row td {
            font-weight: bold;
            background-color: #f1f3f5;
        }
        .thanks {
            text-align: center;
            margin-top: 25px;
            font-size: 14px;
            color: #555;
        }
        .btn-download {
            display: block;
            margin: 30px auto 0;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            font-size: 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }
        .btn-download:hover {
            background-color: #0056b3;
        }
        .error {
            text-align: center;
            color: red;
            font-size: 20px;
        }
    </style>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script>
        window.jsPDF = window.jspdf.jsPDF;
        function downloadPayslip() {
            const element = document.querySelector(".payslip-container");
            html2canvas(element, { scale: 2 }).then(canvas => {
                const imgData = canvas.toDataURL("image/png");
                const pdf = new jsPDF("p", "mm", "a4");
                const imgWidth = 210;
                const imgHeight = (canvas.height * imgWidth) / canvas.width;
                pdf.addImage(imgData, "PNG", 0, 10, imgWidth, imgHeight);
                pdf.save("SmartHub_Payslip.pdf");
            });
        }
    </script>
</head>
<body>
<%
    String empId = request.getParameter("employee_id");
    if (empId == null || empId.isEmpty()) {
%>
    <div class="error">No employee ID provided.</div>
<%
    } else {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConection.getConnection();
            ps = conn.prepareStatement("SELECT u.name, u.mail, u.mobno, u.address, s.* FROM users u JOIN salary_payments s ON u.id = s.employee_id WHERE u.id = ? ORDER BY s.date DESC LIMIT 1");
            ps.setInt(1, Integer.parseInt(empId));
            rs = ps.executeQuery();
            if (rs.next()) {
%>
<div class="payslip-container">
    <div class="header">
        <div>
            <div class="title">SmartHub Payslip</div>
            <div class="info">Invoice ID: <strong>#<%= rs.getInt("id") %></strong></div>
            <div class="info">Date: <strong><%= rs.getDate("date") %></strong></div>
        </div>
        <div style="text-align: right;">
            <strong>Mahalakshmi Store</strong><br>
            admin@smarthub.com<br>
            +91-9876543210
        </div>
    </div>

    <hr style="margin: 20px 0;">

    <div>
        <strong>Bill To:</strong><br>
        <%= rs.getString("name") %><br>
        <%= rs.getString("mail") %><br>
        <%= rs.getString("mobno") %><br>
        <%= rs.getString("address") %>
    </div>

    <table>
        <tr>
            <th>#</th>
            <th>Description</th>
            <th>Amount (₹)</th>
        </tr>
        <tr>
            <td>1</td>
            <td>Base Salary</td>
            <td>₹<%= rs.getDouble("base_salary") %></td>
        </tr>
        <tr>
            <td>2</td>
            <td>Overtime</td>
            <td>₹<%= rs.getDouble("overtime") %></td>
        </tr>
        <tr>
            <td>3</td>
            <td>Deductions</td>
            <td>- ₹<%= rs.getDouble("deductions") %></td>
        </tr>
        <tr class="total-row">
            <td colspan="2">Net Salary</td>
            <td>₹<%= rs.getDouble("net_salary") %></td>
        </tr>
    </table>

    <div class="thanks">
        Thank you for your hard work and dedication!<br>
        This is a system-generated payslip.
    </div>
</div>

<button class="btn-download" onclick="downloadPayslip()">Download Payslip</button>
<%
            } else {
%>
    <div class="error">No payslip found for this employee.</div>
<%
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
%>
    <div class="error">Something went wrong while loading the payslip.</div>
<%
        }
    }
%>
</body>
</html>
