<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Checkout - Address</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f0f2f5;
            font-family: 'Segoe UI', sans-serif;
        }
        .checkout-container {
            max-width: 600px;
            margin: 50px auto;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 30px;
        }
        h2 {
            text-align: center;
            margin-bottom: 25px;
            font-weight: 600;
            color: #333;
        }
        input, textarea {
            margin-bottom: 15px;
        }
        @media (max-width: 768px) {
            .checkout-container {
                margin: 20px;
                padding: 20px;
            }
        }
    </style>
</head>
<body>
<%@ include file="navbar.jsp" %>
<jsp:include page="sidebar.jsp" />
<div class="checkout-container">
    <h2>Enter Delivery Address</h2>
    <form action="orderReview.jsp" method="post">
        <div class="form-floating mb-3">
            <input type="text" name="name" class="form-control" id="floatingName" placeholder="Full Name" required>
            <label for="floatingName">Full Name</label>
        </div>
        <div class="form-floating mb-3">
            <input type="text" name="phone" class="form-control" id="floatingPhone" placeholder="Phone Number" required>
            <label for="floatingPhone">Phone Number</label>
        </div>
        <div class="form-floating mb-3">
            <input type="text" name="pincode" class="form-control" id="floatingPin" placeholder="Pincode" required>
            <label for="floatingPin">Pincode</label>
        </div>
        <div class="form-floating mb-3">
            <textarea name="address" class="form-control" placeholder="Full Address" id="floatingAddress" style="height: 100px" required></textarea>
            <label for="floatingAddress">Full Address</label>
        </div>
        <button type="submit" class="btn btn-primary w-100">Continue to Review</button>
    </form>
</div>
</body>
</html>
