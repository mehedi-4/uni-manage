<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Portal</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-color: #1a202c;
            --card-bg: #2d3748;
            --text-color: #e2e8f0;
            --input-bg: #4a5568;
            --primary-blue: #4299e1;
            --accent-red: #fc8181;
            --primary-green: #48bb78;
        }

        body {
            font-family: 'Inter', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            background-color: var(--bg-color);
            color: var(--text-color);
        }

        .container {
            background-color: var(--card-bg);
            padding: 3rem;
            border-radius: 1.5rem;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.7);
            text-align: center;
            max-width: 700px;
            width: 100%;
            border: 1px solid rgba(255, 255, 255, 0.1);
            overflow-y: auto;
        }

        .container h2 { font-size: 2.25rem; font-weight: 700; margin-bottom: 1.5rem; }
        .container .text-red { color: var(--accent-red); }
        .container .text-green { color: var(--primary-green); }
        .section { background-color: #1a202c; padding: 1.5rem; border-radius: 1rem; margin-bottom: 2rem; }
        .section h3 { font-size: 1.5rem; font-weight: 600; margin-bottom: 1rem; color: var(--primary-blue); }

        select, input[type=checkbox] {
            margin-bottom: 1rem;
        }

        select {
            padding: 0.5rem;
            border-radius: 0.5rem;
            border: 1px solid rgba(255, 255, 255, 0.1);
            background-color: var(--input-bg);
            color: var(--text-color);
            font-size: 1rem;
            width: 90%;
        }

        input[type=checkbox] {
            appearance: none;
            width: 1.25rem;
            height: 1.25rem;
            border: 2px solid #a0aec0;
            border-radius: 0.25rem;
            cursor: pointer;
            position: relative;
            margin-right: 0.5rem;
            background-color: var(--input-bg);
        }

        input[type=checkbox]:checked {
            background-color: var(--primary-blue);
            border-color: var(--primary-blue);
        }
        input[type=checkbox]:checked::after {
            content: '\2713';
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: #fff;
            font-size: 1rem;
        }

        button {
            padding: 0.75rem 1.5rem;
            background-color: var(--primary-blue);
            color: #fff;
            border: none;
            border-radius: 9999px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        button:hover { background-color: #2b6cb0; transform: scale(1.02); }

        .message { color: var(--primary-green); margin-bottom: 1rem; }
        .error { color: var(--accent-red); margin-bottom: 1rem; }

        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 1.5rem;
            border-radius: 0.5rem;
            overflow: hidden;
        }
        th, td {
            background-color: #4a5568;
            padding: 1rem;
            text-align: left;
        }
        th { background-color: #4299e1; color: #fff; font-weight: 600; }
        tr:nth-child(even) td { background-color: #2d3748; }
        tr:hover td { background-color: #4a5568; transition: background-color 0.3s ease; }

        .back-link { display: block; margin-top: 2rem; color: #a0aec0; text-decoration: none; }
        .back-link:hover { color: var(--text-color); }

        @media (max-width: 768px) { .container { padding: 2rem; } }
    </style>
</head>
<body>
<%
    if (session.getAttribute("reg") == null) {
%>
    <div class="container">
        <h2 class="text-red">Access Denied</h2>
        <a href="student.jsp" class="back-link">Go to Login</a>
    </div>
<%
    } else {
        String studentReg = (String) session.getAttribute("reg");
        String studentName = "";
        String message = null, error = null;

        String url = "jdbc:mysql://localhost:3306/student_info?useSSL=false";
        String dbUser = "root";
        String dbPassword = "iammhe";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, dbUser, dbPassword);

            // Fetch student name
            PreparedStatement psName = conn.prepareStatement("SELECT name FROM students WHERE reg = ?");
            psName.setString(1, studentReg);
            ResultSet rsName = psName.executeQuery();
            if (rsName.next()) { studentName = rsName.getString("name"); }
            rsName.close();
            psName.close();

            // Handle course registration
            if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("registerCourses") != null) {
                String semester = request.getParameter("semester");
                String[] selectedCourses = request.getParameterValues("courses");
                if (semester != null && selectedCourses != null) {
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
                    if (error == null) { message = "Courses registered successfully!"; }
                } else { error = "Please select a semester and at least one course."; }
            }

            // Fetch all semesters
            Statement stmtSem = conn.createStatement();
            ResultSet rsSem = stmtSem.executeQuery("SELECT DISTINCT semester FROM courses ORDER BY semester");
            java.util.List<String> semesters = new java.util.ArrayList<>();
            while (rsSem.next()) { semesters.add(rsSem.getString("semester")); }
            rsSem.close();
            stmtSem.close();

            // Fetch courses
            Statement stmtCourses = conn.createStatement();
            ResultSet rsCourses = stmtCourses.executeQuery("SELECT code, title, semester FROM courses ORDER BY semester, code");
            java.util.List<String[]> courses = new java.util.ArrayList<>();
            while (rsCourses.next()) {
                courses.add(new String[]{rsCourses.getString("code"), rsCourses.getString("title"), rsCourses.getString("semester")});
            }
            rsCourses.close();
            stmtCourses.close();

            // Fetch registered courses for student
            String sql = "SELECT c.code, c.title, c.semester FROM course_registration r JOIN courses c ON r.course_code = c.code WHERE r.student_reg = ?";
            PreparedStatement stmtReg = conn.prepareStatement(sql);
            stmtReg.setString(1, studentReg);
            ResultSet rsReg = stmtReg.executeQuery();
            java.util.List<String[]> registered = new java.util.ArrayList<>();
            while (rsReg.next()) { registered.add(new String[]{rsReg.getString("code"), rsReg.getString("title"), rsReg.getString("semester")}); }
            rsReg.close();
            stmtReg.close();

            conn.close();
%>
    <div class="container">
        <h2>Welcome, <%= studentName %>!</h2>
        <% if (message != null) { %><p class="message"><%= message %></p><% } %>
        <% if (error != null) { %><p class="error"><%= error %></p><% } %>

        <!-- Course Registration -->
        <div class="section">
            <h3>Register Courses</h3>
            <form method="post">
                <label for="semester" style="display:block; margin-bottom:0.5rem; text-align:left; font-weight:600;">Select Semester:</label>
                <select name="semester" id="semester" required>
                    <option value="">-- Select Semester --</option>
                    <% for (String sem : semesters) { %>
                        <option value="<%= sem %>"><%= sem %></option>
                    <% } %>
                </select>
                <div style="text-align:left; margin-top:1rem; margin-bottom:1rem; max-height:200px; overflow-y:auto; padding-right:10px;">
                    <% for (String[] c : courses) { %>
                        <div data-semester="<%= c[2] %>" style="display:none; margin-bottom:0.5rem;">
                            <input type="checkbox" name="courses" value="<%= c[0] %>">
                            <label><%= c[1] %> (<%= c[0] %>)</label>
                        </div>
                    <% } %>
                </div>
                <button type="submit" name="registerCourses">Register</button>
            </form>
        </div>

        <!-- View Registered Courses -->
        <div class="section">
            <h3>My Registered Courses</h3>
            <% if (registered.isEmpty()) { %>
                <p>You haven't registered any courses yet.</p>
            <% } else { %>
                <div style="max-height:300px; overflow-y:auto;">
                    <table>
                        <thead>
                            <tr><th>Course Code</th><th>Title</th><th>Semester</th></tr>
                        </thead>
                        <tbody>
                            <% for (String[] r : registered) { %>
                                <tr>
                                    <td><%= r[0] %></td>
                                    <td><%= r[1] %></td>
                                    <td><%= r[2] %></td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>

        <a href="index.jsp" class="back-link">Back to Home</a>
    </div>

    <script>
        const semesterDropdown = document.getElementById("semester");
        semesterDropdown.addEventListener("change", function() {
            const selected = this.value;
            const courseDivs = document.querySelectorAll("[data-semester]");
            courseDivs.forEach(div => {
                if (div.getAttribute("data-semester") === selected || selected === "") {
                    div.style.display = "flex"; div.style.alignItems = "center";
                } else { div.style.display = "none"; }
            });
        });
    </script>
<%
        } catch (Exception e) {
            out.println("<p class='error'>DB Error: " + e.getMessage() + "</p>");
        }
    }
%>
</body>
</html>
