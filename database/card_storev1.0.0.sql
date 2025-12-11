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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `card_products`
--

LOCK TABLES `card_products` WRITE;
/*!40000 ALTER TABLE `card_products` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cards`
--

LOCK TABLES `cards` WRITE;
/*!40000 ALTER TABLE `cards` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_items`
--

LOCK TABLES `cart_items` WRITE;
/*!40000 ALTER TABLE `cart_items` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carts`
--

LOCK TABLES `carts` WRITE;
/*!40000 ALTER TABLE `carts` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_feedback`
--

LOCK TABLES `customer_feedback` WRITE;
/*!40000 ALTER TABLE `customer_feedback` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deposit_requests`
--

LOCK TABLES `deposit_requests` WRITE;
/*!40000 ALTER TABLE `deposit_requests` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `import_batches`
--

LOCK TABLES `import_batches` WRITE;
/*!40000 ALTER TABLE `import_batches` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news`
--

LOCK TABLES `news` WRITE;
/*!40000 ALTER TABLE `news` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promotion_details`
--

LOCK TABLES `promotion_details` WRITE;
/*!40000 ALTER TABLE `promotion_details` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promotions`
--

LOCK TABLES `promotions` WRITE;
/*!40000 ALTER TABLE `promotions` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `revenue_reports`
--

LOCK TABLES `revenue_reports` WRITE;
/*!40000 ALTER TABLE `revenue_reports` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_alerts`
--

LOCK TABLES `stock_alerts` WRITE;
/*!40000 ALTER TABLE `stock_alerts` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliers`
--

LOCK TABLES `suppliers` WRITE;
/*!40000 ALTER TABLE `suppliers` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `support_tickets`
--

LOCK TABLES `support_tickets` WRITE;
/*!40000 ALTER TABLE `support_tickets` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_settings`
--

LOCK TABLES `system_settings` WRITE;
/*!40000 ALTER TABLE `system_settings` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_replies`
--

LOCK TABLES `ticket_replies` WRITE;
/*!40000 ALTER TABLE `ticket_replies` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wallet_transactions`
--

LOCK TABLES `wallet_transactions` WRITE;
/*!40000 ALTER TABLE `wallet_transactions` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wallets`
--

LOCK TABLES `wallets` WRITE;
/*!40000 ALTER TABLE `wallets` DISABLE KEYS */;
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

-- Dump completed on 2025-12-11  2:09:32
