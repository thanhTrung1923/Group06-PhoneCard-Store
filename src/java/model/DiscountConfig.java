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

public class DiscountConfig {
    private long configId;
    private int cardTypeId;
    private int denominationId;
    private BigDecimal buyPrice;  // Giá nhập
    private BigDecimal sellPrice; // Giá bán cơ sở

    public DiscountConfig() {
    }

    public DiscountConfig(long configId, int cardTypeId, int denominationId, BigDecimal buyPrice, BigDecimal sellPrice) {
        this.configId = configId;
        this.cardTypeId = cardTypeId;
        this.denominationId = denominationId;
        this.buyPrice = buyPrice;
        this.sellPrice = sellPrice;
    }
    
    // Getter & Setter methods go here

    public long getConfigId() {
        return configId;
    }

    public void setConfigId(long configId) {
        this.configId = configId;
    }

    public int getCardTypeId() {
        return cardTypeId;
    }

    public void setCardTypeId(int cardTypeId) {
        this.cardTypeId = cardTypeId;
    }

    public int getDenominationId() {
        return denominationId;
    }

    public void setDenominationId(int denominationId) {
        this.denominationId = denominationId;
    }

    public BigDecimal getBuyPrice() {
        return buyPrice;
    }

    public void setBuyPrice(BigDecimal buyPrice) {
        this.buyPrice = buyPrice;
    }

    public BigDecimal getSellPrice() {
        return sellPrice;
    }

    public void setSellPrice(BigDecimal sellPrice) {
        this.sellPrice = sellPrice;
    }
    
}
