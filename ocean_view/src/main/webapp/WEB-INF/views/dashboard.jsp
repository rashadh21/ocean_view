<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Ocean View Resort</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/styles.css" rel="stylesheet">
</head>
<body class="flex bg-gray-50">

    <!-- Sidebar with Gradient -->
    <div class="sidebar w-64 flex flex-col shadow-2xl z-20 transition-all duration-300">
        <div class="p-6 text-center border-b border-gray-700 bg-opacity-20 bg-white">
            <h2 class="text-2xl font-bold tracking-wider">Ocean View</h2>
            <p class="text-xs text-blue-200 mt-1 uppercase tracking-widest">Resort Management</p>
        </div>
        <nav class="flex-1 p-4 space-y-2 mt-4">
            <a href="${pageContext.request.contextPath}/dashboard" class="nav-link active rounded-xl">
                <span class="mr-3">📊</span> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/reservation?action=new" class="nav-link rounded-xl">
                <span class="mr-3">➕</span> New Reservation
            </a>
            <a href="${pageContext.request.contextPath}/reservation?action=list" class="nav-link rounded-xl">
                <span class="mr-3">📅</span> Reservations
            </a>
            <a href="${pageContext.request.contextPath}/guests?action=list" class="nav-link rounded-xl">
                 <span class="mr-3">👥</span> Guests
            </a>
            <a href="${pageContext.request.contextPath}/rooms?action=available" class="nav-link rounded-xl">
                <span class="mr-3">🔍</span> Check Availability
            </a>
        </nav>
        <div class="p-4 border-t border-gray-700 bg-opacity-10 bg-black">
            <div class="flex items-center mb-4 px-2">
                <div class="w-10 h-10 rounded-full bg-gradient-to-br from-blue-400 to-blue-600 flex items-center justify-center text-white font-bold shadow-lg ring-2 ring-blue-300">
                    ${sessionScope.user.username.substring(0,1).toUpperCase()}
                </div>
                <div class="ml-3">
                    <p class="text-sm font-semibold text-white tracking-wide">${sessionScope.user.fullName}</p>
                    <p class="text-xs text-blue-300 uppercase">${sessionScope.role}</p>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="block text-center bg-red-500 hover:bg-red-600 text-white py-2 rounded-xl text-sm font-medium transition-all shadow-md hover:shadow-lg transform hover:-translate-y-0.5">
                Logout
            </a>
        </div>
    </div>

    <!-- Main Content -->
    <div class="flex-1 overflow-y-auto h-screen relative">
        <!-- Header Background -->
        <div class="absolute top-0 left-0 w-full h-64 bg-gradient-to-r from-blue-600 to-blue-400 z-0 rounded-b-3xl shadow-lg"></div>
        
        <div class="relative z-10 p-10">
            <header class="flex justify-between items-center mb-10">
                <div>
                    <h1 class="text-4xl font-bold text-white mb-2 drop-shadow-md">Welcome Back, ${sessionScope.user.fullName}!</h1>
                    <p class="text-blue-100 opacity-90">Here's what's happening at the resort today.</p>
                </div>
                <div class="bg-white bg-opacity-20 backdrop-filter backdrop-blur-lg rounded-xl p-2 text-white border border-white border-opacity-30">
                    <span id="current-date" class="font-medium px-4"></span>
                </div>
            </header>
            
            <!-- Quick Stats Cards with Animation -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                <div class="card p-6 border-l-4 border-blue-500 animate-[fadeIn_0.5s_ease-out]">
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="text-gray-500 text-xs uppercase font-bold tracking-wider">Total Bookings</p>
                            <h3 class="text-3xl font-bold text-gray-800 mt-1">${todayBookings}</h3>
                        </div>
                        <div class="p-3 rounded-lg bg-blue-100 text-blue-600">
                             📅
                        </div>
                    </div>
                </div>
                
                <div class="card p-6 border-l-4 border-green-500 animate-[fadeIn_0.7s_ease-out]">
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="text-gray-500 text-xs uppercase font-bold tracking-wider">Available Rooms</p>
                            <h3 class="text-3xl font-bold text-gray-800 mt-1">${availableRooms}</h3>
                        </div>
                        <div class="p-3 rounded-lg bg-green-100 text-green-600">
                             🛏️
                        </div>
                    </div>
                </div>
                
                <div class="card p-6 border-l-4 border-yellow-500 animate-[fadeIn_0.9s_ease-out]">
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="text-gray-500 text-xs uppercase font-bold tracking-wider">Check-Ins Today</p>
                            <h3 class="text-3xl font-bold text-gray-800 mt-1">${todayCheckIns}</h3>
                        </div>
                        <div class="p-3 rounded-lg bg-yellow-100 text-yellow-600">
                             🛎️
                        </div>
                    </div>
                </div>

                 <div class="card p-6 border-l-4 border-purple-500 animate-[fadeIn_1.1s_ease-out]">
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="text-gray-500 text-xs uppercase font-bold tracking-wider">Revenue Today</p>
                            <h3 class="text-3xl font-bold text-gray-800 mt-1">
                                <fmt:formatNumber value="${todayRevenue}" type="currency" currencySymbol="$" />
                            </h3>
                        </div>
                        <div class="p-3 rounded-lg bg-purple-100 text-purple-600">
                             💰
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Actions Section -->
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                <div class="card p-8 animate-[fadeIn_1.3s_ease-out]">
                    <h3 class="text-xl font-bold text-gray-800 mb-6 border-b pb-4">Quick Actions</h3>
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                         <a href="${pageContext.request.contextPath}/reservation?action=new" class="btn group flex items-center justify-center p-4 bg-blue-50 hover:bg-blue-100 rounded-xl border border-blue-200 text-blue-700 font-medium transition-all">
                             <span class="mr-2 text-xl group-hover:scale-110 transition-transform">➕</span> New Reservation
                         </a>
                         <a href="${pageContext.request.contextPath}/rooms?action=available" class="btn group flex items-center justify-center p-4 bg-green-50 hover:bg-green-100 rounded-xl border border-green-200 text-green-700 font-medium transition-all">
                             <span class="mr-2 text-xl group-hover:scale-110 transition-transform">🔍</span> Check Availability
                         </a>
                         <a href="${pageContext.request.contextPath}/reservation?action=list" class="btn group flex items-center justify-center p-4 bg-purple-50 hover:bg-purple-100 rounded-xl border border-purple-200 text-purple-700 font-medium transition-all">
                             <span class="mr-2 text-xl group-hover:scale-110 transition-transform">📋</span> View All Reservations
                         </a>
                         <a href="#" class="btn group flex items-center justify-center p-4 bg-gray-50 hover:bg-gray-100 rounded-xl border border-gray-200 text-gray-700 font-medium transition-all">
                             <span class="mr-2 text-xl group-hover:scale-110 transition-transform">⚙️</span> Settings
                         </a>
                    </div>
                </div>

                <div class="card p-8 animate-[fadeIn_1.5s_ease-out]">
                    <h3 class="text-xl font-bold text-gray-800 mb-4">System Status</h3>
                    <div class="flex items-center p-4 bg-green-50 rounded-lg border border-green-200 mb-4">
                         <div class="w-3 h-3 rounded-full bg-green-500 animate-pulse mr-3"></div>
                         <p class="text-green-800 font-medium">System operational</p>
                    </div>
                    <p class="text-gray-600 text-sm mb-4">Database connection is active and stable.</p>
                    <div class="h-2 w-full bg-gray-200 rounded-full overflow-hidden">
                        <div class="h-full bg-blue-500 w-3/4 rounded-full shimmer" style="background-image: linear-gradient(90deg, rgba(255,255,255,0) 0, rgba(255,255,255,0.2) 20%, rgba(255,255,255,0.5) 60%, rgba(255,255,255,0)); background-size: 200px 100%; animation: shimmer 2s infinite linear;"></div>
                    </div>
                    <p class="text-right text-xs text-gray-500 mt-2">Server Load: 24%</p>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Set current date
        const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        document.getElementById('current-date').textContent = new Date().toLocaleDateString('en-US', options);
    </script>
</body>
</html>
