<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*, java.io.*,java.sql.*,com.smart_hub.servlets.DBConection" %>
<%@ page import="jakarta.servlet.http.*"%>
<%
List<Map<String, String>> products = new ArrayList<>();
Set<String> departments = new HashSet<>();

try (Connection conn = DBConection.getConnection()) {
    if (conn != null) {
        PreparedStatement stmt1 = conn.prepareStatement("SELECT * FROM products");
        //PreparedStatement stmt2 = conn.prepareStatement("SELECT department FROM department");

        ResultSet rs = stmt1.executeQuery();
        while (rs.next()) {
            Map<String, String> product = new HashMap<>();
            product.put("id", String.valueOf(rs.getInt("prod_id")));
            product.put("name", rs.getString("name"));
            product.put("price",rs.getString("price"));
            products.add(product);
        }
        rs.close();
        stmt1.close();

        //ResultSet rsd = stmt2.executeQuery();
        //while (rsd.next()) {
          //  departments.add(rsd.getString("department"));
        //}
        //rsd.close();
        //stmt2.close();
    }
} catch (Exception e) {
    e.printStackTrace();
}

%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Offer on Product</title>
    <style>
    .main-content {
    margin-left: 260px; /* Adjust based on sidebar width */
    padding: 20px;
    transition: margin-left 0.3s;
}
        .container {
            width: 100%;
            max-width: 700px;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        h2 {
            text-align: center;
            color: #333;
        }

        .form-row {
            display: flex;
            gap: 15px;
        }

        .form-group {
            flex: 1;
            margin-bottom: 15px;
        }

        label {
            font-weight: bold;
            display: block;
            margin-bottom: 5px;
        }

        input, select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        #btn {
            padding: 10px;
            width: 100%;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            margin-top: 10px;
            color: white;
            background: #28a745;
            font-size: 16px;
        }

        #btn:hover {
            background: #218838;
        }

        /* Responsive Design */
        @media (max-width: 600px) {
            .form-row {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
<%@ include file="navbar.jsp" %>
<jsp:include page="sidebar.jsp" />

<div class="main-content">
<div class="container">
    <h2>Add Offer on Product</h2>
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
	                window.location.href = "<%= request.getContextPath() %>/jsp_pages/admin/addOffers.jsp";
	            <% } %>
	        }, 3000);
	    </script>
	<% } %>
    <form id="addOfferForm" action="${pageContext.request.contextPath}/addOffers" method="post">
        <div class="form-group">
            <label>Select Product</label>
            <select id="productSelect" name="product" onchange="fillProductPrice()">
                <option value="" disabled selected>Select Product</option>
	                <% for (Map<String, String> product : products) { %>
	        			<option value="<%= product.get("id") %>" data-price="<%= product.get("price") %>">
	            	<%= product.get("name") %>
        		</option>
    		<% } %>
          </select>
        </div>

        <div class="form-group">
            <label>Original Price</label>
            <input type="number" id="originalPrice" name="price" readonly>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label>Discount Type</label>
                <select id="discountType" name="discountType" onchange="calculateOfferPrice()">
                    <option value="percentage">Percentage (%)</option>
                    <option value="fixed">Fixed Amount </option>
                </select>
            </div>
            <div class="form-group">
                <label>Discount Value</label>
                <input type="number" id="discountValue" name="discountValue" oninput="calculateOfferPrice()">
            </div>
        </div>

        <div class="form-group">
            <label>Final Price After Discount </label>
            <input type="number" id="finalPrice" name="finalPrice" readonly>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label>Offer Start Date</label>
                <input type="date" id="startDate" name="startDate">
            </div>
            <div class="form-group">
                <label>Offer End Date</label>
                <input type="date" id="endDate" name="endDate">
            </div>
        </div>

        <button type="submit" id="btn">Add Offer</button>
    </form>
</div>
</div>

<script>
    function fillProductPrice() {
        let productSelect = document.getElementById("productSelect");
        let selectedOption = productSelect.options[productSelect.selectedIndex];
        let price = selectedOption.getAttribute("data-price"); 

        document.getElementById("originalPrice").value = price;
        calculateOfferPrice();
    }

    function calculateOfferPrice() {
        let price = parseFloat(document.getElementById("originalPrice").value) || 0;
        let discountType = document.getElementById("discountType").value;
        let discountValue = parseFloat(document.getElementById("discountValue").value) || 0;
        let finalPrice = price;

        if (discountType === "percentage") {
            finalPrice = price - (price * (discountValue / 100));
        } else if (discountType === "fixed") {
            finalPrice = price - discountValue;
        }

        // Ensure the final price is never negative
        finalPrice = Math.max(finalPrice, 0);

        document.getElementById("finalPrice").value = finalPrice.toFixed(2);
    }


    // Attach event listeners to automatically update the final price
    document.getElementById("discountValue").addEventListener("input", calculateOfferPrice);
    document.getElementById("discountType").addEventListener("change", calculateOfferPrice);
</script>


</body>
</html>
