package com.smart_hub.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class BuyProductServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    int productId = Integer.parseInt(request.getParameter("productId"));
	    int quantity = Integer.parseInt(request.getParameter("quantity"));
	    HttpSession session = request.getSession();
	    String employeeId = (String) session.getAttribute("employee_id"); // assuming session stores employee ID

	    try (Connection conn = DBConection.getConnection()) {
	        // 1. Fetch product details
	        PreparedStatement ps1 = conn.prepareStatement("SELECT * FROM products WHERE prod_id = ?");
	        ps1.setInt(1, productId);
	        ResultSet rs = ps1.executeQuery();

	        if (rs.next()) {
	            int stock = rs.getInt("stock");
	            int price = rs.getInt("price");
	            String name = rs.getString("name");

	            if (quantity > stock) {
	                request.setAttribute("error", "Not enough stock available.");
	                request.getRequestDispatcher("/jsp_pages/employee/buyProduct.jsp").forward(request, response);
	                return;
	            }

	            // 2. Reduce stock
	            PreparedStatement ps2 = conn.prepareStatement("UPDATE products SET stock = stock - ? WHERE prod_id = ?");
	            ps2.setInt(1, quantity);
	            ps2.setInt(2, productId);
	            ps2.executeUpdate();

	            // 3. Insert into bill table
	            PreparedStatement ps3 = conn.prepareStatement("INSERT INTO employee_bills (employee_id, prod_id, quantity, total_amount, bill_date) VALUES (?, ?, ?, ?, NOW())");
	            ps3.setString(1, employeeId);
	            ps3.setInt(2, productId);
	            ps3.setInt(3, quantity);
	            ps3.setInt(4, quantity * price);
	            ps3.executeUpdate();

	            // ✅ 4. Redirect to invoice
	            request.setAttribute("message", "Product purchased successfully!");
	            request.setAttribute("productName", name);
	            request.setAttribute("quantity", quantity);
	            request.setAttribute("total", quantity * price);
	            request.getRequestDispatcher("/jsp_pages/employee/employee_invoice.jsp").forward(request, response);
	        }
	    } catch (Exception e) {
	        request.setAttribute("error", "Error processing purchase: " + e.getMessage());
	        request.getRequestDispatcher("/jsp_pages/employee/buyProduct.jsp").forward(request, response);
	    }
	}

}
