package com.smart_hub.servlets;

import java.io.*;
import java.sql.*;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class AddProduct extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String message = null,messageType = null;

        try (PrintWriter out = response.getWriter()) {
            // Get form data
            String name = request.getParameter("productName");
            String category = request.getParameter("productCategory");
            String subcategoryName = request.getParameter("productSubcategory");
            int stock = Integer.parseInt(request.getParameter("productStock"));
            double price = Double.parseDouble(request.getParameter("productPrice"));
            String description = request.getParameter("productDescription");

            // Handle file upload
            Part filePart = request.getPart("productImage");
            String fileName = extractFileName(filePart);

            if (fileName.isEmpty()) {
            	message="Please select an image!";
            	messageType="error";
            	return;
                //out.println("<script>alert('Please select an image!');window.location='addProduct.jsp';</script>");
                //return;
            }

            // Define upload directory inside WebContent/uploads/product
            String saveDir = getServletContext().getRealPath("/") + "uploads/product";
            File fileSaveDir = new File(saveDir);
            if (!fileSaveDir.exists()) {
                fileSaveDir.mkdirs(); // Creates the directory and parent folders if they don’t exist
            }

            // Save file
            String savePath = saveDir + File.separator + fileName;
            filePart.write(savePath);

            // Store relative path for easy access in JSP
            String imagePath = "uploads/product/" + fileName;

            // Database Connection
            try (Connection conn = DBConection.getConnection()) {
                String sql = "INSERT INTO products (name, category ,subcategory_id, stock, price, description, image) VALUES (?, ?, ?, ?, ?, ?, ?)";
                int subcategoryId = -1;

                PreparedStatement ps = conn.prepareStatement("SELECT subcategory_id FROM subcategories WHERE subcategory_name = ?");
                ps.setString(1, subcategoryName);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    subcategoryId = rs.getInt("subcategory_id");
                }


                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, name);
                    stmt.setString(2, category);
                    stmt.setInt(3, subcategoryId);
                    stmt.setInt(4, stock);
                    stmt.setDouble(5, price);
                    stmt.setString(6, description);
                    stmt.setString(7, imagePath); // Store relative file path

                    int rowsInserted = stmt.executeUpdate();
                    if (rowsInserted > 0) {
                    	message="Product Added Successfully!";
                    	messageType="success";
                        //out.println("<script>alert('Product Added Successfully!');window.location='request.getContextPath() +\"/jsp_pages/admin/addProduct.jsp';</script>");
                    } else {
                    	message="Error adding product!!";
                    	messageType="error";
                        //out.println("<script>alert('Error adding product!');window.location='addProduct.jsp';</script>");
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<script>alert('Database Error: " + e.getMessage() + "');window.location='addProduct.jsp';</script>");
            } catch (ClassNotFoundException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
         // Set the message as a request attribute
            request.setAttribute("message", message);
            request.setAttribute("messageType", messageType);
            
            // Forward the request back to the registration page
            RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp_pages/admin/addProduct.jsp");
            dispatcher.forward(request, response);
        }
    }

    // Extracts file name from content-disposition header
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
