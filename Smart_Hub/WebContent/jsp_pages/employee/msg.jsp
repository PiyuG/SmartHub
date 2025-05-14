<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Employee Dashboard</title>
    <style>
        .msg { padding: 10px; margin: 20px 0; }
        .success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
    </style>
</head>
<body>
<%@ include file="navbar.jsp" %>
<jsp:include page="sidebar.jsp" />
<% 
    // Retrieve the success message from session
    String successMessage = (String) session.getAttribute("successMessage");
    
    if (successMessage != null) {
%>
    <div class="msg success">
        <%= successMessage %>
    </div>
<% 
        // Clear the success message after displaying it
        session.removeAttribute("successMessage");
    }
%>

<!-- Employee dashboard content goes here -->

</body>
</html>
