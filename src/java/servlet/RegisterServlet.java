package servlet;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.sql.*;
import util.DBConnection;

public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String nic = request.getParameter("nic");
        String userType = "CUSTOMER"; // Fixed as CUSTOMER
        
        try {
            Connection conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            try {
                // Check if username or email already exists
                String checkSql = "SELECT COUNT(*) FROM users WHERE username = ? OR email = ?";
                PreparedStatement checkStmt = conn.prepareStatement(checkSql);
                checkStmt.setString(1, username);
                checkStmt.setString(2, email);
                ResultSet rs = checkStmt.executeQuery();
                rs.next();
                if (rs.getInt(1) > 0) {
                    request.setAttribute("error", "Username or email already exists");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    return;
                }
                
                // Insert new user
                String sql = "INSERT INTO users (username, password, email, name, address, phone, nic, user_type, created_at) " +
                            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())";
                
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, username);
                stmt.setString(2, password); // In production, hash the password
                stmt.setString(3, email);
                stmt.setString(4, name);
                stmt.setString(5, address);
                stmt.setString(6, phone);
                stmt.setString(7, nic);
                stmt.setString(8, userType);
                
                int result = stmt.executeUpdate();
                
                if(result > 0) {
                    conn.commit(); // Commit transaction
                    response.sendRedirect("login.jsp?registered=true");
                } else {
                    conn.rollback(); // Rollback on failure
                    request.setAttribute("error", "Registration failed");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
                
                stmt.close();
                
            } catch(SQLException e) {
                conn.rollback(); // Rollback on exception
                throw e;
            } finally {
                conn.setAutoCommit(true); // Reset auto-commit
                conn.close();
            }
            
        } catch(SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
