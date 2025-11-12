-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 12, 2025 at 06:24 AM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.1.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `database`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `username`, `password`) VALUES
(1, 'admin', '1234');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `category_id` int(11) NOT NULL,
  `category_name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`category_id`, `category_name`, `description`, `created_at`) VALUES
(1, 'ชุด SET Combo', 'Set Computer', '2025-10-24 17:40:00'),
(2, 'Notebook Gaming', 'Notebook', '2025-10-24 17:40:00'),
(3, 'Gaming Gear', '', '2025-10-24 17:40:00'),
(4, 'Accessories', '', '2025-10-24 17:40:00');

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `customer_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`customer_id`, `username`, `password`, `full_name`, `email`, `created_at`) VALUES
(1, 'along111along', '$2y$10$IiixCylcuChvhGYEMVNToOkmYPG4SCI8UCBv5C1HFqrOiuKzKdJWm', 'อลงกรณ์ ลายนอก', 'alongkonlainok2@gmail.com', '2025-10-29 17:27:06'),
(2, 'kim', '$2y$10$zc9PbGiw1s3VvrGiJ.G3buNo./kGdwA/yplxXvik.EbWlvieAnuM2', 'อลงกรณ์ ลายนอก', 'potiwat.s2005@gmail.com', '2025-11-12 05:13:05');

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

CREATE TABLE `employees` (
  `employee_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `name` varchar(100) NOT NULL,
  `position` varchar(50) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employees`
--

INSERT INTO `employees` (`employee_id`, `username`, `password`, `name`, `position`, `email`, `phone`, `created_at`, `updated_at`) VALUES
(1, 'admin', '1234', 'ผู้ดูแลระบบ', 'Admin', NULL, NULL, '2025-10-24 17:33:08', '2025-10-24 17:34:11'),
(2, 'staff01', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'พนักงาน 1', 'Staff', NULL, NULL, '2025-10-24 17:33:08', '2025-10-24 17:33:08'),
(3, 'manager', '1234', 'ผู้จัดการ', 'Manager', NULL, NULL, '2025-10-24 17:33:08', '2025-10-24 17:33:35');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(10) UNSIGNED NOT NULL,
  `customer_username` varchar(100) DEFAULT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `order_date` datetime NOT NULL,
  `status` varchar(20) DEFAULT 'รอดำเนินการ'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `customer_username`, `total_price`, `order_date`, `status`) VALUES
