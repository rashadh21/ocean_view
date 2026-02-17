<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Check Availability - Ocean View Resort</title>
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
            <a href="${pageContext.request.contextPath}/reservation?action=list" class="nav-link rounded-xl">
                 <span class="mr-3">📅</span> Reservations
            </a>
             <a href="${pageContext.request.contextPath}/rooms?action=available" class="nav-link active rounded-xl">
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

        <div class="relative z-10 w-full max-w-5xl mx-auto">
            <div class="mb-10 text-center animate-[fadeIn_0.5s_ease-out]">
                <h1 class="text-3xl font-bold text-white mb-2 drop-shadow-md">Check Room Availability</h1>
                <p class="text-blue-100 opacity-90">Find the perfect room for your guests.</p>
            </div>

            <div class="card bg-white p-8 rounded-2xl shadow-xl mb-8 animate-[fadeIn_0.8s_ease-out]">
                 <form action="${pageContext.request.contextPath}/rooms" method="get" class="flex flex-col md:flex-row items-end space-y-4 md:space-y-0 md:space-x-6">
                    <input type="hidden" name="action" value="available">
                    <div class="flex-1 w-full">
                        <label class="block text-gray-700 text-sm font-bold mb-2 ml-1">Check-In Date</label>
                        <input type="date" name="checkIn" value="${param.checkIn}" class="w-full px-4 py-3 rounded-xl border-2 border-gray-200 focus:border-blue-500 transition-colors" required>
                    </div>
                    <div class="flex-1 w-full">
                        <label class="block text-gray-700 text-sm font-bold mb-2 ml-1">Check-Out Date</label>
                        <input type="date" name="checkOut" value="${param.checkOut}" class="w-full px-4 py-3 rounded-xl border-2 border-gray-200 focus:border-blue-500 transition-colors" required>
                    </div>
                    <button type="submit" class="w-full md:w-auto bg-gradient-to-r from-blue-500 to-blue-600 hover:from-blue-600 hover:to-blue-700 text-white font-bold py-3 px-8 rounded-xl shadow-lg transform hover:-translate-y-1 transition-all h-[52px]">
                        Find Rooms
                    </button>
                </form>
            </div>

            <c:if test="${not empty availableRooms}">
                 <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 animate-[fadeIn_1s_ease-out]">
                     <c:forEach var="room" items="${availableRooms}">
                        <div class="card bg-white rounded-2xl shadow-md overflow-hidden hover:shadow-xl transition-all hover:-translate-y-2 border border-gray-100">
                            <div class="h-32 bg-gradient-to-br from-blue-400 to-blue-600 relative p-6">
                                <h3 class="text-white text-3xl font-bold">${room.roomNumber}</h3>
                                <div class="absolute top-4 right-4 bg-white/20 backdrop-blur-md rounded-lg px-3 py-1 text-white text-sm font-semibold">
                                    ID: ${room.roomId}
                                </div>
                                <div class="absolute bottom-4 left-6 text-blue-100 font-medium">
                                    ${room.roomType.typeName}
                                </div>
                            </div>
                            <div class="p-6">
                                <div class="flex justify-between items-center mb-4 pb-4 border-b border-gray-100">
                                    <span class="text-gray-500 text-sm">Price per night</span>
                                    <span class="text-2xl font-bold text-gray-800">$${room.roomType.basePrice}</span>
                                </div>
                                <div class="space-y-2 text-sm text-gray-600 mb-6">
                                    <div class="flex items-center">
                                        <span class="mr-2">👥</span> Capacity: ${room.roomType.capacity} Guests
                                    </div>
                                    <div class="flex items-center">
                                        <span class="mr-2">🏢</span> Floor: ${room.floorNumber}
                                    </div>
                                </div>
                                <a href="${pageContext.request.contextPath}/reservation?action=new&roomId=${room.roomId}&checkIn=${param.checkIn}&checkOut=${param.checkOut}" class="btn block w-full text-center bg-blue-50 hover:bg-blue-100 text-blue-700 py-3 rounded-xl font-bold transition-colors">
                                    Book Now
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>

             <c:if test="${empty availableRooms and not empty param.checkIn}">
                <div class="text-center py-16 bg-white rounded-2xl shadow-md animate-[fadeIn_0.5s_ease-out]">
                    <span class="text-6xl mb-4 block">🏝️</span>
                    <h3 class="text-2xl font-bold text-gray-800 mb-2">No Rooms Available</h3>
                    <p class="text-gray-500 text-lg">We're fully booked for these dates. Please try different dates.</p>
                </div>
            </c:if>
        </div>
    </div>
</body>
</html>
