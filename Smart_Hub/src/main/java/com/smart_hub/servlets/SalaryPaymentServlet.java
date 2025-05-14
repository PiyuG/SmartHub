package com.smart_hub.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class SalaryPaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement checkStmt = null;
        PreparedStatement insertStmt = null;
        ResultSet rs = null;

        try {
            // Retrieve form data
            int employeeId = Integer.parseInt(request.getParameter("employee_id"));
            double baseSalary = Double.parseDouble(request.getParameter("base_salary"));
            double overtime = Double.parseDouble(request.getParameter("overtime"));
            double deductions = Double.parseDouble(request.getParameter("deductions"));
            double netSalary = Double.parseDouble(request.getParameter("net_salary"));

            
            conn = DBConection.getConnection();

            
            String checkQuery = "SELECT COUNT(*) FROM salary_payments WHERE employee_id = ? AND MONTH(date) = MONTH(CURRENT_DATE()) AND YEAR(date) = YEAR(CURRENT_DATE())";
            checkStmt = conn.prepareStatement(checkQuery);
            checkStmt.setInt(1, employeeId);
            rs = checkStmt.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                response.sendRedirect(request.getContextPath() +"/jsp_pages/admin/salary.jsp?error=duplicate");
                return; // Exit function to prevent further execution
            }

            
            String insertQuery = "INSERT INTO salary_payments (employee_id, base_salary, overtime, deductions, net_salary, date) VALUES (?, ?, ?, ?, ?, NOW())";
            insertStmt = conn.prepareStatement(insertQuery);
            insertStmt.setInt(1, employeeId);
            insertStmt.setDouble(2, baseSalary);
            insertStmt.setDouble(3, overtime);
            insertStmt.setDouble(4, deductions);
            insertStmt.setDouble(5, netSalary);
            
            int rowsInserted = insertStmt.executeUpdate();

            if (rowsInserted > 0) {
                response.sendRedirect(request.getContextPath() +"/jsp_pages/admin/salary.jsp?success=true");
            } else {
                response.sendRedirect(request.getContextPath() +"/jsp_pages/admin/salary.jsp?error=true");
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() +"/jsp_pages/admin/salary.jsp?error=invalid_input");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() +"/jsp_pages/admin/salary.jsp?error=db_error");
        } catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
            try {
                if (rs != null) rs.close();
                if (checkStmt != null) checkStmt.close();
                if (insertStmt != null) insertStmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }
}
