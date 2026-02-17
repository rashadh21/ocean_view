-- Create Database (if not exists)
CREATE DATABASE IF NOT EXISTS oceanview_resort;
USE oceanview_resort;

-- 1. users
CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role ENUM('ADMIN', 'STAFF', 'MANAGER') DEFAULT 'STAFF',
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    is_active BOOLEAN DEFAULT TRUE
);

-- 2. room_types
CREATE TABLE IF NOT EXISTS room_types (
    room_type_id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(50) NOT NULL,
    description TEXT,
    base_price DECIMAL(10, 2) NOT NULL,
    capacity INT NOT NULL,
    amenities TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. rooms
CREATE TABLE IF NOT EXISTS rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_number VARCHAR(20) UNIQUE NOT NULL,
    room_type_id INT NOT NULL,
    floor_number INT,
    status ENUM('AVAILABLE', 'OCCUPIED', 'MAINTENANCE', 'RESERVED') DEFAULT 'AVAILABLE',
    FOREIGN KEY (room_type_id) REFERENCES room_types(room_type_id)
);

-- 4. guests
CREATE TABLE IF NOT EXISTS guests (
    guest_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    address TEXT,
    contact_number VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    id_number VARCHAR(50),
    nationality VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. reservations
CREATE TABLE IF NOT EXISTS reservations (
    reservation_id INT PRIMARY KEY AUTO_INCREMENT,
    reservation_number VARCHAR(20) UNIQUE,
    guest_id INT NOT NULL,
    room_id INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    number_of_guests INT DEFAULT 1,
    special_requests TEXT,
    status ENUM('PENDING', 'CONFIRMED', 'CHECKED_IN', 'CHECKED_OUT', 'CANCELLED') DEFAULT 'PENDING',
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (guest_id) REFERENCES guests(guest_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id),
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

-- 6. bills
CREATE TABLE IF NOT EXISTS bills (
    bill_id INT PRIMARY KEY AUTO_INCREMENT,
    reservation_id INT NOT NULL,
    total_nights INT NOT NULL,
    room_charges DECIMAL(10, 2) NOT NULL,
    tax_amount DECIMAL(10, 2) DEFAULT 0.00,
    service_charges DECIMAL(10, 2) DEFAULT 0.00,
    discount DECIMAL(10, 2) DEFAULT 0.00,
    total_amount DECIMAL(10, 2) NOT NULL,
    payment_status ENUM('UNPAID', 'PARTIALLY_PAID', 'PAID') DEFAULT 'UNPAID',
    payment_method VARCHAR(50),
    bill_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reservation_id) REFERENCES reservations(reservation_id)
);

-- 7. audit_log
CREATE TABLE IF NOT EXISTS audit_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(50),
    entity_id INT,
    details TEXT,
    ip_address VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Stored Procedures

-- 1. Calculate Bill
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS CalculateBill(
    IN p_reservation_id INT,
    OUT p_total_amount DECIMAL(10, 2)
)
BEGIN
    DECLARE v_nights INT;
    DECLARE v_base_price DECIMAL(10, 2);
    DECLARE v_room_charges DECIMAL(10, 2);
    DECLARE v_tax DECIMAL(10, 2);
    DECLARE v_service DECIMAL(10, 2);

    SELECT DATEDIFF(check_out_date, check_in_date),
           rt.base_price
    INTO v_nights, v_base_price
    FROM reservations r
    JOIN rooms rm ON r.room_id = rm.room_id
    JOIN room_types rt ON rm.room_type_id = rt.room_type_id
    WHERE r.reservation_id = p_reservation_id;

    -- Ensure minimum 1 night charge
    IF v_nights < 1 THEN
        SET v_nights = 1;
    END IF;

    SET v_room_charges = v_nights * v_base_price;
    SET v_tax = v_room_charges * 0.12; -- 12% tax
    SET v_service = v_room_charges * 0.10; -- 10% service charge
    SET p_total_amount = v_room_charges + v_tax + v_service;

    INSERT INTO bills (reservation_id, total_nights, room_charges, 
                       tax_amount, service_charges, total_amount)
    VALUES (p_reservation_id, v_nights, v_room_charges, v_tax, v_service, p_total_amount);
END$$
DELIMITER ;

-- 2. Check Room Availability
DELIMITER $$
CREATE FUNCTION CheckRoomAvailability(
    p_room_id INT,
    p_check_in DATE,
    p_check_out DATE
) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE v_count INT;

    SELECT COUNT(*)
    INTO v_count
    FROM reservations
    WHERE room_id = p_room_id
    AND status IN ('CONFIRMED', 'CHECKED_IN')
    AND (
        (check_in_date <= p_check_in AND check_out_date > p_check_in)
        OR (check_in_date < p_check_out AND check_out_date >= p_check_out)
        OR (check_in_date >= p_check_in AND check_out_date <= p_check_out)
    );

    IF v_count > 0 THEN
        RETURN FALSE;
    ELSE
        RETURN TRUE;
    END IF;
END$$
DELIMITER ;

-- 3. Generate Reservation Number
DELIMITER $$
CREATE TRIGGER IF NOT EXISTS generate_reservation_number
BEFORE INSERT ON reservations
FOR EACH ROW
BEGIN
    DECLARE v_year VARCHAR(4);
    DECLARE v_count INT;
    DECLARE v_res_num VARCHAR(20);

    SET v_year = YEAR(CURDATE());

    SELECT COUNT(*) + 1 INTO v_count
    FROM reservations
    WHERE YEAR(created_at) = v_year;

    SET v_res_num = CONCAT('RES', v_year, LPAD(v_count, 6, '0'));
    SET NEW.reservation_number = v_res_num;
END$$
DELIMITER ;

-- Insert Sample Data

-- User (password: password123 hashed with BCrypt)
-- Note: You should generate a real hash using your utility in Java, this is a placeholder
INSERT INTO users (username, password, full_name, role, email) VALUES
('admin', '$2a$10$wS.xk...hashed_placeholder...', 'Administrator', 'ADMIN', 'admin@oceanview.com'),
('staff', '$2a$10$wS.xk...hashed_placeholder...', 'Staff Member', 'STAFF', 'staff@oceanview.com');


-- Room Types
INSERT INTO room_types (type_name, description, base_price, capacity) VALUES
('Standard', 'Comfortable standard room', 100.00, 2),
('Deluxe', 'Spacious deluxe room with sea view', 150.00, 2),
('Suite', 'Luxurious suite with separate living area', 250.00, 4);

-- Rooms
INSERT INTO rooms (room_number, room_type_id, floor_number) VALUES
('101', 1, 1),
('102', 1, 1),
('201', 2, 2),
('202', 2, 2),
('301', 3, 3);
