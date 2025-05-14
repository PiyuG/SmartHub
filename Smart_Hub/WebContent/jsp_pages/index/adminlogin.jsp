<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login</title>
    <style>
        body {
            font-family: 'Raleway', sans-serif;
            font-weight: 400;
            margin: 0;
            padding: 0;
            line-height: 1.5;
            background: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .adminlogin-section {
            width: 100%;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            background-image: url('<%= request.getContextPath() %>/image/logo3.jpg');
            background-size: cover;
            background-position: center top;
        }


        .login-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            padding: 2rem;
            max-width: 400px;
            width: 100%;
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
            font-size: 1.8rem;
            color: #333;
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        form label {
            font-size: 14px;
            font-weight: bold;
            color: #555;
        }

        form input {
            padding: 10px;
            font-size: 14px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
            width: 100%;
        }

        form button {
            padding: 10px;
            font-size: 16px;
            background: #007bff;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        form button:hover {
            background: #0056b3;
        }

        .admin-info {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: #555;
        }

        .admin-info a {
            color: #007bff;
            text-decoration: none;
        }

        .admin-info a:hover {
            text-decoration: underline;
        }

        @media (max-width: 768px) {
            .login-container {
                padding: 1.5rem;
            }

            h2 {
                font-size: 1.6rem;
            }
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
    <%@ include file="header.jsp" %>
    <section class="adminlogin-section">
    <div class="login-container">
        <h2>Admin Login</h2>
        <% String message = (String) request.getAttribute("message"); %>
	            <% String messageType = (String) request.getAttribute("messageType"); %>
	            <% if (message != null) { %>
	    		<div class="message-box <%= messageType %>">
		        	<span class="close-btn" onclick="this.parentElement.style.display='none';">&times;</span>
		        	<%= message %>
    			</div>
    			<script>
			        setTimeout(function() {
			            let messageBox = document.querySelector('.message-box');
			            if (messageBox) {
			                messageBox.style.opacity = '0';
			                setTimeout(() => messageBox.style.display = 'none', 500);
			            }
			            <% if ("success".equals(messageType)) { %>
			                window.location.href = "<%= request.getContextPath() %>/jsp_pages/index/employeelogin.jsp";
			            <% } %>
			        }, 3000);
			    </script>
			<% } %>
        
        <form action="${pageContext.request.contextPath}/AdminLogin" method="post">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" placeholder="Username" required>

            <label for="password">Password:</label>
            <input type="password" id="password" name="password" placeholder="Password" required>

            <button type="submit">Login</button>
        </form>
        <div class="admin-info">
            <p>Forgot password? <a href="<%= request.getContextPath() %>/jsp_pages/index/forgetpassword.jsp">Click here</a></p>
        </div>
    </div>
    </section>
</body>
</html>
