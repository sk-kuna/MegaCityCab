package servlet;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.sql.*;
import java.text.SimpleDateFormat;
import util.DBConnection;

public class ReportServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        switch(action) {
            case "getReportData":
                getReportData(request, response);
                break;
            case "download":
                downloadReport(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
    
    private void getReportData(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        
        try {
            Connection conn = DBConnection.getConnection();
            StringBuilder jsonResponse = new StringBuilder("{");
            
            // Revenue statistics using correct payments table
            String revenueSql = "SELECT " +
                "COALESCE(SUM(p.total_amount), 0) as total_revenue, " +
                "COUNT(DISTINCT b.booking_id) as total_bookings, " +
                "COALESCE(AVG(p.total_amount), 0) as avg_revenue, " +
                "COALESCE(SUM(p.discount_amount), 0) as total_discounts, " +
                "COALESCE(SUM(p.tax_amount), 0) as total_tax " +
                "FROM bookings b " +
                "LEFT JOIN payments p ON b.booking_id = p.booking_id " +
                "WHERE b.booking_time BETWEEN ? AND ? " +
                "AND p.payment_status = 'COMPLETED'";
            
            PreparedStatement revenueStmt = conn.prepareStatement(revenueSql);
            revenueStmt.setString(1, startDate);
            revenueStmt.setString(2, endDate);
            ResultSet revenueRs = revenueStmt.executeQuery();
            
            if(revenueRs.next()) {
                jsonResponse.append("\"revenue\":{");
                jsonResponse.append("\"total\":").append(revenueRs.getDouble("total_revenue")).append(",");
                jsonResponse.append("\"bookings\":").append(revenueRs.getInt("total_bookings")).append(",");
                jsonResponse.append("\"average\":").append(revenueRs.getDouble("avg_revenue")).append(",");
                jsonResponse.append("\"discounts\":").append(revenueRs.getDouble("total_discounts")).append(",");
                jsonResponse.append("\"tax\":").append(revenueRs.getDouble("total_tax"));
                jsonResponse.append("},");
            }
            
            // Booking status statistics
            String statusSql = "SELECT status, COUNT(*) as count " +
                             "FROM bookings WHERE booking_time BETWEEN ? AND ? " +
                             "GROUP BY status";
            
            PreparedStatement statusStmt = conn.prepareStatement(statusSql);
            statusStmt.setString(1, startDate);
            statusStmt.setString(2, endDate);
            ResultSet statusRs = statusStmt.executeQuery();
            
            jsonResponse.append("\"bookingStatus\":{");
            while(statusRs.next()) {
                jsonResponse.append("\"").append(statusRs.getString("status")).append("\":");
                jsonResponse.append(statusRs.getInt("count")).append(",");
            }
            jsonResponse.setLength(jsonResponse.length() - 1); // Remove last comma
            jsonResponse.append("},");
            
            // Driver performance with payment details
            String driverSql = "SELECT u.name, " +
                "COUNT(b.booking_id) as total_trips, " +
                "AVG(d.rating) as avg_rating, " +
                "COALESCE(SUM(p.total_amount), 0) as total_revenue " +
                "FROM users u " +
                "JOIN driver_details d ON u.user_id = d.driver_id " +
                "LEFT JOIN bookings b ON d.driver_id = b.driver_id " +
                "LEFT JOIN payments p ON b.booking_id = p.booking_id " +
                "WHERE b.booking_time BETWEEN ? AND ? " +
                "AND p.payment_status = 'COMPLETED' " +
                "GROUP BY u.user_id " +
                "ORDER BY total_revenue DESC " +
                "LIMIT 5";
            
            PreparedStatement driverStmt = conn.prepareStatement(driverSql);
            driverStmt.setString(1, startDate);
            driverStmt.setString(2, endDate);
            ResultSet driverRs = driverStmt.executeQuery();
            
            jsonResponse.append("\"driverStats\":[");
            while(driverRs.next()) {
                jsonResponse.append("{");
                jsonResponse.append("\"name\":\"").append(driverRs.getString("name")).append("\",");
                jsonResponse.append("\"trips\":").append(driverRs.getInt("total_trips")).append(",");
                jsonResponse.append("\"rating\":").append(driverRs.getDouble("avg_rating")).append(",");
                jsonResponse.append("\"revenue\":").append(driverRs.getDouble("total_revenue"));
                jsonResponse.append("},");
            }
            if(jsonResponse.charAt(jsonResponse.length() - 1) == ',') {
                jsonResponse.setLength(jsonResponse.length() - 1);
            }
            jsonResponse.append("]}");
            
            response.setContentType("application/json");
            response.getWriter().write(jsonResponse.toString());
            
            conn.close();
            
        } catch(SQLException e) {
            throw new ServletException(e);
        }
    }
    
    private void downloadReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String format = request.getParameter("format");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        
        if("pdf".equals(format)) {
            downloadPDFReport(response, startDate, endDate);
        } else if("excel".equals(format)) {
            downloadExcelReport(response, startDate, endDate);
        }
    }
    
    private void downloadPDFReport(HttpServletResponse response, String startDate, String endDate)
            throws ServletException, IOException {
        // PDF generation code will go here
        // You'll need to add a PDF library like iText or Apache PDFBox
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=report.pdf");
    }
    
    private void downloadExcelReport(HttpServletResponse response, String startDate, String endDate)
            throws ServletException, IOException {
        // Excel generation code will go here
        // You'll need to add Apache POI library for Excel generation
        response.setContentType("application/vnd.ms-excel");
        response.setHeader("Content-Disposition", "attachment; filename=report.xlsx");
    }
}
