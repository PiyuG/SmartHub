package com.smart_hub.servlets;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import jakarta.servlet.RequestDispatcher;

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
				  maxFileSize = 1024 * 1024 * 10,      // 10MB
				  maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class EmployeeRegistrationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String message;
        String messageType;

        try (PrintWriter out = response.getWriter()) {
            String fullName = request.getParameter("full_name");
            String mail = request.getParameter("email");
            String mob_no = request.getParameter("phone");
            String dob = request.getParameter("dob");
            String pass = request.getParameter("password");
            String address = request.getParameter("address");

            Part filePart = request.getPart("empImage");
            String fileName = extractFileName(filePart);

            if (fileName.isEmpty()) {
                request.setAttribute("message", "Please select an image!");
                request.setAttribute("messageType", "error");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp_pages/index/employeeRegistration.jsp");
                dispatcher.forward(request, response);
                return;
            }

            String saveDir = getServletContext().getRealPath("/") + "uploads/employee";
            File fileSaveDir = new File(saveDir);
            if (!fileSaveDir.exists()) {
                fileSaveDir.mkdirs();
            }

            String savePath = saveDir + File.separator + fileName;
            filePart.write(savePath);

            String imagePath = "uploads/employee/" + fileName;

            try (Connection conn = DBConection.getConnection()) {
                // 1. Check if email already exists
                String checkEmailSql = "SELECT COUNT(*) FROM users WHERE mail = ?";
                try (PreparedStatement checkStmt = conn.prepareStatement(checkEmailSql)) {
                    checkStmt.setString(1, mail);
                    var rs = checkStmt.executeQuery();
                    if (rs.next() && rs.getInt(1) > 0) {
                        // Email already exists
                        request.setAttribute("message", "Email already registered!");
                        request.setAttribute("messageType", "error");
                        RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp_pages/index/employeeRegistration.jsp");
                        dispatcher.forward(request, response);
                        return;
                    }
                }

                // 2. Insert data
                String sql = "INSERT INTO users (name, mail, mobno, dob, password, address, image, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, fullName);
                stmt.setString(2, mail);
                stmt.setString(3, mob_no);
                stmt.setDate(4, java.sql.Date.valueOf(dob));
                stmt.setString(5, pass);
                stmt.setString(6, address);
                stmt.setString(7, imagePath);
                stmt.setString(8, "Inactive");

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
            RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp_pages/index/employeeRegistration.jsp");
            dispatcher.forward(request, response);
        }
    }



    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        for (String content : contentDisp.split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf("=") + 2, content.length() - 1);
            }
        }
        return "";
    }
}