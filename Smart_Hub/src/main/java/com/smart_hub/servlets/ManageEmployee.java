package com.smart_hub.servlets;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class ManageEmployee extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIR = "uploads";
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        String message = null;
        String messageType = null;

        if (idParam == null || idParam.isEmpty()) {
        	message = "Invalid Employee ID";
            messageType = "error";
            return;
        }

        int id = Integer.parseInt(idParam);
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DBConection.getConnection();

            if ("delete".equals(action)) {
                // Retrieve the employee's image path before deleting
                String sqlGetImage = "SELECT image FROM users WHERE id=?";
                stmt = conn.prepareStatement(sqlGetImage);
                stmt.setInt(1, id);
                ResultSet rs = stmt.executeQuery();
                String imagePath = null;
                if (rs.next()) {
                    imagePath = rs.getString("image");
                }
                rs.close();
                stmt.close();

                // Delete employee record
                String sql = "DELETE FROM users WHERE id=?";
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, id);
                int rowsDeleted = stmt.executeUpdate();

                if (rowsDeleted > 0) {
                    // Delete the image file
                    if (imagePath != null && !imagePath.isEmpty()) {
                        String fullImagePath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR + File.separator + imagePath;
                        File file = new File(fullImagePath);
                        if (file.exists()) {
                            file.delete();
                        }
                    }
                    message = "Employee Information Deleted!";
                    messageType = "success";
                } else {
                	message = "Error to Employee Information Deleted!";
                    messageType = "error";
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/jsp_pages/admin/manageStaff.jsp?error=" + e.getMessage());
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        request.setAttribute("message", message);
        request.setAttribute("messageType", messageType);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp_pages/admin/manageStaff.jsp");
        dispatcher.forward(request, response);
    }


    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        int id = (idParam != null && !idParam.isEmpty()) ? Integer.parseInt(idParam) : -1;
        String message = null;
        String messageType = null;

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConection.getConnection();

            if ("edit".equals(action) && id > 0) {
                // Edit Employee Details
                String name = request.getParameter("name");
                String mail = request.getParameter("mail");
                String mobno = request.getParameter("mobno");
                String dob = request.getParameter("dob");
                String address = request.getParameter("address");
                String department = request.getParameter("department");
                String designation = request.getParameter("designation");
                double salary = Double.parseDouble(request.getParameter("salary"));
                String doj = request.getParameter("doj");

                // Handle image upload
                Part filePart = request.getPart("image");
                String fileName = null;

                if (filePart != null && filePart.getSize() > 0) {
                    fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                    String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdir();
                    }
                    filePart.write(uploadPath + File.separator + fileName);
                } else {
                    // Keep existing image
                    String sqlGetImage = "SELECT image FROM users WHERE id=?";
                    stmt = conn.prepareStatement(sqlGetImage);
                    stmt.setInt(1, id);
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next()) {
                        fileName = rs.getString("image");
                    }
                    rs.close();
                    stmt.close();
                }

                // Update employee details
                String sql = "UPDATE users SET name=?, mail=?, mobno=?, dob=?, address=?, department=?, designation=?, salary=?, joining_date=?, image=? WHERE id=?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, name);
                stmt.setString(2, mail);
                stmt.setString(3, mobno);
                stmt.setDate(4, java.sql.Date.valueOf(dob));
                stmt.setString(5, address);
                stmt.setString(6, department);
                stmt.setString(7, designation);
                stmt.setDouble(8, salary);
                stmt.setDate(9, java.sql.Date.valueOf(doj));
                stmt.setString(10, fileName);
                stmt.setInt(11, id);
                
                int rowsUpdated = stmt.executeUpdate();
                if (rowsUpdated > 0) {
                    message = "Employee Information Updated!";
                    messageType = "success";
                } else {
                    message = "Error Updating Employee Info!";
                    messageType = "error";
                }
            } 
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        request.setAttribute("message", message);
        request.setAttribute("messageType", messageType);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp_pages/admin/manageStaff.jsp");
        dispatcher.forward(request, response);
    }
}
