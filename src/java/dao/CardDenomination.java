/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author ADMIN
 */
public class CardDenomination {
    private int denominationId;
    private int cardTypeId; // Foreign Key
    private long value; // 10000, 20000

    public CardDenomination() {
    }

    public CardDenomination(int denominationId, int cardTypeId, long value) {
        this.denominationId = denominationId;
        this.cardTypeId = cardTypeId;
        this.value = value;
    }
    
    // Getter & Setter methods go here

    public int getDenominationId() {
        return denominationId;
    }

    public void setDenominationId(int denominationId) {
        this.denominationId = denominationId;
    }

    public int getCardTypeId() {
        return cardTypeId;
    }

    public void setCardTypeId(int cardTypeId) {
        this.cardTypeId = cardTypeId;
    }

    public long getValue() {
        return value;
    }

    public void setValue(long value) {
        this.value = value;
    }
    
}
