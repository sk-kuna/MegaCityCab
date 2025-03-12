<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="util.DBConnection"%>
<% 
    if (session.getAttribute("userType") == null || !session.getAttribute("userType").equals("ADMIN")) {
        response.sendRedirect("../login.jsp");
        return;
    }

    // Fetch dashboard statistics
    Connection conn = DBConnection.getConnection();
    int totalUsers = 0;
    int activeBookings = 0;
    int availableVehicles = 0;
    double todayRevenue = 0.0;
    int pendingBookings = 0;
    double totalRevenue = 0.0;
    int totalCompletedRides = 0;
    
    try {
        // Get total users
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) as count FROM users WHERE user_type = 'CUSTOMER'");
        if(rs.next()) totalUsers = rs.getInt("count");
        
        // Get active bookings
        rs = stmt.executeQuery("SELECT COUNT(*) as count FROM bookings WHERE status = 'CONFIRMED'");
        if(rs.next()) activeBookings = rs.getInt("count");
        
        // Get available vehicles
        rs = stmt.executeQuery("SELECT COUNT(*) as count FROM vehicles WHERE status = 'AVAILABLE'");
        if(rs.next()) availableVehicles = rs.getInt("count");
        
        // Get today's revenue
        rs = stmt.executeQuery("SELECT COALESCE(SUM(total_amount), 0) as revenue FROM payments WHERE DATE(payment_date) = CURDATE() AND payment_status = 'COMPLETED'");
        if(rs.next()) todayRevenue = rs.getDouble("revenue");
        
        // Get pending bookings
        rs = stmt.executeQuery("SELECT COUNT(*) as count FROM bookings WHERE status = 'PENDING'");
        if(rs.next()) pendingBookings = rs.getInt("count");
        
        // Get total completed rides
        rs = stmt.executeQuery("SELECT COUNT(*) as count FROM bookings WHERE status = 'COMPLETED'");
        if(rs.next()) totalCompletedRides = rs.getInt("count");
        
        rs.close();
        stmt.close();
        conn.close();
    } catch(SQLException e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Admin Dashboard - MegaCity Cab</title>
    <!-- <link rel="stylesheet" href="../css/style.css" /> -->
    <link rel="stylesheet" href="../css/admin.css" />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
    />
  </head>
  <body>
    <div class="admin-container">
      <!-- Sidebar -->
      <%@ include file="includes/sidebar.jsp" %>

      <!-- Main Content -->
      <div class="main-content">
        <!-- Top Navigation -->
        <%@ include file="includes/topbar.jsp" %>

        <!-- Dashboard Content -->
        <div class="dashboard-content">
          <!-- Stats Cards -->
          <div class="stats-container">
            <div class="stat-card">
              <i class="fas fa-users stat-icon"></i>
              <div class="stat-info">
                <h3>Total Users</h3>
                <p class="stat-number"><%= totalUsers %></p>
              </div>
            </div>
            <div class="stat-card">
              <i class="fas fa-taxi stat-icon"></i>
              <div class="stat-info">
                <h3>Active Bookings</h3>
                <p class="stat-number"><%= activeBookings %></p>
              </div>
            </div>
            <div class="stat-card">
              <i class="fas fa-car stat-icon"></i>
              <div class="stat-info">
                <h3>Available Vehicles</h3>
                <p class="stat-number"><%= availableVehicles %></p>
              </div>
            </div>
            <div class="stat-card">
              <i class="fas fa-money-bill-wave stat-icon"></i>
              <div class="stat-info">
                <h3>Today's Revenue</h3>
                <p class="stat-number">LKR <%= String.format("%.2f", todayRevenue) %></p>
              </div>
            </div>
          </div>

          <!-- Recent Bookings Section -->
          <div class="dashboard-section">
            <div class="section-header">
              <h3>Recent Bookings</h3>
              <a href="bookings.jsp" class="view-all-btn">View All</a>
            </div>
            <div class="recent-bookings-table">
              <table>
                <thead>
                  <tr>
                    <th>Booking ID</th>
                    <th>Customer</th>
                    <th>Pickup Location</th>
                    <th>Status</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <% 
                    try {
                      conn = DBConnection.getConnection();
                      PreparedStatement pstmt = conn.prepareStatement(
                        "SELECT b.*, u.name as customer_name " +
                        "FROM bookings b " +
                        "JOIN users u ON b.customer_id = u.user_id " +
                        "ORDER BY b.booking_time DESC LIMIT 5"
                      );
                      ResultSet rs = pstmt.executeQuery();
                      while(rs.next()) {
                  %>
                  <tr>
                    <td><%= rs.getInt("booking_id") %></td>
                    <td><%= rs.getString("customer_name") %></td>
                    <td><%= rs.getString("pickup_location") %></td>
                    <td><span class="status <%= rs.getString("status").toLowerCase() %>">
                      <%= rs.getString("status") %>
                    </span></td>
                    <td>
                      <a href="bookings.jsp?id=<%= rs.getInt("booking_id") %>" class="action-btn">
                        <i class="fas fa-eye"></i>
                      </a>
                    </td>
                  </tr>
                  <%
                      }
                      rs.close();
                      pstmt.close();
                      conn.close();
                    } catch(SQLException e) {
                      e.printStackTrace();
                    }
                  %>
                </tbody>
              </table>
            </div>
          </div>

          <!-- Quick Actions Section -->
          <div class="quick-actions-section">
            <div class="section-header">
              <h3>Quick Actions</h3>
            </div>
            <div class="quick-actions-grid">
              <a href="drivers.jsp" class="quick-action-card">
                <i class="fas fa-id-card"></i>
                <span>Add New Driver</span>
              </a>
              <a href="vehicles.jsp" class="quick-action-card">
                <i class="fas fa-car"></i>
                <span>Add New Vehicle</span>
              </a>
              <a href="reports.jsp" class="quick-action-card">
                <i class="fas fa-chart-bar"></i>
                <span>Generate Report</span>
              </a>
              <a href="bookings.jsp?status=pending" class="quick-action-card">
                <i class="fas fa-clock"></i>
                <span>Pending Bookings (<%= pendingBookings %>)</span>
              </a>
            </div>
          </div>

          <!-- Summary Stats -->
          <div class="summary-stats">
            <div class="stat-card large">
              <i class="fas fa-route stat-icon"></i>
              <div class="stat-info">
                <h3>Total Completed Rides</h3>
                <p class="stat-number"><%= totalCompletedRides %></p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <script src="../js/admin.js"></script>
  </body>
</html>
