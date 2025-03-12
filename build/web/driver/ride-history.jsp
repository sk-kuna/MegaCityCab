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
        <title>Ride History - Driver Portal</title>
        <link rel="stylesheet" href="../css/style.css">
        <link rel="stylesheet" href="../css/driver.css">
        <link rel="stylesheet" href="../css/ride-history.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>
    <body>
        <div class="driver-container">
            <%@ include file="includes/sidebar.jsp" %>
            
            <div class="main-content">
                <div class="history-content">
                    <div class="history-header">
                        <h2>Ride History</h2>
                        <div class="history-filters">
                            <input type="date" id="dateFilter" onchange="filterRides()">
                            <select id="statusFilter" onchange="filterRides()">
                                <option value="">All Status</option>
                                <option value="COMPLETED">Completed</option>
                                <option value="CANCELLED">Cancelled</option>
                            </select>
                        </div>
                    </div>

                    <div class="history-stats">
                        <div class="stat-card">
                            <i class="fas fa-route"></i>
                            <div class="stat-info">
                                <h4>Total Rides</h4>
                                <p id="totalRides">Loading...</p>
                            </div>
                        </div>
                        <div class="stat-card">
                            <i class="fas fa-money-bill-wave"></i>
                            <div class="stat-info">
                                <h4>Total Earnings</h4>
                                <p id="totalEarnings">Loading...</p>
                            </div>
                        </div>
                        <div class="stat-card">
                            <i class="fas fa-star"></i>
                            <div class="stat-info">
                                <h4>Average Rating</h4>
                                <p id="avgRating">Loading...</p>
                            </div>
                        </div>
                    </div>

                    <div class="rides-list">
                        <% 
                            try {
                                Connection conn = DBConnection.getConnection();
                                String sql = "SELECT b.*, u.name as customer_name, u.phone as customer_phone, " +
                                           "p.total_amount, COALESCE(r.rating, 0) as ride_rating " +
                                           "FROM bookings b " +
                                           "LEFT JOIN users u ON b.customer_id = u.user_id " +
                                           "LEFT JOIN payments p ON b.booking_id = p.booking_id " +
                                           "LEFT JOIN ride_ratings r ON b.booking_id = r.booking_id " +
                                           "WHERE b.driver_id = ? AND b.status IN ('COMPLETED', 'CANCELLED') " +
                                           "ORDER BY b.booking_time DESC";
                                
                                PreparedStatement stmt = conn.prepareStatement(sql);
                                stmt.setInt(1, driverId);
                                ResultSet rs = stmt.executeQuery();
                                
                                while(rs.next()) {
                        %>
                            <div class="ride-card" data-date="<%= rs.getTimestamp("booking_time") %>" 
                                 data-status="<%= rs.getString("status") %>">
                                <div class="ride-header">
                                    <div class="ride-id">
                                        <h3>Booking #<%= rs.getInt("booking_id") %></h3>
                                        <span class="ride-date"><%= rs.getTimestamp("booking_time") %></span>
                                    </div>
                                    <span class="status <%= rs.getString("status").toLowerCase() %>">
                                        <%= rs.getString("status") %>
                                    </span>
                                </div>
                                <div class="ride-details">
                                    <div class="customer-info">
                                        <p><i class="fas fa-user"></i> <%= rs.getString("customer_name") %></p>
                                        <p><i class="fas fa-phone"></i> <%= rs.getString("customer_phone") %></p>
                                    </div>
                                    <div class="trip-info">
                                        <p><i class="fas fa-map-marker-alt"></i> <%= rs.getString("pickup_location") %> → <%= rs.getString("dropoff_location") %></p>
                                        <% if(rs.getString("status").equals("COMPLETED")) { %>
                                            <p><i class="fas fa-money-bill"></i> LKR <%= String.format("%.2f", rs.getDouble("total_amount")) %></p>
                                            <p><i class="fas fa-star"></i> Rating: <%= String.format("%.1f", rs.getDouble("ride_rating")) %></p>
                                        <% } %>
                                    </div>
                                </div>
                            </div>
                        <%
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
        
        <script src="../js/ride-history.js"></script>
    </body>
</html>
