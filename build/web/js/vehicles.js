document.addEventListener("DOMContentLoaded", function () {
  const modal = document.getElementById("vehicleModal");
  const closeBtn = modal.querySelector(".close");

  // Make functions globally accessible
  window.showAddVehicleForm = function () {
    document.getElementById("modalTitle").textContent = "Add New Vehicle";
    document.getElementById("formAction").value = "add";
    document.getElementById("vehicleId").value = "";
    document.getElementById("vehicleForm").reset();
    modal.style.display = "block";
  };

  window.editVehicle = function (vehicleId) {
    document.getElementById("modalTitle").textContent = "Edit Vehicle";
    document.getElementById("formAction").value = "edit";
    document.getElementById("vehicleId").value = vehicleId;

    fetch(`../VehicleServlet?action=get&vehicleId=${vehicleId}`)
      .then((response) => response.text())
      .then((data) => {
        const vehicle = JSON.parse(data);
        const form = document.getElementById("vehicleForm");
        form.registrationNumber.value = vehicle.registrationNumber;
        form.model.value = vehicle.model;
        form.capacity.value = vehicle.capacity;
        form.status.value = vehicle.status;
        modal.style.display = "block";
      });
  };

  window.deleteVehicle = function (vehicleId) {
    if (confirm("Are you sure you want to delete this vehicle?")) {
      fetch("../VehicleServlet", {
        method: "POST",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: `action=delete&vehicleId=${vehicleId}`,
      })
        .then((response) => response.text())
        .then((result) => {
          if (result === "success") {
            location.reload();
          } else {
            alert("Failed to delete vehicle");
          }
        });
    }
  };

  // Handle form submission
  document
    .getElementById("vehicleForm")
    .addEventListener("submit", function (e) {
      e.preventDefault();
      const formData = new FormData(this);

      fetch("../VehicleServlet", {
        method: "POST",
        body: formData,
      })
        .then((response) => response.text())
        .then((result) => {
          if (result === "success") {
            modal.style.display = "none";
            location.reload();
          } else {
            alert(
              result.includes("error:") ? result : "Failed to save vehicle"
            );
          }
        });
    });

  // Close modal functionality
  closeBtn.onclick = () => (modal.style.display = "none");
  window.onclick = (e) => {
    if (e.target === modal) modal.style.display = "none";
  };

  // Search and filter functionality
  document
    .getElementById("searchVehicle")
    .addEventListener("input", filterVehicles);
  document
    .getElementById("statusFilter")
    .addEventListener("change", filterVehicles);

  function filterVehicles() {
    const search = document.getElementById("searchVehicle").value.toLowerCase();
    const status = document.getElementById("statusFilter").value;
    const rows = document.querySelectorAll(".vehicles-table tbody tr");

    rows.forEach((row) => {
      const model = row.cells[2].textContent.toLowerCase();
      const registration = row.cells[1].textContent.toLowerCase();
      const vehicleStatus = row.cells[4].textContent.trim();

      const matchesSearch =
        model.includes(search) || registration.includes(search);
      const matchesStatus = !status || vehicleStatus === status;

      row.style.display = matchesSearch && matchesStatus ? "" : "none";
    });
  }
});
