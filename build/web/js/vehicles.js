// Define functions in global scope first
function openVehicleModal() {
  const modal = document.getElementById("vehicleModal");
  const modalTitle = document.getElementById("modalTitle");
  const formAction = document.getElementById("formAction");
  const vehicleForm = document.getElementById("vehicleForm");

  if (modal && modalTitle && formAction && vehicleForm) {
    modalTitle.textContent = "Add New Vehicle";
    formAction.value = "add";
    vehicleForm.reset();
    modal.style.display = "block";
  }
}

function editVehicle(vehicleId) {
  const modal = document.getElementById("vehicleModal");

  fetch(`../VehicleServlet?action=get&vehicleId=${vehicleId}`)
    .then((response) => response.json())
    .then((vehicle) => {
      if (!vehicle) throw new Error("No vehicle data received");

      const elements = {
        modalTitle: document.getElementById("modalTitle"),
        formAction: document.getElementById("formAction"),
        vehicleId: document.getElementById("vehicleId"),
        registrationNumber: document.getElementById("registrationNumber"),
        model: document.getElementById("model"),
        capacity: document.getElementById("capacity"),
      };

      // Check if all elements exist before setting values
      if (Object.values(elements).every((element) => element)) {
        elements.modalTitle.textContent = "Edit Vehicle";
        elements.formAction.value = "edit";
        elements.vehicleId.value = vehicle.id;
        elements.registrationNumber.value = vehicle.registrationNumber;
        elements.model.value = vehicle.model;
        elements.capacity.value = vehicle.capacity;
        modal.style.display = "block";
      } else {
        throw new Error("Required form elements not found");
      }
    })
    .catch((error) => {
      console.error("Error:", error);
      alert("Error loading vehicle details");
    });
}

function deleteVehicle(vehicleId) {
  if (confirm("Are you sure you want to delete this vehicle?")) {
    const formData = new FormData();
    formData.append("action", "delete");
    formData.append("vehicleId", vehicleId);

    fetch("../VehicleServlet", {
      method: "POST",
      body: new URLSearchParams(formData),
    })
      .then((response) => response.text())
      .then((result) => {
        if (result === "success") {
          location.reload();
        } else {
          alert("Failed to delete vehicle: " + result);
        }
      })
      .catch((error) => {
        console.error("Error:", error);
        alert("Error deleting vehicle");
      });
  }
}

function filterTable() {
  const input = document.getElementById("searchInput");
  const filter = input.value.toLowerCase();
  const rows = document
    .getElementById("vehiclesTable")
    .getElementsByTagName("tr");

  Array.from(rows)
    .slice(1)
    .forEach((row) => {
      const cells = row.getElementsByTagName("td");
      if (cells.length >= 2) {
        const regText = cells[1].textContent.toLowerCase();
        const modelText = cells[2].textContent.toLowerCase();
        row.style.display =
          regText.includes(filter) || modelText.includes(filter) ? "" : "none";
      }
    });
}

function closeModal() {
  const modal = document.getElementById("vehicleModal");
  if (modal) {
    modal.style.display = "none";
    const form = document.getElementById("vehicleForm");
    if (form) form.reset();
  }
}

// Initialize everything when DOM is loaded
document.addEventListener("DOMContentLoaded", function () {
  // Add form submit handler
  const vehicleForm = document.getElementById("vehicleForm");
  if (vehicleForm) {
    vehicleForm.addEventListener("submit", function (e) {
      e.preventDefault();
      const formData = new FormData(this);

      fetch("../VehicleServlet", {
        method: "POST",
        body: new URLSearchParams(formData),
      })
        .then((response) => response.text())
        .then((result) => {
          if (result === "success") {
            closeModal();
            location.reload();
          } else {
            alert(
              result.includes("error:")
                ? result
                : "Failed to save vehicle details"
            );
          }
        })
        .catch((error) => {
          console.error("Error:", error);
          alert("An error occurred while saving");
        });
    });
  }

  // Add modal close handlers
  const closeBtn = document.querySelector(".close");
  const cancelBtn = document.querySelector(".cancel-btn");
  const modal = document.getElementById("vehicleModal");

  if (closeBtn) closeBtn.addEventListener("click", closeModal);
  if (cancelBtn) cancelBtn.addEventListener("click", closeModal);
  if (modal) {
    window.onclick = (e) => {
      if (e.target === modal) closeModal();
    };
  }

  // Add search handler
  const searchInput = document.getElementById("searchInput");
  if (searchInput) {
    searchInput.addEventListener("input", filterTable);
  }
});

