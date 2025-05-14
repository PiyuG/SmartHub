<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*,java.io.*,java.sql.*,com.smart_hub.servlets.DBConection"%>
<%@ page import="jakarta.servlet.http.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Customer</title>
<style>
	.main-content {
	    margin-left: 260px;
	    padding: 20px;
	    transition: margin-left 0.3s;
	}
	.admin-panel {
	    background: white;
	    margin-top: 100px;
	    margin-left: 100px;
	    padding: 20px;
	    border-radius: 10px;
	    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	    width: 90%;
	    max-width: 900px;
	    overflow-x: auto;
	}
	.form-container {
	    display: flex;
	    flex-wrap: wrap;
	    gap: 20px;
	    justify-content: space-between;
	}
	.form-group {
	    display: flex;
	    flex-direction: column;
	    flex: 1 1 calc(50% - 10px);
	    min-width: 200px;
	}
	label {
	    font-weight: 600;
	    margin-bottom: 5px;
	}
	select, input {
	    padding: 8px;
	    border: 1px solid #ccc;
	    border-radius: 5px;
	    width: 100%;
	}
	.btn-container {
	    width: 100%;
	    text-align: center;
	    margin-top: 20px;
	}
	#btn {
	    background: #28a745;
	    color: white;
	    padding: 10px 20px;
	    border: none;
	    cursor: pointer;
	    border-radius: 5px;
	    font-size: 16px;
	}
	#btn:hover {
	    background: #218838;
	}

	.message-box {
	    text-align: center;
	    padding: 15px;
	    font-size: 16px;
	    font-weight: bold;
	    margin-bottom: 15px;
	    border-radius: 8px;
	    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
	    position: relative;
	    opacity: 1;
	    transition: opacity 0.5s ease-in-out;
	}
	
	.success {
	    background-color: #D4EDDA;
	    color: #155724;
	    border: 1px solid #C3E6CB;
	}
	
	.error {
	    background-color: #F8D7DA;
	    color: #721C24;
	    border: 1px solid #F5C6CB;
	}
	
	/* Close Button */
	.close-btn {
	    position: absolute;
	    top: 8px;
	    right: 12px;
	    font-size: 18px;
	    font-weight: bold;
	    cursor: pointer;
	    color: inherit;
	    background: none;
	    border: none;
	}
</style>
</head>
<body>
<%@ include file="navbar.jsp" %>
<jsp:include page="sidebar.jsp" />

<div class="main-content">
    <div class="admin-panel">
      <h2>Add Customer</h2>
      <!-- Display success or error message -->
            <% String message = (String) request.getAttribute("message"); %>
            <% String messageType = (String) request.getAttribute("messageType"); %>
            <% if (message != null) { %>
    		<div class="message-box <%= messageType %>">
        	<span class="close-btn" onclick="this.parentElement.style.display='none';">&times;</span>
        	<%= message %>
    	</div>
    <script>
        // Hide message after 3 seconds with fade-out effect
        setTimeout(function() {
            let messageBox = document.querySelector('.message-box');
            if (messageBox) {
                messageBox.style.opacity = '0';
                setTimeout(() => messageBox.style.display = 'none', 500);
            }
            <% if ("success".equals(messageType)) { %>
                window.location.href = "<%= request.getContextPath() %>/jsp_pages/admin/addCustomer.jsp";
            <% } %>
        }, 3000);
    </script>
<% } %>
    <form action="${pageContext.request.contextPath}/Registration" method="POST" class="form-container">
        <div class="form-group">
            <label>Name: </label>
            <input type="text" name="full_name" required>
        </div>

        <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" required>
        </div>

        <div class="form-group">
            <label>Mobile No. </label>
            <input type="tel" name="phone" required>
        </div>

        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" required>
        </div>

        <div class="form-group">
            <label>Address</label>
            <input type="text" name="address" required>
        </div>


        <div class="btn-container">
            <button type="submit" id="btn">Add Customer</button>
        </div>
    </form>
</div>
</div>
</body>
</html>
