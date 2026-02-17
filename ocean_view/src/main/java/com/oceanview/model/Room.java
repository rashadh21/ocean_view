package com.oceanview.model;

public class Room {
    private int roomId;
    private String roomNumber;
    private int roomTypeId;
    private int floorNumber;
    private String status;
    private RoomType roomType; // For join queries

    // Constructors
    public Room() {}

    public Room(String roomNumber, int roomTypeId, int floorNumber, String status) {
        this.roomNumber = roomNumber;
        this.roomTypeId = roomTypeId;
        this.floorNumber = floorNumber;
        this.status = status;
    }

    // Getters and Setters
    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }

    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }

    public int getRoomTypeId() { return roomTypeId; }
    public void setRoomTypeId(int roomTypeId) { this.roomTypeId = roomTypeId; }

    public int getFloorNumber() { return floorNumber; }
    public void setFloorNumber(int floorNumber) { this.floorNumber = floorNumber; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public RoomType getRoomType() { return roomType; }
    public void setRoomType(RoomType roomType) { this.roomType = roomType; }
}
