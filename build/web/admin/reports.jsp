<%@page contentType="text/html" pageEncoding="UTF-8"%> <%@page
import="java.sql.*"%> <%@page import="util.DBConnection"%> <% if
(session.getAttribute("userType") == null ||
!session.getAttribute("userType").equals("ADMIN")) {
response.sendRedirect("../login.jsp"); return; } %>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Reports - MegaCity Cab</title>
    <link rel="stylesheet" href="../css/style.css" />
    <link rel="stylesheet" href="../css/admin.css" />
    <link rel="stylesheet" href="../css/reports.css" />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
    />
  </head>
  <body>
    <div class="admin-container">
      <%@ include file="includes/sidebar.jsp" %>
      <div class="main-content">
        <%@ include file="includes/topbar.jsp" %>

        <div class="reports-content">
          <div class="reports-header">
            <h2>Reports & Analytics</h2>
            <div class="date-filter">
              <input type="date" id="startDate" />
              <span>to</span>
              <input type="date" id="endDate" />
              <button onclick="generateReport()" class="generate-btn">
                Generate Report
              </button>
            </div>
          </div>

          <!-- Revenue Summary -->
          <div class="report-section">
            <h3>Revenue Summary</h3>
            <div class="revenue-stats">
              <div class="stat-card">
                <h4>Total Revenue</h4>
                <div class="stat-value" id="totalRevenue">LKR 0.00</div>
              </div>
              <div class="stat-card">
                <h4>Average Daily Revenue</h4>
                <div class="stat-value" id="avgRevenue">LKR 0.00</div>
              </div>
              <div class="stat-card">
                <h4>Total Bookings</h4>
                <div class="stat-value" id="totalBookings">0</div>
              </div>
              <div class="stat-card">
                <h4>Total Discounts</h4>
                <div class="stat-value" id="totalDiscounts">LKR 0.00</div>
              </div>
              <div class="stat-card">
                <h4>Total Tax</h4>
                <div class="stat-value" id="totalTax">LKR 0.00</div>
              </div>
            </div>
          </div>

          <!-- Bookings by Status -->
          <div class="report-section">
            <h3>Bookings by Status</h3>
            <div class="status-chart" id="bookingStatusChart"></div>
          </div>

          <!-- Driver Performance -->
          <div class="report-section">
            <h3>Top Performing Drivers</h3>
            <div class="drivers-table-container">
              <table class="reports-table">
                <thead>
                  <tr>
                    <th>Driver Name</th>
                    <th>Total Trips</th>
                    <th>Rating</th>
                    <th>Total Revenue</th>
                  </tr>
                </thead>
                <tbody id="driverStatsBody">
                  <!-- Will be populated via JavaScript -->
                </tbody>
              </table>
            </div>
          </div>

          <!-- Download Reports -->
          <div class="report-actions">
            <button onclick="downloadReport('pdf')" class="download-btn pdf">
              <i class="fas fa-file-pdf"></i> Download PDF
            </button>
            <button
              onclick="downloadReport('excel')"
              class="download-btn excel"
            >
              <i class="fas fa-file-excel"></i> Download Excel
            </button>
          </div>
        </div>
      </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="../js/admin.js"></script>
    <script src="../js/reports.js"></script>
  </body>
</html>
