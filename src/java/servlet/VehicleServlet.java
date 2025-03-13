package servlet;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.sql.*;
import util.DBConnection;

public class VehicleServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if ("get".equals(request.getParameter("action"))) {
            getVehicleDetails(request, response);
        }
    }

    private void getVehicleDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        try {
            int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
            Connection conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM vehicles WHERE vehicle_id = ?");
            stmt.setInt(1, vehicleId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                // Create simple JSON object
                out.print("{");
                out.print("\"id\":" + rs.getInt("vehicle_id") + ",");
                out.print("\"registrationNumber\":\"" + rs.getString("registration_number") + "\",");
                out.print("\"model\":\"" + rs.getString("model") + "\",");
                out.print("\"capacity\":" + rs.getInt("capacity"));
                out.print("}");
            }
            
            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            out.print("{\"error\":\"Error loading vehicle\"}");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        PrintWriter out = response.getWriter();
        
        try (Connection conn = DBConnection.getConnection()) {
            switch (action) {
                case "add":
                    try (PreparedStatement stmt = conn.prepareStatement(
                            "INSERT INTO vehicles (registration_number, model, capacity) VALUES (?, ?, ?)")) {
                        stmt.setString(1, request.getParameter("registrationNumber"));
                        stmt.setString(2, request.getParameter("model"));
                        stmt.setInt(3, Integer.parseInt(request.getParameter("capacity")));
                        stmt.executeUpdate();
                        out.write("success");
                    }
                    break;
                    
                case "edit":
                    try (PreparedStatement stmt = conn.prepareStatement(
                            "UPDATE vehicles SET registration_number=?, model=?, capacity=? WHERE vehicle_id=?")) {
                        stmt.setString(1, request.getParameter("registrationNumber"));
                        stmt.setString(2, request.getParameter("model"));
                        stmt.setInt(3, Integer.parseInt(request.getParameter("capacity")));
                        stmt.setInt(4, Integer.parseInt(request.getParameter("vehicleId")));
                        stmt.executeUpdate();
                        out.write("success");
                    }
                    break;
                    
                case "delete":
                    try {
                        PreparedStatement stmt = conn.prepareStatement("DELETE FROM vehicles WHERE vehicle_id = ?");
                        stmt.setInt(1, Integer.parseInt(request.getParameter("vehicleId")));
                        int result = stmt.executeUpdate();
                        out.print(result > 0 ? "success" : "error");
                        stmt.close();
                    } catch (Exception e) {
                        out.print("error");
                    }
                    break;
                    
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (SQLException e) {
            out.write("error: " + e.getMessage());
        }
    }
}
