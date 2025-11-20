-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 20, 2025 at 11:56 AM
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
(34, 'along111along', '0.00', '2025-10-30 00:39:02', 'เสร็จแล้ว'),
(35, 'undefined', '314880.00', '2025-11-20 01:10:39', 'ยกเลิก');

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
(73, 34, 29, 1, '39500.00', '0.00', 'เสร็จแล้ว'),
(74, 35, 30, 1, '192990.00', '0.00', 'ยกเลิก'),
(75, 35, 35, 1, '5900.00', '0.00', 'ยกเลิก'),
(76, 35, 36, 1, '5990.00', '0.00', 'ยกเลิก'),
(77, 35, 32, 1, '110000.00', '0.00', 'ยกเลิก');

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
(35, 3, 'KEYBOARD (คีย์บอร์ด) RAZER HUNTSMAN V3 PRO TENKEYLESS (WHITE) (RAZER ANALOG OPTICAL SWITCH GEN-2 - C', '• Razer Analog Optical Switch Gen-2 (Linear)\r\n• Chroma RGB\r\n• English Keycap\r\n• ANSI\r\n• Wired (Detachable USB-C to USB-A)', '5900.00', '1762923927_2024070815181368731_1.jpg', 5, '2025-11-12 05:05:27'),
(36, 3, 'WIRELESS MOUSE (เมาส์ไร้สาย) RAZER BASILISK V3 PRO 35K - PHANTOM GREEN (RZ01-05240300-R3A1)', 'RAZER BASILISK V3 PRO 35K เมาส์เกมมิ่งไร้สายดีไซน์ตามหลักสรีรศาสตร์ มาพร้อมเซนเซอร์ความแม่นยำสูงสุด 35,000 DPI ล้อเลื่อนปรับได้หลายโหมด และไฟ RGB ปรับแต่งได้ 13 โซน รองรับการเชื่อมต่อทั้ง Razer HyperSpeed, Bluetooth และ USB เพื่อประสบการณ์เล่นเกมที่ลื่นไหลและปรับแต่งได้เต็มที่\r\n\r\n• DPI : สูงสุด 35,000\r\n• เซ็นเซอร์ : Focus Pro 35K Optical Sensor Gen-2\r\n• การเชื่อมต่อ : Razer HyperSpeed Wireless, บลูทูธ, มีสาย\r\n• ปุ่มที่ตั้งค่าได้ : 11 ปุ่ม\r\n• ความเร็วสูงสุด : 750 IPS\r\n• ไฟ : RGB', '5990.00', '1762923968_20250605085442_77294_464_1.jpg', 5, '2025-11-12 05:06:08'),
(37, 1, 'COMPUTERSET JIB ZARUKON-6811018 I7-14700K / RX9070 XT 16GB / 32GB DDR5 / M.2 1TB', '• สามารถปรับเปลี่ยนอุปกรณ์ได้ตามที่ต้องการ\r\n• ทุกเซ็ตที่กำหนด จัดส่งฟรีภายใน 4 ชั่วโมง *เฉพาะกรุงเทพฯ และปริมณฑล\r\n• อุปกรณ์คอมพิวเตอร์เสียภายใน 30 วัน นับจากวันซื้อ เปลี่ยนอุปกรณ์คอมพิวเตอร์ใหม่ให้ทันที ภายใน 24 ชั่วโมง เฉพาะซื้อผ่าน JIB Online เท่านั้น (เงื่อนไขเป็นไปตามที่กำหนด)\r\n• ผ่อนสบายๆ 0% นาน 10 เดือน ทุกเซ็ต\r\n• บริการซ่อมและตรวจเช็คอาการ ฟรี! ได้ที่เจไอบีกว่า 130 สาขา ใน 70 จังหวัด', '59900.00', '1762924009_20251110132451_81456_447_1.jpg', 1, '2025-11-12 05:06:49'),
(38, 1, 'NOVAMDD5-067', 'AMD RYZEN 7 9800X3D 4.7GHz 8C/16T / X870 / RX 9070 XT 16GB / 32GB DDR5 6400MHz / M.2 1TB / 850W (80+GOLD) / CS360', '71900.00', '1762924087_products136800_800.jpg', 1, '2025-11-12 05:08:07'),
(39, 1, 'NOVAMDD5-036', 'AMD RYZEN 7 7800X3D 4.2GHz 8C/16T / X870 / RX 9060 XT 16GB / 32GB DDR5 6000MHz / M.2 1TB / 750W (80+BRONZE) / CS360', '52990.00', '1762924119_products136707_800.jpg', 1, '2025-11-12 05:08:39'),
(40, 1, 'NOVAMDD5-020', 'AMD RYZEN 5 7500F 3.7GHz 6C/12T / A620 / RTX 5060 8GB / 32GB DDR5 5600MHz / M.2 500GB / 650W (80+BRONZE)', '25990.00', '1762924155_products136659_800.jpg', 1, '2025-11-12 05:09:15'),
(41, 4, 'ANDA SEAT AXE-E SERIES SIZE M', 'ANDA SEAT AXE-E SERIES SIZE M(AD5-02-BB-PV) (BLACK) (6Y)', '8900.00', '1763630169_products89831_800.jpg', 10, '2025-11-20 09:16:09'),
(42, 1, 'NOVULTRA-070', 'INTEL ULTRA 9 285K 3.2GHz 24C/24T / Z890 / RTX 5090 32GB / 32GB DDR5 6400MHz / M.2 1TB / 1200W (80+PLATINUM) / CS360', '178990.00', '1763630235_products141072_800.jpg', 5, '2025-11-20 09:17:15'),
(43, 1, 'NOVULTRA-001', 'INTEL ULTRA 5 225F 3.3GHz 10C/10T / H810M / RTX 5050 8GB / 32GB DDR5 5600MHz / M.2 1TB / 600W (80+WHITE) / HS', '26990.00', '1763630272_products140892_800.jpg', 30, '2025-11-20 09:17:52'),
(44, 1, 'NOVULTRA-024', 'INTEL ULTRA 5 245KF 3.6GHz 14C/14T / Z890M / RTX 5060 TI 8GB / 32GB DDR5 6000MHz / M.2 1TB / 650W (80+BRONZE) / CS240', '40990.00', '1763630327_products140949_800.jpg', 20, '2025-11-20 09:18:47'),
(45, 1, 'NOVULTRA-025', 'INTEL ULTRA 7 265K 3.3GHz 20C/20T / Z890 / RTX 5060 TI 8GB / 32GB DDR5 6000MHz / M.2 1TB / 750W (80+BRONZE) / CS360', '47990.00', '1763630377_products140952_800.jpg', 15, '2025-11-20 09:19:37'),
(46, 1, 'NOVULTRA-020', 'INTEL ULTRA 9 285K 3.2GHz 24C/24T / Z890 / RX 9060 XT 16GB / 32GB DDR5 6000MHz / M.2 1TB / 750W (80+BRONZE) / CS360', '56990.00', '1763630453_products140940_800.jpg', 10, '2025-11-20 09:20:53'),
(47, 1, 'NOVULTRA-051', 'INTEL ULTRA 5 245KF 3.6GHz 14C/14T / Z890 / RTX 5070 TI 16GB / 32GB DDR5 6400MHz / M.2 1TB / 850W (80+GOLD) / CS240', '61990.00', '1763630526_products141021_800.jpg', 10, '2025-11-20 09:22:06'),
(48, 1, 'NOVULTRA-054', 'INTEL ULTRA 7 265K 3.3GHz 20C/20T / Z890 / RTX 5070 TI 16GB / 32GB DDR5 6400MHz / M.2 1TB / 850W (80+GOLD) / CS360', '71990.00', '1763630592_products141027_800.jpg', 10, '2025-11-20 09:23:12'),
(49, 1, 'NOVULTRA-062', 'INTEL ULTRA 9 285K 3.2GHz 24C/24T / Z890 / RTX 5080 16GB / 32GB DDR5 6400MHz / M.2 1TB / 850W (80+GOLD) / CS360', '91990.00', '1763630687_products141048_800.jpg', 5, '2025-11-20 09:24:47'),
(50, 1, 'NOVAMDD5-009', 'AMD RYZEN 5 8400F 4.2GHz 6C/12T / A620 / RX 7600 8GB / 16GB DDR5 5600MHz / M.2 500GB / 650W (80+BRONZE)', '20990.00', '1763630834_products140326_800.jpg', 50, '2025-11-20 09:27:14'),
(51, 1, 'NOVAMDD5-040', 'AMD RYZEN 7 8700F 4.1GHz 8C/16T / B650M / RTX 5060 TI 8GB / 32GB DDR5 5600MHz / M.2 500GB / 650W (80+BRONZE) / HS', '32990.00', '1763630935_products140413_800.jpg', 20, '2025-11-20 09:28:55'),
(52, 1, 'NOVAMDD5-035', 'AMD RYZEN 7 9700X 3.8GHz 8C/16T / B650M / RX 9060 XT 16GB / 32GB DDR5 6000MHz / M.2 1TB / 650W (80+SILVER) / CS240', '43990.00', '1763630992_products140398_800.jpg', 20, '2025-11-20 09:29:52'),
(53, 1, 'NOVAMDD5-046', 'AMD RYZEN 7 7800X3D 4.2GHz 8C/16T / X870 / RTX 5060 TI 8GB / 32GB DDR5 6000MHz / M.2 1TB / 750W (80+BRONZE) / CS360', '54490.00', '1763631078_products140425_800.jpg', 10, '2025-11-20 09:31:18'),
(54, 1, 'NOVAMDD5-028', 'AMD RYZEN 7 9800X3D 4.7GHz 8C/16T / X870 / RTX 5060 8GB / 32GB DDR5 6000MHz / M.2 1TB / 650W (80+SILVER) / CS360', '52990.00', '1763631125_products140380_800.jpg', 40, '2025-11-20 09:32:05'),
(55, 1, 'NOVAMDD5-048', 'AMD RYZEN 9 9950X3D 4.3GHz 16C/32T / X870 / RTX 5060 TI 8GB / 32GB DDR5 6000MHz / M.2 1TB / 750W (80+BRONZE) / CS360', '69490.00', '1763631170_products140431_800.jpg', 10, '2025-11-20 09:32:50'),
(56, 1, 'NOVAMDD5-080', 'AMD RYZEN 7 9700X 3.8GHz 8C/16T / B650M / RTX 5080 16GB / 32GB DDR5 6000MHz / M.2 1TB / 850W (80+GOLD) / CS240', '71990.00', '1763631235_products140497_800.jpg', 15, '2025-11-20 09:33:55'),
(57, 1, 'NOVAMDD5-068', 'AMD RYZEN 9 9950X3D 4.3GHz 16C/32T / X870 / RX 9070 XT 16GB / 32GB DDR5 6400MHz / M.2 1TB / 850W (80+GOLD) / CS360', '81990.00', '1763631279_products140485_800.jpg', 15, '2025-11-20 09:34:39'),
(58, 1, 'NOVAMDD5-083', 'AMD RYZEN 7 9800X3D 4.7GHz 8C/16T / X870 / RTX 5080 16GB / 32GB DDR5 6400MHz / M.2 1TB / 850W (80+GOLD) / CS360', '90990.00', '1763631355_products140506_800.jpg', 40, '2025-11-20 09:35:55'),
(59, 3, 'KEYBOARD (คีย์บอร์ด) AKKO 5087B PLUS BLACK&GOLD (AKKO CS SILVER) (EN)', 'AKKO 5087B PLUS BLACK&GOLD (AKKO CS SILVER)\r\n\r\n Model   :   Black & Gold 5087B Plus\r\n Type     : Mechanical Keyboard\r\n Structure   : Tray Mount\r\n Layout   : 80% TKL\r\n Keys Count   : 87\r\n Materials   : PBT Keycaps + ABS Frame\r\n Switches   : Akko CS Silver/Akko V3 Cream Yellow/Akko CS Jelly Pink/\r\n Switches Orientation   : North-facing\r\n Lifespan   : 50/100 Million Keystrokes\r\n Larger Key Structure   : Akko Stabilizers\r\n Legends Printing   : Double-shot\r\n Keycap Profile : ASA\r\n Connection   : Bluetooth5.1 / 2.4GHz / USB Type-C\r\n Hot Swappable   : Support\r\n N-Key Rollover   : Support\r\n Battery Capacity   : 3000mAh\r\n Response Time   : 1ms\r\n Polling Rate   : 1000Hz\r\n Interface   : USB Type-C\r\n Cable Length   : 150cm\r\n Product Weight   : Approx. 1.05KG\r\n Dimensions   : 382 x 134 x 40mm\r\n Operating Systems  :  Windows / macOS / iOS / Android\r\n\r\n \r\n\r\nPackage List:\r\n\r\n  Keyboard×1\r\n  Manual×1\r\n  Cable×1, 2.4GHz Receiver×1\r\n  Supplementary Keycaps\r\n  Keycap Puller×1\r\n  Switch Puller×1\r\n  Dust Cover×1', '3090.00', '1763631458_product29251_800.png', 20, '2025-11-20 09:37:38'),
(60, 3, 'RACING WHEEL ACCESSORIES (อุปกรณ์เสริมพวงมาลัย) MOZA RS067 CRP2 CLUTCH PEDAL', 'MOZA CRP 2 Load Cell Pedals ผลิตจากอะลูมิเนียมเกรดอากาศยาน พร้อมแป้นวางส้นเท้าคาร์บอนไฟเบอร์ เซ็นเซอร์ Load Cell 200kg และเซ็นเซอร์มุม 15-bit ให้ฟีลเบรกแม่นยำ รองรับปรับแต่งได้กว่า 1,700 แบบ ใช้งานได้ทั้ง PC และ Xbox', '3590.00', '1763631677_2025050510184176506_1.jpg', 5, '2025-11-20 09:41:17'),
(61, 3, 'RACING WHEEL CONTROLLER (คอนโทรลเลอร์พวงมาลัย) MOZA R3 BUNDLE (XBOX) (MZ-RS053)', 'Officially Licensed for Xbox \r\n3.9Nm DD Servo Motor\r\nAviation-grade Aluminum\r\nISF PU Grips\r\nFull High-Strength Steel\r\nUltra-low Torque Ripple & Groove Torque\r\nMobile App Control\r\nGame Compatibility', '12990.00', '1763631749_2024053114342367693_1.jpg', 3, '2025-11-20 09:42:29'),
(62, 3, 'MOBILE CONTROLLER (คอนโทรลเลอร์มือถือ) RAZER KISHI V3 PRO XL - BLACK', 'Razer Kishi V3 Pro จอยเกมมือถือดีไซน์พรีเมียม เชื่อมต่อผ่าน USB-C รองรับ Android และ iOS ปุ่มกดตอบสนองไว มีแอป Nexus ปรับแต่งได้ เล่นเกมมือถือเหมือนคอนโซล\r\n', '6990.00', '1763631792_20250610082648_77292_287_1.jpg', 5, '2025-11-20 09:43:12'),
(63, 3, 'MOBILE CONTROLLER (คอนโทรลเลอร์มือถือ) RAZER KISHI V3 - BLACK', 'Razer Kishi V3 จอยเกมมือถือดีไซน์พรีเมียม เชื่อมต่อผ่าน USB-C รองรับ Android และ iOS ปุ่มกดตอบสนองไว มีแอป Nexus ปรับแต่งได้ เล่นเกมมือถือเหมือนคอนโซล\r\n', '3490.00', '1763631839_20250610082517_77290_287_1.jpg', 3, '2025-11-20 09:43:59'),
(64, 3, 'RACING WHEEL CONTROLLER (คอนโทรลเลอร์พวงมาลัย) THERMALTAKE G6 DIRECT DRIVE RACING WHEEL WITH PEDALS ', 'Thermaltake G6 Direct Drive Racing Wheel มอบประสบการณ์การขับขี่ระดับมืออาชีพด้วยแรงตอบสนองสมจริงจากมอเตอร์ทรงพลัง ดีไซน์แข็งแกร่งพร้อมฐานอะลูมิเนียมและชุดแป้นเหยียบปรับระดับได้ ออกแบบเพื่อความแม่นยำและความเร็วในการควบคุมทุกเส้นทางของการแข่งขัน', '18990.00', '1763631878_2025101511353580998_1.jpg', 2, '2025-11-20 09:44:38'),
(65, 3, 'FLIGHT WHEEL ACCESSORIES (อุปกรณ์เสริมพวงมาลัยนักบิน) THRUSTMASTER TPR THRUSTMASTER PENDULAR RUDDER ', 'The TPR features Thrustmaster’s exclusive PENDUL_R technology: a unique, suspended mechanism ensuring smooth and fluid movements. In conjunction with the magnetic sensors, this guarantees perfect precision, even for minor adjustments.\r\n\r\n', '26950.00', '1763631929_2024010613470664695_1.jpg', 1, '2025-11-20 09:45:29'),
(66, 3, 'RACING WHEEL ACCESSORIES (อุปกรณ์เสริมพวงมาลัย) MOZA KS STEERING WHEEL (MZ-RS047)', 'Introducing the MOZA KS Sim Racing Steering Wheel, a brand-new offering designed specifically for GT enthusiasts. This 300mm butterfly-style GT wheel brings the thrill of the track to your fingertips. Crafted with carbon fiber-reinforced composites and TPE rubber grips, it combines durability and comfort for a superior racing experience. The programmable short-travel RGB buttons allow for personalized controls and extreme input accuracy. With hall sensor magnetic paddles featuring dual clutch functionality, gear shifts are seamless and precise. Embrace an open ecosystem with compatibility across all MOZA bases and 3rd party wheelbases via our MOZA Universal Hub Kit PC adapter. Enjoy the efficiency of the Real Racing QR system and take full control with the MOZA Pit House Control Suite.', '10590.00', '1763631976_2024060114530867707_1.jpg', 3, '2025-11-20 09:46:16'),
(67, 3, 'HANDHELD GAMING PC (เครื่องเล่นเกมพกพา) MSI CLAW 8 AI PLUS A2VM-010TH', '• Intel Core Ultra 7 258V\r\n• 32GB LPDDR5x\r\n• 1TB NVMe PCIe M.2 SSD\r\n• 8\" FHD+ (1920x1200) 120Hz IPS Touch\r\n• Intel Arc Graphics (Integrated)\r\n• Windows 11 Home', '32990.00', '1763632098_2025021409054274407_1.jpg', 5, '2025-11-20 09:48:18'),
(68, 3, 'GAMING STATION (เกมมิ่งสเตชั่น) COOLER MASTER ORB-X (WHITE) (IXS-OX-1WKBS-NN-EU1) (สินค้าต้องประกอบก', 'FULLY IMMERSIVE MULTI-PURPOSE STATION FOR GAMERS AND PROFESSIONALS\r\nStay relaxed or focused in this semi-enclosed station which brings you a whole new level of immersion, comfort, and luxury.', '990000.00', '1763632143_2023111709283363678_1.jpg', 1, '2025-11-20 09:49:03'),
(69, 3, 'FLIGHT WHEEL CONTROLLER (คอนโทรลเลอร์พวงมาลัยนักบิน) THRUSTMASTER TCA YOKE PACK BOEING ED. XBOX (TCA', 'TCA Yoke Pack Boeing Edition is an aviation system officially licensed by both Boeing and Xbox, for Xbox One and Xbox Series X|S. It is also compatible with PC.\r\nTCA Boeing Edition, Thrustmaster’s new flagship civil aviation range, is a line of products allowing for cutting-edge new features with a highly-specific goal in mind: replicating the different controls, flight kinematics and sensations experienced by real Boeing pilots at the controls of a 787 airliner.\r\n\r\n', '24900.00', '1763632197_2024010611310664688_1.jpg', 1, '2025-11-20 09:49:57'),
(70, 3, 'WIRELESS CONTROLLER (คอนโทรลเลอร์ไร้สาย) SONY DUALSENSE - WHITE (CFI-ZCT1G)', 'คอนโทรลเลอร์ไร้สาย DualSense มอบประสบการณ์เกมที่สมจริงยิ่งขึ้น ด้วยระบบสั่นแบบ Haptic Feedback และทริกเกอร์ปรับแรงต้านได้ ออกแบบใหม่เพื่อการควบคุมที่แม่นยำบน PS5\r\n\r\n• PS5\r\n• Windows PC / Mac / Android / iOS', '2590.00', '1763632237_2024052113294867399_1.jpg', 50, '2025-11-20 09:50:37'),
(71, 4, 'GAMING DESK (โต๊ะเกมมิ่ง) ERGOPIXEL ALTURA VALORE ADJUSTABLE 140x60 (GD0008) (WHITE) (ASSEMBLY REQUI', '• ขนาดโต๊ะ 140 x 60 ซม.\r\n• ความสูง ต่ำ-สูง 72 - 1117 ซม.\r\n• มอเตอร์เดี่ยว\r\n• รองรับน้ำหนัก 80 กก.', '8900.00', '1763632282_2023071010180960765_1.jpg', 20, '2025-11-20 09:51:22'),
(72, 3, 'WIRELESS CONTROLLER (คอนโทรลเลอร์ไร้สาย) SONY DUALSENSE - CHROMA INDIGO (CFI-ZCT1G 11)', 'คอนโทรลเลอร์ไร้สาย DualSense มอบประสบการณ์เกมที่สมจริงยิ่งขึ้น ด้วยระบบสั่นแบบ Haptic Feedback และทริกเกอร์ปรับแรงต้านได้ ออกแบบใหม่เพื่อการควบคุมที่แม่นยำบน PS5\r\n\r\n• PS5\r\n• Windows PC / Mac / Android / iOS', '2690.00', '1763632323_2024110509164571872_1.jpg', 20, '2025-11-20 09:52:03'),
(73, 2, 'NOTEBOOK (โน้ตบุ๊ค) MSI TITAN 18 HX DRAGON EDITION NORSE MYTH A2XWJG-286TH - CORE BLACK', 'MSI’s Titan 18 HX Dragon Edition Norse Myth เปลี่ยนแปลงมาตรฐานของแล็ปท็อปเกมมิ่งด้วยการขับเคลื่อนด้วยโปรเซสเซอร์ Intel Core Ultra 9 รุ่นล่าสุด 285HX และ GPU สำหรับแล็ปท็อป NVIDIA GeForce RTX 5090 ถึงระดับสูงสุด สัตว์ประหลาดรุ่นลิมิเต็ดนี้มอบประสิทธิภาพที่ไม่มีใครเทียบได้ พร้อมดีไซน์ที่ได้รับแรงบันดาลใจจากตำนานเทพเจ้านอร์สอย่างน่าทึ่ง ด้วยลวดลายแกะสลักละเอียดอ่อนและแผ่นจารึกวิญญาณมังกร มันไม่ใช่แค่แล็ปท็อประสิทธิภาพสูง แต่ยังเป็นผลงานชิ้นเอกสำหรับสะสมอย่างแท้จริง สร้างขึ้นสำหรับผู้ที่ต้องการพลังในตำนานและความทนทานที่โดดเด่น Titan นี้พร้อมที่จะพิชิตทุกความท้าทายในฐานะแหล่งพลังเกมมิ่งที่ดีที่สุดของคุณ\r\n\r\n• ซีพียู : Intel Core Ultra 9 285HX\r\n• แรม : 96GB DDR5-6400\r\n• เอสเอสดี : 2TB NVMe PCIe Gen5x4 SSD w/o DRAM + 2TB NVMe PCIe Gen4x4 SSD x2\r\n• จอแสดงผล : 18\" UHD+ (3840 x 2400) MiniLED 120Hz IPS\r\n• กราฟิก : Nvidia GeForce RTX 5090 Laptop 24GB GDDR7\r\n• ซอฟต์แวร์ : Windows 11 Home / Office Home & Student 2024', '245990.00', '1763632436_2025022414450074619_1.jpg', 2, '2025-11-20 09:53:56'),
(74, 2, 'NOTEBOOK (โน้ตบุ๊ค) MSI TITAN 18 HX AI A2XWIG-080TH - CORE BLACK', 'MSI TITAN 18 HX AI ยืนหยัดอย่างภาคภูมิในฐานะผู้นำด้านนวัตกรรมเกมมิ่ง Titan 18 HX AI ก้าวข้ามขีดจำกัดของประสิทธิภาพไปอีกขั้น ด้วยฟีเจอร์ระดับท็อปที่ครบครัน ระบบระบายความร้อนอันล้ำสมัยมอบพลังที่เหนือชั้น ช่วยให้การทำงานราบรื่นแม้ในภารกิจที่หนักหน่วงที่สุด ตัวเครื่องผลิตจากแมกนีเซียม-อะลูมิเนียมอัลลอยที่แข็งแกร่งแต่มีน้ำหนักเบา ผสานความทนทานเข้ากับความสะดวกในการพกพา จึงเป็นตัวเลือกอันดับหนึ่งสำหรับเกมเมอร์และครีเอเตอร์ที่มุ่งมั่นสู่ความเป็นเลิศ\r\n\r\n• ซีพียู : Intel Core Ultra 9 285HX\r\n• แรม : 64GB DDR5-6400\r\n• เอสเอสดี : 2TB NVMe PCIe Gen5x4 SSD w/o DRAM + 2TB NVMe PCIe Gen4x4 SSD x2\r\n• จอแสดงผล : 18\" UHD+ (3840 x 2400) MiniLED 120Hz IPS\r\n• กราฟิก : Nvidia GeForce RTX 5080 Laptop 16GB GDDR7\r\n• ซอฟต์แวร์ : Windows 11 Home / Office Home & Student 2024', '179990.00', '1763632516_20251015152039_74625_287_1.jpg', 5, '2025-11-20 09:55:16'),
(75, 2, 'NOTEBOOK (โน้ตบุ๊ค) LENOVO LEGION 9 18IAX10 83EY002STA - ECLIPSE BLACK', 'Lenovo Legion 9 18IAX10 ขุมพลังเกมมิ่งตัวจริง มาพร้อม Intel Core Ultra 9 275HX แบบ 24 คอร์ ความเร็วสูงสุด 5.4GHz จับคู่ RAM 64GB DDR5 และ SSD 2TB PCIe 5.0 ความเร็วเหนือชั้น กราฟิก RTX 5090 24GB GDDR7 แรงสุดขีด รองรับงาน AI 1824 TOPS เล่นเกมและทำงานหนักได้อย่างไร้ข้อจำกัด\r\n\r\n• ซีพียู : Intel Core Ultra 9 275HX\r\n• แรม : 64GB (32GBx2) SO-DIMM DDR5 5200MHz\r\n• เอสเอสดี : 2TB PCIe 5/NVMe M.2 SSD\r\n• จอแสดงผล : 18\" WQUXGA (3840x2400) IPS 240Hz / 440Hz G-SYNC\r\n• กราฟิก : Nvidia GeForce RTX 5090 24GB GDDR7\r\n• ซอฟต์แวร์ : Windows 11 Home', '169990.00', '1763632558_2025100113342680661_1.jpg', 5, '2025-11-20 09:55:58'),
(76, 2, 'NOTEBOOK (โน้ตบุ๊ค) ACER PREDATOR HELIOS 18 AI PH18-73-98NZ - ABYSSAL BLACK', 'Predator Helios 18 AI แล็ปท็อปเกมมิ่งระดับเรือธงจาก Acer ที่มาพร้อมดีไซน์ทรงพลัง และการผสานเทคโนโลยี AI เพื่อยกระดับประสบการณ์การเล่นเกม รองรับการใช้งานหนักได้อย่างลื่นไหล เหมาะสำหรับเกมเมอร์ที่ต้องการประสิทธิภาพสูงสุดในทุกด้าน\r\n\r\n• ซีพียู : Intel Core Ultra 9 275HX\r\n• แรม : 64GB DDR5\r\n• เอสเอสดี : 2TB PCIe/NVMe M.2 SSD\r\n• จอแสดงผล : 18\" WQUXGA (3840x2400) IPS\r\n• กราฟิก : Nvidia GeForce RTX5090 24GB GDDR7\r\n• ซอฟต์แวร์ : Windows 11 Home', '159900.00', '1763632613_20250926153629_79147_287_1.jpg', 5, '2025-11-20 09:56:53'),
(77, 2, 'NOTEBOOK (โน้ตบุ๊ค) GIGABYTE AORUS MASTER 16 AM6H-BYHC5THE64SH - DARK TIDE', '• ซีพียู : Intel Core Ultra 9 275HX\r\n• แรม : 32GB DDR5-5600\r\n• เอสเอสดี : 1TB PCIe 4/NVMe M.2 SSD\r\n• จอแสดงผล : 16\" QHD+ (2560 x 1600) 240Hz OLED\r\n• กราฟิก : Nvidia GeForce RTX 5080 16GB GDDR7\r\n• ซอฟต์แวร์ : Windows 11 Home', '99990.00', '1763632690_20251007154125_74640_287_1.jpg', 5, '2025-11-20 09:58:10'),
(78, 2, 'NOTEBOOK (โน้ตบุ๊ค) ALIENWARE M16 R2-CANM162CTO01GTH (DARK METALLIC MOON)', '• Intel Core Ultra 7 155H\r\n• 32GB (16GBx2) DDR5 5600MT/s\r\n• 1TB PCIe/NVMe M.2 SSD\r\n• 16\" QHD+ 240Hz\r\n• Nvidia GeForce RTX 4060 8GB GDDR6\r\n• Windows 11 Home + Office Home & Student 2021', '87990.00', '1763632732_20240514142821_67204_287_1.jpg', 5, '2025-11-20 09:58:52'),
(79, 2, 'NOTEBOOK (โน้ตบุ๊ค) HP OMEN MAX 16-AK0000AX', 'HP OMEN MAX 16 เป็นโน้ตบุ๊กเกมมิ่งพรีเมียม ดีไซน์เรียบหรู มีจอภาพสุดคม เหมาะสำหรับเกมเมอร์และครีเอเตอร์ แต่ค่อนข้างหนัก แบตได้น้อย และเครื่องร้อนเมื่อใช้งานหนัก\r\n\r\n• ซีพียู : AMD Ryzen AI 9 HX 375\r\n• แรม : 32GB DDR5\r\n• เอสเอสดี : 1TB PCIe 4/NVMe M.2 SSD\r\n• จอแสดงผล : 16\" WQXGA (2560x1600) IPS 240Hz\r\n• กราฟิก : Nvidia GeForce RTX5080 16GB GDDR7\r\n• ซอฟต์แวร์ : Windows 11 Home', '99990.00', '1763632768_20250617145454_77576_287_1.jpg', 5, '2025-11-20 09:59:28'),
(80, 2, 'NOTEBOOK (โน้ตบุ๊ค) MSI STEALTH A16 MERCEDES AMG AI PLUS A3XWGG-029TH - SELENITE GRAY', 'MSI Stealth A16 AI Plus Mercedes-AMG Motorsport แล็ปท็อปที่ผสานพลังเกมมิ่งเข้ากับเอกลักษณ์ของมอเตอร์สปอร์ต ดีไซน์พรีเมียมสะท้อนความหรูหราและความเร็ว มาพร้อมฟีเจอร์ที่ตอบโจทย์ทั้งประสิทธิภาพและสไตล์ เหมาะสำหรับผู้ที่ต้องการโน้ตบุ๊กทรงพลังและโดดเด่นไม่เหมือนใคร\r\n\r\n• ซีพียู : AMD Ryzen AI 9 HX 370\r\n• แรม : 32GB DDR5\r\n• เอสเอสดี : 2TB PCIe 4/NVMe M.2 SSD\r\n• จอแสดงผล : 16\" QHD+ (2560x1600) OLED 240Hz\r\n• กราฟิก : Nvidia GeForce RTX5070 8GB GDDR7\r\n• ซอฟต์แวร์ : Windows 11 Home / Office Home & Student 2024', '89990.00', '1763632803_20250808151517_78957_287_1.jpg', 5, '2025-11-20 10:00:03'),
(81, 2, 'NOTEBOOK (โน้ตบุ๊ค) ALIENWARE 16 AURORA OAC16250I901 - INTERSTELLAR INDIGO', 'Alienware 16 Aurora รุ่นนี้มาพร้อม Intel Core 9 270H และการ์ดจอ RTX 5070 แรงจัดเต็ม พร้อม RAM 32GB และ SSD 1TB เล่นเกม ทำงานกราฟิก หรือเรนเดอร์หนัก ๆ ได้สบาย จอ QHD+ สีสันแม่นยำ 100% sRGB ดีไซน์ Interstellar Indigo ล้ำอนาคต โดดเด่นทุกมุมมอง\r\n\r\n• ซีพียู : Intel Core 9 270H\r\n• แรม : 32GB (16GB x 2) DDR5 5600MT/s\r\n• เอสเอสดี : 1TB PCIe/NVMe M.2 SSD\r\n• จอแสดงผล : 16\" QHD+ (2560 x 1600) 120Hz 300nits ComfortView Plus sRGB 100%\r\n• กราฟิก : Nvidia GeForce RTX 5070 8 GB GDDR7\r\n• ซอฟต์แวร์ : Windows 11 Home / Office Home 2024 / Microsoft 365 Basic', '85900.00', '1763632837_2025080710485879218_1.jpg', 5, '2025-11-20 10:00:37'),
(82, 2, 'NOTEBOOK (โน้ตบุ๊ค) ACER PREDATOR HELIOS NEO 16S AI PHN16S-71-95J9 - ABYSSAL BLACK', 'Predator Helios Neo 16S AI คือแล็ปท็อปเกมมิ่งที่รวมความแรง ดีไซน์ดุดัน และเทคโนโลยี AI เข้าไว้ด้วยกัน เหมาะกับคนที่ต้องการเล่นเกม ทำงานกราฟิก หรือสตรีมแบบลื่นไหลในเครื่องเดียว พร้อมพกพาไปได้ทุกที่\r\n\r\n• ซีพียู : Intel Core Ultra 9 275HX\r\n• แรม : 32GB DDR5\r\n• เอสเอสดี : 1TB PCIe 4/NVMe M.2 SSD\r\n• จอแสดงผล : 16\" WQXGA (2560x1600) OLED 240Hz\r\n• กราฟิก : Nvidia GeForce RTX5070Ti 12GB GDDR7\r\n• ซอฟต์แวร์ : Windows 11 Home', '75990.00', '1763632869_2025070308563378206_1.jpg', 10, '2025-11-20 10:01:09'),
(83, 3, 'LED WALL (แอลอีดีวอลล์) ICONN INDOOR LED ISJ-390B - 5X3M', 'ICONN ISJ-390B คือจอ LED แสดงผลในร่มที่ออกแบบมาเพื่องานระดับมืออาชีพ ด้วยดีไซน์เต็มสี ความละเอียดสูง และมุมมองกว้าง มอบภาพคมชัด สีสันสดใส และประสบการณ์รับชมที่ราบรื่น เหมาะสำหรับงานประชุม นิทรรศการ และการติดตั้งในพื้นที่ที่ต้องการความโดดเด่น', '428000.00', '1763632974_2025090214333779942_1.jpg', 1, '2025-11-20 10:02:54'),
(84, 3, 'MONITOR (จอมอนิเตอร์) EIZO RADIFORCE RX370 21.3 INCH (1536 x 2048) 3:4 60Hz IPS (BLACK)', '• Panel Size : 21.3\"\r\n• Panel Type : IPS\r\n• Maximum Resolution : 1536 x 2048\r\n• Response Time : 25 ms', '205500.00', '1763633035_2024051713473967344_1.jpg', 10, '2025-11-20 10:03:55'),
(85, 3, 'MONITOR(จอมอนิเตอร์) LENOVO THINKVISION P49W-30 - 49 INCH ULTRA WIDE IPS DQHD 60Hz (63D1RAR1WW)', 'ThinkVision P49w-30 Monitor จอโค้งไซส์ใหญ่ 49 นิ้ว ความละเอียด Dual QHD (5120 x 1440) พร้อมอัตราส่วน 32:9 ให้พื้นที่ทำงานกว้างจุใจ เหมาะกับสายมัลติทาสก์และสายครีเอทีฟ สีสดคมชัดด้วย 98% DCI-P3 และ Delta E<2 มาพร้อมพอร์ตครบถึง 13 ช่อง รวม Thunderbolt 4, Ethernet และลำโพง 5W คู่ ใช้งานพร้อมกัน 2 เครื่องผ่านฟีเจอร์ True Split และสลับคอมง่ายด้วย eKVM ครบเครื่องเรื่องการทำงานในจอเดียว\r\n\r\n• ขนาดจอ : 49 นิ้ว\r\n• ประเภทจอ : IPS\r\n• ความละเอียด : 5120 x 1440\r\n• รีเฟรชเรต : 60Hz\r\n• การตอบสนอง : 4ms\r\n• การรองรับสี : 1.07 พันล้านสี\r\n• การเชื่อมต่อ : 2x HDMI 2.1, 1x DP 1.4, 1x Thunderbolt 4 in, 1x Thunderbolt 4 out\r\n• การติดตั้งบนผนัง : รองรับ VESA mount ขนาด 100 x 100 มม. และ 200 x 100 มม.', '45900.00', '1763633084_2025040813172575892_1.jpg', 1, '2025-11-20 10:04:44'),
(86, 3, 'MONITOR (จอมอนิเตอร์) ASUS PROART DISPLAY 6K PA32QCV - 31.5 INCH IPS 6K 60Hz THUNDERBOLT 4', 'Asus ProArt Display 6K PA32QCV มอนิเตอร์ระดับโปร 31.5 นิ้ว ความละเอียด 6K รองรับมาตรฐานสีระดับสากล DCI-P3 98% และ sRGB 100% คาลิเบรตจากโรงงานเพื่อความแม่นยำ Delta E<2 มาพร้อมพอร์ต Thunderbolt 4, HDMI 2.1, DisplayPort และ USB Hub มีฟีเจอร์ Auto KVM, DisplayWidget และการออกแบบที่ปรับได้ตามสรีระ\r\n\r\n• ขนาดจอ : 31.5 นิ้ว\r\n• ประเภทจอ : IPS ป้องกันแสงสะท้อน\r\n• ความละเอียด : 6016 x 3384\r\n• รีเฟรชเรท : 60Hz\r\n• การตอบสนอง : 5ms\r\n• การรองรับสี : 1.07 พันล้านสี\r\n• การเชื่อมต่อ : 1 x HDMI, 1 x DP, 2 x USB-C (PD 96W), 2 x Thunderbolt 4\r\n• เทคโนโลยีการซิงค์ : Adaptive Sync\r\n• เทคโนโลยี : KVM\r\n• การปรับตั้ง : ปรับได้ทั้งความสูง, หมุนแนวตั้ง, หมุนซ้าย-ขวา, และเอียง\r\n• การติดตั้งบนผนัง : VESA ขนาด 100 x 100 มม.', '45250.00', '1763633116_20250918143450_80185_287_1.jpg', 5, '2025-11-20 10:05:16'),
(87, 3, 'MONITOR (จอมอนิเตอร์) DELL UP3216Q 32 INCH IPS 60Hz (BLACK)', 'Size : 32\"\r\nBrightness : 300 cd/m²\r\nContrast : 1000 : 1\r\nResponse Time : 6 ms', '42900.00', '1763633177_20231116150112_40062_344_1.jpg', 100, '2025-11-20 10:06:17'),
(88, 3, 'Monitor (จอมอนิเตอร์) Asus Rog Swift Oled Pg27Aqdp - 26.5 Inch Oled 2K 480Hz Amd Freesync Premium G-', 'ROG Swift OLED PG27AQDP จอเกมมิ่ง WOLED ขนาด 26.5 นิ้ว ความละเอียด QHD รีเฟรชเรตสูงสุด 480Hz พร้อมเวลาตอบสนองเพียง 0.03ms มาพร้อม ASUS OLED Care+ ป้องกัน Burn-in, AI Assistant ฟีเจอร์ช่วยเล่นเกมอัจฉริยะ, เทคโนโลยีลดภาพสั่นไหว และรองรับ HDR400 True Black\r\n\r\n• ขนาดจอ : 26.5 นิ้ว\r\n• ประเภทจอ : OLED ป้องกันแสงสะท้อน\r\n• ความละเอียด : 2560 x 1440\r\n• รีเฟรชเรท : 480Hz\r\n• การตอบสนอง : 0.03ms\r\n• การรองรับสี : 1.07 พันล้านสี\r\n• การเชื่อมต่อ : 2 x HDMI, 1 x DP\r\n• เทคโนโลยีการซิงค์ : AMD FreeSync Premium, G-Sync Compatible\r\n• การปรับตั้ง : ปรับได้ทั้งความสูง, หมุนแนวตั้ง, หมุนซ้าย-ขวา, และเอียง\r\n• การติดตั้งบนผนัง : VESA ขนาด 100 x 100 มม.', '39900.00', '1763633223_20250814155649_77427_287_1.jpg', 10, '2025-11-20 10:07:03'),
(89, 3, 'Monitor (จอมอนิเตอร์) Benq Zowie Xl2586X Plus - 24.1 Inch Tn 600Hz Dyac', '• 24.1\"\r\n• TN panel Anti-glare\r\n• 1920 x 1080 600Hz\r\n• 1.07 billion colors\r\n• 3 x HDMI\r\n• 1 x DP\r\n• Height, Swivel, Tilt adjustable\r\n• VESA mount 100 x 100 mm', '38590.00', '1763633268_20250218162600_74380_287_1.jpg', 10, '2025-11-20 10:07:48'),
(90, 3, 'Monitor (จอมอนิเตอร์) Eizo Ev2785-Wt 27 Inch Ips', '• Panel Size : 27\"\r\n• Panel Type : IPS\r\n• Maximum Resolution : 3840 x 2160\r\n• Refresh Rate : 60 Hz\r\n• Response Time : 5 ms', '37900.00', '1763633302_20220518134801_50612_363_1.jpg', 10, '2025-11-20 10:08:22'),
(91, 4, 'WACOM (แท็บเล็ตปากกาพร้อมหน้าจอสำหรับวาดภาพกราฟฟิก) CINTIP PRO 27 (DTH271K0C)', '• ปากกา : Wacom Pro Pen 3\r\n• อัตราส่วนความคอนทราสต์ : 1000 : 1\r\n• ความสว่าง 400 cd/m2\r\n• ความละเอียดหน้าจอแสดงผล : 3840 x 2160 พิกเซล', '132000.00', '1763633433_2023040715183658884_1.jpg', 10, '2025-11-20 10:10:33'),
(92, 4, 'GRAPHIC TABLET (กระดานกราฟิก) WACOM CINTIQ 24 (DTK246K0C)', 'Wacom Cintiq 24 มาพร้อมจอ IPS ขนาด 23.8 นิ้ว ความละเอียด 2K (2560×1440) สีตรง sRGB 100% ความสว่าง 350cd/m² และคอนทราสต์ 1000:1 ใช้คู่กับ Pro Pen 3 รองรับแรงกด 8192 ระดับและเอียงได้ 60° เหมาะสำหรับงานออกแบบมืออาชีพ\r\n\r\n• หน้าจอ IPS ขนาดใหญ่ 23.8 นิ้ว ความละเอียด 2K (2560 × 1440)\r\n• รองรับ sRGB 100% สีสันแม่นยำสำหรับงานสร้างสรรค์\r\n• ความสว่าง 350 cd/m² และคอนทราสต์ 1000:1 มุมมองกว้าง 178°\r\n• มาพร้อมปากกา Wacom Pro Pen 3 แรงกด 8192 ระดับ รองรับเอียง 60°\r\n• ฟังก์ชันเสริม: Precision Mode, Radial Menu, On-Screen Controls\r\n• รองรับการเชื่อมต่อ USB-C และ HDMI พร้อม VESA Mount 75×75', '49900.00', '1763633484_2025091614354480218_1.jpg', 10, '2025-11-20 10:11:24'),
(93, 4, 'GRAPHIC TABLET (กระดานกราฟิก) WACOM INTUOS PRO L - BLACK (PTK870K0C)', 'Wacom Intuos Pro L แท็บเล็ตวาดภาพระดับมืออาชีพ มาพร้อม Pro Pen 3 ที่ปรับน้ำหนักและปุ่มได้ตามต้องการ ให้ความแม่นยำสูงสุด ตัวเครื่องบางเพียง 4 มม. ทำจากแมกนีเซียม แข็งแรงแต่พกพาง่าย มีปุ่ม ExpressKeys และ Dial ใช้งานสะดวก รองรับการเชื่อมต่อผ่าน Bluetooth และรองรับปากการุ่นเก่า\r\n\r\n• Pro Pen 3 รองรับแรงกด 8,192 ระดับ, รองรับการเอียง, ตอบสนองไว ปรับจับถนัดมือได้หลายแบบ\r\n• ExpressKeys 10 ปุ่ม และ Dial 2 ตัว ปรับแต่งได้ อยู่ใกล้คีย์บอร์ด เพิ่มความสะดวกในการใช้งาน\r\n• ขนาดใหญ่แต่กะทัดรัด (พื้นที่ใช้งาน 14.8 x 9.9 นิ้ว) อัตราส่วน 16:9 เหมาะกับจอหลายจอ\r\n• บางเพียง 4 มม. ให้สัมผัสเหมือนเขียนบนกระดาษ ตัวเครื่องทำจากแมกนีเซียม แข็งแรงและพกพาสะดวก\r\n• เชื่อมต่อได้ทั้ง USB และ Bluetooth ใช้งานกับพีซีหรือแมคได้หลายเครื่องผ่านปุ่มสลับง่าย ๆ', '19900.00', '1763633522_2025070314434378225_1.jpg', 10, '2025-11-20 10:12:02'),
(94, 4, 'MACROPAD (มาโครแพด) COOLER MASTER MASTERHUB STREAM KIT - BLACK (MHSK13AA00)', 'MasterHUB Stream Kit ชุดควบคุมแบบโมดูลาร์ระดับมืออาชีพ ที่ออกแบบมาเพื่อเพิ่มประสิทธิภาพการทำงานและความคิดสร้างสรรค์ รองรับการใช้งานหลากหลายไม่ว่าจะเป็น สตรีมมิ่ง การตัดต่อ หรือการเล่นเกม MasterHUB มอบพลังการควบคุมที่แม่นยำ ใช้งานง่าย และช่วยยกระดับประสิทธิภาพไปอีกขั้น เปิดประสบการณ์ใหม่ในการทำงานและความคิดสร้างสรรค์อย่างไร้ขีดจำกัด\r\n\r\n• มาพร้อม Base ที่รองรับการเชื่อมต่อครบครัน\r\n• หน้าจอ IPS 15 ปุ่ม สำหรับควบคุมแอปแบบอินเตอร์แอคทีฟ\r\n• ฟังก์ชัน 5xFader ช่วยปรับแต่งการทำงานได้อย่างแม่นยำ\r\n• โมดูล 2xRoller ใช้งานสะดวก ราบรื่นทุกการควบคุม\r\n• ออกแบบให้ปรับแต่งได้อิสระตามความต้องการของผู้ใช้', '12900.00', '1763633557_2025091108475680133_1.jpg', 10, '2025-11-20 10:12:37'),
(95, 3, 'WIRELESS KEYBOARD (คีย์บอร์ดไร้สาย) STEELSERIES APEX PRO TKL WIRELESS GEN 3 (BLACK) (OMNIPOINT 3.0 S', '• OmniPoint 3.0 Switch (Linear)\r\n• RGB\r\n• English Keycap\r\n• ANSI\r\n• OLED Display\r\n• Wired (Detachable USB-C to USB-A)\r\n• 2.4GHz Wireless\r\n• Bluetooth\r\n', '12490.00', '1763633591_2024102413224271538_1.jpg', 10, '2025-11-20 10:13:11'),
(96, 3, 'KEYBOARD (คีย์บอร์ด) GLORIOUS GMMK 3 PRO HE PREBUILT (75%) (BLACK) (GLORIOUS FOX HE SWITCH RGB EN)', '• Glorious Fox HE Switch (Linear)\r\n• RGB\r\n• English Keycap\r\n• ANSI\r\n• Wired (Detachable USB-C to USB-A)\r\n• CNC Aluminum Case', '13900.00', '1763633630_2024120417263072648_1.jpg', 10, '2025-11-20 10:13:50'),
(97, 3, 'KEYBOARD (คีย์บอร์ด) GLORIOUS GMMK PRO PRE-BUILT (BLACK SLATE) (GLORIOUS FOX SWITCH) (RGB LED) (EN)', '• Glorious Fox Switch (Linear)\r\n• RGB LED\r\n• English Legend (Font)\r\n• USB 2.0', '10900.00', '1763633685_20220316131926_52116_66_1.jpg', 10, '2025-11-20 10:14:45'),
(98, 3, 'KEYBOARD (คีย์บอร์ด) STEELSERIES APEX PRO GEN 3 (BLACK) (OMNIPOINT 3.0 SWITCH RGB EN)', '• OmniPoint 3.0 Switch (Magnetic, Hall Effect, Linear)\r\n• RGB\r\n• English Keycap\r\n• ANSI\r\n• OLED Smart Display\r\n• Wired (Detachable USB-C to USB-A)', '10290.00', '1763633757_2024120909430972732_1.jpg', 10, '2025-11-20 10:15:57'),
(99, 3, 'KEYBOARD (คีย์บอร์ด) GRAVASTAR MERCURY V75 PRO MAGNETIC SWITCH RGB EN - NEON GRAFFITI', 'Gravastar Mercury V75 Pro คีย์บอร์ดเกมมิ่งระดับมือโปร มาพร้อมอัตราการตอบสนอง 8,000Hz และระบบสแกนคีย์ 256kHz ลดค่าหน่วงเหลือเพียง 0.125ms ปรับระดับการกดได้ตั้งแต่ 0.1–3.5 มม. รองรับ Dynamic Rapid Trigger และระบบ LKP เพื่อการตอบสนองที่แม่นยำ ตัวเครื่องแบบกึ่งอะลูมิเนียม แข็งแรงและน้ำหนักเบา รองรับ Hot-Swap สำหรับสวิตช์แม่เหล็ก Hall Effect พร้อมโฟมซับเสียง 5 ชั้น และไฟ RGB 16 โหมดแบบแยกโซน ปรับแต่งได้เต็มรูปแบบ\r\n\r\n• สวิตช์ : Magnetic switch (linear)\r\n• ขนาด : 75%\r\n• แสงไฟ : RGB\r\n• คีย์แคป : ภาษาอังกฤษ\r\n• เลย์เอาต์ : ANSI\r\n• การเชื่อมต่อ : แบบใช้สาย\r\n• สายเคเบิล : สาย USB-C เป็น USB-A\r\n• การเปลี่ยนสวิตช์ : เปลี่ยนสวิตช์ได้', '8590.00', '1763633799_2025082214081079172_1.jpg', 10, '2025-11-20 10:16:39'),
(100, 3, 'WIRELESS KEYBOARD (คีย์บอร์ดไร้สาย) KEYCHRON Q1 MAX (QMK/VIA) (CARBON BLACK) (GATERON JUPITER BROWN ', '• Gateron Jupiter Brown Switch (Tactile)\r\n• QMK / VIA\r\n• RGB\r\n• English / Thai Keycap\r\n• ANSI\r\n• Wired (Detachable USB-C to USB-C with USB-A Adapter)\r\n• 2.4GHz Wireless (USB Receiver Included)\r\n• Bluetooth 5.1\r\n• Hot Swappable (3 or 5 pin)', '7190.00', '1763633845_2024041215143266737_1.jpg', 10, '2025-11-20 10:17:25'),
(101, 3, 'MOUSE (เมาส์) CORSAIR M75 WIRELESS CALL OF DUTY BLACK OPS 6 (CH-931D11D-NA) (2Y)', 'Brand	CORSAIR\r\nTilt scroll function	N/A\r\nClick life span	100 MILLION\r\nScroll Whell	Yes\r\nNumber of buttons	5 buttons\r\nBattery Life	105 hours Bluetooth : Up to 210hrs\r\nBattery Type	N/A\r\nInterface	2.4GHz Wireless\r\nSensor Resolution	26,000 DPI\r\nSensor technology	MARKSMAN 26K\r\nWireless technology	2.4GHz Wireless Techology\r\nColor	BLACK\r\nWarranty	2 Years', '5990.00', '1763634054_products77590_800.jpg', 10, '2025-11-20 10:20:54'),
(102, 3, 'MOUSE (เมาส์) LOGITECH G PRO-X SUPERLIGHT 2 DEX (WHITE) (2Y)', 'Brand	LOGITECH\r\nTilt scroll function	N/A\r\nClick life span	N/A\r\nScroll Whell	Yes\r\nNumber of buttons	5 buttons\r\nBattery Life	95 hours\r\nBattery Type	N/A\r\nInterface	WIRELESS\r\nSensor Resolution	100 – 44,000 DPI\r\nSensor technology	HERO 2\r\nWireless technology	LIGHTSPEED WIRELESS\r\nDimensions	125.8 x 67.7 x 43.9 mm\r\nColor	WHITE\r\nWarranty	2 Years', '4990.00', '1763634102_products58345_800.jpg', 10, '2025-11-20 10:21:42'),
(103, 3, 'MOUSE (เมาส์) CORSAIR SCIMITAR ELITE WIRELESS SE (CH-9314014-AP) (2Y)', 'Brand	CORSAIR\r\nTilt scroll function	N/A\r\nClick life span	100 MILLION\r\nScroll Whell	Yes\r\nMacro Keys	Yes\r\nNumber of buttons	16 buttons\r\nBattery Life	Up to 150 hours via 2.4 GHz with RGB off, up to 500 hours via Bluetooth® with RGB off\r\nBattery Type	Built-in lithium-polymer\r\nInterface	Wireless / Bluetooth / Wired\r\nSensor Resolution	33000 DPI\r\nSensor technology	MARKSMAN S 33k\r\nWireless technology	\r\nWireless 2.4G\r\nBLUETOOTH 4.2\r\nDimensions	119.23 x 73.48 x 42.17 mm\r\nColor	Gun Metal\r\nOption	N/A\r\nWeight	161 g\r\nWarranty	2 Years', '4990.00', '1763634141_products129836_800.jpg', 10, '2025-11-20 10:22:21'),
(104, 3, 'MOUSE (เมาส์) STEELSERIES AEROX 3 WIRELESS CS2 (DRAGON LORE EDITION) (2Y)', 'Brand	STEELSERIES\r\nClick life span	80 MILLION\r\nScroll Whell	Yes\r\nMacro Keys	6 buttons\r\nNumber of buttons	6 buttons\r\nBattery Life	\r\nUp to 80 hours 2.4GHz\r\nUp to 200 hours Bluetooth\r\nInterface	\r\n2.4GHz Wireless\r\nBluetooth 5.0\r\nUSB Type-C\r\nSensor Resolution	100 - 18,000 DPI\r\nSensor technology	SteelSeries TrueMove Air\r\nWireless technology	Ultra-fast Quantum 2.0 Wireless\r\nDimensions	120.55 x 57.91 x 21.53 mm\r\nColor	MEALLIC AND MATTE FINISH\r\nWeight	71 g\r\nWarranty	2 Years', '4990.00', '1763634177_products128131_800.jpg', 10, '2025-11-20 10:22:57'),
(105, 3, 'MOUSE (เมาส์) RAZER BASILISK V3 PRO WHITE (2Y)', 'Brand	RAZER\r\nTilt scroll function	N/A\r\nClick life span	90 MILLION\r\nScroll Whell	Yes\r\nNumber of buttons	11 buttons\r\nBattery Life	Up to 90 hours (HyperSpeed)\r\nBattery Type	Lithium-Ion Battery, 600mAh\r\nInterface	\r\nBLUETOOTH\r\nRazer HyperSpeed Wireless 2.4GHz\r\nWired – Speedflex Cable USB Type C\r\nSensor Resolution	30000 DPI\r\nSensor technology	Focus Pro 30K Optical Sensor\r\nWireless technology	Wireless 2.4G\r\nDimensions	130 x 75.4 x 42.5 mm\r\nColor	WHITE\r\nWarranty	2 Years', '4890.00', '1763634218_products83334_800.jpg', 10, '2025-11-20 10:23:38'),
(106, 3, 'MOUSE (เมาส์) LOGITECH G PRO-X SUPERLIGHT 2C - (MAGENTA) (2Y)', 'Brand	LOGITECH\r\nScroll Whell	Yes\r\nMacro Keys	5 buttons\r\nNumber of buttons	5 buttons\r\nBattery Life	95 hours\r\nInterface	\r\nWIRELESS\r\nUSB Type-C\r\nSensor Resolution	100 – 44,000 DPI\r\nSensor technology	HERO 2\r\nWireless technology	WIRELESS\r\nDimensions	61.2 x 118.4 x 38.6 mm\r\nColor	MAGENTA\r\nWeight	51 g\r\nWarranty	2 Years', '4290.00', '1763634261_products134327_800.jpg', 10, '2025-11-20 10:24:21'),
(107, 3, 'MOUSE (เมาส์) ROCCAT KONE PRO AIR WHITE (ROC-11-415-01)', 'Brand	ROCCAT\r\nDimensions W x D x H	125.6 x 72 x 40 mm\r\nClick life span	100 MILLION\r\nScroll Whell	Yes\r\nMacro Keys	5 buttons\r\nNumber of buttons	5 buttons\r\nInterface	\r\nWIRELESS\r\nBLUETOOTH\r\nSensor Resolution	19,000 DPI\r\nSensor technology	PAW 3370\r\nWireless technology	RF2.4G WIRELESS\r\nColor	WHITE\r\nWarranty	2 Years', '3999.00', '1763634310_product14802_800.jpg', 10, '2025-11-20 10:25:10'),
(108, 3, 'MOUSE (เมาส์) LOGA xHITSCANxPRINTSTREAM : HYPERLIGHT GAMING MOUSE - (2Y)', 'Brand	LOGA\r\nScroll Whell	Yes\r\nMacro Keys	5 buttons\r\nNumber of buttons	5 buttons\r\nBattery Life	\r\n1000 Hz 75 hours (with High Performance mode off)\r\n2000 Hz 22 hours\r\n4000 Hz 20 hours\r\n8000 Hz 14 hours\r\nInterface	Wireless / Wired\r\nSensor Resolution	50 - 26,000 DPI\r\nSensor technology	PIXART PAW3395\r\nWireless technology	Nordic nRF52840\r\nDimensions	118 x 61 x 38 mm.\r\nColor	WHITE\r\nWeight	39 g\r\nWarranty	2 Years', '3790.00', '1763634347_products128465_800.jpg', 10, '2025-11-20 10:25:47'),
(109, 3, 'MOUSE (เมาส์) LOGITECH MX MASTER 3S (PALE GRAY) (1Y)', 'Brand	LOGITECH\r\nWireless Operating Distance	10 m\r\nTilt scroll function	N/A\r\nScroll Whell	Yes\r\nNumber of buttons	7 buttons\r\nBattery Type	500mAh\r\nInterface	\r\nBLUETOOTH\r\nUSB receiver\r\nSensor Resolution	8000 DPI\r\nSensor technology	Darkfield\r\nWireless technology	\r\nWireless 2.4G\r\nBLUETOOTH\r\nDimensions	124.9 x 84.3 x 51 mm\r\nColor	PALE GRAY\r\nWeight	141 g\r\nWarranty	1 Year', '3490.00', '1763634389_products111622_800.jpg', 10, '2025-11-20 10:26:29'),
(110, 3, 'MOUSE (เมาส์) STEELSERIES RIVAL 600 WIRED (BLACK) (2Y)', 'Brand	STEELSERIES\r\nTilt scroll function	N/A\r\nClick life span	60 MILLION\r\nScroll Whell	Yes\r\nNumber of buttons	7 buttons\r\nBattery Life	None\r\nBattery Type	None\r\nInterface	USB\r\nSensor Resolution	100 – 12,000 DPI\r\nSensor technology	SteelSeries TrueMove3+ Dual Sensor System\r\nWireless technology	USB\r\nDimensions	131 x 43 x 27 mm\r\nColor	BLACK\r\nWarranty	1 Year', '2990.00', '1763634432_products43604_800.jpg', 20, '2025-11-20 10:27:12'),
(111, 3, 'HANDHELD GAMING (เครื่องเล่นเกมพกพา) NINTENDO SWITCH 2 + MARIO KART WORLD BUNDLE (18M)', 'Nintendo Switch 2 เครื่องเกมคอนโซลแบบ Hybrid รุ่นใหม่ล่าสุดจาก Nintendo ที่มาพร้อมประสิทธิภาพที่เร็วแรงขึ้น ภาพคมชัด เล่นได้ทั้งแบบพกพาและต่อทีวี ตอบโจทย์ทุกไลฟ์สไตล์ของเกมเมอร์\r\n\r\nคุณสมบัติเด่น :\r\n- หน้าจอขนาดใหญ่ 7.9 นิ้ว\r\n- ความละเอียด Full HD 1080p\r\n- Joy-Con สามารถใช้เป็นเมาส์ได้\r\n- มาพร้อมเกม Mario Kart World\r\n\r\n*ของแท้ศูนย์ไทย M.M Soft Co., Ltd. รับประกัน 18 เดือน', '19800.00', '1763634479_products112335_800.jpg', 5, '2025-11-20 10:27:59'),
(112, 4, 'UPS (อุปกรณ์สำรองไฟ) CYBER POWER OLS3000EA 3000VA/2700W (BLACK) (2Y)', 'CyberPower OLS3000EA คือเครื่องสำรองไฟ (UPS) ประสิทธิภาพสูงที่ใช้เทคโนโลยีออนไลน์ดับเบิลคอนเวอร์ชัน (online double-conversion topology) ซึ่งให้พลังงานไฟฟ้าบริสุทธิ์แบบ Pure Sine Wave อย่างต่อเนื่องไม่มีสะดุด สำหรับอุปกรณ์ที่สำคัญอย่างยิ่ง เช่น NAS และเซิร์ฟเวอร์, ระบบ DVR/กล้องวงจรปิด, ระบบขนส่งและโครงสร้างพื้นฐาน และระบบฉุกเฉิน โดยทั่วไปมักติดตั้งในสภาพแวดล้อมของสำนักงานส่วนหลัง (back office), ห้องเซิร์ฟเวอร์ (server room) และศูนย์ข้อมูล (data center)\r\n\r\nยูพีเอสรุ่นนี้ถูกออกแบบมาพร้อมแผงจอ LCD สีเพื่อให้ผู้ใช้สามารถตรวจสอบระบบไฟฟ้าและตั้งค่าต่างๆ ได้อย่างง่ายดาย โมเดลนี้รองรับการทำงานร่วมกับเครื่องปั่นไฟและยังมีโหมดประหยัดพลังงาน (ECO mode) เพื่อช่วยอนุรักษ์พลังงาน ผลิตภัณฑ์สามารถเชื่อมต่อกับสวิตช์ตัดไฟฉุกเฉิน (Emergency Power Off - EPO) ซึ่งช่วยให้ผู้ใช้สามารถปิดการทำงานของ UPS ได้ทันทีในกรณีฉุกเฉิน พัดลมแบบปรับความเร็วได้ (variable speed fans) จะช่วยจัดการความร้อนโดยอัตโนมัติตามปริมาณโหลดไฟฟ้า เพื่อลดเสียงรบกวนและให้ความสะดวกสบายแก่ผู้ใช้งานมากยิ่งขึ้น\r\n\r\nคุณสมบัติ\r\nเทคโนโลยี Online (Double Conversion) UPS\r\n\r\nรองรับการทำงานร่วมกับเครื่องปั่นไฟ\r\n\r\nระยะเวลาสลับโหมดเป็นศูนย์ (Zero Transfer Time)\r\n\r\nการป้องกันไฟกระชากและไฟกระโชก\r\n\r\nแผงจอ LCD สี\r\n\r\nพอร์ตเชื่อมต่อแบบอนุกรม\r\n\r\nซอฟต์แวร์จัดการ PowerPanel\r\n\r\nรูปทรงแบบทาวเวอร์\r\n\r\nโหมดประหยัดพลังงาน (ECO Mode)\r\n\r\nการป้องกันการใช้งานเกินพิกัด\r\n\r\nการจัดการแบตเตอรี่อัจฉริยะ (SBM)\r\n\r\nการกรองสัญญาณรบกวน EMI และ RFI\r\n\r\nพัดลมปรับความเร็วอัตโนมัติ\r\n\r\nพอร์ตสำหรับสวิตช์ตัดไฟฉุกเฉิน (EPO)\r\n\r\nความสามารถในการจัดการระยะไกลผ่าน SNMP/HTTP (เป็นตัวเลือกเสริม)\r\n\r\nอุปกรณ์ภายในกล่อง\r\nเครื่องสำรองไฟ OLS3000EA\r\n\r\nสายไฟ\r\n\r\nสาย USB\r\n\r\nคู่มือผู้ใช้\r\n\r\n \r\n\r\nหมวดหมู่	คุณสมบัติ (Feature)	\r\nรายละเอียด (Details)\r\nทั่วไป	(General)	 \r\nPhase	Single Phase\r\nForm Factor	Tower\r\nUPS Topology	\r\nOnline Double Conversion\r\nEnergy Saving	\r\nECO Mode Efficiency > 95%\r\nไฟขาเข้า	(Input)	 \r\nNominal Input Voltage	230 ± 10% Vac\r\nInput Voltage Range	190 ~ 300 Vac\r\nInput Frequency	\r\n50 / 60 Hz (Auto-sensing)\r\nInput Connector	IEC C20\r\nไฟขาออก	(Output)	 \r\nCapacity (VA / Watts)	\r\n3000VA / 2700W\r\nOn Battery Waveform	Pure Sine Wave\r\nOutlet(s) - Total	7\r\nOutlet Type	\r\nAS x 4, Hardwire Terminal x 1, IEC C13 x 2\r\nTypical Transfer Time	0 ms\r\nแบตเตอรี่	(Battery)	 \r\nRuntime at Half Load	13.1 นาที\r\nRuntime at Full Load	4.2 นาที\r\nTypical Recharge Time	4 ชั่วโมง\r\nUser-replaceable	No\r\nBattery Type	\r\nSealed Lead-acid\r\nการจัดการ	(Management)	 \r\nLCD Panel	Color LCD\r\nPorts	\r\nUSB, RS232, Dry Contact, EPO\r\nManagement Software	\r\nPowerPanel Business\r\nกายภาพ	(Physical)	 \r\nDimensions (WxHxD)	\r\n196 x 337 x 416 mm\r\nWeight	26 kg\r\nการรับรอง	(Certifications)	 \r\nCertifications	CE, RoHS', '25900.00', '1763634553_products116822_800.jpg', 10, '2025-11-20 10:29:13'),
(113, 4, 'SPEAKER (ลำโพงพกพา) MARSHALL MIDDLETON BLACK AND BRASS (1Y)', 'Brand	MARSHALL\r\nDriver Type	\r\nTwo 3” 15W woofers\r\nTwo 3/5” 10W tweeters\r\nTwo passive radiators\r\nConnector Interface (Input)	\r\nBluetooth\r\n3.5 mm Input\r\nBluetooth	Bluetooth 5.1\r\nFrequency Response	50–20,000 Hz\r\nMax Sound Pressure Level (SPL)	87 dB SPL @ 1 m\r\nPOWER AMPLIFIERS	Two 20 Watt Class D amplifiers for the woofers\r\nHigh Gain Switch	Manual switch\r\nDimensions	109 x 230 x 95 mm\r\nWeight	1.80 kg\r\nWarranty	1 Year', '9990.00', '1763634624_products108148_800.jpg', 5, '2025-11-20 10:30:24'),
(114, 4, 'MONITOR ARM (ขายึดจอคอม) ERGONOZ EGN-ARMOURV2-D (3Y)', 'Brand	ERGONOZ\r\nRotation	\r\nTilt : -45⁰ ~ +70⁰\r\nSwivel : -90° ~ +90°\r\nPivot : -90° ~ +90°\r\nUSB Ports	\r\n1 x USB-C 3.2 Gen 4\r\n1 x USB-A 3.0\r\nMaterial	\r\nSteel\r\nPlastic\r\nAluminum\r\nVESA Compatible	\r\n75/75\r\n100/100\r\n200/100\r\n200/200\r\nWeight Capacity	27Kg/ARM\r\nFit Screen Size	24\" - 49\"\r\nWarranty	3 Years', '6100.00', '1763634676_products128457_800.jpg', 20, '2025-11-20 10:31:16'),
(115, 4, 'STREAM DECK (แผงปุ่มคุมระบบ) STREAMPLIFY STREAMING DECK ONE (2Y)', 'แบรนด์:\r\nSTREAMPLIFY\r\n|\r\nรหัสสินค้า:\r\nSKU-240518918', '3990.00', '1763634808_products42842_800.jpg', 10, '2025-11-20 10:33:28'),
(116, 4, 'MONITOR ARM (ขายึดจอคอม) ERGONOZ EGN-ARMOURV2-S (3Y)', 'Brand	ERGONOZ\r\nRotation	\r\nTilt : -45⁰ ~ +70⁰\r\nSwivel : -90° ~ +90°\r\nPivot : -90° ~ +90°\r\nUSB Ports	\r\n1 x USB-C 3.2 Gen 4\r\n1 x USB-A 3.0\r\nMaterial	\r\nSteel\r\nPlastic\r\nAluminum\r\nVESA Compatible	\r\n75/75\r\n100/100\r\n200/100\r\n200/200\r\nWeight Capacity	30Kg/ARM\r\nFit Screen Size	24\" - 57\"\r\nWarranty	3 Years', '3600.00', '1763634848_products128456_800.jpg', 10, '2025-11-20 10:34:08'),
(117, 4, 'MONITOR ARM (ขายึดจอคอม) ERGONOZ EGN-TRAZERV2-S (3Y)', 'Brand	ERGONOZ\r\nRotation	\r\nTilt : -45⁰ ~ +70⁰\r\nSwivel : -90° ~ +90°\r\nPivot : -90° ~ +90°\r\nUSB Ports	\r\n1 x USB-C 3.2 Gen 4\r\n1 x USB-A 3.0\r\nMaterial	\r\nSteel\r\nPlastic\r\nAluminum\r\nVESA Compatible	\r\n75/75\r\n100/100\r\n200/100\r\n200/200\r\nWeight Capacity	30Kg/ARM\r\nFit Screen Size	24\" - 57\"\r\nWarranty	3 Years', '3300.00', '1763634901_products130067_800.jpg', 15, '2025-11-20 10:35:01'),
(118, 4, 'EXTENSION SOCKET (ปลั๊กไฟ) POWERCONNEX 6-WAY 2-USB (PCX-PVTTS-TS06C2A1)(3M) (5Y)', 'Brand	POWERCONNEX\r\nจำนวนขา	3 ขา\r\nจำนวนช่องเสียบ	\r\n6 ช่อง\r\n2 x USB Port Type C\r\n1 x USB Port Type A\r\nRating Voltage	220V~ 250V\r\nRating Current	16 Amps\r\nรองรับอุปกรณ์กำลังไฟสูงสุด	3680 Watt\r\nสวิตซ์	1 สวิตซ์\r\nความยาวสายไฟ	3 เมตร', '3290.00', '1763634931_products137573_800.jpg', 10, '2025-11-20 10:35:31'),
(119, 4, 'EXTENDER RISER CABLE (สายพีซีไอ) HYTE PCI-E 5.0 x16 RISER CABLE PITCH (BLACK) (3Y)', 'Brand	HYTE\r\nCable Type	Riser Cable\r\nCable Color	Black\r\nCable Port	PCIe 5.0 x16\r\nWarranty	3 Years', '2790.00', '1763634971_products135227_800.jpg', 5, '2025-11-20 10:36:11'),
(120, 4, 'SLEEVED CABLE (สายถัก) LIAN LI STRIMER WIRELESS 24P - CONTROLLER 260MM (1Y)', 'แบรนด์:\r\nLIAN LI\r\n|\r\nรหัสสินค้า:\r\nSKU-241126184', '2590.00', '1763635022_products74902_800.jpg', 10, '2025-11-20 10:37:02'),
(121, 4, 'VGA HOLDER (ค้ำการ์ดจอ) ASUS ROG WINGWALL GRAPHICS CARD HOLDER', 'แบรนด์:\r\nASUS\r\n|\r\nรหัสสินค้า:\r\nSKU-12108', '1990.00', '1763635060_product39749_800.jpg', 20, '2025-11-20 10:37:40'),
(122, 4, 'EXTENSION SOCKET (ปลั๊กไฟ) POWERCONNEX 8-WAY (PCX-C5PHTTS-TS08B)(3M) (5Y)', 'Brand	POWERCONNEX\r\nจำนวนขา	3 ขา\r\nจำนวนช่องเสียบ	8 ช่อง\r\nRating Voltage	220V~ 250V\r\nRating Current	16 Amps\r\nรองรับอุปกรณ์กำลังไฟสูงสุด	3680 Watt\r\nสวิตซ์	1 สวิตซ์\r\nความยาวสายไฟ	3 เมตร', '1950.00', '1763635090_products128366_800.jpg', 10, '2025-11-20 10:38:10'),
(123, 4, 'VGA HOLDER (ค้ำการ์ดจอ) ASUS ROG HERCULX GRAPHICS CARD HOLDER (WHITE)(1Y)', 'ROG Herculx คือขาตั้งรองรับการ์ดจอที่แข็งแรงทนทาน ช่วยพยุงการ์ดจอแรงๆ ได้อย่างมั่นคง พร้อมดีไซน์ที่ใช้งานง่ายและรองรับเคสหลากหลายรุ่น\r\n\r\nออกแบบมาให้รองรับกับเคสได้หลายประเภท โดยไม่กินช่อง PCIe\r\n\r\nปรับความสูงได้ตั้งแต่ 72-128 มม. แข็งแรงและยืดหยุ่นตามการใช้งาน\r\n\r\nมาพร้อม ปุ่มหมุนปรับระดับ และ ปุ่มปลดล็อก ติดตั้งหรือถอดออกได้ง่ายโดยไม่ต้องใช้เครื่องมือ\r\n\r\nมี ระดับน้ำในตัว ช่วยให้ติดตั้งได้ตรงระดับ\r\n\r\nมี ไฟ ARGB แบบฝังในตัว รองรับการซิงก์กับ Aura Sync', '1790.00', '1763635124_products109460_800.jpg', 5, '2025-11-20 10:38:44'),
(124, 4, 'SLEEVED CABLE (สายถัก) LIAN LI STRIMER WIRELESS 16-8 340MM (PW16-81W) (1Y)', 'แบรนด์:\r\nLIAN LI\r\n|\r\nรหัสสินค้า:\r\nSKU-250229163', '1600.00', '1763635156_products85549_800.jpg', 20, '2025-11-20 10:39:16'),
(125, 4, 'VGA HOLDER (ค้ำการ์ดจอ) GIGABYTE AORUS GRAPHICS CARD HOLDER RGB', 'แบรนด์:\r\nGIGABYTE\r\n|\r\nรหัสสินค้า:\r\nSKU-00220', '1490.00', '1763635186_product8562_800.jpg', 20, '2025-11-20 10:39:46'),
(126, 4, 'EXTENDER RISER CABLE (สายพีซีไอ) ASUS ROG STRIX CABLE RS200 (240MM)', 'Cable Accessories	N/A\r\nCable With Power Supply	N/A\r\nCable Type	Riser Cable\r\nCable Color	Black\r\nCable Length	240mm.\r\nCable Port	PCI Express X16 Male to PCI Express X16 Female\r\nCable Brand	ASUS\r\nCable Dimensions	240 x 127 mm.\r\nWarranty	1 Year', '1590.00', '1763635238_product4122_800.jpg', 10, '2025-11-20 10:40:38'),
(127, 4, 'WIRELESS PCIE ADAPTER (การ์ดไวไฟ) D-LINK AX5400 DWA-X586E PCI-E WIFI6 BT5.2 (LT)', 'แบรนด์:\r\nD-LINK\r\n|\r\nรหัสสินค้า:\r\nSKU-250127372', '990.00', '1763635267_products74924_800.jpg', 10, '2025-11-20 10:41:07'),
(128, 4, 'NUMPAD (แป้นพิมพ์ตัวเลขไร้สาย) MOFII BISCUIT WIRELESS NUMERIC KEYPAD (BROWN)(1Y)', '✅  Wireless 2.4G Numerical keypad with 18 round keys  \r\n✅  Sync function .                                                            \r\n✅  Connection/Lower power indicator; \r\n✅  ➖keypad size:    135x89x28.5mm; \r\n       ➖Receiver size: 19x15.5x6.8mm \r\n✅ with 1xAAA alkaline battery\"\r\n✅ รับประกัน 1 ปี', '470.00', '1763635296_products84755_800.jpg', 10, '2025-11-20 10:41:36'),
(129, 4, 'MOUSE PAD (แผ่นรองเมาส์) FANTECH VIGIL MP902 (900 X 300 X 3MM)', 'แบรนด์:\r\nFANTECH\r\n|\r\nรหัสสินค้า:\r\nSKU-14279', '180.00', '1763635401_product43519_800.jpg', 100, '2025-11-20 10:43:21'),
(130, 4, 'MICROPHONE (ไมโครโฟน) FANTECH MCX03 LEVIOSA MAX (WHITE) (2Y)', 'แบรนด์:\r\nFANTECH\r\n|\r\nรหัสสินค้า:\r\nSKU-241024741', '790.00', '1763635429_products66931_800.jpg', 10, '2025-11-20 10:43:49'),
(131, 3, 'HEADSET (หูฟัง) LOGITECH G333 BUFFY [INEAR] BLACK', 'แบรนด์:\r\nLOGITECH\r\n|\r\nรหัสสินค้า:\r\nSKU-128366', '1090.00', '1763635473_products72284_800.jpg', 100, '2025-11-20 10:44:33'),
(132, 4, 'MICROPHONE (ไมโครโฟน) HYPERX PROCAST XLR', '• Gold-sputtered large diaphragm condenser\r\n• Cardioid polar pattern\r\n• XLR Connection\r\n• Detachable HyperX Shield metal pop filter', '9990.00', '1763635647_2022102609271855945_1.jpg', 10, '2025-11-20 10:47:27'),
(133, 4, 'MICROPHONE (ไมโครโฟน) HYPERX FLIPCAST - USB/XLR DYNAMIC', 'HyperX FlipCast ไมโครโฟนไดนามิกที่มาพร้อมการเชื่อมต่อ USB และ XLR ในตัว ให้เสียงระดับมืออาชีพสำหรับสตรีม พอดแคสต์ และงานบันทึกเสียงต่าง ๆ ดีไซน์ทันสมัย ใช้งานง่าย มีฟังก์ชัน Tap-to-Mute และไฟ RGB ปรับแต่งได้ เพิ่มความสะดวกและสไตล์ในทุกการใช้งาน', '8790.00', '1763635680_2025090909343780096_1.jpg', 10, '2025-11-20 10:48:00'),
(134, 4, 'MICROPHONE (ไมโครโฟน) HYPERX QUADCAST 2 S STANDALONE (BLACK)', '• ปรับแต่งได้อย่างเต็มที่ด้วย aRGB กว่า 100+ ดวง\r\n• เซนเซอร์เปิดปิดเสียง\r\n• คาร์ดิออยด์, รอบทิศทาง, สองทิศทาง, สเตอริโอ\r\n• ปรับแต่งได้ผ่านซอฟต์แวร์ HyperX NGENUITY', '6490.00', '1763635711_2024102609395371574_1.jpg', 10, '2025-11-20 10:48:31'),
(135, 3, 'WIRELESS HEADPHONE (หูฟังไร้สาย) BOWERS & WILKINS PX7 S2 (BLUE)', '• Hybrid Noise Cancellation\r\n• Ambient Pass-Through\r\n• Wear-Detection Sensor\r\n• Bluetooth audio - Bluetooth 5.2 with aptX Adaptive\r\n• USB-C charging & audio interface', '17500.00', '1763635765_2023103111101763333_1.jpg', 5, '2025-11-20 10:49:25'),
(136, 1, 'COMPUTER SET JIB ZARUKON-6811014', 'RYZEN 7 9800X3D / RTX5070 TI 16GB / 32GB DDR5 / M.2 1TB', '77900.00', '1763635830_20251110132252_81452_447_1.jpg', 5, '2025-11-20 10:50:30');

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
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=78;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=137;

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
