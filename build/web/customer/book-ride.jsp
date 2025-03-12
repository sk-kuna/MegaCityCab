<%@page contentType="text/html" pageEncoding="UTF-8"%> <% if
(session.getAttribute("userType") == null ||
!session.getAttribute("userType").equals("CUSTOMER")) {
response.sendRedirect("../login.jsp"); return; } %>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Book a Ride - MegaCity Cab</title>
    <link rel="stylesheet" href="../css/style.css" />
    <link rel="stylesheet" href="../css/dashboard.css" />
    <link rel="stylesheet" href="../css/booking.css" />
  </head>
  <body>
    <div class="dashboard-container">
      <h1>Book a Ride</h1>
      <div class="booking-form-container">
        <form action="../BookingServlet" method="POST" class="booking-form">
          <div class="form-group">
            <label>Pickup Location</label>
            <input type="text" name="pickup_location" required />
          </div>
          <div class="form-group">
            <label>Dropoff Location</label>
            <input type="text" name="dropoff_location" required />
          </div>
          <div class="form-group">
            <label>Number of Passengers</label>
            <input
              type="number"
              name="passenger_count"
              min="1"
              max="50"
              required
            />
          </div>
          <div class="form-group">
            <label>Vehicle Type</label>
            <select
              name="vehicle_type"
              required
              class="vehicle-select"
              onchange="updatePrice()"
            >
              <option value="">Select Vehicle Type</option>
              <option value="CAR">Car (1-4 passengers)</option>
              <option value="VAN">Van (5-8 passengers)</option>
              <option value="BUS">Mini Bus (9-15 passengers)</option>
            </select>
          </div>
          <div class="form-group">
            <label>Pickup Date & Time</label>
            <input type="datetime-local" name="pickup_time" required />
          </div>
          <button type="submit" class="submit-btn">Book Now</button>
          <button
            type="button"
            onclick="location.href='dashboard.jsp'"
            class="cancel-btn"
          >
            Cancel
          </button>
        </form>
      </div>
    </div>
  </body>
</html>
