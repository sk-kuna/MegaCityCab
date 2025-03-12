document.addEventListener("DOMContentLoaded", function () {
  const statusToggle = document.getElementById("statusToggle");
  const statusText = document.getElementById("statusText");

  // Add function to fetch current status from database
  function fetchCurrentStatus() {
    fetch("../DriverServlet?action=getCurrentStatus")
      .then((response) => response.text())
      .then((status) => {
        updateStatusDisplay(status);
      })
      .catch((error) => {
        console.error("Error fetching status:", error);
      });
  }

  function updateStatusDisplay(status) {
    const isOnline = status === "ONLINE";
    statusToggle.checked = isOnline;
    statusText.textContent = status;
    statusText.className = isOnline ? "status-online" : "status-offline";
  }

  statusToggle.addEventListener("change", function () {
    const newStatus = this.checked ? "ONLINE" : "OFFLINE";

    fetch("../DriverServlet", {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: `action=updateStatus&status=${newStatus}`,
    })
      .then((response) => response.text())
      .then((result) => {
        if (result === "success") {
          // Fetch fresh status from database after update
          fetchCurrentStatus();
        } else {
          this.checked = !this.checked;
          alert("Failed to update status: " + result);
        }
      })
      .catch((error) => {
        console.error("Error:", error);
        this.checked = !this.checked;
        alert("An error occurred while updating status");
      });
  });

  // Fetch initial status when page loads
  fetchCurrentStatus();
});

function startRide(bookingId) {
  if (confirm("Are you sure you want to start this ride?")) {
    fetch("../BookingServlet", {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: `action=updateStatus&bookingId=${bookingId}&status=ONGOING`,
    })
      .then((response) => response.text())
      .then((result) => {
        if (result === "success") {
          location.reload();
        } else {
          alert("Failed to start ride");
        }
      });
  }
}

function cancelRide(bookingId) {
  if (confirm("Are you sure you want to cancel this ride?")) {
    fetch("../BookingServlet", {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: `action=updateStatus&bookingId=${bookingId}&status=CANCELLED`,
    })
      .then((response) => response.text())
      .then((result) => {
        if (result === "success") {
          location.reload();
        } else {
          alert("Failed to cancel ride");
        }
      });
  }
}
