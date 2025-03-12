document.addEventListener("DOMContentLoaded", function () {
  // Load dashboard stats
  loadDashboardStats();
  // Load recent bookings
  loadRecentBookings();
  // Refresh data every 30 seconds
  setInterval(loadDashboardStats, 30000);
  setInterval(loadRecentBookings, 30000);
});

function loadDashboardStats() {
  fetch("../AdminDashboardServlet?action=getStats")
    .then((response) => response.json())
    .then((data) => {
      document.getElementById("totalBookings").textContent = data.totalBookings;
      document.getElementById("activeDrivers").textContent = data.activeDrivers;
      document.getElementById("totalRevenue").textContent =
        "LKR " + data.totalRevenue.toFixed(2);
      document.getElementById("totalUsers").textContent = data.totalUsers;
    });
}

function loadRecentBookings() {
  fetch("../AdminDashboardServlet?action=getRecentBookings")
    .then((response) => response.text())
    .then((html) => {
      document.querySelector(".recent-bookings-table").innerHTML = html;
    });
}
