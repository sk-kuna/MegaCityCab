let bookingStatusChart;

document.addEventListener("DOMContentLoaded", function () {
  // Set default date range (last 30 days)
  const endDate = new Date();
  const startDate = new Date();
  startDate.setDate(startDate.getDate() - 30);

  document.getElementById("startDate").value = startDate
    .toISOString()
    .split("T")[0];
  document.getElementById("endDate").value = endDate
    .toISOString()
    .split("T")[0];

  generateReport();
});

function generateReport() {
  const startDate = document.getElementById("startDate").value;
  const endDate = document.getElementById("endDate").value;

  // Fetch report data
  fetch(
    `../ReportServlet?action=getReportData&startDate=${startDate}&endDate=${endDate}`
  )
    .then((response) => response.json())
    .then((data) => {
      updateRevenueStats(data.revenue);
      updateBookingChart(data.bookingStatus);
      updateDriverStats(data.driverStats);
    });
}

function updateRevenueStats(revenue) {
  document.getElementById(
    "totalRevenue"
  ).textContent = `LKR ${revenue.total.toFixed(2)}`;
  document.getElementById(
    "avgRevenue"
  ).textContent = `LKR ${revenue.average.toFixed(2)}`;
  document.getElementById("totalBookings").textContent = revenue.bookings;

  // Add new elements for discounts and tax if they exist in your HTML
  if (document.getElementById("totalDiscounts")) {
    document.getElementById(
      "totalDiscounts"
    ).textContent = `LKR ${revenue.discounts.toFixed(2)}`;
  }
  if (document.getElementById("totalTax")) {
    document.getElementById(
      "totalTax"
    ).textContent = `LKR ${revenue.tax.toFixed(2)}`;
  }
}

function updateBookingChart(statusData) {
  const ctx = document.getElementById("bookingStatusChart").getContext("2d");

  if (bookingStatusChart) {
    bookingStatusChart.destroy();
  }

  bookingStatusChart = new Chart(ctx, {
    type: "pie",
    data: {
      labels: Object.keys(statusData),
      datasets: [
        {
          data: Object.values(statusData),
          backgroundColor: [
            "#ffd700", // Pending
            "#28a745", // Confirmed
            "#007bff", // Completed
            "#dc3545", // Cancelled
          ],
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
    },
  });
}

function updateDriverStats(drivers) {
  const tbody = document.getElementById("driverStatsBody");
  tbody.innerHTML = "";

  drivers.forEach((driver) => {
    const row = `
            <tr>
                <td>${driver.name}</td>
                <td>${driver.trips}</td>
                <td>
                    <div class="rating">
                        ${driver.rating.toFixed(1)}
                        <i class="fas fa-star"></i>
                    </div>
                </td>
                <td>LKR ${driver.revenue.toFixed(2)}</td>
            </tr>
        `;
    tbody.innerHTML += row;
  });
}

function downloadReport(format) {
  const startDate = document.getElementById("startDate").value;
  const endDate = document.getElementById("endDate").value;

  window.location.href = `../ReportServlet?action=download&format=${format}&startDate=${startDate}&endDate=${endDate}`;
}
