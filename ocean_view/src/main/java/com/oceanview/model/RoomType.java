package com.oceanview.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class RoomType {
    private int roomTypeId;
    private String typeName;
    private String description;
    private BigDecimal basePrice;
    private int capacity;
    private String amenities;
    private Timestamp createdAt;

    // Constructors
    public RoomType() {}

    public RoomType(String typeName, String description, BigDecimal basePrice, int capacity, String amenities) {
        this.typeName = typeName;
        this.description = description;
        this.basePrice = basePrice;
        this.capacity = capacity;
        this.amenities = amenities;
    }

    // Getters and Setters
    public int getRoomTypeId() { return roomTypeId; }
    public void setRoomTypeId(int roomTypeId) { this.roomTypeId = roomTypeId; }

    public String getTypeName() { return typeName; }
    public void setTypeName(String typeName) { this.typeName = typeName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getBasePrice() { return basePrice; }
    public void setBasePrice(BigDecimal basePrice) { this.basePrice = basePrice; }

    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }

    public String getAmenities() { return amenities; }
    public void setAmenities(String amenities) { this.amenities = amenities; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
