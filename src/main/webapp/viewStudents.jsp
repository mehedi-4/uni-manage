<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Registered Students</title>

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
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: flex-start;
        }

        .container {
            background-color: var(--card-bg);
            padding: 2rem;
            border-radius: 1.25rem;
            max-width: 600px;
            width: 100%;
            box-shadow: 0 15px 40px rgba(0,0,0,0.7);
        }

        h2 {
            margin-top: 0;
            text-align: center;
            color: var(--primary-blue);
        }

        ul {
            list-style: none;
            padding: 0;
            margin-top: 1.5rem;
        }

        li {
            background-color: #4a5568;
            padding: 0.75rem 1rem;
            margin-bottom: 0.5rem;
            border-radius: 0.5rem;
            font-weight: 600;
        }

        li:nth-child(even) {
            background-color: #2d3748;
        }

        .back-link {
            display: block;
            margin-top: 2rem;
            text-align: center;
            color: #a0aec0;
            text-decoration: none;
            font-weight: 600;
        }

        .back-link:hover {
            color: white;
        }

        .error {
            color: #fc8181;
            text-align: center;
            margin-top: 1rem;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Registered Students</h2>

<%
    if (request.getAttribute("error") != null) {
%>
        <p class="error"><%= request.getAttribute("error") %></p>
<%
    } else {
        List<String[]> students = (List<String[]>) request.getAttribute("students");
        if (students != null) {
            out.println("<ul>");
            for (String[] s : students) {
                out.println("<li>" + s[0] + " - " + s[1] + "</li>");
            }
            out.println("</ul>");
        }
    }
%>

    <a href="teacherPortal" class="back-link">← Back to Teacher Portal</a>
</div>

</body>
</html>
