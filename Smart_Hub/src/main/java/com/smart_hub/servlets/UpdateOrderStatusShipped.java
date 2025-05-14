package com.smart_hub.servlets;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;


public class UpdateOrderStatusShipped extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String status = request.getParameter("status");

        try (Connection conn = DBConection.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("UPDATE orders SET status = ? WHERE order_id = ?");
            stmt.setString(1, status);
            stmt.setInt(2, orderId);

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                request.setAttribute("assignMessage", "Order marked as " + status + " successfully.");
            } else {
                request.setAttribute("assignMessage", "Failed to update order status.");
            }

            RequestDispatcher dispatcher=request.getRequestDispatcher("/jsp_pages/employee/delivery_order.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("assignMessage", "Error: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp_pages/employee/delivery_order.jsp");
            dispatcher.forward(request, response);
        }
    }
}
