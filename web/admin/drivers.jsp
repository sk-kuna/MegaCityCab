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
                        <button type="button" onclick="openDriverModal()" class="add-driver-btn">
                            <i class="fas fa-plus"></i> Add New Driver
                        </button>
                    </div>

                    <div class="driver-filters">
                        <input type="text" id="searchInput" onkeyup="filterTable()" placeholder="Search by name...">
                    </div>

                    <div class="drivers-table-container">
                        <table id="driversTable" class="drivers-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Driver Name</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    try {
                                        Connection conn = DBConnection.getConnection();
                                        String sql = "SELECT * FROM users WHERE user_type = 'DRIVER' ORDER BY user_id";
                                        Statement stmt = conn.createStatement();
                                        ResultSet rs = stmt.executeQuery(sql);
                                        
                                        while(rs.next()) {
                                %>
                                    <tr>
                                        <td><%= rs.getInt("user_id") %></td>
                                        <td><%= rs.getString("name") %></td>
                                        <td><%= rs.getString("email") %></td>
                                        <td><%= rs.getString("phone") != null ? rs.getString("phone") : "N/A" %></td>
                                        <td class="actions">
                                            <button type="button" onclick="editDriver(<%= rs.getInt("user_id") %>)" class="btn edit-btn">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button type="button" onclick="confirmDelete(<%= rs.getInt("user_id") %>)" class="btn delete-btn">
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
                                        out.println("<tr><td colspan='5' class='error'>Error: " + e.getMessage() + "</td></tr>");
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Driver Modal -->
        <div id="driverModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 id="modalTitle">Add New Driver</h2>
                    <span class="close" onclick="closeModal()">&times;</span>
                </div>
                <form id="driverForm">
                    <input type="hidden" name="action" id="formAction" value="add">
                    <input type="hidden" name="driverId" id="driverId" value="">
                    
                    <div class="form-group">
                        <label for="name">Full Name</label>
                        <input type="text" id="name" name="name" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input type="tel" id="phone" name="phone" pattern="[0-9]{10}" required>
                    </div>
                    
                    <div class="form-buttons">
                        <button type="submit" class="btn save-btn">Save</button>
                        <button type="button" class="btn cancel-btn" onclick="closeModal()">Cancel</button>
                    </div>
                </form>
            </div>
        </div>

        <script src="../js/drivers.js"></script>
    </body>
</html>
