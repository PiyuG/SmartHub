package com.smart_hub.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;


import java.io.IOException;
import java.sql.*;
import java.sql.PreparedStatement;
import java.time.*;


public class EmployeeTakeAttendance extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("employeeEmail"); // Get email from session
        if (email == null) {
            response.sendRedirect("jsp_pages/index/employeelogin.jsp");
            return;
        }

        String action = request.getParameter("action");
        LocalDate today = LocalDate.now();
        LocalTime currentTime = LocalTime.now();

        try (Connection conn = DBConection.getConnection()) {
            if ("checkin".equals(action)) {
                // Insert check-in time if no record exists for today
                String checkInSQL = "INSERT INTO attendance (email, date, check_in) VALUES (?, ?, ?) " +
                                    "ON DUPLICATE KEY UPDATE check_in = VALUES(check_in)";
                try (PreparedStatement ps = conn.prepareStatement(checkInSQL)) {
                    ps.setString(1, email);
                    ps.setDate(2, Date.valueOf(today));
                    ps.setTime(3, Time.valueOf(currentTime));
                    ps.executeUpdate();
                }
            } else if ("checkout".equals(action)) {
                // Update check-out time
                String checkOutSQL = "UPDATE attendance SET check_out = ? WHERE email = ? AND date = ?";
                try (PreparedStatement ps = conn.prepareStatement(checkOutSQL)) {
                    ps.setTime(1, Time.valueOf(currentTime));
                    ps.setString(2, email);
                    ps.setDate(3, Date.valueOf(today));
                    ps.executeUpdate();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
        response.sendRedirect("jsp_pages/employee/attendance.jsp");
    }
}
