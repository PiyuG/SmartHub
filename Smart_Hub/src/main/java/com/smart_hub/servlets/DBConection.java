package com.smart_hub.servlets;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConection {
    private static final String URL = "jdbc:mysql://localhost:3306/smarthub"; // Database URL
    private static final String USER = "root"; // Your MySQL username
    private static final String PASSWORD = ""; // Your MySQL password (default is empty for XAMPP)

    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver"); // Load MySQL JDBC Driver
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
    
    public static void main(String[] args) {
        try {
            Connection conn = getConnection();
            if (conn != null) {
                System.out.println("Database connected successfully!");
                conn.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
