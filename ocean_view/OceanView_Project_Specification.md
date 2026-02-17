# Ocean View Resort - Room Reservation System
## Complete Development Specification for Antigravity AI

---

## PROJECT OVERVIEW
Develop a distributed Java web application for Ocean View Resort's room reservation system using Eclipse, Servlets, JSP, and MySQL database with 3-tier architecture, design patterns, and web services.

---

## TECHNOLOGY STACK

### Backend
- **Language**: Java (JDK 11 or higher)
- **Web Container**: Apache Tomcat 9.x
- **Framework**: Java Servlets + JSP
- **Database**: MySQL 8.0
- **Web Services**: RESTful APIs using JAX-RS or plain Servlets
- **Build Tool**: Maven
- **JDBC**: MySQL Connector/J

### Frontend
- **HTML5 + CSS3**
- **Tailwind CSS** (for styling)
- **JavaScript** (for client-side validation and AJAX calls)
- **JSP** (for dynamic content)

### Testing
- **JUnit 5** (for unit testing)
- **Mockito** (for mocking)
- **Selenium WebDriver** (optional for UI testing)

### Version Control
- **Git/GitHub**

---

## DATABASE SCHEMA

### Tables Required

#### 1. users
```sql
CREATE TABLE users (
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
```

#### 2. room_types
```sql
CREATE TABLE room_types (
    room_type_id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(50) NOT NULL,
    description TEXT,
    base_price DECIMAL(10, 2) NOT NULL,
    capacity INT NOT NULL,
    amenities TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### 3. rooms
```sql
CREATE TABLE rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_number VARCHAR(20) UNIQUE NOT NULL,
    room_type_id INT NOT NULL,
    floor_number INT,
    status ENUM('AVAILABLE', 'OCCUPIED', 'MAINTENANCE', 'RESERVED') DEFAULT 'AVAILABLE',
    FOREIGN KEY (room_type_id) REFERENCES room_types(room_type_id)
);
```

#### 4. guests
```sql
CREATE TABLE guests (
    guest_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    address TEXT,
    contact_number VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    id_number VARCHAR(50),
    nationality VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### 5. reservations
```sql
CREATE TABLE reservations (
    reservation_id INT PRIMARY KEY AUTO_INCREMENT,
    reservation_number VARCHAR(20) UNIQUE NOT NULL,
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
```

#### 6. bills
```sql
CREATE TABLE bills (
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
```

#### 7. audit_log
```sql
CREATE TABLE audit_log (
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
```

### Stored Procedures

#### 1. Calculate Bill
```sql
DELIMITER $$
CREATE PROCEDURE CalculateBill(
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

    SET v_room_charges = v_nights * v_base_price;
    SET v_tax = v_room_charges * 0.12; -- 12% tax
    SET v_service = v_room_charges * 0.10; -- 10% service charge
    SET p_total_amount = v_room_charges + v_tax + v_service;

    INSERT INTO bills (reservation_id, total_nights, room_charges, 
                       tax_amount, service_charges, total_amount)
    VALUES (p_reservation_id, v_nights, v_room_charges, v_tax, v_service, p_total_amount);
END$$
DELIMITER ;
```

#### 2. Check Room Availability
```sql
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
```

#### 3. Generate Reservation Number
```sql
DELIMITER $$
CREATE TRIGGER generate_reservation_number
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
```

---

## PROJECT STRUCTURE

```
OceanViewResort/
├── src/main/java/
│   ├── com/oceanview/
│   │   ├── config/
│   │   │   ├── DatabaseConfig.java           # Singleton DB connection
│   │   │   └── AppConfig.java                # Application configurations
│   │   ├── model/
│   │   │   ├── User.java
│   │   │   ├── Guest.java
│   │   │   ├── Room.java
│   │   │   ├── RoomType.java
│   │   │   ├── Reservation.java
│   │   │   └── Bill.java
│   │   ├── dao/
│   │   │   ├── BaseDAO.java                  # Abstract DAO
│   │   │   ├── UserDAO.java
│   │   │   ├── GuestDAO.java
│   │   │   ├── RoomDAO.java
│   │   │   ├── ReservationDAO.java
│   │   │   ├── BillDAO.java
│   │   │   └── impl/                         # DAO implementations
│   │   │       ├── UserDAOImpl.java
│   │   │       ├── GuestDAOImpl.java
│   │   │       ├── RoomDAOImpl.java
│   │   │       ├── ReservationDAOImpl.java
│   │   │       └── BillDAOImpl.java
│   │   ├── service/
│   │   │   ├── AuthenticationService.java
│   │   │   ├── ReservationService.java
│   │   │   ├── BillingService.java
│   │   │   ├── RoomService.java
│   │   │   └── ReportService.java
│   │   ├── controller/                       # Servlets
│   │   │   ├── LoginServlet.java
│   │   │   ├── LogoutServlet.java
│   │   │   ├── ReservationServlet.java
│   │   │   ├── GuestServlet.java
│   │   │   ├── RoomServlet.java
│   │   │   ├── BillServlet.java
│   │   │   └── ReportServlet.java
│   │   ├── api/                              # REST API endpoints
│   │   │   ├── ReservationAPIServlet.java
│   │   │   ├── RoomAPIServlet.java
│   │   │   └── BillAPIServlet.java
│   │   ├── filter/
│   │   │   ├── AuthenticationFilter.java     # Session validation
│   │   │   ├── CORSFilter.java               # For REST APIs
│   │   │   └── LoggingFilter.java
│   │   ├── util/
│   │   │   ├── PasswordUtil.java             # Password hashing
│   │   │   ├── ValidationUtil.java           # Input validation
│   │   │   ├── DateUtil.java
│   │   │   └── PDFGenerator.java             # For bill generation
│   │   └── factory/
│   │       ├── DAOFactory.java               # Factory pattern
│   │       └── RoomTypeFactory.java
│   └── resources/
│       └── db.properties                     # Database configuration
├── src/main/webapp/
│   ├── WEB-INF/
│   │   ├── web.xml                           # Deployment descriptor
│   │   └── views/                            # JSP files
│   │       ├── login.jsp
│   │       ├── dashboard.jsp
│   │       ├── reservation/
│   │       │   ├── new-reservation.jsp
│   │       │   ├── view-reservation.jsp
│   │       │   ├── search-reservation.jsp
│   │       │   └── reservation-list.jsp
│   │       ├── guest/
│   │       │   ├── add-guest.jsp
│   │       │   └── guest-list.jsp
│   │       ├── room/
│   │       │   ├── room-availability.jsp
│   │       │   └── room-list.jsp
│   │       ├── billing/
│   │       │   ├── generate-bill.jsp
│   │       │   └── bill-history.jsp
│   │       ├── reports/
│   │       │   ├── occupancy-report.jsp
│   │       │   ├── revenue-report.jsp
│   │       │   └── guest-history.jsp
│   │       ├── help.jsp
│   │       └── error.jsp
│   ├── css/
│   │   └── styles.css                        # Tailwind CSS + custom
│   ├── js/
│   │   ├── main.js
│   │   ├── validation.js
│   │   └── api-client.js                     # For REST API calls
│   └── index.jsp                             # Landing page
├── src/test/java/
│   ├── com/oceanview/
│   │   ├── dao/
│   │   │   ├── UserDAOTest.java
│   │   │   ├── ReservationDAOTest.java
│   │   │   └── BillDAOTest.java
│   │   ├── service/
│   │   │   ├── AuthenticationServiceTest.java
│   │   │   ├── ReservationServiceTest.java
│   │   │   └── BillingServiceTest.java
│   │   └── integration/
│   │       └── ReservationIntegrationTest.java
├── pom.xml                                   # Maven dependencies
└── README.md
```

---

## DESIGN PATTERNS TO IMPLEMENT

### 1. Singleton Pattern
**Location**: `DatabaseConfig.java`
```java
public class DatabaseConfig {
    private static DatabaseConfig instance;
    private DataSource dataSource;

    private DatabaseConfig() {
        // Initialize database connection pool
    }

    public static synchronized DatabaseConfig getInstance() {
        if (instance == null) {
            instance = new DatabaseConfig();
        }
        return instance;
    }

    public Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }
}
```

### 2. Factory Pattern
**Location**: `DAOFactory.java` and `RoomTypeFactory.java`
```java
public class DAOFactory {
    public static UserDAO getUserDAO() {
        return new UserDAOImpl();
    }

    public static ReservationDAO getReservationDAO() {
        return new ReservationDAOImpl();
    }
    // ... other DAOs
}

public class RoomTypeFactory {
    public static RoomType createRoomType(String type) {
        switch(type) {
            case "DELUXE": return new DeluxeRoom();
            case "SUITE": return new SuiteRoom();
            case "STANDARD": return new StandardRoom();
            default: throw new IllegalArgumentException("Unknown room type");
        }
    }
}
```

### 3. DAO Pattern
**Location**: All DAO classes
- Abstract interface defining CRUD operations
- Concrete implementations for each entity

### 4. MVC Pattern
**Architecture**:
- **Model**: Entity classes in `model/` package
- **View**: JSP files in `WEB-INF/views/`
- **Controller**: Servlet classes in `controller/` package

### 5. Filter Pattern
**Location**: `filter/` package
- Authentication filter for session management
- Logging filter for audit trails

### 6. Strategy Pattern (Optional)
**Location**: Billing calculations
- Different pricing strategies for different seasons/promotions

---

## CORE FUNCTIONALITIES IMPLEMENTATION

### 1. User Authentication

#### LoginServlet.java
```java
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private AuthenticationService authService;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = authService.authenticate(username, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("role", user.getRole());
            session.setMaxInactiveInterval(30 * 60); // 30 minutes

            response.sendRedirect("dashboard");
        } else {
            request.setAttribute("error", "Invalid credentials");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }
}
```

#### AuthenticationFilter.java
```java
@WebFilter("/*")
public class AuthenticationFilter implements Filter {
    private static final List<String> PUBLIC_URLS = Arrays.asList("/login", "/css/", "/js/");

    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);

        String path = request.getRequestURI();

        if (isPublicResource(path) || isLoggedIn(session)) {
            chain.doFilter(req, res);
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
}
```

### 2. Add New Reservation

#### ReservationServlet.java
```java
@WebServlet("/reservation")
public class ReservationServlet extends HttpServlet {
    private ReservationService reservationService;
    private GuestService guestService;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
        try {
            // Validation
            String guestName = ValidationUtil.sanitize(request.getParameter("guestName"));
            String contact = ValidationUtil.validatePhone(request.getParameter("contact"));
            String checkIn = request.getParameter("checkInDate");
            String checkOut = request.getParameter("checkOutDate");
            int roomId = Integer.parseInt(request.getParameter("roomId"));

            // Check room availability
            if (!reservationService.isRoomAvailable(roomId, checkIn, checkOut)) {
                request.setAttribute("error", "Room not available for selected dates");
                request.getRequestDispatcher("/WEB-INF/views/reservation/new-reservation.jsp")
                       .forward(request, response);
                return;
            }

            // Create guest
            Guest guest = new Guest();
            guest.setFullName(guestName);
            guest.setContactNumber(contact);
            guest.setAddress(request.getParameter("address"));
            guest.setEmail(request.getParameter("email"));

            int guestId = guestService.addGuest(guest);

            // Create reservation
            Reservation reservation = new Reservation();
            reservation.setGuestId(guestId);
            reservation.setRoomId(roomId);
            reservation.setCheckInDate(LocalDate.parse(checkIn));
            reservation.setCheckOutDate(LocalDate.parse(checkOut));
            reservation.setNumberOfGuests(Integer.parseInt(request.getParameter("numGuests")));
            reservation.setSpecialRequests(request.getParameter("specialRequests"));
            reservation.setCreatedBy(((User)request.getSession().getAttribute("user")).getUserId());

            String reservationNumber = reservationService.createReservation(reservation);

            response.sendRedirect("reservation?action=view&id=" + reservationNumber);

        } catch (Exception e) {
            request.setAttribute("error", "Error creating reservation: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
}
```

### 3. Display Reservation Details

#### View Reservation JSP
```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Reservation Details</title>
    <link href="${pageContext.request.contextPath}/css/styles.css" rel="stylesheet">
</head>
<body>
    <div class="container mx-auto p-6">
        <h1 class="text-3xl font-bold mb-6">Reservation Details</h1>

        <div class="bg-white shadow-md rounded-lg p-6">
            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label class="font-semibold">Reservation Number:</label>
                    <p>${reservation.reservationNumber}</p>
                </div>
                <div>
                    <label class="font-semibold">Guest Name:</label>
                    <p>${reservation.guest.fullName}</p>
                </div>
                <div>
                    <label class="font-semibold">Contact:</label>
                    <p>${reservation.guest.contactNumber}</p>
                </div>
                <div>
                    <label class="font-semibold">Room Number:</label>
                    <p>${reservation.room.roomNumber}</p>
                </div>
                <div>
                    <label class="font-semibold">Check-in Date:</label>
                    <p>${reservation.checkInDate}</p>
                </div>
                <div>
                    <label class="font-semibold">Check-out Date:</label>
                    <p>${reservation.checkOutDate}</p>
                </div>
            </div>

            <div class="mt-6 flex gap-4">
                <button onclick="location.href='bill?reservationId=${reservation.reservationId}'" 
                        class="bg-blue-500 text-white px-4 py-2 rounded">
                    Generate Bill
                </button>
                <button onclick="window.print()" 
                        class="bg-green-500 text-white px-4 py-2 rounded">
                    Print Details
                </button>
            </div>
        </div>
    </div>
</body>
</html>
```

### 4. Calculate and Print Bill

#### BillingService.java
```java
public class BillingService {
    private BillDAO billDAO;

    public Bill calculateAndGenerateBill(int reservationId) throws SQLException {
        Connection conn = DatabaseConfig.getInstance().getConnection();
        CallableStatement stmt = conn.prepareCall("{CALL CalculateBill(?, ?)}");

        stmt.setInt(1, reservationId);
        stmt.registerOutParameter(2, Types.DECIMAL);
        stmt.execute();

        BigDecimal totalAmount = stmt.getBigDecimal(2);

        // Retrieve generated bill
        Bill bill = billDAO.getByReservationId(reservationId);

        return bill;
    }

    public byte[] generatePDFBill(int billId) {
        Bill bill = billDAO.getById(billId);
        return PDFGenerator.generateBillPDF(bill);
    }
}
```

### 5. Help Section

#### help.jsp
```jsp
<html>
<head>
    <title>Help - User Guide</title>
</head>
<body>
    <div class="container mx-auto p-6">
        <h1 class="text-3xl font-bold mb-6">Ocean View Resort - User Guide</h1>

        <div class="space-y-6">
            <section>
                <h2 class="text-2xl font-semibold">1. Login</h2>
                <p>Use your assigned username and password to access the system.</p>
            </section>

            <section>
                <h2 class="text-2xl font-semibold">2. Creating a Reservation</h2>
                <ol class="list-decimal ml-6">
                    <li>Navigate to "New Reservation" from the dashboard</li>
                    <li>Check room availability for desired dates</li>
                    <li>Enter guest information</li>
                    <li>Select room type and dates</li>
                    <li>Submit reservation</li>
                </ol>
            </section>

            <section>
                <h2 class="text-2xl font-semibold">3. Viewing Reservations</h2>
                <p>Search by reservation number or guest name in the search section.</p>
            </section>

            <section>
                <h2 class="text-2xl font-semibold">4. Generating Bills</h2>
                <p>From reservation details, click "Generate Bill" to calculate and create invoice.</p>
            </section>
        </div>
    </div>
</body>
</html>
```

---

## REST API ENDPOINTS (Web Services)

### Base URL: `/api/v1/`

#### 1. Reservations API
```
GET    /api/v1/reservations              - Get all reservations
GET    /api/v1/reservations/{id}         - Get reservation by ID
POST   /api/v1/reservations              - Create new reservation
PUT    /api/v1/reservations/{id}         - Update reservation
DELETE /api/v1/reservations/{id}         - Cancel reservation
GET    /api/v1/reservations/search?q=    - Search reservations
```

#### 2. Rooms API
```
GET    /api/v1/rooms                     - Get all rooms
GET    /api/v1/rooms/available           - Get available rooms
POST   /api/v1/rooms/check-availability  - Check specific room availability
```

#### 3. Bills API
```
GET    /api/v1/bills/{reservationId}     - Get bill for reservation
POST   /api/v1/bills/generate            - Generate new bill
```

### ReservationAPIServlet.java (Example)
```java
@WebServlet("/api/v1/reservations/*")
public class ReservationAPIServlet extends HttpServlet {
    private ReservationService reservationService;
    private Gson gson = new Gson();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Get all reservations
                List<Reservation> reservations = reservationService.getAllReservations();
                response.getWriter().write(gson.toJson(reservations));
            } else {
                // Get specific reservation
                String id = pathInfo.substring(1);
                Reservation reservation = reservationService.getReservationByNumber(id);

                if (reservation != null) {
                    response.getWriter().write(gson.toJson(reservation));
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    response.getWriter().write("{"error":"Reservation not found"}");
                }
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{"error":"" + e.getMessage() + ""}");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
        // Implementation for creating reservation via API
    }
}
```

---

## ADDITIONAL FEATURES (For Higher Marks)

### 1. Room Availability Checker
- Real-time availability calendar
- Filter by room type, price range, capacity
- Visual date picker with unavailable dates highlighted

### 2. Email Notifications
```java
public class EmailService {
    public void sendBookingConfirmation(Reservation reservation) {
        // Use JavaMail API
        String to = reservation.getGuest().getEmail();
        String subject = "Booking Confirmation - " + reservation.getReservationNumber();
        String body = generateEmailBody(reservation);

        // Send email logic
    }
}
```

### 3. Reports Generation

#### Occupancy Report
- Daily/weekly/monthly occupancy rates
- Room-wise utilization
- Peak season analysis

#### Revenue Report
- Total revenue by period
- Room type revenue breakdown
- Average daily rate (ADR)

#### Guest History
- Frequent guest tracking
- Guest preferences
- Past stay records

### 4. Advanced Search
- Multi-criteria search
- Date range filters
- Status-based filtering
- Guest name/contact search

---

## INPUT VALIDATION

### ValidationUtil.java
```java
public class ValidationUtil {
    public static String sanitize(String input) {
        return input.replaceAll("[<>"']", "");
    }

    public static String validatePhone(String phone) throws ValidationException {
        if (!phone.matches("^\+?[0-9]{10,15}$")) {
            throw new ValidationException("Invalid phone number");
        }
        return phone;
    }

    public static String validateEmail(String email) throws ValidationException {
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            throw new ValidationException("Invalid email");
        }
        return email;
    }

    public static boolean isValidDateRange(LocalDate checkIn, LocalDate checkOut) {
        return checkOut.isAfter(checkIn) && checkIn.isAfter(LocalDate.now().minusDays(1));
    }
}
```

### Client-side Validation (validation.js)
```javascript
function validateReservationForm() {
    const guestName = document.getElementById('guestName').value;
    const contact = document.getElementById('contact').value;
    const checkIn = document.getElementById('checkIn').value;
    const checkOut = document.getElementById('checkOut').value;

    if (guestName.trim().length < 3) {
        alert('Guest name must be at least 3 characters');
        return false;
    }

    if (!contact.match(/^\+?[0-9]{10,15}$/)) {
        alert('Invalid phone number');
        return false;
    }

    if (new Date(checkOut) <= new Date(checkIn)) {
        alert('Check-out date must be after check-in date');
        return false;
    }

    return true;
}
```

---

## MAVEN DEPENDENCIES (pom.xml)

```xml
<project>
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.oceanview</groupId>
    <artifactId>reservation-system</artifactId>
    <version>1.0.0</version>
    <packaging>war</packaging>

    <properties>
        <maven.compiler.source>11</maven.compiler.source>
        <maven.compiler.target>11</maven.compiler.target>
    </properties>

    <dependencies>
        <!-- Servlet API -->
        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>javax.servlet-api</artifactId>
            <version>4.0.1</version>
            <scope>provided</scope>
        </dependency>

        <!-- JSP API -->
        <dependency>
            <groupId>javax.servlet.jsp</groupId>
            <artifactId>javax.servlet.jsp-api</artifactId>
            <version>2.3.3</version>
            <scope>provided</scope>
        </dependency>

        <!-- JSTL -->
        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>jstl</artifactId>
            <version>1.2</version>
        </dependency>

        <!-- MySQL Connector -->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>8.0.33</version>
        </dependency>

        <!-- Apache Commons DBCP (Connection Pool) -->
        <dependency>
            <groupId>org.apache.commons</groupId>
            <artifactId>commons-dbcp2</artifactId>
            <version>2.9.0</version>
        </dependency>

        <!-- Gson for JSON -->
        <dependency>
            <groupId>com.google.code.gson</groupId>
            <artifactId>gson</artifactId>
            <version>2.10.1</version>
        </dependency>

        <!-- Apache PDFBox for PDF generation -->
        <dependency>
            <groupId>org.apache.pdfbox</groupId>
            <artifactId>pdfbox</artifactId>
            <version>2.0.29</version>
        </dependency>

        <!-- BCrypt for password hashing -->
        <dependency>
            <groupId>org.mindrot</groupId>
            <artifactId>jbcrypt</artifactId>
            <version>0.4</version>
        </dependency>

        <!-- JUnit 5 for testing -->
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter</artifactId>
            <version>5.9.3</version>
            <scope>test</scope>
        </dependency>

        <!-- Mockito for mocking -->
        <dependency>
            <groupId>org.mockito</groupId>
            <artifactId>mockito-core</artifactId>
            <version>5.3.1</version>
            <scope>test</scope>
        </dependency>

        <!-- SLF4J Logging -->
        <dependency>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-api</artifactId>
            <version>2.0.7</version>
        </dependency>

        <dependency>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-simple</artifactId>
            <version>2.0.7</version>
        </dependency>
    </dependencies>

    <build>
        <finalName>oceanview</finalName>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-war-plugin</artifactId>
                <version>3.3.2</version>
            </plugin>
        </plugins>
    </build>
</project>
```

---

## DATABASE CONFIGURATION (db.properties)

```properties
db.url=jdbc:mysql://localhost:3306/oceanview_resort?useSSL=false&serverTimezone=UTC
db.username=root
db.password=your_password
db.driver=com.mysql.cj.jdbc.Driver
db.pool.initialSize=5
db.pool.maxTotal=20
db.pool.maxIdle=10
db.pool.minIdle=5
```

---

## WEB.XML CONFIGURATION

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
         http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0">

    <display-name>Ocean View Resort</display-name>

    <welcome-file-list>
        <welcome-file>index.jsp</welcome-file>
    </welcome-file-list>

    <!-- Session timeout (30 minutes) -->
    <session-config>
        <session-timeout>30</session-timeout>
    </session-config>

    <!-- Error pages -->
    <error-page>
        <error-code>404</error-code>
        <location>/WEB-INF/views/error.jsp</location>
    </error-page>

    <error-page>
        <error-code>500</error-code>
        <location>/WEB-INF/views/error.jsp</location>
    </error-page>
</web-app>
```

---

## TESTING STRATEGY

### Unit Tests
- Test all DAO methods
- Test service layer logic
- Test utility functions (validation, date calculations)

### Integration Tests
- Test complete reservation flow
- Test billing calculations with database
- Test authentication flow

### Test Data
```java
public class TestDataGenerator {
    public static User createTestUser() {
        User user = new User();
        user.setUsername("testuser");
        user.setPassword("hashedPassword");
        user.setFullName("Test User");
        user.setRole("STAFF");
        return user;
    }

    public static Reservation createTestReservation() {
        Reservation res = new Reservation();
        res.setCheckInDate(LocalDate.now().plusDays(1));
        res.setCheckOutDate(LocalDate.now().plusDays(3));
        res.setRoomId(1);
        res.setGuestId(1);
        return res;
    }
}
```

### Example Test Class
```java
public class ReservationServiceTest {
    private ReservationService service;
    private ReservationDAO mockDAO;

    @BeforeEach
    void setUp() {
        mockDAO = Mockito.mock(ReservationDAO.class);
        service = new ReservationService(mockDAO);
    }

    @Test
    void testCreateReservation() {
        Reservation reservation = TestDataGenerator.createTestReservation();

        when(mockDAO.insert(any(Reservation.class))).thenReturn(1);

        String resNumber = service.createReservation(reservation);

        assertNotNull(resNumber);
        assertTrue(resNumber.startsWith("RES"));
        verify(mockDAO, times(1)).insert(any(Reservation.class));
    }

    @Test
    void testIsRoomAvailable() {
        when(mockDAO.checkAvailability(1, LocalDate.now(), LocalDate.now().plusDays(2)))
            .thenReturn(true);

        boolean available = service.isRoomAvailable(1, "2026-02-20", "2026-02-22");

        assertTrue(available);
    }
}
```

---

## SECURITY FEATURES

### Password Hashing
```java
public class PasswordUtil {
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
    }

    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }
}
```

### SQL Injection Prevention
- Use PreparedStatement for all database queries
- Never concatenate user input into SQL queries

### XSS Prevention
- Sanitize all user inputs
- Use JSTL's `<c:out>` tag in JSP to escape HTML

### Session Security
- Set HttpOnly flag on session cookies
- Implement session timeout
- Regenerate session ID after login

---

## SAMPLE DATA FOR TESTING

```sql
-- Insert room types
INSERT INTO room_types (type_name, description, base_price, capacity) VALUES
('Standard', 'Comfortable standard room with basic amenities', 5000.00, 2),
('Deluxe', 'Spacious deluxe room with sea view', 8000.00, 2),
('Suite', 'Luxurious suite with separate living area', 15000.00, 4),
('Family', 'Large family room with multiple beds', 12000.00, 5);

