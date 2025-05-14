package com.smart_hub.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.sql.*;

public class SubmitFeedbackServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer customerId = (Integer) session.getAttribute("user_id");

        if (customerId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int orderId = Integer.parseInt(request.getParameter("order_id"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comments = request.getParameter("comments");

            Connection conn = DBConection.getConnection();
            String sql = "INSERT INTO feedback (customer_id, order_id, rating, comments, created_at) VALUES (?, ?, ?, ?, NOW())";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, customerId);
            stmt.setInt(2, orderId);
            stmt.setInt(3, rating);
            stmt.setString(4, comments);

            int rowsInserted = stmt.executeUpdate();
            stmt.close();
            conn.close();

            if (rowsInserted > 0) {
                request.setAttribute("feedbackMessage", "Feedback submitted successfully!");
            } else {
                request.setAttribute("feedbackMessage", "Failed to submit feedback.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("feedbackMessage", "Something went wrong: " + e.getMessage());
        }

        // Forward back to orders page
        RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp_pages/customer/orderHistory.jsp");
        dispatcher.forward(request, response);
    }
}
