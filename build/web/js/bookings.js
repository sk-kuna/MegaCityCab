// Modal functionality
const viewModal = document.getElementById("viewModal");
const assignModal = document.getElementById("assignModal");
const statusModal = document.getElementById("statusModal");
const closeBtns = document.querySelectorAll(".close");

// Close modals
closeBtns.forEach((btn) => {
  btn.onclick = function () {
    viewModal.style.display = "none";
    assignModal.style.display = "none";
    statusModal.style.display = "none";
  };
});

// Close modals when clicking outside
window.onclick = (e) => {
  if (e.target.classList.contains("modal")) {
    e.target.style.display = "none";
  }
};

// View booking details
function viewBooking(bookingId) {
  fetch(`../BookingServlet?action=view&bookingId=${bookingId}`)
    .then((response) => response.text())
    .then((html) => {
      document.getElementById("bookingDetails").innerHTML = html;
      viewModal.style.display = "block";
    });
}

// Assign driver
function assignDriver(bookingId) {
  document.getElementById("assignBookingId").value = bookingId;

  fetch("../BookingServlet?action=getDrivers")
    .then((response) => response.text())
    .then((html) => {
      const select = document.querySelector("#assignForm select");
      select.innerHTML = html;
      assignModal.style.display = "block";
    });
}

// Handle assign driver form submission
document.getElementById("assignForm").addEventListener("submit", function (e) {
  e.preventDefault();
  const formData = new FormData(this);

  fetch("../BookingServlet", {
    method: "POST",
    body: formData,
  })
    .then((response) => response.text())
    .then((result) => {
      if (result === "success") {
        assignModal.style.display = "none";
        location.reload();
      } else {
        alert("Failed to assign driver");
      }
    });
});

// Update status handling
function updateStatus(bookingId) {
  document.getElementById("statusBookingId").value = bookingId;

  // Get current status and pre-select it
  const statusCell = document.querySelector(
    `tr[data-booking-id="${bookingId}"] .status`
  );
  const currentStatus = statusCell.textContent.trim();
  document.querySelector("#statusForm select").value = currentStatus;

  statusModal.style.display = "block";
}

// Handle status update form submission
document.getElementById("statusForm").addEventListener("submit", function (e) {
  e.preventDefault();
  const formData = new FormData(this);

  // Verify form data
  console.log("Sending data:", Object.fromEntries(formData));

  fetch("../BookingServlet", {
    method: "POST",
    headers: {
      "X-Requested-With": "XMLHttpRequest",
    },
    body: new URLSearchParams({
      action: "updateStatus",
      bookingId: formData.get("bookingId"),
      status: formData.get("status"),
    }),
  })
    .then((response) => response.text())
    .then((result) => {
      console.log("Server response:", result);
      if (result.trim() === "success") {
        const bookingId = formData.get("bookingId");
        const newStatus = formData.get("status");

        // Update the status in the table
        const statusCell = document.querySelector(
          `tr[data-booking-id="${bookingId}"] .status`
        );
        if (statusCell) {
          statusCell.className = `status ${newStatus.toLowerCase()}`;
          statusCell.textContent = newStatus;
        }

        statusModal.style.display = "none";
        showAlert("Status updated successfully", "success");
      } else {
        showAlert("Failed to update status: " + result, "error");
      }
    })
    .catch((error) => {
      console.error("Error:", error);
      showAlert("An error occurred while updating status", "error");
    });
});

// Add this function for showing alerts
function showAlert(message, type) {
  // Create alert container if it doesn't exist
  let alertContainer = document.querySelector(".alert-container");
  if (!alertContainer) {
    alertContainer = document.createElement("div");
    alertContainer.className = "alert-container";
    const content = document.querySelector(".bookings-content");
    content.insertBefore(alertContainer, content.firstChild);
  }

  // Create alert element
  const alert = document.createElement("div");
  alert.className = `alert alert-${type}`;
  alert.textContent = message;

  // Add to container
  alertContainer.appendChild(alert);

  // Remove after 3 seconds
  setTimeout(() => alert.remove(), 3000);
}

// Filter functionality
document
  .getElementById("searchBooking")
  .addEventListener("input", filterBookings);
document
  .getElementById("statusFilter")
  .addEventListener("change", filterBookings);
document
  .getElementById("dateFilter")
  .addEventListener("change", filterBookings);

function filterBookings() {
  const search = document.getElementById("searchBooking").value.toLowerCase();
  const status = document.getElementById("statusFilter").value;
  const date = document.getElementById("dateFilter").value;

  const rows = document
    .getElementById("bookingsTableBody")
    .getElementsByTagName("tr");

  for (let row of rows) {
    const customer = row.cells[1].textContent.toLowerCase();
    const bookingStatus = row.cells[7].textContent.trim();
    const pickupTime = row.cells[6].textContent;

    const matchesSearch = customer.includes(search);
    const matchesStatus = !status || bookingStatus === status;
    const matchesDate = !date || pickupTime.includes(date);

    row.style.display =
      matchesSearch && matchesStatus && matchesDate ? "" : "none";
  }
}
