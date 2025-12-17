import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class StudentPortalServlet extends HttpServlet {
    private void loadData(HttpServletRequest request, String studentReg) throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/student_info?useSSL=false", "root", "iammhe");

        // Fetch student name
        PreparedStatement psName = conn.prepareStatement("SELECT name FROM students WHERE reg = ?");
        psName.setString(1, studentReg);
        ResultSet rsName = psName.executeQuery();
        if (rsName.next()) {
            request.setAttribute("studentName", rsName.getString("name"));
        }
        rsName.close();
        psName.close();

        // Fetch all semesters
        Statement stmtSem = conn.createStatement();
        ResultSet rsSem = stmtSem.executeQuery("SELECT DISTINCT semester FROM courses ORDER BY semester");
        List<String> semesters = new ArrayList<>();
        while (rsSem.next()) { semesters.add(rsSem.getString("semester")); }
        rsSem.close();
        stmtSem.close();
        request.setAttribute("semesters", semesters);

        // Fetch courses
        Statement stmtCourses = conn.createStatement();
        ResultSet rsCourses = stmtCourses.executeQuery("SELECT code, title, semester FROM courses ORDER BY semester, code");
        List<String[]> courses = new ArrayList<>();
        while (rsCourses.next()) {
            courses.add(new String[]{rsCourses.getString("code"), rsCourses.getString("title"), rsCourses.getString("semester")});
        }
        rsCourses.close();
        stmtCourses.close();
        request.setAttribute("courses", courses);

        // Fetch registered courses for student
        String sql = "SELECT c.code, c.title, c.semester FROM course_registration r JOIN courses c ON r.course_code = c.code WHERE r.student_reg = ?";
        PreparedStatement stmtReg = conn.prepareStatement(sql);
        stmtReg.setString(1, studentReg);
        ResultSet rsReg = stmtReg.executeQuery();
        List<String[]> registered = new ArrayList<>();
        while (rsReg.next()) { registered.add(new String[]{rsReg.getString("code"), rsReg.getString("title"), rsReg.getString("semester")}); }
        rsReg.close();
        stmtReg.close();
        request.setAttribute("registered", registered);

        conn.close();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("reg") == null) {
            response.sendRedirect("student.jsp");
            return;
        }
        try {
            loadData(request, (String) session.getAttribute("reg"));
        } catch (Exception e) {
            request.setAttribute("error", "DB Error: " + e.getMessage());
        }
        request.getRequestDispatcher("studentportal.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("reg") == null) {
            response.sendRedirect("student.jsp");
            return;
        }
        String studentReg = (String) session.getAttribute("reg");
        String message = null;
        String error = null;

        if (request.getParameter("registerCourses") != null) {
            String semester = request.getParameter("semester");
            String[] selectedCourses = request.getParameterValues("courses");
            if (semester != null && selectedCourses != null) {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/student_info?useSSL=false", "root", "iammhe");
                    
                    for (String courseCode : selectedCourses) {
                        try {
                            String sql = "INSERT INTO course_registration (student_reg, course_code, semester) VALUES (?, ?, ?)";
                            PreparedStatement stmt = conn.prepareStatement(sql);
                            stmt.setString(1, studentReg);
                            stmt.setString(2, courseCode);
                            stmt.setString(3, semester);
                            stmt.executeUpdate();
                            stmt.close();
                        } catch (SQLIntegrityConstraintViolationException e) {
                            error = "You already registered for some of these courses.";
                        }
                    }
                    conn.close();
                    if (error == null) { message = "Courses registered successfully!"; }
                } catch (Exception e) {
                    error = "Error: " + e.getMessage();
                }
            } else {
                error = "Please select a semester and at least one course.";
            }
        }

        request.setAttribute("message", message);
        request.setAttribute("error", error);
        try {
            loadData(request, studentReg);
        } catch (Exception e) {
             // ignore or append to error
        }
        request.getRequestDispatcher("studentportal.jsp").forward(request, response);
    }
}
