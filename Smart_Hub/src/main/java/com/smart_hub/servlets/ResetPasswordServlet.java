package com.smart_hub.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

public class ResetPasswordServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        String message = "";
        String messageType = "error";
        
        if (newPassword.equals(confirmPassword)) {
            // Proceed with password update
            try (Connection conn = DBConection.getConnection()) {
                
                String sql = "SELECT * FROM admin WHERE username = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, email);
                ResultSet rs = stmt.executeQuery();
                
                if (rs.next()) {
                    // Update the password in the database
                    String updateSQL = "UPDATE admin SET password = ? WHERE username = ?";
                    stmt = conn.prepareStatement(updateSQL);
                    stmt.setString(1, newPassword); // Store new password
                    stmt.setString(2, email);
                    stmt.executeUpdate();
                    
                    message = "Password reset successfully!";
                    messageType = "success";
                } else {
                    message = "Email not found.";
                }
            } catch (SQLException e) {
                e.printStackTrace();
                message = "Error resetting password.";
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            }
        } else {
            message = "Passwords do not match.";
        }
        
        // Set the message in the request and forward to resetpassword.jsp
        request.setAttribute("message", message);
        request.setAttribute("messageType", messageType);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp_pages/index/forgetpassword.jsp");
        dispatcher.forward(request, response);
    }

}
