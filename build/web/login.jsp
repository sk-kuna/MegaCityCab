<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Login - MegaCity Cab</title>
    <link
      href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap"
      rel="stylesheet"
    />
    <!-- <link rel="stylesheet" href="css/style.css" />
    <link rel="stylesheet" href="css/login.css" /> -->
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
    />

    <style>
/* General Styles */
body {
  font-family: 'Poppins', sans-serif;
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  margin: 0;
  background: linear-gradient(135deg, #4b6cb7, #182848);
  color: #fff;
}

.auth-container {
  width: 90%;
  max-width: 400px;
  background: rgba(255, 255, 255, 0.1);
  padding: 30px;
  border-radius: 10px;
  backdrop-filter: blur(10px);
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
  text-align: center;
}

.logo img {
  width: 80px;
}

.logo h1 {
  font-size: 24px;
  margin: 10px 0;
}

/* Form Styles */
.form-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 100%;
}

.form-group {
  position: relative;
  width: 100%;
  margin: 15px 0;
}

.form-group i {
  position: absolute;
  left: 15px;
  top: 50%;
  transform: translateY(-50%);
  color: #ffffff;
}

input, select, textarea {
  width: 100%;
  padding: 12px 45px;
  border: none;
  border-radius: 25px;
  background: rgba(255, 255, 255, 0.2);
  color: #0d0e0d;
  outline: none;
  box-sizing: border-box;
}

input::placeholder, textarea::placeholder {
  color: #ddd;
}

.submit-btn {
  width: 100%;
  padding: 12px;
  border: none;
  border-radius: 25px;
  background: linear-gradient(90deg, #ff7eb3, #ff758c);
  color: #fff;
  font-size: 16px;
  cursor: pointer;
  transition: 0.3s;
}

.submit-btn:hover {
  background: linear-gradient(90deg, #ff758c, #ff7eb3);
}

.error-message {
  background: rgba(255, 0, 0, 0.2);
  color: #ff4b5c;
  padding: 10px;
  border-radius: 5px;
  margin-bottom: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.switch-form {
  margin-top: 15px;
  font-size: 14px;
}

.switch-form a {
  color: #ff7eb3;
  text-decoration: none;
  font-weight: 500;
}

.switch-form a:hover {
  text-decoration: underline;
}


    </style>
  </head>
  <body>
    <div class="auth-container">
      <!-- Login Form -->
      <div class="form-container" id="loginForm">
        <div class="logo">
          <h1>MegaCity Cab</h1>
        </div>

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

          <div class="form-group select-group">
            <i class="fas fa-users"></i>
            <select name="userType" required>
              <option value="">Select User Type</option>
              <option value="CUSTOMER">Customer</option>
              <option value="DRIVER">Driver</option>
              <option value="ADMIN">Admin</option>
            </select>
          </div>

          <button type="submit" class="submit-btn">Login</button>
        </form>
        <p class="switch-form">
          Don't have an account?
          <a href="#" onclick="toggleForm('register')">Register</a>
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
