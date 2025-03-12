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
    <!-- <link rel="stylesheet" href="../css/style.css">
    <link rel="stylesheet" href="../css/customer.css"> -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">\

    <style>
        /* Main container and layout */
body {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  margin: 0;
  padding: 0;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4efe9 100%);
  color: #333;
  min-height: 100vh;
}

.customer-container {
  display: flex;
  min-height: 100vh;
}

/* Main content area */
.main-content {
  flex: 1;
  margin-left: 250px;
  padding: 0;
  transition: margin 0.3s ease;
  background-color: #f8fafc;
}

/* Top navigation */
.top-nav {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 30px;
  background: linear-gradient(to right, #fff, #f8fafc);
  border-bottom: 1px solid #eaeaea;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.top-nav h1 {
  margin: 0;
  color: #2c3e50;
  font-size: 24px;
  font-weight: 600;
}

.user-menu {
  display: flex;
  align-items: center;
  gap: 15px;
}

.user-menu span {
  font-weight: 500;
  color: #2c3e50;
}

.logout-btn {
  background: linear-gradient(to right, #ff7e5f, #feb47b);
  color: white;
  border: none;
  border-radius: 5px;
  padding: 8px 15px;
  font-size: 14px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 8px;
  transition: all 0.2s ease;
}

.logout-btn:hover {
  background: linear-gradient(to right, #fc6b4f, #fea36d);
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(255, 126, 95, 0.2);
}

/* Dashboard content */
.dashboard-content {
  padding: 30px;
}

/* Quick actions grid */
.quick-actions-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: 25px;
  margin-bottom: 30px;
}

.action-card {
  background: white;
  border-radius: 10px;
  padding: 25px;
  text-align: center;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease;
  cursor: pointer;
  border-top: 4px solid transparent;
}

.action-card:nth-child(1) {
  border-top-color: #4a90e2;
}

.action-card:nth-child(2) {
  border-top-color: #50c878;
}

.action-card:nth-child(3) {
  border-top-color: #e67e22;
}

.action-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
}

.action-card i {
  font-size: 36px;
  margin-bottom: 15px;
  color: #2c3e50;
  background: linear-gradient(135deg, #f6f9fc, #eef2f7);
  width: 70px;
  height: 70px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  margin: 0 auto 15px auto;
}

.action-card:nth-child(1) i {
  color: #4a90e2;
}

.action-card:nth-child(2) i {
  color: #50c878;
}

.action-card:nth-child(3) i {
  color: #e67e22;
}

.action-card h3 {
  margin: 0 0 10px 0;
  color: #2c3e50;
  font-size: 18px;
}

.action-card p {
  margin: 0;
  color: #7f8c8d;
  font-size: 14px;
}

/* Section cards */
.section-card {
  background: white;
  border-radius: 10px;
  padding: 25px;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
  margin-bottom: 30px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding-bottom: 15px;
  border-bottom: 1px solid #eaeaea;
}

.section-header h2 {
  margin: 0;
  color: #2c3e50;
  font-size: 20px;
}

.view-all {
  color: #4a90e2;
  text-decoration: none;
  font-size: 14px;
  font-weight: 500;
  transition: color 0.2s ease;
}

.view-all:hover {
  color: #2e86de;
  text-decoration: underline;
}

/* Recent bookings */
.recent-bookings {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.booking-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px;
  border-radius: 8px;
  background: linear-gradient(to right, #f9fafc, #f5f7fa);
  border-left: 4px solid #e0e0e0;
  transition: all 0.2s ease;
}

.booking-item:hover {
  background: linear-gradient(to right, #f5f7fa, #eef2f7);
  transform: translateX(5px);
}

.booking-info h4 {
  margin: 0 0 8px 0;
  color: #2c3e50;
  font-size: 16px;
}

.booking-info p {
  margin: 5px 0;
  color: #7f8c8d;
  font-size: 14px;
}

.booking-info i {
  margin-right: 8px;
  width: 16px;
  text-align: center;
}

.booking-status .status {
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 600;
  text-transform: uppercase;
}

.status.pending {
  background-color: #ffeaa7;
  color: #d35400;
}

.status.confirmed {
  background-color: #d1f8d1;
  color: #27ae60;
}

.status.cancelled {
  background-color: #ffd3d3;
  color: #c0392b;
}

.status.completed {
  background-color: #cce5ff;
  color: #2980b9;
}

/* Statistics grid */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 20px;
}

.stat-card {
  background: white;
  border-radius: 10px;
  padding: 20px;
  display: flex;
  align-items: center;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
}

.stat-card i {
  font-size: 24px;
  color: #4a90e2;
  background: linear-gradient(135deg, #f6f9fc, #eef2f7);
  width: 50px;
  height: 50px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  margin-right: 15px;
}

.stat-info h4 {
  margin: 0 0 5px 0;
  color: #7f8c8d;
  font-size: 14px;
  font-weight: 500;
}

.stat-info .stat-number {
  margin: 0;
  color: #2c3e50;
  font-size: 24px;
  font-weight: 600;
}

/* Responsive adjustments */
@media (max-width: 992px) {
  .main-content {
    margin-left: 0;
  }
  
  .top-nav {
    padding: 15px 20px;
  }
  
  .dashboard-content {
    padding: 20px;
  }
  
  .quick-actions-grid {
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 15px;
  }
}

@media (max-width: 768px) {
  .top-nav {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }
  
  .user-menu {
    width: 100%;
    justify-content: space-between;
  }
  
  .booking-item {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }
  
  .booking-status {
    align-self: flex-start;
  }
}

@media (max-width: 576px) {
  .action-card {
    padding: 15px;
  }
  
  .action-card i {
    width: 50px;
    height: 50px;
    font-size: 24px;
  }
  
  .section-card {
    padding: 15px;
  }
  
  .stats-grid {
    grid-template-columns: 1fr;
  }
}
    </style>
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
                    <!-- <div class="action-card" onclick="location.href='profile.jsp'">
                        <i class="fas fa-user"></i>
                        <h3>My Profile</h3>
                        <p>Update personal info</p>
                    </div> -->
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
