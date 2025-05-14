package com.smart_hub.servlets;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


public class EmployeeLogin extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String message = null;
        String messageType = null;
		String username = request.getParameter("emp-username");
        String password = request.getParameter("emp-password");
        
        try (Connection conn = DBConection.getConnection()) {
            String sql = "SELECT * FROM users WHERE mail = ? AND password = ? AND status='Active'";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("employeeEmail", username);
                session.setAttribute("employeeName", rs.getString("name"));
                session.setAttribute("empId", rs.getInt("id"));                
                response.sendRedirect(request.getContextPath() + "/jsp_pages/employee/index.jsp");
                return;
          } else {
           	message = "Invalid Credentials";
              messageType = "error";
           }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            message = "Error: " + e.getMessage();
            messageType = "error";
        }
        request.setAttribute("message", message);
        request.setAttribute("messageType", messageType);
        
        // Forward the request back to the registration page
        RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp_pages/index/employeelogin.jsp");
        dispatcher.forward(request, response);
	}

}
