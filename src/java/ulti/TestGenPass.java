/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ulti;

/**
 *
 * @author ADMIN
 */
public class TestGenPass {
    public static void main(String[] args) {
        String pass = "123456";
        String hash = PasswordUtil.hash(pass);
        System.out.println("Copy chuỗi này vào Database: " + hash);
        
        // Test thử luôn xem có khớp không
        boolean check = PasswordUtil.verify(pass, hash);
        System.out.println("Kết quả check lại: " + check);
    }
    }