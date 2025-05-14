package com.smart_hub.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class RemoveFromCartServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String cartIdParam = request.getParameter("cart_id");

        if (cartIdParam != null && !cartIdParam.isEmpty()) {
            int cartId = Integer.parseInt(cartIdParam);

            Connection conn = null;
            PreparedStatement stmt = null;

            try {
                conn = DBConection.getConnection();
                String sql = "DELETE FROM cart WHERE id = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, cartId);

                stmt.executeUpdate();

            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try { if (stmt != null) stmt.close(); } catch (SQLException ignored) {}
                try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
            }
        }

        // Redirect back to the cart page
        response.sendRedirect(request.getContextPath() + "/jsp_pages/customer/cart.jsp");
    }
}
