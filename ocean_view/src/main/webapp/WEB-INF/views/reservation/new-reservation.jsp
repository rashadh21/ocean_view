<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>New Reservation - Ocean View Resort</title>
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
            <a href="${pageContext.request.contextPath}/reservation?action=new" class="nav-link active rounded-xl">
                 <span class="mr-3">➕</span> New Reservation
            </a>
            <a href="${pageContext.request.contextPath}/reservation?action=list" class="nav-link rounded-xl">
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
            <h1 class="text-3xl font-bold text-white mb-8 drop-shadow-md animate-[fadeIn_0.5s_ease-out]">Create New Reservation</h1>
            
            <div class="card bg-white p-8 rounded-2xl shadow-xl animate-[fadeIn_0.8s_ease-out]">
                <% if (request.getAttribute("error") != null) { %>
                    <div class="bg-red-50 border-l-4 border-red-500 text-red-700 p-4 mb-8 rounded-r flex items-center shadow-sm">
                        <span class="text-2xl mr-3">⚠️</span>
                        <p><%= request.getAttribute("error") %></p>
                    </div>
                <% } %>

                <form action="${pageContext.request.contextPath}/reservation" method="post" onsubmit="return validateReservationForm()">
                    
                    <!-- Section: Guest Selection/Search -->
                    <div class="mb-8 p-6 bg-blue-50 rounded-xl border border-blue-100 relative">
                        <h3 class="text-lg font-bold text-gray-800 mb-4 flex items-center">
                            <span class="w-8 h-8 rounded-full bg-blue-600 text-white flex items-center justify-center text-sm mr-3">1</span>
                            Find Guest
                        </h3>
                        <div class="relative">
                            <input type="text" id="guestSearch" class="w-full px-4 py-3 pl-10 rounded-xl border-2 border-blue-200 focus:border-blue-500 transition-colors" placeholder="Search existing guest by name or phone..." autocomplete="off">
                            <span class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400">🔍</span>
                            
                            <!-- Search Results Dropdown -->
                            <div id="searchResults" class="hidden absolute top-full left-0 w-full bg-white shadow-xl rounded-xl z-50 mt-2 max-h-60 overflow-y-auto border border-gray-100">
                                <!-- Results populated by JS -->
                            </div>
                        </div>
                        <p class="text-xs text-gray-500 mt-2 ml-1">Type to search existing guests. Click to auto-fill details.</p>
                    </div>

                    <!-- Hidden field to store selected Guest ID if any -->
                    <input type="hidden" id="existingGuestId" name="existingGuestId">

                    <!-- Section: Guest Info -->
                    <div class="mb-8">
                        <h3 class="text-lg font-bold text-gray-800 mb-6 flex items-center">
                            <span class="w-8 h-8 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center text-sm mr-3">2</span>
                            Guest Information
                        </h3>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 relative">
                            <!-- Overlay to disable fields when guest is selected (optional UX) -->
                            
                            <div>
                                <label class="block text-gray-700 text-sm font-bold mb-2 ml-1">Full Name</label>
                                <input type="text" id="guestName" name="guestName" class="w-full px-4 py-3 rounded-xl border-2 border-gray-200 focus:border-blue-500 transition-colors" placeholder="e.g. John Doe" required>
                            </div>
                            <div>
                                <label class="block text-gray-700 text-sm font-bold mb-2 ml-1">Contact Number</label>
                                <input type="text" id="contact" name="contact" class="w-full px-4 py-3 rounded-xl border-2 border-gray-200 focus:border-blue-500 transition-colors" placeholder="e.g. +1 234 567 890" required>
                            </div>
                            <div>
                                <label class="block text-gray-700 text-sm font-bold mb-2 ml-1">Email (Optional)</label>
                                <input type="email" id="email" name="email" class="w-full px-4 py-3 rounded-xl border-2 border-gray-200 focus:border-blue-500 transition-colors" placeholder="john@example.com">
                            </div>
                             <div>
                                <label class="block text-gray-700 text-sm font-bold mb-2 ml-1">Address (Optional)</label>
                                <input type="text" id="address" name="address" class="w-full px-4 py-3 rounded-xl border-2 border-gray-200 focus:border-blue-500 transition-colors" placeholder="Billing Address">
                            </div>
                            
                            <div class="md:col-span-2 text-right">
                                <button type="button" id="clearGuest" class="hidden text-sm text-red-500 hover:text-red-700 underline" onclick="clearGuestForm()">Clear Guest Selection</button>
                            </div>
                        </div>
                    </div>

                    <div class="border-t border-gray-100 my-8"></div>

                    <!-- Section: Reservation Details -->
                    <div class="mb-8">
                         <h3 class="text-lg font-bold text-gray-800 mb-6 flex items-center">
                            <span class="w-8 h-8 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center text-sm mr-3">3</span>
                            Stay Details
                        </h3>
                        <!-- ... (same date fields) ... -->
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                            <div>
                                <label class="block text-gray-700 text-sm font-bold mb-2 ml-1">Check-In Date</label>
                                <input type="date" id="checkInDate" name="checkInDate" value="${param.checkIn}" class="w-full px-4 py-3 rounded-xl border-2 border-gray-200 focus:border-blue-500 transition-colors" required>
                            </div>
                            <div>
                                <label class="block text-gray-700 text-sm font-bold mb-2 ml-1">Check-Out Date</label>
                                <input type="date" id="checkOutDate" name="checkOutDate" value="${param.checkOut}" class="w-full px-4 py-3 rounded-xl border-2 border-gray-200 focus:border-blue-500 transition-colors" required>
                            </div>
                            <div>
                                <label class="block text-gray-700 text-sm font-bold mb-2 ml-1">Room ID</label>
                                <div class="relative">
                                    <input type="number" id="roomId" name="roomId" value="${param.roomId}" class="w-full px-4 py-3 rounded-xl border-2 border-gray-200 focus:border-blue-500 transition-colors" placeholder="Enter Room ID" required>
                                    <a href="${pageContext.request.contextPath}/rooms?action=available" class="absolute right-3 top-3 text-sm text-blue-600 font-bold hover:underline cursor-pointer">Check Availability</a>
                                </div>
                            </div>
                            <div>
                                <label class="block text-gray-700 text-sm font-bold mb-2 ml-1">Number of Guests</label>
                                <input type="number" name="numGuests" min="1" value="1" class="w-full px-4 py-3 rounded-xl border-2 border-gray-200 focus:border-blue-500 transition-colors">
                            </div>
                        </div>
                        
                         <div class="mb-4">
                            <label class="block text-gray-700 text-sm font-bold mb-2 ml-1">Special Requests</label>
                            <textarea name="specialRequests" class="w-full px-4 py-3 rounded-xl border-2 border-gray-200 focus:border-blue-500 transition-colors" rows="3" placeholder="Any specific requirements?"></textarea>
                        </div>
                    </div>

                    <div class="flex items-center justify-end mt-10">
                        <a href="${pageContext.request.contextPath}/dashboard" class="mr-4 text-gray-500 hover:text-gray-700 font-medium">Cancel</a>
                        <button type="submit" class="bg-gradient-to-r from-blue-500 to-blue-600 hover:from-blue-600 hover:to-blue-700 text-white font-bold py-3 px-8 rounded-xl shadow-lg transform hover:-translate-y-1 transition-all">
                            Confirm Reservation
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        const guestSearchInput = document.getElementById('guestSearch');
        const searchResultsDiv = document.getElementById('searchResults');
        
        let debounceTimer;

        guestSearchInput.addEventListener('input', function() {
            clearTimeout(debounceTimer);
            const query = this.value;
            
            if (query.length < 2) {
                searchResultsDiv.classList.add('hidden');
                return;
            }

            debounceTimer = setTimeout(() => {
                fetch('${pageContext.request.contextPath}/api/v1/guests?search=' + encodeURIComponent(query))
                    .then(response => response.json())
                    .then(data => {
                        searchResultsDiv.innerHTML = '';
                        if (data.length > 0) {
                            searchResultsDiv.classList.remove('hidden');
                            data.forEach(guest => {
                                const div = document.createElement('div');
                                div.className = 'p-3 hover:bg-blue-50 cursor-pointer border-b border-gray-50 last:border-0 transition-colors';
                                div.innerHTML = `
                                    <p class="font-bold text-gray-800">\${guest.fullName}</p>
                                    <p class="text-xs text-gray-500">\${guest.contactNumber} | \${guest.email || 'No email'}</p>
                                `;
                                div.onclick = () => selectGuest(guest);
                                searchResultsDiv.appendChild(div);
                            });
                        } else {
                            searchResultsDiv.classList.add('hidden');
                        }
                    });
            }, 300);
        });

        // Hide dropdown when clicking outside
        document.addEventListener('click', function(e) {
            if (!guestSearchInput.contains(e.target) && !searchResultsDiv.contains(e.target)) {
                searchResultsDiv.classList.add('hidden');
            }
        });

        function selectGuest(guest) {
            document.getElementById('guestName').value = guest.fullName;
            document.getElementById('contact').value = guest.contactNumber;
            document.getElementById('email').value = guest.email || '';
            document.getElementById('address').value = guest.address || '';
            document.getElementById('existingGuestId').value = guest.guestId;
            
            // Visual feedback
            guestSearchInput.value = ''; // Clear search
            searchResultsDiv.classList.add('hidden');
            
            document.getElementById('clearGuest').classList.remove('hidden');
            // Optional: Disable fields to prevent editing existing guest data from here
            // document.getElementById('guestName').readOnly = true;
            // ...
        }

        function clearGuestForm() {
            document.getElementById('guestName').value = '';
            document.getElementById('contact').value = '';
            document.getElementById('email').value = '';
            document.getElementById('address').value = '';
            document.getElementById('existingGuestId').value = '';
            document.getElementById('clearGuest').classList.add('hidden');
        }
    </script>
            </div>
        </div>
    </div>
</body>
</html>
