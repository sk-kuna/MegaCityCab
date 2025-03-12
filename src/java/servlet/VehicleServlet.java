package servlet;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.sql.*;
import util.DBConnection;

public class VehicleServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("get".equals(action)) {
            getVehicleDetails(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        switch(action) {
            case "add":
                addVehicle(request, response);
                break;
            case "edit":
                updateVehicle(request, response);
                break;
            case "delete":
                deleteVehicle(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
    
    private void getVehicleDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
        
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM vehicles WHERE vehicle_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, vehicleId);
            ResultSet rs = stmt.executeQuery();
            
            StringBuilder html = new StringBuilder("{");
            if(rs.next()) {
                html.append("\"registrationNumber\":\"").append(rs.getString("registration_number")).append("\",");
                html.append("\"model\":\"").append(rs.getString("model")).append("\",");
                html.append("\"capacity\":").append(rs.getInt("capacity")).append(",");
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
    
    private void addVehicle(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String registrationNumber = request.getParameter("registrationNumber");
        String model = request.getParameter("model");
        int capacity = Integer.parseInt(request.getParameter("capacity"));
        String status = request.getParameter("status");
        
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO vehicles (registration_number, model, capacity, status) VALUES (?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            
            stmt.setString(1, registrationNumber);
            stmt.setString(2, model);
            stmt.setInt(3, capacity);
            stmt.setString(4, status);
            
            int result = stmt.executeUpdate();
            
            response.setContentType("text/plain");
            response.getWriter().write(result > 0 ? "success" : "error");
            
            stmt.close();
            conn.close();
            
        } catch(SQLException e) {
            response.getWriter().write("error: " + e.getMessage());
        }
    }
    
    private void updateVehicle(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
        String registrationNumber = request.getParameter("registrationNumber");
        String model = request.getParameter("model");
        int capacity = Integer.parseInt(request.getParameter("capacity"));
        String status = request.getParameter("status");
        
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE vehicles SET registration_number=?, model=?, capacity=?, status=? WHERE vehicle_id=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            
            stmt.setString(1, registrationNumber);
            stmt.setString(2, model);
            stmt.setInt(3, capacity);
            stmt.setString(4, status);
            stmt.setInt(5, vehicleId);
            
            int result = stmt.executeUpdate();
            
            response.setContentType("text/plain");
            response.getWriter().write(result > 0 ? "success" : "error");
            
            stmt.close();
            conn.close();
            
        } catch(SQLException e) {
            response.getWriter().write("error: " + e.getMessage());
        }
    }
    
    private void deleteVehicle(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
        
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "DELETE FROM vehicles WHERE vehicle_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            
            stmt.setInt(1, vehicleId);
            int result = stmt.executeUpdate();
            
            response.setContentType("text/plain");
            response.getWriter().write(result > 0 ? "success" : "error");
            
            stmt.close();
            conn.close();
            
        } catch(SQLException e) {
            response.getWriter().write("error: " + e.getMessage());
        }
    }
}
