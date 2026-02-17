<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Guest List - Ocean View Resort</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/styles.css" rel="stylesheet">
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
             <a href="${pageContext.request.contextPath}/rooms?action=available" class="nav-link rounded-xl">
                 <span class="mr-3">🔍</span> Check Availability
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

        <div class="relative z-10 w-full max-w-6xl mx-auto">
            <div class="flex justify-between items-center mb-8 animate-[fadeIn_0.5s_ease-out]">
                <div>
                    <h1 class="text-3xl font-bold text-white mb-2 drop-shadow-md">Guest Management</h1>
                    <p class="text-blue-100 opacity-90">View and manage guest profiles.</p>
                </div>
                <a href="${pageContext.request.contextPath}/guests?action=new" class="btn bg-white text-blue-600 hover:bg-blue-50 font-bold py-3 px-6 rounded-xl shadow-lg transform hover:-translate-y-1 transition-all flex items-center">
                    <span class="mr-2 text-xl">+</span> Add New Guest
                </a>
            </div>

            <!-- Search Bar -->
            <div class="card bg-white p-6 rounded-2xl shadow-lg mb-8 animate-[fadeIn_0.7s_ease-out]">
                <form action="${pageContext.request.contextPath}/guests" method="get" class="flex items-center">
                    <input type="hidden" name="action" value="list">
                    <div class="flex-1 relative">
                        <span class="absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400">🔍</span>
                        <input type="text" name="search" value="${param.search}" placeholder="Search by name or phone number..." class="w-full pl-12 pr-4 py-3 rounded-xl border-2 border-gray-100 focus:border-blue-500 transition-colors">
                    </div>
                    <button type="submit" class="ml-4 bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-8 rounded-xl transition-colors">
                        Search
                    </button>
                    <c:if test="${not empty param.search}">
                        <a href="${pageContext.request.contextPath}/guests?action=list" class="ml-2 text-gray-500 hover:text-gray-700 underline">Clear</a>
                    </c:if>
                </form>
            </div>

            <div class="card bg-white shadow-xl rounded-2xl overflow-hidden animate-[fadeIn_0.9s_ease-out]">
                <div class="overflow-x-auto">
                    <table class="min-w-full leading-normal">
                        <thead>
                            <tr>
                                <th class="px-6 py-4 border-b-2 border-gray-100 bg-gray-50 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">ID</th>
                                <th class="px-6 py-4 border-b-2 border-gray-100 bg-gray-50 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Name</th>
                                <th class="px-6 py-4 border-b-2 border-gray-100 bg-gray-50 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Contact</th>
                                <th class="px-6 py-4 border-b-2 border-gray-100 bg-gray-50 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Email</th>
                                <th class="px-6 py-4 border-b-2 border-gray-100 bg-gray-50 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Address</th>
                                <!-- <th class="px-6 py-4 border-b-2 border-gray-100 bg-gray-50 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Actions</th> -->
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="guest" items="${guests}">
                                <tr class="hover:bg-blue-50 transition-colors border-b border-gray-50 last:border-0">
                                    <td class="px-6 py-4 text-sm text-gray-600">#${guest.guestId}</td>
                                    <td class="px-6 py-4 text-sm font-bold text-gray-800">${guest.fullName}</td>
                                    <td class="px-6 py-4 text-sm text-gray-600">${guest.contactNumber}</td>
                                    <td class="px-6 py-4 text-sm text-gray-600">${guest.email}</td>
                                    <td class="px-6 py-4 text-sm text-gray-600 truncate max-w-xs" title="${guest.address}">${guest.address}</td>
                                    <!-- 
                                    <td class="px-6 py-4 text-sm">
                                        <a href="#" class="text-blue-600 hover:text-blue-800 font-medium">Edit</a>
                                    </td>
                                    -->
                                </tr>
                            </c:forEach>
                            <c:if test="${empty guests}">
                                <tr>
                                    <td colspan="5" class="px-6 py-10 text-center text-gray-500">
                                        No guests found matching your criteria.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
