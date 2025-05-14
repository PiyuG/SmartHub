<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
 <title>Success</title>
    <script>
        window.onload = function() {
            var message = "<%= request.getParameter("msg") %>";
            if (message !== "null") {
                alert(message);
                window.location.href = "employeelogin.jsp"; // Redirect to login page
            }
        };
    </script>
</head>
<body>
<div class="message-box message-box-success">
  <i class="fa fa-check fa-2x"></i>
  <span class="message-text"><strong>Success:</strong>Successfully Registration!</span>
  <i class="fa fa-times fa-2x exit-button "></i>
</div>
</body>
</html>