-- Insert rooms
INSERT INTO rooms (room_number, room_type_id, floor_number, status) VALUES
('101', 1, 1, 'AVAILABLE'),
('102', 1, 1, 'AVAILABLE'),
('201', 2, 2, 'AVAILABLE'),
('202', 2, 2, 'AVAILABLE'),
('301', 3, 3, 'AVAILABLE');

-- Insert test user
INSERT INTO users (username, password, full_name, role, email) VALUES
('admin', '$2a$12$hashed_password', 'Administrator', 'ADMIN', 'admin@oceanview.com'),
('staff1', '$2a$12$hashed_password', 'John Doe', 'STAFF', 'john@oceanview.com');
```

---

## DEPLOYMENT STEPS

1. **Setup MySQL Database**
   - Create database: `CREATE DATABASE oceanview_resort;`
   - Run all table creation scripts
   - Insert sample data
   - Create stored procedures and functions

2. **Configure Eclipse Project**
   - Import as Maven project
   - Configure Tomcat server in Eclipse
   - Update db.properties with correct credentials

3. **Build Project**
   - Run `mvn clean install`
   - Verify WAR file generation

4. **Deploy to Tomcat**
   - Copy WAR to Tomcat webapps folder
   - Start Tomcat server
   - Access at `http://localhost:8080/oceanview`

