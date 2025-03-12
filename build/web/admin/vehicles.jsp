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
        <title>Vehicle Management - MegaCity Cab</title>
        <link rel="stylesheet" href="../css/style.css">
        <link rel="stylesheet" href="../css/admin.css">
        <link rel="stylesheet" href="../css/vehicles.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>
    <body>
        <div class="admin-container">
            <%@ include file="includes/sidebar.jsp" %>
            <div class="main-content">
                <%@ include file="includes/topbar.jsp" %>
                
                <div class="vehicles-content">
                    <div class="vehicles-header">
                        <h2>Vehicle Management</h2>
                        <button onclick="showAddVehicleForm()" class="add-vehicle-btn">
                            <i class="fas fa-plus"></i> Add New Vehicle
                        </button>
                    </div>

                    <div class="vehicle-filters">
                        <input type="text" id="searchVehicle" placeholder="Search vehicles...">
                        <select id="statusFilter">
                            <option value="">All Status</option>
                            <option value="AVAILABLE">Available</option>
                            <option value="IN_USE">In Use</option>
                            <option value="MAINTENANCE">Maintenance</option>
                        </select>
                    </div>

                    <div class="vehicles-table-container">
                        <table class="vehicles-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Registration</th>
                                    <th>Model</th>
                                    <th>Capacity</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    try {
                                        Connection conn = DBConnection.getConnection();
                                        String sql = "SELECT * FROM vehicles ORDER BY vehicle_id";
                                        Statement stmt = conn.createStatement();
                                        ResultSet rs = stmt.executeQuery(sql);
                                        
                                        while(rs.next()) {
                                %>
                                    <tr data-vehicle-id="<%= rs.getInt("vehicle_id") %>">
                                        <td><%= rs.getInt("vehicle_id") %></td>
                                        <td><%= rs.getString("registration_number") %></td>
                                        <td><%= rs.getString("model") %></td>
                                        <td><%= rs.getInt("capacity") %></td>
                                        <td>
                                            <span class="status <%= rs.getString("status").toLowerCase() %>">
                                                <%= rs.getString("status") %>
                                            </span>
                                        </td>
                                        <td class="actions">
                                            <button onclick="editVehicle(<%= rs.getInt("vehicle_id") %>)" class="edit-btn">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button onclick="deleteVehicle(<%= rs.getInt("vehicle_id") %>)" class="delete-btn">
                                                <i class="fas fa-trash"></i>
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

        <!-- Add/Edit Vehicle Modal -->
        <div id="vehicleModal" class="modal">
            <div class="modal-content">
                <span class="close">&times;</span>
                <h2 id="modalTitle">Add New Vehicle</h2>
                <form id="vehicleForm" action="../VehicleServlet" method="POST">
                    <input type="hidden" name="action" id="formAction" value="add">
                    <input type="hidden" name="vehicleId" id="vehicleId">
                    
                    <div class="form-group">
                        <label>Registration Number</label>
                        <input type="text" name="registrationNumber" required>
                    </div>
                    <div class="form-group">
                        <label>Model</label>
                        <input type="text" name="model" required>
                    </div>
                    <div class="form-group">
                        <label>Capacity</label>
                        <input type="number" name="capacity" min="1" required>
                    </div>
                    <div class="form-group">
                        <label>Status</label>
                        <select name="status" required>
                            <option value="AVAILABLE">Available</option>
                            <option value="IN_USE">In Use</option>
                            <option value="MAINTENANCE">Maintenance</option>
                        </select>
                    </div>
                    <button type="submit" class="submit-btn">Save Vehicle</button>
                </form>
            </div>
        </div>

        <script src="../js/admin.js"></script>
        <script src="../js/vehicles.js"></script>
    </body>
</html>
