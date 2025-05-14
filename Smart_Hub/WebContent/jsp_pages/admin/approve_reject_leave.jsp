<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, com.smart_hub.servlets.DBConection" %>

<%
    String leaveId = request.getParameter("leave_id");
    String action = request.getParameter("action");

    if (leaveId != null && action != null) {
        Connection conn = null;
        PreparedStatement updateStatusStmt = null;
        PreparedStatement fetchLeaveStmt = null;
        PreparedStatement updateBalanceStmt = null;
        ResultSet rs = null;

        try {
            conn = DBConection.getConnection();
            conn.setAutoCommit(false); // Begin transaction

            String status = action.equalsIgnoreCase("approve") ? "Approved" : "Rejected";

            // Step 1: Update leave status
            String updateStatusSQL = "UPDATE leave_requests SET status = ? WHERE id = ?";
            updateStatusStmt = conn.prepareStatement(updateStatusSQL);
            updateStatusStmt.setString(1, status);
            updateStatusStmt.setInt(2, Integer.parseInt(leaveId));
            updateStatusStmt.executeUpdate();

            // Step 2: If approved, update used leaves
            if ("Approved".equalsIgnoreCase(status)) {
                String fetchLeaveSQL = "SELECT email, DATEDIFF(end_date, start_date) + 1 AS leave_days FROM leave_requests WHERE id = ?";
                fetchLeaveStmt = conn.prepareStatement(fetchLeaveSQL);
                fetchLeaveStmt.setInt(1, Integer.parseInt(leaveId));
                rs = fetchLeaveStmt.executeQuery();

                if (rs.next()) {
                    String email = rs.getString("email");
                    int leaveDays = rs.getInt("leave_days");

                    String updateBalanceSQL = "UPDATE leave_balance SET used_leaves = used_leaves + ? WHERE email = ?";
                    updateBalanceStmt = conn.prepareStatement(updateBalanceSQL);
                    updateBalanceStmt.setInt(1, leaveDays);
                    updateBalanceStmt.setString(2, email);
                    updateBalanceStmt.executeUpdate();
                }
            }

            conn.commit(); // Commit transaction
            conn.setAutoCommit(true); // Restore default
            response.sendRedirect("leave.jsp?success=true");

        } catch (Exception e) {
            if (conn != null) conn.rollback(); // Rollback on error
            e.printStackTrace();
            response.sendRedirect("leave.jsp?error=true");

        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
            if (updateStatusStmt != null) try { updateStatusStmt.close(); } catch (SQLException ignored) {}
            if (fetchLeaveStmt != null) try { fetchLeaveStmt.close(); } catch (SQLException ignored) {}
            if (updateBalanceStmt != null) try { updateBalanceStmt.close(); } catch (SQLException ignored) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
        }
    } else {
        response.sendRedirect("leave.jsp?invalid=true");
    }
%>
