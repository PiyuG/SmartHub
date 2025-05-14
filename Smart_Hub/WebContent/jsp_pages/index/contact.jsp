<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Contact Us</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css2?family=Raleway:wght@400;600;700&display=swap" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"/>

    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Raleway', sans-serif;
            background: linear-gradient(to right, #eef2f3, #8e9eab);
            color: #333;
        }

        .contact-section {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: url('<%= request.getContextPath() %>/image/logo3.jpg') no-repeat center top / cover;
            padding: 40px 20px;
        }

        .contact-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 2rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            max-width: 1100px;
            width: 100%;
            display: flex;
            gap: 30px;
            animation: fadeIn 1s ease;
        }

        .form-section, .info-section {
            flex: 1;
        }

        h2 {
            font-size: 2rem;
            margin-bottom: 1rem;
            color: #007BFF;
            position: relative;
            text-align: center;
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        label {
            font-weight: 600;
            color: #444;
        }

        input, textarea {
            padding: 12px;
            border-radius: 10px;
            border: 1px solid #ccc;
            transition: border 0.3s ease, box-shadow 0.3s ease;
        }

        input:focus, textarea:focus {
            border-color: #007BFF;
            box-shadow: 0 0 8px rgba(0, 123, 255, 0.2);
            outline: none;
        }

        button {
            background: linear-gradient(to right, #007bff, #00c6ff);
            color: white;
            border: none;
            padding: 12px;
            border-radius: 50px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        button:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 123, 255, 0.4);
        }

        .info-section h3 {
            font-size: 1.5rem;
            margin-bottom: 10px;
            color: #007BFF;
        }

        .info-section p {
            margin-bottom: 10px;
            line-height: 1.8;
            color: #444;
        }

        .info-section ul {
            padding: 0;
            list-style: none;
        }

        .info-section ul li {
            margin-bottom: 10px;
            color: #333;
            font-size: 14px;
        }

        .info-section ul li i {
            margin-right: 10px;
            color: #007BFF;
        }

        @media (max-width: 768px) {
            .contact-container {
                flex-direction: column;
            }
        }

        @keyframes fadeIn {
            from {opacity: 0; transform: translateY(40px);}
            to {opacity: 1; transform: translateY(0);}
        }
        
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>

    <section class="contact-section">
        <div class="contact-container">
            <!-- Form Section -->
            <div class="form-section">
                <h2>Get in Touch</h2>
                <form action="#" method="post">
                    <label for="name">Name</label>
                    <input type="text" name="name" id="nameInput" placeholder="Enter your name" required>

                    <label for="mail">Email</label>
                    <input type="email" name="mail" id="mailInput" placeholder="Enter your email" required>

                    <label for="message">Message</label>
                    <textarea name="message" id="messageInput" rows="5" placeholder="Write your message here" required></textarea>

                    <button type="submit">Send Message</button>
                </form>
            </div>

            <!-- Info Section -->
            <div class="info-section">
                <h3>Contact Information</h3>
                <p>Feel free to reach out to us anytime. We are here to help you 24/7.</p>
                <ul>
                    <li><i class="fas fa-phone"></i> +91-9876543210</li>
                    <li><i class="fas fa-map-marker-alt"></i> SmartHub HQ, 2nd Floor, Tech Park, MG Road, Pune, Maharashtra 411001</li>
                </ul>
                <p>We'll get back to you as soon as possible. Thanks for contacting us!</p>
            </div>
        </div>
    </section>

</body>
</html>
