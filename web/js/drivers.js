document.addEventListener("DOMContentLoaded", function () {
  initializeDriversPage();
});

function initializeDriversPage() {
  // Initialize modal and form references
  window.modal = document.getElementById("driverModal");
  window.driverForm = document.getElementById("driverForm");

  // Add form submit handler
  if (driverForm) {
    driverForm.addEventListener("submit", handleFormSubmit);
  }

  // Add modal close handlers
  const closeBtn = document.querySelector(".close");
  if (closeBtn) {
    closeBtn.addEventListener("click", closeModal);
  }

  const cancelBtn = document.querySelector(".cancel-btn");
  if (cancelBtn) {
    cancelBtn.addEventListener("click", closeModal);
  }

  // Close modal when clicking outside
  window.addEventListener("click", function (event) {
    if (event.target === modal) {
      closeModal();
    }
  });
}

function openDriverModal() {
  clearForm();
  document.getElementById("modalTitle").textContent = "Add New Driver";
  document.getElementById("formAction").value = "add";
  modal.style.display = "block";
}

function editDriver(driverId) {
  fetch(`../DriverServlet?action=get&driverId=${driverId}`)
    .then((response) => response.json())
    .then((driver) => {
      document.getElementById("modalTitle").textContent = "Edit Driver";
      document.getElementById("formAction").value = "edit";
      document.getElementById("driverId").value = driver.id;
      document.getElementById("name").value = driver.name;
      document.getElementById("email").value = driver.email;
      document.getElementById("phone").value = driver.phone || "";
      modal.style.display = "block";
    })
    .catch((error) => {
      console.error("Error:", error);
      alert("Error loading driver details");
    });
}

function confirmDelete(driverId) {
  if (confirm("Are you sure you want to delete this driver?")) {
    const formData = new FormData();
    formData.append("action", "delete");
    formData.append("driverId", driverId);

    fetch("../DriverServlet", {
      method: "POST",
      body: new URLSearchParams(formData),
    })
      .then((response) => response.text())
      .then((result) => {
        if (result === "success") {
          location.reload();
        } else {
          alert("Failed to delete driver: " + result);
        }
      })
      .catch((error) => {
        console.error("Error:", error);
        alert("Error deleting driver");
      });
  }
}

function handleFormSubmit(e) {
  e.preventDefault();
  const formData = new FormData(driverForm);

  fetch("../DriverServlet", {
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
          result.includes("error:") ? result : "Failed to save driver details"
        );
      }
    })
    .catch((error) => {
      console.error("Error:", error);
      alert("An error occurred while saving");
    });
}

function filterTable() {
  const input = document.getElementById("searchInput");
  const filter = input.value.toLowerCase();
  const rows = document
    .getElementById("driversTable")
    .getElementsByTagName("tr");

  for (let i = 1; i < rows.length; i++) {
    const nameCell = rows[i].getElementsByTagName("td")[1];
    if (nameCell) {
      const nameText = nameCell.textContent || nameCell.innerText;
      rows[i].style.display =
        nameText.toLowerCase().indexOf(filter) > -1 ? "" : "none";
    }
  }
}

function clearForm() {
  driverForm.reset();
  document.getElementById("driverId").value = "";
}

function closeModal() {
  modal.style.display = "none";
  clearForm();
}
