package com.smart_hub.servlets;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class NotificationUpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action"); // "single" or "all"
        HttpSession session = request.getSession(false);
        String email = (String) session.getAttribute("employeeEmail");

        try (Connection conn = DBConection.getConnection()) {

            if ("single".equalsIgnoreCase(action)) {
                int notifId = Integer.parseInt(request.getParameter("notifId"));
                PreparedStatement ps = conn.prepareStatement("UPDATE notifications SET status = 'read' WHERE id = ?");
                ps.setInt(1, notifId);
                ps.executeUpdate();
                ps.close();

            } else if ("all".equalsIgnoreCase(action) && email != null) {
                PreparedStatement ps = conn.prepareStatement(
                    "UPDATE notifications SET status = 'read' WHERE user_id = (SELECT id FROM users WHERE mail = ?)"
                );
                ps.setString(1, email);
                ps.executeUpdate();
                ps.close();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/jsp_pages/employee/notification.jsp");
    }
}
