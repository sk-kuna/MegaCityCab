<div class="top-nav">
  <div class="nav-left">
    <button id="sidebar-toggle" class="menu-toggle">
      <i class="fas fa-bars"></i>
    </button>
    <h1>Dashboard</h1>
  </div>
  <div class="nav-right">
    <div class="admin-profile">
      <span>Welcome, ${username}</span>
      <form action="../LogoutServlet" method="post" class="logout-form">
        <button type="submit" class="logout-btn">
          <i class="fas fa-sign-out-alt"></i> Logout
        </button>
      </form>
    </div>
  </div>
</div>
