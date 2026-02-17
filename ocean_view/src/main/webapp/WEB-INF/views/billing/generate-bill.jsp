<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Bill - Ocean View Resort</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/styles.css" rel="stylesheet">
</head>
<body class="flex bg-gray-50">
    
    <!-- Sidebar -->
    <div class="sidebar w-64 flex flex-col shadow-2xl z-20 no-print">
         <div class="p-6 text-center border-b border-gray-700 bg-opacity-20 bg-white">
            <h2 class="text-2xl font-bold tracking-wider">Ocean View</h2>
            <p class="text-xs text-blue-200 mt-1 uppercase tracking-widest">Resort Management</p>
        </div>
        <nav class="flex-1 p-4 space-y-2 mt-4">
            <a href="${pageContext.request.contextPath}/dashboard" class="nav-link rounded-xl">
                 <span class="mr-3">📊</span> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/reservation?action=list" class="nav-link rounded-xl">
                 <span class="mr-3">📅</span> Reservations
            </a>
        </nav>
    </div>

    <div class="flex-1 p-10 overflow-y-auto h-screen relative">
        <!-- Header Background -->
        <div class="absolute top-0 left-0 w-full h-48 bg-gradient-to-r from-blue-600 to-blue-400 z-0 rounded-b-3xl shadow-lg no-print"></div>

        <div class="relative z-10 w-full max-w-3xl mx-auto">
            <div class="flex justify-between items-center mb-6 no-print animate-[fadeIn_0.5s_ease-out]">
                <h1 class="text-3xl font-bold text-white drop-shadow-md">Invoice Review</h1>
                 <div class="space-x-3">
                    <button onclick="window.print()" class="bg-white hover:bg-gray-50 text-gray-700 font-bold py-2 px-4 rounded-lg shadow-md transition-all">
                       🖨️ Print
                    </button>
                    <a href="${pageContext.request.contextPath}/bill?reservationId=${bill.reservationId}&action=pdf" target="_blank" class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-lg shadow-md transition-all">
                        ⬇️ Download PDF
                    </a>
                 </div>
            </div>

            <div class="bg-white p-12 rounded-2xl shadow-xl border border-gray-100 print:shadow-none print:border-none animate-[float_1s_ease-out]">
                <!-- Invoice Header -->
                <div class="flex justify-between items-start border-b border-gray-100 pb-8 mb-8">
                    <div>
                        <div class="flex items-center mb-2">
                             <div class="w-10 h-10 rounded-lg bg-blue-600 flex items-center justify-center text-white font-bold text-xl mr-3">
                                OV
                            </div>
                            <h2 class="text-2xl font-bold text-gray-800 tracking-tight">Ocean View Resort</h2>
                        </div>
                        <p class="text-gray-500 text-sm">123 Ocean Drive, Paradise City</p>
                        <p class="text-gray-500 text-sm">contact@oceanview.com</p>
                    </div>
                    <div class="text-right">
                        <h3 class="text-4xl font-bold text-blue-600 mb-1">INVOICE</h3>
                        <p class="text-gray-600 font-medium">#INV-${bill.billId}</p>
                        <p class="text-gray-500 text-sm mt-1">Date: ${bill.billDate}</p>
                    </div>
                </div>

                <!-- Bill Details Grid -->
                <div class="grid grid-cols-2 gap-10 mb-10">
                    <div>
                         <h3 class="text-gray-400 text-xs uppercase font-bold tracking-wider mb-2">Billed To</h3>
                         <p class="text-lg font-bold text-gray-800">Guest ID: ${bill.reservationId}</p>
                         <p class="text-gray-600">Reservation #${bill.reservationId}</p>
                    </div>
                    <div class="text-right">
                        <h3 class="text-gray-400 text-xs uppercase font-bold tracking-wider mb-2">Payment Status</h3>
                        <div class="inline-block">
                             <span class="${bill.paymentStatus == 'PAID' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'} px-3 py-1 rounded-full text-sm font-bold">
                                ${bill.paymentStatus}
                            </span>
                        </div>
                         <p class="text-gray-500 text-sm mt-2">Total Nights: ${bill.totalNights}</p>
                    </div>
                </div>

                <!-- Line Items Table -->
                <div class="mb-8">
                    <table class="w-full">
                        <thead>
                            <tr class="bg-gray-50 border-y border-gray-100">
                                <th class="text-left py-3 px-4 text-gray-500 uppercase text-xs font-bold tracking-wider">Description</th>
                                <th class="text-right py-3 px-4 text-gray-500 uppercase text-xs font-bold tracking-wider">Amount</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-50">
                            <tr>
                                <td class="py-4 px-4 text-gray-800 font-medium">Room Charges (${bill.totalNights} nights)</td>
                                <td class="text-right py-4 px-4 font-mono text-gray-700">$${bill.roomCharges}</td>
                            </tr>
                            <tr>
                                <td class="py-4 px-4 text-gray-800 font-medium">Tax (12%)</td>
                                <td class="text-right py-4 px-4 font-mono text-gray-700">$${bill.taxAmount}</td>
                            </tr>
                            <tr>
                                <td class="py-4 px-4 text-gray-800 font-medium">Service Charges (10%)</td>
                                <td class="text-right py-4 px-4 font-mono text-gray-700">$${bill.serviceCharges}</td>
                            </tr>
                            <tr class="${bill.discount > 0 ? '' : 'hidden'}">
                                <td class="py-4 px-4 text-gray-800 font-medium">Discount</td>
                                <td class="text-right py-4 px-4 font-mono text-green-600">-$${bill.discount}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                
                <!-- Total -->
                 <div class="flex justify-end border-t-2 border-gray-100 pt-6">
                    <div class="text-right">
                        <p class="text-gray-500 text-sm mb-1 uppercase font-bold">Total Due</p>
                        <p class="text-4xl font-bold text-blue-600 tracking-tight">$${bill.totalAmount}</p>
                    </div>
                </div>

                <div class="mt-12 pt-8 border-t border-gray-100 text-center">
                    <p class="text-gray-500 text-sm italic">Thank you for choosing Ocean View Resort!</p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
