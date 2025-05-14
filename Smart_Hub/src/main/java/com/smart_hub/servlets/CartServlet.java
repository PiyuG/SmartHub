package com.smart_hub.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;



public class CartServlet extends HttpServlet {
    
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/jsp_pages/index/customerlogin.jsp"); // Redirect if user not logged in
            return;
        }

        // Get product details from the request parameters
        int productId = Integer.parseInt(request.getParameter("product_id"));
        String name=request.getParameter("product_name");
        double price = Double.parseDouble(request.getParameter("price"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        String image = request.getParameter("image");

        try {
            Connection conn = DBConection.getConnection();

            String sql = "INSERT INTO cart (user_id, product_id, name, price, quantity, image, added_on) " +
                    "VALUES (?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP) " +
                    "ON DUPLICATE KEY UPDATE quantity = quantity + ?";

            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);  // user_id
            stmt.setInt(2, productId);
            stmt.setString(3, name);// product_id
            stmt.setDouble(4, price); // price
            stmt.setInt(5, quantity); // quantity
            stmt.setString(6, image); // image
            stmt.setInt(7, quantity); // update quantity if product already exists

            stmt.executeUpdate();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("jsp_pages/customer/cart.jsp"); // Redirect to cart page after adding to cart
    }
}
