<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*,java.io.*,java.sql.*,com.smart_hub.servlets.DBConection"%>
<%@ page import="jakarta.servlet.http.*"%>
<!DOCTYPE html>
<html lang="en">
<%
	int recordCount = 0;
	List<Map<String, String>> categories = new ArrayList<>();
	try (Connection conn = DBConection.getConnection()) {
	    if (conn != null) {
	        PreparedStatement stmt1 = conn.prepareStatement("SELECT category_id, category_name FROM category");
	        ResultSet rs = stmt1.executeQuery();
	        while (rs.next()) {
	            Map<String, String> category = new HashMap<>();
	            category.put("id", String.valueOf(rs.getInt("category_id")));
	            category.put("name", rs.getString("category_name"));
	            categories.add(category);
	        }
	        rs.close();
	        stmt1.close();
	    }
	} catch (Exception e) {
	    e.printStackTrace();
	}
%>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Product</title>
    <style>
        .main-content { margin-left: 260px; padding: 20px; transition: margin-left 0.3s; }
        .container {
            max-width: 600px;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            margin: auto;
        }
        h2 { text-align: center; color: #333; }
        .form-row { display: flex; gap: 15px; }
        .form-group { flex: 1; margin-bottom: 15px; }
        label { font-weight: bold; display: block; margin-bottom: 5px; }
        input, select, textarea {
            width: 100%; padding: 10px; border: 1px solid #ccc;
            border-radius: 5px;
        }
        textarea { height: 80px; resize: none; }
        #btn {
            padding: 10px; width: 100%; border: none; cursor: pointer;
            border-radius: 5px; margin-top: 10px;
            color: white; background: #28a745; font-size: 16px;
        }
        #btn:hover { background: #218838; }
        @media (max-width: 600px) { .form-row { flex-direction: column; } }

        .message-box {
            text-align: center; padding: 15px; font-size: 16px;
            font-weight: bold; margin-bottom: 15px; border-radius: 8px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            position: relative; opacity: 1;
            transition: opacity 0.5s ease-in-out;
        }
        .success {
            background-color: #D4EDDA; color: #155724; border: 1px solid #C3E6CB;
        }
        .error {
            background-color: #F8D7DA; color: #721C24; border: 1px solid #F5C6CB;
        }
        .close-btn {
            position: absolute; top: 8px; right: 12px;
            font-size: 18px; font-weight: bold; cursor: pointer;
            color: inherit; background: none; border: none;
        }
    </style>
</head>
<body>
<%@ include file="navbar.jsp" %>
<jsp:include page="sidebar.jsp" />

<div class="main-content">
    <div class="container">
        <h2>Add New Product</h2>

        <% String message = (String) request.getAttribute("message"); %>
        <% String messageType = (String) request.getAttribute("messageType"); %>
        <% if (message != null) { %>
        <div class="message-box <%= messageType %>">
            <span class="close-btn" onclick="this.parentElement.style.display='none';">&times;</span>
            <%= message %>
        </div>
        <script>
            setTimeout(function () {
                let box = document.querySelector('.message-box');
                if (box) {
                    box.style.opacity = '0';
                    setTimeout(() => box.style.display = 'none', 500);
                }
                <% if ("success".equals(messageType)) { %>
                    window.location.href = "<%= request.getContextPath() %>/jsp_pages/admin/addProduct.jsp";
                <% } %>
            }, 3000);
        </script>
        <% } %>

        <form id="addProductForm" action="${pageContext.request.contextPath}/addProduct" method="post" enctype="multipart/form-data">
            <div class="form-row">
                <div class="form-group">
                    <label>Product Name</label>
                    <input type="text" id="productName" name="productName" required>
                </div>
                <div class="form-group">
                    <label>Category</label>
                    <select id="productCategory" name="productCategory" required>
                        <option value="" disabled selected>-- Select Category --</option>
                        <% for(Map<String, String> cat : categories) { %>
                            <option value="<%= cat.get("id") %>"><%= cat.get("name") %></option>
                        <% } %>
                    </select>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Subcategory</label>
                    <select id="productSubcategory" name="productSubcategory" required>
                        <option value="" disabled selected>-- Select Subcategory --</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Stock Quantity</label>
                    <input type="number" id="productStock" name="productStock" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Price</label>
                    <input type="number" id="productPrice" name="productPrice" required>
                </div>
            </div>

            <div class="form-group">
                <label>Product Description</label>
                <textarea id="productDescription" name="productDescription" required></textarea>
            </div>

            <div class="form-group">
                <label>Product Image</label>
                <input type="file" id="productImage" accept="image/*" name="productImage">
            </div>

            <button type="submit" id="btn">Add Product</button>
        </form>
    </div>
</div>

<script>
document.getElementById("productCategory").addEventListener("change", function () {
    const selectedCategory = this.value;
    const subCategoryDropdown = document.getElementById("productSubcategory");

    if (!selectedCategory) {
    	subCategoryDropdown.innerHTML = '<option value="">-- Select SubCategory --</option>';
        return;
    }

    subCategoryDropdown.innerHTML = '<option value="">Loading...</option>'; 

    fetch("/Smart_Hub/GetSubCategoryServlet?productCategory=" + encodeURIComponent(selectedCategory))
        .then(response => response.json())
        .then(data => {
        	subCategoryDropdown.innerHTML = '<option value="">-- Select SubCategory --</option>';
            data.forEach(productSubcategory => {
                let option = document.createElement("option");
                option.value = productSubcategory;
                option.textContent = productSubcategory;
                subCategoryDropdown.appendChild(option);
            });
        })
        .catch(error => console.error("Error fetching designations:", error));
});
</script>

</body>
</html>
