package com.smart_hub.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AdminLogin extends HttpServlet {
	private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String message = null;
        String messageType = null;

        try (Connection conn = DBConection.getConnection()) {
            String sql = "SELECT * FROM admin WHERE username = ? AND password = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // Admin authentication successful
                HttpSession session = request.getSession();
                session.setAttribute("adminEmail", username);
                session.setAttribute("adminName", rs.getString("name"));
                response.sendRedirect(request.getContextPath() + "/jsp_pages/admin/index.jsp");
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
        RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp_pages/index/adminlogin.jsp");
        dispatcher.forward(request, response);
    }


}
