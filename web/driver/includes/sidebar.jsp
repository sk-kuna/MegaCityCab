<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <style>
        /* General Styles */
body {
    font-family: 'Poppins', sans-serif;
    margin: 0;
    padding: 0;
    display: flex;
    height: 100vh;
    background: linear-gradient(135deg, #1e3c72, #2a5298);
}

/* Sidebar */
.sidebar {
    width: 250px;
    height: 100vh;
    background: linear-gradient(180deg, #007bff, #00c6ff);
    color: white;
    display: flex;
    flex-direction: column;
    align-items: center;
    padding-top: 20px;
    box-shadow: 4px 0px 10px rgba(0, 0, 0, 0.2);
}

/* Sidebar Header */
.sidebar-header {
    text-align: center;
    margin-bottom: 30px;
}

.logo-img {
    width: 100px;
    height: auto;
}

.sidebar-header h2 {
    margin: 10px 0 0;
    font-size: 20px;
    font-weight: bold;
}

/* Navigation */
.sidebar-nav {
    width: 100%;
    display: flex;
    flex-direction: column;
    align-items: center;
}

.nav-item {
    display: flex;
    align-items: center;
    width: 80%;
    padding: 12px 15px;
    text-decoration: none;
    color: white;
    font-size: 16px;
    font-weight: bold;
    border-radius: 8px;
    transition: 0.3s ease;
}

.nav-item i {
    margin-right: 10px;
    font-size: 18px;
}

/* Hover and Active Effects */
.nav-item:hover,
.nav-item.active {
    background: linear-gradient(90deg, #00c6ff, #007bff);
    box-shadow: 0px 4px 8px rgba(255, 255, 255, 0.3);
    transform: translateX(5px);
}

    </style>
</head>
<body>
    <div class="sidebar">
        <div class="sidebar-header">
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


