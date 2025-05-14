<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee Registration</title>
    <style>
        body {
            font-family: 'Raleway', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
            color: #444;
            line-height: 1.6;
        }

        .registration-section {
            width: 100%;
            min-height: 100vh;
            align-items: center;
            padding: 100px 15px;
            display: flex;
            background-image: url('<%= request.getContextPath() %>/image/logo3.jpg');
            background-size: cover;
            background-position: center top;
            justify-content: center;
        }

        .registration-container {
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

        form input, form textarea, form select {
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
            background: #28a745;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        form button:hover {
            background: #218838;
        }

        .registration-info {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: #555;
        }

        .registration-info a {
            color: #28a745;
            text-decoration: none;
        }

        .registration-info a:hover {
            text-decoration: underline;
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
    <section class="registration-section">
        <div class="registration-container">
            <h2>Employee Registration</h2>

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
                window.location.href = "<%= request.getContextPath() %>/jsp_pages/index/employeelogin.jsp";
            <% } %>
        }, 3000);
    </script>
<% } %>
            

            <form action="${pageContext.request.contextPath}/register" method="post" enctype="multipart/form-data">
                <label for="full-name">Full Name</label>
                <input type="text" id="full-name" name="full_name" placeholder="Enter your full name" required>

                <label for="email">Email</label>
                <input type="email" id="email" name="email" placeholder="Enter your email" required>

                <label for="phone">Phone</label>
                <input type="tel" id="phone" name="phone" placeholder="Enter your phone number" pattern="[0-9]{10}" required>


                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="Create a password" required>
                
                <label for="dob">DOB: </label>
                <input type="date" id="dob" name="dob" required>

                <label for="address">Address</label>
                <textarea id="address" name="address" placeholder="Enter your address" rows="3" required></textarea>
				
				<label>Employee Image</label>
            	<input type="file" id="empImage" accept="image/*" name="empImage">
            	
                <button type="submit">Register</button>
            </form>
            
            <div class="registration-info">
                <p>Already have an account? <a href="<%= request.getContextPath() %>/jsp_pages/index/employeelogin.jsp">Login here</a></p>
            </div>
        </div>
    </section>
</body>
</html>
