/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.WalletTransaction;

public class WalletDAO {

    public BigDecimal getBalance(Connection con, int userId) throws Exception {
        String sql = "SELECT balance FROM wallets WHERE user_id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        }
        return BigDecimal.ZERO;
    }

    public void deduct(Connection con, int userId, BigDecimal amount) throws Exception {
        String sql = "UPDATE wallets SET balance = balance - ? WHERE user_id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setBigDecimal(1, amount);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    public BigDecimal getUserBallance(int userId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sql = """
                     SELECT balance FROM wallets WHERE user_id = ?;
                     """;

        try {
            con = DBConnect.getConnection();
            ps = con.prepareStatement(sql);

            ps.setInt(1, userId);

            rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getBigDecimal("balance");
            }

        } catch (SQLException e) {
            System.err.println(e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
                System.err.println(e.getMessage());
                e.printStackTrace();
            }
        }

        return BigDecimal.valueOf(0);
    }

    public int getTotalWalletTransactionInMonth(int userId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sql = """
                     SELECT COUNT(*) FROM wallet_transactions wt
                     JOIN wallets w ON wt.wallet_id = w.wallet_id
                     WHERE w.user_id = ?
                       AND MONTH(wt.created_at) = MONTH(CURRENT_DATE())
                       AND YEAR(wt.created_at) = YEAR(CURRENT_DATE());
                     """;

        try {
            con = DBConnect.getConnection();
            ps = con.prepareStatement(sql);

            ps.setInt(1, userId);

            rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            System.err.println(e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
                System.err.println(e.getMessage());
                e.printStackTrace();
            }
        }

        return 0;
    }

    public BigDecimal getUserTotalCash(int userId, String type) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sql = """
                     SELECT SUM(wt.amount) as total FROM wallet_transactions wt
                     JOIN wallets w ON wt.wallet_id = w.wallet_id
                     WHERE wt.type = ? AND w.user_id = ?;
                     """;

        try {
            con = DBConnect.getConnection();
            ps = con.prepareStatement(sql);

            ps.setString(1, type);
            ps.setInt(2, userId);

            rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getBigDecimal("total");
            }

        } catch (SQLException e) {
            System.err.println(e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
                System.err.println(e.getMessage());
                e.printStackTrace();
            }
        }

        return BigDecimal.valueOf(0);
    }

    public List<WalletTransaction> getListRecentWalletTransaction(int userId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        List<WalletTransaction> trans = new ArrayList<>();

        String sql = """
                     SELECT * FROM wallet_transactions wt
                     JOIN wallets w ON wt.wallet_id = w.wallet_id
                     WHERE w.user_id = ?
                     ORDER BY wt.created_at
                     LIMIT 5;
                     """;

        try {
            con = DBConnect.getConnection();
            ps = con.prepareStatement(sql);

            ps.setInt(1, userId);

            rs = ps.executeQuery();

            while (rs.next()) {
                WalletTransaction wt = new WalletTransaction(
                        rs.getInt("transaction_id"),
                        rs.getInt("wallet_id"),
                        rs.getBigDecimal("amount"),
                        rs.getString("type"),
                        rs.getString("reference"),
                        rs.getTimestamp("created_at").toLocalDateTime()
                );

                trans.add(wt);
            }

        } catch (SQLException e) {
            System.err.println(e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
                System.err.println(e.getMessage());
                e.printStackTrace();
            }
        }

        return trans;
    }

    public List<WalletTransaction> getListWalletTransaction(int userId,
            int limit, int offset, BigDecimal minAmount, BigDecimal maxAmount,
            LocalDateTime fromDate, LocalDateTime toDate, String type) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        List<WalletTransaction> trans = new ArrayList<>();

        // Xử lý minAmount và maxAmount
        if (minAmount != null && maxAmount != null) {
            if (minAmount.compareTo(maxAmount) > 0) {
                // Swap nếu min > max
                BigDecimal temp = minAmount;
                minAmount = maxAmount;
                maxAmount = temp;
            }
        }

        // Xử lý fromDate và toDate
        if (fromDate != null && toDate != null) {
            if (fromDate.isAfter(toDate)) {
                // Swap nếu from > to
                LocalDateTime temp = fromDate;
                fromDate = toDate;
                toDate = temp;
            }
        }

        StringBuilder sql = new StringBuilder("""
                 SELECT wt.* FROM wallet_transactions wt
                 JOIN wallets w ON wt.wallet_id = w.wallet_id
                 WHERE w.user_id = ?
                 """);

        if (minAmount != null && maxAmount != null && minAmount.compareTo(maxAmount) == 0) {
            // Nếu min = max thì dùng điều kiện bằng
            sql.append(" AND wt.amount = ?");
        } else {
            if (minAmount != null) {
                sql.append(" AND wt.amount >= ?");
            }
            if (maxAmount != null) {
                sql.append(" AND wt.amount <= ?");
            }
        }

        if (fromDate != null) {
            sql.append(" AND wt.created_at >= ?");
        }
        if (toDate != null) {
            sql.append(" AND wt.created_at <= ?");
        }
        if (type != null && !type.isBlank()) {
            sql.append(" AND wt.type = ?");
        }

        sql.append(" ORDER BY wt.created_at DESC");
        sql.append(" LIMIT ? OFFSET ?");

        try {
            con = DBConnect.getConnection();
            ps = con.prepareStatement(sql.toString());

            int paramIndex = 1;
            ps.setInt(paramIndex++, userId);

            if (minAmount != null && maxAmount != null && minAmount.compareTo(maxAmount) == 0) {
                // Set giá trị bằng 1 lần
                ps.setBigDecimal(paramIndex++, minAmount);
            } else {
                if (minAmount != null) {
                    ps.setBigDecimal(paramIndex++, minAmount);
                }
                if (maxAmount != null) {
                    ps.setBigDecimal(paramIndex++, maxAmount);
                }
            }

            if (fromDate != null) {
                ps.setObject(paramIndex++, fromDate);
            }
            if (toDate != null) {
                ps.setObject(paramIndex++, toDate);
            }
            if (type != null && !type.isBlank()) {
                ps.setString(paramIndex++, type);
            }

            ps.setInt(paramIndex++, limit);
            ps.setInt(paramIndex++, offset);

            rs = ps.executeQuery();

            while (rs.next()) {
                WalletTransaction wt = new WalletTransaction(
                        rs.getLong("transaction_id"),
                        rs.getInt("wallet_id"),
                        rs.getBigDecimal("amount"),
                        rs.getString("type"),
                        rs.getString("reference"),
                        rs.getTimestamp("created_at").toLocalDateTime()
                );

                trans.add(wt);
            }

        } catch (SQLException e) {
            System.err.println(e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
                System.err.println(e.getMessage());
                e.printStackTrace();
            }
        }

        return trans;
    }

    public int countListWalletTransaction(int userId,
            BigDecimal minAmount, BigDecimal maxAmount,
            LocalDateTime fromDate, LocalDateTime toDate, String type) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        // Xử lý minAmount và maxAmount
        if (minAmount != null && maxAmount != null) {
            if (minAmount.compareTo(maxAmount) > 0) {
                // Swap nếu min > max
                BigDecimal temp = minAmount;
                minAmount = maxAmount;
                maxAmount = temp;
            }
        }

        // Xử lý fromDate và toDate
        if (fromDate != null && toDate != null) {
            if (fromDate.isAfter(toDate)) {
                // Swap nếu from > to
                LocalDateTime temp = fromDate;
                fromDate = toDate;
                toDate = temp;
            }
        }

        StringBuilder sql = new StringBuilder("""
                 SELECT COUNT(*) FROM wallet_transactions wt
                 JOIN wallets w ON wt.wallet_id = w.wallet_id
                 WHERE w.user_id = ?
                 """);

        if (minAmount != null && maxAmount != null && minAmount.compareTo(maxAmount) == 0) {
            // Nếu min = max thì dùng điều kiện bằng
            sql.append(" AND wt.amount = ?");
        } else {
            if (minAmount != null) {
                sql.append(" AND wt.amount >= ?");
            }
            if (maxAmount != null) {
                sql.append(" AND wt.amount <= ?");
            }
        }

        if (fromDate != null) {
            sql.append(" AND wt.created_at >= ?");
        }
        if (toDate != null) {
            sql.append(" AND wt.created_at <= ?");
        }
        if (type != null && !type.isBlank()) {
            sql.append(" AND wt.type = ?");
        }

        try {
            con = DBConnect.getConnection();
            ps = con.prepareStatement(sql.toString());

            int paramIndex = 1;
            ps.setInt(paramIndex++, userId);

            if (minAmount != null && maxAmount != null && minAmount.compareTo(maxAmount) == 0) {
                // Set giá trị bằng 1 lần
                ps.setBigDecimal(paramIndex++, minAmount);
            } else {
                if (minAmount != null) {
                    ps.setBigDecimal(paramIndex++, minAmount);
                }
                if (maxAmount != null) {
                    ps.setBigDecimal(paramIndex++, maxAmount);
                }
            }

            if (fromDate != null) {
                ps.setObject(paramIndex++, fromDate);
            }
            if (toDate != null) {
                ps.setObject(paramIndex++, toDate);
            }
            if (type != null && !type.isBlank()) {
                ps.setString(paramIndex++, type);
            }

            rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            System.err.println(e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
                System.err.println(e.getMessage());
                e.printStackTrace();
            }
        }

        return 0;
    }
}
