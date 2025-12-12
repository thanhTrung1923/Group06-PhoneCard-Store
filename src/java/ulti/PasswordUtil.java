/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ulti;

/**
 *
 * @author ADMIN
 */
import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    public static String hash(String plain) {
        return BCrypt.hashpw(plain, BCrypt.gensalt(12));
    }

    public static boolean verify(String plain, String hash) {
        if (hash == null || hash.isEmpty()) {
            return false;
        }
        return BCrypt.checkpw(plain, hash);
    }
}
