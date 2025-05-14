package com.smart_hub.servlets;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;


public class ManageCustomer extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
   
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 String action = request.getParameter("action");
	        String idParam = request.getParameter("id");
	        String message = null;
	        String messageType = null;

	        if (idParam == null || idParam.isEmpty()) {
	        	message = "Invalid Employee ID";
	            messageType = "error";
	            return;
	        }

	        int id = Integer.parseInt(idParam);
	        Connection conn = null;
	        PreparedStatement stmt = null;
	        
	        try {
	            conn = DBConection.getConnection();

	            if ("delete".equals(action)) {
	                String sql = "DELETE FROM customer WHERE id=?";
	                stmt = conn.prepareStatement(sql);
	                stmt.setInt(1, id);
	                int rowsDeleted = stmt.executeUpdate();

	                if (rowsDeleted > 0) {
	                    message = "Customer Information Deleted!";
	                    messageType = "success";
	                } else {
	                	message = "Error to Customer Information Deleted!";
	                    messageType = "error";
	                }
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	            response.sendRedirect(request.getContextPath() + "/jsp_pages/admin/manageCustomer.jsp?error=" + e.getMessage());
	        } finally {
	            try {
	                if (stmt != null) stmt.close();
	                if (conn != null) conn.close();
	            } catch (Exception e) {
	                e.printStackTrace();
	            }
	        }
	        request.setAttribute("message", message);
	        request.setAttribute("messageType", messageType);
	        
	        RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp_pages/admin/manageCustomer.jsp");
	        dispatcher.forward(request, response);
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        int id = (idParam != null && !idParam.isEmpty()) ? Integer.parseInt(idParam) : -1;
        String message = null;
        String messageType = null;

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConection.getConnection();

            if ("edit".equals(action) && id > 0) {
                // Edit Employee Details
                String name = request.getParameter("name");
                String mail = request.getParameter("mail");
                String mobno = request.getParameter("phone");
                String address = request.getParameter("address");

                // Update customer details
                String sql = "UPDATE customer SET name=?, mail=?, phone=?, address=? WHERE id=?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, name);
                stmt.setString(2, mail);
                stmt.setString(3, mobno);
                stmt.setString(4, address);
                stmt.setInt(5, id);
                
                int rowsUpdated = stmt.executeUpdate();
                if (rowsUpdated > 0) {
                    message = "Customer Information Updated!";
                    messageType = "success";
                } else {
                    message = "Error Updating Customer Info!";
                    messageType = "error";
                }
            } 
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        request.setAttribute("message", message);
        request.setAttribute("messageType", messageType);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp_pages/admin/manageCustomer.jsp");
        dispatcher.forward(request, response);
	}

}