5. **Initial Login**
   - Username: admin
   - Password: (as configured in database)

---

## DELIVERABLES CHECKLIST

### Code
- [ ] All Java classes implemented with proper package structure
- [ ] All JSP pages with Tailwind CSS styling
- [ ] All design patterns implemented and documented
- [ ] REST API endpoints functional
- [ ] Input validation on client and server side
- [ ] Error handling throughout application

### Database
- [ ] All tables created with proper relationships
- [ ] Stored procedures implemented
- [ ] Functions and triggers created
- [ ] Sample data inserted

### Testing
- [ ] Unit tests for DAO layer
- [ ] Unit tests for service layer
- [ ] Integration tests for key flows
- [ ] Test coverage report

### Documentation
- [ ] Code comments and JavaDoc
- [ ] README with setup instructions
- [ ] API documentation
- [ ] User manual (Help section)

### Version Control
- [ ] GitHub repository created (public)
- [ ] Multiple commits showing daily progress
- [ ] Meaningful commit messages
- [ ] Branches for feature development
- [ ] CI/CD workflow configured

---

## SUCCESS CRITERIA

1. **Functionality**: All 6 core features working without errors
2. **Architecture**: Clear 3-tier separation with web services
3. **Design Patterns**: At least 4 patterns properly implemented
4. **Database**: Normalized schema with stored procedures
5. **UI/UX**: Professional interface with Tailwind CSS
6. **Validation**: Comprehensive input validation
7. **Testing**: Good test coverage with automation
8. **Documentation**: Clear and complete
9. **Version Control**: Regular commits with proper workflows

---

## NOTES FOR DEVELOPMENT

- Focus on clean, maintainable code
- Follow Java naming conventions
- Comment complex logic
- Handle exceptions properly
- Log important operations
- Use prepared statements always
- Validate all inputs
- Test thoroughly before deployment
- Keep business logic separate from presentation
- Make code reusable and modular

---

END OF SPECIFICATION
