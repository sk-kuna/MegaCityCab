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
        <title>Driver Management - MegaCity Cab</title>
        <link rel="stylesheet" href="../css/style.css">
        <link rel="stylesheet" href="../css/admin.css">
        <link rel="stylesheet" href="../css/drivers.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>
    <body>
        <div class="admin-container">
            <%@ include file="includes/sidebar.jsp" %>
            <div class="main-content">
                <%@ include file="includes/topbar.jsp" %>
                
                <div class="drivers-content">
                    <div class="drivers-header">
                        <h2>Driver Management</h2>
                        <button class="add-driver-btn" onclick="showAddDriverForm()">
                            <i class="fas fa-plus"></i> Add New Driver
                        </button>
                    </div>

                    <div class="driver-filters">
                        <input type="text" id="searchDriver" placeholder="Search drivers...">
                        <select id="statusFilter">
                            <option value="">All Status</option>
                            <option value="ONLINE">Online</option>
                            <option value="OFFLINE">Offline</option>
                            <option value="BUSY">Busy</option>
                        </select>
                    </div>

                    <div class="drivers-table-container">
                        <table class="drivers-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Driver Name</th>
                                    <th>License Number</th>
                                    <th>Experience (Years)</th>
                                    <th>Rating</th>
                                    <th>Status</th>
                                    <th>Contact</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    try {
                                        Connection conn = DBConnection.getConnection();
                                        String sql = "SELECT u.*, d.* FROM users u " +
                                                    "JOIN driver_details d ON u.user_id = d.driver_id " +
                                                    "WHERE u.user_type = 'DRIVER' ORDER BY u.user_id";
                                        Statement stmt = conn.createStatement();
                                        ResultSet rs = stmt.executeQuery(sql);
                                        
                                        while(rs.next()) {
                                %>
                                    <tr>
                                        <td><%= rs.getInt("user_id") %></td>
                                        <td><%= rs.getString("name") %></td>
                                        <td><%= rs.getString("license_number") %></td>
                                        <td><%= rs.getInt("experience_years") %></td>
                                        <td>
                                            <div class="rating">
                                                <%= String.format("%.1f", rs.getDouble("rating")) %>
                                                <i class="fas fa-star"></i>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="status <%= rs.getString("status").toLowerCase() %>">
                                                <%= rs.getString("status") %>
                                            </span>
                                        </td>
                                        <td>
                                            <div class="contact-info">
                                                <div><%= rs.getString("phone") %></div>
                                                <div><%= rs.getString("email") %></div>
                                            </div>
                                        </td>
                                        <td class="actions">
                                            <button onclick="editDriver(<%= rs.getInt("user_id") %>)" class="edit-btn">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button onclick="viewPerformance(<%= rs.getInt("user_id") %>)" class="view-btn">
                                                <i class="fas fa-chart-line"></i>
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

        <!-- Add/Edit Driver Modal -->
        <div id="driverModal" class="modal">
            <div class="modal-content">
                <span class="close">&times;</span>
                <h2 id="modalTitle">Add New Driver</h2>
                <form id="driverForm" action="../DriverServlet" method="POST">
                    <input type="hidden" name="action" id="formAction" value="add">
                    <input type="hidden" name="driverId" id="driverId">
                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" name="name" required>
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" name="email" required>
                    </div>
                    <div class="form-group">
                        <label>Phone</label>
                        <input type="tel" name="phone" required pattern="[0-9]{10}">
                    </div>
                    <div class="form-group">
                        <label>License Number</label>
                        <input type="text" name="licenseNumber" required>
                    </div>
                    <div class="form-group">
                        <label>Experience (Years)</label>
                        <input type="number" name="experience" min="0" required>
                    </div>
                    <div class="form-group">
                        <label>Initial Status</label>
                        <select name="status" required>
                            <option value="OFFLINE">Offline</option>
                            <option value="ONLINE">Online</option>
                        </select>
                    </div>
                    <button type="submit" class="submit-btn">Save Driver</button>
                </form>
            </div>
        </div>

        <script src="../js/admin.js"></script>
        <script src="../js/drivers.js"></script>
    </body>
</html>
