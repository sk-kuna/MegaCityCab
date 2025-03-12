document.addEventListener("DOMContentLoaded", function () {
  updateStats();
});

function filterRides() {
  const dateFilter = document.getElementById("dateFilter").value;
  const statusFilter = document.getElementById("statusFilter").value;
  const rides = document.querySelectorAll(".ride-card");

  rides.forEach((ride) => {
    const rideDate = new Date(ride.dataset.date).toLocaleDateString();
    const rideStatus = ride.dataset.status;

    const matchesDate =
      !dateFilter || new Date(dateFilter).toLocaleDateString() === rideDate;
    const matchesStatus = !statusFilter || rideStatus === statusFilter;

    ride.style.display = matchesDate && matchesStatus ? "block" : "none";
  });

  updateStats();
}

function updateStats() {
  const visibleRides = Array.from(
    document.querySelectorAll(".ride-card")
  ).filter((ride) => ride.style.display !== "none");

  // Update total rides
  document.getElementById("totalRides").textContent = visibleRides.length;

  // Calculate total earnings
  const totalEarnings = visibleRides.reduce((sum, ride) => {
    const amountElement = ride.querySelector(".fas.fa-money-bill");
    if (amountElement) {
      const amount = parseFloat(
        amountElement.nextSibling.textContent.replace("LKR ", "")
      );
      return sum + (isNaN(amount) ? 0 : amount);
    }
    return sum;
  }, 0);
  document.getElementById(
    "totalEarnings"
  ).textContent = `LKR ${totalEarnings.toFixed(2)}`;

  // Calculate average rating
  const ratings = visibleRides
    .map((ride) => {
      const ratingElement = ride.querySelector(".fas.fa-star");
      return ratingElement
        ? parseFloat(
            ratingElement.nextSibling.textContent.replace("Rating: ", "")
          )
        : 0;
    })
    .filter((rating) => rating > 0);

  const avgRating =
    ratings.length > 0
      ? ratings.reduce((sum, rating) => sum + rating, 0) / ratings.length
      : 0;
  document.getElementById("avgRating").textContent = avgRating.toFixed(1);
}
