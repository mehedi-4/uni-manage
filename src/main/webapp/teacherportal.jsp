<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
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
            --primary-blue: #4299e1;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-color);
            color: var(--text-color);
            margin: 0;
            padding: 2rem;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            min-height: 100vh;
        }

        .container {
            background-color: var(--card-bg);
            padding: 2rem;
            border-radius: 1.5rem;
            max-width: 900px;
            width: 100%;
            box-shadow: 0 20px 50px rgba(0,0,0,0.7);
            text-align: center;
        }

        h2 {
            margin-bottom: 1rem;
        }

        h3 {
            color: var(--primary-blue);
            margin-top: 2rem;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }

        th, td {
            padding: 1rem;
            text-align: center;
        }

        th {
            background-color: var(--primary-blue);
            color: white;
        }

        td {
            background-color: #4a5568;
        }

        tr:nth-child(even) td {
            background-color: #2d3748;
        }

        button {
            padding: 0.5rem 1rem;
            background-color: var(--primary-blue);
            color: white;
            border: none;
            border-radius: 9999px;
            cursor: pointer;
            font-weight: 600;
        }

        button:hover {
            background-color: #2b6cb0;
        }

        .logout-link {
            display: inline-block;
            margin-top: 2rem;
            color: #a0aec0;
            text-decoration: none;
            font-weight: 600;
        }

        .logout-link:hover {
            color: white;
        }
    </style>
</head>
<body>

    <div class="container">
        <h2>Welcome, <%= request.getAttribute("teacherName") %>!</h2>

        <h3>Your Assigned Courses</h3>

        <% if (request.getAttribute("error") != null) { %>
            <p style='color:red'><%= request.getAttribute("error") %></p>
        <% } %>

        <table>
            <tr>
                <th>Course Code</th>
                <th>Course Title</th>
                <th>Action</th>
            </tr>

<%
            List<String[]> assignedCourses = (List<String[]>) request.getAttribute("assignedCourses");
            if (assignedCourses != null) {
                for (String[] course : assignedCourses) {
%>
            <tr>
                <td><%= course[0] %></td>
                <td><%= course[1] %></td>
                <td>
                    <a href="viewStudents?courseCode=<%= course[0] %>">
                        <button>View Students</button>
                    </a>
                </td>
            </tr>
<%
                }
            }
%>
        </table>

        <a href="logout" class="logout-link">Logout</a>
    </div>

</body>
</html>
