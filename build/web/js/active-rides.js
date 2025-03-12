function completeRide(bookingId) {
  if (confirm("Are you sure you want to complete this ride?")) {
    fetch("../BookingServlet", {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: `action=updateStatus&bookingId=${bookingId}&status=COMPLETED`,
    })
      .then((response) => response.text())
      .then((result) => {
        if (result === "success") {
          location.reload();
        } else {
          alert("Failed to complete ride");
        }
      });
  }
}

function showDirections(location) {
  // Open Google Maps with the location
  window.open(
    `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(
      location
    )}`,
    "_blank"
  );
}

// Auto-refresh page every 30 seconds to check for new rides
setInterval(() => {
  location.reload();
}, 30000);
