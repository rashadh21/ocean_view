<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>View Reservation - Ocean View Resort</title>
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

    <div class="flex-1 p-10 overflow-y-auto h-screen relative">
        <!-- Header Background -->
        <div class="absolute top-0 left-0 w-full h-48 bg-gradient-to-r from-blue-600 to-blue-400 z-0 rounded-b-3xl shadow-lg"></div>

        <div class="relative z-10 w-full max-w-4xl mx-auto">
            <div class="flex justify-between items-center mb-8 animate-[fadeIn_0.5s_ease-out]">
                <div>
                    <a href="${pageContext.request.contextPath}/reservation?action=list" class="text-blue-100 hover:text-white mb-2 inline-block transition-colors">&larr; Back to List</a>
                    <h1 class="text-3xl font-bold text-white drop-shadow-md">Reservation Details</h1>
                </div>
                <div class="bg-white/20 backdrop-blur-md px-4 py-2 rounded-lg text-white font-mono border border-white/30">
                    #${reservation.reservationNumber}
                </div>
            </div>

            <c:if test="${not empty reservation}">
                <div class="card bg-white rounded-2xl shadow-xl overflow-hidden animate-[fadeIn_0.8s_ease-out]">
                    <!-- Status Header -->
                    <div class="px-8 py-6 border-b border-gray-100 bg-gray-50 flex justify-between items-center">
                        <span class="text-gray-500 font-medium">Current Status</span>
                        <span class="badge status-${reservation.status.toLowerCase()} text-lg px-4 py-1">
                            ${reservation.status}
                        </span>
                    </div>

                    <div class="p-8 grid grid-cols-1 md:grid-cols-2 gap-10">
                        <!-- Guest Section -->
                        <div class="space-y-4">
                            <h3 class="text-gray-400 text-xs uppercase font-bold tracking-wider mb-4 border-b pb-2">Guest Information</h3>
                            <div class="flex items-start">
                                <div class="w-12 h-12 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center text-xl font-bold mr-4">
                                    👤
                                </div>
                                <div>
                                    <p class="text-xl font-bold text-gray-800">${reservation.guest.fullName}</p>
                                    <p class="text-gray-500 text-sm">Guest ID: ${reservation.guestId}</p>
                                    <p class="text-gray-600 mt-2">${reservation.guest.contactNumber}</p>
                                    <p class="text-gray-600">${reservation.guest.email}</p>
                                </div>
                            </div>
                        </div>

                        <!-- Stay Section -->
                        <div class="space-y-4">
                            <h3 class="text-gray-400 text-xs uppercase font-bold tracking-wider mb-4 border-b pb-2">Stay Details</h3>
                            <div class="bg-blue-50 rounded-xl p-4 border border-blue-100">
                                <div class="flex justify-between items-center mb-2">
                                    <div class="text-center">
                                        <p class="text-xs text-gray-500 uppercase">Check-In</p>
                                        <p class="font-bold text-gray-800">${reservation.checkInDate}</p>
                                    </div>
                                    <div class="text-blue-300">➜</div>
                                    <div class="text-center">
                                        <p class="text-xs text-gray-500 uppercase">Check-Out</p>
                                        <p class="font-bold text-gray-800">${reservation.checkOutDate}</p>
                                    </div>
                                </div>
                                <div class="mt-4 pt-4 border-t border-blue-200 flex justify-between items-center">
                                    <div>
                                        <p class="text-xs text-gray-500 uppercase">Room</p>
                                        <p class="font-bold text-gray-800 text-lg">${reservation.room.roomNumber}</p>
                                    </div>
                                     <div>
                                        <p class="text-xs text-gray-500 uppercase text-right">Type</p>
                                        <p class="font-bold text-gray-800 text-right">${reservation.room.roomType.typeName}</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Actions Footer -->
                    <div class="bg-gray-50 px-8 py-6 border-t border-gray-100 flex justify-end space-x-4">
                        <a href="${pageContext.request.contextPath}/bill?reservationId=${reservation.reservationId}&action=generate" class="btn bg-green-500 hover:bg-green-600 text-white font-bold py-3 px-6 rounded-xl shadow-lg transform hover:-translate-y-1 transition-all flex items-center">
                            <span class="mr-2">📄</span> Generate Bill
                        </a>
                        <c:if test="${reservation.status != 'CANCELLED'}">
                            <a href="${pageContext.request.contextPath}/reservation?action=cancel&id=${reservation.reservationId}" class="btn bg-white hover:bg-red-50 text-red-500 border border-red-200 hover:border-red-300 font-bold py-3 px-6 rounded-xl shadow-sm transform hover:-translate-y-1 transition-all" onclick="return confirm('Are you sure you want to cancel this reservation?')">
                                Cancel Reservation
                            </a>
                        </c:if>
                    </div>
                </div>
            </c:if>

            <c:if test="${empty reservation}">
                <div class="card p-8 bg-white rounded-2xl text-center shadow-lg">
                    <p class="text-red-500 text-lg font-medium">Reservation not found.</p>
                </div>
            </c:if>
        </div>
    </div>
</body>
</html>
