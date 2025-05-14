package com.smart_hub.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class LeaveServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final int DEFAULT_TOTAL_LEAVES = 30;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String leaveReason = request.getParameter("leaveReason");

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConection.getConnection();

            // Step 1: Calculate total leave days
            String diffQuery = "SELECT DATEDIFF(?, ?) + 1 AS total_days";
            stmt = conn.prepareStatement(diffQuery);
            stmt.setString(1, endDate);
            stmt.setString(2, startDate);
            rs = stmt.executeQuery();

            int totalDays = 0;
            if (rs.next()) {
                totalDays = rs.getInt("total_days");
            }
            rs.close();
            stmt.close();

            // Step 2: Check leave balance
            String balanceQuery = "SELECT total_leaves, used_leaves FROM leave_balance WHERE email = ?";
            stmt = conn.prepareStatement(balanceQuery);
            stmt.setString(1, email);
            rs = stmt.executeQuery();

            int totalLeaves = DEFAULT_TOTAL_LEAVES;
            int usedLeaves = 0;
            boolean recordExists = false;

            if (rs.next()) {
                totalLeaves = rs.getInt("total_leaves");
                usedLeaves = rs.getInt("used_leaves");
                recordExists = true;
            }
            rs.close();
            stmt.close();

            // Step 3: If not found, insert default leave balance
            if (!recordExists) {
                String insertBalance = "INSERT INTO leave_balance (email, total_leaves, used_leaves) VALUES (?, ?, 0)";
                stmt = conn.prepareStatement(insertBalance);
                stmt.setString(1, email);
                stmt.setInt(2, DEFAULT_TOTAL_LEAVES);
                stmt.executeUpdate();
                stmt.close();
            }

            int remaining = totalLeaves - usedLeaves;

            // Step 4: Check leave eligibility (based on remaining leaves)
            if (remaining >= totalDays) {
                // Just insert the leave request — no update to used_leaves yet
                String insertLeave = "INSERT INTO leave_requests (email, start_date, end_date, leave_reason, total_days, status) VALUES (?, ?, ?, ?, ?, 'Pending')";
                stmt = conn.prepareStatement(insertLeave);
                stmt.setString(1, email);
                stmt.setString(2, startDate);
                stmt.setString(3, endDate);
                stmt.setString(4, leaveReason);
                stmt.setInt(5, totalDays);
                stmt.executeUpdate();
                stmt.close();

                request.setAttribute("message", "Leave request submitted successfully. Awaiting admin approval.");
                request.setAttribute("status", "success");
            } else {
                request.setAttribute("message", "You do not have enough leave balance.");
                request.setAttribute("status", "error");
            }

            request.getRequestDispatcher("jsp_pages/employee/takeleave.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "An error occurred while applying for leave.");
            request.setAttribute("status", "error");
            request.getRequestDispatcher("jsp_pages/employee/takeleave.jsp").forward(request, response);
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
