const API_BASE_URL = 'api/v1';

async function fetchReservations() {
    try {
        const response = await fetch(`${API_BASE_URL}/reservations`);
        if (!response.ok) throw new Error('Failed to fetch reservations');
        return await response.json();
    } catch (error) {
        console.error('Error:', error);
        return [];
    }
}

async function checkRoomAvailability(checkIn, checkOut) {
    // This could use the API if we exposed it, or the servlet
    // For now, this is a placeholder for future API interaction
    console.log('Checking availability for', checkIn, checkOut);
}
