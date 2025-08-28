import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin")
public class AdminLoginServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/student_info";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "iammhe";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String reg = req.getParameter("reg");
        String pass = req.getParameter("pass");

        System.out.println("Received login attempt: reg=" + reg + ", pass=" + pass); // Debug log

        try {
            // Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("JDBC Driver loaded successfully");

            // Establish database connection
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
                System.out.println("Database connection established");
                String sql = "SELECT * FROM admins WHERE reg = ? AND pass = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, reg);
                    stmt.setString(2, pass);
                    ResultSet rs = stmt.executeQuery();

                    if (rs.next()) {
                        System.out.println("Login successful for reg=" + reg);
                        // Store username in session
                        HttpSession session = req.getSession();
                        session.setAttribute("reg", rs.getString("reg")); // Assuming 'username' is a column in admins table
                        resp.sendRedirect("adminportal.jsp"); // Redirect to welcome page
                    } else {
                        System.out.println("Login failed: Invalid credentials");
                        // Failed login
                        req.setAttribute("error", "Invalid registration number or password");
                        req.getRequestDispatcher("admin.jsp").forward(req, resp);
                    }
                }
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            System.err.println("Driver not found: " + e.getMessage());
            req.setAttribute("error", "Database error: Driver not found");
            req.getRequestDispatcher("admin.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL error: " + e.getMessage());
            req.setAttribute("error", "Database error: " + e.getMessage());
            req.getRequestDispatcher("admin.jsp").forward(req, resp);
        }
    }
}
