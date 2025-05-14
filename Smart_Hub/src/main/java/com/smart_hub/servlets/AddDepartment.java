package com.smart_hub.servlets;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;


public class AddDepartment extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String department =request.getParameter("department");
		String designation =request.getParameter("designation");
		String message="";
		String messageType="";
		try(Connection conn=DBConection.getConnection()) {
			String query="INSERT INTO Department (department,designation) VALUES (?,?)";
			PreparedStatement stmt=conn.prepareStatement(query);
			stmt.setString(1, department);
			stmt.setString(2, designation);
			int rows=stmt.executeUpdate();
			
			if(rows>0) {
				message="Department Added Successfully";
				messageType="success";
			}
			else {
				message="Error to added Department";
				messageType="error";
			}
		}catch(SQLException | ClassNotFoundException e) {
			e.printStackTrace();
            message = "Error: " + e.getMessage();
            messageType = "error";
		}
		
		request.setAttribute("message", message);
		request.setAttribute("messageType", messageType);
		
		RequestDispatcher rds=request.getRequestDispatcher("/jsp_pages/admin/addDepartment.jsp");
		rds.forward(request, response);
	}

}
