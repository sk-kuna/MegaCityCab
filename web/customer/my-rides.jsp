<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="util.DBConnection"%>
<% 
    if (session.getAttribute("userType") == null || !session.getAttribute("userType").equals("CUSTOMER")) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Rides - MegaCity Cab</title>
        <link rel="stylesheet" href="../css/style.css">
        <link rel="stylesheet" href="../css/dashboard.css">
        <link rel="stylesheet" href="../css/my-rides.css">
        <!-- Add QR Code library -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
    </head>
    <body>
        <div class="dashboard-container">
            <h1>My Rides</h1>
            <button onclick="location.href='dashboard.jsp'" class="back-btn">Back to Dashboard</button>
            <div class="rides-container">
                <% 
                    try {
                        int customerId = (int) session.getAttribute("userId");
                        Connection conn = DBConnection.getConnection();
                        String sql = "SELECT * FROM bookings WHERE customer_id = ? ORDER BY booking_time DESC";
                        PreparedStatement stmt = conn.prepareStatement(sql);
                        stmt.setInt(1, customerId);
                        ResultSet rs = stmt.executeQuery();
                        
                        while(rs.next()) {
                %>
                            <div class="ride-card">
                                <div class="ride-header">
                                    <span class="booking-id">Booking #<%= rs.getInt("booking_id") %></span>
                                    <span class="status <%= rs.getString("status").toLowerCase() %>">
                                        <%= rs.getString("status") %>
                                    </span>
                                </div>
                                <div class="ride-details">
                                    <p><strong>From:</strong> <%= rs.getString("pickup_location") %></p>
                                    <p><strong>To:</strong> <%= rs.getString("dropoff_location") %></p>
                                    <p><strong>Vehicle:</strong> <%= rs.getString("vehicle_type") %></p>
                                    <p><strong>Passengers:</strong> <%= rs.getInt("passenger_count") %></p>
                                    <p><strong>Pickup Time:</strong> <%= rs.getTimestamp("pickup_time") %></p>
                                    <p><strong>Booking Time:</strong> <%= rs.getTimestamp("booking_time") %></p>
                                </div>
                                <% if(rs.getString("status").equals("COMPLETED")) { %>
                                    <div class="payment-details">
                                        <div class="amount">
                                            <h4>Total Amount:</h4>
                                            <p>LKR <%= String.format("%.2f", rs.getDouble("total_amount")) %></p>
                                        </div>
                                        <div class="qr-container">
                                            <div id="qrcode-<%= rs.getInt("booking_id") %>"></div>
                                            <button onclick="downloadQR(<%= rs.getInt("booking_id") %>)" class="download-btn">
                                                <i class="fas fa-download"></i> Download QR
                                            </button>
                                        </div>
                                    </div>
                                    <script>
                                        generateQRCode(<%= rs.getInt("booking_id") %>, 
                                                    '<%= rs.getString("pickup_location") %>', 
                                                    '<%= rs.getString("dropoff_location") %>', 
                                                    '<%= rs.getDouble("total_amount") %>',
                                                    '<%= rs.getTimestamp("booking_time") %>');
                                    </script>
                                <% } %>
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
    </body>
</html>
