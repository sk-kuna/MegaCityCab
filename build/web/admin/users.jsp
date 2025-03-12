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
        <title>User Management - MegaCity Cab</title>
        <link rel="stylesheet" href="../css/style.css">
        <link rel="stylesheet" href="../css/admin.css">
        <link rel="stylesheet" href="../css/users.css">
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

                <!-- Users Content -->
                <div class="users-content">
                    <div class="users-header">
                        <h2>User Management</h2>
                        <button class="add-user-btn" onclick="showAddUserForm()">
                            <i class="fas fa-plus"></i> Add New User
                        </button>
                    </div>

                    <!-- User Search & Filter -->
                    <div class="user-filters">
                        <input type="text" id="searchUser" placeholder="Search users...">
                        <select id="userTypeFilter">
                            <option value="">All Types</option>
                            <option value="CUSTOMER">Customers</option>
                            <option value="DRIVER">Drivers</option>
                            <option value="ADMIN">Admins</option>
                        </select>
                    </div>

                    <!-- Users Table -->
                    <div class="users-table-container">
                        <table class="users-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Username</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Type</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody id="usersTableBody">
                                <% 
                                    try {
                                        Connection conn = DBConnection.getConnection();
                                        String sql = "SELECT * FROM users ORDER BY user_id";
                                        Statement stmt = conn.createStatement();
                                        ResultSet rs = stmt.executeQuery(sql);
                                        
                                        while(rs.next()) {
                                %>
                                    <tr>
                                        <td><%= rs.getInt("user_id") %></td>
                                        <td><%= rs.getString("username") %></td>
                                        <td><%= rs.getString("name") %></td>
                                        <td><%= rs.getString("email") %></td>
                                        <td><%= rs.getString("phone") %></td>
                                        <td><span class="user-type <%= rs.getString("user_type").toLowerCase() %>">
                                            <%= rs.getString("user_type") %>
                                        </span></td>
                                        <td class="actions">
                                            <button onclick="editUser(<%= rs.getInt("user_id") %>)" class="edit-btn">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button onclick="deleteUser(<%= rs.getInt("user_id") %>)" class="delete-btn">
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

        <!-- Add/Edit User Modal -->
        <div id="userModal" class="modal">
            <div class="modal-content">
                <span class="close">&times;</span>
                <h2 id="modalTitle">Add New User</h2>
                <form id="userForm" action="../UserServlet" method="POST">
                    <input type="hidden" name="action" id="formAction" value="add">
                    <input type="hidden" name="userId" id="userId" value="">
                    <div class="form-group">
                        <label>Username</label>
                        <input type="text" name="username" required>
                    </div>
                    <div class="form-group">
                        <label>Password</label>
                        <input type="password" name="password">
                    </div>
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
                        <input type="tel" name="phone" required>
                    </div>
                    <div class="form-group">
                        <label>User Type</label>
                        <select name="userType" required>
                            <option value="CUSTOMER">Customer</option>
                            <option value="DRIVER">Driver</option>
                            <option value="ADMIN">Admin</option>
                        </select>
                    </div>
                    <button type="submit" class="submit-btn">Save</button>
                </form>
            </div>
        </div>
        
        <script src="../js/admin.js"></script>
        <script src="../js/users.js"></script>
    </body>
</html>
