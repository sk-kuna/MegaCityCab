package servlet;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.sql.*;
import util.DBConnection;

public class DriverServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("get".equals(action)) {
            getDriverDetails(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        switch(action) {
            case "add":
                addDriver(request, response);
                break;
            case "edit":
                updateDriver(request, response);
                break;
            case "delete":
                deleteDriver(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
    
    private void getDriverDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int driverId = Integer.parseInt(request.getParameter("driverId"));
        
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM users WHERE user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, driverId);
            ResultSet rs = stmt.executeQuery();
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            
            if(rs.next()) {
                String json = "{" +
                    "\"id\":" + rs.getInt("user_id") + "," +
                    "\"name\":\"" + rs.getString("name") + "\"," +
                    "\"email\":\"" + rs.getString("email") + "\"," +
                    "\"phone\":\"" + (rs.getString("phone") != null ? rs.getString("phone") : "") + "\"" +
                    "}";
                out.write(json);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.write("{\"error\":\"Driver not found\"}");
            }
            
            rs.close();
            stmt.close();
            conn.close();
            
        } catch(SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }
    
    private void addDriver(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO users (username, password, email, name, phone, user_type) " +
                         "VALUES (?, ?, ?, ?, ?, 'DRIVER')";
            PreparedStatement stmt = conn.prepareStatement(sql);
            
            stmt.setString(1, request.getParameter("email")); // Using email as username
            stmt.setString(2, "changepass123"); // Default password
            stmt.setString(3, request.getParameter("email"));
            stmt.setString(4, request.getParameter("name"));
            stmt.setString(5, request.getParameter("phone"));
            
            int result = stmt.executeUpdate();
            
            response.setContentType("text/plain");
            response.getWriter().write(result > 0 ? "success" : "error: Failed to add driver");
            
            stmt.close();
            conn.close();
            
        } catch(SQLException e) {
            response.setContentType("text/plain");
            response.getWriter().write("error: " + e.getMessage());
        }
    }

    private void updateDriver(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int driverId = Integer.parseInt(request.getParameter("driverId"));
        
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE users SET name = ?, email = ?, phone = ? WHERE user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            
            stmt.setString(1, request.getParameter("name"));
            stmt.setString(2, request.getParameter("email"));
            stmt.setString(3, request.getParameter("phone"));
            stmt.setInt(4, driverId);
            
            int result = stmt.executeUpdate();
            
            response.setContentType("text/plain");
            response.getWriter().write(result > 0 ? "success" : "error: Failed to update driver");
            
            stmt.close();
            conn.close();
            
        } catch(SQLException e) {
            response.setContentType("text/plain");
            response.getWriter().write("error: " + e.getMessage());
        }
    }

    private void deleteDriver(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int driverId = Integer.parseInt(request.getParameter("driverId"));
        
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "DELETE FROM users WHERE user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, driverId);
            
            int result = stmt.executeUpdate();
            
            response.setContentType("text/plain");
            response.getWriter().write(result > 0 ? "success" : "error: Driver not found");
            
            stmt.close();
            conn.close();
            
        } catch(SQLException e) {
            response.setContentType("text/plain");
            response.getWriter().write("error: " + e.getMessage());
        }
    }
}
