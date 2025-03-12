package servlet;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.sql.*;
import util.DBConnection;

public class BookingServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        switch(action) {
            case "view":
                getBookingDetails(request, response);
                break;
            case "getDrivers":
                getAvailableDrivers(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        response.setContentType("text/plain;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        if (action == null || action.trim().isEmpty()) {
            out.write("error: Missing action parameter");
            return;
        }
        
        try {
            switch(action) {
                case "assign":
                    assignDriver(request, response);
                    break;
                case "updateStatus":
                    updateBookingStatus(request, response);
                    break;
                default:
                    createBooking(request, response);
            }
        } catch (Exception e) {
            out.write("error: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private void getBookingDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT b.*, u.name as customer_name, d.name as driver_name " +
                        "FROM bookings b " +
                        "LEFT JOIN users u ON b.customer_id = u.user_id " +
                        "LEFT JOIN users d ON b.driver_id = d.user_id " +
                        "WHERE b.booking_id = ?";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, bookingId);
            ResultSet rs = stmt.executeQuery();
            
            StringBuilder html = new StringBuilder();
            if(rs.next()) {
                html.append("<div class='booking-detail-grid'>");
                html.append("<p><strong>Booking ID:</strong> ").append(rs.getInt("booking_id")).append("</p>");
                html.append("<p><strong>Customer:</strong> ").append(rs.getString("customer_name")).append("</p>");
                html.append("<p><strong>Driver:</strong> ").append(rs.getString("driver_name") != null ? rs.getString("driver_name") : "Not Assigned").append("</p>");
                html.append("<p><strong>Vehicle Type:</strong> ").append(rs.getString("vehicle_type")).append("</p>");
                html.append("<p><strong>Passengers:</strong> ").append(rs.getInt("passenger_count")).append("</p>");
                html.append("<p><strong>Pickup:</strong> ").append(rs.getString("pickup_location")).append("</p>");
                html.append("<p><strong>Dropoff:</strong> ").append(rs.getString("dropoff_location")).append("</p>");
                html.append("<p><strong>Pickup Time:</strong> ").append(rs.getTimestamp("pickup_time")).append("</p>");
                html.append("<p><strong>Status:</strong> ").append(rs.getString("status")).append("</p>");
                html.append("</div>");
            }
            
            response.setContentType("text/html");
            response.getWriter().write(html.toString());
            
            rs.close();
            stmt.close();
            conn.close();
            
        } catch(SQLException e) {
            throw new ServletException(e);
        }
    }
    
    private void getAvailableDrivers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT user_id, name, phone FROM users WHERE user_type = 'DRIVER' AND user_id NOT IN " +
                        "(SELECT driver_id FROM bookings WHERE status IN ('CONFIRMED', 'ONGOING'))";
            
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            
            StringBuilder html = new StringBuilder();
            html.append("<option value=''>Choose a driver...</option>");
            while(rs.next()) {
                html.append("<option value='").append(rs.getInt("user_id")).append("'>");
                html.append(rs.getString("name")).append(" (").append(rs.getString("phone")).append(")");
                html.append("</option>");
            }
            
            response.setContentType("text/html");
            response.getWriter().write(html.toString());
            
            rs.close();
            stmt.close();
            conn.close();
            
        } catch(SQLException e) {
            throw new ServletException(e);
        }
    }
    
    private void assignDriver(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        int driverId = Integer.parseInt(request.getParameter("driverId"));
        
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE bookings SET driver_id = ?, status = 'CONFIRMED' WHERE booking_id = ?";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, driverId);
            stmt.setInt(2, bookingId);
            
            int result = stmt.executeUpdate();
            
            response.setContentType("text/plain");
            response.getWriter().write(result > 0 ? "success" : "error");
            
            stmt.close();
            conn.close();
            
        } catch(SQLException e) {
            throw new ServletException(e);
        }
    }
    
    private void updateBookingStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String bookingId = request.getParameter("bookingId");
            String status = request.getParameter("status");
            
            if (bookingId == null || status == null) {
                response.getWriter().write("error: Missing required parameters");
                return;
            }

            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE bookings SET status = ? WHERE booking_id = ?";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, status);
            stmt.setInt(2, Integer.parseInt(bookingId));
            
            int result = stmt.executeUpdate();
            
            response.getWriter().write(result > 0 ? "success" : "error: Update failed");
            
            stmt.close();
            conn.close();
            
        } catch(Exception e) {
            response.getWriter().write("error: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private void createBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int customerId = (int) session.getAttribute("userId");
        
        String pickupLocation = request.getParameter("pickup_location");
        String dropoffLocation = request.getParameter("dropoff_location");
        String pickupTime = request.getParameter("pickup_time");
        int passengerCount = Integer.parseInt(request.getParameter("passenger_count"));
        String vehicleType = request.getParameter("vehicle_type");
        
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO bookings (customer_id, pickup_location, dropoff_location, " +
                        "booking_time, pickup_time, passenger_count, vehicle_type, status) " +
                        "VALUES (?, ?, ?, NOW(), ?, ?, ?, 'PENDING')";
            PreparedStatement stmt = conn.prepareStatement(sql);
            
            stmt.setInt(1, customerId);
            stmt.setString(2, pickupLocation);
            stmt.setString(3, dropoffLocation);
            stmt.setString(4, pickupTime);
            stmt.setInt(5, passengerCount);
            stmt.setString(6, vehicleType);
            
            int result = stmt.executeUpdate();
            
            if(result > 0) {
                response.sendRedirect("customer/my-rides.jsp");
            } else {
                request.setAttribute("error", "Failed to book ride");
                request.getRequestDispatcher("customer/book-ride.jsp").forward(request, response);
            }
            
            stmt.close();
            conn.close();
            
        } catch(SQLException e) {
            throw new ServletException(e);
        }
    }
}
