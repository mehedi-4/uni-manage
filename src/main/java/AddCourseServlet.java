import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AddCourseServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("reg") == null) {
            response.sendRedirect("admin.jsp");
            return;
        }
        request.getRequestDispatcher("addcourse.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("reg") == null) {
            response.sendRedirect("admin.jsp");
            return;
        }

        String code = request.getParameter("code");
        String title = request.getParameter("title");
        String credit = request.getParameter("credit");
        String semester = request.getParameter("semester");
        String message = null;
        String error = null;

        if (code != null && title != null && credit != null && semester != null &&
            !code.isEmpty() && !title.isEmpty() && !credit.isEmpty() && !semester.isEmpty()) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/student_info?useSSL=false", "root", "iammhe");

                PreparedStatement stmt = conn.prepareStatement("INSERT INTO courses (code, title, credit, semester)"
                												+ "VALUES (?, ?, ?, ?)");
                stmt.setString(1, code);
                stmt.setString(2, title);
                stmt.setFloat(3, Float.parseFloat(credit));
                stmt.setString(4, semester);
                stmt.executeUpdate();

                message = "Course added successfully!";
                stmt.close(); conn.close();
            } catch (Exception e) {
                error = "Error: " + e.getMessage();
            }
        } else {
            error = "All fields are required!";
        }

        request.setAttribute("message", message);
        request.setAttribute("error", error);
        request.getRequestDispatcher("addcourse.jsp").forward(request, response);
    }
}
