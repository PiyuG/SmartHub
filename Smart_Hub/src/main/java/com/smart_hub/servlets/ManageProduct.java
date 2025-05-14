package com.smart_hub.servlets;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@MultipartConfig(
	    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
	    maxFileSize = 1024 * 1024 * 10,       // 10MB
	    maxRequestSize = 1024 * 1024 * 50     // 50MB
	)
public class ManageProduct extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
private static final String UPLOAD_DIR = "uploads";
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        String message = null;
        String messageType = null;

        if (idParam == null || idParam.isEmpty()) {
        	message = "Invalid Product ID";
            messageType = "error";
            return;
        }

        int id = Integer.parseInt(idParam);
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DBConection.getConnection();

            if ("delete".equals(action)) {
                // Retrieve the product's image path before deleting
                String sqlGetImage = "SELECT image FROM products WHERE prod_id=?";
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
                String sql = "DELETE FROM products WHERE prod_id=?";
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
                    message = "Product Information Deleted!";
                    messageType = "success";
                } else {
                	message = "Error to Product Information Deleted!";
                    messageType = "error";
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/jsp_pages/admin/manageProduct.jsp?error=" + e.getMessage());
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
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp_pages/admin/manageProduct.jsp");
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
                // Edit product Details
                String name = request.getParameter("name");
                int stock = Integer.parseInt(request.getParameter("stock"));
                Double price = Double.parseDouble(request.getParameter("price"));
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
                    String sqlGetImage = "SELECT image FROM products WHERE prod_id=?";
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
                String sql = "UPDATE products SET name=?, stock=?, price=?, image=? WHERE prod_id=?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, name);
                stmt.setInt(2, stock);
                stmt.setDouble(3, price);
                stmt.setString(4, fileName);
                stmt.setInt(5, id);
                
                int rowsUpdated = stmt.executeUpdate();
                if (rowsUpdated > 0) {
                    message = "Product Information Updated!";
                    messageType = "success";
                } else {
                    message = "Error Updating Product Info!";
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
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp_pages/admin/manageProduct.jsp");
        dispatcher.forward(request, response);
    }
    

}
