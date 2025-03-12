document.addEventListener("DOMContentLoaded", function () {
  // Sidebar toggle functionality
  const sidebarToggle = document.getElementById("sidebar-toggle");
  const sidebar = document.querySelector(".sidebar");
  const mainContent = document.querySelector(".main-content");

  sidebarToggle.addEventListener("click", () => {
    sidebar.classList.toggle("active");
  });

  // Close sidebar when clicking outside on mobile
  document.addEventListener("click", (e) => {
    if (window.innerWidth <= 768) {
      if (
        !e.target.closest(".sidebar") &&
        !e.target.closest("#sidebar-toggle")
      ) {
        sidebar.classList.remove("active");
      }
    }
  });

  // Active navigation item
  const navItems = document.querySelectorAll(".nav-item");
  navItems.forEach((item) => {
    if (item.href === window.location.href) {
      item.classList.add("active");
    }
  });
});
