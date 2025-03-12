function updatePrice() {
  const vehicleType = document.querySelector(
    'select[name="vehicle_type"]'
  ).value;
  const pickup = document.querySelector('input[name="pickup_location"]').value;
  const dropoff = document.querySelector(
    'input[name="dropoff_location"]'
  ).value;

  if (vehicleType && pickup && dropoff) {
    // Make AJAX call to get price estimation
    fetch(
      `../PriceEstimateServlet?vehicle_type=${vehicleType}&pickup=${pickup}&dropoff=${dropoff}`
    )
      .then((response) => response.json())
      .then((data) => {
        document.getElementById(
          "estimated_price"
        ).value = `${data.price.toFixed(2)}`;
        document.getElementById("estimated_price_hidden").value = data.price;
      });
  }
}

// Add event listeners for location fields
document
  .querySelectorAll(
    'input[name="pickup_location"], input[name="dropoff_location"]'
  )
  .forEach((input) => {
    input.addEventListener("change", updatePrice);
  });
