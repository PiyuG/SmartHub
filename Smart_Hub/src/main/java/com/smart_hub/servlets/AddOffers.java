package com.smart_hub.servlets;

import java.io.*;
import java.sql.*;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


public class AddOffers extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

            int prod_id= Integer.parseInt(request.getParameter("product"));
            double original_price = Double.parseDouble(request.getParameter("price"));
            String discount_type = request.getParameter("discountType");
            double discount_value = Double.parseDouble(request.getParameter("discountValue"));
            double final_price = Double.parseDouble(request.getParameter("finalPrice"));
            String start_date=request.getParameter("startDate");
            String end_date=request.getParameter("endDate");
            String message = null;
            String messageType = null;

           

            try (Connection conn = DBConection.getConnection()) {
                String sql = "INSERT INTO offers (prod_id, original_price, discount_type, discount_value, final_price, start_date, end_date) VALUES (?, ?, ?, ?, ?, ?, ?)";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setInt(1, prod_id);
                    stmt.setDouble(2, original_price);
                    stmt.setString(3, discount_type);
                    stmt.setDouble(4, discount_value);
                    stmt.setDouble(5, final_price);
                    stmt.setDate(6, java.sql.Date.valueOf(start_date));
                    stmt.setDate(7, java.sql.Date.valueOf(end_date));
                    

                    int rowsInserted = stmt.executeUpdate();
                    if (rowsInserted > 0) {
                    	message = "Offer Added!";
                        messageType = "success";
                    } else {
                    	message = "Error to added offer!";
                        messageType = "error";
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            
            } catch (ClassNotFoundException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
            request.setAttribute("message", message);
            request.setAttribute("messageType", messageType);
            
            // Forward the request back to the registration page
            RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp_pages/admin/addOffers.jsp");
            dispatcher.forward(request, response);
        }
}