<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="util.DBConnection"%>
<% 
    if (session.getAttribute("userType") == null || !session.getAttribute("userType").equals("ADMIN")) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Booking Management - MegaCity Cab</title>
        <link rel="stylesheet" href="../css/style.css">
        <link rel="stylesheet" href="../css/admin.css">
        <link rel="stylesheet" href="../css/bookings.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>
    <body>
        <div class="admin-container">
            <!-- Sidebar -->
            <%@ include file="includes/sidebar.jsp" %>

            <!-- Main Content -->
            <div class="main-content">
                <!-- Top Navigation -->
                <%@ include file="includes/topbar.jsp" %>

                <!-- Bookings Content -->
                <div class="bookings-content">
                    <div class="bookings-header">
                        <h2>Booking Management</h2>
                        <div class="booking-filters">
                            <input type="text" id="searchBooking" placeholder="Search bookings...">
                            <select id="statusFilter">
                                <option value="">All Status</option>
                                <option value="PENDING">Pending</option>
                                <option value="CONFIRMED">Confirmed</option>
                                <option value="COMPLETED">Completed</option>
                                <option value="CANCELLED">Cancelled</option>
                            </select>
                            <input type="date" id="dateFilter" placeholder="Filter by date">
                        </div>
                    </div>

                    <!-- Bookings Table -->
                    <div class="bookings-table-container">
                        <table class="bookings-table">
                            <thead>
                                <tr>
                                    <th>Booking ID</th>
                                    <th>Customer</th>
                                    <th>Driver</th>
                                    <th>Vehicle Type</th>
                                    <th>Pickup Location</th>
                                    <th>Dropoff Location</th>
                                    <th>Pickup Time</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody id="bookingsTableBody">
                                <% 
                                    try {
                                        Connection conn = DBConnection.getConnection();
                                        String sql = "SELECT b.*, u.name as customer_name, d.name as driver_name " +
                                                   "FROM bookings b " +
                                                   "LEFT JOIN users u ON b.customer_id = u.user_id " +
                                                   "LEFT JOIN users d ON b.driver_id = d.user_id " +
                                                   "ORDER BY b.booking_time DESC";
                                        Statement stmt = conn.createStatement();
                                        ResultSet rs = stmt.executeQuery(sql);
                                        
                                        while(rs.next()) {
                                %>
                                    <tr data-booking-id="<%= rs.getInt("booking_id") %>">
                                        <td><%= rs.getInt("booking_id") %></td>
                                        <td><%= rs.getString("customer_name") %></td>
                                        <td><%= rs.getString("driver_name") != null ? rs.getString("driver_name") : "Not Assigned" %></td>
                                        <td><%= rs.getString("vehicle_type") %></td>
                                        <td><%= rs.getString("pickup_location") %></td>
                                        <td><%= rs.getString("dropoff_location") %></td>
                                        <td><%= rs.getTimestamp("pickup_time") %></td>
                                        <td>
                                            <span class="status <%= rs.getString("status").toLowerCase() %>">
                                                <%= rs.getString("status") %>
                                            </span>
                                        </td>
                                        <td class="actions">
                                            <button onclick="viewBooking(<%= rs.getInt("booking_id") %>)" class="view-btn">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button onclick="assignDriver(<%= rs.getInt("booking_id") %>)" class="assign-btn">
                                                <i class="fas fa-user-plus"></i>
                                            </button>
                                            <button onclick="updateStatus(<%= rs.getInt("booking_id") %>)" class="status-btn">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                        </td>
                                    </tr>
                                <%
                                        }
                                        rs.close();
                                        stmt.close();
                                        conn.close();
                                    } catch(SQLException e) {
                                        e.printStackTrace();
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- View Booking Modal -->
        <div id="viewModal" class="modal">
            <div class="modal-content">
                <span class="close">&times;</span>
                <h2>Booking Details</h2>
                <div id="bookingDetails"></div>
            </div>
        </div>

        <!-- Assign Driver Modal -->
        <div id="assignModal" class="modal">
            <div class="modal-content">
                <span class="close">&times;</span>
                <h2>Assign Driver</h2>
                <form id="assignForm" action="../BookingServlet" method="POST">
                    <input type="hidden" name="action" value="assign">
                    <input type="hidden" name="bookingId" id="assignBookingId">
                    <div class="form-group">
                        <label>Select Driver</label>
                        <select name="driverId" required>
                            <option value="">Choose a driver...</option>
                            <!-- Will be populated via JavaScript -->
                        </select>
                    </div>
                    <button type="submit" class="submit-btn">Assign Driver</button>
                </form>
            </div>
        </div>

        <!-- Status Update Modal -->
        <div id="statusModal" class="modal">
            <div class="modal-content">
                <span class="close">&times;</span>
                <h2>Update Booking Status</h2>
                <form id="statusForm" action="../BookingServlet" method="POST">
                    <input type="hidden" name="action" value="updateStatus">
                    <input type="hidden" name="bookingId" id="statusBookingId">
                    <div class="form-group">
                        <label>Select Status</label>
                        <select name="status" required>
                            <option value="PENDING">Pending</option>
                            <option value="CONFIRMED">Confirmed</option>
                            <option value="COMPLETED">Completed</option>
                            <option value="CANCELLED">Cancelled</option>
                        </select>
                    </div>
                    <button type="submit" class="submit-btn">Update Status</button>
                </form>
            </div>
        </div>

        <script src="../js/admin.js"></script>
        <script src="../js/bookings.js"></script>
    </body>
</html>
