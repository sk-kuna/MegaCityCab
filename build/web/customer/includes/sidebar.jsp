<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
  <style>
    /* Sidebar styling */
.sidebar {
  width: 250px;
  height: 100vh;
  position: fixed;
  left: 0;
  top: 0;
  background: linear-gradient(135deg, #2c3e50, #1a1e2c);
  color: white;
  box-shadow: 2px 0 10px rgba(0, 0, 0, 0.2);
  z-index: 100;
  transition: all 0.3s ease;
}

/* Sidebar header */
.sidebar-header {
  padding: 20px;
  text-align: center;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.sidebar-header h2 {
  margin: 0;
  font-size: 24px;
  font-weight: 600;
  color: #fff;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);
  letter-spacing: 0.5px;
}

/* Sidebar navigation */
.sidebar-nav {
  padding: 20px 0;
}

.nav-item {
  display: flex;
  align-items: center;
  padding: 14px 20px;
  color: rgba(255, 255, 255, 0.8);
  text-decoration: none;
  transition: all 0.3s ease;
  border-left: 4px solid transparent;
}

.nav-item:hover {
  background: linear-gradient(to right, rgba(255, 255, 255, 0.1), transparent);
  color: white;
  border-left-color: #ff7e5f;
}

.nav-item.active {
  background: linear-gradient(to right, rgba(255, 255, 255, 0.15), transparent);
  color: white;
  border-left-color: #ff7e5f;
}

.nav-item i {
  margin-right: 15px;
  font-size: 18px;
  width: 20px;
  text-align: center;
}

/* Responsive adjustments */
@media (max-width: 992px) {
  .sidebar {
    width: 100%;
    height: auto;
    position: relative;
  }
  
  .sidebar-nav {
    display: flex;
    padding: 10px;
    justify-content: space-around;
  }
  
  .nav-item {
    flex-direction: column;
    padding: 10px;
    text-align: center;
    border-left: none;
    border-bottom: 3px solid transparent;
  }
  
  .nav-item:hover,
  .nav-item.active {
    border-left-color: transparent;
    border-bottom-color: #ff7e5f;
  }
  
  .nav-item i {
    margin: 0 0 8px 0;
    font-size: 20px;
  }
}

@media (max-width: 576px) {
  .sidebar-header h2 {
    font-size: 20px;
  }
  
  .nav-item {
    padding: 8px;
    font-size: 14px;
  }
  
  .nav-item i {
    font-size: 18px;
  }
}

/* Main content adjustment to accommodate fixed sidebar */
.main-content {
  margin-left: 250px;
  transition: margin 0.3s ease;
}

@media (max-width: 992px) {
  .main-content {
    margin-left: 0;
  }
}

/* Active page indicator animation */
.nav-item.active i {
  animation: pulse 1.5s infinite;
}

@keyframes pulse {
  0% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.1);
  }
  100% {
    transform: scale(1);
  }
}
  </style>
</head>
<body>
  <div class="sidebar">
    <div class="sidebar-header">
      <h2>MegaCity Cab</h2>
    </div>
    <nav class="sidebar-nav">
      <a href="dashboard.jsp" class="nav-item">
        <i class="fas fa-home"></i> Dashboard
      </a>
      <a href="book-ride.jsp" class="nav-item">
        <i class="fas fa-taxi"></i> Book a Ride
      </a>
      <a href="my-rides.jsp" class="nav-item">
        <i class="fas fa-history"></i> My Rides
      </a>
    </nav>
  </div>
</body>
</html>

