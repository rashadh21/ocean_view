<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Ocean View Resort</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/styles.css" rel="stylesheet">
    <script src="${pageContext.request.contextPath}/js/validation.js"></script>
</head>
<body class="flex items-center justify-center h-screen overflow-hidden relative">

    <!-- Animated Background Elements -->
    <div class="fish fish-1">🐠</div>
    <div class="fish fish-2">🐟</div>
    <div class="fish fish-3">🐡</div>
    <div class="fish fish-4">🦈</div>
    
    <div class="bubble"></div>
    <div class="bubble"></div>
    <div class="bubble"></div>
    <div class="bubble"></div>
    <div class="bubble"></div>
    <div class="bubble"></div>
    <div class="bubble"></div>

    <!-- Wave Animation at Bottom (Multi-layered) -->
    <div class="wave-container">
        <!-- Layer 1 (Back) -->
        <svg class="wave" style="animation-duration: 20s; opacity: 0.4;" viewBox="0 0 2440 920" xmlns="http://www.w3.org/2000/svg">
             <path fill="#00A8E8" fill-opacity="1" d="M0,192L48,197.3C96,203,192,213,288,229.3C384,245,480,267,576,250.7C672,235,768,181,864,181.3C960,181,1056,235,1152,234.7C1248,235,1344,181,1392,154.7L1440,128L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path>
        </svg>
        <!-- Layer 2 (Front) -->
        <svg class="wave" style="animation-duration: 15s; animation-delay: -5s;" viewBox="0 0 2440 920" xmlns="http://www.w3.org/2000/svg">
            <path fill="#0077BE" fill-opacity="0.6" d="M0,256L48,245.3C96,235,192,213,288,192C384,171,480,149,576,160C672,171,768,213,864,224C960,235,1056,213,1152,192C1248,171,1344,149,1392,138.7L1440,128L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path>
        </svg>
    </div>

    <div class="auth-container glass relative z-10 w-full max-w-md p-8 rounded-2xl">
        <div class="text-center mb-8">
            <h1 class="text-4xl font-bold text-gray-800 mb-2" style="color: var(--ocean-primary);">Ocean View</h1>
            <p class="text-gray-600">Welcome to Paradise</p>
        </div>

        <% 
            String error = (String) request.getAttribute("error");
            if (error != null) { 
        %>
            <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6 rounded-r" role="alert" style="animation: slideInLeft 0.5s ease-out;">
                <p class="font-bold">Error</p>
                <p><%= error %></p>
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/login" method="post" onsubmit="return validateLoginForm()">
            <div class="mb-6 relative">
                <label class="block text-gray-700 text-sm font-bold mb-2 ml-1" for="username">
                    Username
                </label>
                <input class="w-full px-4 py-3 rounded-lg border-2 border-gray-200 focus:border-blue-500 transition-colors" 
                       id="username" name="username" type="text" placeholder="Enter your username">
            </div>
            <div class="mb-8 relative">
                <label class="block text-gray-700 text-sm font-bold mb-2 ml-1" for="password">
                    Password
                </label>
                <input class="w-full px-4 py-3 rounded-lg border-2 border-gray-200 focus:border-blue-500 transition-colors" 
                       id="password" name="password" type="password" placeholder="Enter your password">
            </div>
            <div class="flex items-center justify-between">
                <button class="w-full bg-gradient-to-r from-blue-500 to-blue-600 hover:from-blue-600 hover:to-blue-700 text-white font-bold py-3 px-4 rounded-xl shadow-lg transform transition hover:-translate-y-1 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50" 
                        type="submit">
                    Sign In
                </button>
            </div>
        </form>
        <div class="mt-6 text-center">
            <p class="text-sm text-gray-500">Don't have an account? <a href="#" class="text-blue-600 hover:underline">Contact Admin</a>.</p>
        </div>
    </div>

</body>
</html>
