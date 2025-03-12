<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="util.DBConnection"%>
<% 
    if (session.getAttribute("userType") == null || !session.getAttribute("userType").equals("DRIVER")) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    int driverId = (int) session.getAttribute("userId");
    Connection conn = DBConnection.getConnection();
    
    // Fetch driver stats
    PreparedStatement stmt = conn.prepareStatement(
        "SELECT status FROM driver_details WHERE driver_id = ?"
    );
    stmt.setInt(1, driverId);
    ResultSet driverRs = stmt.executeQuery();
    String driverStatus = driverRs.next() ? driverRs.getString("status") : "OFFLINE";
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Driver Dashboard - MegaCity Cab</title>
        <!-- <link rel="stylesheet" href="../css/style.css">
        <link rel="stylesheet" href="../css/driver.css"> -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

        <style>
            /* General Styles */
body {
    font-family: 'Poppins', sans-serif;
    margin: 0;
    padding: 0;
    display: flex;
    height: 100vh;
    background: linear-gradient(135deg, #1e3c72, #2a5298);
}

/* Main Container */
.driver-container {
    display: flex;
    width: 100%;
}

/* Main Content */
.main-content {
    flex: 1;
    padding: 20px;
    color: white;
}

/* Dashboard Content */
.dashboard-content {
    display: flex;
    flex-direction: column;
    gap: 20px;
}

/* Status Toggle */
.status-toggle {
    display: flex;
    align-items: center;
    gap: 15px;
    padding: 15px;
    border-radius: 10px;
    background: linear-gradient(45deg, #00c6ff, #007bff);
    box-shadow: 0px 5px 15px rgba(255, 255, 255, 0.2);
    font-weight: bold;
    font-size: 18px;
}

/* Toggle Switch */
.toggle-switch {
    position: relative;
    width: 50px;
    height: 24px;
}

.toggle-switch input {
    display: none;
}

.slider {
    position: absolute;
    cursor: pointer;
    width: 100%;
    height: 100%;
    background: #ccc;
    border-radius: 50px;
    transition: 0.4s;
}

.slider:before {
    content: "";
    position: absolute;
    width: 20px;
    height: 20px;
    left: 2px;
    bottom: 2px;
    background: white;
    border-radius: 50%;
    transition: 0.4s;
}

input:checked + .slider {
    background: #28a745;
}

input:checked + .slider:before {
    transform: translateX(26px);
}

/* Stats Grid */
.stats-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 20px;
}

/* Stat Card */
.stat-card {
    display: flex;
    align-items: center;
    padding: 15px;
    background: linear-gradient(180deg, #ff9a9e, #fad0c4);
    border-radius: 10px;
    box-shadow: 0px 5px 15px rgba(255, 255, 255, 0.2);
}

.stat-icon {
    font-size: 30px;
    margin-right: 15px;
}

.stat-info {
    display: flex;
    flex-direction: column;
}

.stat-info h3 {
    font-size: 18px;
    margin: 0;
}

.stat-number {
    font-size: 22px;
    font-weight: bold;
}

/* Active Ride Section */
.active-ride-card {
    background: linear-gradient(90deg, #fbc2eb, #a6c1ee);
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0px 5px 15px rgba(255, 255, 255, 0.2);
}

.ride-details p {
    font-size: 16px;
    margin: 5px 0;
}

/* Ride Actions */
.ride-actions {
    display: flex;
    gap: 10px;
    margin-top: 10px;
}

.action-btn {
    padding: 10px 15px;
    font-size: 14px;
    font-weight: bold;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    transition: 0.3s;
}

.accept-btn {
    background: #28a745;
    color: white;
}

.reject-btn {
    background: #dc3545;
    color: white;
}

.action-btn:hover {
    transform: scale(1.05);
}

/* Earnings Section */
.earnings-section {
    padding: 15px;
    background: linear-gradient(180deg, #ffecd2, #fcb69f);
    border-radius: 10px;
    box-shadow: 0px 5px 15px rgba(255, 255, 255, 0.2);
}

.earnings-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.view-all {
    text-decoration: none;
    color: white;
    background: #007bff;
    padding: 5px 10px;
    border-radius: 5px;
    font-weight: bold;
    transition: 0.3s;
}

.view-all:hover {
    background: #0056b3;
}

        </style>
    </head>
    <body>
        <div class="driver-container">
            <%@ include file="includes/sidebar.jsp" %>
            
            <div class="main-content">
                <div class="dashboard-content">
                    <!-- Status Toggle -->
                    <div class="status-toggle">
                        <h3>Driver Status</h3>
                        <label class="toggle-switch">
                            <input type="checkbox" id="statusToggle" <%= driverStatus.equals("ONLINE") ? "checked" : "" %>>
                            <span class="slider round"></span>
                        </label>
                        <span id="statusText"><%= driverStatus %></span>
                    </div>

                    <!-- Stats Overview -->
                    <div class="stats-grid">
                        <div class="stat-card">
                            <i class="fas fa-route stat-icon"></i>
                            <div class="stat-info">
                                <h3>Today's Trips</h3>
                                <p class="stat-number">
                                    <% 
                                        PreparedStatement tripStmt = conn.prepareStatement(
                                            "SELECT COUNT(*) as trips FROM bookings WHERE driver_id = ? " +
                                            "AND DATE(booking_time) = CURDATE()"
                                        );
                                        tripStmt.setInt(1, driverId);
                                        ResultSet tripRs = tripStmt.executeQuery();
                                        tripRs.next();
                                    %>
                                    <%= tripRs.getInt("trips") %>
                                </p>
                            </div>
                        </div>
                        <div class="stat-card">
                            <i class="fas fa-money-bill-wave stat-icon"></i>
                            <div class="stat-info">
                                <h3>Today's Earnings</h3>
                                <p class="stat-number">
                                    <% 
                                        PreparedStatement earnStmt = conn.prepareStatement(
                                            "SELECT COALESCE(SUM(p.total_amount), 0) as earnings " +
                                            "FROM bookings b " +
                                            "JOIN payments p ON b.booking_id = p.booking_id " +
                                            "WHERE b.driver_id = ? AND DATE(b.booking_time) = CURDATE()"
                                        );
                                        earnStmt.setInt(1, driverId);
                                        ResultSet earnRs = earnStmt.executeQuery();
                                        earnRs.next();
                                    %>
                                    LKR <%= String.format("%.2f", earnRs.getDouble("earnings")) %>
                                </p>
                            </div>
                        </div>
                        <div class="stat-card">
                            <i class="fas fa-star stat-icon"></i>
                            <div class="stat-info">
                                <h3>Rating</h3>
                                <p class="stat-number">
                                    <% 
                                        PreparedStatement ratingStmt = conn.prepareStatement(
                                            "SELECT rating FROM driver_details WHERE driver_id = ?"
                                        );
                                        ratingStmt.setInt(1, driverId);
                                        ResultSet ratingRs = ratingStmt.executeQuery();
                                        ratingRs.next();
                                    %>
                                    <%= String.format("%.1f", ratingRs.getDouble("rating")) %>
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Active Ride Section -->
                    <div class="active-ride-card">
                        <h3>Current/Next Ride</h3>
                        <% 
                            PreparedStatement activeStmt = conn.prepareStatement(
                                "SELECT b.*, u.name as customer_name " +
                                "FROM bookings b " +
                                "JOIN users u ON b.customer_id = u.user_id " +
                                "WHERE b.driver_id = ? AND b.status IN ('CONFIRMED', 'ONGOING') " +
                                "ORDER BY b.booking_time DESC LIMIT 1"
                            );
                            activeStmt.setInt(1, driverId);
                            ResultSet activeRs = activeStmt.executeQuery();
                            
                            if(activeRs.next()) {
                        %>
                            <div class="ride-details">
                                <p><strong>Customer:</strong> <%= activeRs.getString("customer_name") %></p>
                                <p><strong>Pickup:</strong> <%= activeRs.getString("pickup_location") %></p>
                                <p><strong>Dropoff:</strong> <%= activeRs.getString("dropoff_location") %></p>
                                <p><strong>Status:</strong> <%= activeRs.getString("status") %></p>
                                <div class="ride-actions">
                                    <button class="action-btn accept-btn" onclick="startRide(<%= activeRs.getInt("booking_id") %>)">
                                        Start Ride
                                    </button>
                                    <button class="action-btn reject-btn" onclick="cancelRide(<%= activeRs.getInt("booking_id") %>)">
                                        Cancel
                                    </button>
                                </div>
                            </div>
                        <% } else { %>
                            <p class="no-rides">No active rides at the moment.</p>
                        <% } %>
                    </div>

                    <!-- Recent Earnings -->
                    <div class="earnings-section">
                        <div class="earnings-header">
                            <h3>Recent Earnings</h3>
                            <a href="earnings.jsp" class="view-all">View All</a>
                        </div>
                        <table class="earnings-table">
                            <!-- Add your earnings table here -->
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <script src="../js/driver.js"></script>
    </body>
</html>
<%
    // Close all database resources
    conn.close();
%>
