<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Employee Invoice</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .invoice-box {
            margin: 50px auto;
            max-width: 600px;
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        /* Hide header and sidebar during printing */
        @media print {
            #navbar, #sidebar { 
                display: none !important; 
            }
        }
    </style>
</head>
<body>
<%@ include file="navbar.jsp" %>
<jsp:include page="sidebar.jsp" />
<div class="invoice-box">
    <h2 class="text-center">SmartHub - Purchase Invoice</h2>
    <hr/>
    <p><strong>Product:</strong> <%= request.getAttribute("productName") %></p>
    <p><strong>Quantity:</strong> <%= request.getAttribute("quantity") %></p>
    <p><strong>Total Amount:</strong> ₹<%= request.getAttribute("total") %></p>
    <p><strong>Date:</strong> <%= new java.util.Date() %></p>
    <hr/>
    <div class="text-center">
        <button class="btn btn-primary" onclick="window.print()">Print Invoice</button>
        <a href="buyProduct.jsp" class="btn btn-secondary">Back</a>
    </div>
</div>
</body>
</html>
