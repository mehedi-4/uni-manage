<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Portal</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        /* CSS Variables for easy color changes */
        :root {
            --bg-color: #1a202c;
            --card-bg: #2d3748;
            --text-color: #e2e8f0;
            --primary-blue: #4299e1;
            --primary-green: #48bb78;
            --primary-purple: #9f7aea;
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

        .welcome-container {
            background-color: var(--card-bg);
            padding: 3rem;
            border-radius: 1.5rem;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.7);
            text-align: center;
            max-width: 450px;
            width: 100%;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .welcome-container h2 {
            font-size: 2.25rem;
            font-weight: 700;
            letter-spacing: -0.025em;
            margin-bottom: 0.5rem;
        }

        .welcome-container .text-red {
            color: var(--accent-red);
        }

        .welcome-container .text-blue {
            color: var(--primary-blue);
        }

        .welcome-container p {
            font-size: 1rem;
            margin-top: 1rem;
            color: #a0aec0;
        }

        .menu-links {
            display: flex;
            flex-direction: column;
            gap: 1rem;
            align-items: center;
            margin-top: 2rem;
        }

        .menu-links a, .go-to-login {
            display: block;
            padding: 0.75rem 1.5rem;
            border-radius: 9999px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            transform: scale(1);
        }

        .menu-links a:hover, .go-to-login:hover {
            transform: scale(1.05);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
        }

        .btn-green {
            background-color: var(--primary-green);
            color: #fff;
        }

        .btn-green:hover {
            background-color: #38a169;
        }

        .btn-purple {
            background-color: var(--primary-purple);
            color: #fff;
        }

        .btn-purple:hover {
            background-color: #805ad5;
        }

        .go-to-login {
            background-color: var(--primary-blue);
            color: #fff;
            margin-top: 2rem;
        }

        .go-to-login:hover {
            background-color: #2b6cb0;
        }

        .back-home {
            display: block;
            margin-top: 2rem;
            color: #a0aec0;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .back-home:hover {
            color: var(--text-color);
        }

        @media (min-width: 640px) {
            .menu-links {
                flex-direction: row;
                justify-content: center;
                gap: 1rem;
            }
        }
    </style>
</head>
<body>
<%
    if (session.getAttribute("reg") == null) {
%>
    <div class="welcome-container">
        <h2 class="text-red">Access Denied</h2>
        <p>You must log in first.</p>
        <a href="admin.jsp" class="go-to-login">Go to Login</a>
    </div>
<%
    } else {
%>
    <div class="welcome-container">
        <h2 class="text-blue">Welcome, <%= session.getAttribute("reg") %>!</h2>
        <p>You have successfully logged in to the Admin Portal.</p>

        <div class="menu-links">
            <a href="addcourse.jsp" class="btn-green">Add Course</a>
            <a href="assignTeacher.jsp" class="btn-purple">Assign Teacher</a>
        </div>

        <a href="logout.jsp" class="back-home">Log Out</a>
    </div>
<%
    }
%>
</body>
</html>
