// Initialize map services
let directionsService = new google.maps.DirectionsService();

function calculateDistance() {
  const pickup = document.getElementById("pickupLocation").value;
  const dropoff = document.getElementById("dropoffLocation").value;

  if (pickup && dropoff) {
    const request = {
      origin: pickup,
      destination: dropoff,
      travelMode: "DRIVING",
    };

    directionsService.route(request, function (result, status) {
      if (status == "OK") {
        const distanceInMeters = result.routes[0].legs[0].distance.value;
        const distanceInKm = distanceInMeters / 1000;
        const price = calculatePrice(distanceInKm);

        document.getElementById("distanceText").textContent =
          distanceInKm.toFixed(2) + " km";
        document.getElementById("priceText").textContent =
          "LKR " + price.toFixed(2);

        // Set hidden fields
        document.getElementById("estimatedDistance").value = distanceInKm;
        document.getElementById("estimatedPrice").value = price;
      }
    });
  }
}

function calculatePrice(distance) {
  const BASE_PRICE = 100; // LKR per kilometer
  return distance * BASE_PRICE;
}

function validateForm() {
  const distance = document.getElementById("estimatedDistance").value;
  if (!distance) {
    alert("Please wait for distance calculation to complete");
    return false;
  }
  return true;
}

// Add event listeners
document
  .getElementById("pickupLocation")
  .addEventListener("change", calculateDistance);
document
  .getElementById("dropoffLocation")
  .addEventListener("change", calculateDistance);
