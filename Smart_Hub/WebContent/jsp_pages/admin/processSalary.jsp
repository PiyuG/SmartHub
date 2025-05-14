<%@ page import="java.sql.*, java.io.*, com.smart_hub.servlets.DBConection"%>
<%
    Connection conn = null;
    PreparedStatement stmt = null;
    
    try {
        int employeeId = Integer.parseInt(request.getParameter("employee_id"));
        double baseSalary = Double.parseDouble(request.getParameter("base_salary"));
        double overtime = Double.parseDouble(request.getParameter("overtime"));
        double deductions = Double.parseDouble(request.getParameter("deductions"));
        double netSalary = Double.parseDouble(request.getParameter("net_salary"));
        System.out.print(employeeId);

        conn = DBConection.getConnection();
        stmt = conn.prepareStatement("INSERT INTO salary_payments (employee_id, base_salary, overtime, deductions, net_salary, date) VALUES (?, ?, ?, ?, ?, NOW())");
        stmt.setInt(1, employeeId);
        stmt.setDouble(2, baseSalary);
        stmt.setDouble(3, overtime);
        stmt.setDouble(4, deductions);
        stmt.setDouble(5, netSalary);
        stmt.executeUpdate();

        response.sendRedirect("salary.jsp?success=true");
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("salary.jsp?error=true");
    } finally {
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
