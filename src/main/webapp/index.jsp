<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Uni Aid - Home</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex flex-col items-center justify-center min-h-screen">
    <div class="text-center mb-12">
        <h1 class="text-4xl font-bold text-gray-800">Welcome to Uni Aid</h1>
        <p class="text-lg text-gray-600 mt-2">Your gateway to seamless university management</p>
    </div>
    <div class="w-full max-w-2xl space-y-6 px-4">
        <a href="student.jsp" class="block w-full bg-blue-600 text-white text-center py-6 rounded-lg shadow-md hover:bg-blue-700 transition duration-300">
    		<h2 class="text-2xl font-semibold">Student Portal</h2>
    	</a>
        </a>
        <a href="teacher.jsp" class="block w-full bg-green-600 text-white text-center py-6 rounded-lg shadow-md hover:bg-green-700 transition duration-300">
            <h2 class="text-2xl font-semibold">Teacher Portal</h2>
        </a>
        <a href="admin.jsp" class="block w-full bg-red-600 text-white text-center py-6 rounded-lg shadow-md hover:bg-red-700 transition duration-300">
            <h2 class="text-2xl font-semibold">Admin Portal</h2>
        </a>
    </div>
</body>
</html>