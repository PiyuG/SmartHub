<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<style>
	.main_container{
		margin-left:330px;
		margin-top:150px;
		padding:20px;
		max-width:2000px;
	}
	.category{
		background: rgba(255, 255, 255, 20);
	    padding: 25px;
	    border-radius: 15px;
	    width: 100%;
	    max-width: 1300px;
	    backdrop-filter: blur(10px);
	    overflow-x: auto;
	    transition: all 0.3s ease-in-out;
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
		    width: calc(100% - 14px); 
		    padding: 8px;
		    margin: 10px 0; 
		    border: 1px solid #ccc;
		    border-radius: 5px;
	}
    #btn {
      	margin-left:35px;
        background-color: blue;
        color: white;
        padding: 10px;
        border: none;
        width: 80%;
        border-radius: 30px;
        cursor: pointer;
        font-size: 16px;
    }
    #btn:hover {
        background-color: darkblue;
    }
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
		    background-color: blue;
		    color: white;
		    border: 1px solid #C3E6CB;
		}
		
		.error {
		    background-color: red;
		    color: black;
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
	<jsp:include page="sidebar.jsp"/>
	
	<div class="main_container">
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
		                window.location.href = "<%= request.getContextPath() %>/jsp_pages/admin/addCategories.jsp";
		            <% } %>
		        }, 3000);
	    	</script>
		<% } %>
		<div class="category">
    <form action="${pageContext.request.contextPath}/addCategory" method="post" enctype="multipart/form-data">
        <label for="category">Main Category</label>
        <input name="category" type="text" required>

        <label for="image">Main Category Image</label>
        <input type="file" name="image" accept="image/*" required>

        <hr>
        <h3 style="text-align:center;">Add Subcategories</h3>
        <div id="subcategories">
            <div class="subcategory-group">
                <label>Subcategory Name</label>
                <input type="text" name="subcategories[]" required>
                
            </div>
        </div>

        <button type="button" onclick="addSubcategory()" style="margin:10px 35px; padding:8px 20px; border-radius:20px; background-color:green; color:white; border:none;">+ Add Another Subcategory</button>

        <hr>
        <button id="btn" type="submit">Save</button>
    </form>
</div>

<script>
    function addSubcategory() {
        const container = document.getElementById('subcategories');
        const subGroup = document.createElement('div');
        subGroup.classList.add('subcategory-group');
        subGroup.innerHTML = `
            <label>Subcategory Name</label>
            <input type="text" name="subcategories[]" required>
        `;
        container.appendChild(subGroup);
    }
</script>

	</div>
</body>
</html>