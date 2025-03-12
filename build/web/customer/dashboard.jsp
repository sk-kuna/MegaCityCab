<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="util.DBConnection"%>
<% 
    if (session.getAttribute("userType") == null || !session.getAttribute("userType").equals("CUSTOMER")) {
        response.sendRedirect("../login.jsp");
        return;
    }

    // Fetch user data
    int userId = (int) session.getAttribute("userId");
    Connection conn = DBConnection.getConnection();
    
    // Get recent bookings
    PreparedStatement stmt = conn.prepareStatement(
        "SELECT * FROM bookings WHERE customer_id = ? ORDER BY booking_time DESC LIMIT 5"
    );
    stmt.setInt(1, userId);
    ResultSet recentBookings = stmt.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Customer Dashboard - MegaCity Cab</title>
    <link rel="stylesheet" href="../css/style.css">
    <link rel="stylesheet" href="../css/customer.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="customer-container">
        <!-- Sidebar -->
        <%@ include file="includes/sidebar.jsp" %>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Top Navigation -->
            <div class="top-nav">
                <h1>Welcome, ${username}!</h1>
                <div class="user-menu">
                    <span>${username}</span>
                    <form action="../LogoutServlet" method="post" style="display: inline;">
                        <button type="submit" class="logout-btn">
                            <i class="fas fa-sign-out-alt"></i> Logout
                        </button>
                    </form>
                </div>
            </div>

            <!-- Dashboard Content -->
            <div class="dashboard-content">
                <!-- Quick Actions -->
                <div class="quick-actions-grid">
                    <div class="action-card" onclick="location.href='book-ride.jsp'">
                        <i class="fas fa-taxi"></i>
                        <h3>Book a Ride</h3>
                        <p>Request a new cab ride</p>
                    </div>
                    <div class="action-card" onclick="location.href='my-rides.jsp'">
                        <i class="fas fa-history"></i>
                        <h3>My Rides</h3>
                        <p>View ride history</p>
                    </div>
                    <div class="action-card" onclick="location.href='profile.jsp'">
                        <i class="fas fa-user"></i>
                        <h3>My Profile</h3>
                        <p>Update personal info</p>
                    </div>
                    <div class="action-card" onclick="location.href='support.jsp'">
                        <i class="fas fa-headset"></i>
                        <h3>Support</h3>
                        <p>Get help & support</p>
                    </div>
                </div>

                <!-- Recent Bookings -->
                <div class="section-card">
                    <div class="section-header">
                        <h2>Recent Bookings</h2>
                        <a href="my-rides.jsp" class="view-all">View All</a>
                    </div>
                    <div class="recent-bookings">
                        <% while(recentBookings.next()) { %>
                            <div class="booking-item">
                                <div class="booking-info">
                                    <h4>Booking #<%= recentBookings.getInt("booking_id") %></h4>
                                    <p><i class="fas fa-map-marker-alt"></i> <%= recentBookings.getString("pickup_location") %> → <%= recentBookings.getString("dropoff_location") %></p>
                                    <p><i class="fas fa-calendar"></i> <%= recentBookings.getTimestamp("booking_time") %></p>
                                </div>
                                <div class="booking-status">
                                    <span class="status <%= recentBookings.getString("status").toLowerCase() %>">
                                        <%= recentBookings.getString("status") %>
                                    </span>
                                </div>
                            </div>
                        <% } %>
                    </div>
                </div>

                <!-- Statistics -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <i class="fas fa-route"></i>
                        <div class="stat-info">
                            <h4>Total Rides</h4>
                            <p class="stat-number">
                                <% 
                                    Statement countStmt = conn.createStatement();
                                    ResultSet countRs = countStmt.executeQuery(
                                        "SELECT COUNT(*) as total FROM bookings WHERE customer_id = " + userId
                                    );
                                    countRs.next();
                                %>
                                <%= countRs.getInt("total") %>
                            </p>
                        </div>
                    </div>
                    <!-- Add more stat cards as needed -->
                </div>
            </div>
        </div>
    </div>

    <script src="../js/customer.js"></script>
</body>
</html>
<% 
    // Close database connections
    recentBookings.close();
    stmt.close();
    conn.close();
%>
