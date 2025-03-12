package servlet;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.sql.*;
import util.DBConnection;

public class UpdateProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int userId = (int) session.getAttribute("userId");
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String nic = request.getParameter("nic");
        
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE users SET name=?, email=?, phone=?, address=?, nic=? WHERE user_id=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            
            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, phone);
            stmt.setString(4, address);
            stmt.setString(5, nic);
            stmt.setInt(6, userId);
            
            int result = stmt.executeUpdate();
            
            if(result > 0) {
                request.setAttribute("message", "Profile updated successfully!");
            } else {
                request.setAttribute("error", "Failed to update profile");
            }
            
            stmt.close();
            conn.close();
            
            response.sendRedirect("customer/profile.jsp");
            
        } catch(SQLException e) {
            throw new ServletException(e);
        }
    }
}
