<%@page contentType="text/html" pageEncoding="UTF-8"%> <%@page
import="java.sql.*"%> <%@page import="util.DBConnection"%> <% if
(session.getAttribute("userType") == null ||
!session.getAttribute("userType").equals("CUSTOMER")) {
response.sendRedirect("../login.jsp"); return; } ResultSet userDetails = null;
int userId = (int) session.getAttribute("userId"); try { Connection conn =
DBConnection.getConnection(); String sql = "SELECT * FROM users WHERE user_id =
?"; PreparedStatement stmt = conn.prepareStatement(sql); stmt.setInt(1, userId);
userDetails = stmt.executeQuery(); if(userDetails.next()) {
request.setAttribute("userDetails", userDetails); } } catch(SQLException e) {
e.printStackTrace(); } %>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>My Profile - MegaCity Cab</title>
    <link rel="stylesheet" href="../css/style.css" />
    <link rel="stylesheet" href="../css/dashboard.css" />
    <link rel="stylesheet" href="../css/profile.css" />
  </head>
  <body>
    <div class="dashboard-container">
      <h1>My Profile</h1>
      <button onclick="location.href='dashboard.jsp'" class="back-btn">
        Back to Dashboard
      </button>

      <div class="profile-container">
        <form
          action="../UpdateProfileServlet"
          method="POST"
          class="profile-form"
        >
          <div class="form-group">
            <label>Username</label>
            <input type="text" name="username" value="<%=
            userDetails.getString("username") %>" readonly>
          </div>
          <div class="form-group">
            <label>Full Name</label>
            <input type="text" name="name" value="<%=
            userDetails.getString("name") %>" required>
          </div>
          <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" value="<%=
            userDetails.getString("email") %>" required>
          </div>
          <div class="form-group">
            <label>Phone</label>
            <input type="tel" name="phone" value="<%=
            userDetails.getString("phone") %>" required>
          </div>
          <div class="form-group">
            <label>Address</label>
            <textarea name="address" required>
<%= userDetails.getString("address") %></textarea
            >
          </div>
          <div class="form-group">
            <label>NIC</label>
            <input type="text" name="nic" value="<%=
            userDetails.getString("nic") %>" required>
          </div>
          <div class="button-group">
            <button type="submit" class="update-btn">Update Profile</button>
            <button
              type="button"
              onclick="showChangePassword()"
              class="password-btn"
            >
              Change Password
            </button>
          </div>
        </form>
      </div>
    </div>
  </body>
</html>
<% try { if(userDetails != null) userDetails.close(); } catch(SQLException e) {
e.printStackTrace(); } %>
