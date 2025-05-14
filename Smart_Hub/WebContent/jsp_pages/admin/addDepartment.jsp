<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Department & Designation Management</title>
    <style>
        .main-content {
    margin-left: 260px; /* Adjust based on sidebar width */
    padding: 20px;
    transition: margin-left 0.3s;
}
        .container {
        	width:300px;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            margin: 30px;
        }
        form{
        margin:auto;
        width:500px;
        }
        label {
            font-weight: bold;
            display: block;
            margin-top: 10px;
        }
        input {
    width: calc(100% - 16px); /* Ensures input fits within the form */
    padding: 8px;
    margin: 10px 0; /* Only top & bottom margin */
    border: 1px solid #ccc;
    border-radius: 5px;
}
        button {
        margin-top: 20px;
            background-color: blue;
            color: white;
            padding: 10px;
            border: none;
            width: 100%;
            border-radius: 15px;
            cursor: pointer;
            font-size: 16px;
        }
        button:hover {
            background-color: darkblue;
        }
        /* Message Box Styling */
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
    <div class="container">
        <h2>Department & Designation Form</h2>
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
	                window.location.href = "<%= request.getContextPath() %>/jsp_pages/admin/addDepartment.jsp";
	            <% } %>
	        }, 3000);
	    </script>
	<% } %>
        <form id="departmentForm" action="${pageContext.request.contextPath}/addDepartment" method="post">
            
            <label for="department">Department Name:</label>
            <input type="text" id="department" name="department" required>
            
            <label for="designation">Designation:</label>
            <input type="text" id="designation" name="designation" required><br><hr>
            
            <button type="submit">Save</button>
        </form>
    </div>
    </div>
    <script>
    window.onload = function() {
        function refreshProfilePic() {
            let profilePic = document.getElementById("profilePic");
            if (profilePic) {
                profilePic.src = profilePic.src.split("?")[0] + "?" + new Date().getTime();
            }
        }

        let form = document.querySelector("form");
        if (form) {
            form.addEventListener("submit", function() {
                refreshProfilePic();
            });
        }
    };
</script>
</body>
</html>
