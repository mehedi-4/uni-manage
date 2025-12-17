import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class TeacherPortalServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("reg") == null) {
            response.sendRedirect("teacher.jsp");
            return;
        }
        String teacherReg = (String) session.getAttribute("reg");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/student_info?useSSL=false", "root", "iammhe");

            // Get teacher name
            String nameSql = "SELECT name FROM teachers WHERE reg = ?";
            PreparedStatement ps = conn.prepareStatement(nameSql);
            ps.setString(1, teacherReg);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                request.setAttribute("teacherName", rs.getString("name"));
            }
            rs.close();
            ps.close();

            // Get assigned courses
            String courseSql = "SELECT c.code, c.title FROM courses c JOIN course_assignments ca ON c.code = ca.course_code WHERE ca.teacher_reg = ?";
            ps = conn.prepareStatement(courseSql);
            ps.setString(1, teacherReg);
            rs = ps.executeQuery();
            List<String[]> assignedCourses = new ArrayList<>();
            while (rs.next()) {
                assignedCourses.add(new String[]{rs.getString("code"), rs.getString("title")});
            }
            rs.close();
            ps.close();
            conn.close();

            request.setAttribute("assignedCourses", assignedCourses);
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
        }

        request.getRequestDispatcher("teacherportal.jsp").forward(request, response);
    }
}
