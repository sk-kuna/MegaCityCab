package servlet;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.sql.*;
import util.DBConnection;

public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String selectedRole = request.getParameter("userType");
        
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM users WHERE username = ? AND password = ? AND user_type = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);
            stmt.setString(3, selectedRole);
            
            ResultSet rs = stmt.executeQuery();
            
            if(rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("userId", rs.getInt("user_id"));
                session.setAttribute("username", rs.getString("username"));
                session.setAttribute("userType", rs.getString("user_type"));
                
                switch(selectedRole) {
                    case "ADMIN":
                        response.sendRedirect("admin/dashboard.jsp");
                        break;
                    case "CUSTOMER":
                        response.sendRedirect("customer/dashboard.jsp");
                        break;
                    case "DRIVER":
                        response.sendRedirect("driver/dashboard.jsp");
                        break;
                }
            } else {
                request.setAttribute("error", "Invalid credentials or unauthorized role access");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
            
            rs.close();
            stmt.close();
            conn.close();
            
        } catch(SQLException e) {
            throw new ServletException(e);
        }
    }
}
