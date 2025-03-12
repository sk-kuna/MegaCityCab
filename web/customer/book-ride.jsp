<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% 
// Check if user is logged in 
if (session.getAttribute("userId") == null) {
    response.sendRedirect("../login.jsp?error=Please+login+to+book+a+ride");
    return;
} 
%>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Book a Ride - MegaCity Cab</title>
    <!-- <link rel="stylesheet" href="../css/style.css" />
    <link rel="stylesheet" href="../css/customer.css" /> -->
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
    />
  </head>
  <style>
    /* General styles */
body {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  margin: 0;
  padding: 0;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4efe9 100%);
  color: #333;
  min-height: 100vh;
}

/* Container layout */
.customer-container {
  display: flex;
  min-height: 100vh;
}

/* Sidebar styling */
.sidebar {
  width: 250px;
  background: linear-gradient(to bottom, #2c3e50, #1a252f);
  color: white;
  padding: 20px 0;
  box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
}

.sidebar .logo {
  text-align: center;
  padding: 10px 0 20px;
}

.sidebar .logo img {
  max-width: 150px;
}

.sidebar .nav-items {
  list-style: none;
  padding: 0;
  margin: 0;
}

.sidebar .nav-items li {
  padding: 10px 20px;
  transition: background 0.3s;
}

.sidebar .nav-items li:hover {
  background: rgba(255, 255, 255, 0.1);
}

.sidebar .nav-items a {
  color: white;
  text-decoration: none;
  display: flex;
  align-items: center;
}

.sidebar .nav-items i {
  margin-right: 10px;
  width: 20px;
  text-align: center;
}

/* Main content area */
.main-content {
  flex: 1;
  padding: 30px;
  background-color: #fff;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.05);
  border-radius: 10px;
  margin: 20px;
}

.main-content h2 {
  color: #2c3e50;
  margin-bottom: 30px;
  padding-bottom: 10px;
  border-bottom: 2px solid #eaeaea;
  font-size: 28px;
}

/* Alert messages */
.alert {
  padding: 15px;
  border-radius: 5px;
  margin-bottom: 25px;
  display: flex;
  align-items: center;
}

.alert-success {
  background: linear-gradient(to right, #43c6ac, #28a745);
  color: white;
}

.alert i {
  margin-right: 10px;
  font-size: 18px;
}

/* Booking form */
.booking-form {
  background: white;
  padding: 30px;
  border-radius: 8px;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
}

.form-group {
  margin-bottom: 20px;
}

.form-group label {
  display: block;
  margin-bottom: 8px;
  font-weight: 500;
  color: #2c3e50;
}

.form-group input,
.form-group select {
  width: 100%;
  padding: 12px 15px;
  border: 1px solid #ddd;
  border-radius: 5px;
  font-size: 16px;
  transition: border-color 0.3s, box-shadow 0.3s;
}

.form-group input:focus,
.form-group select:focus {
  border-color: #4a90e2;
  box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.1);
  outline: none;
}

/* Price estimate section */
.price-estimate {
  background: linear-gradient(to right, #f6f9fc, #eef2f7);
  padding: 20px;
  border-radius: 5px;
  margin: 25px 0;
}

.price-estimate h3 {
  color: #2c3e50;
  margin-top: 0;
}

.price-estimate #price_display {
  color: #2e86de;
  font-weight: bold;
}

.price-note {
  color: #7f8c8d;
  font-size: 14px;
  margin-bottom: 0;
}

/* Submit button */
.submit-btn {
  background: linear-gradient(to right, #ff7e5f, #feb47b);
  color: white;
  border: none;
  border-radius: 5px;
  padding: 15px 30px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  transition: transform 0.2s, box-shadow 0.2s;
}

.submit-btn:hover {
  background: linear-gradient(to right, #fc6b4f, #fea36d);
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(255, 126, 95, 0.3);
}

.submit-btn i {
  margin-right: 10px;
}

/* Responsive adjustments */
@media (max-width: 992px) {
  .customer-container {
    flex-direction: column;
  }
  
  .sidebar {
    width: 100%;
    padding: 10px 0;
  }
  
  .main-content {
    margin: 10px;
  }
}

@media (max-width: 576px) {
  .main-content {
    padding: 15px;
  }
  
  .booking-form {
    padding: 20px;
  }
}
  </style>
  <body>
    <div class="customer-container">
      <%@ include file="includes/sidebar.jsp" %>
      
      <div class="main-content">
        <h2>Book a Ride</h2>
        
        <% if(request.getParameter("success") != null) { %>
        <div class="alert alert-success">
          <i class="fas fa-check-circle"></i>
          Booking successful! Your ride has been confirmed.
        </div>
        <% } %>
        
        <div class="booking-form">
          <form action="../BookingServlet" method="POST">
            <input type="hidden" name="action" value="book" />
            
            <div class="form-group">
              <label>Pickup Location</label>
              <input type="text" name="pickup_location" required />
            </div>
            
            <div class="form-group">
              <label>Dropoff Location</label>
              <input type="text" name="dropoff_location" required />
            </div>
            
            <div class="form-group">
              <label>Distance (in kilometers)</label>
              <input
                type="number"
                name="distance"
                id="distance"
                required
                min="1"
                step="0.1"
                onchange="calculatePrice()"
              />
            </div>
            
            <div class="form-group">
              <label>Pickup Date & Time</label>
              <input type="datetime-local" name="pickup_time" required />
            </div>
            
            <div class="form-group">
              <label>Number of Passengers</label>
              <input
                type="number"
                name="passenger_count"
                min="1"
                max="6"
                required
              />
            </div>
            
            <div class="form-group">
              <label>Vehicle Type</label>
              <select name="vehicle_type" required>
                <option value="CAR">Car (4 seats)</option>
                <option value="VAN">Van (6 seats)</option>
              </select>
            </div>
            
            <div class="price-estimate">
              <input
                type="hidden"
                name="estimated_price"
                id="estimated_price"
              />
              <h3>Estimated Price: <span id="price_display">LKR 0.00</span></h3>
              <p class="price-note">Base rate: LKR 100 per kilometer</p>
            </div>
            
            <button type="submit" class="submit-btn">
              <i class="fas fa-taxi"></i> Book Now
            </button>
          </form>
        </div>
      </div>
    </div>
    
    <script>
      function calculatePrice() {
        const distance = document.getElementById("distance").value;
        const pricePerKm = 100;
        const totalPrice = distance * pricePerKm;
        
        document.getElementById("price_display").textContent =
          "LKR " + totalPrice.toFixed(2);
        document.getElementById("estimated_price").value = totalPrice;
        
        return true;
      }
    </script>
  </body>
</html>