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
import java.nio.file.Paths;
import java.sql.*;

@MultipartConfig(fileSizeThreshold = 1024 * 1024,
                 maxFileSize = 1024 * 1024 * 5,
                 maxRequestSize = 1024 * 1024 * 10)
public class AddCategory extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String category = request.getParameter("category");
		Part imagePart = request.getPart("image");
		String message = null;
		String messageType = null;

		// Upload directory
		String uploadPath = getServletContext().getRealPath("") + File.separator + "category_images";
		File uploadDir = new File(uploadPath);
		if (!uploadDir.exists()) uploadDir.mkdir();

		// Save main category image
		String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
		String imagePath = uploadPath + File.separator + fileName;
		imagePart.write(imagePath);

		try (Connection conn = DBConection.getConnection()) {
		    int categoryId = -1;

		    // Check if category already exists
		    String checkQuery = "SELECT category_id FROM category WHERE category_name = ?";
		    PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
		    checkStmt.setString(1, category);
		    ResultSet rs = checkStmt.executeQuery();

		    if (rs.next()) {
		        // Category exists
		        categoryId = rs.getInt("category_id");
		    } else {
		        // Insert new category
		        String insertCatQuery = "INSERT INTO category (category_name, image) VALUES (?, ?)";
		        PreparedStatement insertStmt = conn.prepareStatement(insertCatQuery, Statement.RETURN_GENERATED_KEYS);
		        insertStmt.setString(1, category);
		        insertStmt.setString(2, fileName);
		        int rows = insertStmt.executeUpdate();

		        if (rows > 0) {
		            ResultSet genKeys = insertStmt.getGeneratedKeys();
		            if (genKeys.next()) {
		                categoryId = genKeys.getInt(1);
		            }
		        } else {
		            throw new Exception("Failed to insert new category.");
		        }
		    }

		    // Add subcategories
		    String[] subcategories = request.getParameterValues("subcategories[]");
		    if (subcategories != null && subcategories.length > 0) {
		        String subInsertQuery = "INSERT INTO subcategories (subcategory_name, category_id) VALUES (?, ?)";
		        PreparedStatement subStmt = conn.prepareStatement(subInsertQuery);
		        for (String subcat : subcategories) {
		            subStmt.setString(1, subcat);
		            subStmt.setInt(2, categoryId);
		            subStmt.addBatch();
		        }
		        subStmt.executeBatch();
		    }

		    message = "Category and Subcategories added successfully.";
		    messageType = "success";

		} catch (Exception e) {
		    e.printStackTrace();
		    message = "Server Error: " + e.getMessage();
		    messageType = "error";
		}


		request.setAttribute("message", message);
		request.setAttribute("messageType", messageType);
		RequestDispatcher rds = request.getRequestDispatcher("/jsp_pages/admin/addCategories.jsp");
		rds.forward(request, response);
	}
}
