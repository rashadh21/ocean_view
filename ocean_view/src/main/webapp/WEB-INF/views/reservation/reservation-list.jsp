<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reservation List - Ocean View Resort</title>
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
            <a href="${pageContext.request.contextPath}/reservation?action=list" class="nav-link active rounded-xl">
                 <span class="mr-3">📅</span> Reservations
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

    <div class="flex-1 overflow-y-auto h-screen p-10 relative">
        <!-- Header Background -->
        <div class="absolute top-0 left-0 w-full h-48 bg-gradient-to-r from-blue-600 to-blue-400 z-0 rounded-b-3xl shadow-lg"></div>
        
        <div class="relative z-10">
            <div class="flex justify-between items-center mb-10 animate-[fadeIn_0.5s_ease-out]">
                <div>
                    <h1 class="text-3xl font-bold text-white mb-2 drop-shadow-md">Reservations</h1>
                    <p class="text-blue-100 opacity-90">Manage all bookings and guests.</p>
                </div>
                <a href="${pageContext.request.contextPath}/reservation?action=new" class="btn bg-white text-blue-600 hover:bg-blue-50 font-bold py-3 px-6 rounded-xl shadow-lg transform hover:-translate-y-1 transition-all flex items-center">
                    <span class="mr-2 text-xl">+</span> New Reservation
                </a>
            </div>

            <div class="card bg-white shadow-xl rounded-2xl overflow-hidden animate-[fadeIn_0.8s_ease-out]">
                <div class="overflow-x-auto">
                    <table class="min-w-full leading-normal">
                        <thead>
                            <tr>
                                <th class="px-6 py-4 border-b-2 border-gray-100 bg-gray-50 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">
                                    Reservation Info
                                </th>
                                <th class="px-6 py-4 border-b-2 border-gray-100 bg-gray-50 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">
                                    Guest Details
                                </th>
                                <th class="px-6 py-4 border-b-2 border-gray-100 bg-gray-50 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">
                                    Room
                                </th>
                                <th class="px-6 py-4 border-b-2 border-gray-100 bg-gray-50 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">
                                    Stay Dates
                                </th>
                                <th class="px-6 py-4 border-b-2 border-gray-100 bg-gray-50 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">
                                    Status
                                </th>
                                <th class="px-6 py-4 border-b-2 border-gray-100 bg-gray-50 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">
                                    Actions
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="res" items="${listReservation}">
                                <tr class="hover:bg-blue-50 transition-colors border-b border-gray-50 last:border-0">
                                    <td class="px-6 py-6 text-sm">
                                        <div class="flex items-center">
                                            <div class="flex-shrink-0 w-10 h-10 rounded-full bg-blue-100 text-blue-500 flex items-center justify-center font-bold mr-3">
                                                #
                                            </div>
                                            <div>
                                                <p class="text-gray-900 font-bold text-base leading-tight">${res.reservationNumber}</p>
                                                <p class="text-gray-400 text-xs mt-1">ID: ${res.reservationId}</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-6 py-6 text-sm">
                                        <p class="text-gray-900 font-medium text-base">${res.guest.fullName}</p>
                                        <p class="text-gray-500 text-xs mt-1">Guest ID: ${res.guestId}</p>
                                    </td>
                                    <td class="px-6 py-6 text-sm">
                                        <span class="px-3 py-1 rounded-lg bg-indigo-100 text-indigo-700 font-semibold text-xs">
                                            Room ${res.room.roomNumber}
                                        </span>
                                    </td>
                                    <td class="px-6 py-6 text-sm">
                                        <div class="flex flex-col">
                                            <span class="text-gray-800 font-medium">${res.checkInDate}</span>
                                            <span class="text-gray-400 text-xs my-1">to</span>
                                            <span class="text-gray-800 font-medium">${res.checkOutDate}</span>
                                        </div>
                                    </td>
                                    <td class="px-6 py-6 text-sm">
                                        <span class="badge status-${res.status.toLowerCase()}">
                                            ${res.status}
                                        </span>
                                    </td>
                                    <td class="px-6 py-6 text-sm">
                                        <a href="${pageContext.request.contextPath}/reservation?action=view&id=${res.reservationId}" class="inline-flex items-center text-blue-600 hover:text-blue-800 font-medium transition-colors">
                                            View Details <span class="ml-1 text-lg">&rarr;</span>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listReservation}">
                                <tr>
                                    <td colspan="6" class="px-6 py-10 text-center text-gray-500">
                                        <div class="flex flex-col items-center justify-center">
                                            <span class="text-4xl mb-3">📭</span>
                                            <p class="text-lg font-medium">No reservations found.</p>
                                            <a href="${pageContext.request.contextPath}/reservation?action=new" class="mt-4 text-blue-600 hover:underline">Create your first reservation</a>
                                        </div>
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
