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
        <!-- <link rel="stylesheet" href="../css/style.css">
        <link rel="stylesheet" href="../css/admin.css">
        <link rel="stylesheet" href="../css/users.css"> -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

        <style>
            /* General Styling */
body {
    font-family: 'Poppins', sans-serif;
    margin: 0;
    padding: 0;
    background: linear-gradient(to right, #2c3e50, #4ca1af);
    color: #fff;
}

.admin-container {
    display: flex;
}

/* Sidebar Styling */
.sidebar {
    width: 250px;
    background: linear-gradient(to bottom, #2c3e50, #34495e);
    padding: 20px;
    height: 100vh;
    position: fixed;
    box-shadow: 2px 0 10px rgba(0, 0, 0, 0.3);
}

.sidebar a {
    display: block;
    padding: 12px;
    color: white;
    text-decoration: none;
    border-radius: 5px;
    transition: 0.3s;
}

.sidebar a:hover {
    background: rgba(255, 255, 255, 0.2);
}

/* Main Content */
.main-content {
    margin-left: 270px;
    padding: 20px;
    width: calc(100% - 270px);
}

/* Navbar Styling */
.topbar {
    background: linear-gradient(to right, #34495e, #2c3e50);
    padding: 15px 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
    border-radius: 10px;
}

.topbar h2 {
    margin: 0;
    font-size: 20px;
}

/* User Table Styling */
.users-table-container {
    background: rgba(255, 255, 255, 0.1);
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
}

.users-table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 10px;
}

.users-table th, .users-table td {
    padding: 12px;
    text-align: left;
    border-bottom: 1px solid rgba(255, 255, 255, 0.2);
}

.users-table th {
    background: rgba(255, 255, 255, 0.2);
}

.users-table tbody tr:hover {
    background: rgba(255, 255, 255, 0.1);
}

/* Buttons */
button {
    background: linear-gradient(to right, #e67e22, #f39c12);
    color: white;
    border: none;
    padding: 10px 15px;
    border-radius: 5px;
    cursor: pointer;
    transition: 0.3s;
}

button:hover {
    background: linear-gradient(to right, #f39c12, #e67e22);
}

/* Modal Styling */
.modal {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.7);
    justify-content: center;
    align-items: center;
}

.modal-content {
    background: linear-gradient(to bottom, #4ca1af, #2c3e50);
    padding: 20px;
    border-radius: 10px;
    width: 400px;
    text-align: center;
}

.close {
    position: absolute;
    top: 15px;
    right: 20px;
    font-size: 20px;
    cursor: pointer;
}

        </style>
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
                        <!-- <button class="add-user-btn" onclick="showAddUserForm()">
                            <i class="fas fa-plus"></i> Add New User
                        </button> -->
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
                                            <!-- <button onclick="editUser(<%= rs.getInt("user_id") %>)" class="edit-btn">
                                                <i class="fas fa-edit"></i>
                                            </button> -->
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
