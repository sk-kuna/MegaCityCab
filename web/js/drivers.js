document.addEventListener("DOMContentLoaded", function () {
  const modal = document.getElementById("driverModal");
  const closeBtn = modal.querySelector(".close");

  // Make functions globally accessible
  window.showAddDriverForm = function () {
    const modal = document.getElementById("driverModal");
    document.getElementById("modalTitle").textContent = "Add New Driver";
    document.getElementById("formAction").value = "add";
    document.getElementById("driverId").value = "";
    document.getElementById("driverForm").reset();
    modal.style.display = "block";
  };

  window.editDriver = function (driverId) {
    const modal = document.getElementById("driverModal");
    document.getElementById("modalTitle").textContent = "Edit Driver Details";
    document.getElementById("formAction").value = "edit";
    document.getElementById("driverId").value = driverId;

    fetch(`../DriverServlet?action=get&driverId=${driverId}`)
      .then((response) => response.text())
      .then((data) => {
        const driver = JSON.parse(data);
        const form = document.getElementById("driverForm");
        form.licenseNumber.value = driver.licenseNumber;
        form.experience.value = driver.experience;
        form.status.value = driver.status;
        modal.style.display = "block";
      });
  };

  window.viewPerformance = function (driverId) {
    alert("Performance tracking coming soon!");
  };

  // Handle form submission
  document
    .getElementById("driverForm")
    .addEventListener("submit", function (e) {
      e.preventDefault();
      const formData = new FormData(this);

      fetch("../DriverServlet", {
        method: "POST",
        body: formData,
      })
        .then((response) => response.text())
        .then((result) => {
          if (result === "success") {
            document.getElementById("driverModal").style.display = "none";
            location.reload();
          } else {
            alert(
              result.includes("error:")
                ? result
                : "Failed to save driver details"
            );
          }
        })
        .catch((error) => {
          alert("An error occurred: " + error);
        });
    });

  // Close modal
  closeBtn.onclick = () => (modal.style.display = "none");
  window.onclick = (e) => {
    if (e.target == modal) modal.style.display = "none";
  };

  // Search and filter
  document
    .getElementById("searchDriver")
    .addEventListener("input", filterDrivers);
  document
    .getElementById("statusFilter")
    .addEventListener("change", filterDrivers);

  function filterDrivers() {
    const search = document.getElementById("searchDriver").value.toLowerCase();
    const status = document.getElementById("statusFilter").value;
    const rows = document.querySelectorAll(".drivers-table tbody tr");

    rows.forEach((row) => {
      const name = row.cells[1].textContent.toLowerCase();
      const driverStatus = row.cells[5].textContent.trim();
      const matchesSearch = name.includes(search);
      const matchesStatus = !status || driverStatus === status;
      row.style.display = matchesSearch && matchesStatus ? "" : "none";
    });
  }
});
