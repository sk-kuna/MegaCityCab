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
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                margin: 0;
                padding: 0;
                background: #f5f7fa;
                color: #333;
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
            }

            .back-btn {
                background: #4a90e2;
                color: white;
                border: none;
                border-radius: 5px;
                padding: 10px 20px;
                cursor: pointer;
                margin-bottom: 25px;
            }

            .rides-container {
                display: flex;
                flex-direction: column;
                gap: 20px;
            }

            .ride-card {
                background: white;
                border-radius: 10px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                overflow: hidden;
            }

            .ride-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 15px 20px;
                background: #f8f9fa;
                border-bottom: 1px solid #eaeaea;
            }

            .booking-id {
                font-weight: 600;
                color: #2c3e50;
            }

            .status {
                padding: 5px 10px;
                border-radius: 15px;
                font-size: 12px;
                font-weight: 600;
                text-transform: uppercase;
            }

            .status.pending { background: #ffeaa7; color: #d35400; }
            .status.confirmed { background: #d1f8d1; color: #27ae60; }
            .status.cancelled { background: #ffd3d3; color: #c0392b; }
            .status.completed { background: #cce5ff; color: #2980b9; }

            .ride-details {
                padding: 20px;
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 15px;
            }

            .ride-details p {
                margin: 5px 0;
                font-size: 14px;
            }

            .ride-details strong {
                color: #2c3e50;
                font-weight: 600;
            }

            .amount {
                padding: 15px 20px;
                background: #f8f9fa;
                border-top: 1px solid #eaeaea;
                text-align: right;
            }

            .amount p {
                margin: 0;
                font-size: 18px;
                font-weight: 700;
                color: #2ecc71;
            }

            @media (max-width: 768px) {
                .dashboard-container {
                    margin: 20px;
                    padding: 15px;
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
                                    <div class="amount">
                                        <p>Total Amount: LKR <%= String.format("%.2f", rs.getDouble("estimated_price")) %></p>
                                    </div>
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
