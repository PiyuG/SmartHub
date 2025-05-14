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

public class CustomerLogin extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String message = null;
        String messageType = null;

        String username = request.getParameter("customer-username");
        String pass = request.getParameter("customer-password");

        try (Connection conn = DBConection.getConnection()) {
            String sql = "SELECT * FROM customer where mail= ? AND password=?";
            PreparedStatement pre = conn.prepareStatement(sql);

            pre.setString(1, username);
            pre.setString(2, pass);
            ResultSet rs = pre.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("mail", username);
                session.setAttribute("user_id", rs.getInt("id"));
                session.setAttribute("name", rs.getString("name"));

                // Redirect after successful login
                response.sendRedirect(request.getContextPath() + "/jsp_pages/customer/index.jsp");
                return; // Ensure no further code execution after the redirect
            } else {
                message = "Invalid Credentials";
                messageType = "error";
            }

        } catch (Exception e) {
            e.printStackTrace();
            message = "Error: " + e.getMessage();
            messageType = "error";
        }

        // Set message attributes for login failure
        request.setAttribute("message", message);
        request.setAttribute("messageType", messageType);

        // Forward request to login page in case of failure
        RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp_pages/index/customerlogin.jsp");
        dispatcher.forward(request, response);
    }
}
