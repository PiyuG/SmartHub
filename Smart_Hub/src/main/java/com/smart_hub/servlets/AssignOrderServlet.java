package com.smart_hub.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class AssignOrderServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String deliveryEmail = request.getParameter("deliveryEmail");

        String message;
        try (Connection conn = DBConection.getConnection()) {
            // Step 1: Update order with delivery boy email and status
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE orders SET delivery_boy_email = ?, status = 'Out for Delivery' WHERE order_id = ?"
            );
            ps.setString(1, deliveryEmail);
            ps.setInt(2, orderId);

            int result = ps.executeUpdate();

            if (result > 0) {
                message = "Successfully Assigned Order #" + orderId;
            } else {
                message = "Failed to Assign Order #" + orderId;
            }

            // Step 2: Get delivery boy ID
            int deliveryBoyId = -1;
            PreparedStatement getIdPs = conn.prepareStatement(
                "SELECT id FROM users WHERE mail = ?"
            );
            getIdPs.setString(1, deliveryEmail);
            ResultSet rs = getIdPs.executeQuery();
            if (rs.next()) {
                deliveryBoyId = rs.getInt("id");
            }
            rs.close();
            getIdPs.close();

            // Step 3: Notify delivery boy
            if (deliveryBoyId != -1) {
                PreparedStatement notifPs = conn.prepareStatement(
                    "INSERT INTO notifications (user_id, message) VALUES (?, ?)");
                notifPs.setInt(1, deliveryBoyId);
                notifPs.setString(2, "New order #" + orderId + " has been assigned to you.");
                notifPs.executeUpdate();
                notifPs.close();
            }

            // Step 4: Notify customer
            PreparedStatement customerPs = conn.prepareStatement(
                "SELECT customer_id FROM orders WHERE order_id = ?"
            );
            customerPs.setInt(1, orderId);
            ResultSet customerRs = customerPs.executeQuery();
            int customerId = -1;
            if (customerRs.next()) {
                customerId = customerRs.getInt("customer_id");
            }
            customerRs.close();
            customerPs.close();

            if (customerId != -1) {
                PreparedStatement customerNotif = conn.prepareStatement(
                    "INSERT INTO notifications (user_id, message) VALUES (?, ?)"
                );
                customerNotif.setInt(1, customerId);
                customerNotif.setString(2, "Your order #" + orderId + " is now out for delivery.");
                customerNotif.executeUpdate();
                customerNotif.close();
            }

        } catch (Exception e) {
            e.printStackTrace();
            message = "An error occurred while assigning order: " + e.getMessage();
        }

        request.setAttribute("assignMessage", message);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp_pages/admin/admin_orders.jsp");
        dispatcher.forward(request, response);
    }
}
