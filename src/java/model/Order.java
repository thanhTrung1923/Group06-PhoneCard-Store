/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ADMIN
 */
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public class Order {

    // Định nghĩa Enum cho trạng thái để đảm bảo Type Safe
    private Long orderId;
    private Integer userId;
    private BigDecimal totalAmount;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime paidAt;
    private LocalDateTime cancelledAt;

    private List<OrderItem> orderItems;

    // 1. Constructor mặc định (No-args constructor)
    public Order() {
        // Thiết lập giá trị mặc định giống như trong SQL

    }

    // 2. Constructor đầy đủ tham số
    public Order(Long orderId, Integer userId, BigDecimal totalAmount, String status,
            LocalDateTime createdAt, LocalDateTime paidAt, LocalDateTime cancelledAt) {
        this.orderId = orderId;
        this.userId = userId;
        this.totalAmount = totalAmount;
        this.status = status;
        this.createdAt = createdAt;
        this.paidAt = paidAt;
        this.cancelledAt = cancelledAt;
    }

    public List<OrderItem> getOrderItems() {
        return orderItems;
    }

    public void setOrderItems(List<OrderItem> orderItems) {
        this.orderItems = orderItems;
    }

    // 3. Getters và Setters
    public Long getOrderId() {
        return orderId;
    }

    public void setOrderId(Long orderId) {
        this.orderId = orderId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(LocalDateTime paidAt) {
        this.paidAt = paidAt;
    }

    public LocalDateTime getCancelledAt() {
        return cancelledAt;
    }

    public void setCancelledAt(LocalDateTime cancelledAt) {
        this.cancelledAt = cancelledAt;
    }

    // 4. Override phương thức toString để in object dễ dàng hơn
    @Override
    public String toString() {
        return "Order{"
                + "orderId=" + orderId
                + ", userId=" + userId
                + ", totalAmount=" + totalAmount
                + ", status=" + status
                + ", createdAt=" + createdAt
                + ", paidAt=" + paidAt
                + ", cancelledAt=" + cancelledAt
                + '}';
    }
}
