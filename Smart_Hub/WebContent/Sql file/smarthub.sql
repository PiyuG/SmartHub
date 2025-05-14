-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 14, 2025 at 05:38 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `smarthub`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `username` varchar(250) NOT NULL,
  `password` varchar(250) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`username`, `password`, `name`) VALUES
('admin', 'admin12345', 'Anna');

-- --------------------------------------------------------

--
-- Table structure for table `attendance`
--

CREATE TABLE `attendance` (
  `id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `date` date NOT NULL,
  `check_in` time DEFAULT NULL,
  `check_out` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `attendance`
--

INSERT INTO `attendance` (`id`, `email`, `date`, `check_in`, `check_out`) VALUES
(1, 'gendrajpatil45@gmail.com', '2025-03-27', '23:03:44', '23:06:42'),
(2, 'meera@gmail.com', '2025-04-05', '11:52:27', '12:22:08'),
(3, 'meera@gmail.com', '2025-04-06', '21:26:14', '21:26:21'),
(4, 'rohan@gmail.com', '2025-05-08', '23:59:04', '23:59:38'),
(5, 'rohan@gmail.com', '2025-05-09', '00:00:30', '00:00:47');

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) DEFAULT 1,
  `price` decimal(10,2) NOT NULL,
  `added_on` timestamp NOT NULL DEFAULT current_timestamp(),
  `name` varchar(255) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `category_id` int(11) NOT NULL,
  `category_name` varchar(150) NOT NULL,
  `image` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`category_id`, `category_name`, `image`) VALUES
(2, ' Grocery & Staples', 'grocery.jpg'),
(3, 'Packaged Foods', 'package food.png'),
(4, 'Beverages', 'Beverages foods.jpg'),
(5, 'Personal Care Bath & Body', 'skin care.jpg'),
(6, 'Household Essentials', 'household.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `id` int(11) NOT NULL,
  `name` varchar(250) NOT NULL,
  `mail` varchar(250) NOT NULL,
  `phone` varchar(10) NOT NULL,
  `password` varchar(20) NOT NULL,
  `address` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`id`, `name`, `mail`, `phone`, `password`, `address`) VALUES
(2, 'Mansi', 'manu@gmail.com', '9876543234', 'manu12345', 'Jalgaon'),
(1000, 'Neha Wani', 'neha@gmail.com', '8956464567', 'neh12345', 'Chinawal'),
(1001, 'Isha Nemade', 'isha@gmail.com', '8978676767', 'isha12345', 'Faizpur'),
(1002, 'Aishwarya Kirange', 'aishwarya@gmail.com', '8975785645', 'aishwarya12345', 'Savada'),
(1003, 'Pranav Pandya', 'pranav@gmail.com', '7865456768', 'pranav12345', 'Yawal'),
(1004, 'Karan Vyas', 'karan@gmail.com', '8976568946', 'karan12345', 'Yawal'),
(1005, 'Aishwarya Kirange', 'aishwarya@gmail.com', '9864675686', 'aish', 'Jalagaon');

-- --------------------------------------------------------

--
-- Table structure for table `department`
--

CREATE TABLE `department` (
  `id` int(11) NOT NULL,
  `department` varchar(50) NOT NULL,
  `designation` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `department`
--

INSERT INTO `department` (`id`, `department`, `designation`) VALUES
(18, ' Retail Department', 'Cashier / Billing Executive'),
(19, ' Retail Department', 'Department Supervisor'),
(20, 'Inventory & Stock Management Department ', 'Inventory Manager'),
(21, 'Inventory & Stock Management Department ', 'Delivery Boy'),
(22, 'Finance & Accounts Department', 'Accountant'),
(23, 'Security & Maintenance Department', 'Security Guard'),
(24, 'Security & Maintenance Department', 'Maintenance Staff'),
(25, 'Human Resources (HR) Department', 'HR Executive'),
(26, 'Marketing & Promotions Department', 'Promotions Executive'),
(27, 'Security', 'Guard');

-- --------------------------------------------------------

--
-- Table structure for table `employee_bills`
--

CREATE TABLE `employee_bills` (
  `bill_id` int(11) NOT NULL,
  `employee_id` varchar(50) DEFAULT NULL,
  `prod_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `total_amount` int(11) DEFAULT NULL,
  `bill_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee_bills`
--

INSERT INTO `employee_bills` (`bill_id`, `employee_id`, `prod_id`, `quantity`, `total_amount`, `bill_date`) VALUES
(11, NULL, 12, 2, 4000, '2025-05-11 21:50:17'),
(12, NULL, 14, 2, 2800, '2025-05-11 21:52:10'),
(13, NULL, 15, 3, 318, '2025-05-11 21:54:08'),
(14, NULL, 15, 3, 318, '2025-05-11 21:55:53'),
(15, NULL, 39, 1, 125, '2025-05-11 21:56:16');

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE `feedback` (
  `feedback_id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `customer_id` int(11) NOT NULL,
  `rating` int(11) DEFAULT NULL CHECK (`rating` between 1 and 5),
  `comments` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `feedback`
--

INSERT INTO `feedback` (`feedback_id`, `order_id`, `customer_id`, `rating`, `comments`, `created_at`) VALUES
(7, 17, 2, 5, 'First Class', '2025-05-08 10:31:10');

-- --------------------------------------------------------

--
-- Table structure for table `leave_balance`
--

CREATE TABLE `leave_balance` (
  `id` int(11) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `total_leaves` int(11) DEFAULT 20,
  `used_leaves` int(11) DEFAULT 0,
  `remaining_leaves` int(11) GENERATED ALWAYS AS (`total_leaves` - `used_leaves`) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `leave_balance`
--

INSERT INTO `leave_balance` (`id`, `email`, `total_leaves`, `used_leaves`) VALUES
(4, 'meera@gmail.com', 30, 11),
(5, 'nil@gmail.com', 30, 6),
(6, 'rohan@gmail.com', 30, 3),
(7, 'arjun@gmail.com', 30, 0);

-- --------------------------------------------------------

--
-- Table structure for table `leave_requests`
--

CREATE TABLE `leave_requests` (
  `id` int(11) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `leave_reason` varchar(255) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Pending',
  `total_days` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `leave_requests`
--

INSERT INTO `leave_requests` (`id`, `email`, `start_date`, `end_date`, `leave_reason`, `status`, `total_days`) VALUES
(12, 'meera@gmail.com', '2025-04-07', '2025-04-12', 'Casual Leave', 'Approved', 6),
(13, 'nil@gmail.com', '2025-04-17', '2025-04-22', 'Paid Leave', 'Approved', 6),
(14, 'rohan@gmail.com', '2025-05-08', '2025-05-10', 'Casual Leave', 'Approved', 3),
(15, 'meera@gmail.com', '2025-05-09', '2025-05-13', 'Sick Leave', 'Approved', 5),
(16, 'arjun@gmail.com', '2025-05-12', '2025-05-15', 'Sick Leave', 'Pending', 4);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` varchar(100) NOT NULL DEFAULT 'unread'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `message`, `created_at`, `status`) VALUES
(19, 13, 'New order #16 has been assigned to you.', '2025-04-14 16:07:43', 'unread'),
(20, 2, 'Your order #16 is now out for delivery.', '2025-04-14 16:07:43', 'unread'),
(21, 13, 'New order #16 has been assigned to you.', '2025-04-14 16:08:41', 'unread'),
(22, 2, 'Your order #16 is now out for delivery.', '2025-04-14 16:08:41', 'unread'),
(23, 13, 'New order #17 has been assigned to you.', '2025-05-06 15:33:26', 'unread'),
(24, 2, 'Your order #17 is now out for delivery.', '2025-05-06 15:33:26', 'unread'),
(25, 19, 'New order #18 has been assigned to you.', '2025-05-08 17:55:19', 'unread'),
(26, 2, 'Your order #18 is now out for delivery.', '2025-05-08 17:55:19', 'unread');

-- --------------------------------------------------------

--
-- Table structure for table `offers`
--

CREATE TABLE `offers` (
  `id` int(11) NOT NULL,
  `prod_id` int(11) NOT NULL,
  `original_price` double NOT NULL,
  `discount_type` varchar(100) NOT NULL,
  `discount_value` double NOT NULL,
  `final_price` double NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `offers`
--

INSERT INTO `offers` (`id`, `prod_id`, `original_price`, `discount_type`, `discount_value`, `final_price`, `start_date`, `end_date`) VALUES
(3, 15, 106, 'percentage', 30, 74.2, '2025-05-06', '2025-05-11'),
(4, 25, 199, 'fixed', 50, 149, '2025-05-06', '2025-05-11'),
(5, 33, 1349, 'percentage', 50, 674.5, '2025-05-05', '2025-05-17'),
(6, 28, 97, 'percentage', 30, 67.9, '2025-05-05', '2025-05-18'),
(7, 39, 125, 'percentage', 30, 87.5, '2025-05-06', '2025-05-11'),
(8, 41, 250, 'fixed', 50, 200, '2025-05-11', '2025-05-15'),
(9, 44, 530, 'fixed', 131, 399, '2025-05-11', '2025-05-13');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `fullname` varchar(100) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `pincode` varchar(10) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `order_date` datetime DEFAULT NULL,
  `status` varchar(50) DEFAULT 'Processing',
  `payment_mode` varchar(20) DEFAULT NULL,
  `delivery_boy_email` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `customer_id`, `fullname`, `phone`, `pincode`, `address`, `order_date`, `status`, `payment_mode`, `delivery_boy_email`) VALUES
(16, 2, 'Mansi', '7378447741', '425505', 'at post chinawal\r\n', '2025-04-14 21:35:46', 'Delivered', 'online', 'arjun@gmail.com'),
(17, 2, 'Mansi', '9876543234', '425505', 'pune', '2025-05-06 20:59:44', 'Delivered', 'online', 'arjun@gmail.com'),
(18, 2, 'Mansi', '9876543234', '425505', 'Jalgaon', '2025-05-08 09:13:14', 'Delivered', 'online', 'abhishek@gmail.com'),
(19, 1000, 'Neha', '9876543234', '425505', 'Chinawal', '2025-05-08 23:39:41', 'Processing', 'online', NULL),
(20, 2, 'Mansi', '7378447741', '425505', 'Chinawal', '2025-05-09 00:21:06', 'Processing', 'cod', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `quantity`) VALUES
(24, 16, 12, 1),
(25, 16, 11, 43),
(26, 17, 11, 14),
(27, 18, 13, 1),
(28, 19, 39, 2),
(29, 19, 28, 2),
(30, 19, 36, 1),
(31, 20, 15, 1),
(32, 20, 11, 1);

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `prod_id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `stock` int(11) NOT NULL,
  `price` double NOT NULL,
  `description` text DEFAULT NULL,
  `image` varchar(255) NOT NULL,
  `subcategory_id` int(11) NOT NULL,
  `category` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`prod_id`, `name`, `stock`, `price`, `description`, `image`, `subcategory_id`, `category`) VALUES
(11, 'NIMBARK Basmati Rice White Basmati Rice  (0.5 kg)', 1, 950, 'Basmati rice is a type of white rice. It is more aromatic than plain white rice (such as rice used in Chinese and Japanese cuisine), with a slight nutty perfume. The grains are also longer than ordinary white rice', 'uploads/product/nimbarkar.jpg', 14, 2),
(12, 'Pansari Sona Masoori Rice (Small Grain)  (30 kg)', 36, 2000, 'Pansari Sona Masoori Rice, a staple in Indian households, embodies the essence of quality and tradition. Cultivated in the fertile lands of Telangana, Andhra Pradesh, and Karnataka, this medium-grain rice variety carries a distinct aroma and flavor that elevate every dish it graces. Its quick and even cooking properties make it a preferred choice for various culinary creations, from aromatic biryanis to comforting rice bowls. With Pansari\'s commitment to sourcing the finest grains and maintaining stringent quality standards, every grain of Sona Masoori Rice embodies the rich heritage of Indian cuisine, promising a delightful dining experience with every meal.', 'uploads/product/pansari_rice.jpg', 14, 2),
(13, 'Daawat Sehat/Rozana Mini Mogra Basmati Rice (Broken Grain)  (10 kg)', 49, 700, 'Daawat Sehat Mini Mogra Basmati Rice 10 kg', 'uploads/product/dawaat rozana.jpg', 14, 2),
(14, 'Nupsila Long Grain Premium Basmati Rice (Long Grain, Steam)  (5 kg)', 48, 1400, 'Steam Basmati Rice It is specially aged to help every grain acquire the best basmati characteristics of fluffy and long grain. On cooking, the grains do not stick together and become flavorsome. The result is an irresistible serving the delights everyone s heart through its appearance and taste.', 'uploads/product/nupsila.jpg', 14, 2),
(15, 'Unity Brown Rice 1 kg', 42, 106, 'Unity Brown Rice is mainly cultivated in southern parts of India. It is rich in flavour and has a delightful aroma. The size of the grain is consistent with the consumer\'s requirement. The slender long grained rice is aromatic and nutritious at the same time. Buy Unity Brown Rice online today.', 'uploads/product/unity rice.jpg', 14, 2),
(16, 'ARANYAKA Kerala Wayanad Forest Bamboo Rice (500g) Brown Bamboo Seed Rice (Small Grain, ) Brown Bamboo Seed Rice (Small Grain, Raw)  (0.5 kg)', 50, 530, 'Bamboo rice is special rice that is grown out of a dying bamboo shoot. When the bamboo shoot breathes its last, it flowers into a rare variety of rice seeds, which are known as bamboo rice. It is said that the bamboo rice harvesting is a major source of income for the tribal communities living in the interiors of Wayanad Sanctuary in Kerala.Bamboo rice: The next superfood that can boost your health .', 'uploads/product/aranyaka.jpg', 14, 2),
(17, 'Sigotar Bajra Unpolished Pearl Millet Desi Bajri Gluten Free Bajra High Plant Protein Pearl Millet  (1 kg)', 50, 250, 'Natural & Organic Millets! Millets is one of the most ancient forms of food and was famously consumed by all our ancestors. It is known to be very healthy, nutritious and tasty. In earlier days, one bowl of millet Daliya used to be entire lunch. Due to heavy dietary fibers, it is a wholesome lunch and is a very good source of energy.', 'uploads/product/bajari.jpg', 14, 2),
(18, 'PRODUCER PREMIUM JOWAR SEEDS (Sorghum), 2kg Sorghum', 50, 500, 'Jowar is rich in good quality fibre which can aid digestion, manage obesity and regulate blood sugar levels. Besides it has complex carbohydrates, which takes time to digest and release sugar in the bloodstream gradually, keeping sudden sugar spikes at bay.', 'uploads/product/jowar.jpg', 14, 2),
(19, 'PRODUCER PREMIUM 1st GRADE SHARBATI WHOLE WHEAT, 1kg Whole Wheat  (1 kg)', 50, 345, '\r\nPRODUCER presents Premium Whole Wheat grains, natural land organic whole Wheat grains had a great traditional taste since organically grown using traditional seeds and processed traditionally. A staple in the Indian diet, Wheat is a good source of protein. Essential in every household. Our Wheat is unpolished as it does not undergo any artificial polishing with water, oil or leather thereby retaining its goodness and wholesomeness.', 'uploads/product/wheat.jpg', 14, 2),
(20, 'Goshudh Premium Quality Sabudana (Sago)-1Kg (Pack Of 1) Sago  (1 kg)', 50, 100, 'Sabudana also known as Sago, in various parts of the world is an edible starch extracted from the pith or the spongy centre of the tropical palm trees. Sabudana is traditionally added in Indian cooking, particularly in recipes prepared during festivals like Navratri, Diwali and Varalakshmi Vrat, as these dishes are consumed following a fast. ', 'uploads/product/sbudana.jpg', 14, 2),
(22, 'Aashirvaad Multigrain Atta: 5 kgs', 60, 316, 'High in Dietary Fibre: Supports digestion for a healthier lifestyle.Soft and Smooth Chapattis: Absorbs more water, making chapattis soft and smooth.Rich in Multigrains: Contains a blend of various nutritious grains.', 'product_images\\product_1746700438308_Aashirvaad Multigrain Atta.jpg', 15, 2),
(23, 'Fortune Chakki Fresh Wheat Atta: 10 kgs', 50, 433, 'Light and fluffy rotis are guaranteed, with the asli phulke wala atta!\r\n Made with the finest wheat crops, Fortune Chakki Fresh Atta ensures with every meal your loved ones say, Ek phulka aur.', 'product_images\\product_1746689432473_Fortune Chakki Fresh Wheat Atta.jpg', 15, 2),
(24, 'Tata Sampann Chana Dal: 1 kg', 50, 101, 'Chana dal is a staple in the Indian diet. It\'s nutritious and can be easily digested. Tata Sampann\'s Chana Dal has a rich flavour and aroma, and provides essential amino acids for complete protein. Used in a variety of soups, salads, sweets and savouries, chana dal is an essential in every household.', 'product_images\\product_1746689947245_Tata Sampann Chana Dal.jpg', 16, 2),
(25, 'Organic Tattva Moong Dal Yellow Split: 1 kg', 50, 199, 'Organic Tattva&#146;s Organic Moong Dal Yellow Split is full of iron, calcium, and protein. Along with these nutrients, a bowl of Organic Moong Dal Yellow Split also contains dietary fibers, sodium, and all the other nutrients that are required for your body. A 100g serving of Organic Moong Dal Yellow Split contains 0g trans fat and 0g sugar. The calorie count per serving of Organic Moong Dal Yellow Split is 293. If leading a healthy life is your mantra, then switch to Organic Moong Dal Yellow Split by Organic Tattva today!', 'product_images\\product_1746690019755_Organic Tattva Moong Dal Yellow Split.jpg', 16, 2),
(26, 'Tata Sampann Unpolished Toor Dal: 1 kg', 50, 164, 'Tata Sampann Dals are unpolished and don�t undergo any artificial polishing with water, oil or leather, thereby nourishing their goodness and wholesome character. The 5-Step Process ensures that Tata Sampann grains are uniform and of premium quality, giving you an all-natural aesthetic taste', 'product_images\\product_1746690079646_Tata Sampann Unpolished Toor Dal.jpg', 16, 2),
(27, 'Tata Salt - Evaporated Iodised: 1 kg', 50, 25, 'Iodised for Health � Contains essential iodine for thyroid support.\r\nZero Calories � No energy contribution to your diet.\r\nEnvironmentally Friendly Packaging � 100% recyclable pack to reduce waste.', 'product_images\\product_1746690144951_Tata Salt - Evaporated Iodised.jpg', 18, 2),
(28, 'Everest Tikhalal Chilli Powder: 200 gms', 98, 97, 'Everest Tikhalal Chilli Powder is a popular spice product known for its vibrant red colour and spicy flavour. It is widely used in Indian cuisine to add heat and flavour to a variety of dishes. Tikhalal refers to the powder being finely ground and suitable for use in both dry and wet dishes', 'uploads/product/Everest Tikhalal Chilli Powder.jpg', 19, 2),
(29, 'LG Hing: 100 gms', 100, 147, 'Traditional LG Hing (Asafoetida) for authentic flavour.\r\nPackaged in a convenient 200g size.', 'uploads/product/LG Hing.jpg', 19, 2),
(30, 'Everest Pav Bhaji Masala: 100 gms', 50, 90, 'Authentic Taste: Brings the traditional Pav Bhaji flavour to life.\r\n100% Natural Ingredients: No artificial colours or preservatives.\r\nQuick and Easy: Simple recipe for delicious Pav Bhaji.', 'uploads/product/Everest Pav Bhaji Masala.jpg', 19, 2),
(31, 'Maggi Masala Magic: 120 gms', 200, 100, 'Perfect Spice Blend: A delicious mix of 10 aromatic, roasted spices.\r\nTransforms Vegetables: Turns Everyday vegetables into flavorful dishes.\r\nKid-Friendly: Makes veggies more enjoyable for children.', 'uploads/product/Maggi Masala Magic.jpg', 19, 2),
(32, 'Everest Turmeric Powder: 200 gms', 196, 92, 'Farm Fresh Golden Yellow Colour: Authentic, vibrant yellow turmeric powder.\r\n100% Pure Turmeric: No artificial colours or preservatives.\r\nRich in Nutrients: Supports overall wellness with anti-inflammatory properties.', 'uploads/product/Everest Turmeric Powder.jpg', 19, 2),
(33, 'ProV Select California Almonds: 1 kg', 200, 1349, ' Premium products inspiring healthier choices for nutritional living \r\nSourced from the finest orchards and choicest suppliers from India and abroad \r\nA step towards wholesome goodness', 'uploads/product/ProV Select California Almonds.jpg', 20, 2),
(34, 'Nutraj Cashews: 500 gms', 100, 699, 'Refrigerate for freshness and Natural taste', 'uploads/product/Nutraj Cashews.jpg', 20, 2),
(35, 'ProV Select Cashews: 500 gms', 100, 849, 'Allergen advice : Packed in a facility that packs tree nuts. May contain dry fruits and other nuts', 'uploads/product/ProV Select Cashews.jpg', 20, 2),
(36, 'KMK Pista Salted Irani (Pistachios): 200 gms', 99, 319, 'Pista tastes great as it is the most delicious variety seen in years. This seed can be folded into quick breads, muffins, cupcakes, or yeast breads, they contribute crunch and buttery flavor but they don\'t stay green.', 'uploads/product/KMK Pista Salted Irani (Pistachios).jpg', 20, 2),
(37, 'Betty Crocker Complete Pancake Mix: 1 kg', 100, 520, 'Since 1921, Betty Crocker has been delighting consumers all around the world! Betty Crocker products can be found in more than a dozen markets throughout the world.', 'uploads/product/Betty Crocker Complete Pancake Mix.jpg', 21, 3),
(38, 'Haldiram\'s Paneer Butter Masala', 100, 155, 'A delicious North Indian dish made with soft cottage cheese in a richly spiced gravy.\r\nPC/Pack 1 N', 'uploads/product/Haldiram\'s Paneer Butter Masala.jpg', 21, 3),
(39, 'Gits Gulab Jamun: 200 gms', 96, 125, 'Who can resist the temptation of hot, homemade gulab jamuns? It is the perfect dessert after a scrumptious lunch or dinner. And, with this GITS Instant Mix, you can make gulab jamuns in just 20 minutes.', 'uploads/product/Gits Gulab Jamun.jpg', 21, 3),
(40, 'Act II Butter Delite Flavour Popcorn: 450 gms', 100, 135, 'Enjoy the classic Butter Delite popcorn flavour, while catching up on your favourite movies or shows. The delicious buttery aroma and flavour makes it an irresistible snack. What\'s more, you can make it in just 3 minutes in a pressure cooker or pan.', 'uploads/product/Act II Butter Delite Flavour Popcorn.jpg', 21, 3),
(41, 'Pravin Mango Pickle: 1 kg', 98, 250, 'Pravin mango pickle will make any boring meal come alive. It has a sweet and sour taste that will make your mouth water every time you have it. It has the traditional taste of homemade pickles and is a must-have in every kitchen.', 'uploads/product/Pravin Mango Pickle.jpg', 22, 3),
(42, 'Ram Bandhu Mango Pickle: 1 kg', 100, 270, 'Ready to eat Mango Pickle from the house of Rambandhu is the ultimate mood builder. All ingredients are meticulously hand-picked. The exquisite quality and taste of their pickles are liked and revered by all our consumers.', 'uploads/product/Ram Bandhu Mango Pickle.jpg', 22, 3),
(43, 'Kissan Tomato Ketchup: 1.1 kgs', 100, 150, 'Kissan Fresh Tomato Ketchup is made with 100% real, naturally ripened fresh Tomatoes. The Tangy Tomato Ketchup is a must have at all homes and most loved by Indians! This sauce bottle and pouch packs can either be paired with fries or noodles or dhokla.', 'uploads/product/Kissan Tomato Ketchup.jpg', 22, 3),
(44, 'Parachute Coconut Oil: 1 Litre', 50, 530, 'Parachute Coconut oil contains only the goodness of 100% pure coconut oil. It is made from naturally sun-dried coconuts sourced from the finest farms in the country. The oil is extracted from the nuts through a meticulous hands-free process.', 'uploads/product/Parachute Coconut Oil.jpg', 32, 5),
(45, 'Indulekha Bringha Ayurvedic Hair Oil: 100 ml', 40, 468, 'Indulekha Bringha Oil is a Proprietary Ayurvedic Medicine for Hair Fall, Grows New Hair. It is 100% Ayurvedic Oil which is clinically proven to reduce hair fall and grows new hair in 4 months. It is proven on real male and female consumers having mild to severe hair fall.', 'uploads/product/Indulekha Bringha Ayurvedic Hair Oil.jpg', 32, 5),
(46, 'Dabur Amla Hair Oil: 450 ml', 40, 225, 'Dabur Amla Hair Oil is enriched with soya protein and 10X Vitamin E for healthy hair.', 'uploads/product/Dabur Amla Hair Oil.jpg', 32, 5),
(47, 'Himalaya Purifying Neem Face Wash: 200 ml', 60, 399, 'Clinically Proven Pimple-free Healthy Skin Expert. Himalaya\'s Purifying Neem Face Wash is a soap-free formulation that cleans impurities and helps clear pimples.', 'uploads/product/Himalaya Purifying Neem Face Wash.jpg', 34, 5),
(48, 'Pond\'s Bright Beauty Spot-Less Glow Facewash: 200 gms', 50, 452, 'POND\'S is a trusted skincare brand under Hindustan Unilever Limited, known for providing effective solutions for bright, healthy-looking skin. With decades of expertise, POND\'S offers products that combine advanced skincare technology with natural ingredients for visible results.', 'uploads/product/Pond\'s Bright Beauty Spot-Less Glow Facewash.jpg', 34, 5),
(49, 'Garnier Bright Complete Face Wash - Lemon: 100 gms', 50, 209, 'Cleanses and Brightens: Removes impurities for clearer skin.\r\nEnriched with Yuzu Lemon Essence: Enhances brightness.\r\nUse Twice Daily: Ideal for daily use.', 'uploads/product/Garnier Bright Complete Face Wash - Lemon.jpg', 34, 5),
(50, 'Colgate MaxFresh Spicy Fresh Toothpaste: 300 gms', 50, 275, 'Switch on the power of freshness with Colgate Maxfresh toothpaste that refreshes you and helps you seize the day because every morning is a fresh start. The red gel toothpaste contains unique cooling cyrstals that give you an intense cooling while you brush.', 'uploads/product/Colgate MaxFresh Spicy Fresh Toothpaste.jpg', 33, 5),
(51, 'Colgate Charcoal Clean Bamboo & Mint Toothpaste: 240 gms', 30, 400, 'Bid farewell to your usual brushing experience and say hello to an interesting one, with Colgate Charcoal Clean black gel toothpaste. Refresh your senses with a toothpaste which is perfect blend of natural bamboo charcoal that helps to detoxify for a deep clean feeling & exotic ', 'uploads/product/Colgate Charcoal Clean Bamboo & Mint Toothpaste.jpg', 33, 5),
(52, 'Wagh Bakri Premium Leaf Tea Pouch: 1 kg', 30, 620, 'An integral part of the daily life of millions of tea lovers. Wagh Bakri Tea is renowned for its premium quality which promises you consistency in taste, aroma and strength. \r\nAt Wagh Bakri Tea Group, they believe tea is a social catalyst that spreads peace and harmony and brings together to build relationships.', 'uploads/product/Wagh Bakri Premium Leaf Tea Pouch.jpg', 30, 4),
(53, 'Surf Excel Matic Liquid Detergent Top Load Pouch: 4 L', 30, 795, 'Top-load washing machine detergent', 'uploads/product/Surf Excel Matic Liquid Detergent Top Load Pouch.jpg', 37, 6);

-- --------------------------------------------------------

--
-- Table structure for table `salary_payments`
--

CREATE TABLE `salary_payments` (
  `id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `base_salary` decimal(10,2) NOT NULL,
  `overtime` decimal(10,2) DEFAULT 0.00,
  `deductions` decimal(10,2) DEFAULT 0.00,
  `net_salary` decimal(10,2) NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `salary_payments`
--

INSERT INTO `salary_payments` (`id`, `employee_id`, `base_salary`, `overtime`, `deductions`, `net_salary`, `date`) VALUES
(4, 12, 45000.00, 3000.00, 0.00, 48000.00, '2025-04-05 07:40:29'),
(5, 11, 50000.00, 3000.00, 0.00, 53000.00, '2025-04-05 09:23:48'),
(6, 13, 20000.00, 5000.00, 0.00, 25000.00, '2025-04-06 16:01:46'),
(7, 16, 30000.00, 3000.00, 0.00, 33000.00, '2025-05-08 17:10:59'),
(8, 13, 20000.00, 4000.00, 0.00, 24000.00, '2025-05-08 17:40:31');

-- --------------------------------------------------------

--
-- Table structure for table `subcategories`
--

CREATE TABLE `subcategories` (
  `subcategory_id` int(11) NOT NULL,
  `subcategory_name` varchar(100) NOT NULL,
  `category_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `subcategories`
--

INSERT INTO `subcategories` (`subcategory_id`, `subcategory_name`, `category_id`) VALUES
(14, 'Rice & Grains', 2),
(15, 'Atta, Flours & Sooji', 2),
(16, 'Dals & Pulses', 2),
(17, 'Edible Oils', 2),
(18, 'Salt, Sugar & Jaggery', 2),
(19, 'Spices & Masalas', 2),
(20, 'Dry Fruits & Nuts', 2),
(21, 'Ready-to-Eat Food', 3),
(22, 'Pickles & Sauces', 3),
(23, 'Jams, Honey & Spreads', 3),
(24, 'Noodles, Pasta & Soups', 3),
(25, 'Chocolates & Candies', 3),
(26, 'Namkeen & Snacks', 3),
(27, 'Biscuits, Cookies & Cakes', 3),
(28, 'Soft Drinks', 4),
(29, 'Juices', 4),
(30, 'Tea, Coffee & Health Drinks', 4),
(31, 'Bottled Water', 4),
(32, 'Hair Care', 5),
(33, 'Oral Care', 5),
(34, 'Skin Care', 5),
(35, 'Men�s Grooming', 5),
(36, 'Sanitary Products', 5),
(37, 'Detergents & Cleaners', 6),
(38, 'Dishwash & Laundry', 6),
(39, 'Air Fresheners', 6),
(40, 'Tissues, Wipes & Napkins', 6),
(41, 'Brooms, Mops & Brushes', 6);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `name` varchar(250) NOT NULL,
  `mail` varchar(250) NOT NULL,
  `mobno` varchar(12) NOT NULL,
  `password` varchar(15) NOT NULL,
  `address` varchar(250) NOT NULL,
  `id` int(11) NOT NULL,
  `department` varchar(100) DEFAULT NULL,
  `designation` varchar(100) DEFAULT NULL,
  `salary` double DEFAULT NULL,
  `joining_date` date DEFAULT NULL,
  `status` varchar(15) NOT NULL,
  `dob` date DEFAULT NULL,
  `image` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`name`, `mail`, `mobno`, `password`, `address`, `id`, `department`, `designation`, `salary`, `joining_date`, `status`, `dob`, `image`) VALUES
('Nil Vashisht', 'nil@gmail.com', '9867453452', 'nil@1234', 'Chaudhari Wada Faizpur', 11, ' Retail Department', 'Department Supervisor', 50000, '2025-01-03', 'Active', '1998-04-05', 'uploads/employee/user5.jpg'),
('Meera Singh', 'meera@gmail.com', '7856345634', 'meeru', 'Tukaram Wadi, Chinawal', 12, ' Retail Department', 'Department Supervisor', 45000, '2024-03-01', 'Active', '2001-04-11', 'uploads/employee/user7.jpg'),
('Arjun', 'arjun@gmail.com', '7385569912', 'arjun@1234', 'Jalgoan', 13, 'Inventory & Stock Management Department ', 'Delivery Boy', 20000, '2025-03-15', 'Active', '2001-04-02', 'uploads/employee/user3.jpg'),
('Shivansh Gupta', 'shivanshg@gmail.com', '7346786379', 'shivansh123', 'Denanagar Bhusawal', 14, ' Retail Department', 'Cashier / Billing Executive', 30000, '2025-02-01', 'Active', '2002-05-15', 'uploads/employee/360_F_364211147_1qgLVxv1Tcq0Ohz3FawUfrtONzz8nq3e.jpg'),
('Arjun Verma', 'arjunv@gmail.com', '9856456567', 'arjunv12345', 'Ramdas Colony Jalgaon', 16, 'Finance & Accounts Department', 'Accountant', 30000, '2023-08-10', 'Active', '2002-05-14', 'uploads/employee/images (5).jpg'),
('Rohan Mehata', 'rohan@gmail.com', '9067565676', 'rohan@12345', 'Khanderav Wadi Jalgaon', 17, 'Inventory & Stock Management Department ', 'Inventory Manager', 30000, '2024-04-11', 'Active', '2025-03-14', 'uploads/employee/user4.jpg'),
('Vikram Reddy', 'vikram@gmail.com', '8856784567', 'vikram12345', 'Mahajan Wada, Chinawal', 18, ' Retail Department', 'Department Supervisor', 40000, '2023-01-04', 'Active', '2025-01-12', 'uploads/employee/images (9).jpg'),
('Abhishek Patil', 'abhishek@gmail.com', '8756453478', 'abhishek12345', 'Prathmesh house, Faizpur', 19, 'Inventory & Stock Management Department ', 'Delivery Boy', 30000, '2024-07-18', 'Active', '1995-05-08', 'uploads/employee/images (3).jpg'),
('Karan Agnihotri', 'karan@gmail.com', '8967564567', 'karan12345', 'Vaishanavi Nagar, Faizpur', 20, 'Human Resources (HR) Department', 'HR Executive', 80000, '2021-02-05', 'Active', '1998-05-08', 'uploads/employee/download.jpg'),
('Avani Kulashesht', 'avani@gmail.com', '8976678976', 'avani12345', 'Ram Colony Savada', 21, 'Human Resources (HR) Department', 'HR Executive', 60000, '2022-05-12', 'Active', '2000-05-14', 'uploads/employee/images (7).jpg'),
('Suhani Roy', 'suhani@gmail.com', '8645468756', 'suhani12345', 'Kubharkheda', 22, 'Finance & Accounts Department', 'Accountant', 30000, '2023-05-11', 'Active', '2002-05-13', 'uploads/employee/images.jpg'),
('Madhu Khanna', 'madhu@gmail.com', '9876543234', 'madhu12345', 'Bhusawal', 23, NULL, NULL, NULL, NULL, 'Inactive', '2000-05-11', 'uploads/employee/download (1).jpg'),
('Aishwarya Kirange', 'ashwaeya@gmail.com', '9876543234', 'ash12345', 'Jalgaon', 24, NULL, NULL, NULL, NULL, 'Inactive', '2000-06-08', 'uploads/employee/images (4).jpg'),
('Aishwarya Kirange', 'ashwaeya@gmail.com', '9876543234', 'ash12345', 'Jalgaon', 25, NULL, NULL, NULL, NULL, 'Inactive', '1999-06-08', 'uploads/employee/images (4).jpg');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `attendance`
--
ALTER TABLE `attendance`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_attendance` (`email`,`date`);

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`,`product_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`category_id`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `department`
--
ALTER TABLE `department`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `employee_bills`
--
ALTER TABLE `employee_bills`
  ADD PRIMARY KEY (`bill_id`);

--
-- Indexes for table `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`feedback_id`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `fk_feedback_order` (`order_id`);

--
-- Indexes for table `leave_balance`
--
ALTER TABLE `leave_balance`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `leave_requests`
--
ALTER TABLE `leave_requests`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `offers`
--
ALTER TABLE `offers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `fk_orders_user` (`customer_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_order_items_order` (`order_id`),
  ADD KEY `fk_order_items_product` (`product_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`prod_id`),
  ADD KEY `fk_subcategory` (`subcategory_id`);

--
-- Indexes for table `salary_payments`
--
ALTER TABLE `salary_payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `employee_id` (`employee_id`);

--
-- Indexes for table `subcategories`
--
ALTER TABLE `subcategories`
  ADD PRIMARY KEY (`subcategory_id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `attendance`
--
ALTER TABLE `attendance`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1006;

--
-- AUTO_INCREMENT for table `department`
--
ALTER TABLE `department`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `employee_bills`
--
ALTER TABLE `employee_bills`
  MODIFY `bill_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `feedback_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `leave_balance`
--
ALTER TABLE `leave_balance`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `leave_requests`
--
ALTER TABLE `leave_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `offers`
--
ALTER TABLE `offers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `prod_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT for table `salary_payments`
--
ALTER TABLE `salary_payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `subcategories`
--
ALTER TABLE `subcategories`
  MODIFY `subcategory_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`prod_id`),
  ADD CONSTRAINT `fk_cart_customer` FOREIGN KEY (`user_id`) REFERENCES `customer` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `feedback`
--
ALTER TABLE `feedback`
  ADD CONSTRAINT `feedback_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_feedback_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_orders_user` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `fk_order_items_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_order_items_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`prod_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `fk_subcategory` FOREIGN KEY (`subcategory_id`) REFERENCES `subcategories` (`subcategory_id`) ON DELETE CASCADE;

--
-- Constraints for table `salary_payments`
--
ALTER TABLE `salary_payments`
  ADD CONSTRAINT `salary_payments_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `subcategories`
--
ALTER TABLE `subcategories`
  ADD CONSTRAINT `subcategories_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
