<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
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

        .nav-button {
            display: block;
            width: 100%;
            padding: 1rem;
            border-radius: 1rem;
            font-size: 1.05rem;
            font-weight: 700;
            cursor: pointer;
            margin-bottom: 1rem;
            border: none;
        }

        .nav-blue { background-color: var(--primary-blue); color: white; }
        .nav-blue:hover { background-color: #2b6cb0; transform: scale(1.02); }

        .nav-green { background-color: var(--primary-green); color: white; }
        .nav-green:hover { background-color: #2f9e57; transform: scale(1.02); }

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

        /* small helper */
        .hidden { display: none; }

        @media (max-width: 768px) { .container { padding: 2rem; } }
    </style>
</head>
<body>
    <div class="container">
        <h2>Welcome, <%= request.getAttribute("studentName") %>!</h2>
        <% if (request.getAttribute("message") != null) { %>
            <p class="message"><%= request.getAttribute("message") %></p>
        <% } %>
        <% if (request.getAttribute("error") != null) { %>
            <p class="error"><%= request.getAttribute("error") %></p>
        <% } %>

        <!-- Two big buttons like admin portal -->
        <div style="max-width:460px; margin: 0 auto 1.5rem;">
            <button class="nav-button nav-blue" onclick="showSection('registerSection')">Register Courses</button>
            <button class="nav-button nav-green" onclick="showSection('myCoursesSection')">View Registered Courses</button>
        </div>

        <!-- Course Registration (hidden by default) -->
        <div id="registerSection" class="section hidden">
            <h3>Register Courses</h3>
            <form action="studentPortal" method="post">
                <label for="semester" style="display:block; margin-bottom:0.5rem; text-align:left; font-weight:600;">Select Semester:</label>
                <select name="semester" id="semester" required>
                    <option value="">-- Select Semester --</option>
                    <% 
                    List<String> semesters = (List<String>) request.getAttribute("semesters");
                    if (semesters != null) {
                        for (String sem : semesters) { 
                    %>
                        <option value="<%= sem %>"><%= sem %></option>
                    <% 
                        } 
                    }
                    %>
                </select>
                <div style="text-align:left; margin-top:1rem; margin-bottom:1rem; max-height:200px; overflow-y:auto; padding-right:10px;">
                    <% 
                    List<String[]> courses = (List<String[]>) request.getAttribute("courses");
                    if (courses != null) {
                        for (String[] c : courses) { 
                    %>
                        <div data-semester="<%= c[2] %>" style="display:none; margin-bottom:0.5rem;">
                            <input type="checkbox" name="courses" value="<%= c[0] %>">1
                            <label><%= c[1] %> (<%= c[0] %>)</label>
                        </div>
                    <% 
                        } 
                    }
                    %>
                </div>
                <button type="submit" name="registerCourses">Register</button>
            </form>
        </div>

        <!-- View Registered Courses (hidden by default) -->
        <div id="myCoursesSection" class="section hidden">
            <h3>My Registered Courses</h3>
            <% 
            List<String[]> registered = (List<String[]>) request.getAttribute("registered");
            if (registered == null || registered.isEmpty()) { 
            %>
                <p>You haven't registered any courses yet.</p>
            <% } else { %>
                <div style="max-height:300px; overflow-y:auto;">
                    <table>
                        <thead>
                            <tr>
                            	<th>Course Code</th>
                            	<th>Title</th>
                            	<th>Semester</th>
                            </tr>
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

        <a href="logout" class="back-link">Logout</a>
    </div>

    <script>
        // Show the requested section and hide the other
        function showSection(id) {
            var reg = document.getElementById('registerSection');
            var my = document.getElementById('myCoursesSection');

            if (reg) reg.style.display = 'none';
            if (my) my.style.display = 'none';

            var target = document.getElementById(id);
            if (target) {
                target.style.display = 'block';
                target.scrollIntoView({behavior: 'smooth', block: 'start'});
            }
        }

        // Initialize: nothing visible by default. (If you want register open by default, uncomment next line)
        // showSection('registerSection');

        // Semester dropdown listener (safe-guard if element not present)
        var semesterDropdown = document.getElementById("semester");
        if (semesterDropdown) {
            semesterDropdown.addEventListener("change", function() {
                const selected = this.value;
                const courseDivs = document.querySelectorAll("[data-semester]");
                courseDivs.forEach(div => {
                    if (div.getAttribute("data-semester") === selected || selected === "") {
                        div.style.display = "flex"; div.style.alignItems = "center";
                    } else { div.style.display = "none"; }
                });
            });
        }
    </script>
</body>
</html>
