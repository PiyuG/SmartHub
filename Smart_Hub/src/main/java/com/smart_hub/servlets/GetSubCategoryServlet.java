package com.smart_hub.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class GetSubCategoryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get department parameter
        String category = request.getParameter("productCategory");
        
        // Validate department parameter
        if (category == null || category.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Category parameter is required.");
            return;
        }

        List<String> subcategories = new ArrayList<>();

        // Fetch designations from the database
        try (Connection conn = DBConection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT subcategory_name FROM subcategories WHERE category_id = ?")) {
            
            stmt.setString(1, category);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                subcategories.add(rs.getString("subcategory_name"));
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred.");
            return;
        }

        // Manually build JSON response
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < subcategories.size(); i++) {
            json.append("\"").append(subcategories.get(i)).append("\"");
            if (i < subcategories.size() - 1) {
                json.append(",");
            }
        }
        json.append("]");

        // Set response headers
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Send JSON response
        response.getWriter().write(json.toString());
    }
}
