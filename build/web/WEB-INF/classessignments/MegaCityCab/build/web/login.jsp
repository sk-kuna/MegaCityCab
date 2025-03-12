<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Login & Register - MegaCity Cab</title>
    <link
      href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap"
      rel="stylesheet"
    />
    <link rel="stylesheet" href="css/style.css" />
    <link rel="stylesheet" href="css/login.css" />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
    />
  </head>
  <body>
    <div class="auth-container">
      <!-- Login Form -->
      <div class="form-container" id="loginForm">
        <h2>Welcome Back</h2>
        <p class="subtitle">Please login to continue</p>

        <% if (request.getAttribute("error") != null) { %>
        <div class="error-message">
          <i class="fas fa-exclamation-circle"></i>
          <%= request.getAttribute("error") %>
        </div>
        <% } %>

        <form action="LoginServlet" method="POST">
          <div class="form-group">
            <i class="fas fa-user"></i>
            <input
              type="text"
              name="username"
              required
              placeholder="Username"
            />
          </div>

          <div class="form-group">
            <i class="fas fa-lock"></i>
            <input
              type="password"
              name="password"
              required
              placeholder="Password"
            />
          </div>

          <div class="form-group">
            <i class="fas fa-users"></i>
            <select name="userType" required>
              <option value="">Select User Type</option>
              <option value="CUSTOMER">Customer</option>
              <option value="DRIVER">Driver</option>
              <option value="ADMIN">Admin</option>
            </select>
          </div>

          <button type="submit" class="submit-btn">
            <i class="fas fa-sign-in-alt"></i> Login
          </button>
        </form>
        <p class="switch-form">
          Don't have an account?
          <a href="#" onclick="toggleForm('register')">Register here</a>
        </p>
      </div>

      <!-- Registration Form -->
      <div class="form-container" id="registerForm" style="display: none">
        <h2>Create Account</h2>
        <p class="subtitle">Join MegaCity Cab today</p>

        <form action="RegisterServlet" method="POST" id="registrationForm">
          <div class="form-group">
            <i class="fas fa-user"></i>
            <input
              type="text"
              name="username"
              required
              placeholder="Username"
            />
          </div>

          <div class="form-group">
            <i class="fas fa-lock"></i>
            <input
              type="password"
              name="password"
              required
              placeholder="Password"
            />
          </div>

          <div class="form-group">
            <i class="fas fa-envelope"></i>
            <input
              type="email"
              name="email"
              required
              placeholder="Email Address"
            />
          </div>

          <div class="form-group">
            <i class="fas fa-user-circle"></i>
            <input type="text" name="name" required placeholder="Full Name" />
          </div>

          <div class="form-group">
            <i class="fas fa-map-marker-alt"></i>
            <textarea name="address" required placeholder="Address"></textarea>
          </div>

          <div class="form-group">
            <i class="fas fa-phone"></i>
            <input
              type="tel"
              name="phone"
              required
              placeholder="Phone Number"
              pattern="[0-9]{10}"
            />
          </div>

          <div class="form-group">
            <i class="fas fa-id-card"></i>
            <input type="text" name="nic" required placeholder="NIC Number" />
          </div>

          <button type="submit" class="submit-btn">
            <i class="fas fa-user-plus"></i> Register
          </button>
        </form>
        <p class="switch-form">
          Already have an account?
          <a href="#" onclick="toggleForm('login')">Login here</a>
        </p>
      </div>
    </div>
    <script src="js/login.js"></script>
  </body>
</html>
