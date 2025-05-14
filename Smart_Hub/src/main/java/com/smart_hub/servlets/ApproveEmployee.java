package com.smart_hub.servlets;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class ApproveEmployee extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int emp=Integer.parseInt(request.getParameter("employee"));
		String department=request.getParameter("department");
		String designation=request.getParameter("designation");
		double salary=Double.parseDouble(request.getParameter("salary"));
		String doj=request.getParameter("joining_date");
		String status=request.getParameter("status");
		
		String message = null;
        String messageType = null;
        
		try(Connection conn=DBConection.getConnection()){
			String query="UPDATE users SET department = ?, designation = ?, salary = ?, joining_date = ?, status = ? WHERE id = ?";
			PreparedStatement ps=conn.prepareStatement(query);
			
			ps.setString(1, department);
			ps.setString(2, designation);
			ps.setDouble(3, salary);
			ps.setDate(4,java.sql.Date.valueOf(doj));
			ps.setString(5, status);
			ps.setInt(6, emp);
			
			int rowsInserted=ps.executeUpdate();
			
			if(rowsInserted>0) {
				message = "Employee Activated!";
                messageType = "success";
			}else {
				message = "Error in Activate Employee!";
                messageType = "error";
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		request.setAttribute("message", message);
        request.setAttribute("messageType", messageType);
        
        // Forward the request back to the registration page
        RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp_pages/admin/addEmployee.jsp");
        dispatcher.forward(request, response);
	}

}
