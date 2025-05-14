package com.smart_hub.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.RequestDispatcher;

public class CustomerRegistration extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("full_name");
        String mail = request.getParameter("email");
        String mob_no = request.getParameter("phone");
        String pass = request.getParameter("password");
        String address = request.getParameter("address");

        String message;
        String messageType;

        try (Connection conn = DBConection.getConnection()) {
            // 1. Check if email already exists
            String checkEmailSql = "SELECT COUNT(*) FROM customer WHERE mail = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkEmailSql)) {
                checkStmt.setString(1, mail);
                ResultSet rs = checkStmt.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    // Email already registered
                    message = "Email is already registered!";
                    messageType = "error";
                    request.setAttribute("message", message);
                    request.setAttribute("messageType", messageType);
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp_pages/index/customerregistration.jsp");
                    dispatcher.forward(request, response);
                    return;
                }
            }

            // 2. Insert new customer
            String sql = "INSERT INTO customer (name, mail, phone, password, address) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, fullName);
            stmt.setString(2, mail);
            stmt.setString(3, mob_no);
            stmt.setString(4, pass);
            stmt.setString(5, address);

            int rowsInserted = stmt.executeUpdate();

            if (rowsInserted > 0) {
                message = "Registration Successful!";
                messageType = "success";
            } else {
                message = "Error in Registration!";
                messageType = "error";
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            message = "Error: " + e.getMessage();
            messageType = "error";
        }

        request.setAttribute("message", message);
        request.setAttribute("messageType", messageType);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp_pages/index/customerregistration.jsp");
        dispatcher.forward(request, response);
    }
}
