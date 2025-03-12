<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="util.DBConnection"%>
<% 
    if (session.getAttribute("userType") == null || !session.getAttribute("userType").equals("DRIVER")) {
        response.sendRedirect("../login.jsp");
        return;
    }
    int driverId = (int) session.getAttribute("userId");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Active Rides - Driver Portal</title>
        <link rel="stylesheet" href="../css/style.css">
        <link rel="stylesheet" href="../css/driver.css">
        <link rel="stylesheet" href="../css/active-rides.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>
    <body>
        <div class="driver-container">
            <%@ include file="includes/sidebar.jsp" %>
            
            <div class="main-content">
                <div class="active-rides-content">
                    <h2>Active Rides</h2>
                    
                    <div class="rides-container">
                        <% 
                            try {
                                Connection conn = DBConnection.getConnection();
                                String sql = "SELECT b.*, u.name as customer_name, u.phone as customer_phone " +
                                           "FROM bookings b " +
                                           "JOIN users u ON b.customer_id = u.user_id " +
                                           "WHERE b.driver_id = ? AND b.status IN ('CONFIRMED', 'ONGOING') " +
                                           "ORDER BY b.pickup_time";
                                
                                PreparedStatement stmt = conn.prepareStatement(sql);
                                stmt.setInt(1, driverId);
                                ResultSet rs = stmt.executeQuery();
                                
                                if (!rs.isBeforeFirst()) {
                        %>
                            <div class="no-rides">
                                <i class="fas fa-car"></i>
                                <p>No active rides at the moment</p>
                            </div>
                        <%
                                } else {
                                    while(rs.next()) {
                        %>
                            <div class="ride-card">
                                <div class="ride-header">
                                    <h3>Booking #<%= rs.getInt("booking_id") %></h3>
                                    <span class="status <%= rs.getString("status").toLowerCase() %>">
                                        <%= rs.getString("status") %>
                                    </span>
                                </div>
                                <div class="customer-info">
                                    <p><i class="fas fa-user"></i> <%= rs.getString("customer_name") %></p>
                                    <p><i class="fas fa-phone"></i> <%= rs.getString("customer_phone") %></p>
                                </div>
                                <div class="ride-details">
                                    <div class="location">
                                        <p><i class="fas fa-map-marker-alt pickup"></i> <%= rs.getString("pickup_location") %></p>
                                        <div class="route-line"></div>
                                        <p><i class="fas fa-map-marker-alt dropoff"></i> <%= rs.getString("dropoff_location") %></p>
                                    </div>
                                    <p><i class="fas fa-clock"></i> <%= rs.getTimestamp("pickup_time") %></p>
                                    <p><i class="fas fa-users"></i> <%= rs.getInt("passenger_count") %> passengers</p>
                                </div>
                                <div class="ride-actions">
                                    <% if(rs.getString("status").equals("CONFIRMED")) { %>
                                        <button onclick="startRide(<%= rs.getInt("booking_id") %>)" class="action-btn start-btn">
                                            <i class="fas fa-play"></i> Start Ride
                                        </button>
                                    <% } else if(rs.getString("status").equals("ONGOING")) { %>
                                        <button onclick="completeRide(<%= rs.getInt("booking_id") %>)" class="action-btn complete-btn">
                                            <i class="fas fa-check"></i> Complete Ride
                                        </button>
                                    <% } %>
                                    <button onclick="cancelRide(<%= rs.getInt("booking_id") %>)" class="action-btn cancel-btn">
                                        <i class="fas fa-times"></i> Cancel
                                    </button>
                                    <button onclick="showDirections('<%= rs.getString("pickup_location") %>')" class="action-btn directions-btn">
                                        <i class="fas fa-directions"></i> Get Directions
                                    </button>
                                </div>
                            </div>
                        <%
                                    }
                                }
                                rs.close();
                                stmt.close();
                                conn.close();
                            } catch(SQLException e) {
                                e.printStackTrace();
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>
        
        <script src="../js/driver.js"></script>
        <script src="../js/active-rides.js"></script>
    </body>
</html>