// Make functions globally available
window.openVehicleModal = openVehicleModal;
window.editVehicle = editVehicle;
window.deleteVehicle = deleteVehicle;
window.closeModal = closeModal;
window.filterTable = filterTable;

document.addEventListener("DOMContentLoaded", function () {
  const modal = document.getElementById("vehicleModal");
  const form = document.getElementById("vehicleForm");

  if (!modal || !form) {
    console.error("Required elements not found");
    return;
  }

  // Add button click handler
  document
    .getElementById("addVehicleBtn")
    .addEventListener("click", function () {
      document.getElementById("modalTitle").textContent = "Add New Vehicle";
      document.getElementById("formAction").value = "add";
      document.getElementById("vehicleId").value = "";
      form.reset();
      modal.style.display = "block";
    });

  // Edit button click handlers
  document.querySelectorAll(".edit-btn").forEach((button) => {
    button.addEventListener("click", function () {
      const vehicleId = this.getAttribute("data-id");
      if (!vehicleId) return;

      fetch(`../VehicleServlet?action=get&vehicleId=${vehicleId}`)
        .then((response) => response.json())
        .then((vehicle) => {
          document.getElementById("modalTitle").textContent = "Edit Vehicle";
          document.getElementById("formAction").value = "edit";
          document.getElementById("vehicleId").value = vehicle.id;
          document.getElementById("registrationNumber").value =
            vehicle.registrationNumber;
          document.getElementById("model").value = vehicle.model;
          document.getElementById("capacity").value = vehicle.capacity;
          modal.style.display = "block";
        })
        .catch((error) => {
          console.error("Error:", error);
          alert("Error loading vehicle details");
        });
    });
  });

  // Delete button click handlers
  document.querySelectorAll(".delete-btn").forEach((button) => {
    button.addEventListener("click", function () {
      const vehicleId = this.getAttribute("data-id");
      if (!vehicleId) return;

      if (confirm("Are you sure you want to delete this vehicle?")) {
        const formData = new FormData();
        formData.append("action", "delete");
        formData.append("vehicleId", vehicleId);

        fetch("../VehicleServlet", {
          method: "POST",
          body: new URLSearchParams(formData),
        })
          .then((response) => response.text())
          .then((result) => {
            if (result === "success") {
              location.reload();
            } else {
              alert("Failed to delete vehicle: " + result);
            }
          })
          .catch((error) => {
            console.error("Error:", error);
            alert("Error deleting vehicle");
          });
      }
    });
  });

  // Form submission
  form.addEventListener("submit", function (e) {
    e.preventDefault();
    const formData = new FormData(this);

    fetch("../VehicleServlet", {
      method: "POST",
      body: new URLSearchParams(formData),
    })
      .then((response) => response.text())
      .then((result) => {
        if (result === "success") {
          modal.style.display = "none";
          location.reload();
        } else {
          alert(
            result.includes("error:")
              ? result
              : "Failed to save vehicle details"
          );
        }
      })
      .catch((error) => {
        console.error("Error:", error);
        alert("An error occurred while saving");
      });
  });

  // Modal close handlers
  const closeBtn = document.querySelector(".close");
  const cancelBtn = document.querySelector(".cancel-btn");

  if (closeBtn) {
    closeBtn.addEventListener("click", () => {
      modal.style.display = "none";
      form.reset();
    });
  }

  if (cancelBtn) {
    cancelBtn.addEventListener("click", () => {
      modal.style.display = "none";
      form.reset();
    });
  }

  // Close modal when clicking outside
  window.addEventListener("click", function (e) {
    if (e.target === modal) {
      modal.style.display = "none";
      form.reset();
    }
  });

  // Search functionality
  document
    .getElementById("searchInput")
    ?.addEventListener("input", function () {
      const filter = this.value.toLowerCase();
      const rows = document.querySelectorAll("#vehiclesTable tbody tr");

      rows.forEach((row) => {
        const cells = row.getElementsByTagName("td");
        if (cells.length >= 3) {
          const regText = cells[1].textContent.toLowerCase();
          const modelText = cells[2].textContent.toLowerCase();
          row.style.display =
            regText.includes(filter) || modelText.includes(filter)
              ? ""
              : "none";
        }
      });
    });
});
