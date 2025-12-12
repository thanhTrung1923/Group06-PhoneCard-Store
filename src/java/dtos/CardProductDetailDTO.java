/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dtos;

import java.math.BigDecimal;

/**
 *
 * @author trung
 */
public class CardProductDetailDTO {

    private int product_id;
    private String type_code;
    private String type_name;
    private long value;
    private String description;
    private BigDecimal original_price;
    private BigDecimal sell_price;
    private float discount_percent;
    private BigDecimal final_price;
    private int stock_quantity;
    private boolean is_active;
    private String stock_status;
    private String img_url;
    private String thumbnail_url;
    private float avg_rating;
    private int review_count;
    private int total_sold;
    private int max_quantity_per_order;

    public CardProductDetailDTO() {
    }

    public int getProduct_id() {
        return product_id;
    }

    public void setProduct_id(int product_id) {
        this.product_id = product_id;
    }

    public String getType_code() {
        return type_code;
    }

    public void setType_code(String type_code) {
        this.type_code = type_code;
    }

    public String getType_name() {
        return type_name;
    }

    public void setType_name(String type_name) {
        this.type_name = type_name;
    }

    public long getValue() {
        return value;
    }

    public void setValue(long value) {
        this.value = value;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getOriginal_price() {
        return original_price;
    }

    public void setOriginal_price(BigDecimal original_price) {
        this.original_price = original_price;
    }

    public BigDecimal getSell_price() {
        return sell_price;
    }

    public void setSell_price(BigDecimal sell_price) {
        this.sell_price = sell_price;
    }

    public float getDiscount_percent() {
        return discount_percent;
    }

    public void setDiscount_percent(float discount_percent) {
        this.discount_percent = discount_percent;
    }

    public BigDecimal getFinal_price() {
        return final_price;
    }

    public void setFinal_price(BigDecimal final_price) {
        this.final_price = final_price;
    }

    public int getStock_quantity() {
        return stock_quantity;
    }

    public void setStock_quantity(int stock_quantity) {
        this.stock_quantity = stock_quantity;
    }

    public boolean isIs_active() {
        return is_active;
    }

    public void setIs_active(boolean is_active) {
        this.is_active = is_active;
    }

    public String getStock_status() {
        return stock_status;
    }

    public void setStock_status(String stock_status) {
        this.stock_status = stock_status;
    }

    public String getImg_url() {
        return img_url;
    }

    public void setImg_url(String img_url) {
        this.img_url = img_url;
    }

    public String getThumbnail_url() {
        return thumbnail_url;
    }

    public void setThumbnail_url(String thumbnail_url) {
        this.thumbnail_url = thumbnail_url;
    }

    public float getAvg_rating() {
        return avg_rating;
    }

    public void setAvg_rating(float avg_rating) {
        this.avg_rating = avg_rating;
    }

    public int getReview_count() {
        return review_count;
    }

    public void setReview_count(int review_count) {
        this.review_count = review_count;
    }

    public int getTotal_sold() {
        return total_sold;
    }

    public void setTotal_sold(int total_sold) {
        this.total_sold = total_sold;
    }

    public int getMax_quantity_per_order() {
        return max_quantity_per_order;
    }

    public void setMax_quantity_per_order(int max_quantity_per_order) {
        this.max_quantity_per_order = max_quantity_per_order;
    }

    @Override
    public String toString() {
        return "CardProductDetailDTO{" + "product_id=" + product_id + ", type_code=" + type_code + ", type_name=" + type_name + ", value=" + value + ", desription=" + description + ", original_price=" + original_price + ", sell_price=" + sell_price + ", discount_percent=" + discount_percent + ", final_price=" + final_price + ", stock_quantity=" + stock_quantity + ", is_active=" + is_active + ", stock_status=" + stock_status + ", img_url=" + img_url + ", thumbnail_url=" + thumbnail_url + ", avg_rating=" + avg_rating + ", review_count=" + review_count + ", total_sold=" + total_sold + ", max_quantity_per_order=" + max_quantity_per_order + '}';
    }

}
