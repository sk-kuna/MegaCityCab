<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <div class="sidebar">
        <div class="sidebar-header">
            <img src="../images/logo.png" alt="MegaCity Cab" class="logo-img">
            <h2>Driver Portal</h2>
        </div>
        <nav class="sidebar-nav">
            <a href="dashboard.jsp" class="nav-item <%= request.getRequestURI().endsWith("dashboard.jsp") ? "active" : "" %>">
                <i class="fas fa-home"></i>
                <span>Dashboard</span>
            </a>
            <a href="active-rides.jsp" class="nav-item <%= request.getRequestURI().endsWith("active-rides.jsp") ? "active" : "" %>">
                <i class="fas fa-taxi"></i>
                <span>Active Rides</span>
            </a>
            <a href="ride-history.jsp" class="nav-item <%= request.getRequestURI().endsWith("ride-history.jsp") ? "active" : "" %>">
                <i class="fas fa-history"></i>
                <span>Ride History</span>
            </a>
        </nav>
    </div>
</body>
</html>


