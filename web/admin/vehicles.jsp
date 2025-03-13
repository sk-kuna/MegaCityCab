<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="util.DBConnection"%>
<% 
    if (session.getAttribute("userType") == null || !session.getAttribute("userType").equals("ADMIN")) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Vehicle Management</title>
        <link rel="stylesheet" href="../css/style.css">
        <link rel="stylesheet" href="../css/admin.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            .content { padding: 20px; }
            .header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }
            .btn-add {
                padding: 10px 20px;
                background: #4CAF50;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }
            .table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            .table th, .table td {
                padding: 12px;
                text-align: left;
                border-bottom: 1px solid #ddd;
            }
            .btn-edit { background: #2196F3; }
            .btn-delete { background: #f44336; }
            .btn-edit, .btn-delete {
                padding: 5px 10px;
                color: white;
                border: none;
                border-radius: 3px;
                cursor: pointer;
                margin: 0 5px;
            }
            .modal {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.5);
            }
            .modal-content {
                background: white;
                margin: 15% auto;
                padding: 20px;
                width: 70%;
                max-width: 500px;
                border-radius: 5px;
            }
            .form-group {
                margin-bottom: 15px;
            }
            .form-group label {
                display: block;
                margin-bottom: 5px;
            }
            .form-group input {
                width: 100%;
                padding: 8px;
                border: 1px solid #ddd;
                border-radius: 4px;
            }
            .btn-save {
                background: #4CAF50;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }
        </style>
    </head>
    <body>
        <div class="admin-container">
            <%@ include file="includes/sidebar.jsp" %>
            <div class="main-content">
                <%@ include file="includes/topbar.jsp" %>
                
                <div class="content">
                    <div class="header">
                        <h2>Vehicle Management</h2>
                        <button onclick="showModal()" class="btn-add">Add New Vehicle</button>
                    </div>
                    
                    <table class="table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Registration Number</th>
                                <th>Model</th>
                                <th>Capacity</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                try {
                                    Connection conn = DBConnection.getConnection();
                                    Statement stmt = conn.createStatement();
                                    ResultSet rs = stmt.executeQuery("SELECT * FROM vehicles");
                                    
                                    while(rs.next()) {
                            %>
                                <tr>
                                    <td><%= rs.getInt("vehicle_id") %></td>
                                    <td><%= rs.getString("registration_number") %></td>
                                    <td><%= rs.getString("model") %></td>
                                    <td><%= rs.getInt("capacity") %></td>
                                    <td>
                                        <button type="button" onclick="editVehicle(<%= rs.getInt("vehicle_id") %>)" class="btn-edit">
                                            <i class="fas fa-edit"></i> Edit
                                        </button>
                                        <button type="button" onclick="deleteVehicle(<%= rs.getInt("vehicle_id") %>)" class="btn-delete">
                                            <i class="fas fa-trash"></i> Delete
                                        </button>
                                    </td>
                                </tr>
                            <%
                                    }
                                    rs.close();
                                    stmt.close();
                                    conn.close();
                                } catch(Exception e) {
                                    out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                
                <!-- Modal -->
                <div id="vehicleModal" class="modal">
                    <div class="modal-content">
                        <h2 id="modalTitle">Add New Vehicle</h2>
                        <form id="vehicleForm" onsubmit="handleSubmit(event)">
                            <input type="hidden" id="vehicleId" name="vehicleId">
                            <input type="hidden" id="action" name="action" value="add">
                            
                            <div class="form-group">
                                <label>Registration Number</label>
                                <input type="text" id="regNumber" name="registrationNumber" required>
                            </div>
                            
                            <div class="form-group">
                                <label>Model</label>
                                <input type="text" id="model" name="model" required>
                            </div>
                            
                            <div class="form-group">
                                <label>Capacity</label>
                                <input type="number" id="capacity" name="capacity" required min="1">
                            </div>
                            
                            <div class="form-buttons">
                                <button type="submit" class="btn-save">Save Changes</button>
                                <button type="button" onclick="closeModal()" class="btn-delete">Cancel</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        
        <script>
            function showModal() {
                document.getElementById('modalTitle').textContent = 'Add New Vehicle';
                document.getElementById('action').value = 'add';
                document.getElementById('vehicleForm').reset();
                document.getElementById('vehicleModal').style.display = 'block';
            }
            
            function closeModal() {
                document.getElementById('vehicleModal').style.display = 'none';
                document.getElementById('vehicleForm').reset();
            }
            
            function editVehicle(id) {
                fetch('../VehicleServlet?action=get&vehicleId=' + id)
                    .then(response => response.json())
                    .then(data => {
                        // Set form values
                        document.getElementById('vehicleId').value = data.id;
                        document.getElementById('regNumber').value = data.registrationNumber;
                        document.getElementById('model').value = data.model;
                        document.getElementById('capacity').value = data.capacity;
                        
                        // Update form for edit mode
                        document.getElementById('modalTitle').textContent = 'Edit Vehicle';
                        document.getElementById('action').value = 'edit';
                        
                        // Show modal
                        document.getElementById('vehicleModal').style.display = 'block';
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Could not load vehicle details. Please try again.');
                    });
            }
            
            function handleSubmit(event) {
                event.preventDefault();
                const formData = new FormData(event.target);
                
                fetch('../VehicleServlet', {
                    method: 'POST',
                    body: new URLSearchParams(formData)
                })
                .then(response => response.text())
                .then(result => {
                    if(result === 'success') {
                        closeModal();
                        location.reload();
                    } else {
                        alert('Error: ' + result);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error saving vehicle data');
                });
            }
            
            function deleteVehicle(id) {
                if (confirm('Are you sure you want to delete this vehicle?')) {
                    fetch('../VehicleServlet', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: 'action=delete&vehicleId=' + id
                    })
                    .then(response => response.text())
                    .then(result => {
                        if (result === 'success') {
                            window.location.reload();
                        } else {
                            alert('Error deleting vehicle');
                        }
                    })
                    .catch(() => {
                        alert('Error deleting vehicle');
                    });
                }
            }

            // Close modal when clicking outside
            window.onclick = function(event) {
                if (event.target == document.getElementById('vehicleModal')) {
                    closeModal();
                }
            }
        </script>
    </body>
</html>
