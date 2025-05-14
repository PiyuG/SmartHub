<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, com.smart_hub.servlets.DBConection"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Manage Customer</title>
<style>
	.main-content {
	    margin-left: 260px; /* Adjust based on sidebar width */
	    padding: 20px;
	    transition: margin-left 0.3s;
	}
    
    .search-container {
        display: flex;
        justify-content: space-between;
        margin-bottom: 15px;
    }
    .search-container input{
        padding: 8px;
        border: 1px solid #ccc;
        border-radius: 5px;
        width: 35%;
    }
    .btn {
        padding: 8px;
        border: none;
        cursor: pointer;
        border-radius: 5px;
    }
    

	/* Employee Panel */
	.employee-panel {
	    background: rgba(255, 255, 255, 0.2);
	    padding: 25px;
	    border-radius: 15px;
	    width: 100%;
	    max-width: 1300px;
	    backdrop-filter: blur(10px);
	    overflow-x: auto;
	    transition: all 0.3s ease-in-out;
	}
	
	/* Title */
	h2 {
	    text-align: center;
	    font-size: 26px;
	    font-weight: bold;
	    color: #333;
	    text-transform: uppercase;
	    margin-bottom: 25px;
	}
	
	/* Table Styling */
	table {
	    width: 100%;
	    border-collapse: collapse;
	    background: white;
	    border-radius: 10px;
	    overflow: hidden;
	    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
	}
	
	/* Table Header */
	th {
	     background: linear-gradient(45deg, #007bff, #0056b3); /* Blue Gradient */
	    color: white;
	    font-size: 16px;
	    text-transform: uppercase;
	    padding: 14px;
	    border-bottom: 3px solid #004080;
	}
	
	/* Table Rows */
	td {
	    padding: 14px;
	    border: 1px solid #ddd;
	    text-align: center;
	    font-size: 15px;
	    color: #555;
	}
	
	/* Alternating Row Colors */
	tbody tr:nth-child(even) {
	    background: #f8f9fa;
	}
	
	tbody tr:hover {
	    transition: background 0.3s ease-in-out;
	    background: rgba(0, 123, 255, 0.1);
	    cursor: pointer;
	}
	
	#btn {
	    padding: 10px 16px;
	    border: none;
	    border-radius: 6px;
	    cursor: pointer;
	    font-size: 15px;
	    font-weight: 500;
	    transition: all 0.3s ease-in-out;
	    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
	}
	
	#edit-btn {
	    border: none;
	    background: none;
	    color: #FFC107; 
	    font-size: 18px;
	    cursor: pointer;
	    transition: transform 0.2s ease-in-out, color 0.2s ease-in-out;
	}
	
	#edit-btn:hover {
		color: #E0A800;
	    transform: translateY(-2px);
	}
	
	/* Delete Button - Elegant Red */
	#delete-btn {
	   border: none;
	    background: none;
	    color: #DC3545; /* Red */
	    font-size: 18px;
	    cursor: pointer;
	    transition: transform 0.2s ease-in-out, color 0.2s ease-in-out;
	}
	
	#delete-btn:hover {
		color: #B71C1C; /* Darker Red */
	    transform: translateY(-2px);
	}
	
	
	/* Responsive Design */
	@media (max-width: 768px) {
	    .main-content {
	        margin-left: 0;
	        padding: 15px;
	    }
	
	    .employee-panel {
	        width: 100%;
	        padding: 15px;
	    }
	
	    table {
	        font-size: 14px;
	    }
	
	    #btn {
	        font-size: 13px;
	        padding: 8px;
	    }
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
<div class="container">
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
			                window.location.href = "<%= request.getContextPath() %>/jsp_pages/admin/manageCustmer.jsp";
			            <% } %>
			        }, 3000);
			    </script>
			<% } %>
    <h2>Manage Customers</h2>

    <!-- Search & Filter -->
    <div class="search-container">
        <button class="btn btn-add" onclick="showLoaderAndNavigate('<%= request.getContextPath() %>/jsp_pages/admin/addCustomer.jsp')">+ Add Customer</button>
    </div>

    <div class="employee-panel">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Mail</th>
                    <th>Mob No.</th>
                    <th>address</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection conn = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;
                    
                    try {
                        // Get the database connection from your existing DBConection class
                        conn = DBConection.getConnection();
                        
                        // Prepare SQL Query
                        String sql = "SELECT id, name, mail, phone, address FROM customer";
                        stmt = conn.prepareStatement(sql);
                        rs = stmt.executeQuery();
                        
                        // Iterate through the result set
                        while (rs.next()) {
                            int id = rs.getInt("id");
                            String name = rs.getString("name");
                            String mail=rs.getString("mail");
                            String mobno=rs.getString("phone");
                            String address=rs.getString("address");
                %>
                <tr>
                    <td><%= id %></td>
                    <td><%= name %></td>
                    <td><%= mail %></td>
                    <td><%= mobno %></td>
                    <td><%= address %></td>
                    <td>
                        <button id="btn edit-btn" onclick="window.location.href='<%= request.getContextPath() %>/jsp_pages/admin/editCustomer.jsp?id=<%= id %>'"><i class="fa fa-edit"></i></button>
						<button id="btn delete-btn" onclick="confirmDelete(<%= id %>)"><i class="fa fa-trash"></i></button>
                    </td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='6' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
                    } finally {
                        // Close resources
                        if (rs != null) try { rs.close(); } catch (SQLException e) {}
                        if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
                        if (conn != null) try { conn.close(); } catch (SQLException e) {}
                    }
                %>
            </tbody>
        </table>
    </div>
  </div>
 </div>
 <script>
    function confirmDelete(id) {
            window.location.href = "${pageContext.request.contextPath}/manageCustomer?action=delete&id=" + id;
    }
    </script>
</body>
</html>