(34, 'along111along', '0.00', '2025-10-30 00:39:02', 'เสร็จแล้ว');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `order_id` int(10) UNSIGNED NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'รอดำเนินการ' COMMENT 'status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `quantity`, `price`, `subtotal`, `status`) VALUES
(73, 34, 29, 1, '39500.00', '0.00', 'เสร็จแล้ว');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` int(11) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `product_name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `image` text DEFAULT NULL,
  `stock` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_id`, `category_id`, `product_name`, `description`, `price`, `image`, `stock`, `created_at`) VALUES
(29, 1, 'COMPUTER SET MARU-2510095', 'COMPUTER SET  MARU-2510095 RYZEN 7 9700X / RX9060 XT 16GB / B650M / 32GB DDR5', '39500.00', '1761757269_20251007170823_80596_371_1.jpg', 2, '2025-10-29 17:01:09'),
(30, 1, 'NOVAMDD5-100', 'AMD RYZEN 9 9950X3D 4.3GHz 16C/32T / X870 / RTX 5090 32GB / 32GB DDR5 6400MHz / M.2 1TB / 1000W (80+GOLD) / CS360', '192990.00', '1762923607_products136899_800.jpg', 2, '2025-11-12 05:00:07'),
(31, 2, 'LENOVO LEGION PRO 7', 'Legion Pro 7 16IAX10H โน้ตบุ๊คเกมมิ่งเรือธงจาก Lenovo มาพร้อมจอ OLED 240Hz สีสดสมจริงระดับ DCI-P3 100% แรงเต็มพลังด้วย Core Ultra 9 และ RTX 5070 Ti พร้อมแรม 32GB ใช้งานหรือเล่นเกมระดับ AAA ได้ลื่นไหล ตอบโจทย์ทั้งสายเกมและสายทำงาน\r\n\r\n• ซีพียู : Intel Core Ultra 9 275HX\r\n• แรม : 32GB (16GB x 2) DDR5 6400MHz\r\n• เอสเอสดี : 1TB PCIe 4/NVMe M.2 SSD\r\n• จอแสดงผล : 16\" WQXGA (2560 x 1600) OLED 240Hz 500nits Glossy G-SYNC DCI-P3 100%\r\n• กราฟิก : Nvidia GeForce RTX 5070 Ti 12GB GDDR7\r\n• ซอฟต์แวร์ : Windows 11 Home', '100000.00', '1762923693_20250609151833_76821_287_1.jpg', 4, '2025-11-12 05:01:33'),
(32, 2, 'NOTEBOOK (โน้ตบุ๊ค) ASUS ROG STRIX G18 G815LW-S9112W - VOLT GREEN', 'ROG Strix G18 G815LW-S9112W แรงสุดด้วย Intel Core Ultra 9 และ RTX 5080 จอ 18\" 2.5K 240Hz พร้อมระบบระบายความร้อน Tri-Fans และ Dolby Vision รองรับเกม AAA ได้ลื่นไหล ภาพสวยสมจริงเต็มอรรถรส.\r\n\r\n• ซีพียู : Intel Core Ultra 9 275HX\r\n• แรม : 32GB DDR5 5600MHz SO-DIMM\r\n• เอสเอสดี : 1TB PCIe 4/NVMe M.2 SSD\r\n• จอแสดงผล : 18\" 2.5K (2560 x 1600, WQXGA) 240Hz IPS-level DCI-P3 100% G-Sync\r\n• กราฟิก : Nvidia GeForce RTX 5080 16GB GDDR7\r\n• ซอฟต์แวร์ : Windows 11 Home', '110000.00', '1762923755_20250613150405_76009_287_1.jpg', 20, '2025-11-12 05:02:35'),
(33, 3, 'GAME CONSOLE (เครื่องเล่นเกม) SONY PLAYSTATION 5 PRO', 'PS5 Pro คือรุ่นประสิทธิภาพสูงของ PlayStation 5 ที่มอบภาพคมชัดระดับเหนือชั้นและเฟรมเรตที่ลื่นไหลยิ่งขึ้น เหมาะสำหรับผู้เล่นที่ต้องการประสบการณ์เกมขั้นสุด พร้อมเทคโนโลยีเสียงรอบทิศทางและดีไซน์ล้ำสมัยที่ตอบโจทย์ทั้งการเล่นเกมในบ้านและสตรีมออนไลน์', '25890.00', '1762923831_20250814155244_79404_23_1.jpg', 10, '2025-11-12 05:03:51'),
(34, 3, 'GAMING CHAIR (เก้าอี้เกมมิ่ง) THERMALTAKE GF500 FLIGHT SIMULATOR COCKPIT - SNOW (GSC-F50-CPASWH-01)', 'Thermaltake GF500 คือค็อกพิทจำลองการบินระดับพรีเมียม วัสดุโครงเหล็ก-อะลูมิเนียมแข็งแรง เบาะไฟเบอร์กลาสปรับเอนได้ พร้อมแผ่นวางจอย ปีกยกคันเร่ง และติดตั้งระบบไฟ RGB เหมาะสำหรับนักบินจำลองผู้ต้องการความสมจริงแบบจัดเต็ม', '23000.00', '1762923877_2025061909433977737_1.jpg', 10, '2025-11-12 05:04:37'),
(35, 4, 'KEYBOARD (คีย์บอร์ด) RAZER HUNTSMAN V3 PRO TENKEYLESS (WHITE) (RAZER ANALOG OPTICAL SWITCH GEN-2 - C', '• Razer Analog Optical Switch Gen-2 (Linear)\r\n• Chroma RGB\r\n• English Keycap\r\n• ANSI\r\n• Wired (Detachable USB-C to USB-A)', '5900.00', '1762923927_2024070815181368731_1.jpg', 5, '2025-11-12 05:05:27'),
(36, 4, 'WIRELESS MOUSE (เมาส์ไร้สาย) RAZER BASILISK V3 PRO 35K - PHANTOM GREEN (RZ01-05240300-R3A1)', 'RAZER BASILISK V3 PRO 35K เมาส์เกมมิ่งไร้สายดีไซน์ตามหลักสรีรศาสตร์ มาพร้อมเซนเซอร์ความแม่นยำสูงสุด 35,000 DPI ล้อเลื่อนปรับได้หลายโหมด และไฟ RGB ปรับแต่งได้ 13 โซน รองรับการเชื่อมต่อทั้ง Razer HyperSpeed, Bluetooth และ USB เพื่อประสบการณ์เล่นเกมที่ลื่นไหลและปรับแต่งได้เต็มที่\r\n\r\n• DPI : สูงสุด 35,000\r\n• เซ็นเซอร์ : Focus Pro 35K Optical Sensor Gen-2\r\n• การเชื่อมต่อ : Razer HyperSpeed Wireless, บลูทูธ, มีสาย\r\n• ปุ่มที่ตั้งค่าได้ : 11 ปุ่ม\r\n• ความเร็วสูงสุด : 750 IPS\r\n• ไฟ : RGB', '5990.00', '1762923968_20250605085442_77294_464_1.jpg', 5, '2025-11-12 05:06:08'),
(37, 1, 'COMPUTERSET JIB ZARUKON-6811018 I7-14700K / RX9070 XT 16GB / 32GB DDR5 / M.2 1TB', '• สามารถปรับเปลี่ยนอุปกรณ์ได้ตามที่ต้องการ\r\n• ทุกเซ็ตที่กำหนด จัดส่งฟรีภายใน 4 ชั่วโมง *เฉพาะกรุงเทพฯ และปริมณฑล\r\n• อุปกรณ์คอมพิวเตอร์เสียภายใน 30 วัน นับจากวันซื้อ เปลี่ยนอุปกรณ์คอมพิวเตอร์ใหม่ให้ทันที ภายใน 24 ชั่วโมง เฉพาะซื้อผ่าน JIB Online เท่านั้น (เงื่อนไขเป็นไปตามที่กำหนด)\r\n• ผ่อนสบายๆ 0% นาน 10 เดือน ทุกเซ็ต\r\n• บริการซ่อมและตรวจเช็คอาการ ฟรี! ได้ที่เจไอบีกว่า 130 สาขา ใน 70 จังหวัด', '59900.00', '1762924009_20251110132451_81456_447_1.jpg', 1, '2025-11-12 05:06:49'),
(38, 1, 'NOVAMDD5-067', 'AMD RYZEN 7 9800X3D 4.7GHz 8C/16T / X870 / RX 9070 XT 16GB / 32GB DDR5 6400MHz / M.2 1TB / 850W (80+GOLD) / CS360', '71900.00', '1762924087_products136800_800.jpg', 1, '2025-11-12 05:08:07'),
(39, 1, 'NOVAMDD5-036', 'AMD RYZEN 7 7800X3D 4.2GHz 8C/16T / X870 / RX 9060 XT 16GB / 32GB DDR5 6000MHz / M.2 1TB / 750W (80+BRONZE) / CS360', '52990.00', '1762924119_products136707_800.jpg', 1, '2025-11-12 05:08:39'),
(40, 1, 'NOVAMDD5-020', 'AMD RYZEN 5 7500F 3.7GHz 6C/12T / A620 / RTX 5060 8GB / 32GB DDR5 5600MHz / M.2 500GB / 650W (80+BRONZE)', '25990.00', '1762924155_products136659_800.jpg', 1, '2025-11-12 05:09:15');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`customer_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`employee_id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `idx_category` (`category_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `customer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `employees`
--
ALTER TABLE `employees`
  MODIFY `employee_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=74;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE;

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
