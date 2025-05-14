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

public class GetDesignations extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get department parameter
        String department = request.getParameter("department");

        // Validate department parameter
        if (department == null || department.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Department parameter is required.");
            return;
        }

        List<String> designations = new ArrayList<>();

        // Fetch designations from the database
        try (Connection conn = DBConection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT designation FROM department WHERE department = ?")) {
            
            stmt.setString(1, department);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                designations.add(rs.getString("designation"));
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred.");
            return;
        }

        // Manually build JSON response
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < designations.size(); i++) {
            json.append("\"").append(designations.get(i)).append("\"");
            if (i < designations.size() - 1) {
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
