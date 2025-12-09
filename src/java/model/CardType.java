/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ADMIN
 */
public class CardType {
    private int cardTypeId;
    private String typeCode; // VIETTEL, VINA
    private String typeName;
    private String description;

    public CardType() {
    }

    public CardType(int cardTypeId, String typeCode, String typeName, String description) {
        this.cardTypeId = cardTypeId;
        this.typeCode = typeCode;
        this.typeName = typeName;
        this.description = description;
    }
    
    // Getter & Setter methods go here

    public int getCardTypeId() {
        return cardTypeId;
    }

    public void setCardTypeId(int cardTypeId) {
        this.cardTypeId = cardTypeId;
    }

    public String getTypeCode() {
        return typeCode;
    }

    public void setTypeCode(String typeCode) {
        this.typeCode = typeCode;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
    
}
