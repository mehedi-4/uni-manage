<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assign Teacher</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        /* CSS Variables for a consistent color palette */
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
            transition: background-color 0.3s ease;
        }

        .container {
            background-color: var(--card-bg);
            padding: 3rem;
            border-radius: 1.5rem;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.7);
            text-align: center;
            max-width: 450px;
            width: 100%;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .container h2 {
            font-size: 2.25rem;
            font-weight: 700;
            letter-spacing: -0.025em;
            margin-bottom: 1.5rem;
        }

        .container .text-red {
            color: var(--accent-red);
        }

        .container .text-green {
            color: var(--primary-green);
        }

        /* Form styling */
        form {
            display: flex;
            flex-direction: column;
            gap: 1rem;
            align-items: center;
            margin-top: 1rem;
        }

        select {
            width: 100%;
            padding: 0.75rem;
            border-radius: 0.5rem;
            border: 1px solid rgba(255, 255, 255, 0.1);
            background-color: var(--input-bg);
            color: var(--text-color);
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }

        select:focus {
            outline: none;
            border-color: var(--primary-blue);
        }

        button {
            width: 100%;
            padding: 0.75rem 1.5rem;
            background-color: var(--primary-blue);
            color: #fff;
            border: none;
            border-radius: 9999px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            transform: scale(1);
        }

        button:hover {
            background-color: #2b6cb0;
            transform: scale(1.02);
        }

        .message {
            color: var(--primary-green);
            margin-bottom: 1rem;
        }
        
        .error {
            color: var(--accent-red);
            margin-bottom: 1rem;
        }

        .back-link {
            display: block;
            margin-top: 2rem;
            color: #a0aec0;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .back-link:hover {
            color: var(--text-color);
        }
    </style>
</head>
<body>
<%
    if (session.getAttribute("reg") == null) {
%>
    <div class="container">
        <h2 class="text-red">Access Denied</h2>
        <a href="admin.jsp" class="back-link">Go to Login</a>
    </div>
<%
    } else {
        String message = null, error = null;

        // DB connection details
        String url = "jdbc:mysql://localhost:3306/student_info?useSSL=false";
        String dbUser = "root";
        String dbPassword = "iammhe";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, dbUser, dbPassword);

            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String courseCode = request.getParameter("courseCode"); // code as value
                String teacherReg = request.getParameter("teacherReg"); // reg as value

                if (courseCode != null && teacherReg != null) {
                    try {
                        // Check if course is already assigned
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
                    } catch (Exception e) {
                        error = "Error: " + e.getMessage();
                    }
                } else {
                    error = "Please select both fields!";
                }
            }

            // Fetch courses (code + title)
            Statement stmtCourses = conn.createStatement();
            ResultSet rsCourses = stmtCourses.executeQuery("SELECT code, title FROM courses");
            java.util.List<String[]> courses = new java.util.ArrayList<>();
            while (rsCourses.next()) {
                courses.add(new String[]{rsCourses.getString("code"), rsCourses.getString("title")});
            }
            rsCourses.close();
            stmtCourses.close();

            // Fetch teachers (reg + name)
            Statement stmtTeachers = conn.createStatement();
            ResultSet rsTeachers = stmtTeachers.executeQuery("SELECT reg, name FROM teachers");
            java.util.List<String[]> teachers = new java.util.ArrayList<>();
            while (rsTeachers.next()) {
                teachers.add(new String[]{rsTeachers.getString("reg"), rsTeachers.getString("name")});
            }
            rsTeachers.close();
            stmtTeachers.close();

            conn.close();
%>
    <div class="container">
        <h2>Assign Teacher to Course</h2>
        <% if (message != null) { %><p class="message"><%= message %></p><% } %>
        <% if (error != null) { %><p class="error"><%= error %></p><% } %>

        <form method="post">
            <!-- Course dropdown -->
            <select name="courseCode" required>
                <option value="">-- Select Course --</option>
                <% for (String[] c : courses) { %>
                    <option value="<%= c[0] %>"><%= c[1] %> (<%= c[0] %>)</option>
                <% } %>
            </select><br>

            <!-- Teacher dropdown -->
            <select name="teacherReg" required>
                <option value="">-- Select Teacher --</option>
                <% for (String[] t : teachers) { %>
                    <option value="<%= t[0] %>"><%= t[1] %> (<%= t[0] %>)</option>
                <% } %>
            </select><br>

            <button type="submit">Assign</button>
        </form>

        <a href="adminportal.jsp" class="back-link">Back to Portal</a>
    </div>
<%
        } catch (Exception e) {
            out.println("<p class='error'>DB Error: " + e.getMessage() + "</p>");
        }
    }
%>
</body>
</html>
