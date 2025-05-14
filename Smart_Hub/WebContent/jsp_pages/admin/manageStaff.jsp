<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, com.smart_hub.servlets.DBConection"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="ISO-8859-1">
    <title>Manage Employees</title>

    <!-- FontAwesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* Main Content */
        .main-content {
            margin-left: 230px;
            padding: 20px;
            width: 100%;
            max-width: 1400px;
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

        /* Table */
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 30px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        th, td {
            padding: 14px;
            border: 1px solid #ddd;
            text-align: center;
            font-size: 15px;
            color: #555;
        }

        /* Table Header */
        th {
            background: linear-gradient(45deg, #007bff, #0056b3);
            color: white;
            font-size: 16px;
            text-transform: uppercase;
            border-bottom: 3px solid #004080;
        }

        /* Alternating Row Colors */
        tbody tr:nth-child(even) {
            background: #f8f9fa;
        }

        tbody tr:hover {
            background: rgba(0, 123, 255, 0.1);
            cursor: pointer;
        }

        /* Buttons */
        .btn {
            padding: 10px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 15px;
            transition: all 0.3s ease-in-out;
        }

        .edit-btn {
            background: none;
            color: #FFC107;
            font-size: 18px;
        }

        .edit-btn:hover {
            color: #E0A800;
            transform: scale(1.1);
        }

        .delete-btn {
            background: none;
            color: #DC3545;
            font-size: 18px;
        }

        .delete-btn:hover {
            color: #B71C1C;
            transform: scale(1.1);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 15px;
            }
        }
    </style>
</head>
<body>

    <%@ include file="navbar.jsp" %>
    <jsp:include page="sidebar.jsp" />

    <div class="main-content">
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
			                window.location.href = "<%= request.getContextPath() %>/jsp_pages/admin/manageStaff.jsp";
			            <% } %>
			        }, 3000);
			    </script>
			<% } %>
        <div class="employee-panel">
            <h2>Manage Employees</h2>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Mail</th>
                        <th>Mob No.</th>
                        <th>DOB</th>
                        <th>Address</th>
                        <th>Department</th>
                        <th>Designation</th>
                        <th>Salary</th>
                        <th>DOJ</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Connection conn = null;
                        PreparedStatement stmt = null;
                        ResultSet rs = null;

                        try {
                            conn = DBConection.getConnection();
                            String sql = "SELECT id, name, mail, mobno, dob, address, department, designation, salary, joining_date FROM users WHERE status='active'";
                            stmt = conn.prepareStatement(sql);
                            rs = stmt.executeQuery();

                            while (rs.next()) {
                                int id = rs.getInt("id");
                                String name = rs.getString("name");
                                String mail = rs.getString("mail");
                                String mobno = rs.getString("mobno");
                                Date dob = rs.getDate("dob");
                                String address = rs.getString("address");
                                String department = rs.getString("department");
                                String designation = rs.getString("designation");
                                double salary = rs.getDouble("salary");
                                Date doj = rs.getDate("joining_date");
                    %>
                    <tr>
                        <td><%= id %></td>
                        <td><%= name %></td>
                        <td><%= mail %></td>
                        <td><%= mobno %></td>
                        <td><%= dob %></td>
                        <td><%= address %></td>
                        <td><%= department %></td>
                        <td><%= designation %></td>
                        <td>$<%= salary %></td>
                        <td><%= doj %></td>
                        <td>
                            <!-- Fixed Edit Button -->
                            <button class="btn edit-btn" onclick="window.location.href='<%= request.getContextPath() %>/jsp_pages/admin/editEmployee.jsp?id=<%= id %>'">
                                <i class="fa fa-edit"></i>
                            </button>

                            <!-- Fixed Delete Button -->
                            <button class="btn delete-btn" onclick="confirmDelete(<%= id %>)">
                                <i class="fa fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                    <%
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='11' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
                        } finally {
                            if (rs != null) try { rs.close(); } catch (SQLException e) {}
                            if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
                            if (conn != null) try { conn.close(); } catch (SQLException e) {}
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <script>
    function confirmDelete(id) {
            window.location.href = "${pageContext.request.contextPath}/ManageEmployee?action=delete&id=" + id;
    }

    </script>

</body>
</html>
