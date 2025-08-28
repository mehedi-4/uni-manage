<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String courseCode = request.getParameter("courseCode");
    if(courseCode != null && !courseCode.isEmpty()) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/student_info", "root", "iammhe");

            String sql = "SELECT s.reg, s.name FROM students s " +
                         "JOIN course_registration cr ON s.reg = cr.student_reg " +
                         "WHERE cr.course_code = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, courseCode);
            rs = ps.executeQuery();

            out.println("<ul>");
            while(rs.next()) {
                out.println("<li>" + rs.getString("reg") + " - " + rs.getString("name") + "</li>");
            }
            out.println("</ul>");
        } catch(Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        } finally {
            if(rs != null) rs.close();
            if(ps != null) ps.close();
            if(conn != null) conn.close();
        }
    }
%>
