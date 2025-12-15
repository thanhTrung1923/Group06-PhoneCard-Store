/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dtos;

/**
 *
 * @author trung
 */
public class ApiResponse {

    private int status;
    private String message;
    private Object data;
    private int page;

    public ApiResponse(int status, String message, Object data) {
        this.status = status;
        this.message = message;
        this.data = data;
    }

    public ApiResponse(int status, String message, Object data, int page) {
        this.status = status;
        this.message = message;
        this.data = data;
        this.page = page;
    }

}
