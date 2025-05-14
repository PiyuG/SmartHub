<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*,java.io.*,java.sql.*,com.smart_hub.servlets.DBConection"%>
<%@ page import="jakarta.servlet.http.*"%>
<!DOCTYPE html>
<html>
<%
int recordCount = 0;
List<Map<String, String>> users = new ArrayList<>();
Set<String> departments = new HashSet<>();

try (Connection conn = DBConection.getConnection()) {
    if (conn != null) {
        PreparedStatement stmt1 = conn.prepareStatement("SELECT id, name FROM users WHERE status='inactive'");
        PreparedStatement stmt2 = conn.prepareStatement("SELECT department FROM department");

        ResultSet rs = stmt1.executeQuery();
        while (rs.next()) {
            Map<String, String> user = new HashMap<>();
            user.put("id", String.valueOf(rs.getInt("id")));
            user.put("name", rs.getString("name"));
            users.add(user);
        }
        rs.close();
        stmt1.close();

        ResultSet rsd = stmt2.executeQuery();
        while (rsd.next()) {
            departments.add(rsd.getString("department"));
        }
        rsd.close();
        stmt2.close();
    }
} catch (Exception e) {
    e.printStackTrace();
}
%>

<head>
    <title>Add Employee</title>
<style>
	.main-content {
	    margin-left: 260px;
	    padding: 20px;
	    transition: margin-left 0.3s;
	}
	.admin-panel {
	    background: white;
	    margin-top: 100px;
	    margin-left: 100px;
	    padding: 20px;
	    border-radius: 10px;
	    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	    width: 90%;
	    max-width: 900px;
	    overflow-x: auto;
	}
	.form-container {
	    display: flex;
	    flex-wrap: wrap;
	    gap: 20px;
	    justify-content: space-between;
	}
	.form-group {
	    display: flex;
	    flex-direction: column;
	    flex: 1 1 calc(50% - 10px);
	    min-width: 200px;
	}
	label {
	    font-weight: 600;
	    margin-bottom: 5px;
	}
	select, input {
	    padding: 8px;
	    border: 1px solid #ccc;
	    border-radius: 5px;
	    width: 100%;
	}
	.btn-container {
	    width: 100%;
	    text-align: center;
	    margin-top: 20px;
	}
	#btn {
	    background: #28a745;
	    color: white;
	    padding: 10px 20px;
	    border: none;
	    cursor: pointer;
	    border-radius: 5px;
	    font-size: 16px;
	}
	#btn:hover {
	    background: #218838;
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
    <div class="admin-panel">
      <h2>Approve Employee</h2>
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
		                window.location.href = "<%= request.getContextPath() %>/jsp_pages/admin/addEmployee.jsp";
		            <% } %>
		        }, 3000);
		    </script>
		<% } %>
    <form action="${pageContext.request.contextPath}/approve_employee" method="POST" class="form-container">
        <div class="form-group">
            <label>Select Employee</label>
            <select name="employee">
                <option value="">-- Select Employee --</option>
			    <% for (Map<String, String> user : users) { %>
			        <option value="<%= user.get("id") %>"><%= user.get("name") %></option>
			    <% } %>
            </select>
        </div>

        <div class="form-group">
            <label>Department</label>
            <select name="department" id="department">
                <option value="">-- Select Department --</option>
			    <% for (String dept : departments) { %>
			        <option value="<%= dept %>"><%= dept %></option>
			    <% } %>
            </select>
        </div>

        <div class="form-group">
            <label>Designation</label>
            <select name="designation" id="designation">
                <option value="">-- Select Designation --</option>
            </select>
        </div>

        <div class="form-group">
            <label>Salary</label>
            <input type="number" name="salary" required>
        </div>

        <div class="form-group">
            <label>Date of Joining</label>
            <input type="date" name="joining_date" required>
        </div>

        <div class="form-group">
            <label>Account Status</label>
            <select name="status">
                <option>Active</option>
                <option>Inactive</option>
            </select>
        </div>

        <div class="btn-container">
            <button type="submit" id="btn">Approve Employee</button>
        </div>
    </form>
</div>
</div>

<script>
document.getElementById("department").addEventListener("change", function () {
    const selectedDepartment = this.value;
    const designationDropdown = document.getElementById("designation");

    if (!selectedDepartment) {
        designationDropdown.innerHTML = '<option value="">-- Select Designation --</option>';
        return;
    }

    designationDropdown.innerHTML = '<option value="">Loading...</option>'; 

    fetch("/Smart_Hub/getDesignations?department=" + encodeURIComponent(selectedDepartment))
        .then(response => response.json())
        .then(data => {
            designationDropdown.innerHTML = '<option value="">-- Select Designation --</option>';
            data.forEach(designation => {
                let option = document.createElement("option");
                option.value = designation;
                option.textContent = designation;
                designationDropdown.appendChild(option);
            });
        })
        .catch(error => console.error("Error fetching designations:", error));
});
</script>

</body>
</html>
