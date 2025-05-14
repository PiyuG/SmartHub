package com.smart_hub.servlets;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2,    // 2MB
                 maxFileSize = 1024 * 1024 * 10,         // 10MB
                 maxRequestSize = 1024 * 1024 * 50)      // 50MB
public class UpdateProductServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String IMAGE_UPLOAD_DIR = "product_images";  // inside webapp folder

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int prodId = Integer.parseInt(request.getParameter("prod_id"));
        String name = request.getParameter("name");
        int stock = Integer.parseInt(request.getParameter("stock"));
        double price = Double.parseDouble(request.getParameter("price"));
        Part imagePart = request.getPart("image");
        String imagePath = null;

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConection.getConnection();

            // Fetch existing image path
            String oldImage = null;
            PreparedStatement getOld = conn.prepareStatement("SELECT image FROM products WHERE prod_id = ?");
            getOld.setInt(1, prodId);
            ResultSet rs = getOld.executeQuery();
            if (rs.next()) {
                oldImage = rs.getString("image");
            }

            // Check if a new image is uploaded
            if (imagePart != null && imagePart.getSize() > 0) {
                String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
                String uploadPath = getServletContext().getRealPath("") + File.separator + IMAGE_UPLOAD_DIR;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();

                String newFileName = "product_" + System.currentTimeMillis() + "_" + fileName;
                imagePath = IMAGE_UPLOAD_DIR + File.separator + newFileName;
                imagePart.write(uploadPath + File.separator + newFileName);

                // Optionally delete old image
                if (oldImage != null) {
                    File oldFile = new File(getServletContext().getRealPath("") + File.separator + oldImage);
                    if (oldFile.exists()) oldFile.delete();
                }
            } else {
                imagePath = oldImage;  // Keep existing image if none uploaded
            }

            // Update the product
            String sql = "UPDATE products SET name = ?, stock = ?, price = ?, image = ? WHERE prod_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, name);
            stmt.setInt(2, stock);
            stmt.setDouble(3, price);
            stmt.setString(4, imagePath);
            stmt.setInt(5, prodId);

            int rowsUpdated = stmt.executeUpdate();

            if (rowsUpdated > 0) {
                request.setAttribute("message", "Product updated successfully!");
                request.setAttribute("messageType", "success");
            } else {
                request.setAttribute("message", "Failed to update product.");
                request.setAttribute("messageType", "error");
            }

        } catch (Exception e) {
            request.setAttribute("message", "Error: " + e.getMessage());
            request.setAttribute("messageType", "error");
            e.printStackTrace();
        } finally {
            if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }

        request.getRequestDispatcher("/jsp_pages/admin/manageProduct.jsp").forward(request, response);
    }
}
