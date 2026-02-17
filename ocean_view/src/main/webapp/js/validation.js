function validateReservationForm() {
    const guestName = document.getElementById('guestName').value;
    const contact = document.getElementById('contact').value;
    const checkIn = document.getElementById('checkInDate').value;
    const checkOut = document.getElementById('checkOutDate').value;
    const roomId = document.getElementById('roomId').value;

    if (guestName.trim().length < 3) {
        alert('Guest name must be at least 3 characters');
        return false;
    }

    // specific validation for 10-15 digits
    if (!contact.match(/^\+?[0-9]{10,15}$/)) {
        alert('Invalid phone number. It should be 10-15 digits.');
        return false;
    }

    if (!checkIn || !checkOut) {
        alert('Please select both check-in and check-out dates');
        return false;
    }

    if (new Date(checkOut) <= new Date(checkIn)) {
        alert('Check-out date must be after check-in date');
        return false;
    }

    if (!roomId) {
        alert('Please select a room');
        return false;
    }

    return true;
}

function validateLoginForm() {
    const username = document.getElementById('username').value;
    if (!username) {
        alert('Username is required');
        return false;
    }
    return true;
}
