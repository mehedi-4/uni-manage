<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Teacher Portal</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
            background-color: #f0f0f0;
        }
        .container {
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            max-width: 700px;
            margin: auto;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: center;
        }
        th {
            background: #eee;
        }
        button {
            padding: 5px 10px;
            border: none;
            border-radius: 5px;
            background: #007BFF;
            color: white;
            cursor: pointer;
        }
        button:hover {
            background: #0056b3;
        }
        /* Popup Modal */
        .modal {
            display: none;
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(0,0,0,0.5);
            justify-content: center;
            align-items: center;
        }
        .modal-content {
            background: white;
            padding: 20px;
            border-radius: 10px;
            width: 400px;
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
    <h2>Access Denied</h2>
    <p>You must log in to access the Teacher Portal.</p>
    <a href="teacher.jsp">Go to Login</a>
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

            // 🔹 Get teacher name from teachers table
            String nameSql = "SELECT name FROM teachers WHERE reg = ?";
            ps = conn.prepareStatement(nameSql);
            ps.setString(1, teacherReg);
            rs = ps.executeQuery();
            if(rs.next()) {
                teacherName = rs.getString("name");
            }
            rs.close();
            ps.close();

            // 🔹 Now fetch assigned courses
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
    </div>
<%
        } catch(Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        } finally {
            if(rs != null) rs.close();
            if(ps != null) ps.close();
            if(conn != null) conn.close();
        }
    }
%>

    <!-- Popup Modal -->
    <div class="modal" id="studentModal">
        <div class="modal-content">
            <h3>Registered Students</h3>
            <div id="modal-body"></div>
            <button onclick="closeModal()">Close</button>
        </div>
    </div>
</body>
</html>
