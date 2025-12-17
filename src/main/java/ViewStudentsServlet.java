import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ViewStudentsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("reg") == null) {
            response.sendRedirect("teacher.jsp");
            return;
        }

        String courseCode = request.getParameter("courseCode");
        if (courseCode != null && !courseCode.isEmpty()) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/student_info?useSSL=false", "root", "iammhe");

                String sql = "SELECT s.reg, s.name FROM students s JOIN course_registration cr ON s.reg = cr.student_reg WHERE cr.course_code = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, courseCode);
                ResultSet rs = ps.executeQuery();

                List<String[]> students = new ArrayList<>();
                while (rs.next()) {
                    students.add(new String[]{rs.getString("reg"), rs.getString("name")});
                }
                rs.close();
                ps.close();
                conn.close();

                request.setAttribute("students", students);
                request.setAttribute("courseCode", courseCode);
            } catch (Exception e) {
                request.setAttribute("error", "Error: " + e.getMessage());
            }
        } else {
            request.setAttribute("error", "Invalid course code.");
        }

        request.getRequestDispatcher("viewStudents.jsp").forward(request, response);
    }
}
