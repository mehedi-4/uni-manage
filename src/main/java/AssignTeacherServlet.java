import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AssignTeacherServlet extends HttpServlet {
    private void loadData(HttpServletRequest request) throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/student_info?useSSL=false", "root", "iammhe");

        Statement stmtCourses = conn.createStatement();
        ResultSet rsCourses = stmtCourses.executeQuery("SELECT code, title FROM courses");
        List<String[]> courses = new ArrayList<>();
        while (rsCourses.next()) {
            courses.add(new String[]{rsCourses.getString("code"), rsCourses.getString("title")});
        }
        rsCourses.close();
        stmtCourses.close();

        Statement stmtTeachers = conn.createStatement();
        ResultSet rsTeachers = stmtTeachers.executeQuery("SELECT reg, name FROM teachers");
        List<String[]> teachers = new ArrayList<>();
        while (rsTeachers.next()) {
            teachers.add(new String[]{rsTeachers.getString("reg"), rsTeachers.getString("name")});
        }
        rsTeachers.close();
        stmtTeachers.close();
        conn.close();

        request.setAttribute("courses", courses);
        request.setAttribute("teachers", teachers);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("reg") == null) {
            response.sendRedirect("admin.jsp");
            return;
        }
        try {
            loadData(request);
        } catch (Exception e) {
            request.setAttribute("error", "DB Error: " + e.getMessage());
        }
        request.getRequestDispatcher("assignTeacher.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("reg") == null) {
            response.sendRedirect("admin.jsp");
            return;
        }

        String courseCode = request.getParameter("courseCode");
        String teacherReg = request.getParameter("teacherReg");
        String message = null;
        String error = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/student_info?useSSL=false", "root", "iammhe");

            if (courseCode != null && teacherReg != null && !courseCode.isEmpty() && !teacherReg.isEmpty()) {
                String checkSql = "SELECT COUNT(*) FROM course_assignments WHERE course_code = ?";
                PreparedStatement checkStmt = conn.prepareStatement(checkSql);
                checkStmt.setString(1, courseCode);
                ResultSet rs = checkStmt.executeQuery();
                rs.next();
                int count = rs.getInt(1);
                rs.close();
                checkStmt.close();

                if (count > 0) {
                    error = "This course is already assigned to a teacher!";
                } else {
                    String sql = "INSERT INTO course_assignments (course_code, teacher_reg) VALUES (?, ?)";
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    stmt.setString(1, courseCode);
                    stmt.setString(2, teacherReg);
                    stmt.executeUpdate();
                    stmt.close();
                    message = "Teacher assigned successfully!";
                }
            } else {
                error = "Please select both fields!";
            }
            conn.close();
            
            loadData(request); // Reload dropdowns
        } catch (Exception e) {
            error = "Error: " + e.getMessage();
        }

        request.setAttribute("message", message);
        request.setAttribute("error", error);
        request.getRequestDispatcher("assignTeacher.jsp").forward(request, response);
    }
}
