CREATE DATABASE  IF NOT EXISTS `card_store` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `card_store`;
-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: card_store
-- ------------------------------------------------------
-- Server version	8.0.44

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `audit_logs`
--

DROP TABLE IF EXISTS `audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_logs` (
  `log_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `entity_type` varchar(50) DEFAULT NULL,
  `entity_id` bigint DEFAULT NULL,
  `old_value` text,
  `new_value` text,
  `ip_address` varchar(50) DEFAULT NULL,
  `user_agent` varchar(500) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`log_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `audit_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
INSERT INTO `audit_logs` VALUES (1,1,'CREATE_USER','USER',4,NULL,'{\"email\":\"customer01@gmail.com\",\"full_name\":\"Phạm Văn Khách\"}','192.168.1.100','Mozilla/5.0','2024-12-01 08:00:00.000000'),(2,1,'APPROVE_DEPOSIT','DEPOSIT_REQUEST',1,'{\"status\":\"PENDING\"}','{\"status\":\"APPROVED\"}','192.168.1.100','Mozilla/5.0','2024-12-01 08:00:00.000000'),(3,2,'UPDATE_PRODUCT','PRODUCT',1,'{\"quantity\":500}','{\"quantity\":498}','192.168.1.101','Mozilla/5.0','2024-12-05 10:01:00.000000'),(4,3,'RESOLVE_TICKET','SUPPORT_TICKET',1,'{\"status\":\"NEW\"}','{\"status\":\"RESOLVED\"}','192.168.1.102','Mozilla/5.0','2024-12-05 11:00:00.000000'),(5,1,'CREATE_PROMOTION','PROMOTION',1,NULL,'{\"promotion_name\":\"Khuyến mãi Noel 2024\"}','192.168.1.100','Mozilla/5.0','2024-11-25 14:00:00.000000');
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `card_products`
--

DROP TABLE IF EXISTS `card_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `card_products` (
  `product_id` int NOT NULL AUTO_INCREMENT,
  `type_code` varchar(50) NOT NULL,
  `type_name` varchar(100) NOT NULL,
  `value` bigint NOT NULL,
  `quantity` int DEFAULT '0',
  `min_stock_alert` int DEFAULT '10',
  `buy_price` decimal(18,2) NOT NULL DEFAULT '0.00',
  `sell_price` decimal(18,2) NOT NULL DEFAULT '0.00',
  `img_url` varchar(500) DEFAULT NULL,
  `thumbnail_url` varchar(500) DEFAULT NULL,
  `description` text,
  `is_active` tinyint(1) DEFAULT '1',
  `allow_discount` tinyint(1) DEFAULT '1',
  `created_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`product_id`),
  UNIQUE KEY `unique_product` (`type_code`,`value`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `card_products`
--

LOCK TABLES `card_products` WRITE;
/*!40000 ALTER TABLE `card_products` DISABLE KEYS */;
INSERT INTO `card_products` VALUES (1,'VIETTEL','Thẻ Viettel mệnh giá 10.000đ',10000,0,50,9500.00,10000.00,'https://down-vn.img.susercontent.com/file/e8954eb414dd32c1d50c103eecd339d4_tn','https://down-vn.img.susercontent.com/file/e8954eb414dd32c1d50c103eecd339d4_tn','Thẻ nạp Viettel mệnh giá 10,000đ',1,1,'2025-12-11 12:56:51.000000',NULL),(2,'VIETTEL','Thẻ Viettel mệnh giá 20.000đ',20000,800,80,19000.00,20000.00,'https://down-vn.img.susercontent.com/file/456360f7e2d51b81853ac643c593b0f8_tn.webp','https://down-vn.img.susercontent.com/file/456360f7e2d51b81853ac643c593b0f8_tn.webp','Thẻ nạp Viettel mệnh giá 20,000đ',1,1,'2025-12-11 12:56:51.000000',NULL),(3,'VIETTEL','Thẻ Viettel mệnh giá 50.000đ',50000,1000,100,47500.00,50000.00,'https://img.giftpop.vn/brand/VIETTEL/MP2308220022_BASIC_origin.jpg','https://img.giftpop.vn/brand/VIETTEL/MP2308220022_BASIC_origin.jpg','Thẻ nạp Viettel mệnh giá 50,000đ',1,1,'2025-12-11 12:56:51.000000',NULL),(4,'VIETTEL','Thẻ Viettel mệnh giá 100.000đ',100000,1500,150,95000.00,100000.00,'https://img.giftpop.vn/brand/VIETTEL/MP2308220021_BASIC_origin.jpg','https://img.giftpop.vn/brand/VIETTEL/MP2308220021_BASIC_origin.jpg','Thẻ nạp Viettel mệnh giá 100,000đ',1,1,'2025-12-11 12:56:51.000000',NULL),(5,'VIETTEL','Thẻ Viettel mệnh giá 200.000đ',200000,800,80,190000.00,200000.00,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTKiA0vJGwca6Ed4mmZhKCoKpKO1WQEOTP1Kw&s','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTKiA0vJGwca6Ed4mmZhKCoKpKO1WQEOTP1Kw&s','Thẻ nạp Viettel mệnh giá 200,000đ',1,1,'2025-12-11 12:56:51.000000',NULL),(6,'VIETTEL','Thẻ Viettel mệnh giá 500.000đ',500000,500,50,475000.00,500000.00,'https://img.giftpop.vn/brand/VIETTEL/MP2308220018_BASIC_origin.jpg','https://img.giftpop.vn/brand/VIETTEL/MP2308220018_BASIC_origin.jpg','Thẻ nạp Viettel mệnh giá 500,000đ',1,1,'2025-12-11 12:56:51.000000',NULL),(7,'VINAPHONE','Thẻ Vinaphone',10000,450,50,9500.00,10000.00,'https://img.giftpop.vn/brand/VINAPHONE/MP2308220016_BASIC_origin.jpg','https://img.giftpop.vn/brand/VINAPHONE/MP2308220016_BASIC_origin.jpg','Thẻ nạp Vinaphone mệnh giá 10,000đ',1,1,'2025-12-11 12:56:51.000000',NULL),(8,'VINAPHONE','Thẻ Vinaphone',20000,700,70,19000.00,20000.00,'https://img.giftpop.vn/brand/VINAPHONE/MP2308220015_BASIC_origin.jpg','https://img.giftpop.vn/brand/VINAPHONE/MP2308220015_BASIC_origin.jpg','Thẻ nạp Vinaphone mệnh giá 20,000đ',1,1,'2025-12-11 12:56:51.000000',NULL),(9,'VINAPHONE','Thẻ Vinaphone',50000,900,90,47500.00,50000.00,'https://img.giftpop.vn/brand/VINAPHONE/MP2308220013_BASIC_origin.jpg','https://img.giftpop.vn/brand/VINAPHONE/MP2308220013_BASIC_origin.jpg','Thẻ nạp Vinaphone mệnh giá 50,000đ',1,1,'2025-12-11 12:56:51.000000',NULL),(10,'VINAPHONE','Thẻ Vinaphone',100000,1300,130,95000.00,100000.00,'https://img.giftpop.vn/brand/VINAPHONE/MP2308220012_BASIC_origin.jpg','https://img.giftpop.vn/brand/VINAPHONE/MP2308220012_BASIC_origin.jpg','Thẻ nạp Vinaphone mệnh giá 100,000đ',1,1,'2025-12-11 12:56:51.000000',NULL),(11,'VINAPHONE','Thẻ Vinaphone',200000,700,70,190000.00,200000.00,'https://img.giftpop.vn/brand/VINAPHONE/MP2308220011_BASIC_origin.jpg','https://img.giftpop.vn/brand/VINAPHONE/MP2308220011_BASIC_origin.jpg','Thẻ nạp Vinaphone mệnh giá 200,000đ',1,1,'2025-12-11 12:56:51.000000',NULL),(12,'VINAPHONE','Thẻ Vinaphone',500000,400,40,475000.00,500000.00,'https://img.giftpop.vn/brand/VINAPHONE/MP2308220009_BASIC_origin.jpg','https://img.giftpop.vn/brand/VINAPHONE/MP2308220009_BASIC_origin.jpg','Thẻ nạp Vinaphone mệnh giá 500,000đ',1,1,'2025-12-11 12:56:51.000000',NULL),(13,'MOBIFONE','Thẻ Mobifone',10000,400,50,9500.00,10000.00,'https://trungdungmobile.com/images/product/goc/1712650657th_i_n_tho_i_mobifone_10k.jpg','https://trungdungmobile.com/images/product/goc/1712650657th_i_n_tho_i_mobifone_10k.jpg','Thẻ nạp Mobifone mệnh giá 10,000đ',1,1,'2025-12-11 12:56:51.000000',NULL),(14,'MOBIFONE','Thẻ Mobifone',20000,650,65,19000.00,20000.00,'https://laz-img-sg.alicdn.com/p/30b5c950cc9e55d3182e8b9bc3ea0fcf.jpg','https://laz-img-sg.alicdn.com/p/30b5c950cc9e55d3182e8b9bc3ea0fcf.jpg','Thẻ nạp Mobifone mệnh giá 20,000đ',1,1,'2025-12-11 12:56:51.000000',NULL),(15,'MOBIFONE','Thẻ Mobifone',50000,850,85,47500.00,50000.00,'https://img.giftpop.vn/brand/MOBIFONE/MP2308220005_BASIC_origin.jpg','https://img.giftpop.vn/brand/MOBIFONE/MP2308220005_BASIC_origin.jpg','Thẻ nạp Mobifone mệnh giá 50,000đ',1,1,'2025-12-11 12:56:51.000000',NULL),(16,'MOBIFONE','Thẻ Mobifone',100000,1200,120,95000.00,100000.00,'https://img.giftpop.vn/brand/MOBIFONE/MP2308220004_BASIC_origin.jpg','https://img.giftpop.vn/brand/MOBIFONE/MP2308220004_BASIC_origin.jpg','Thẻ nạp Mobifone mệnh giá 100,000đ',1,1,'2025-12-11 12:56:51.000000',NULL),(17,'MOBIFONE','Thẻ Mobifone',200000,600,60,190000.00,200000.00,'https://img.giftpop.vn/brand/MOBIFONE/MP2308220003_BASIC_origin.jpg','https://img.giftpop.vn/brand/MOBIFONE/MP2308220003_BASIC_origin.jpg','Thẻ nạp Mobifone mệnh giá 200,000đ',1,1,'2025-12-11 12:56:51.000000',NULL),(18,'MOBIFONE','Thẻ Mobifone',500000,350,35,475000.00,500000.00,'https://img.giftpop.vn/brand/MOBIFONE/MP2308220001_BASIC_origin.jpg','https://img.giftpop.vn/brand/MOBIFONE/MP2308220001_BASIC_origin.jpg','Thẻ nạp Mobifone mệnh giá 500,000đ',1,1,'2025-12-11 12:56:51.000000',NULL);
/*!40000 ALTER TABLE `card_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cards`
--

DROP TABLE IF EXISTS `cards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cards` (
  `card_id` bigint NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `batch_id` bigint DEFAULT NULL,
  `serial` varchar(200) NOT NULL,
  `code` text NOT NULL,
  `supplier_id` int DEFAULT NULL,
  `status` enum('IN_STOCK','SOLD','RESERVED') DEFAULT 'IN_STOCK',
  `created_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `sold_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`card_id`),
  KEY `product_id` (`product_id`),
  KEY `supplier_id` (`supplier_id`),
  KEY `batch_id` (`batch_id`),
  CONSTRAINT `cards_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `card_products` (`product_id`),
  CONSTRAINT `cards_ibfk_2` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`supplier_id`),
  CONSTRAINT `cards_ibfk_3` FOREIGN KEY (`batch_id`) REFERENCES `import_batches` (`batch_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cards`
--

LOCK TABLES `cards` WRITE;
/*!40000 ALTER TABLE `cards` DISABLE KEYS */;
INSERT INTO `cards` VALUES (1,1,1,'10012345670001','VT10K0001234567',1,'IN_STOCK','2024-12-01 09:00:00.000000',NULL),(2,1,1,'10012345670002','VT10K0002345678',1,'IN_STOCK','2024-12-01 09:00:00.000000',NULL),(3,1,1,'10012345670003','VT10K0003456789',1,'SOLD','2024-12-01 09:00:00.000000',NULL),(4,2,1,'20012345670001','VT20K0001234567',1,'IN_STOCK','2024-12-01 09:00:00.000000',NULL),(5,2,1,'20012345670002','VT20K0002345678',1,'SOLD','2024-12-01 09:00:00.000000',NULL),(6,9,2,'50023456780001','VN50K0001234567',2,'IN_STOCK','2024-12-01 10:30:00.000000',NULL),(7,9,2,'50023456780002','VN50K0002345678',2,'IN_STOCK','2024-12-01 10:30:00.000000',NULL),(8,16,3,'10034567890001','MB100K001234567',3,'IN_STOCK','2024-12-02 08:00:00.000000',NULL),(9,16,3,'10034567890002','MB100K002345678',3,'SOLD','2024-12-02 08:00:00.000000',NULL);
/*!40000 ALTER TABLE `cards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_items`
--

DROP TABLE IF EXISTS `cart_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart_items` (
  `item_id` bigint NOT NULL AUTO_INCREMENT,
  `cart_id` bigint NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `unit_price` decimal(18,2) DEFAULT NULL,
  PRIMARY KEY (`item_id`),
  KEY `cart_id` (`cart_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `cart_items_ibfk_1` FOREIGN KEY (`cart_id`) REFERENCES `carts` (`cart_id`) ON DELETE CASCADE,
  CONSTRAINT `cart_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `card_products` (`product_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_items`
--

LOCK TABLES `cart_items` WRITE;
/*!40000 ALTER TABLE `cart_items` DISABLE KEYS */;
INSERT INTO `cart_items` VALUES (1,1,3,2,50000.00),(2,1,10,1,100000.00),(3,2,4,3,100000.00),(4,3,15,1,50000.00);
/*!40000 ALTER TABLE `cart_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `carts`
--

DROP TABLE IF EXISTS `carts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carts` (
  `cart_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `created_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`cart_id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `carts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carts`
--

LOCK TABLES `carts` WRITE;
/*!40000 ALTER TABLE `carts` DISABLE KEYS */;
INSERT INTO `carts` VALUES (1,4,'2025-12-11 12:56:51.000000','2025-12-11 12:56:51.000000'),(2,5,'2025-12-11 12:56:51.000000','2025-12-11 12:56:51.000000'),(3,6,'2025-12-11 12:56:51.000000','2025-12-11 12:56:51.000000');
/*!40000 ALTER TABLE `carts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_feedback`
--

DROP TABLE IF EXISTS `customer_feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_feedback` (
  `feedback_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `order_id` bigint DEFAULT NULL,
  `rating` int DEFAULT NULL,
  `category` enum('SERVICE','PRODUCT','WEBSITE','DELIVERY','OTHER') DEFAULT 'OTHER',
  `subject` varchar(255) DEFAULT NULL,
  `content` text NOT NULL,
  `is_public` tinyint(1) DEFAULT '0',
  `is_responded` tinyint(1) DEFAULT '0',
  `admin_response` text,
  `responded_by` int DEFAULT NULL,
  `responded_at` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`feedback_id`),
  KEY `user_id` (`user_id`),
  KEY `order_id` (`order_id`),
  KEY `responded_by` (`responded_by`),
  CONSTRAINT `customer_feedback_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `customer_feedback_ibfk_2` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  CONSTRAINT `customer_feedback_ibfk_3` FOREIGN KEY (`responded_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `customer_feedback_chk_1` CHECK ((`rating` between 1 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_feedback`
--

LOCK TABLES `customer_feedback` WRITE;
/*!40000 ALTER TABLE `customer_feedback` DISABLE KEYS */;
INSERT INTO `customer_feedback` VALUES (1,4,1,5,'SERVICE','Dịch vụ tuyệt vời!','Mình rất hài lòng với dịch vụ của shop. Giao dịch nhanh, thẻ chuẩn. Sẽ ủng hộ lâu dài!',1,1,'Cảm ơn bạn đã tin tùng và ủng hộ chúng tôi! Chúc bạn trải nghiệm thật tốt.',3,'2024-12-05 14:00:00.000000','2024-12-05 12:00:00.000000'),(2,5,2,4,'PRODUCT','Thẻ tốt, giá hợp lý','Thẻ chất lượng, giá cả cạnh tranh. Chỉ tiếc là không có nhiều khuyến mãi hơn.',1,1,'Cảm ơn bạn đã đánh giá! Chúng tôi sẽ có thêm nhiều chương trình khuyến mãi hấp dẫn trong thời gian tới.',3,'2024-12-06 16:00:00.000000','2024-12-06 15:00:00.000000'),(3,6,3,5,'WEBSITE','Website dễ sử dụng','Giao diện đẹp, dễ thao tác. Mua hàng rất tiện lợi.',1,0,NULL,NULL,NULL,'2024-12-07 11:00:00.000000'),(4,7,4,3,'DELIVERY','Hơi chậm','Thẻ về hơi chậm, nhưng chất lượng ok.',0,1,'Xin lỗi vì sự chậm trễ. Chúng tôi sẽ cải thiện tốc độ xử lý đơn hàng. Cảm ơn bạn đã góp ý.',2,'2024-12-08 18:00:00.000000','2024-12-08 17:00:00.000000'),(5,8,5,5,'SERVICE','Hoàn hảo!','Mọi thứ đều tốt, không có gì để chê. 10 điểm!',1,0,NULL,NULL,NULL,'2024-12-09 13:00:00.000000');
/*!40000 ALTER TABLE `customer_feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deposit_requests`
--

DROP TABLE IF EXISTS `deposit_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `deposit_requests` (
  `request_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `amount` decimal(18,2) NOT NULL,
  `status` enum('PENDING','APPROVED','FAILED') DEFAULT 'PENDING',
  `note` text,
  `created_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `approved_at` datetime(6) DEFAULT NULL,
  `approved_by` int DEFAULT NULL,
  PRIMARY KEY (`request_id`),
  KEY `user_id` (`user_id`),
  KEY `approved_by` (`approved_by`),
  CONSTRAINT `deposit_requests_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `deposit_requests_ibfk_2` FOREIGN KEY (`approved_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deposit_requests`
--

LOCK TABLES `deposit_requests` WRITE;
/*!40000 ALTER TABLE `deposit_requests` DISABLE KEYS */;
INSERT INTO `deposit_requests` VALUES (1,4,500000.00,'APPROVED','Nạp tiền lần đầu','2024-12-01 07:50:00.000000','2024-12-01 08:00:00.000000',1),(2,5,750000.00,'APPROVED','Nạp tiền','2024-12-02 08:50:00.000000','2024-12-02 09:00:00.000000',1),(3,6,1200000.00,'APPROVED','Nạp tiền','2024-12-03 09:50:00.000000','2024-12-03 10:00:00.000000',2),(4,7,300000.00,'APPROVED','Nạp tiền','2024-12-04 11:00:00.000000','2024-12-04 11:10:00.000000',1),(5,8,1000000.00,'APPROVED','Nạp tiền','2024-12-05 13:00:00.000000','2024-12-05 13:10:00.000000',1),(6,4,200000.00,'PENDING','Nạp thêm','2024-12-10 14:00:00.000000',NULL,NULL);
/*!40000 ALTER TABLE `deposit_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `import_batches`
--

DROP TABLE IF EXISTS `import_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `import_batches` (
  `batch_id` bigint NOT NULL AUTO_INCREMENT,
  `supplier_id` int DEFAULT NULL,
  `filename` varchar(500) DEFAULT NULL,
  `total_cards` int DEFAULT '0',
  `total_amount` decimal(18,2) DEFAULT '0.00',
  `imported_by` int DEFAULT NULL,
  `note` text,
  `created_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`batch_id`),
  KEY `supplier_id` (`supplier_id`),
  KEY `imported_by` (`imported_by`),
  CONSTRAINT `import_batches_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`supplier_id`),
  CONSTRAINT `import_batches_ibfk_2` FOREIGN KEY (`imported_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `import_batches`
--

LOCK TABLES `import_batches` WRITE;
/*!40000 ALTER TABLE `import_batches` DISABLE KEYS */;
INSERT INTO `import_batches` VALUES (1,1,'viettel_batch_001.xlsx',5000,475000000.00,1,'Lô hàng Viettel tháng 12/2024','2024-12-01 09:00:00.000000'),(2,2,'vinaphone_batch_001.xlsx',4000,380000000.00,1,'Lô hàng Vinaphone tháng 12/2024','2024-12-01 10:30:00.000000'),(3,3,'mobifone_batch_001.xlsx',3500,332500000.00,2,'Lô hàng Mobifone tháng 12/2024','2024-12-02 08:00:00.000000'),(4,1,'viettel_batch_002.xlsx',3000,285000000.00,1,'Lô hàng Viettel bổ sung','2024-12-05 14:00:00.000000');
/*!40000 ALTER TABLE `import_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `news`
--

DROP TABLE IF EXISTS `news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `news` (
  `news_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `content` longtext,
  `thumbnail_url` varchar(500) DEFAULT NULL,
  `author_id` int DEFAULT NULL,
  `is_published` tinyint(1) DEFAULT '0',
  `view_count` int DEFAULT '0',
  `published_at` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`news_id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `author_id` (`author_id`),
  CONSTRAINT `news_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news`
--

LOCK TABLES `news` WRITE;
/*!40000 ALTER TABLE `news` DISABLE KEYS */;
INSERT INTO `news` VALUES (1,'Hướng dẫn mua thẻ điện thoại online an toàn','huong-dan-mua-the-dien-thoai-online-an-toan','<h2>Giới thiệu</h2><p>Mua thẻ điện thoại online đang trở thành xu hướng phổ biến nhờ sự tiện lợi và nhanh chóng...</p><h2>Các bước thực hiện</h2><p>1. Chọn nhà cung cấp uy tín<br>2. Kiểm tra thông tin sản phẩm<br>3. Thanh toán an toàn...</p>','https://via.placeholder.com/800x400/4CAF50/ffffff?text=Huong+dan',1,1,1250,'2024-11-15 10:00:00.000000','2024-11-15 09:00:00.000000','2024-11-15 10:00:00.000000'),(2,'Khuyến mãi Noel 2024 - Giảm giá đến 10%','khuyen-mai-noel-2024','<h2>Chương trình khuyến mãi</h2><p>Nhân dịp Noel 2024, chúng tôi dành tặng khách hàng chương trình giảm giá hấp dẫn...</p><ul><li>Giảm 5% cho thẻ Viettel</li><li>Giảm 10% cho thẻ Vinaphone</li><li>Nhiều quà tặng hấp dẫn</li></ul>','https://via.placeholder.com/800x400/F44336/ffffff?text=Noel+2024',2,1,3420,'2024-12-01 08:00:00.000000','2024-11-25 14:00:00.000000','2024-12-01 08:00:00.000000'),(3,'Top 3 nhà mạng được ưa chuộng nhất 2024','top-3-nha-mang-duoc-ua-chuong-nhat-2024','<h2>Bảng xếp hạng</h2><p>Dựa trên khảo sát từ hàng nghìn người dùng...</p><h3>1. Viettel</h3><p>Viettel dẫn đầu với độ phủ sóng rộng nhất...</p><h3>2. Vinaphone</h3><p>Vinaphone nổi bật với các gói cước hấp dẫn...</p>','https://via.placeholder.com/800x400/2196F3/ffffff?text=Top+3',1,1,2180,'2024-11-20 15:00:00.000000','2024-11-18 10:00:00.000000','2024-11-20 15:00:00.000000'),(4,'Cách phân biệt thẻ cào thật và giả','cach-phan-biet-the-cao-that-va-gia','<h2>Dấu hiệu nhận biết</h2><p>Để tránh mua phải thẻ cào giả, bạn cần chú ý các dấu hiệu sau...</p><ol><li>Kiểm tra chất liệu thẻ</li><li>Xem xét màu sắc và in ấn</li><li>Thử nạp thẻ</li></ol>','https://via.placeholder.com/800x400/FF9800/ffffff?text=Phan+biet',2,1,890,'2024-12-05 09:00:00.000000','2024-12-03 11:00:00.000000','2024-12-05 09:00:00.000000'),(5,'Thông báo bảo trì hệ thống','thong-bao-bao-tri-he-thong','<p>Kính gửi quý khách hàng,</p><p>Hệ thống sẽ tạm ngưng hoạt động để bảo trì từ 02:00 - 04:00 ngày 15/12/2024...</p>','https://via.placeholder.com/800x400/9C27B0/ffffff?text=Bao+tri',1,0,0,NULL,'2024-12-10 10:00:00.000000','2024-12-10 10:00:00.000000');
/*!40000 ALTER TABLE `news` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `notification_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `type` enum('SYSTEM','TRANSACTION','PROMOTION','ORDER') DEFAULT 'SYSTEM',
  `is_read` tinyint(1) DEFAULT '0',
  `created_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`notification_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (1,4,'Đơn hàng #1 đã được xác nhận','Đơn hàng của bạn đã được thanh toán thành công. Thẻ đã được gửi về email.','ORDER',1,'2024-12-05 10:01:00.000000'),(2,4,'Nạp tiền thành công','Bạn đã nạp 500,000đ vào ví thành công.','TRANSACTION',1,'2024-12-01 08:00:00.000000'),(3,5,'Khuyến mãi Noel 2024','Giảm giá đến 10% cho các sản phẩm. Xem ngay!','PROMOTION',0,'2024-12-01 08:30:00.000000'),(4,5,'Đơn hàng #2 đã được xác nhận','Đơn hàng của bạn đã được thanh toán thành công.','ORDER',1,'2024-12-06 14:31:00.000000'),(5,6,'Đơn hàng #3 đã được xác nhận','Đơn hàng của bạn đã được thanh toán thành công.','ORDER',1,'2024-12-07 09:16:00.000000'),(6,7,'Chào mừng bạn đến với CardStore','Cảm ơn bạn đã đăng ký tài khoản. Nạp tiền ngay để nhận ưu đãi!','SYSTEM',0,'2024-12-08 08:00:00.000000'),(7,8,'Flash Sale cuối tuần','Giảm 7% tất cả thẻ Mobifone mỗi thứ 7. Đừng bỏ lỡ!','PROMOTION',0,'2024-12-09 07:00:00.000000');
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `item_id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL,
  `unit_price` decimal(18,2) NOT NULL,
  `final_price` decimal(18,2) NOT NULL,
  `profit` decimal(18,2) NOT NULL,
  `assigned_card_id` bigint DEFAULT NULL,
  PRIMARY KEY (`item_id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  KEY `assigned_card_id` (`assigned_card_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `card_products` (`product_id`),
  CONSTRAINT `order_items_ibfk_3` FOREIGN KEY (`assigned_card_id`) REFERENCES `cards` (`card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (1,1,4,2,100000.00,100000.00,5000.00,NULL),(2,2,3,3,50000.00,50000.00,2500.00,NULL),(3,3,10,2,100000.00,100000.00,5000.00,NULL),(4,3,16,1,100000.00,100000.00,5000.00,8),(5,4,4,1,100000.00,100000.00,5000.00,NULL),(6,5,6,1,500000.00,500000.00,25000.00,NULL);
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `total_amount` decimal(18,2) NOT NULL,
  `status` enum('PAID','CANCELLED','REFUNDED') DEFAULT 'PAID',
  `created_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `paid_at` datetime(6) DEFAULT NULL,
  `cancelled_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,4,200000.00,'PAID','2024-12-05 10:00:00.000000','2024-12-05 10:01:00.000000',NULL),(2,5,150000.00,'PAID','2024-12-06 14:30:00.000000','2024-12-06 14:31:00.000000',NULL),(3,6,300000.00,'PAID','2024-12-07 09:15:00.000000','2024-12-07 09:16:00.000000',NULL),(4,7,100000.00,'PAID','2024-12-08 16:45:00.000000','2024-12-08 16:46:00.000000',NULL),(5,8,500000.00,'PAID','2024-12-09 11:20:00.000000','2024-12-09 11:21:00.000000',NULL);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `payment_id` bigint NOT NULL AUTO_INCREMENT,
  `deposit_request_id` bigint NOT NULL,
  `amount` decimal(18,2) NOT NULL,
  `vnp_transaction_no` varchar(100) DEFAULT NULL,
  `vnp_bank_code` varchar(50) DEFAULT NULL,
  `vnp_bank_tran_no` varchar(100) DEFAULT NULL,
  `vnp_card_type` varchar(50) DEFAULT NULL,
  `vnp_response_code` varchar(10) DEFAULT NULL,
  `vnp_transaction_status` varchar(10) DEFAULT NULL,
  `pay_date` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`payment_id`),
  KEY `deposit_request_id` (`deposit_request_id`),
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`deposit_request_id`) REFERENCES `deposit_requests` (`request_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (1,1,500000.00,'VNP14152441','NCB','VNP14152441','ATM','00','00','2024-12-01 07:55:00.000000','2024-12-01 07:55:00.000000'),(2,2,750000.00,'VNP14152442','VIETCOMBANK','VNP14152442','ATM','00','00','2024-12-02 08:55:00.000000','2024-12-02 08:55:00.000000'),(3,3,1200000.00,'VNP14152443','TECHCOMBANK','VNP14152443','ATM','00','00','2024-12-03 09:55:00.000000','2024-12-03 09:55:00.000000'),(4,4,300000.00,'VNP14152444','VIETINBANK','VNP14152444','ATM','00','00','2024-12-04 11:05:00.000000','2024-12-04 11:05:00.000000'),(5,5,1000000.00,'VNP14152445','ACB','VNP14152445','ATM','00','00','2024-12-05 13:05:00.000000','2024-12-05 13:05:00.000000');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `promotion_details`
--

DROP TABLE IF EXISTS `promotion_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promotion_details` (
  `detail_id` bigint NOT NULL AUTO_INCREMENT,
  `promotion_id` int NOT NULL,
  `product_id` int NOT NULL,
  `discount_percent` decimal(5,2) DEFAULT '0.00',
  PRIMARY KEY (`detail_id`),
  KEY `promotion_id` (`promotion_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `promotion_details_ibfk_1` FOREIGN KEY (`promotion_id`) REFERENCES `promotions` (`promotion_id`) ON DELETE CASCADE,
  CONSTRAINT `promotion_details_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `card_products` (`product_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promotion_details`
--

LOCK TABLES `promotion_details` WRITE;
/*!40000 ALTER TABLE `promotion_details` DISABLE KEYS */;
INSERT INTO `promotion_details` VALUES (1,1,1,5.00),(2,1,2,5.00),(3,1,3,5.00),(4,1,4,5.00),(5,1,5,5.00),(6,1,6,5.00),(7,2,10,10.00),(8,2,11,10.00),(9,2,12,10.00),(10,3,13,7.00),(11,3,14,7.00),(12,3,15,7.00),(13,3,16,7.00),(14,3,17,7.00),(15,3,18,7.00);
/*!40000 ALTER TABLE `promotion_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `promotions`
--

DROP TABLE IF EXISTS `promotions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promotions` (
  `promotion_id` int NOT NULL AUTO_INCREMENT,
  `promotion_name` varchar(255) NOT NULL,
  `description` text,
  `start_at` datetime NOT NULL,
  `end_at` datetime NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `banner_url` varchar(500) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `created_by` int DEFAULT NULL,
  PRIMARY KEY (`promotion_id`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `promotions_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promotions`
--

LOCK TABLES `promotions` WRITE;
/*!40000 ALTER TABLE `promotions` DISABLE KEYS */;
INSERT INTO `promotions` VALUES (1,'Khuyến mãi Noel 2024','Giảm giá 5% cho tất cả thẻ Viettel','2024-12-20 00:00:00','2024-12-26 23:59:59',1,'https://via.placeholder.com/1200x400/ff0000/ffffff?text=Noel+2024','2025-12-11 12:56:51.000000',1),(2,'Chào mừng năm mới 2025','Giảm giá 10% thẻ Vinaphone 100K+','2024-12-28 00:00:00','2025-01-05 23:59:59',1,'https://via.placeholder.com/1200x400/0066cc/ffffff?text=Happy+New+Year','2025-12-11 12:56:51.000000',1),(3,'Flash Sale cuối tuần','Giảm 7% thẻ Mobifone mỗi thứ 7','2024-12-14 00:00:00','2024-12-31 23:59:59',1,'https://via.placeholder.com/1200x400/ff9900/ffffff?text=Flash+Sale','2025-12-11 12:56:51.000000',2);
/*!40000 ALTER TABLE `promotions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `revenue_reports`
--

DROP TABLE IF EXISTS `revenue_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `revenue_reports` (
  `report_id` bigint NOT NULL AUTO_INCREMENT,
  `report_date` date NOT NULL,
  `report_type` enum('DAILY','WEEKLY','MONTHLY','YEARLY') NOT NULL,
  `total_revenue` decimal(18,2) DEFAULT '0.00',
  `total_profit` decimal(18,2) DEFAULT '0.00',
  `total_orders` int DEFAULT '0',
  `total_cards_sold` int DEFAULT '0',
  `new_users_count` int DEFAULT '0',
  `total_deposits` decimal(18,2) DEFAULT '0.00',
  `generated_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `generated_by` int DEFAULT NULL,
  PRIMARY KEY (`report_id`),
  UNIQUE KEY `unique_report` (`report_date`,`report_type`),
  KEY `generated_by` (`generated_by`),
  CONSTRAINT `revenue_reports_ibfk_1` FOREIGN KEY (`generated_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `revenue_reports`
--

LOCK TABLES `revenue_reports` WRITE;
/*!40000 ALTER TABLE `revenue_reports` DISABLE KEYS */;
INSERT INTO `revenue_reports` VALUES (1,'2024-12-05','DAILY',200000.00,10000.00,1,2,0,500000.00,'2024-12-06 00:30:00.000000',1),(2,'2024-12-06','DAILY',150000.00,7500.00,1,3,0,750000.00,'2024-12-07 00:30:00.000000',1),(3,'2024-12-07','DAILY',300000.00,15000.00,1,3,0,1200000.00,'2024-12-08 00:30:00.000000',1),(4,'2024-12-08','DAILY',100000.00,5000.00,1,1,0,300000.00,'2024-12-09 00:30:00.000000',1),(5,'2024-12-09','DAILY',500000.00,25000.00,1,1,0,1000000.00,'2024-12-10 00:30:00.000000',1),(6,'2024-12-01','WEEKLY',1250000.00,62500.00,5,10,4,3750000.00,'2024-12-08 01:00:00.000000',1),(7,'2024-12-01','MONTHLY',1250000.00,62500.00,5,10,4,3750000.00,'2024-12-10 02:00:00.000000',1);
/*!40000 ALTER TABLE `revenue_reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `role_id` int NOT NULL AUTO_INCREMENT,
  `role_name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `role_name` (`role_name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'ADMIN','Quản trị viên hệ thống'),(2,'MANAGER','Quản lý cửa hàng'),(3,'STAFF','Nhân viên hỗ trợ'),(4,'CUSTOMER','Khách hàng');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_alerts`
--

DROP TABLE IF EXISTS `stock_alerts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_alerts` (
  `alert_id` bigint NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `alert_type` enum('LOW_STOCK','OUT_OF_STOCK','RESTOCKED') NOT NULL,
  `threshold_quantity` int DEFAULT NULL,
  `current_quantity` int DEFAULT NULL,
  `is_resolved` tinyint(1) DEFAULT '0',
  `created_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `resolved_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`alert_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `stock_alerts_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `card_products` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_alerts`
--

LOCK TABLES `stock_alerts` WRITE;
/*!40000 ALTER TABLE `stock_alerts` DISABLE KEYS */;
INSERT INTO `stock_alerts` VALUES (1,1,'LOW_STOCK',50,45,0,'2024-12-08 10:00:00.000000',NULL),(2,13,'LOW_STOCK',50,30,1,'2024-12-05 08:00:00.000000','2024-12-06 09:00:00.000000'),(3,7,'OUT_OF_STOCK',50,0,0,'2024-12-09 15:00:00.000000',NULL);
/*!40000 ALTER TABLE `stock_alerts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suppliers`
--

DROP TABLE IF EXISTS `suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `suppliers` (
  `supplier_id` int NOT NULL AUTO_INCREMENT,
  `supplier_name` varchar(255) NOT NULL,
  `contact_info` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `address` text,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`supplier_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliers`
--

LOCK TABLES `suppliers` WRITE;
/*!40000 ALTER TABLE `suppliers` DISABLE KEYS */;
INSERT INTO `suppliers` VALUES (1,'Viettel Store','Mr. Tuấn','contact@viettelstore.vn','19008198','01 Phố Huế, Hai Bà Trưng, Hà Nội',1,'2025-12-11 12:56:51.000000'),(2,'Vinaphone Official','Ms. Hương','supplier@vinaphone.vn','18001091','115 Trần Duy Hưng, Cầu Giấy, Hà Nội',1,'2025-12-11 12:56:51.000000'),(3,'MobiFone Partner','Mr. Dũng','partner@mobifone.vn','18001090','50 Bà Triệu, Hoàn Kiếm, Hà Nội',1,'2025-12-11 12:56:51.000000'),(4,'Thẻ Việt','Ms. Linh','info@theviet.vn','0909123456','123 Lê Lợi, Quận 1, TP.HCM',1,'2025-12-11 12:56:51.000000');
/*!40000 ALTER TABLE `suppliers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `support_tickets`
--

DROP TABLE IF EXISTS `support_tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `support_tickets` (
  `ticket_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `subject` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `priority` enum('LOW','MEDIUM','HIGH','URGENT') DEFAULT 'MEDIUM',
  `status` enum('NEW','PROCESSING','RESOLVED','CLOSED') DEFAULT 'NEW',
  `processed_by` int DEFAULT NULL,
  `created_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) DEFAULT NULL,
  `resolved_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`ticket_id`),
  KEY `user_id` (`user_id`),
  KEY `processed_by` (`processed_by`),
  CONSTRAINT `support_tickets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `support_tickets_ibfk_2` FOREIGN KEY (`processed_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `support_tickets`
--

LOCK TABLES `support_tickets` WRITE;
/*!40000 ALTER TABLE `support_tickets` DISABLE KEYS */;
INSERT INTO `support_tickets` VALUES (1,4,'Không nhận được thẻ sau khi thanh toán','Em đã thanh toán đơn hàng #1 nhưng chưa thấy thẻ trong email. Nhờ ad kiểm tra giúp em.','HIGH','RESOLVED',3,'2024-12-05 10:30:00.000000','2024-12-05 11:00:00.000000','2024-12-05 11:00:00.000000'),(2,5,'Hỏi về khuyến mãi Noel','Cho em hỏi khuyến mãi Noel có áp dụng cho thẻ Vinaphone không ạ?','MEDIUM','RESOLVED',3,'2024-12-06 15:00:00.000000','2024-12-06 15:30:00.000000','2024-12-06 15:30:00.000000'),(3,6,'Muốn đổi mật khẩu','Em quên mật khẩu tài khoản, nhờ ad hỗ trợ reset lại.','MEDIUM','PROCESSING',3,'2024-12-07 10:00:00.000000','2024-12-07 10:15:00.000000',NULL),(4,7,'Thẻ bị lỗi không nạp được','Em mua thẻ Viettel 100K nhưng nạp vào báo lỗi. Code: VT100K001234567','URGENT','NEW',NULL,'2024-12-10 16:00:00.000000','2024-12-10 16:00:00.000000',NULL);
/*!40000 ALTER TABLE `support_tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_settings`
--

DROP TABLE IF EXISTS `system_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_settings` (
  `setting_id` int NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text,
  `description` varchar(255) DEFAULT NULL,
  `data_type` enum('STRING','NUMBER','BOOLEAN','JSON') DEFAULT 'STRING',
  `is_public` tinyint(1) DEFAULT '0',
  `updated_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `updated_by` int DEFAULT NULL,
  PRIMARY KEY (`setting_id`),
  UNIQUE KEY `setting_key` (`setting_key`),
  KEY `updated_by` (`updated_by`),
  CONSTRAINT `system_settings_ibfk_1` FOREIGN KEY (`updated_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_settings`
--

LOCK TABLES `system_settings` WRITE;
/*!40000 ALTER TABLE `system_settings` DISABLE KEYS */;
INSERT INTO `system_settings` VALUES (1,'site_name','CardStore Vietnam','Tên website','STRING',1,'2025-12-11 12:56:51.000000',1),(2,'site_logo','https://via.placeholder.com/200x80/000000/ffffff?text=CardStore','Logo website','STRING',1,'2025-12-11 12:56:51.000000',1),(3,'contact_email','support@cardstore.vn','Email liên hệ','STRING',1,'2025-12-11 12:56:51.000000',1),(4,'contact_phone','1900-xxxx','Số điện thoại hỗ trợ','STRING',1,'2025-12-11 12:56:51.000000',1),(5,'contact_address','123 Nguyễn Huệ, Q.1, TP.HCM','Địa chỉ công ty','STRING',1,'2025-12-11 12:56:51.000000',1),(6,'min_deposit_amount','50000','Số tiền nạp tối thiểu','NUMBER',1,'2025-12-11 12:56:51.000000',1),(7,'max_deposit_amount','50000000','Số tiền nạp tối đa','NUMBER',1,'2025-12-11 12:56:51.000000',1),(8,'enable_promotions','true','Bật/tắt tính năng khuyến mãi','BOOLEAN',0,'2025-12-11 12:56:51.000000',1),(9,'maintenance_mode','false','Chế độ bảo trì','BOOLEAN',0,'2025-12-11 12:56:51.000000',1),(10,'vnpay_tmn_code','XXXXXXXX','Mã TMN của VNPay','STRING',0,'2025-12-11 12:56:51.000000',1),(11,'vnpay_hash_secret','XXXXXXXXXXXXXXXX','Hash secret VNPay (encrypted)','STRING',0,'2025-12-11 12:56:51.000000',1),(12,'allow_guest_checkout','false','Cho phép khách mua hàng không cần đăng ký','BOOLEAN',1,'2025-12-11 12:56:51.000000',1),(13,'facebook_url','https://facebook.com/cardstore','Link Facebook','STRING',1,'2025-12-11 12:56:51.000000',1),(14,'zalo_url','https://zalo.me/cardstore','Link Zalo','STRING',1,'2025-12-11 12:56:51.000000',1);
/*!40000 ALTER TABLE `system_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_replies`
--

DROP TABLE IF EXISTS `ticket_replies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ticket_replies` (
  `reply_id` bigint NOT NULL AUTO_INCREMENT,
  `ticket_id` bigint NOT NULL,
  `user_id` int NOT NULL,
  `content` text NOT NULL,
  `is_staff_reply` tinyint(1) DEFAULT '0',
  `created_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`reply_id`),
  KEY `ticket_id` (`ticket_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `ticket_replies_ibfk_1` FOREIGN KEY (`ticket_id`) REFERENCES `support_tickets` (`ticket_id`) ON DELETE CASCADE,
  CONSTRAINT `ticket_replies_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_replies`
--

LOCK TABLES `ticket_replies` WRITE;
/*!40000 ALTER TABLE `ticket_replies` DISABLE KEYS */;
INSERT INTO `ticket_replies` VALUES (1,1,3,'Chào bạn, chúng tôi đã kiểm tra và thấy đơn hàng của bạn đã được xử lý thành công. Thẻ đã được gửi về email. Vui lòng kiểm tra lại hộp thư spam.',1,'2024-12-05 10:45:00.000000'),(2,1,4,'Em đã tìm thấy trong spam rồi ạ. Cảm ơn ad!',0,'2024-12-05 11:00:00.000000'),(3,2,3,'Chào bạn, khuyến mãi Noel hiện tại chỉ áp dụng cho thẻ Viettel. Chúng tôi sẽ có chương trình khuyến mãi cho Vinaphone vào dịp Tết.',1,'2024-12-06 15:15:00.000000'),(4,2,5,'Dạ em hiểu rồi. Cảm ơn ad!',0,'2024-12-06 15:30:00.000000'),(5,3,3,'Chào bạn, chúng tôi đã gửi link reset mật khẩu về email của bạn. Vui lòng kiểm tra.',1,'2024-12-07 10:15:00.000000');
/*!40000 ALTER TABLE `ticket_replies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_roles`
--

DROP TABLE IF EXISTS `user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_roles` (
  `user_id` int NOT NULL,
  `role_id` int NOT NULL,
  `assigned_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `user_roles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `user_roles_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_roles`
--

LOCK TABLES `user_roles` WRITE;
/*!40000 ALTER TABLE `user_roles` DISABLE KEYS */;
INSERT INTO `user_roles` VALUES (1,1,'2025-12-11 12:56:51.178432'),(2,2,'2025-12-11 12:56:51.178432'),(3,3,'2025-12-11 12:56:51.178432'),(4,4,'2025-12-11 12:56:51.178432'),(5,4,'2025-12-11 12:56:51.178432'),(6,4,'2025-12-11 12:56:51.178432'),(7,4,'2025-12-11 12:56:51.178432'),(8,4,'2025-12-11 12:56:51.178432');
/*!40000 ALTER TABLE `user_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `password_hash` varchar(512) NOT NULL,
  `full_name` varchar(200) DEFAULT NULL,
  `avatar_url` varchar(500) DEFAULT NULL,
  `is_locked` tinyint(1) DEFAULT '0',
  `created_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin@cardstore.vn','0901234567','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy','Nguyễn Văn Admin','https://i.pravatar.cc/150?img=1',0,'2025-12-11 12:56:51.000000',NULL),(2,'manager@cardstore.vn','0902345678','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy','Trần Thị Manager','https://i.pravatar.cc/150?img=2',0,'2025-12-11 12:56:51.000000',NULL),(3,'staff01@cardstore.vn','0903456789','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy','Lê Văn Staff','https://i.pravatar.cc/150?img=3',0,'2025-12-11 12:56:51.000000',NULL),(4,'customer01@gmail.com','0904567890','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy','Phạm Văn Khách','https://i.pravatar.cc/150?img=4',0,'2025-12-11 12:56:51.000000',NULL),(5,'customer02@gmail.com','0905678901','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy','Hoàng Thị Hoa','https://i.pravatar.cc/150?img=5',0,'2025-12-11 12:56:51.000000',NULL),(6,'customer03@gmail.com','0906789012','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy','Đặng Văn Bình','https://i.pravatar.cc/150?img=6',0,'2025-12-11 12:56:51.000000',NULL),(7,'customer04@gmail.com','0907890123','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy','Vũ Thị Lan','https://i.pravatar.cc/150?img=7',0,'2025-12-11 12:56:51.000000',NULL),(8,'customer05@gmail.com','0908901234','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy','Bùi Văn Nam','https://i.pravatar.cc/150?img=8',0,'2025-12-11 12:56:51.000000',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wallet_transactions`
--

DROP TABLE IF EXISTS `wallet_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wallet_transactions` (
  `transaction_id` bigint NOT NULL AUTO_INCREMENT,
  `wallet_id` int NOT NULL,
  `amount` decimal(18,2) NOT NULL,
  `type` enum('DEPOSIT','PURCHASE','REFUND') NOT NULL,
  `reference` varchar(200) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`transaction_id`),
  KEY `wallet_id` (`wallet_id`),
  CONSTRAINT `wallet_transactions_ibfk_1` FOREIGN KEY (`wallet_id`) REFERENCES `wallets` (`wallet_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wallet_transactions`
--

LOCK TABLES `wallet_transactions` WRITE;
/*!40000 ALTER TABLE `wallet_transactions` DISABLE KEYS */;
INSERT INTO `wallet_transactions` VALUES (1,4,500000.00,'DEPOSIT','VNP_TXN_20241201001','2024-12-01 08:00:00.000000'),(2,5,750000.00,'DEPOSIT','VNP_TXN_20241202001','2024-12-02 09:00:00.000000'),(3,6,1200000.00,'DEPOSIT','VNP_TXN_20241203001','2024-12-03 10:00:00.000000'),(4,4,-200000.00,'PURCHASE','ORDER_1','2024-12-05 10:01:00.000000'),(5,5,-150000.00,'PURCHASE','ORDER_2','2024-12-06 14:31:00.000000'),(6,6,-300000.00,'PURCHASE','ORDER_3','2024-12-07 09:16:00.000000'),(7,7,-100000.00,'PURCHASE','ORDER_4','2024-12-08 16:46:00.000000'),(8,8,-500000.00,'PURCHASE','ORDER_5','2024-12-09 11:21:00.000000');
/*!40000 ALTER TABLE `wallet_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wallets`
--

DROP TABLE IF EXISTS `wallets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wallets` (
  `wallet_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `balance` decimal(18,2) NOT NULL DEFAULT '0.00',
  `updated_at` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`wallet_id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `wallets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wallets`
--

LOCK TABLES `wallets` WRITE;
/*!40000 ALTER TABLE `wallets` DISABLE KEYS */;
INSERT INTO `wallets` VALUES (1,1,10000000.00,'2025-12-11 12:56:51.000000'),(2,2,5000000.00,'2025-12-11 12:56:51.000000'),(3,3,2000000.00,'2025-12-11 12:56:51.000000'),(4,4,500000.00,'2025-12-11 12:56:51.000000'),(5,5,750000.00,'2025-12-11 12:56:51.000000'),(6,6,1200000.00,'2025-12-11 12:56:51.000000'),(7,7,300000.00,'2025-12-11 12:56:51.000000'),(8,8,950000.00,'2025-12-11 12:56:51.000000');
/*!40000 ALTER TABLE `wallets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'card_store'
--

--
-- Dumping routines for database 'card_store'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-12  9:19:15
