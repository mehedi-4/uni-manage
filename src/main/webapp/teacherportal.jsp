<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Teacher Portal</title>
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
            align-items: flex-start;
            min-height: 100vh;
            margin: 0;
            background-color: var(--bg-color);
            color: var(--text-color);
            padding: 2rem;
        }

        .container {
            background-color: var(--card-bg);
            padding: 2rem;
            border-radius: 1.5rem;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.7);
            text-align: center;
            max-width: 900px;
            width: 100%;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .container h2 {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }

        .container h3 {
            font-size: 1.25rem;
            font-weight: 600;
            margin: 1.5rem 0 1rem;
            color: var(--primary-blue);
        }

        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 1rem;
            border-radius: 0.5rem;
            overflow: hidden;
        }

        th, td {
            padding: 1rem;
            text-align: center;
        }

        th {
            background-color: var(--primary-blue);
            color: #fff;
            font-weight: 600;
        }

        td {
            background-color: #4a5568;
        }

        tr:nth-child(even) td {
            background-color: #2d3748;
        }

        tr:hover td {
            background-color: #4a5568;
            transition: background-color 0.3s ease;
        }

        button {
            padding: 0.5rem 1rem;
            background-color: var(--primary-blue);
            color: #fff;
            border: none;
            border-radius: 9999px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        button:hover {
            background-color: #2b6cb0;
            transform: scale(1.02);
        }

        /* Modal */
        .modal {
            display: none;
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(0,0,0,0.7);
            justify-content: center;
            align-items: center;
        }

        .modal-content {
            background: var(--card-bg);
            padding: 2rem;
            border-radius: 1rem;
            width: 500px;
            color: var(--text-color);
            box-shadow: 0 10px 30px rgba(0,0,0,0.8);
        }

        .modal-content h3 {
            color: var(--primary-green);
            margin-top: 0;
        }

        .logout-link {
            display: inline-block;
            margin-top: 2rem;
            color: #a0aec0;
            text-decoration: none;
            font-weight: 600;
        }

        .logout-link:hover {
            color: var(--text-color);
        }
    </style>
    <script>
        function viewStudents(courseCode) {
            fetch("viewStudents.jsp?courseCode=" + courseCode)
                .then(response => response.text())
                .then(data => {
                    document.getElementById("modal-body").innerHTML = data;
                    document.getElementById("studentModal").style.display = "flex";
                });
        }
        function closeModal() {
            document.getElementById("studentModal").style.display = "none";
        }
    </script>
</head>
<body>
<%
    if (session.getAttribute("reg") == null) {
%>
    <div class="container">
        <h2 class="text-red">Access Denied</h2>
        <a href="teacher.jsp" class="logout-link">Go to Login</a>
    </div>
<%
    } else {
        String teacherReg = session.getAttribute("reg").toString();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String teacherName = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/student_info", "root", "iammhe");

            // Teacher name
            String nameSql = "SELECT name FROM teachers WHERE reg = ?";
            ps = conn.prepareStatement(nameSql);
            ps.setString(1, teacherReg);
            rs = ps.executeQuery();
            if(rs.next()) {
                teacherName = rs.getString("name");
            }
            rs.close();
            ps.close();

            // Assigned courses
            String sql = "SELECT c.code, c.title FROM courses c " +
                         "JOIN course_assignments ca ON c.code = ca.course_code " +
                         "WHERE ca.teacher_reg = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, teacherReg);
            rs = ps.executeQuery();
%>
    <div class="container">
        <h2>Welcome, <%= teacherName %>!</h2>
        <h3>Your Assigned Courses:</h3>
        <table>
            <tr>
                <th>Course Code</th>
                <th>Course Title</th>
                <th>Action</th>
            </tr>
<%
        while(rs.next()) {
%>
            <tr>
                <td><%= rs.getString("code") %></td>
                <td><%= rs.getString("title") %></td>
                <td><button onclick="viewStudents('<%= rs.getString("code") %>')">View Students</button></td>
            </tr>
<%
        }
%>
        </table>
        <a href="logout.jsp" class="logout-link">Logout</a>
    </div>
<%
        } catch(Exception e) {
            out.println("<p style='color:red'>Error: " + e.getMessage() + "</p>");
        } finally {
            if(rs != null) rs.close();
            if(ps != null) ps.close();
            if(conn != null) conn.close();
        }
    }
%>

<!-- Modal -->
<div class="modal" id="studentModal">
    <div class="modal-content">
        <h3>Registered Students</h3>
        <div id="modal-body"></div>
        <button onclick="closeModal()">Close</button>
    </div>
</div>
</body>
</html>
