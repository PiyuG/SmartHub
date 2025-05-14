<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, com.smart_hub.servlets.DBConection"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Salary Payment</title>
<style>
    .main-content { margin-left: 260px; padding: 20px; transition: margin-left 0.3s; }
    .container { background: white; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); width: 400px; text-align: center; }
    h2 { color: #007bff; }
    .form-group { text-align: left; margin-bottom: 15px; }
    select, input { width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 5px; }
    #btn_download,#btn_pay { 
    	background: #28a745;
	    color: white;
	    padding: 10px 20px;
	    border: none;
	    cursor: pointer;
	    border-radius: 5px;
	    font-size: 16px; }
    .pay { background: #28a745; color: white; }
    .download { background: #007bff; color: white; }
    #btn_pay,#btn_download:hover { background: #218838; }
    .msg { margin-top: 10px; padding: 10px; border-radius: 5px; }
    .success { background-color: #28a745; color: white; }
    .error { background-color: #dc3545; color: white; }
</style>
</head>
<body>

<%@ include file="navbar.jsp" %>
<jsp:include page="sidebar.jsp" />

<div class="main-content">
<div class="container">
    <h2>Salary Payment</h2>

    <form action="${pageContext.request.contextPath}/salaryPayment" method="POST" onsubmit="return validateForm()">
        <div class="form-group">
            <label>Select Employee</label>
            <select name="employee_id" id="employeeSelect" onchange="fillSalaryDetails()">
                <option value="" disabled selected>Select Employee</option>
                <%
                    Connection conn = DBConection.getConnection();
                    PreparedStatement stmt = conn.prepareStatement("SELECT id, name, salary FROM users");
                    ResultSet rs = stmt.executeQuery();
                    while (rs.next()) {
                %>
                <option value="<%= rs.getInt("id") %>" data-salary="<%= rs.getDouble("salary") %>">
                    <%= rs.getString("name") %>
                </option>
                <%
                    }
                    rs.close();
                    stmt.close();
                    conn.close();
                %>
            </select>
        </div>

        <div class="form-group">
            <label>Base Salary</label>
            <input type="number" id="baseSalary" name="base_salary" readonly>
        </div>

        <div class="form-group">
            <label>Overtime</label>
            <input type="number" id="overtime" name="overtime" oninput="calculateNetSalary()">
        </div>

        <div class="form-group">
            <label>Deductions</label>
            <input type="number" id="deductions" name="deductions" oninput="calculateNetSalary()">
        </div>

        <div class="form-group">
            <label>Net Salary</label>
            <input type="number" id="netSalary" name="net_salary" readonly>
        </div>

        <button type="submit" id="btn_pay">Approve Payment</button>
        <button type="button" id="btn_download" onclick="downloadPayslip()">Download Payslip</button>
    </form>

    <div id="messageContainer"></div>

    <% if (request.getParameter("success") != null) { %>
    <div id="successMsg" class="msg success">Salary payment recorded successfully!</div>
	<% } else if (request.getParameter("error") != null) { 
	    String errorType = request.getParameter("error");
	    if ("duplicate".equals(errorType)) { %>
	        <div id="errorMsg" class="msg error">Salary for this month has already been recorded!</div>
	    <% } else { %>
	        <div id="errorMsg" class="msg error">Error recording salary payment.</div>
	    <% }
	} %>
    
</div>
</div>

<script>
    function fillSalaryDetails() {
        let selectedOption = document.getElementById("employeeSelect").selectedOptions[0];
        let baseSalary = selectedOption.getAttribute("data-salary");
        document.getElementById("baseSalary").value = baseSalary;
        calculateNetSalary();
    }

    function calculateNetSalary() {
        let base = parseFloat(document.getElementById("baseSalary").value) || 0;
        let overtime = parseFloat(document.getElementById("overtime").value) || 0;
        let deduction = parseFloat(document.getElementById("deductions").value) || 0;
        document.getElementById("netSalary").value = base + overtime - deduction;
    }

    function downloadPayslip() {
        let employeeId = document.getElementById("employeeSelect").value;
        if (employeeId) {
            window.open("paySlip.jsp?employee_id=" + employeeId, "_blank");
        } else {
            alert("Please select an employee.");
        }
    }

    function validateForm() {
        if (!document.getElementById("employeeSelect").value) {
            alert("Please select an employee.");
            return false;
        }
        return true;
    }

    // Hide messages after 5 seconds
    window.onload = function() {
        setTimeout(() => {
            let successMsg = document.getElementById("successMsg");
            let errorMsg = document.getElementById("errorMsg");
            if (successMsg) successMsg.style.display = "none";
            if (errorMsg) errorMsg.style.display = "none";
        }, 5000);
    }
</script>

</body>
</html>
