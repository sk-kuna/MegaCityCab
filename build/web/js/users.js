// Modal functionality
const modal = document.getElementById("userModal");
const closeBtn = document.querySelector(".close");

function showAddUserForm() {
  document.getElementById("modalTitle").textContent = "Add New User";
  document.getElementById("formAction").value = "add";
  document.getElementById("userId").value = "";
  document.getElementById("userForm").reset();
  modal.style.display = "block";
}

function editUser(userId) {
  document.getElementById("modalTitle").textContent = "Edit User";
  document.getElementById("formAction").value = "edit";
  document.getElementById("userId").value = userId;

  // Fetch user data and populate form
  fetch(`../UserServlet?action=get&userId=${userId}`)
    .then((response) => response.json())
    .then((user) => {
      const form = document.getElementById("userForm");
      form.username.value = user.username;
      form.name.value = user.name;
      form.email.value = user.email;
      form.phone.value = user.phone;
      form.userType.value = user.userType;
    });

  modal.style.display = "block";
}

function deleteUser(userId) {
  if (confirm("Are you sure you want to delete this user?")) {
    fetch(`../UserServlet?action=delete&userId=${userId}`, {
      method: "POST",
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.success) {
          location.reload();
        } else {
          alert("Failed to delete user");
        }
      });
  }
}

// Close modal when clicking X or outside
closeBtn.onclick = () => (modal.style.display = "none");
window.onclick = (e) => {
  if (e.target == modal) modal.style.display = "none";
};

// Search and filter functionality
document.getElementById("searchUser").addEventListener("input", filterUsers);
document
  .getElementById("userTypeFilter")
  .addEventListener("change", filterUsers);

function filterUsers() {
  const searchText = document.getElementById("searchUser").value.toLowerCase();
  const userType = document.getElementById("userTypeFilter").value;
  const rows = document
    .getElementById("usersTableBody")
    .getElementsByTagName("tr");

  for (let row of rows) {
    const name = row.cells[2].textContent.toLowerCase();
    const type = row.cells[5].textContent.trim();
    const matchesSearch = name.includes(searchText);
    const matchesType = !userType || type === userType;

    row.style.display = matchesSearch && matchesType ? "" : "none";
  }
}
