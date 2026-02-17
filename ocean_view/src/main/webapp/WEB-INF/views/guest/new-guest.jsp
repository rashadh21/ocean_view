<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register New Guest - Ocean View Resort</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/styles.css" rel="stylesheet">
    <script src="${pageContext.request.contextPath}/js/validation.js"></script>
</head>
<body class="flex bg-gray-50">
    
    <!-- Sidebar -->
    <div class="sidebar w-64 flex flex-col shadow-2xl z-20">
         <div class="p-6 text-center border-b border-gray-700 bg-opacity-20 bg-white">
            <h2 class="text-2xl font-bold tracking-wider">Ocean View</h2>
            <p class="text-xs text-blue-200 mt-1 uppercase tracking-widest">Resort Management</p>
        </div>
        <nav class="flex-1 p-4 space-y-2 mt-4">
            <a href="${pageContext.request.contextPath}/dashboard" class="nav-link rounded-xl">
                 <span class="mr-3">📊</span> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/reservation?action=new" class="nav-link rounded-xl">
                 <span class="mr-3">➕</span> New Reservation
            </a>
            <a href="${pageContext.request.contextPath}/guests?action=list" class="nav-link active rounded-xl">
                 <span class="mr-3">👥</span> Guests
            </a>
        </nav>
        <div class="p-4 border-t border-gray-700 bg-opacity-10 bg-black">
             <a href="${pageContext.request.contextPath}/logout" class="block text-center bg-red-500 hover:bg-red-600 text-white py-2 rounded-xl text-sm font-medium transition-all shadow-md hover:shadow-lg transform hover:-translate-y-0.5">
                Logout
            </a>
        </div>
    </div>

    <div class="flex-1 p-10 overflow-y-auto h-screen relative">
        <!-- Header Background -->
        <div class="absolute top-0 left-0 w-full h-48 bg-gradient-to-r from-blue-600 to-blue-400 z-0 rounded-b-3xl shadow-lg"></div>

        <div class="relative z-10 w-full max-w-3xl mx-auto">
            <h1 class="text-3xl font-bold text-white mb-8 drop-shadow-md animate-[fadeIn_0.5s_ease-out]">Register New Guest</h1>
            
            <div class="card bg-white p-8 rounded-2xl shadow-xl animate-[fadeIn_0.8s_ease-out]">
                <% if (request.getAttribute("error") != null) { %>
                    <div class="bg-red-50 border-l-4 border-red-500 text-red-700 p-4 mb-8 rounded-r flex items-center shadow-sm">
                        <span class="text-2xl mr-3">⚠️</span>
                        <p><%= request.getAttribute("error") %></p>
                    </div>
                <% } %>

                <form action="${pageContext.request.contextPath}/guests" method="post">
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                        <div class="md:col-span-2">
                             <label class="block text-gray-700 text-sm font-bold mb-2 ml-1">Full Name</label>
                             <input type="text" name="fullName" class="w-full px-4 py-3 rounded-xl border-2 border-gray-200 focus:border-blue-500 transition-colors" placeholder="e.g. Jane Doe" required>
                        </div>
                        <div>
                            <label class="block text-gray-700 text-sm font-bold mb-2 ml-1">Contact Number</label>
                            <input type="text" name="contactNumber" class="w-full px-4 py-3 rounded-xl border-2 border-gray-200 focus:border-blue-500 transition-colors" placeholder="e.g. +1 555 0199" required>
                        </div>
                        <div>
                            <label class="block text-gray-700 text-sm font-bold mb-2 ml-1">Email (Optional)</label>
                            <input type="email" name="email" class="w-full px-4 py-3 rounded-xl border-2 border-gray-200 focus:border-blue-500 transition-colors" placeholder="jane@example.com">
                        </div>
                        <div class="md:col-span-2">
                            <label class="block text-gray-700 text-sm font-bold mb-2 ml-1">Address</label>
                            <input type="text" name="address" class="w-full px-4 py-3 rounded-xl border-2 border-gray-200 focus:border-blue-500 transition-colors" placeholder="123 Ocean Blvd, City">
                        </div>
                         <!-- Optional fields if your model supports them 
                        <div>
                             <label class="block text-gray-700 text-sm font-bold mb-2 ml-1">ID Number</label>
                             <input type="text" name="idNumber" class="w-full px-4 py-3 rounded-xl border-2 border-gray-200 focus:border-blue-500 transition-colors" placeholder="Passport / ID">
                        </div>
                        <div>
                             <label class="block text-gray-700 text-sm font-bold mb-2 ml-1">Nationality</label>
                             <input type="text" name="nationality" class="w-full px-4 py-3 rounded-xl border-2 border-gray-200 focus:border-blue-500 transition-colors" placeholder="e.g. American">
                        </div>
                        -->
                    </div>

                    <div class="flex items-center justify-end mt-8">
                        <a href="${pageContext.request.contextPath}/guests?action=list" class="mr-4 text-gray-500 hover:text-gray-700 font-medium">Cancel</a>
                        <button type="submit" class="bg-gradient-to-r from-blue-500 to-blue-600 hover:from-blue-600 hover:to-blue-700 text-white font-bold py-3 px-8 rounded-xl shadow-lg transform hover:-translate-y-1 transition-all">
                            Register Guest
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
