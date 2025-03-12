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
        
        if ("getCurrentStatus".equals(action)) {
            getCurrentStatus(request, response);
        } else if ("get".equals(action)) {
            getDriverDetails(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("updateStatus".equals(action)) {
            HttpSession session = request.getSession();
            int driverId = (int) session.getAttribute("userId");
            String status = request.getParameter("status").toUpperCase(); // Ensure uppercase
            
            try {
                // Validate status value
                if (!status.equals("ONLINE") && !status.equals("OFFLINE")) {
                    response.getWriter().write("error: Invalid status value");
                    return;
                }

                Connection conn = DBConnection.getConnection();
                String sql = "UPDATE driver_details SET status = ? WHERE driver_id = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, status);
                stmt.setInt(2, driverId);
                
                int result = stmt.executeUpdate();
                
                response.setContentType("text/plain");
                PrintWriter out = response.getWriter();
                
                if (result > 0) {
                    out.write("success");
                } else {
                    out.write("error: No driver found with ID " + driverId);
                }
                
                stmt.close();
                conn.close();
                
            } catch (SQLException e) {
                response.getWriter().write("error: " + e.getMessage());
                e.printStackTrace();
            }
        } else {
            switch(action) {
                case "add":
                    addDriver(request, response);
                    break;
                case "edit":
                    updateDriver(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        }
    }
    
    private void getDriverDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int driverId = Integer.parseInt(request.getParameter("driverId"));
        
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT d.* FROM driver_details d WHERE d.driver_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, driverId);
            ResultSet rs = stmt.executeQuery();
            
            StringBuilder html = new StringBuilder("{");
            if(rs.next()) {
                html.append("\"licenseNumber\":\"").append(rs.getString("license_number")).append("\",");
                html.append("\"experience\":").append(rs.getInt("experience_years")).append(",");
                html.append("\"status\":\"").append(rs.getString("status")).append("\"");
            }
            html.append("}");
            
            response.setContentType("text/plain");
            response.getWriter().write(html.toString());
            
            rs.close();
            stmt.close();
            conn.close();
            
        } catch(SQLException e) {
            throw new ServletException(e);
        }
    }
    
    private void addDriver(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String licenseNumber = request.getParameter("licenseNumber");
        int experience = Integer.parseInt(request.getParameter("experience"));
        String status = request.getParameter("status");
        
        try {
            Connection conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            try {
                // First, create user entry
                String userSql = "INSERT INTO users (username, password, email, name, phone, user_type) " +
                               "VALUES (?, ?, ?, ?, ?, 'DRIVER')";
                PreparedStatement userStmt = conn.prepareStatement(userSql, Statement.RETURN_GENERATED_KEYS);
                
                userStmt.setString(1, licenseNumber); // Using license number as username
                userStmt.setString(2, "changepass123"); // Default password
                userStmt.setString(3, request.getParameter("email"));
                userStmt.setString(4, request.getParameter("name"));
                userStmt.setString(5, request.getParameter("phone"));
                
                userStmt.executeUpdate();
                
                // Get the generated user ID
                ResultSet rs = userStmt.getGeneratedKeys();
                if(rs.next()) {
                    int driverId = rs.getInt(1);
                    
                    // Then create driver details
                    String driverSql = "INSERT INTO driver_details (driver_id, license_number, experience_years, rating, status) " +
                                     "VALUES (?, ?, ?, 0.00, ?)";
                    PreparedStatement driverStmt = conn.prepareStatement(driverSql);
                    
                    driverStmt.setInt(1, driverId);
                    driverStmt.setString(2, licenseNumber);
                    driverStmt.setInt(3, experience);
                    driverStmt.setString(4, status);
                    
                    driverStmt.executeUpdate();
                    conn.commit();
                    
                    response.setContentType("text/plain");
                    response.getWriter().write("success");
                }
                
            } catch(SQLException e) {
                conn.rollback();
                throw e;
            }
            conn.close();
            
        } catch(SQLException e) {
            response.setContentType("text/plain");
            response.getWriter().write("error: " + e.getMessage());
        }
    }

    private void updateDriver(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int driverId = Integer.parseInt(request.getParameter("driverId"));
        String licenseNumber = request.getParameter("licenseNumber");
        int experience = Integer.parseInt(request.getParameter("experience"));
        String status = request.getParameter("status");
        
        try {
            Connection conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            try {
                // Update driver details
                String sql = "UPDATE driver_details SET license_number = ?, experience_years = ?, status = ? " +
                           "WHERE driver_id = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                
                stmt.setString(1, licenseNumber);
                stmt.setInt(2, experience);
                stmt.setString(3, status);
                stmt.setInt(4, driverId);
                
                stmt.executeUpdate();
                
                // Update user details if provided
                if(request.getParameter("name") != null && request.getParameter("email") != null) {
                    String userSql = "UPDATE users SET name = ?, email = ?, phone = ? WHERE user_id = ?";
                    PreparedStatement userStmt = conn.prepareStatement(userSql);
                    userStmt.setString(1, request.getParameter("name"));
                    userStmt.setString(2, request.getParameter("email"));
                    userStmt.setString(3, request.getParameter("phone"));
                    userStmt.setInt(4, driverId);
                    userStmt.executeUpdate();
                }
                
                conn.commit();
                response.setContentType("text/plain");
                response.getWriter().write("success");
                
            } catch(SQLException e) {
                conn.rollback();
                throw e;
            }
            conn.close();
            
        } catch(SQLException e) {
            response.setContentType("text/plain");
            response.getWriter().write("error: " + e.getMessage());
        }
    }

    private void getCurrentStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int driverId = (int) session.getAttribute("userId");
        
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT status FROM driver_details WHERE driver_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, driverId);
            
            ResultSet rs = stmt.executeQuery();
            String status = "OFFLINE"; // Default status
            
            if (rs.next()) {
                status = rs.getString("status");
            }
            
            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().write(status);
            
            rs.close();
            stmt.close();
            conn.close();
            
        } catch (SQLException e) {
            response.getWriter().write("OFFLINE");
            e.printStackTrace();
        }
    }
}
