/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;

public class CardDAO {

    public long assignCard(Connection con, int productId) throws Exception {

        String select = """
            SELECT card_id FROM cards
            WHERE product_id = ? AND status = 'IN_STOCK'
            LIMIT 1 FOR UPDATE
        """;

        try (PreparedStatement ps = con.prepareStatement(select)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                throw new Exception("Sản phẩm đã hết thẻ trong kho");
            }

            long cardId = rs.getLong("card_id");

            String update = "UPDATE cards SET status='SOLD', sold_at=NOW() WHERE card_id=?";
            try (PreparedStatement ups = con.prepareStatement(update)) {
                ups.setLong(1, cardId);
                ups.executeUpdate();
            }

            return cardId;
        }
    }
}

