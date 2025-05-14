package com.smart_hub.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class PlaceOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = (int) session.getAttribute("user_id");
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String pincode = request.getParameter("pincode");
        String address = request.getParameter("address");
        String paymentMode = request.getParameter("paymentMode");

        Connection conn = null;
        PreparedStatement orderStmt = null;
        PreparedStatement itemStmt = null;
        PreparedStatement clearCartStmt = null;
        PreparedStatement getCartItemsStmt = null;
        PreparedStatement stockStmt = null;
        ResultSet rs = null;
        ResultSet cartItems = null;

        try {
            conn = DBConection.getConnection();
            conn.setAutoCommit(false);

            // Insert order
            String insertOrder = "INSERT INTO orders(customer_id, fullname, phone, pincode, address, order_date, status, payment_mode) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            orderStmt = conn.prepareStatement(insertOrder, Statement.RETURN_GENERATED_KEYS);
            orderStmt.setInt(1, userId);
            orderStmt.setString(2, fullname);
            orderStmt.setString(3, phone);
            orderStmt.setString(4, pincode);
            orderStmt.setString(5, address);
            orderStmt.setString(6, LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
            orderStmt.setString(7, "Processing");
            orderStmt.setString(8, paymentMode);
            orderStmt.executeUpdate();

            rs = orderStmt.getGeneratedKeys();
            int orderId = rs.next() ? rs.getInt(1) : 0;

            // Insert order items from cart
            String itemSQL = "INSERT INTO order_items(order_id, product_id, quantity) SELECT ?, product_id, quantity FROM cart WHERE user_id=?";
            itemStmt = conn.prepareStatement(itemSQL);
            itemStmt.setInt(1, orderId);
            itemStmt.setInt(2, userId);
            itemStmt.executeUpdate();

            // Get cart items to update stock
            getCartItemsStmt = conn.prepareStatement("SELECT product_id, quantity FROM cart WHERE user_id = ?");
            getCartItemsStmt.setInt(1, userId);
            cartItems = getCartItemsStmt.executeQuery();

            stockStmt = conn.prepareStatement(
                "UPDATE products SET stock = stock - ? WHERE prod_id = ? AND stock >= ?"
            );

            while (cartItems.next()) {
                int productId = cartItems.getInt("product_id");
                int quantity = cartItems.getInt("quantity");

                stockStmt.setInt(1, quantity);
                stockStmt.setInt(2, productId);
                stockStmt.setInt(3, quantity);
                stockStmt.executeUpdate();
            }

            // Clear cart
            clearCartStmt = conn.prepareStatement("DELETE FROM cart WHERE user_id=?");
            clearCartStmt.setInt(1, userId);
            clearCartStmt.executeUpdate();

            conn.commit();

            response.sendRedirect(request.getContextPath() + "/jsp_pages/customer/cart.jsp?order=success");

        } catch (Exception e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (SQLException ignored) {}
            response.sendRedirect(request.getContextPath() + "/jsp_pages/customer/cart.jsp?order=error");
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException ignored) {}
            try { if (cartItems != null) cartItems.close(); } catch (SQLException ignored) {}
            try { if (orderStmt != null) orderStmt.close(); } catch (SQLException ignored) {}
            try { if (itemStmt != null) itemStmt.close(); } catch (SQLException ignored) {}
            try { if (getCartItemsStmt != null) getCartItemsStmt.close(); } catch (SQLException ignored) {}
            try { if (stockStmt != null) stockStmt.close(); } catch (SQLException ignored) {}
            try { if (clearCartStmt != null) clearCartStmt.close(); } catch (SQLException ignored) {}
            try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
        }
    }
}
