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
        <!-- <link rel="stylesheet" href="../css/style.css">
        <link rel="stylesheet" href="../css/dashboard.css">
        <link rel="stylesheet" href="../css/my-rides.css"> -->
        <!-- Add QR Code library -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
        <style>
            /* My Rides Page Styling */
body {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  margin: 0;
  padding: 0;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4efe9 100%);
  color: #333;
  min-height: 100vh;
}

.dashboard-container {
  max-width: 1200px;
  margin: 40px auto;
  padding: 30px;
  background-color: white;
  border-radius: 12px;
  box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
}

h1 {
  color: #2c3e50;
  margin: 0 0 20px 0;
  padding-bottom: 15px;
  border-bottom: 2px solid #eaeaea;
  font-size: 28px;
}

.back-btn {
  background: linear-gradient(to right, #4a90e2, #5ca9fb);
  color: white;
  border: none;
  border-radius: 5px;
  padding: 10px 20px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  margin-bottom: 25px;
  transition: all 0.2s ease;
}

.back-btn:hover {
  background: linear-gradient(to right, #3a80d2, #4c99eb);
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(74, 144, 226, 0.3);
}

.back-btn::before {
  content: "←";
  margin-right: 8px;
}

.rides-container {
  display: flex;
  flex-direction: column;
  gap: 25px;
}

.ride-card {
  background: white;
  border-radius: 10px;
  overflow: hidden;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  border-left: 5px solid #ddd;
}

.ride-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
}

/* Different border colors based on status */
.ride-card .status.pending ~ .ride-details,
.ride-card .status.pending ~ .payment-details {
  border-left-color: #f39c12;
}

.ride-card .status.confirmed ~ .ride-details,
.ride-card .status.confirmed ~ .payment-details {
  border-left-color: #2ecc71;
}

.ride-card .status.cancelled ~ .ride-details,
.ride-card .status.cancelled ~ .payment-details {
  border-left-color: #e74c3c;
}

.ride-card .status.completed ~ .ride-details,
.ride-card .status.completed ~ .payment-details {
  border-left-color: #3498db;
}

.ride-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 20px;
  background: linear-gradient(to right, #f8f9fa, #f2f3f4);
  border-bottom: 1px solid #eaeaea;
}

.booking-id {
  font-weight: 600;
  color: #2c3e50;
  font-size: 16px;
}

.status {
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

.ride-details {
  padding: 20px;
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 15px 30px;
}

.ride-details p {
  margin: 0;
  font-size: 14px;
  color: #444;
  line-height: 1.6;
}

.ride-details strong {
  color: #2c3e50;
  font-weight: 600;
}

.payment-details {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-top: 1px solid #eaeaea;
  background: linear-gradient(to right, #f9fafc, #f5f7fa);
}

.amount h4 {
  margin: 0 0 5px 0;
  color: #2c3e50;
  font-size: 16px;
}

.amount p {
  margin: 0;
  font-size: 22px;
  font-weight: 700;
  color: #2ecc71;
}

.qr-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
}

#qrcode-canvas {
  margin: 0 auto;
}

.download-btn {
  background: linear-gradient(to right, #ff7e5f, #feb47b);
  color: white;
  border: none;
  border-radius: 5px;
  padding: 8px 15px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 8px;
  transition: all 0.2s ease;
}

.download-btn:hover {
  background: linear-gradient(to right, #fc6b4f, #fea36d);
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(255, 126, 95, 0.2);
}

/* QR Code styling */
[id^="qrcode-"] {
  padding: 10px;
  background-color: white;
  border-radius: 5px;
  border: 1px solid #eaeaea;
  box-shadow: 0 3px 6px rgba(0, 0, 0, 0.05);
}

/* Add this JavaScript to complement the CSS */
function generateQRCode(bookingId, pickup, dropoff, amount, bookingTime) {
  const qrContainer = document.getElementById(`qrcode-${bookingId}`);
  
  // Clear existing content
  qrContainer.innerHTML = '';
  
  // Create QR code
  const qrcode = new QRCode(qrContainer, {
    text: `Booking #${bookingId}\nFrom: ${pickup}\nTo: ${dropoff}\nAmount: LKR ${amount}\nTime: ${bookingTime}`,
    width: 120,
    height: 120,
    colorDark: "#2c3e50",
    colorLight: "#ffffff",
    correctLevel: QRCode.CorrectLevel.H
  });
}

function downloadQR(bookingId) {
  const canvas = document.querySelector(`#qrcode-${bookingId} canvas`);
  if (canvas) {
    const image = canvas.toDataURL("image/png");
    const link = document.createElement('a');
    link.download = `megacity-cab-booking-${bookingId}.png`;
    link.href = image;
    link.click();
  }
}

/* Responsive adjustments */
@media (max-width: 992px) {
  .dashboard-container {
    margin: 20px;
    padding: 20px;
  }
  
  .ride-details {
    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
  }
}

@media (max-width: 768px) {
  .payment-details {
    flex-direction: column;
    gap: 20px;
    text-align: center;
  }
  
  .qr-container {
    width: 100%;
  }
}

@media (max-width: 576px) {
  .dashboard-container {
    margin: 10px;
    padding: 15px;
  }
  
  .ride-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }
  
  .status {
    align-self: flex-start;
  }
  
  .ride-details {
    grid-template-columns: 1fr;
  }
}
        </style>
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
