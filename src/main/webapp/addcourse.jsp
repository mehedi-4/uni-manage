<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Course</title>
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
            --primary-green: #48bb78;
            --accent-red: #fc8181;
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

        input[type="text"],
        input[type="number"] {
            width: 100%;
            padding: 0.75rem;
            border-radius: 0.5rem;
            border: 1px solid rgba(255, 255, 255, 0.1);
            background-color: var(--input-bg);
            color: var(--text-color);
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }

        input[type="text"]:focus,
        input[type="number"]:focus {
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

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String code = request.getParameter("code");
            String title = request.getParameter("title");
            String credit = request.getParameter("credit");
            String semester = request.getParameter("semester");

            if (code != null && title != null && credit != null && semester != null &&
                !code.isEmpty() && !title.isEmpty() && !credit.isEmpty() && !semester.isEmpty()) {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/student_info?useSSL=false", "root", "iammhe");

                    PreparedStatement stmt = conn.prepareStatement("INSERT INTO courses (code, title, credit, semester) VALUES (?, ?, ?, ?)");
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
        }
%>
    <div class="container">
        <h2>Add Course</h2>
        <% if (message != null) { %><p class="message"><%= message %></p><% } %>
        <% if (error != null) { %><p class="error"><%= error %></p><% } %>
        <form method="post">
            <input type="text" name="code" placeholder="Course Code" required><br>
            <input type="text" name="title" placeholder="Course Title" required><br>
            <input type="number" step="0.1" name="credit" placeholder="Credit" required><br>
            <input type="text" name="semester" placeholder="Semester" required><br>
            <button type="submit">Add Course</button>
        </form>
        <a href="adminportal.jsp" class="back-link">Back to Portal</a>
    </div>
<%
    }
%>
</body>
</html>
