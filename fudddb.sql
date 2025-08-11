-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Aug 11, 2025 at 01:55 PM
-- Server version: 10.11.8-MariaDB
-- PHP Version: 8.4.7

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `fudddb`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`fuddusr`@`%` PROCEDURE `getproductfromcategoryid` (IN `catid` TEXT, IN `isonlyactive` INT)   select * from products where (find_in_set(catid,categoryid)) and isactive=1$$

CREATE DEFINER=`fuddusr`@`%` PROCEDURE `proc_searchrestro` (IN `searchtext` VARCHAR(300), IN `late` VARCHAR(20), IN `longe` VARCHAR(20), IN `userid` INT)   BEGIN

IF(searchtext ='null' OR searchtext ='') THEN

SELECT *, ( 3959 * acos( cos( radians(late) ) * cos( radians( lat ) ) * 
cos( radians( lng ) - radians(longe) ) + sin( radians(late) ) * 
sin( radians( lat ) ) ) ) AS distance
FROM restaurants where isactive=1 HAVING distance < 25 ORDER BY distance LIMIT 0 , 100;

ELSE

SELECT *, ( 3959 * acos( cos( radians(late) ) * cos( radians( lat ) ) * 
cos( radians( lng ) - radians(longe) ) + sin( radians(late) ) * 
sin( radians( lat ) ) ) ) AS distance
FROM restaurants where isactive=1 and (categoryname like CONCAT('%', searchtext , '%') or tags like CONCAT('%', searchtext , '%') or name like CONCAT('%', searchtext , '%') or location like CONCAT('%', searchtext , '%') or city like CONCAT('%', searchtext , '%') or state like CONCAT('%', searchtext , '%')) HAVING distance < 25 ORDER BY distance LIMIT 0 , 100;

END IF;

END$$

CREATE DEFINER=`fuddusr`@`%` PROCEDURE `searchcommunities` (IN `qry` TEXT)  NO SQL SELECT * FROM community  
WHERE isactive=1 and (title like CONCAT('%', qry , '%') or description like CONCAT('%', qry , '%') )$$

CREATE DEFINER=`fuddusr`@`%` PROCEDURE `searchrestaurants` (IN `qry` TEXT, IN `qry2` TEXT, IN `userid` INT, IN `cty` VARCHAR(150))  NO SQL SELECT id,name,added_by,categoryid,categoryname,tags,shortdescription,location,city,state,description,docuntry,totfav,totbeen,tottry,pincode,phone,lat,lng,fblink,instalink,rating,totreviews,barcode
slug,createdon,updatedon,isperks,isactive,isexclusive,mainimg,subregion,added_by_super,address_1,address_2,created_at,deleted,price,rating_link,tagsid,updated_at,updated_by,updated_by_name,updated_ip,
use_third_party_book_url,use_third_party_check,alternate_phone,booking_url,barcode,
(select IFNULL(iswishlist,0) from wish_try_tested_restaurants where wish_try_tested_restaurants.userid=userid and wish_try_tested_restaurants.restroid=restaurants.id) as iswishlist,
(select IFNULL(istestedlist,0) from wish_try_tested_restaurants where wish_try_tested_restaurants.userid=userid and wish_try_tested_restaurants.restroid=restaurants.id) as isbeenlist, 
(select IFNULL(istrylist,0) from wish_try_tested_restaurants where wish_try_tested_restaurants.userid=userid and wish_try_tested_restaurants.restroid=restaurants.id) as istrylist
FROM restaurants  
WHERE isactive=1 and (city=cty or state=cty) and (name like CONCAT('%', qry , '%') or name like CONCAT('%', qry2 , '%') or description like CONCAT('%', qry , '%') or description like CONCAT('%', qry2 , '%') or shortdescription like CONCAT('%', qry , '%') or shortdescription like CONCAT('%', qry2 , '%') or location like CONCAT('%', qry , '%') or location like CONCAT('%', qry2 , '%') or tags like CONCAT('%', qry , '%') or tags like CONCAT('%', qry2 , '%'))$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `appsetting`
--

CREATE TABLE `appsetting` (
  `id` int(11) NOT NULL,
  `name` varchar(120) DEFAULT NULL,
  `currency` varchar(5) DEFAULT NULL,
  `logo` varchar(200) DEFAULT NULL,
  `footerlogo` varchar(200) DEFAULT NULL,
  `adminlogo` varchar(200) DEFAULT NULL,
  `favicon` varchar(200) DEFAULT NULL,
  `address` varchar(500) DEFAULT NULL,
  `phone` varchar(100) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `orderemail` varchar(150) DEFAULT NULL,
  `addressiframe` varchar(1000) DEFAULT NULL,
  `facebook` varchar(500) DEFAULT NULL,
  `twitter` varchar(500) DEFAULT NULL,
  `instagram` varchar(500) DEFAULT NULL,
  `youtube` varchar(500) DEFAULT NULL,
  `googleplus` varchar(500) DEFAULT NULL,
  `rewardpointvalue` decimal(18,2) NOT NULL DEFAULT 0.00,
  `pg` varchar(500) DEFAULT NULL,
  `pgappkey` varchar(100) DEFAULT NULL,
  `pgseckey` varchar(150) DEFAULT NULL,
  `smsapi` varchar(500) DEFAULT NULL,
  `smsappkey` varchar(100) DEFAULT NULL,
  `smsseckey` varchar(150) DEFAULT NULL,
  `smtp` varchar(50) DEFAULT NULL,
  `port` int(11) NOT NULL DEFAULT 587,
  `fromemail` varchar(120) DEFAULT NULL,
  `fromemailpass` varchar(50) DEFAULT NULL,
  `isssl` int(11) NOT NULL DEFAULT 0,
  `lastinvno` int(11) NOT NULL DEFAULT 0,
  `invprefix` longtext DEFAULT NULL,
  `invpostfix` longtext DEFAULT NULL,
  `invformat` longtext DEFAULT NULL,
  `minorderamt` decimal(18,2) NOT NULL DEFAULT 0.00,
  `createdon` datetime(6) NOT NULL,
  `updatedon` datetime(6) DEFAULT NULL,
  `fcmsenderid` longtext DEFAULT NULL,
  `fcmserverkey` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `appsetting`
--

INSERT INTO `appsetting` (`id`, `name`, `currency`, `logo`, `footerlogo`, `adminlogo`, `favicon`, `address`, `phone`, `email`, `orderemail`, `addressiframe`, `facebook`, `twitter`, `instagram`, `youtube`, `googleplus`, `rewardpointvalue`, `pg`, `pgappkey`, `pgseckey`, `smsapi`, `smsappkey`, `smsseckey`, `smtp`, `port`, `fromemail`, `fromemailpass`, `isssl`, `lastinvno`, `invprefix`, `invpostfix`, `invformat`, `minorderamt`, `createdon`, `updatedon`, `fcmsenderid`, `fcmserverkey`) VALUES
(2, 'Fudd Restaurant', '$', '/resources/appsetting/logo/logo.png', '/resources/appsetting/footerlogo/logo2.png', '/resources/appsetting/logo/text-logo.png', '/resources/appsetting/favicon/favicon.ico', 'PO Box 4433 North Rocks, NSW, 2151 Australia', '0478708356 / 96304610', 'enquiry@fuddapp.com', 'ashutosh@maventechie.com', 'iuyio', 'https://www.facebook.com/fuddapp', NULL, NULL, NULL, NULL, 0.05, NULL, NULL, NULL, NULL, NULL, NULL, 'updategpsmap.com', 587, 'fireworks@updategpsmap.com', 'Fireworks@2022', 1, 582, '2023-', NULL, 'invno', 10.00, '2022-08-09 00:58:06.000000', '2023-07-24 18:51:08.000000', '33705865636', 'AAAAB9kGsaQ:APA91bEVM9wquNyv7GMx_q1IlCoDZAVzVBZwRc6SDhzbCN808erO2_Cl1TcBGDSazo4syUwDUXt6s28_zaK2YCuRBvklqZsuUGAuEDgd2Gjs-Vax9ORFvvaVET9xlzydSx6864q4_Mx8');

-- --------------------------------------------------------

--
-- Table structure for table `beenlist`
--

CREATE TABLE `beenlist` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `restroid` int(11) NOT NULL,
  `createdon` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `beenlist`
--

INSERT INTO `beenlist` (`id`, `userid`, `restroid`, `createdon`) VALUES
(1, 21, 123, '2024-08-01 11:11:56.000000');

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `id` int(11) NOT NULL,
  `name` varchar(200) DEFAULT NULL,
  `parentid` int(11) NOT NULL,
  `country` int(11) NOT NULL,
  `added_by_super` int(11) NOT NULL DEFAULT 0,
  `description` longtext DEFAULT NULL,
  `mainimg` varchar(200) DEFAULT NULL,
  `bannerimg` varchar(200) DEFAULT NULL,
  `metakey` longtext DEFAULT NULL,
  `metatitle` longtext DEFAULT NULL,
  `metadescription` longtext DEFAULT NULL,
  `metarobot` longtext DEFAULT NULL,
  `slug` longtext DEFAULT NULL,
  `createdon` datetime(6) NOT NULL,
  `isactive` int(11) NOT NULL DEFAULT 1,
  `updatedon` datetime(6) DEFAULT NULL,
  `ordering` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`id`, `name`, `parentid`, `country`, `added_by_super`, `description`, `mainimg`, `bannerimg`, `metakey`, `metatitle`, `metadescription`, `metarobot`, `slug`, `createdon`, `isactive`, `updatedon`, `ordering`) VALUES
(1, 'Cuisines', 24, 4, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2024-06-18 08:26:39.000000', 1, '2024-06-18 08:26:39.000000', 1),
(2, 'Occasion', 24, 4, 1, 'Occasion', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2024-08-06 04:46:29.000000', 1, '2024-08-06 04:46:29.000000', 1),
(3, 'Vibes', 24, 4, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2024-06-18 08:26:23.000000', 1, '2024-06-18 08:26:23.000000', 1),
(4, 'Top', 24, 4, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2024-08-09 14:31:03.000000', 1, '2024-08-09 14:31:03.000000', 1);

-- --------------------------------------------------------

--
-- Table structure for table `community`
--

CREATE TABLE `community` (
  `id` int(11) NOT NULL,
  `creatorid` int(11) NOT NULL,
  `restroid` int(11) NOT NULL,
  `creatorname` varchar(200) DEFAULT NULL,
  `title` varchar(300) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `usertype` varchar(20) DEFAULT NULL,
  `totview` int(11) NOT NULL DEFAULT 0,
  `totreply` int(11) NOT NULL DEFAULT 0,
  `totlike` int(11) NOT NULL DEFAULT 0,
  `totdislike` int(11) NOT NULL DEFAULT 0,
  `totshare` int(11) NOT NULL DEFAULT 0,
  `slug` longtext DEFAULT NULL,
  `createdon` datetime(6) NOT NULL,
  `isactive` int(11) NOT NULL DEFAULT 1,
  `lastreply` datetime(6) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `community`
--

INSERT INTO `community` (`id`, `creatorid`, `restroid`, `creatorname`, `title`, `description`, `usertype`, `totview`, `totreply`, `totlike`, `totdislike`, `totshare`, `slug`, `createdon`, `isactive`, `lastreply`, `created_at`, `updated_at`) VALUES
(2, 1, 29, 'joji', 'A place to land, eat, drink and escape real life for a couple of hours', 'We just want our food to make you feel good. From handmade pastas to slow roasted birria, all we’re hoping for is that you’ll taste the love we put into it. If you don’t, we want to know. We’ll keep on striving and creating craveable & approachable dishes, as long as you keep coming back.', 'Customer', 0, 21, 5, 2, 8, 'A_place_to_land,_eat,_drink_and_escape_real_life_for_a_couple_of_hours', '2024-03-13 14:25:48.814666', 1, '2024-09-11 11:34:45.463284', NULL, NULL),
(4, 18, 0, 'Tarun Kumar', 'nice to see the place of bolbune', 'i have visited this palce very nice environment and kids friendly\nthanks team\n', 'Customer', 0, 1, 6, 3, 1, 'nice_to_see_the_place_of_bolbune', '2024-07-16 21:20:03.905595', 1, '2024-07-16 21:22:59.776915', NULL, NULL),
(5, 22, 0, 'Kislay raj', 'Had a visit in Choukram last ight', 'It was a delightful place with polite server and good management.\nFood Was awesome and drinks needs more Recognition', 'Customer', 0, 3, 0, 0, 0, 'Had_a_visit_in_Choukram_last_ight', '2024-09-09 17:55:15.387693', 1, '2024-09-09 18:45:51.137652', NULL, NULL),
(6, 27, 0, 'shivam', 'good taste and friendly staff with on time food service ', 'i really enjoyed my food here with my family, everyone love their food service. I will revisit soon.', 'Customer', 0, 1, 1, 0, 0, 'good_taste_and_friendly_staff_with_on_time_food_service_', '2025-01-09 00:58:11.379579', 1, '2025-02-20 16:30:55.304730', NULL, NULL),
(7, 27, 0, 'shivam', 'good taste and friendly staff with on time food service ', 'i really enjoyed my food here with my family, everyone love their food service. I will revisit soon.', 'Customer', 0, 0, 0, 0, 0, 'good_taste_and_friendly_staff_with_on_time_food_service_', '2025-01-09 00:58:25.997281', 1, NULL, NULL, NULL),
(8, 27, 0, 'shivam', 'good taste and friendly staff with on time food service ', 'i really enjoyed my food here with my family, everyone love their food service. I will revisit soon.', 'Customer', 0, 0, 0, 0, 0, 'good_taste_and_friendly_staff_with_on_time_food_service_', '2025-01-09 00:58:42.429953', 1, NULL, NULL, NULL),
(9, 27, 0, 'shivam', 'good taste and friendly staff ', 'i really enjoyed my food here with my family, everyone love their food service. I will revisit soon.', 'Customer', 0, 0, 0, 0, 0, 'good_taste_and_friendly_staff_', '2025-01-09 00:59:11.057179', 1, NULL, NULL, NULL),
(10, 27, 0, 'shivam', 'good taste and friendly staff ', 'i really enjoyed my food here with my family, everyone love their food service. I will revisit soon.', 'Customer', 0, 0, 0, 0, 1, 'good_taste_and_friendly_staff_', '2025-01-09 00:59:56.388365', 1, NULL, NULL, NULL),
(11, 27, 0, 'shivam', 'great taste ', 'love to eat food here , taste is brilliant 😋 I will revisit here soon.\n', 'Customer', 0, 0, 0, 0, 0, 'great_taste_', '2025-01-09 01:01:08.420903', 1, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `communitydislike`
--

CREATE TABLE `communitydislike` (
  `id` int(11) NOT NULL,
  `communityid` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `createdon` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `communitydislike`
--

INSERT INTO `communitydislike` (`id`, `communityid`, `userid`, `createdon`) VALUES
(3, 2, 14, '2024-07-11 19:28:03.937824'),
(5, 3, 14, '2024-07-11 19:28:10.073944'),
(6, 2, 5, '2024-07-12 10:52:47.762371'),
(12, 4, 18, '2024-07-16 21:28:02.246123'),
(13, 4, 5, '2024-07-19 17:57:57.168482'),
(14, 4, 5, '2024-07-19 17:58:00.106710');

-- --------------------------------------------------------

--
-- Table structure for table `communitylike`
--

CREATE TABLE `communitylike` (
  `id` int(11) NOT NULL,
  `communityid` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `createdon` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `communitylike`
--

INSERT INTO `communitylike` (`id`, `communityid`, `userid`, `createdon`) VALUES
(3, 2, 14, '2024-07-11 19:23:30.242166'),
(5, 2, 14, '2024-07-11 19:27:53.114409'),
(7, 2, 14, '2024-07-11 19:28:04.638049'),
(9, 3, 14, '2024-07-11 19:28:09.495839'),
(11, 2, 5, '2024-07-12 10:52:46.807744'),
(18, 4, 18, '2024-07-16 21:27:48.070308'),
(19, 4, 18, '2024-07-16 21:27:53.619694'),
(20, 4, 18, '2024-07-16 21:28:02.910032'),
(22, 4, 5, '2024-07-19 17:57:59.536671'),
(23, 4, 7, '2024-07-25 21:40:03.452795'),
(24, 4, 7, '2024-07-25 21:40:04.627979'),
(25, 2, 7, '2024-08-10 14:46:38.753947'),
(26, 6, 19, '2025-02-20 16:30:31.284143');

-- --------------------------------------------------------

--
-- Table structure for table `communityreply`
--

CREATE TABLE `communityreply` (
  `id` int(11) NOT NULL,
  `communityid` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `username` varchar(200) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `usertype` varchar(20) DEFAULT NULL,
  `parentid` int(11) NOT NULL DEFAULT 0,
  `totlike` int(11) NOT NULL DEFAULT 0,
  `totdislike` int(11) NOT NULL DEFAULT 0,
  `createdon` datetime(6) NOT NULL,
  `isactive` int(11) NOT NULL DEFAULT 1,
  `lastreply` datetime(6) DEFAULT NULL,
  `is_admin_reply` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `communityreply`
--

INSERT INTO `communityreply` (`id`, `communityid`, `userid`, `username`, `description`, `usertype`, `parentid`, `totlike`, `totdislike`, `createdon`, `isactive`, `lastreply`, `is_admin_reply`, `created_at`, `updated_at`) VALUES
(1, 2, 1, 'joji', 'Yes! very nice.', 'Customer', 0, 0, 0, '2024-03-13 14:47:41.692329', 1, NULL, 0, NULL, NULL),
(2, 2, 0, 'Super Admin', 'Thanks for the considirartion ...', 'Super admin', 24, 0, 0, '2024-05-17 13:16:20.000000', 1, '2024-05-17 13:16:20.000000', 1, NULL, NULL),
(4, 2, 2, 'Fauji', 'GOOD HERE', 'Customer', 24, 0, 0, '2024-05-20 13:00:17.000000', 1, '2024-05-20 13:00:17.000000', 0, NULL, NULL),
(10, 2, 14, 'test', 'xbbx', 'Customer', 0, 0, 0, '2024-07-11 17:45:53.181675', 1, NULL, 0, NULL, NULL),
(11, 2, 14, 'test', 'vzvsv', 'Customer', 10, 0, 0, '2024-07-11 17:59:34.458962', 1, NULL, 0, NULL, NULL),
(12, 2, 14, 'test', 'vzvsv', 'Customer', 0, 0, 0, '2024-07-11 17:59:44.873083', 1, NULL, 0, NULL, NULL),
(13, 2, 14, 'test', 'hiiiii', 'Customer', 0, 0, 0, '2024-07-11 18:02:59.175461', 1, NULL, 0, NULL, NULL),
(14, 2, 14, 'test', 'testing ', 'Customer', 0, 0, 0, '2024-07-11 18:04:01.432391', 1, NULL, 0, NULL, NULL),
(15, 2, 14, 'test', 'testing ', 'Customer', 0, 0, 0, '2024-07-11 18:04:07.806551', 1, NULL, 0, NULL, NULL),
(16, 2, 14, 'test', 'hii', 'Customer', 0, 0, 0, '2024-07-11 18:06:17.030240', 1, NULL, 0, NULL, NULL),
(18, 2, 14, 'test', 'vzgsvsb sggsgsgw sgsgsg sgsgs', 'Customer', 0, 0, 0, '2024-07-11 18:07:24.995053', 1, NULL, 0, NULL, NULL),
(19, 2, 14, 'test', 'dhgdsgs', 'Customer', 0, 0, 0, '2024-07-11 18:07:57.454512', 1, NULL, 0, NULL, NULL),
(20, 2, 14, 'test', 'xvzvvzz', 'Customer', 18, 0, 0, '2024-07-11 18:08:46.275713', 1, NULL, 0, NULL, NULL),
(21, 2, 14, 'test', 'vzzc', 'Customer', 18, 0, 0, '2024-07-11 18:11:54.475983', 1, NULL, 0, NULL, NULL),
(22, 2, 14, 'test', 'xvxv', 'Customer', 19, 0, 0, '2024-07-11 18:12:45.610092', 1, NULL, 0, NULL, NULL),
(23, 2, 14, 'test', NULL, 'Customer', 1, 0, 0, '2024-07-11 18:24:05.763235', 1, NULL, 0, NULL, NULL),
(24, 2, 14, 'test', 'vxvxvxvxvxv', 'Customer', 22, 0, 0, '2024-07-11 18:40:26.543653', 1, NULL, 0, NULL, NULL),
(26, 2, 5, 'ashutosh jha', 'testing by ashutosh', 'Customer', 0, 0, 0, '2024-07-12 10:53:16.145726', 1, NULL, 0, NULL, NULL),
(27, 4, 18, 'Tarun Kumar', 'yes i also feel this', 'Customer', 0, 0, 0, '2024-07-16 21:22:59.758860', 1, NULL, 0, NULL, NULL),
(28, 2, 22, 'Kislay raj', 'Okay is there better dessert ', 'Customer', 0, 0, 0, '2024-08-30 16:13:19.813198', 1, NULL, 0, NULL, NULL),
(31, 2, 0, 'Super Admin', 'Thanks for the responses . Well Appreciated', 'Super admin', 24, 0, 0, '2024-09-09 11:19:22.000000', 1, '2024-09-09 11:19:22.000000', 1, NULL, NULL),
(33, 5, 0, 'Super Admin', 'Appreciated  for your Feedback  . Thanks', 'Super admin', 24, 0, 0, '2024-09-09 12:27:37.000000', 1, '2024-09-09 12:27:37.000000', 1, NULL, NULL),
(34, 5, 22, 'Kislay raj', 'good', 'Customer', 0, 0, 0, '2024-09-09 17:59:12.505073', 1, NULL, 0, NULL, NULL),
(35, 5, 0, 'Super Admin', 'TEST', 'Super admin', 0, 0, 0, '2024-09-09 12:29:22.000000', 1, '2024-09-09 12:29:22.000000', 1, NULL, NULL),
(36, 5, 22, 'Kislay raj', 'red', 'Customer', 34, 0, 0, '2024-09-09 18:05:17.674339', 1, NULL, 0, NULL, NULL),
(37, 4, 0, 'Super Admin', 'TESTdsffdss', 'Super admin', 24, 0, 0, '2024-09-09 12:37:25.000000', 1, '2024-09-09 12:37:25.000000', 1, NULL, NULL),
(39, 5, 0, 'Super Admin', 'Thanks from Fuud support', 'Super admin', 36, 0, 0, '2024-09-10 06:42:19.000000', 1, '2024-09-10 06:42:19.000000', 1, NULL, NULL),
(40, 5, 0, 'Super Admin', 'Thanks', 'Super admin', 34, 0, 0, '2024-09-10 06:47:45.000000', 1, '2024-09-10 06:47:45.000000', 1, NULL, NULL),
(42, 2, 0, 'Super Admin', 'TESTTT', 'Super admin', 31, 0, 0, '2024-09-11 04:52:16.000000', 1, '2024-09-11 04:52:16.000000', 1, NULL, NULL),
(43, 2, 0, 'Super Admin', 'jaipal', 'Super admin', 23, 0, 0, '2024-09-11 04:53:48.000000', 1, '2024-09-11 04:53:48.000000', 1, NULL, NULL),
(44, 2, 0, 'Super Admin', 'jaipal singh', 'Super admin', 1, 0, 0, '2024-09-11 04:56:50.000000', 1, '2024-09-11 04:56:50.000000', 1, NULL, NULL),
(45, 2, 0, 'Super Admin', 'OKay No Issues', 'Super admin', 26, 0, 0, '2024-09-11 06:03:28.000000', 1, '2024-09-11 06:03:28.000000', 1, NULL, NULL),
(47, 4, 0, 'Super Admin', 'Good to Here this @TarunKumar', 'Super admin', 27, 0, 0, '2024-09-18 06:24:49.000000', 1, '2024-09-18 06:24:49.000000', 1, NULL, NULL),
(48, 6, 19, 'Julia', 'what did you like the most? ', 'Customer', 0, 0, 0, '2025-02-20 16:30:55.270962', 1, NULL, 0, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `communityreplydislike`
--

CREATE TABLE `communityreplydislike` (
  `id` int(11) NOT NULL,
  `replyid` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `createdon` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `communityreplylike`
--

CREATE TABLE `communityreplylike` (
  `id` int(11) NOT NULL,
  `replyid` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `createdon` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `communityshare`
--

CREATE TABLE `communityshare` (
  `id` int(11) NOT NULL,
  `communityid` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `createdon` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `communityshare`
--

INSERT INTO `communityshare` (`id`, `communityid`, `userid`, `createdon`) VALUES
(1, 2, 14, '2024-07-11 19:44:25.037936'),
(2, 2, 14, '2024-07-11 19:46:02.593884'),
(3, 2, 5, '2024-07-12 10:53:26.558425'),
(4, 2, 14, '2024-07-15 15:49:45.816563'),
(5, 2, 5, '2024-07-16 21:24:37.708878'),
(6, 2, 5, '2024-07-16 21:24:38.522065'),
(7, 4, 5, '2024-07-19 17:58:51.333808'),
(8, 10, 27, '2025-01-09 01:02:01.092053'),
(9, 2, 14, '2025-08-04 13:07:50.979667'),
(10, 2, 21, '2025-08-05 21:37:38.033526');

-- --------------------------------------------------------

--
-- Table structure for table `contactus`
--

CREATE TABLE `contactus` (
  `id` int(11) NOT NULL,
  `createdon` datetime(6) NOT NULL DEFAULT '0001-01-01 00:00:00.000000',
  `email` longtext DEFAULT NULL,
  `messages` longtext DEFAULT NULL,
  `name` longtext DEFAULT NULL,
  `phone` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `countries`
--

CREATE TABLE `countries` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `country_name` varchar(255) NOT NULL,
  `added_by` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `short_name` varchar(10) DEFAULT NULL,
  `flagimg` varchar(200) DEFAULT NULL,
  `shortname` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `countries`
--

INSERT INTO `countries` (`id`, `country_name`, `added_by`, `created_at`, `updated_at`, `short_name`, `flagimg`, `shortname`) VALUES
(1, 'Spain', '24', '2024-06-14 17:47:10', NULL, 'SP', 'resources/flags/sp-flag.gif', NULL),
(4, 'France', '24', '2024-06-19 08:38:15', '2024-06-19 08:38:15', 'FR', 'resources/flags/1718806095_fr-flag.gif', NULL),
(6, 'United Kingdom', '24', '2024-06-15 17:47:22', NULL, 'UK', 'resources/flags/uk-flag.gif', NULL),
(7, 'India', '24', '2024-06-20 06:24:08', '2024-06-20 06:24:08', 'IN', 'resources/flags/1718884448_india flag.png', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `couponforrestaurant`
--

CREATE TABLE `couponforrestaurant` (
  `id` int(11) NOT NULL,
  `restaurantid` int(11) NOT NULL,
  `couponId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `couponforrestaurant`
--

INSERT INTO `couponforrestaurant` (`id`, `restaurantid`, `couponId`) VALUES
(157, 65, 15),
(158, 64, 15),
(159, 73, 16),
(160, 72, 16),
(161, 71, 16),
(162, 70, 16),
(163, 69, 16),
(164, 68, 16),
(165, 67, 16),
(166, 66, 16),
(167, 65, 16),
(168, 64, 16),
(169, 71, 17),
(176, 72, 20),
(177, 71, 20),
(274, 11, 21),
(275, 64, 21),
(276, 65, 21),
(277, 66, 21),
(278, 67, 21),
(279, 68, 21),
(280, 69, 21),
(281, 70, 21),
(282, 71, 21),
(283, 72, 21),
(284, 86, 21),
(285, 87, 21),
(286, 88, 21),
(287, 89, 21),
(288, 90, 21),
(289, 91, 21),
(290, 92, 21),
(291, 93, 21),
(292, 94, 21),
(293, 95, 21),
(294, 96, 21),
(295, 97, 21),
(296, 98, 21),
(297, 99, 21),
(298, 100, 21),
(299, 101, 21),
(300, 102, 21),
(301, 103, 21),
(302, 104, 21),
(303, 105, 21),
(304, 106, 21),
(305, 108, 21),
(308, 85, 22),
(309, 114, 22),
(310, 123, 23),
(312, 123, 25),
(313, 123, 26),
(314, 123, 27),
(315, 123, 28);

-- --------------------------------------------------------

--
-- Table structure for table `coupons`
--

CREATE TABLE `coupons` (
  `id` int(11) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `restroid` int(11) NOT NULL,
  `country` int(11) NOT NULL,
  `all_restro_selected` enum('0','1') NOT NULL COMMENT '0 for all not selected and 1 for all restro added',
  `all_country_selected` varchar(255) NOT NULL,
  `code` varchar(20) DEFAULT NULL,
  `details` longtext DEFAULT NULL,
  `minorderamt` int(11) NOT NULL DEFAULT 1,
  `maxdiscountamt` int(11) NOT NULL DEFAULT 0,
  `discounttype` varchar(50) DEFAULT NULL,
  `discount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `startdate` datetime(6) NOT NULL,
  `enddate` datetime(6) NOT NULL,
  `createdon` datetime(6) NOT NULL,
  `created_by` int(11) NOT NULL,
  `isactive` int(11) NOT NULL DEFAULT 1,
  `noofusage` int(11) NOT NULL DEFAULT 0,
  `updatedon` datetime(6) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `coupons`
--

INSERT INTO `coupons` (`id`, `type`, `restroid`, `country`, `all_restro_selected`, `all_country_selected`, `code`, `details`, `minorderamt`, `maxdiscountamt`, `discounttype`, `discount`, `startdate`, `enddate`, `createdon`, `created_by`, `isactive`, `noofusage`, `updatedon`, `created_at`, `updated_at`) VALUES
(15, NULL, 0, 0, '0', '', 'fudd_20', '', 1, 0, 'percent', 20.00, '2024-06-04 00:00:00.000000', '2024-12-31 00:00:00.000000', '2024-06-04 00:00:00.000000', 24, 1, 10, NULL, '2024-06-04 08:15:42', '2024-06-04 08:15:42'),
(16, NULL, 0, 0, '0', '', 'WELCOM_FUUD_20', '', 1, 0, 'percent', 20.00, '2024-06-06 00:00:00.000000', '2024-12-31 00:00:00.000000', '2024-06-06 00:00:00.000000', 24, 1, 20, NULL, '2024-06-06 01:25:11', '2024-06-06 01:25:11'),
(17, 'unlimited', 0, 0, '0', '', 'CP', '', 1, 0, 'amount', 120.00, '2024-06-14 00:00:00.000000', '2024-10-30 00:00:00.000000', '2024-06-14 00:00:00.000000', 24, 1, 0, NULL, '2024-06-14 01:25:07', '2024-06-14 01:25:07'),
(20, 'unlimited', 0, 0, '0', '0', 'NEWREST10', '', 1, 0, 'percent', 20.00, '2024-06-20 00:00:00.000000', '2024-12-31 00:00:00.000000', '2024-06-20 00:00:00.000000', 24, 1, 0, NULL, '2024-06-20 00:16:41', '2024-06-20 00:16:41'),
(21, 'unlimited', 0, 0, '1', '0', 'New Opening', '10% details for coupon', 1, 0, 'percent', 10.00, '2024-08-06 00:00:00.000000', '2024-11-27 00:00:00.000000', '2024-08-06 00:00:00.000000', 24, 1, 1, NULL, '2024-08-06 01:01:36', '2024-08-07 06:29:18'),
(22, NULL, 0, 0, '1', '0', 'Welcome5', 'Get 5 % discount for new user', 1, 0, 'percent', 5.00, '2024-08-10 00:00:00.000000', '2024-09-30 00:00:00.000000', '2024-08-10 00:00:00.000000', 24, 1, 1, NULL, '2024-08-10 01:15:42', '2024-08-10 01:16:07'),
(23, NULL, 0, 0, '0', '0', 'RAD_20', '', 1, 0, 'percent', 20.00, '2024-08-13 00:00:00.000000', '2024-12-31 00:00:00.000000', '2024-08-13 00:00:00.000000', 24, 1, 5, NULL, '2024-08-13 07:03:24', '2024-08-13 07:03:24'),
(25, NULL, 0, 0, '0', '0', 'R1', '', 1, 0, 'percent', 20.00, '2024-08-21 00:00:00.000000', '2024-09-21 00:00:00.000000', '2024-08-21 00:00:00.000000', 24, 1, 2, NULL, '2024-08-21 08:33:40', '2024-08-21 08:33:40'),
(26, 'unlimited', 0, 0, '0', '0', 'THIRD_1', '', 1, 0, 'percent', 40.00, '2024-09-02 00:00:00.000000', '2024-10-02 00:00:00.000000', '2024-09-02 00:00:00.000000', 24, 1, 0, NULL, '2024-09-02 02:20:36', '2024-09-02 02:20:36'),
(27, 'unlimited', 0, 0, '0', '0', 'THIRD_1_2', '', 1, 0, 'percent', 20.00, '2024-09-02 00:00:00.000000', '2024-10-02 00:00:00.000000', '2024-09-02 00:00:00.000000', 24, 1, 0, NULL, '2024-09-02 03:48:36', '2024-09-02 03:48:36'),
(28, NULL, 0, 0, '0', '0', 'THIRD_1_3', '', 1, 0, 'percent', 12.00, '2024-09-02 00:00:00.000000', '2024-10-02 00:00:00.000000', '2024-09-02 00:00:00.000000', 24, 1, 2, NULL, '2024-09-02 03:49:06', '2024-09-02 03:49:06');

-- --------------------------------------------------------

--
-- Table structure for table `couponsuses`
--

CREATE TABLE `couponsuses` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `bookid` int(11) DEFAULT NULL,
  `restroid` int(11) NOT NULL,
  `couponid` int(11) NOT NULL,
  `createdon` datetime(6) NOT NULL,
  `updatedon` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `couponsuses`
--

INSERT INTO `couponsuses` (`id`, `userid`, `bookid`, `restroid`, `couponid`, `createdon`, `updatedon`) VALUES
(1, 21, 1, 123, 25, '2024-08-29 13:36:57.000000', '2024-08-29 13:36:57.000000'),
(2, 22, 2, 108, 21, '2024-08-30 09:59:27.000000', '2024-08-30 09:59:27.000000'),
(3, 18, 6, 123, 23, '2024-09-02 07:56:25.000000', '2024-09-02 07:56:25.000000');

-- --------------------------------------------------------

--
-- Table structure for table `coupons_city`
--

CREATE TABLE `coupons_city` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `city` varchar(255) NOT NULL,
  `couponId` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `coupons_city`
--

INSERT INTO `coupons_city` (`id`, `city`, `couponId`, `created_at`, `updated_at`) VALUES
(4, 'Paris', 21, '2024-08-07 06:29:18', '2024-08-07 06:29:18'),
(6, 'Noida', 22, '2024-08-10 01:16:07', '2024-08-10 01:16:07'),
(7, 'Paris', 23, '2024-08-13 07:03:24', '2024-08-13 07:03:24'),
(8, 'Paris', 24, '2024-08-21 07:52:18', '2024-08-21 07:52:18'),
(9, 'Paris', 25, '2024-08-21 08:33:40', '2024-08-21 08:33:40'),
(10, 'Paris', 26, '2024-09-02 02:20:36', '2024-09-02 02:20:36'),
(11, 'Paris', 27, '2024-09-02 03:48:36', '2024-09-02 03:48:36'),
(12, 'Paris', 28, '2024-09-02 03:49:06', '2024-09-02 03:49:06');

-- --------------------------------------------------------

--
-- Table structure for table `coupons_country`
--

CREATE TABLE `coupons_country` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `countryId` int(11) NOT NULL,
  `couponId` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `coupons_country`
--

INSERT INTO `coupons_country` (`id`, `countryId`, `couponId`, `created_at`, `updated_at`) VALUES
(1, 1, 18, NULL, NULL),
(2, 4, 18, NULL, NULL),
(3, 6, 18, NULL, NULL),
(4, 1, 19, NULL, NULL),
(5, 4, 19, NULL, NULL),
(6, 1, 20, NULL, NULL),
(7, 4, 20, NULL, NULL),
(11, 4, 21, NULL, NULL),
(13, 7, 22, NULL, NULL),
(14, 4, 23, NULL, NULL),
(15, 4, 24, NULL, NULL),
(16, 4, 25, NULL, NULL),
(17, 4, 26, NULL, NULL),
(18, 4, 27, NULL, NULL),
(19, 4, 28, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `customer_email_change_otp`
--

CREATE TABLE `customer_email_change_otp` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `cust_id` int(11) NOT NULL,
  `cust_change_email_id` varchar(255) NOT NULL,
  `otp_temp` varchar(100) NOT NULL,
  `otp_expired_time` varchar(255) NOT NULL,
  `cust_is_otp_verified_change` enum('0','1') NOT NULL DEFAULT '0',
  `deleted` enum('0','1') NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `customer_email_change_otp`
--

INSERT INTO `customer_email_change_otp` (`id`, `cust_id`, `cust_change_email_id`, `otp_temp`, `otp_expired_time`, `cust_is_otp_verified_change`, `deleted`, `created_at`, `updated_at`) VALUES
(11, 17, 'kislayraj69@gmail.com', '992191', '1712818611', '1', '1', NULL, NULL),
(12, 19, 'kislayrajai06@gmail.com', '507382', '1712927405', '1', '1', NULL, NULL),
(13, 22, 'kislayrajai06@gmail.com', '704241', '1713534927', '0', '0', NULL, NULL),
(14, 22, 'kislayrajjai06@gmail.com', '461917', '1713534979', '0', '0', NULL, NULL),
(15, 22, 'kislayrajai06@gmail.com', '542781', '1713535110', '0', '0', NULL, NULL),
(16, 22, 'kislayrajai06@gmail.com', '461772', '1713535680', '0', '0', NULL, NULL),
(17, 22, 'kislayrajai06@gmail.com', '247163', '1713535687', '0', '0', NULL, NULL),
(18, 22, 'kislayrajai06@gmail.com', '681509', '1713535745', '0', '0', NULL, NULL),
(19, 22, 'kislayrajai06@gmail.com', '186638', '1713535917', '0', '0', NULL, NULL),
(20, 22, 'kislayrajai06@gmail.com', '545885', '1713535996', '0', '0', NULL, NULL),
(21, 22, 'kislayraj69@gmail.com', '282554', '1713877595', '0', '0', NULL, NULL),
(22, 22, 'kislayrajai06@gmail.com', '927376', '1713878605', '', '', NULL, NULL),
(23, 24, 'kislayraj69@gmail.com', '697062', '1724219340', '0', '0', NULL, NULL),
(24, 24, 'kislayraj69@gmail.com', '801551', '1724319334', '0', '0', NULL, NULL),
(25, 24, 'kislayraj69@gmail.com', '261326', '1724320353', '0', '0', NULL, NULL),
(26, 24, 'jaianimator@gmail.com', '404992', '1724320445', '0', '0', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `dailysalesreport`
--

CREATE TABLE `dailysalesreport` (
  `id` int(11) NOT NULL,
  `date` datetime(6) NOT NULL,
  `total_sales` decimal(18,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `emailtemplate`
--

CREATE TABLE `emailtemplate` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `french_title` varchar(255) DEFAULT NULL,
  `french_description` longtext DEFAULT NULL,
  `spanish_title` varchar(255) DEFAULT NULL,
  `spanish_description` longtext DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `emailtemplate`
--

INSERT INTO `emailtemplate` (`id`, `title`, `description`, `french_title`, `french_description`, `spanish_title`, `spanish_description`, `created_at`, `updated_at`) VALUES
(1, 'Booking', '<p>Hello&nbsp;<span style=\\\"&quot;&quot;color:&quot;\\\" var(--bs-body-color);=\\\"&quot;&quot;\\\" letter-spacing:=\\\"&quot;&quot;\\\" 0.5px;=\\\"&quot;&quot;\\\" font-weight:=\\\"&quot;&quot;\\\" var(--bs-body-font-weight);=\\\"&quot;&quot;\\\" text-align:=\\\"&quot;&quot;\\\" var(--bs-body-text-align);=\\\"&quot;&quot;\\\" display:=\\\"&quot;&quot;\\\" inline=\\\"&quot;&quot;\\\" !important;\\\"=\\\"&quot;&quot;\\\">[[first_name]]</span><span style=\\\"&quot;&quot;letter-spacing:&quot;\\\" 0.7px;=\\\"&quot;&quot;\\\" color:=\\\"&quot;&quot;\\\" var(--bs-body-color);=\\\"&quot;&quot;\\\" font-weight:=\\\"&quot;&quot;\\\" var(--bs-body-font-weight);=\\\"&quot;&quot;\\\" text-align:=\\\"&quot;&quot;\\\" var(--bs-body-text-align);=\\\"&quot;&quot;\\\" display:=\\\"&quot;&quot;\\\" inline=\\\"&quot;&quot;\\\" !important;\\\"=\\\"&quot;&quot;\\\">,</span></p><p>Thank you for making a reservation. You booking id is&nbsp;<span style=\\\"&quot;&quot;color:&quot;\\\" var(--bs-body-color);=\\\"&quot;&quot;\\\" letter-spacing:=\\\"&quot;&quot;\\\" 0.5px;=\\\"&quot;&quot;\\\" font-weight:=\\\"&quot;&quot;\\\" var(--bs-body-font-weight);=\\\"&quot;&quot;\\\" text-align:=\\\"&quot;&quot;\\\" var(--bs-body-text-align);=\\\"&quot;&quot;\\\" display:=\\\"&quot;&quot;\\\" inline=\\\"&quot;&quot;\\\" !important;\\\"=\\\"&quot;&quot;\\\">[[bookingId]]</span><span style=\\\"&quot;&quot;letter-spacing:&quot;\\\" 0.7px;=\\\"&quot;&quot;\\\" color:=\\\"&quot;&quot;\\\" var(--bs-body-color);=\\\"&quot;&quot;\\\" font-weight:=\\\"&quot;&quot;\\\" var(--bs-body-font-weight);=\\\"&quot;&quot;\\\" text-align:=\\\"&quot;&quot;\\\" var(--bs-body-text-align);=\\\"&quot;&quot;\\\" display:=\\\"&quot;&quot;\\\" inline=\\\"&quot;&quot;\\\" !important;\\\"=\\\"&quot;&quot;\\\">.</span></p><p>We are expecting you on [[bookingdatetime]] .</p><p>We look forward to your visit and hope we will be enjoying your meal experience at [[restaurantName]] as much as we will be enjoying your company.</p><p>See you very soon,</p><p><span style=\\\"&quot;&quot;letter-spacing:&quot;\\\" 0.5px;=\\\"&quot;&quot;\\\" display:=\\\"&quot;&quot;\\\" inline=\\\"&quot;&quot;\\\" !important;\\\"=\\\"&quot;&quot;\\\">If you have any questions, please contact us at anytime.</span><br style=\\\"&quot;&quot;letter-spacing:&quot;\\\" 0.5px;\\\"=\\\"&quot;&quot;\\\"><br style=\\\"&quot;&quot;letter-spacing:&quot;\\\" 0.5px;\\\"=\\\"&quot;&quot;\\\"><span style=\\\"&quot;&quot;letter-spacing:&quot;\\\" 0.5px;=\\\"&quot;&quot;\\\" display:=\\\"&quot;&quot;\\\" inline=\\\"&quot;&quot;\\\" !important;\\\"=\\\"&quot;&quot;\\\"><b>Kind Regards,</b></span><br style=\\\"&quot;&quot;letter-spacing:&quot;\\\" 0.5px;\\\"=\\\"&quot;&quot;\\\"><span style=\\\"&quot;&quot;letter-spacing:&quot;\\\" 0.5px;\\\"=\\\"&quot;&quot;\\\">Fuud Support Team</span><br></p><p></p><p></p><br><br>', 'Réservation', '<p>Bonjour [[prenom]],<br><br>Merci d\\\'avoir fait une réservation. Votre identifiant de réservation est [[id_reservation]].<br><br>Nous vous attendons le [[date_heure_reservation]].<br><br>Nous\r\n attendons avec impatience votre visite et espérons que nous \r\napprécierons votre expérience culinaire au [[nom_restaurant]] autant que\r\n nous apprécierons votre compagnie.<br><br>à très bientôt<br><br>Si vous avez des questions, veuillez nous contacter à tout moment.<br><br><b>Salutations,</b><br>Équipe de soutien alimentaire </p>', 'Reservarce', '<p>Hola [[nombre_completo]] ,<br><br>Gracias por hacer una reserva. Su ID de reserva es&nbsp;[[id_reserva]] .<br><br>Te esperamos el [[fecha_hora_reserva]]<br><br>Esperamos su visita y esperamos disfrutar su experiencia gastronómica en&nbsp;[[nombre_restaurante]] tanto como disfrutaremos de su compañía.<br><br>Te veré muy pronto,<br><br>Si tiene alguna pregunta, comuníquese con nosotros en cualquier momento.<br><br><b>Atentamente ,</b><br>Equipo de soporte de Fuud</p><p><br></p><p><br></p><br><br><br><br>', '2024-04-26 03:33:00', '2024-08-08 07:50:19'),
(2, 'User Signup', '<p>Hello [[fullname]] ,<br><br>Your Account has been successfully Created .</p><p><br></p><p>Please Feel Free to contact our support team .</p><p><b>Kind regards ,</b></p><p>FUUD Team<br><br></p>', 'Inscription de l\\\'utilisateur', '<p>Bonjour [[nom_complet]],<br><br>Votre compte à été créé avec succès .<br><br><br>N\\\'hésitez pas à contacter notre équipe d\\\'assistance.<br><br>Cordialement ,<br><br>L\\\'équipe FUUD&nbsp;&nbsp; <br><br><br></p>', 'Registro de usuario', '<p>Hola [[nombre_completo]] ,<br><br>Su cuenta ha sido creada satisfactoriamente .<br><br><br>No dude en ponerse en contacto con nuestro equipo de soporte.<br><br>Atentamente ,<br><br>Equipo FUUD<br></p><br><br><p></p>', '2024-04-29 00:11:47', '2024-08-08 07:51:51'),
(3, 'Forgot Password', '<p></p><p><span style=\\\"&quot;&quot;vertical-align:&quot;\\\">Dear <br></span><br></p>[[fullname]] ,<p></p><p>You have navigated towards the forgotten password option.</p>', 'Mot de passe oublié', '<p>Cher<br>[[nom_complet]] ,<br><br>Vous êtes enraciné vers un mot de passe oublié.<br></p><br><br><p></p>', 'Has olvidado tu contraseña', '<p>Estimado<br>[[nombre_completo]] ,<br><br>Has rooteado hacia una contraseña olvidada.<br></p><br><br><p></p>', '2024-04-29 00:15:14', '2024-08-08 07:46:57'),
(4, 'Change Password', '<p><span style=\\\"&quot;&quot;vertical-align:&quot;\\\">Dear&nbsp; <br></span>[[fullname]] ,</p><p>Your Password Has Been Changed <span role=\\\"&quot;heading&quot;\\\" aria-level=\\\"&quot;1&quot;\\\" class=\\\"&quot;yKMVIe&quot;\\\">Successfully .<br></span></p>', 'Changer le mot de passe', '<p>Cher&nbsp; [[nom_complet]] ,<br><br>Votre mot de passe a été changé avec succès .<br></p><br><br><p></p>', 'cambiar la contraseña', '<p>Estimado [[nombre_completo]] ,<br><br>Tu contraseña ha sido cambiada exitosamente .<br></p><br><br><p></p>', '2024-04-29 00:16:40', '2024-08-08 07:53:06'),
(5, 'Restaurant Add', '<p></p><p>Dear <br></p>[[fullname]] ,<p></p><p><br></p><p>Your Restaurant&nbsp;&nbsp; [[restaurantname]] Has been successfully added .</p><p><br></p><p>Kind Regards ,</p><p>Fuud Team<br></p>', 'Restaurant Ajouter', '<p>Cher </p><p>[[nom_complet]] ,<br><br><br><br>Votre restaurant&nbsp;[[nom_restaurant]] &nbsp; a été ajouté avec succès.<br><br><br>Cordialement ,<br><br>L\\\'équipe Fuud</p><br>', 'Restaurante Añadir', 'Estimado<br>[[nombre_completo]] ,<br><br><br>Su restaurante&nbsp;[[nombre_restaurante]] se ha agregado correctamente.<br><br><br>Atentamente ,<br><br>equipo fuud&nbsp;&nbsp;&nbsp; <br><br>', '2024-04-29 01:39:42', '2024-08-10 01:34:45'),
(6, 'Restaurant Update', '<p>Dear&nbsp; [[fullname]] ,<br><br>We are excited to announce that your [[restaurantname]] has has been updated&nbsp; .<br><br>Thank you for your continued support, and we look forward to serving you soon!<br><br>Warm regards, &nbsp;<br>FUUD&nbsp; Team<br><br>&nbsp;</p>', 'Mise à jour du restaurant', '<p>Cher&nbsp;[[nom_complet]] ,<br><br>Nous sommes ravis d\\\'annoncer que votre [[nom_restaurant]] a été mis à jour.<br><br>Merci pour votre soutien continu et nous avons hâte de vous servir bientôt&nbsp;!<br><br>Cordialement, &nbsp;<br>L\\\'équipe FUUD</p><br><br><p></p><br>', 'Actualización del restaurante', '<p>Estimado&nbsp;[[nombre_completo]] ,<br><br>Nos complace anunciar que su [[nombre_restaurante]] se ha actualizado.<br><br>¡Gracias por su continuo apoyo y esperamos poder servirle pronto!<br><br>Un cordial saludo, &nbsp;<br>Equipo FUUD<br></p><br><p></p>', '2024-04-30 02:07:41', '2024-08-10 01:35:17'),
(7, 'Profile Update', '<p><p>Dear <br></p>[[fullname]]&nbsp; ,</p><p><br></p><p>Your Profile Details Has been Updated Successfully .<br></p>', 'Mise à jour du profil', '<p>Cher<br>[[nom_complet]] ,<br><br><br>Les détails de votre profil ont été mis à jour avec succès.<br></p><br><br><p></p>', 'Perfil actualizado', '<p>Estimado<br>[[nombre_completo]] ,<br><br><br>Los detalles de su perfil se han actualizado correctamente.<br></p><br><br><p></p>', '2024-04-30 02:13:13', '2024-08-08 07:53:57'),
(8, 'Contact Us', '<p><br></p>[[sub_title]][[name]][[gender_salutation]][[email]][[reset_link]]', NULL, NULL, NULL, NULL, '2024-04-30 02:31:01', '2024-07-24 05:08:02');

-- --------------------------------------------------------

--
-- Table structure for table `faq`
--

CREATE TABLE `faq` (
  `id` int(11) NOT NULL,
  `title` varchar(200) DEFAULT NULL,
  `details` longtext DEFAULT NULL,
  `files` varchar(200) DEFAULT NULL,
  `createdon` datetime(6) NOT NULL,
  `updatedon` datetime(6) DEFAULT NULL,
  `isactive` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `faqquestion`
--

CREATE TABLE `faqquestion` (
  `id` int(11) NOT NULL,
  `details` longtext DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `language` varchar(255) NOT NULL,
  `createdon` datetime(6) NOT NULL,
  `isactive` int(11) NOT NULL DEFAULT 1,
  `updatedon` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `faqquestion`
--

INSERT INTO `faqquestion` (`id`, `details`, `title`, `language`, `createdon`, `isactive`, `updatedon`) VALUES
(6, '<p>User can register themselves on Fuud Mobile. Then login to use Fuud App.</p>', 'How to use Fuud App?', 'english', '2024-08-06 05:20:50.000000', 1, '2024-08-06 05:20:50.000000'),
(7, '<p>User should register themselves on Fuud if they are regular user of Fuud. They can register themselves on Fudd App by install IOS or Android App. They to go to Login option click on ‘You Don’t Have An Account Yet? Sign Up’.</p>', 'How to sign up as a new user?', 'english', '2024-08-06 05:20:19.000000', 1, '2024-08-06 05:20:19.000000'),
(8, '<p>To place order on Fudd you don’t have to register yourself on Fuud. You can’t place order directly. You need to contact with Fuud support team they will help you to place order as a guest.</p>', 'Can user place order if user is not registered on Fuud?', 'english', '2024-08-06 05:21:48.000000', 1, '2024-08-06 05:21:48.000000'),
(9, '<p>To search restaurants in particular city is very simple with Fuud App. Enter preferred city name in search bar and click on search. All restaurant listed in searched city will be display. Or you can change the city from the app and see the all restaurants in particular city.</p>', 'How to search city wise restaurant?', 'english', '2024-08-06 05:22:29.000000', 1, '2024-08-06 05:22:29.000000'),
(10, '<p>Anyone can start their restaurant business online within few minutes. Contact to Fuud support team. They will help to list your business online.</p>', 'How to register restaurant on Fuud App?', 'english', '2024-08-06 05:22:59.000000', 1, '2024-08-06 05:22:59.000000'),
(11, '<p>On Fuud App you can also find restaurant according to your choice of cuisine. Enter cuisine in search bar and click on search. All restaurant listed in searched cuisine will be display.</p>', 'How to search restaurant for particular cuisine?', 'english', '2024-08-06 05:23:34.000000', 1, '2024-08-06 05:23:34.000000'),
(12, '<p>There are multiple ways to go on particular restaurant page. Search restaurant city wise or cuisine wise or tags wise and click on restaurant from list and directly go to restaurant details page.</p>', 'How to go on particular restaurant page?', 'english', '2024-08-06 05:25:01.000000', 1, '2024-08-06 05:25:01.000000'),
(13, '<p>On Fuud App user can also provide rating to restaurant so that other user will able to view those review. Go to any restaurant page and scroll down to view reviews/rating of that particular restaurant.</p>', 'How to view reviews for particular restaurant?', 'english', '2024-08-06 05:26:26.000000', 1, '2024-08-06 05:26:26.000000'),
(14, '<p>User can register themselves on Fuud Mobile. Then login to use Fuud App.</p>', 'How to use Fuud App?', 'french', '2024-08-06 05:20:50.000000', 1, '2024-08-06 05:20:50.000000'),
(15, '<p>User should register themselves on Fuud if they are regular user of Fuud. They can register themselves on Fudd App by install IOS or Android App. They to go to Login option click on ‘You Don’t Have An Account Yet? Sign Up’.</p>', 'How to sign up as a new user?', 'french', '2024-08-06 05:20:19.000000', 1, '2024-08-06 05:20:19.000000'),
(16, '<p>To place order on Fudd you don’t have to register yourself on Fuud. You can’t place order directly. You need to contact with Fuud support team they will help you to place order as a guest.</p>', 'Can user place order if user is not registered on Fuud?', 'french', '2024-08-06 05:21:48.000000', 1, '2024-08-06 05:21:48.000000'),
(17, '<p>To search restaurants in particular city is very simple with Fuud App. Enter preferred city name in search bar and click on search. All restaurant listed in searched city will be display. Or you can change the city from the app and see the all restaurants in particular city.</p>', 'How to search city wise restaurant?', 'french', '2024-08-06 05:22:29.000000', 1, '2024-08-06 05:22:29.000000'),
(18, '<p>Anyone can start their restaurant business online within few minutes. Contact to Fuud support team. They will help to list your business online.</p>', 'How to register restaurant on Fuud App?', 'french', '2024-08-06 05:22:59.000000', 1, '2024-08-06 05:22:59.000000'),
(19, '<p>On Fuud App you can also find restaurant according to your choice of cuisine. Enter cuisine in search bar and click on search. All restaurant listed in searched cuisine will be display.</p>', 'How to search restaurant for particular cuisine?', 'french', '2024-08-06 05:23:34.000000', 1, '2024-08-06 05:23:34.000000'),
(20, '<p>There are multiple ways to go on particular restaurant page. Search restaurant city wise or cuisine wise or tags wise and click on restaurant from list and directly go to restaurant details page.</p>', 'How to go on particular restaurant page?', 'french', '2024-08-06 05:25:01.000000', 1, '2024-08-06 05:25:01.000000'),
(21, '<p>On Fuud App user can also provide rating to restaurant so that other user will able to view those review. Go to any restaurant page and scroll down to view reviews/rating of that particular restaurant.</p>', 'How to view reviews for particular restaurant?', 'french', '2024-08-06 05:26:26.000000', 1, '2024-08-06 05:26:26.000000'),
(22, '<p>User can register themselves on Fuud Mobile. Then login to use Fuud App.</p>', 'How to use Fuud App?', 'spanish', '2024-08-06 05:20:50.000000', 1, '2024-08-06 05:20:50.000000'),
(23, '<p>User should register themselves on Fuud if they are regular user of Fuud. They can register themselves on Fudd App by install IOS or Android App. They to go to Login option click on ‘You Don’t Have An Account Yet? Sign Up’.</p>', 'How to sign up as a new user?', 'spanish', '2024-08-06 05:20:19.000000', 1, '2024-08-06 05:20:19.000000'),
(24, '<p>To place order on Fudd you don’t have to register yourself on Fuud. You can’t place order directly. You need to contact with Fuud support team they will help you to place order as a guest.</p>', 'Can user place order if user is not registered on Fuud?', 'spanish', '2024-08-06 05:21:48.000000', 1, '2024-08-06 05:21:48.000000'),
(25, '<p>To search restaurants in particular city is very simple with Fuud App. Enter preferred city name in search bar and click on search. All restaurant listed in searched city will be display. Or you can change the city from the app and see the all restaurants in particular city.</p>', 'How to search city wise restaurant?', 'spanish', '2024-08-06 05:22:29.000000', 1, '2024-08-06 05:22:29.000000'),
(26, '<p>Anyone can start their restaurant business online within few minutes. Contact to Fuud support team. They will help to list your business online.</p>', 'How to register restaurant on Fuud App?', 'spanish', '2024-08-06 05:22:59.000000', 1, '2024-08-06 05:22:59.000000'),
(27, '<p>On Fuud App you can also find restaurant according to your choice of cuisine. Enter cuisine in search bar and click on search. All restaurant listed in searched cuisine will be display.</p>', 'How to search restaurant for particular cuisine?', 'spanish', '2024-08-06 05:23:34.000000', 1, '2024-08-06 05:23:34.000000'),
(28, '<p>There are multiple ways to go on particular restaurant page. Search restaurant city wise or cuisine wise or tags wise and click on restaurant from list and directly go to restaurant details page.</p>', 'How to go on particular restaurant page?', 'spanish', '2024-08-06 05:25:01.000000', 1, '2024-08-06 05:25:01.000000'),
(29, '<p>On Fuud App user can also provide rating to restaurant so that other user will able to view those review. Go to any restaurant page and scroll down to view reviews/rating of that particular restaurant.</p>', 'How to view reviews for particular restaurant?', 'spanish', '2024-08-06 05:26:26.000000', 1, '2024-08-06 05:26:26.000000');

-- --------------------------------------------------------

--
-- Table structure for table `fuud_booking_logs`
--

CREATE TABLE `fuud_booking_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `rest_id` int(11) NOT NULL,
  `no_of_guests` int(11) NOT NULL,
  `book_date` date NOT NULL,
  `slot_day` varchar(255) NOT NULL,
  `total_seats` int(11) NOT NULL DEFAULT 0,
  `busy_seats` int(11) NOT NULL,
  `avail_seats` int(11) NOT NULL,
  `added_by` int(11) NOT NULL,
  `updated_by` int(11) NOT NULL,
  `updated_ip` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `fuud_booking_logs`
--

INSERT INTO `fuud_booking_logs` (`id`, `rest_id`, `no_of_guests`, `book_date`, `slot_day`, `total_seats`, `busy_seats`, `avail_seats`, `added_by`, `updated_by`, `updated_ip`, `created_at`, `updated_at`) VALUES
(1, 123, 1, '2024-08-29', 'thursday', 20, 1, 19, 24, 24, '49.47.132.111', '2024-08-29 08:06:57', '2024-08-29 08:06:57'),
(2, 108, 2, '2024-09-02', 'monday', 8, 2, 6, 0, 0, '152.59.133.223', '2024-08-30 04:29:27', '2024-08-30 04:29:27'),
(3, 108, 1, '2024-08-31', 'saturday', 8, 1, 7, 0, 0, '152.58.191.43', '2024-08-30 08:19:36', '2024-08-30 08:19:36'),
(4, 110, 1, '2024-09-04', 'wednesday', 14, 1, 13, 24, 24, '49.47.132.135', '2024-08-31 04:56:30', '2024-08-31 04:56:30'),
(5, 110, 1, '2024-09-09', 'monday', 14, 1, 13, 0, 0, '152.59.143.204', '2024-08-31 05:08:04', '2024-08-31 05:08:04'),
(6, 123, 1, '2024-09-04', 'wednesday', 20, 0, 20, 24, 24, '49.47.132.135', '2024-09-02 02:26:25', '2024-09-02 02:26:25'),
(7, 165, 1, '2024-09-12', 'thursday', 50, 0, 50, 0, 0, '49.47.132.135', '2024-09-08 23:39:36', '2024-09-08 23:39:36'),
(8, 114, 1, '2025-01-08', 'wednesday', 24, 1, 23, 0, 0, '223.178.213.240', '2025-01-08 05:03:28', '2025-01-08 05:03:28'),
(9, 114, 1, '2025-01-09', 'thursday', 24, 5, 19, 0, 0, '117.224.199.18', '2025-01-08 13:22:19', '2025-01-08 13:30:00');

-- --------------------------------------------------------

--
-- Table structure for table `fuud_booking_management`
--

CREATE TABLE `fuud_booking_management` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` varchar(255) NOT NULL,
  `is_reg` int(11) NOT NULL DEFAULT 0,
  `no_of_guests` int(11) NOT NULL DEFAULT 0,
  `rest_id` int(11) NOT NULL DEFAULT 0,
  `booking_fname` varchar(255) NOT NULL,
  `booking_lname` varchar(255) NOT NULL,
  `booking_email` varchar(255) NOT NULL,
  `booking_phone` varchar(255) NOT NULL,
  `booking_city` varchar(255) NOT NULL,
  `booking_state` varchar(255) DEFAULT NULL,
  `booking_country` varchar(255) NOT NULL,
  `is_self` varchar(255) NOT NULL DEFAULT 'Yes',
  `booking_unique_id` varchar(255) NOT NULL DEFAULT 'N/A',
  `time_slot` varchar(255) NOT NULL,
  `table_id` int(11) DEFAULT NULL,
  `bussiness_hour_day` varchar(255) NOT NULL,
  `bussiness_hour_time` varchar(255) NOT NULL,
  `booked_date` date NOT NULL DEFAULT '2024-05-03',
  `total_price` varchar(255) DEFAULT NULL,
  `added_by` int(11) NOT NULL,
  `deleted` enum('0','1') NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `fuud_booking_management`
--

INSERT INTO `fuud_booking_management` (`id`, `user_id`, `is_reg`, `no_of_guests`, `rest_id`, `booking_fname`, `booking_lname`, `booking_email`, `booking_phone`, `booking_city`, `booking_state`, `booking_country`, `is_self`, `booking_unique_id`, `time_slot`, `table_id`, `bussiness_hour_day`, `bussiness_hour_time`, `booked_date`, `total_price`, `added_by`, `deleted`, `created_at`, `updated_at`) VALUES
(1, '21', 1, 1, 123, 'Dhruv', 'Jha', 'dhruv2jha@gmail.com', '9876543212', 'Paris', NULL, 'France', 'Yes', 'RADDHR1724938617Pechyw', 'thursday', 0, 'thursday', '09:45:00', '2024-08-29', 'N/A', 24, '0', '2024-08-29 08:06:57', '2024-08-29 08:06:57'),
(2, '22', 1, 2, 108, 'Kislay', 'raj', 'kislayraj69@gmail.com', 'N/A', 'Paris', 'Paris', 'France', 'Yes', 'LA KIS1725011967ApMS7h', '09:00:00', 0, 'monday', '09:00:00', '2024-09-02', 'N/A', 0, '0', '2024-08-30 04:29:27', '2024-08-30 04:29:27'),
(3, '22', 1, 1, 108, 'Virat', 'Kohli', 'kislayraj69@gmail.com', '9304512323', 'Paris', 'Paris', 'France', 'No', 'LA VIR1725025776Yg59qE', '09:45:00', 0, 'saturday', '09:45:00', '2024-08-31', 'N/A', 0, '0', '2024-08-30 08:19:36', '2024-08-30 08:19:36'),
(4, '26', 0, 1, 110, 'Francis', 'Menon', 'kislay.raj.maventechie@gmail.com', '9876543212', 'Eure', NULL, 'France', 'Yes', 'MINFRA1725099990ykQpkD', 'wednesday', 0, 'wednesday', '18:10:00', '2024-09-04', 'N/A', 24, '0', '2024-08-31 04:56:30', '2024-08-31 04:56:30'),
(5, '22', 1, 1, 110, 'Ravi', 'Gupta', 'kislayraj69@gmail.com', '93045123213', 'Paris', 'Paris', 'France', 'No', 'MINRAV17251006846JGdEw', '21:45:00', 0, 'monday', '21:45:00', '2024-09-09', 'N/A', 0, '0', '2024-08-31 05:08:04', '2024-08-31 05:08:04'),
(6, '18', 1, 1, 123, 'Tarun', 'Kumar', 'tarunmandal.1288@yahoo.com', 'N/A', '0', '0', '0', 'Yes', 'RADTAR1725263785O3qNl1', '10:30:00', 0, 'wednesday', '10:30:00', '2024-09-04', 'N/A', 24, '1', '2024-09-02 02:26:25', '2024-09-02 02:26:51'),
(7, '22', 1, 1, 165, 'Kislay', 'raj', 'kislayraj69@gmail.com', 'N/A', 'Paris', 'Paris', 'France', 'Yes', 'TESKIS1725858576u0C5QF', '21:15:00', 0, 'thursday', '21:15:00', '2024-09-12', 'N/A', 0, '1', '2024-09-08 23:39:36', '2024-09-08 23:41:50'),
(8, '27', 1, 1, 114, 'shivam', 'Sharma', 'shivam.sharma@maventechie.com', 'N/A', 'Noida', 'null', 'India', 'Yes', 'JHASHI1736332408L8OyHC', '18:00:00', 0, 'wednesday', '18:00:00', '2025-01-08', 'N/A', 0, '0', '2025-01-08 05:03:28', '2025-01-08 05:03:28'),
(9, '27', 1, 1, 114, 'shivam', '', 'shivam.sharma@maventechie.com', 'N/A', '0', '0', '0', 'Yes', 'JHASHI1736362339AA71lj', '20:15:00', 0, 'thursday', '20:15:00', '2025-01-09', 'N/A', 0, '0', '2025-01-08 13:22:19', '2025-01-08 13:22:19'),
(10, '27', 1, 1, 114, '', '', '', 'N/A', '0', 'null', 'India', 'Yes', '0', '18:00:00', 0, 'thursday', '18:00:00', '2025-01-09', 'N/A', 0, '0', '2025-01-08 13:27:20', '2025-01-08 13:27:20'),
(11, '27', 1, 1, 114, '', '', '', 'N/A', '0', 'null', 'India', 'Yes', '0', '18:00:00', 0, 'thursday', '18:00:00', '2025-01-09', 'N/A', 0, '0', '2025-01-08 13:27:24', '2025-01-08 13:27:24'),
(12, '27', 1, 1, 114, '', '', '', 'N/A', '0', 'null', 'India', 'Yes', '0', '18:00:00', 0, 'thursday', '18:00:00', '2025-01-09', 'N/A', 0, '0', '2025-01-08 13:28:19', '2025-01-08 13:28:19'),
(13, '27', 1, 1, 114, 'Shivam', 'Sharma', 'shivam.sharma@maventechie.com', 'N/A', '0', 'null', 'India', 'Yes', 'JHASHI1736362800BWqJT3', '18:00:00', 0, 'thursday', '18:00:00', '2025-01-09', 'N/A', 0, '0', '2025-01-08 13:30:00', '2025-01-08 13:30:00');

-- --------------------------------------------------------

--
-- Table structure for table `fuud_customer_details`
--

CREATE TABLE `fuud_customer_details` (
  `cust_id` bigint(20) UNSIGNED NOT NULL,
  `cust_first_name` varchar(100) NOT NULL,
  `cust_last_name` varchar(100) NOT NULL,
  `cust_email_id` varchar(255) NOT NULL,
  `cust_phone_no` varchar(100) NOT NULL,
  `cust_password` varchar(100) NOT NULL,
  `cust_bio` varchar(255) DEFAULT NULL,
  `cust_profile_pic` varchar(255) DEFAULT NULL,
  `cust_country` varchar(255) DEFAULT NULL,
  `cust_country_id` int(11) NOT NULL DEFAULT 0,
  `cust_state` varchar(255) DEFAULT NULL,
  `cust_city` varchar(255) NOT NULL,
  `cust_postal` varchar(255) DEFAULT NULL,
  `type` int(11) NOT NULL DEFAULT 2,
  `added_by_super` enum('0','1') NOT NULL DEFAULT '0',
  `super_admin_id` int(11) NOT NULL DEFAULT 0,
  `device_token` varchar(255) DEFAULT NULL,
  `deleted` int(11) NOT NULL,
  `added_on` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `fuud_customer_details`
--

INSERT INTO `fuud_customer_details` (`cust_id`, `cust_first_name`, `cust_last_name`, `cust_email_id`, `cust_phone_no`, `cust_password`, `cust_bio`, `cust_profile_pic`, `cust_country`, `cust_country_id`, `cust_state`, `cust_city`, `cust_postal`, `type`, `added_by_super`, `super_admin_id`, `device_token`, `deleted`, `added_on`, `created_at`, `updated_at`, `deleted_at`) VALUES
(6, 'Supp', 'Mavens', 'supp.maven@yahoo.mail', '9876543211', '$2y$12$BaD28SdDeKu2YyZ/oAE64OvGRRWh4NEbxf6qbP8uX68HbRTq3NrJi', 'TECHIE OWNER TEST', 'resources/profileImage/1724222872_pro1.jpg', 'France', 4, 'Paris', 'Paris', '123451', 2, '1', 24, NULL, 0, '2024-08-05 22:59:20', '2024-04-03 00:58:31', '2024-08-21 01:17:52', NULL),
(22, 'Kislay', 'maven', 'kislay.raj@maventechie.com', '9898989898', '$2y$12$.p.AQZWDGVMHBvFCesN2Tee1HpaJ2zB/b4fCvkVRHnZ0G4i3QG3jW', '', 'resources/profileImage/1723037173_1717417408(3).jpg', 'France', 4, 'Paris', 'Paris', '', 2, '1', 24, NULL, 0, '2024-08-07 07:56:13', '2024-04-19 07:36:39', '2024-08-07 07:56:14', NULL),
(24, 'Super', 'Admin', 'kislay.raj.maventechie@gmail.com', '9898980000', '$2y$12$kFutLoLsQEeZXN3QQFgviuPXsIGnhTvKNjCJhEX2xN8WqIPqenpza', 'Super Admin', NULL, 'spain', 1, '', '', '', 1, '0', 0, 'fZYc3VkeVBT_BtuwIma4Nc:APA91bFgsaY-f1kG7IHKXcBiUV7s44qbh-3tWpcO7UdBc2NgrrPXb6-E_YjfyWtR3tYILWgkHnYfqXtiz6j8sp84TmNELkRoNzl3sgloB6DomnjHnjanARhzH3jikGuZj0Hx8-Bp34UA', 0, '2024-05-08 23:54:51', '2024-05-08 23:54:51', '2024-08-08 08:51:07', NULL),
(40, 'Tarun', 'Kumar', 'tarunmandal.1289@yahoo.com', '8447880910', '$2y$12$pGdyU5cvCsO33dKxpy8YqOtc4JNkoMXggIeSJTvtKTapb01KnGa.K', 'Here are the details.', NULL, 'India', 7, 'Uttar Pradesh', 'Noida', '201301', 2, '1', 24, NULL, 0, '2024-06-20 06:39:51', '2024-06-20 06:39:51', '2024-06-20 06:39:51', NULL),
(41, 'Test', 'Owner', 'test@aol.com', '0000000000', '$2y$12$sF5HJSxTZzyCUGa564J2TOsMfprAoIwpUu9Xvk1JO0yk7pgUiu5YC', '', NULL, 'Spain', 1, 'Madrid', 'Madrid', '28001', 2, '1', 24, NULL, 0, '2024-07-26 01:41:41', '2024-07-26 01:41:41', '2024-07-26 01:41:41', NULL),
(42, 'Ashutosh', 'Kumar', 'ashutosh@maventechie.com', '9953509796', '$2y$12$vzrZcdg9dN1ZxpYE5PmqYe9buETq/7KvDnboTbmSBBzU9pOGWY3lu', '', 'resources/profileImage/1723532106_pro1.jpg', 'India', 7, 'Uttar Pradesh', 'Ghaziabad', '201009', 2, '1', 24, NULL, 0, '2024-08-13 01:25:06', '2024-08-09 01:06:36', '2024-08-13 01:25:06', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `fuud_cust_otp`
--

CREATE TABLE `fuud_cust_otp` (
  `otp_id` bigint(20) UNSIGNED NOT NULL,
  `cust_id` int(11) NOT NULL,
  `cust_otp_no` varchar(255) NOT NULL,
  `cust_otp_expiration_time` varchar(255) NOT NULL,
  `cust_is_otp_verified` enum('0','1') NOT NULL DEFAULT '0',
  `deleted` enum('0','1') NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `fuud_cust_otp`
--

INSERT INTO `fuud_cust_otp` (`otp_id`, `cust_id`, `cust_otp_no`, `cust_otp_expiration_time`, `cust_is_otp_verified`, `deleted`, `created_at`, `updated_at`) VALUES
(1, 1, '687390', '1712065855', '1', '1', '2024-04-02 08:16:55', '2024-04-02 08:17:34'),
(2, 2, '619190', '1712123639', '0', '0', '2024-04-03 00:20:00', '2024-04-03 00:20:00'),
(3, 3, '263346', '1712123906', '0', '0', '2024-04-03 00:24:26', '2024-04-03 00:24:26'),
(4, 4, '464025', '1712125248', '0', '0', '2024-04-03 00:46:48', '2024-04-03 00:46:48'),
(5, 5, '413366', '1712125461', '1', '1', '2024-04-03 00:50:21', '2024-04-03 00:50:55'),
(6, 6, '716993', '1712125951', '1', '1', '2024-04-03 00:58:31', '2024-04-03 00:58:59'),
(8, 8, '840052', '1712208318', '1', '1', '2024-04-03 23:51:18', '2024-04-03 23:52:14'),
(9, 10, '403933', '1712731958', '1', '1', '2024-04-10 01:18:38', '2024-04-10 01:19:29'),
(10, 15, '566236', '1712736252', '1', '1', '2024-04-10 02:30:12', '2024-04-10 02:30:44'),
(11, 16, '963476', '1712736897', '1', '1', '2024-04-10 02:40:57', '2024-04-10 02:41:27'),
(12, 17, '363884', '1712737399', '1', '1', '2024-04-10 02:49:20', '2024-04-10 02:50:26'),
(13, 18, '956405', '1712925712', '1', '1', '2024-04-12 07:07:53', '2024-04-12 07:08:57'),
(14, 19, '982681', '1712927224', '1', '1', '2024-04-12 07:33:04', '2024-04-12 07:33:47'),
(15, 20, '405725', '1713379479', '1', '1', '2024-04-17 13:10:39', '2024-04-17 13:11:34'),
(16, 21, '401946', '1713521464', '1', '1', '2024-04-19 04:37:04', '2024-04-19 04:38:26'),
(17, 22, '458333', '1713532239', '1', '1', '2024-04-19 07:36:39', '2024-04-19 07:37:56'),
(18, 35, '259558', '1715576912', '1', '1', '2024-05-12 23:34:33', '2024-05-12 23:35:09'),
(19, 24, '105793', '1724320122', '0', '0', NULL, NULL),
(20, 24, '386104', '1724320263', '0', '0', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `fuud_push_notification`
--

CREATE TABLE `fuud_push_notification` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `msg_title` varchar(255) NOT NULL,
  `msg_body` varchar(255) NOT NULL,
  `country` varchar(255) NOT NULL,
  `city` varchar(255) DEFAULT NULL,
  `users_id` longtext DEFAULT NULL,
  `added_by_super` int(11) NOT NULL,
  `added_by` int(11) NOT NULL,
  `sent_ip_addr` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `fuud_push_notification`
--

INSERT INTO `fuud_push_notification` (`id`, `msg_title`, `msg_body`, `country`, `city`, `users_id`, `added_by_super`, `added_by`, `sent_ip_addr`, `created_at`, `updated_at`) VALUES
(21, 'Explore our new cuisine with 20% extra this weekend', 'Explore our new cuisine with 20% extra this weekendExplore our new cuisine with 20% extra this weekend', 'France', 'Paris', '22', 1, 1, '49.47.132.120', '2024-08-30 23:32:43', NULL),
(22, 'Get 5% discount for booking', 'user code welcome5', 'India', 'Noida', '24', 1, 1, '103.46.200.147', '2024-09-16 12:11:29', NULL),
(23, 'Get 5% discount for booking', 'test5', 'India', 'Noida', '21', 1, 1, '103.46.200.147', '2024-09-16 12:14:09', NULL),
(24, 'Only Testing One Time Send Message', 'THIS Message will not be saved', 'France', 'Paris', '22', 1, 1, '49.47.132.135', '2024-09-16 12:17:39', NULL),
(25, 'Testing2', 'Testing only', 'India', 'Noida', '21', 1, 1, '192.168.1.1', '2024-09-16 12:25:15', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `fuud_registered_users`
--

CREATE TABLE `fuud_registered_users` (
  `reg_user_id` bigint(20) UNSIGNED NOT NULL,
  `reg_user_fname` varchar(255) NOT NULL,
  `reg_user_lname` varchar(255) NOT NULL,
  `reg_user_email` varchar(255) NOT NULL,
  `reg_user_phone` varchar(255) NOT NULL,
  `no_of_guests` int(11) NOT NULL,
  `country_id` int(11) NOT NULL,
  `country` varchar(255) NOT NULL,
  `state` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `rest_id` int(11) NOT NULL,
  `is_reg` enum('0','1','2') NOT NULL DEFAULT '0',
  `is_end_user` enum('0','1','2') NOT NULL DEFAULT '0',
  `added_by` int(11) NOT NULL,
  `deleted` enum('0','1') NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `fuud_registered_users`
--

INSERT INTO `fuud_registered_users` (`reg_user_id`, `reg_user_fname`, `reg_user_lname`, `reg_user_email`, `reg_user_phone`, `no_of_guests`, `country_id`, `country`, `state`, `city`, `rest_id`, `is_reg`, `is_end_user`, `added_by`, `deleted`, `created_at`, `updated_at`) VALUES
(110, 'Ashutosh', 'Kumar', 'ashu@aol.com', '9953509796', 2, 0, 'France', 'Paris', 'Paris', 72, '0', '1', 0, '0', '2024-06-14 02:28:03', '2024-06-14 02:28:03'),
(111, 'joji', '', 'jojijoji891@gmail.com', 'N/A', 1, 0, 'France', 'Paris', 'Paris', 70, '1', '0', 0, '0', '2024-06-20 08:22:16', '2024-06-20 08:22:16'),
(112, 'Olatz', 'Test', 'olatz_aurrekoetxea@yahoo.com', '603434210', 3, 0, 'Spain', 'Madrid', 'Madrid', 72, '0', '0', 0, '0', '2024-07-21 12:51:48', '2024-07-21 12:51:48');

-- --------------------------------------------------------

--
-- Table structure for table `fuud_restaurant_users`
--

CREATE TABLE `fuud_restaurant_users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `parent_id` int(11) NOT NULL,
  `user_first_name` varchar(255) NOT NULL,
  `user_last_name` varchar(255) NOT NULL,
  `user_phone` varchar(255) DEFAULT NULL,
  `user_email` varchar(255) NOT NULL,
  `user_password` varchar(255) NOT NULL,
  `user_bio` longtext NOT NULL,
  `user_profile_pic` varchar(255) NOT NULL DEFAULT 'N/A',
  `user_rest_mapping` varchar(255) NOT NULL,
  `user_rest_name` varchar(255) NOT NULL,
  `user_type` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `fuud_restaurant_users`
--

INSERT INTO `fuud_restaurant_users` (`id`, `parent_id`, `user_first_name`, `user_last_name`, `user_phone`, `user_email`, `user_password`, `user_bio`, `user_profile_pic`, `user_rest_mapping`, `user_rest_name`, `user_type`, `created_at`, `updated_at`) VALUES
(3, 22, 'Ben', 'Stokes Eng', '9898989891', 'benstokes12@gmail.com', '$2y$12$yLThSzxlcRgT/WWeLhkCE.SE0NRp8IfhmvDijGWFUFiGIQfWPEcYi', 'N/A', 'N/A', '28,43,45', 'El berio,PurneaRest5,DELETE1', '3', '2024-04-29 07:03:06', '2024-04-29 08:11:13'),
(4, 22, 'Munchiss', 'Leh', '9898981111', 'munchisleh@gmail.com', '$2y$12$yBH3CNDxQFbGs6jtdyIoued.iaNBuur0nVl1y4NOughEjiDWmdxv6', 'User Here Bio .', 'N/A', '28,29', 'El berio,Est Emrads', '3', '2024-04-30 00:00:21', '2024-05-01 00:50:21'),
(5, 6, 'Shivam', 'Dube', '9898989898', 'hivamdube@gmail.com', '$2y$12$z0bjXVFs2j94QO4O3JSSzuATbhQhm2o6SWOt/xiIlK47J9TLxjr1q', 'Restaurnat Users', '1714500247_pro2.jpeg', '11,12', 'PurneaRest5,PurneaRest6', '3', '2024-04-30 07:00:17', '2024-04-30 12:34:07'),
(6, 22, 'User', 'Test', '9876787878', 'kislaayraj@gmail.com', '$2y$12$0kpFXSbzS3D4JYcQD3H69uEbT/CM.kyQ9xxU30Li2qW.kO5dZSIMO', 'N/A', 'N/A', '110', 'Mine_Rest1', '3', '2024-08-08 08:13:17', '2024-08-08 08:13:17'),
(7, 6, 'Shivam', 'Dubey', '9876787678', 'shivamdube@gmail.com', '$2y$12$xdbM0U5vX.y0Iy6xwg63m.jFbkZT7KFfWkxoFE8hr.moz22Q.vksW', 'N/A', 'resources/profileImage/1724225667_pro4.jpg', '123,72,71', 'Choukran,Boubale,Radisun Blue', '3', '2024-08-21 00:32:31', '2024-08-21 07:42:59');

-- --------------------------------------------------------

--
-- Table structure for table `fuud_tags`
--

CREATE TABLE `fuud_tags` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `parentid` int(11) DEFAULT NULL,
  `tag_name` varchar(255) NOT NULL,
  `added_by_super` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `fuud_tags`
--

INSERT INTO `fuud_tags` (`id`, `parentid`, `tag_name`, `added_by_super`, `created_at`, `updated_at`) VALUES
(30, 24, 'Italian', 0, '2024-06-04 07:33:45', '2024-06-04 07:33:45'),
(32, 24, 'Corsica', 0, '2024-06-06 00:14:11', '2024-06-06 00:14:11'),
(33, 24, 'Corse', 0, '2024-06-06 00:16:08', '2024-06-06 00:16:08'),
(34, 24, 'Mediterranean', 0, '2024-06-06 00:17:18', '2024-06-06 00:17:18'),
(35, 24, 'Méditerranéen', 0, '2024-06-06 00:20:00', '2024-06-06 00:20:00'),
(36, 24, 'French Cuisine', 0, '2024-06-06 00:23:25', '2024-06-06 00:23:25'),
(37, 24, 'francaise', 0, '2024-06-06 00:23:39', '2024-06-06 00:23:39'),
(38, 24, 'Cuisine', 0, '2024-06-06 00:23:39', '2024-06-06 00:23:39'),
(39, 24, 'Japonese', 0, '2024-06-06 00:28:43', '2024-06-06 00:28:43'),
(40, 24, 'Japonais', 0, '2024-06-06 00:31:34', '2024-06-06 00:31:34'),
(41, 24, 'Moroccan', 0, '2024-06-06 00:36:15', '2024-06-06 00:36:15'),
(42, 24, 'Marocain', 0, '2024-06-06 00:36:15', '2024-06-06 00:36:15'),
(43, 24, 'Europe de l\\\'Est', 0, '2024-06-06 00:44:07', '2024-06-06 00:44:07'),
(44, 24, 'Eastern', 0, '2024-06-06 00:44:07', '2024-06-06 00:44:07'),
(45, 24, 'European', 0, '2024-06-06 00:44:07', '2024-06-06 00:44:07'),
(47, 24, 'India Vibes', 0, '2024-06-20 06:45:13', '2024-06-20 06:45:13'),
(48, 24, 'finedining', 0, '2024-07-25 22:50:53', '2024-07-25 22:50:53'),
(49, 24, 'localproducts', 0, '2024-07-25 22:50:53', '2024-07-25 22:50:53'),
(50, 24, 'uniqueexperience', 0, '2024-07-25 22:50:53', '2024-07-25 22:50:53'),
(51, 24, 'michelinstyle', 0, '2024-07-25 22:50:53', '2024-07-25 22:50:53'),
(52, 24, 'perfectforadate', 0, '2024-07-25 22:50:53', '2024-07-25 22:50:53'),
(53, 24, 'nicedecor', 0, '2024-07-25 22:50:53', '2024-07-25 22:50:53'),
(56, 24, 'instagramfamous', 0, '2024-07-25 23:23:01', '2024-07-25 23:23:01'),
(57, 24, 'idealwithfriends', 0, '2024-07-25 23:23:01', '2024-07-25 23:23:01'),
(58, 24, 'greatatmosphere', 0, '2024-07-25 23:23:01', '2024-07-25 23:23:01'),
(59, 24, 'fuud favourite', 0, '2024-07-25 23:23:01', '2024-07-25 23:23:01'),
(61, 24, 'fivestarservice', 0, '2024-07-25 23:23:01', '2024-07-25 23:23:01'),
(62, 24, 'openlate', 0, '2024-07-25 23:23:01', '2024-07-25 23:23:01'),
(63, 24, 'delishop', 0, '2024-07-25 23:39:49', '2024-07-25 23:39:49'),
(64, 24, 'tastingtable', 0, '2024-07-25 23:39:49', '2024-07-25 23:39:49'),
(65, 24, 'epiceriefine', 0, '2024-07-25 23:39:49', '2024-07-25 23:39:49'),
(66, 24, 'traiteuravectables', 0, '2024-07-25 23:39:49', '2024-07-25 23:39:49'),
(67, 24, 'authenticfood', 0, '2024-07-25 23:39:49', '2024-07-25 23:39:49'),
(68, 24, 'frenchcuisine', 0, '2024-07-25 23:39:49', '2024-07-25 23:39:49'),
(69, 24, 'intimateexperience', 0, '2024-07-25 23:39:49', '2024-07-25 23:39:49'),
(71, 24, 'heeselover', 0, '2024-07-25 23:39:49', '2024-07-25 23:39:49'),
(73, 24, 'inedinging', 0, '2024-07-25 23:55:16', '2024-07-25 23:55:16'),
(76, 24, 'partyplace', 0, '2024-07-25 23:55:16', '2024-07-25 23:55:16'),
(78, 24, 'celebration', 0, '2024-07-25 23:55:16', '2024-07-25 23:55:16'),
(79, 24, 'ethnicfood', 0, '2024-07-25 23:55:16', '2024-07-25 23:55:16'),
(80, 24, 'warmatmosphere', 0, '2024-07-25 23:55:16', '2024-07-25 23:55:16'),
(81, 24, 'nicebar', 0, '2024-07-25 23:55:16', '2024-07-25 23:55:16'),
(82, 24, 'cocktaillover', 0, '2024-07-25 23:55:16', '2024-07-25 23:55:16'),
(95, 24, 'lebanese', 0, '2024-07-26 00:08:46', '2024-07-26 00:08:46'),
(97, 24, 'sharingplates', 0, '2024-07-26 00:08:46', '2024-07-26 00:08:46'),
(100, 24, 'kidsfriendly', 0, '2024-07-26 00:08:46', '2024-07-26 00:08:46'),
(101, 24, 'budgetfriendly', 0, '2024-07-26 00:08:46', '2024-07-26 00:08:46'),
(104, 24, 'veganoptions', 0, '2024-07-26 00:14:01', '2024-07-26 00:14:01'),
(105, 24, 'japonesefood', 0, '2024-07-26 00:14:01', '2024-07-26 00:14:01'),
(107, 24, 'takeaway', 0, '2024-07-26 00:14:01', '2024-07-26 00:14:01'),
(108, 24, 'rooftop', 0, '2024-07-26 00:19:33', '2024-07-26 00:19:33'),
(113, 24, 'summervibe', 0, '2024-07-26 00:19:33', '2024-07-26 00:19:33'),
(118, 24, 'freshpasta', 0, '2024-07-26 00:24:44', '2024-07-26 00:24:44'),
(120, 24, 'vegan', 0, '2024-07-26 00:24:44', '2024-07-26 00:24:44'),
(123, 24, 'winebar', 0, '2024-07-26 00:34:30', '2024-07-26 00:34:30'),
(124, 24, 'greatatmosphe', 0, '2024-07-26 00:34:30', '2024-07-26 00:34:30'),
(125, 24, 'goodwine', 0, '2024-07-26 00:34:30', '2024-07-26 00:34:30'),
(126, 24, 'intimate', 0, '2024-07-26 00:34:30', '2024-07-26 00:34:30'),
(128, 24, 'naturalwine', 0, '2024-07-26 00:34:30', '2024-07-26 00:34:30'),
(129, 24, 'music', 0, '2024-07-26 00:34:30', '2024-07-26 00:34:30'),
(134, 24, 'barwithaview', 0, '2024-07-26 00:38:24', '2024-07-26 00:38:24'),
(137, 24, 'breakfast', 0, '2024-07-26 00:41:50', '2024-07-26 00:41:50'),
(139, 24, 'patio', 0, '2024-07-26 00:41:50', '2024-07-26 00:41:50'),
(161, 24, 'solodinner', 0, '2024-07-26 00:53:51', '2024-07-26 00:53:51'),
(168, 24, 'ramen', 0, '2024-07-26 00:57:08', '2024-07-26 00:57:08'),
(203, 24, 'healthyfood', 0, '2024-07-26 01:17:57', '2024-07-26 01:17:57'),
(207, 24, 'cosy', 0, '2024-07-26 01:17:57', '2024-07-26 01:17:57'),
(231, 24, 'brunch', 0, '2024-07-26 04:02:10', '2024-07-26 04:02:10'),
(233, 24, 'cosytest1', 0, '2024-08-09 00:46:02', '2024-08-09 00:46:02'),
(234, 6, 'cosyrita', 0, '2024-08-09 00:54:42', '2024-08-09 00:54:42'),
(236, 0, 'test123', 0, '2024-08-12 08:10:46', '2024-08-12 08:10:46'),
(237, 0, 'thaifood nicedecor', 0, '2024-09-03 02:26:42', '2024-09-03 02:26:42'),
(238, 0, 'thaifood', 0, '2024-09-03 02:26:42', '2024-09-03 02:26:42'),
(239, 0, 'localprodcts', 0, '2024-09-03 02:31:46', '2024-09-03 02:31:46'),
(240, 0, 'happyhour', 0, '2024-09-03 02:31:46', '2024-09-03 02:31:46'),
(241, 0, 'lactosefree', 0, '2024-09-03 02:31:46', '2024-09-03 02:31:46'),
(242, 0, 'glutenfree', 0, '2024-09-03 02:31:46', '2024-09-03 02:31:46'),
(243, NULL, 'terrasse', 0, '2024-09-03 04:01:33', '2024-09-03 04:01:33'),
(244, NULL, 'fuudfavourite', 0, '2024-09-03 04:01:33', '2024-09-03 04:01:33'),
(245, 24, 'italianfood', 0, '2024-09-03 05:08:12', '2024-09-03 05:08:12'),
(246, 24, 'seafood', 0, '2024-09-03 05:25:58', '2024-09-03 05:25:58');

-- --------------------------------------------------------

--
-- Table structure for table `fuud_user_roles`
--

CREATE TABLE `fuud_user_roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `type` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `fuud_user_roles`
--

INSERT INTO `fuud_user_roles` (`id`, `type`, `created_at`, `updated_at`) VALUES
(1, 'Super Admin', '2024-05-17 08:24:51', '2024-05-17 08:24:51'),
(2, 'Admin', '2024-05-17 08:24:51', '2024-05-17 08:24:51'),
(3, 'User', '2024-05-17 08:24:51', '2024-05-17 08:24:51');

-- --------------------------------------------------------

--
-- Table structure for table `gototrylist`
--

CREATE TABLE `gototrylist` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `restroid` int(11) NOT NULL,
  `createdon` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `gototrylist`
--

INSERT INTO `gototrylist` (`id`, `userid`, `restroid`, `createdon`) VALUES
(1, 21, 108, '2024-08-30 11:12:50.000000'),
(2, 21, 106, '2024-08-06 11:13:08.000000'),
(3, 24, 108, '2024-08-29 11:13:53.000000'),
(4, 24, 104, '2024-08-25 11:14:26.000000'),
(5, 22, 93, '2024-08-25 11:14:26.000000');

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(6, '2024_04_01_093633_create_fuud_customer_details_table', 2),
(7, '2024_04_01_095018_create_fuud_cust_otp_table', 2),
(8, '2024_04_02_074450_alter_to_fuud_cust_otp', 2),
(11, '2024_04_04_123944_alter_to_restaurants', 3),
(12, '2024_04_05_161821_create_restaurant_tables', 4),
(15, '2024_04_08_095839_create_restaurant_shift_schedule', 5),
(19, '2024_04_08_095847_create_restaurant_shift_timing', 6),
(21, '2024_04_10_054736_alter_to_fuud_customer_details', 7),
(24, '2024_04_11_053525_create_customer_email_change__o_t_p', 8),
(28, '2024_04_11_141903_create_restaurant_tables_occupied_status', 10),
(31, '2024_04_11_092404_create_booking_management', 12),
(32, '2024_04_12_072844_alter_to_fuud_booking_management', 13),
(33, '2024_04_13_091114_alter_to_restaurant_shift_schedule', 14),
(37, '2024_04_14_124753_create_restaurant_business_hours', 15),
(39, '2024_04_15_125614_alter_to_fuud_booking_management', 17),
(40, '2024_04_15_093114_create_fuud_registered_users', 18),
(42, '2024_04_15_182236_alter_to_fuud_booking_management', 19),
(44, '2024_04_16_105414_alter_to_restaurant_business_hours', 20),
(45, '2024_04_17_102605_alter_to_restaurant_tables', 21),
(46, '2024_04_17_182717_alter_to_fuud_customer_details', 22),
(48, '2024_04_19_084839_alter_to_fuud_customer_details', 23),
(49, '2024_04_24_130937_alter_to_restaurants', 24),
(50, '2024_04_25_072448_alter_to_restaurant_business_hours', 25),
(52, '2024_04_26_104140_alter_to_restaurants', 26),
(53, '2024_04_24_175631_alter_to_restaurants', 27),
(57, '2024_04_29_063634_create_fuud_restaurant_users', 28),
(59, '2024_04_30_062305_alter_to_fuud_customer_details', 29),
(61, '2024_04_30_120832_alter_to_fuud_restaurant_users', 30),
(63, '2024_05_01_053204_alter_to_restaurants', 31),
(64, '2024_05_01_063231_alter_to_restaurants', 32),
(65, '2024_05_03_064906_alter_to_fuud_registered_users', 33),
(66, '2024_05_03_070243_alter_to_fuud_booking_management', 34),
(67, '2024_05_03_114124_alter_to_fuud_booking_management', 35),
(69, '2024_05_04_123059_create_fuud_booking_logs', 36),
(70, '2024_05_04_150729_alter_to_fuud_booking_logs', 37),
(71, '2024_05_04_151152_alter_to_fuud_booking_logs', 38),
(73, '2024_05_09_070226_alter_to_fudd_customer_details', 39),
(75, '2024_05_09_123123_alter_to_category', 40),
(76, '2024_05_09_133632_alter_to_restaurants', 41),
(77, '2024_05_10_060134_alter_to_fuud_registered_users', 42),
(81, '2024_05_10_154146_alter_to_coupons', 43),
(82, '2024_05_13_060939_create_fuud_push_notification', 44),
(84, '2024_05_13_110913_alter_to_fuud_customer_details', 45),
(85, '2024_05_13_114228_create_jobs_table', 46),
(86, '2024_05_14_054425_create_smart_ads_tracking_table', 47),
(87, '2024_05_14_055354_create_smart_ads_table', 48),
(88, '2024_05_14_055436_create_smart_ads_tracking_table', 48),
(89, '2024_05_14_064557_create_smart_ads_table', 49),
(90, '2024_05_14_064558_create_smart_ads_tracking_table', 49),
(94, '2024_05_14_081547_create_smart_ads', 50),
(100, '2024_05_15_051926_create_fuud_tags', 51),
(102, '2024_05_16_052250_alter_to_restaurantreview', 52),
(104, '2024_05_17_062815_alter_to_community', 53),
(105, '2024_05_17_064248_alter_to_communityreply', 53),
(107, '2024_05_17_064850_alter_to_communityreply', 54),
(109, '2024_05_17_093835_alter_to_community', 55),
(110, '2024_05_17_134113_create_seeder_track_list', 56),
(112, '2024_05_17_135329_create_to_fuud_user_roles', 57),
(115, '2024_05_21_062643_alter_to_restroads', 58),
(116, '2024_05_21_132209_alter_to_restroads', 59),
(117, '2024_05_22_060051_alter_to_couponforrestaurant', 60),
(119, '2024_05_22_090115_alter_to_coupons', 61),
(121, '2024_05_23_070021_alter_to_restaurant_shift_timing', 62),
(122, '2024_05_23_113346_alter_to_couponsuses', 63),
(123, '2024_05_29_071402_create_countries', 64),
(124, '2024_05_29_103816_alter_to_category', 65),
(125, '2024_05_30_050601_alter_to_restaurants', 66),
(127, '2024_05_30_064644_alter_to_restaurant_tables_occupied_status', 67),
(128, '2024_05_30_101709_alter_to_restaurants', 68),
(129, '2024_05_31_101502_alter_to_restaurants', 69),
(130, '2024_05_31_120906_alter_to_fuud_customer_details', 70),
(131, '2024_06_01_095136_alter_to_restaurants', 71),
(135, '2024_06_03_075831_alter_to_restaurantmenu', 72),
(136, '2024_06_14_051440_alter_to_restaurants', 73),
(137, '2024_06_14_115318_alter_to_coupons', 74),
(138, '2024_06_14_123435_alter_to_fuud_registered_users', 74),
(139, '2024_06_17_074009_alrter_to_fudd_customer_details', 74),
(140, '2024_06_17_113605_alter_to_fuud_push_notification', 74),
(141, '2024_06_19_063243_create_coupons_country', 75),
(142, '2024_06_19_145527_alter_to_coupons', 76),
(143, '2024_07_23_052000_alter_to_restaurantmenu', 77),
(144, '2024_07_23_103058_alter_to_restroads', 77),
(145, '2024_07_24_085912_alter_to_termsandconditions', 78),
(146, '2024_07_24_115822_alter_to_privacypolicy', 79),
(147, '2024_07_26_103734_alter_to_fuud_booking_management', 80),
(148, '2024_07_26_104036_alter_to_user', 80),
(149, '2024_07_27_095924_alter_to_fuud_booking_management', 80),
(150, '2024_07_29_131613_create_coupons_city', 81),
(151, '2024_07_30_102101_alter_to_restroads', 81),
(152, '2024_07_30_135419_alter_to_restroads', 82),
(153, '2024_08_01_044716_alter_to_fuud_booking_management', 82),
(154, '2024_08_01_090705_alter_to_restroads', 82),
(155, '2024_08_01_113756_alter_to_restaurantreview', 82),
(156, '2024_08_01_155246_alter_to_restaurantmenu', 83),
(157, '2024_08_02_064102_alter_to_fuud_push_notification', 84),
(158, '2024_08_06_103442_alter_to_restaurant_tables', 85),
(159, '2024_08_07_053900_alter_to_restaurant_shift_timing', 85),
(160, '2024_08_07_084747_alter_to_restaurant_business_hours', 85),
(161, '2024_08_07_131542_alter_to_emailtemplate', 86),
(162, '2024_08_09_183141_alter_to_fuud_booking_management', 87);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `msgsubject` varchar(250) DEFAULT NULL,
  `msgbody` longtext DEFAULT NULL,
  `isread` int(11) NOT NULL DEFAULT 0,
  `createdon` datetime(6) NOT NULL,
  `readdon` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `userid`, `msgsubject`, `msgbody`, `isread`, `createdon`, `readdon`) VALUES
(1, 0, 'Account has been created successfully.', 'Your registration with Fudd App has been successfully created.', 0, '2023-11-01 14:15:47.615381', NULL),
(2, 0, 'Account has been created successfully.', 'Your registration with Fudd App has been successfully created.', 0, '2023-11-06 09:11:31.007396', NULL),
(3, 0, 'Account has been created successfully.', 'Your registration with Fudd App has been successfully created.', 0, '2024-03-06 04:36:46.167067', NULL),
(4, 0, 'Account has been created successfully.', 'Your registration with Fudd App has been successfully created.', 0, '2024-03-15 13:01:59.372626', NULL),
(5, 0, 'Account has been created successfully.', 'Your registration with Fudd App has been successfully created.', 0, '2024-03-15 14:13:06.624410', NULL),
(6, 0, 'Account has been created successfully.', 'Your registration with Fudd App has been successfully created.', 0, '2024-03-21 23:32:58.121123', NULL),
(7, 0, 'Account has been created successfully.', 'Your registration with Fudd App has been successfully created.', 0, '2024-03-26 17:04:14.540254', NULL),
(8, 0, 'Account has been created successfully.', 'Your registration with Fudd App has been successfully created.', 0, '2024-06-06 12:37:30.995688', NULL),
(9, 0, 'Account has been created successfully.', 'Your registration with Fudd App has been successfully created.', 0, '2024-06-12 12:52:17.340421', NULL),
(10, 0, 'Account has been created successfully.', 'Your registration with Fudd App has been successfully created.', 0, '2024-06-16 19:39:53.757010', NULL),
(11, 0, 'Account has been created successfully.', 'Your registration with Fudd App has been successfully created.', 0, '2024-06-16 19:47:34.857893', NULL),
(12, 0, 'Account has been created successfully.', 'Your registration with Fudd App has been successfully created.', 0, '2024-06-16 19:52:14.108816', NULL),
(13, 0, 'Account has been created successfully.', 'Your registration with Fudd App has been successfully created.', 0, '2024-06-26 11:09:37.973003', NULL),
(14, 0, 'Account has been created successfully.', 'Your registration with Fudd App has been successfully created.', 0, '2024-06-29 12:33:22.508111', NULL),
(15, 0, 'Account has been created successfully.', 'Your registration with Fudd App has been successfully created.', 0, '2024-07-04 18:00:26.143704', NULL),
(16, 0, 'Account has been created successfully.', 'Your registration with Fudd App has been successfully created.', 0, '2024-07-10 00:29:08.425020', NULL),
(17, 0, 'Account has been created successfully.', 'Your registration with Fudd App has been successfully created.', 0, '2024-07-16 15:28:33.104796', NULL),
(18, 0, 'Account has been created successfully.', 'Your registration with Fudd App has been successfully created.', 0, '2024-07-16 21:01:45.807075', NULL),
(19, 0, 'Account has been created successfully.', 'Your registration with Fudd App has been successfully created.', 0, '2024-07-17 18:39:32.585353', NULL),
(20, 0, 'Account has been created successfully.', 'Your registration with Fudd App has been successfully created.', 0, '2024-07-22 12:16:20.296649', NULL),
(21, 0, 'Account has been created successfully.', 'Your registration with Fudd App has been successfully.', 0, '2024-07-24 13:00:16.571574', NULL),
(22, 0, 'Account has been created successfully.', 'Your registration with Fudd App has been successfully.', 0, '2024-08-04 18:23:51.019125', NULL),
(23, 0, 'Account has been created successfully.', 'Your registration with Fudd App has been successfully.', 0, '2024-08-05 13:36:09.547302', NULL),
(24, 0, 'Account has been created successfully.', 'Your registration with Fudd App has been successfully.', 0, '2024-08-05 13:40:08.914113', NULL),
(25, 0, 'Account has been created successfully.', 'Your registration with Fudd App has been successfully.', 0, '2025-01-08 15:56:43.981970', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `order`
--

CREATE TABLE `order` (
  `id` int(11) NOT NULL,
  `orderno` varchar(120) DEFAULT NULL,
  `userid` int(11) NOT NULL,
  `totorderitem` int(11) NOT NULL DEFAULT 1,
  `schdate` longtext DEFAULT NULL,
  `schtime` longtext DEFAULT NULL,
  `restaurantid` int(11) NOT NULL,
  `totguest` int(11) NOT NULL DEFAULT 1,
  `paymenttype` varchar(120) DEFAULT NULL,
  `paymentstatus` varchar(120) DEFAULT NULL,
  `paymentdetails` longtext DEFAULT NULL,
  `ip` varchar(50) DEFAULT NULL,
  `subtotal` decimal(18,2) NOT NULL DEFAULT 0.00,
  `grandtotal` decimal(18,2) NOT NULL DEFAULT 0.00,
  `couponid` int(11) NOT NULL,
  `coupondiscount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `savingamt` decimal(18,2) NOT NULL DEFAULT 0.00,
  `specialinstruction` longtext DEFAULT NULL,
  `specialrequest` longtext DEFAULT NULL,
  `transactionid` longtext DEFAULT NULL,
  `receiptid` longtext DEFAULT NULL,
  `createdon` datetime(6) NOT NULL,
  `status` varchar(120) DEFAULT NULL,
  `isuserewardpoint` int(11) NOT NULL DEFAULT 0,
  `totrewardpoints` decimal(18,2) NOT NULL DEFAULT 0.00,
  `updatedon` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `privacypolicy`
--

CREATE TABLE `privacypolicy` (
  `id` int(11) NOT NULL,
  `english_details` longtext DEFAULT NULL,
  `french_details` longtext DEFAULT NULL,
  `spanish_details` longtext DEFAULT NULL,
  `language` varchar(255) DEFAULT NULL,
  `createdon` datetime(6) NOT NULL,
  `isactive` int(11) NOT NULL DEFAULT 1,
  `updatedon` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `privacypolicy`
--

INSERT INTO `privacypolicy` (`id`, `english_details`, `french_details`, `spanish_details`, `language`, `createdon`, `isactive`, `updatedon`) VALUES
(1, '<p>English Privacy Policy</p>', '<p><strong><u>French Privacy Policy</u></strong></p>', '<p><strong><u>Spanish Privacy Policy</u></strong></p>', NULL, '2024-08-06 05:13:43.000000', 1, '2024-08-06 05:13:43.000000');

-- --------------------------------------------------------

--
-- Table structure for table `recentview`
--

CREATE TABLE `recentview` (
  `id` int(11) NOT NULL,
  `restroid` int(11) NOT NULL,
  `ip` longtext DEFAULT NULL,
  `userid` int(11) NOT NULL,
  `createdon` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `restaurantimages`
--

CREATE TABLE `restaurantimages` (
  `id` int(11) NOT NULL,
  `restroid` int(11) NOT NULL,
  `imgfile` varchar(250) DEFAULT NULL,
  `createdon` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `restaurantimages`
--

INSERT INTO `restaurantimages` (`id`, `restroid`, `imgfile`, `createdon`) VALUES
(1, 1, 'resources/restaurant/milk_beach/377c2ee0-b1fe-447e-8fc8-e61d9cb5d5b4.png', '2023-11-17 12:24:06.000000'),
(2, 1, 'resources/restaurant/milk_beach/377c2ee0-b1fe-447e-8fc8-e61d9cb5d5b5.png', '2023-11-17 12:25:16.000000'),
(3, 1, 'resources/restaurant/milk_beach/377c2ee0-b1fe-447e-8fc8-e61d9cb5d5b6.png', '2023-11-17 12:25:16.000000'),
(4, 1, 'resources/restaurant/milk_beach/377c2ee0-b1fe-447e-8fc8-e61d9cb5d5b7.png', '2023-11-17 12:25:16.000000'),
(5, 1, 'resources/restaurant/milk_beach/377c2ee0-b1fe-447e-8fc8-e61d9cb5d5b8.png', '2023-11-17 12:25:16.000000'),
(6, 2, 'resources/restaurant/Burger_and_Beyond/19392e9f-1cec-4af5-820d-98ca237a6b69.png', '2023-12-05 00:00:00.000000'),
(7, 2, 'resources/restaurant/Burger_and_Beyond/19392e9f-1cec-4af5-820d-98ca237a6b68.png', '2023-12-05 00:00:00.000000'),
(8, 2, 'resources/restaurant/Burger_and_Beyond/19392e9f-1cec-4af5-820d-98ca237a6b67.png', '2023-12-05 00:00:00.000000'),
(9, 2, 'resources/restaurant/Burger_and_Beyond/19392e9f-1cec-4af5-820d-98ca237a6b66.png', '2023-12-05 00:00:00.000000'),
(10, 2, 'resources/restaurant/Burger_and_Beyond/19392e9f-1cec-4af5-820d-98ca237a6b65.png', '2023-12-05 00:00:00.000000'),
(11, 2, 'resources/restaurant/Burger_and_Beyond/19392e9f-1cec-4af5-820d-98ca237a6b64.png', '2023-12-05 00:00:00.000000'),
(12, 3, 'resources/restaurant/Rochelle_Canteen/2b512926-fd03-4264-927d-8c2adcbe8d96.png', '2023-12-05 00:00:00.000000'),
(13, 3, 'resources/restaurant/Rochelle_Canteen/2b512926-fd03-4264-927d-8c2adcbe8d95.png', '2023-12-05 00:00:00.000000'),
(14, 3, 'resources/restaurant/Rochelle_Canteen/2b512926-fd03-4264-927d-8c2adcbe8d94.png', '2023-12-05 00:00:00.000000'),
(15, 3, 'resources/restaurant/Rochelle_Canteen/2b512926-fd03-4264-927d-8c2adcbe8d93.png', '2023-12-05 00:00:00.000000'),
(16, 3, 'resources/restaurant/Rochelle_Canteen/2b512926-fd03-4264-927d-8c2adcbe8d92.png', '2023-12-05 00:00:00.000000'),
(17, 3, 'resources/restaurant/Rochelle_Canteen/2b512926-fd03-4264-927d-8c2adcbe8d91.png', '2023-12-05 00:00:00.000000'),
(18, 3, 'resources/restaurant/Rochelle_Canteen/2b512926-fd03-4264-927d-8c2adcbe8d90.png', '2023-12-05 00:00:00.000000'),
(19, 3, 'resources/restaurant/Rochelle_Canteen/2b512926-fd03-4264-927d-8c2adcbe8d89.png', '2023-12-05 00:00:00.000000'),
(20, 4, 'resources/restaurant/Pavyilon_at_The_Four_Seasons/e69671ed-57ac-4cc7-be38-75cfd529863b.png', '2023-12-05 00:00:00.000000'),
(21, 4, 'resources/restaurant/Pavyilon_at_The_Four_Seasons/e69671ed-57ac-4cc7-be38-75cfd529867b.png', '2023-12-05 00:00:00.000000'),
(22, 4, 'resources/restaurant/Pavyilon_at_The_Four_Seasons/e69671ed-57ac-4cc7-be38-75cfd529866b.png', '2023-12-05 00:00:00.000000'),
(23, 4, 'resources/restaurant/Pavyilon_at_The_Four_Seasons/e69671ed-57ac-4cc7-be38-75cfd529865b.png', '2023-12-05 00:00:00.000000'),
(24, 4, 'resources/restaurant/Pavyilon_at_The_Four_Seasons/e69671ed-57ac-4cc7-be38-75cfd529864b.png', '2023-12-05 00:00:00.000000'),
(25, 4, 'resources/restaurant/Pavyilon_at_The_Four_Seasons/e69671ed-57ac-4cc7-be38-75cfd529863b.png', '2023-12-05 00:00:00.000000'),
(26, 5, 'resources/restaurant/Gunpowder/92d86637-f281-4be3-abc8-380788c6ae85.png', '2023-12-05 00:00:00.000000'),
(27, 5, 'resources/restaurant/Gunpowder/92d86637-f281-4be3-abc8-380788c6ae84.png', '2023-12-05 00:00:00.000000'),
(28, 5, 'resources/restaurant/Gunpowder/92d86637-f281-4be3-abc8-380788c6ae83.png', '2023-12-05 00:00:00.000000'),
(29, 5, 'resources/restaurant/Gunpowder/92d86637-f281-4be3-abc8-380788c6ae82.png', '2023-12-05 00:00:00.000000'),
(30, 5, 'resources/restaurant/Gunpowder/92d86637-f281-4be3-abc8-380788c6ae81.png', '2023-12-05 00:00:00.000000'),
(31, 5, 'resources/restaurant/Gunpowder/92d86637-f281-4be3-abc8-380788c6ae80.png', '2023-12-05 00:00:00.000000'),
(32, 5, 'resources/restaurant/Gunpowder/92d86637-f281-4be3-abc8-380788c6ae79.png', '2023-12-05 00:00:00.000000'),
(33, 5, 'resources/restaurant/Gunpowder/92d86637-f281-4be3-abc8-380788c6ae79.png', '2023-12-05 00:00:00.000000'),
(34, 6, 'resources/restaurant/Daddy_Bao/7f91030f-f96e-4b72-9099-0036b1745b63.png', '2023-12-05 00:00:00.000000'),
(35, 6, 'resources/restaurant/Daddy_Bao/7f91030f-f96e-4b72-9099-0036b1745b62.png', '2023-12-05 00:00:00.000000'),
(36, 6, 'resources/restaurant/Daddy_Bao/7f91030f-f96e-4b72-9099-0036b1745b61.png', '2023-12-05 00:00:00.000000'),
(37, 6, 'resources/restaurant/Daddy_Bao/7f91030f-f96e-4b72-9099-0036b1745b60.png', '2023-12-05 00:00:00.000000'),
(38, 6, 'resources/restaurant/Daddy_Bao/7f91030f-f96e-4b72-9099-0036b1745b59.png', '2023-12-05 00:00:00.000000'),
(39, 6, 'resources/restaurant/Daddy_Bao/7f91030f-f96e-4b72-9099-0036b1745b58.png', '2023-12-05 00:00:00.000000'),
(40, 6, 'resources/restaurant/Daddy_Bao/7f91030f-f96e-4b72-9099-0036b1745b57.png', '2023-12-05 00:00:00.000000'),
(41, 7, 'resources/restaurant/Shuk/5d2ddadc-9d18-4d09-8258-ea654f11f424.png', '2023-12-05 00:00:00.000000'),
(42, 7, 'resources/restaurant/Shuk/5d2ddadc-9d18-4d09-8258-ea654f11f423.png', '2023-12-05 00:00:00.000000'),
(43, 2, 'resources/restaurant/Burger_and_Beyond/19392e9f-1cec-4af5-820d-98ca237a6b85.png', '2024-03-15 15:10:45.000000'),
(44, 8, 'resources/restaurant/black_rabbit_cafe/ckur45g0iz59a0886r2k925nk1702460746505.jpeg', '2024-03-15 16:05:17.000000'),
(45, 8, 'resources/restaurant/black_rabbit_cafe/ckur45g0iz59a0886r2k925nk1702465943112.jpeg', '2024-03-15 16:05:17.000000'),
(46, 30, 'resources/restaurant/1713945987_res.jpeg', '2024-04-24 08:06:27.000000'),
(47, 30, 'resources/restaurant/1713945987_rest.jpeg', '2024-04-24 08:06:27.000000'),
(48, 36, 'resources/restaurant/1713946626_res.jpeg', '2024-04-24 08:17:06.000000'),
(49, 36, 'resources/restaurant/1713946626_rest.jpeg', '2024-04-24 08:17:07.000000'),
(50, 37, 'resources/restaurant/1713946860_res.jpeg', '2024-04-24 08:21:00.000000'),
(59, 38, 'resources/restaurant/1713954696_rest1.webp', '2024-04-24 10:31:36.000000'),
(60, 38, 'resources/restaurant/1713954696_rest2.jpg', '2024-04-24 10:31:36.000000'),
(61, 39, 'resources/restaurant/1713964978_sc1.jpeg', '2024-04-24 13:22:58.000000'),
(62, 39, 'resources/restaurant/1713964978_sc2.jpg', '2024-04-24 13:22:58.000000'),
(63, 40, 'resources/restaurant/1713965722_sc1.jpeg', '2024-04-24 13:35:22.000000'),
(64, 40, 'resources/restaurant/1713965722_sc2.jpg', '2024-04-24 13:35:22.000000'),
(65, 41, 'resources/restaurant/1713966316_sc1.jpeg', '2024-04-24 13:45:16.000000'),
(66, 41, 'resources/restaurant/1713966316_sc2.jpg', '2024-04-24 13:45:16.000000'),
(67, 42, 'resources/restaurant/1713966901_res.jpeg', '2024-04-24 13:55:01.000000'),
(68, 43, 'resources/restaurant/1713979589_rest.jpeg', '2024-04-24 17:26:29.000000'),
(69, 43, 'resources/restaurant/1713979589_sc1.jpeg', '2024-04-24 17:26:29.000000'),
(70, 43, 'resources/restaurant/1713979590_sc2.jpg', '2024-04-24 17:26:30.000000'),
(71, 44, 'resources/restaurant/1713979945_rest.jpeg', '2024-04-24 17:32:25.000000'),
(72, 44, 'resources/restaurant/1713979945_rest1.webp', '2024-04-24 17:32:25.000000'),
(73, 44, 'resources/restaurant/1713979945_sc1.jpeg', '2024-04-24 17:32:25.000000'),
(74, 44, 'resources/restaurant/1713979945_sc2.jpg', '2024-04-24 17:32:25.000000'),
(79, 45, 'resources/restaurant/1714027426_rest.jpeg', '2024-04-25 06:43:46.000000'),
(80, 45, 'resources/restaurant/1714027426_sc1.jpeg', '2024-04-25 06:43:46.000000'),
(81, 46, 'resources/restaurant/1714129795_pro1.jpg', '2024-04-26 11:09:55.000000'),
(82, 60, 'resources/restaurant/1717152278_6_.jpg', '2024-05-31 10:44:38.000000'),
(83, 60, 'resources/restaurant/1717152278_6__.jpg', '2024-05-31 10:44:38.000000'),
(84, 60, 'resources/restaurant/1717152278_6.jpg', '2024-05-31 10:44:38.000000'),
(85, 61, 'resources/restaurant/1717162262_7___.jpg', '2024-05-31 13:31:02.000000'),
(86, 61, 'resources/restaurant/1717162262_7__.jpg', '2024-05-31 13:31:02.000000'),
(87, 61, 'resources/restaurant/1717162262_7.jpg', '2024-05-31 13:31:02.000000'),
(88, 62, 'resources/restaurant/1717238928_8__.jpg', '2024-06-01 10:48:48.000000'),
(89, 62, 'resources/restaurant/1717238928_8___.jpg', '2024-06-01 10:48:48.000000'),
(90, 62, 'resources/restaurant/1717238928_8.jpg', '2024-06-01 10:48:48.000000'),
(99, 63, 'resources/restaurant/1717398983_4_.jpg', '2024-06-03 07:16:23.000000'),
(104, 63, 'resources/restaurant/1717399276_6.jpg', '2024-06-03 07:21:17.000000'),
(106, 65, 'resources/restaurant/1717563618_2_.jpg', '2024-06-05 05:00:18.000000'),
(107, 66, 'resources/restaurant/1717652409_3_.jpg', '2024-06-06 05:40:09.000000'),
(108, 66, 'resources/restaurant/1717652409_3__.jpg', '2024-06-06 05:40:09.000000'),
(109, 67, 'resources/restaurant/1717652768_4_.jpg', '2024-06-06 05:46:08.000000'),
(110, 67, 'resources/restaurant/1717652768_4__.jpg', '2024-06-06 05:46:08.000000'),
(117, 70, 'resources/restaurant/1717653694_7_.jpg', '2024-06-06 06:01:34.000000'),
(118, 70, 'resources/restaurant/1717653694_7__.jpg', '2024-06-06 06:01:34.000000'),
(119, 70, 'resources/restaurant/1717653694_7___.jpg', '2024-06-06 06:01:34.000000'),
(147, 71, 'resources/restaurant/1718340923_9_.jpg', '2024-06-14 04:55:24.000000'),
(148, 71, 'resources/restaurant/1718340924_9__.jpg', '2024-06-14 04:55:24.000000'),
(149, 72, 'resources/restaurant/1718341580_10__.jpg', '2024-06-14 05:06:20.000000'),
(151, 68, 'resources/restaurant/1718343442_5.jpg', '2024-06-14 05:37:22.000000'),
(152, 68, 'resources/restaurant/1718343442_5__.jpg', '2024-06-14 05:37:22.000000'),
(153, 68, 'resources/restaurant/1718343442_5___.jpg', '2024-06-14 05:37:22.000000'),
(154, 69, 'resources/restaurant/1718344745_6_.jpg', '2024-06-14 05:59:05.000000'),
(155, 69, 'resources/restaurant/1718344745_6__.jpg', '2024-06-14 05:59:05.000000'),
(156, 69, 'resources/restaurant/1718344745_6___.jpg', '2024-06-14 05:59:05.000000'),
(160, 79, 'resources/restaurant/1718704227_8___.jpg', '2024-06-18 09:50:27.000000'),
(161, 79, 'resources/restaurant/1718704286_8_.jpg', '2024-06-18 09:51:26.000000'),
(162, 80, 'resources/restaurant/1718705658_9___.jpg', '2024-06-18 10:14:18.000000'),
(163, 80, 'resources/restaurant/1718705678_8_.jpg', '2024-06-18 10:14:38.000000'),
(165, 80, 'resources/restaurant/1718705690_9__.jpg', '2024-06-18 10:14:50.000000'),
(166, 80, 'resources/restaurant/1718705935_1__.jpg', '2024-06-18 10:18:55.000000'),
(167, 80, 'resources/restaurant/1718706032_6__.jpg', '2024-06-18 10:20:32.000000'),
(168, 81, 'resources/restaurant/1718706280_8_.jpg', '2024-06-18 10:24:40.000000'),
(169, 81, 'resources/restaurant/1718706280_8__.jpg', '2024-06-18 10:24:40.000000'),
(171, 82, 'resources/restaurant/1718773109_8_.jpg', '2024-06-19 04:58:29.000000'),
(172, 82, 'resources/restaurant/1718773109_8__.jpg', '2024-06-19 04:58:29.000000'),
(173, 82, 'resources/restaurant/1718773109_8___.jpg', '2024-06-19 04:58:29.000000'),
(174, 82, 'resources/restaurant/1718773223_9__.jpg', '2024-06-19 05:00:23.000000'),
(175, 82, 'resources/restaurant/1718773242_9___.jpg', '2024-06-19 05:00:42.000000'),
(176, 72, 'resources/restaurant/1718805632_10_.jpg', '2024-06-19 14:00:32.000000'),
(177, 83, 'resources/restaurant/1718806228_9.jpg', '2024-06-19 14:10:28.000000'),
(178, 83, 'resources/restaurant/1718806625_9__.jpg', '2024-06-19 14:17:05.000000'),
(179, 83, 'resources/restaurant/1718806625_9___.jpg', '2024-06-19 14:17:05.000000'),
(180, 84, 'resources/restaurant/1718806738_8_.jpg', '2024-06-19 14:18:58.000000'),
(182, 84, 'resources/restaurant/1718806738_8___.jpg', '2024-06-19 14:18:58.000000'),
(183, 84, 'resources/restaurant/1718806809_5___.jpg', '2024-06-19 14:20:09.000000'),
(184, 84, 'resources/restaurant/1718806809_6.jpg', '2024-06-19 14:20:09.000000'),
(185, 84, 'resources/restaurant/1718806809_7___.jpg', '2024-06-19 14:20:09.000000'),
(186, 84, 'resources/restaurant/1718806809_8.jpg', '2024-06-19 14:20:09.000000'),
(187, 84, 'resources/restaurant/1718806895_2_.jpg', '2024-06-19 14:21:35.000000'),
(188, 84, 'resources/restaurant/1718806895_2__.jpg', '2024-06-19 14:21:35.000000'),
(189, 72, 'resources/restaurant/1718862477_10___.jpg', '2024-06-20 05:47:58.000000'),
(190, 64, 'resources/restaurant/1718886981_1_.jpg', '2024-06-20 12:36:21.000000'),
(191, 64, 'resources/restaurant/1718886981_1__.jpg', '2024-06-20 12:36:21.000000'),
(192, 64, 'resources/restaurant/1718886981_1___.jpg', '2024-06-20 12:36:21.000000'),
(193, 11, 'resources/restaurant/1718887055_rest2.jpg', '2024-06-20 12:37:35.000000'),
(194, 85, 'resources/restaurant/1718891378_rest2.jpg', '2024-06-20 13:49:38.000000'),
(195, 86, 'resources/restaurant/1721967654_CartecadeauOktobre_360x.webp', '2024-07-26 04:20:54.000000'),
(196, 86, 'resources/restaurant/1721967654_Oktobre.webp', '2024-07-26 04:20:54.000000'),
(197, 86, 'resources/restaurant/1721967654_Merlan_de_ligne_jus_d_artichaut_choux_celeri_rave_condiment_yuzu_kosho.webp', '2024-07-26 04:20:54.000000'),
(198, 86, 'resources/restaurant/1721967726_Oktobre2_33f15111-ff75-4798-8f60-ba38bd0f0497_1000x_crop_center.webp', '2024-07-26 04:22:06.000000'),
(199, 87, 'resources/restaurant/1721969581_P1120225-2048x1536.webp', '2024-07-26 04:53:01.000000'),
(200, 87, 'resources/restaurant/1721969581_P11202482-2048x1538.webp', '2024-07-26 04:53:01.000000'),
(201, 87, 'resources/restaurant/1721969581_Merlan_de_ligne_jus_d_artichaut_choux_celeri_rave_condiment_yuzu_kosho.webp', '2024-07-26 04:53:01.000000'),
(202, 88, 'resources/restaurant/1721970589_version_400_image-demo-.jpeg', '2024-07-26 05:09:49.000000'),
(203, 88, 'resources/restaurant/1721970589_version_400_image-demo-2.jpeg', '2024-07-26 05:09:49.000000'),
(204, 88, 'resources/restaurant/1721970589_version_400_image-demo-3.jpeg', '2024-07-26 05:09:49.000000'),
(205, 89, 'resources/restaurant/1721971516_SINNER_poulpe_grillé_sauce_shich_taouk_creme_de_toum_Guillaume_Czerw.jpg', '2024-07-26 05:25:16.000000'),
(206, 89, 'resources/restaurant/1721971516_SINNER_Restaurant_paris_marais_hotel_Nicolas_Receveur-e1562858922690.jpg', '2024-07-26 05:25:16.000000'),
(207, 89, 'resources/restaurant/1721971516_SINNER20231206cabillaudmarbre-1.jpeg', '2024-07-26 05:25:16.000000'),
(208, 90, 'resources/restaurant/1721971792_Copy-of-alluma-oct22@lephotographedudimanche-117-768x1152.jpg', '2024-07-26 05:29:52.000000'),
(209, 90, 'resources/restaurant/1721971792_Copy-of-alluma-oct22@lephotographedudimanche-133-768x1152.jpg', '2024-07-26 05:29:52.000000'),
(210, 90, 'resources/restaurant/1721971792_Copy-of-Copy-of-alluma-oct22@lephotographedudimanche-33-768x1152.jpg', '2024-07-26 05:29:52.000000'),
(211, 91, 'resources/restaurant/1721972100_ILLUSTRATION-MS-VILLIERS.png', '2024-07-26 05:35:00.000000'),
(212, 91, 'resources/restaurant/1721972100_ILLUSTRATION-WEB-MS-BUCI-800x800.png', '2024-07-26 05:35:00.000000'),
(213, 92, 'resources/restaurant/1721972326_SOSSO-60.webp', '2024-07-26 05:38:46.000000'),
(214, 92, 'resources/restaurant/1721972326_SOSSO-62_edited.webp', '2024-07-26 05:38:46.000000'),
(215, 92, 'resources/restaurant/1721972326_SOSSO-63.webp', '2024-07-26 05:38:46.000000'),
(216, 93, 'resources/restaurant/1721972641_mission1.webp', '2024-07-26 05:44:01.000000'),
(217, 93, 'resources/restaurant/1721972641_mission2.webp', '2024-07-26 05:44:01.000000'),
(218, 94, 'resources/restaurant/1721972974_4ffbae675b38b73ffeafc848d0ec26cc.website.jpg', '2024-07-26 05:49:34.000000'),
(219, 94, 'resources/restaurant/1721972974_7a47213a0cba26143d3055f7f031ed23.website.jpg', '2024-07-26 05:49:34.000000'),
(220, 94, 'resources/restaurant/1721972974_3040875de0d67b302944f570300c8a9b.website.jpg', '2024-07-26 05:49:34.000000'),
(221, 95, 'resources/restaurant/1721973284_IMG_3823.webp', '2024-07-26 05:54:44.000000'),
(222, 95, 'resources/restaurant/1721973284_papi-26-520x780-1.webp', '2024-07-26 05:54:44.000000'),
(223, 96, 'resources/restaurant/1721973870_1.png', '2024-07-26 06:04:30.000000'),
(224, 96, 'resources/restaurant/1721973870_2.png', '2024-07-26 06:04:30.000000'),
(225, 96, 'resources/restaurant/1721973870_4.png', '2024-07-26 06:04:30.000000'),
(226, 96, 'resources/restaurant/1721973870_6.png', '2024-07-26 06:04:30.000000'),
(227, 96, 'resources/restaurant/1721973870_Design-sans-titre-1.png', '2024-07-26 06:04:30.000000'),
(228, 97, 'resources/restaurant/1721974104_704-terrasse-2-.avif', '2024-07-26 06:08:24.000000'),
(229, 97, 'resources/restaurant/1721974104_fnd.avif', '2024-07-26 06:08:24.000000'),
(230, 97, 'resources/restaurant/1721974104_general-vue-du-fond.avif', '2024-07-26 06:08:24.000000'),
(231, 97, 'resources/restaurant/1721974104_resto-general-.avif', '2024-07-26 06:08:24.000000'),
(232, 98, 'resources/restaurant/1721974310_4192206-1318326_0_222_850_700_525_432.jpg', '2024-07-26 06:11:50.000000'),
(233, 98, 'resources/restaurant/1721974310_4192213-1315231_0_0_897_897_525_525.jpg', '2024-07-26 06:11:50.000000'),
(234, 98, 'resources/restaurant/1721974310_4192215-1313244_5_7_525_597_525_597.jpg', '2024-07-26 06:11:50.000000'),
(235, 98, 'resources/restaurant/1721974310_4192220-1318363_0_0_525_621_525_621.jpg', '2024-07-26 06:11:50.000000'),
(236, 99, 'resources/restaurant/1721974704_bteille.jpeg', '2024-07-26 06:18:24.000000'),
(237, 99, 'resources/restaurant/1721974704_exterieur.jpeg', '2024-07-26 06:18:24.000000'),
(238, 99, 'resources/restaurant/1721974704_Photo+30-12-2019+16+56+30+copie.jpg', '2024-07-26 06:18:24.000000'),
(239, 99, 'resources/restaurant/1721974704_salle.png', '2024-07-26 06:18:24.000000'),
(240, 100, 'resources/restaurant/1721975031_HOXTON_PARIS_0891.webp', '2024-07-26 06:23:51.000000'),
(241, 100, 'resources/restaurant/1721975031_LaLoge_Dining_Hero.webp', '2024-07-26 06:23:51.000000'),
(242, 100, 'resources/restaurant/1721975031_Paris_Party_Illustration.webp', '2024-07-26 06:23:51.000000'),
(243, 100, 'resources/restaurant/1721975031_Paris-1.webp', '2024-07-26 06:23:51.000000'),
(244, 101, 'resources/restaurant/1721975228_kodawari-ramen-home-1.jpg', '2024-07-26 06:27:08.000000'),
(245, 101, 'resources/restaurant/1721975228_kodawari-ramen-home-2.jpg', '2024-07-26 06:27:08.000000'),
(246, 101, 'resources/restaurant/1721975228_kodawari-tsukiji-homepage.jpg', '2024-07-26 06:27:08.000000'),
(247, 101, 'resources/restaurant/1721975228_kodawari-yokocho-homepage.jpg', '2024-07-26 06:27:08.000000'),
(248, 102, 'resources/restaurant/1721975499_kodawari-ramen-home-1.jpg', '2024-07-26 06:31:39.000000'),
(249, 102, 'resources/restaurant/1721975499_kodawari-ramen-home-2.jpg', '2024-07-26 06:31:39.000000'),
(250, 102, 'resources/restaurant/1721975499_kodawari-tsukiji-homepage.jpg', '2024-07-26 06:31:39.000000'),
(251, 102, 'resources/restaurant/1721975499_kodawari-yokocho-homepage.jpg', '2024-07-26 06:31:39.000000'),
(252, 103, 'resources/restaurant/1721975787_02_Tartare_de_boeuf_a_la_libanaise_Guillaume_Czerw_Agent_Mel_hotel_paris_luxe-1500x1125.jpg.webp', '2024-07-26 06:36:27.000000'),
(253, 103, 'resources/restaurant/1721975787_03_Brach_Oeuf_mimosa_poutargue_Guillaume_Czerw_hotel_luxe_paris-1.jpg.webp', '2024-07-26 06:36:27.000000'),
(254, 103, 'resources/restaurant/1721975787_04_Brach_Restaurant_31_GuillaumedeLaubier_hotel_paris_luxe-1500x1001.jpg.webp', '2024-07-26 06:36:27.000000'),
(255, 103, 'resources/restaurant/1721975787_brachterrassenuit_122019_mathilde-5-scaled-1-1500x1029.jpeg.webp', '2024-07-26 06:36:27.000000'),
(256, 104, 'resources/restaurant/1721976073_andia-logos.webp', '2024-07-26 06:41:13.000000'),
(257, 105, 'resources/restaurant/1721976477_grand-powers-elements-graphiques-005.webp', '2024-07-26 06:47:57.000000'),
(258, 105, 'resources/restaurant/1721976477_grand-powers-logos-004.webp', '2024-07-26 06:47:57.000000'),
(259, 105, 'resources/restaurant/1721976477_virtuoso-.jpeg.webp', '2024-07-26 06:47:57.000000'),
(260, 106, 'resources/restaurant/1721976777_grand-powers-elements-graphiques-005.webp', '2024-07-26 06:52:57.000000'),
(261, 106, 'resources/restaurant/1721976777_grand-powers-logos-004.webp', '2024-07-26 06:52:57.000000'),
(262, 106, 'resources/restaurant/1721976777_virtuoso-.jpeg.webp', '2024-07-26 06:52:57.000000'),
(263, 107, 'resources/restaurant/1721978133_2024-06-02.jpg', '2024-07-26 07:15:33.000000'),
(264, 107, 'resources/restaurant/1721978133_2023-10-10 (1).jpg', '2024-07-26 07:15:33.000000'),
(265, 107, 'resources/restaurant/1721978133_2020-11-06.jpg', '2024-07-26 07:15:33.000000'),
(266, 108, 'resources/restaurant/1721986330_67ae2771b8ebe618d0a9a04beb12.png', '2024-07-26 09:32:10.000000'),
(267, 108, 'resources/restaurant/1721986330_765c52272b12533afc8c48c4e193.jpg', '2024-07-26 09:32:10.000000'),
(268, 108, 'resources/restaurant/1721986330_27560c2b4a1caf0f23ba16e4-eec6b22cc488e76f66d4f511.jpeg', '2024-07-26 09:32:10.000000'),
(269, 109, 'resources/restaurant/1723122013_4_.jpg', '2024-08-08 13:00:13.000000'),
(270, 109, 'resources/restaurant/1723122013_4___.jpg', '2024-08-08 13:00:13.000000'),
(271, 110, 'resources/restaurant/1723122618_4_.jpg', '2024-08-08 13:10:18.000000'),
(272, 110, 'resources/restaurant/1723122618_4__.jpg', '2024-08-08 13:10:18.000000'),
(273, 114, 'resources/restaurant/1723185987_27258529ed-vegan-restaurants-6-3tf96.jpg', '2024-08-09 06:46:27.000000'),
(274, 114, 'resources/restaurant/1723185987_298bc01c59-vegan-restaurants-1-8xiz3.jpg', '2024-08-09 06:46:27.000000'),
(275, 114, 'resources/restaurant/1723185987_6308f48ac2-vegan-restaurants-5-8kpbq.jpg', '2024-08-09 06:46:27.000000'),
(276, 114, 'resources/restaurant/1723185987_3d4d9db87c-vegan-restaurants-4-drn7g.jpg', '2024-08-09 06:46:27.000000'),
(278, 118, 'resources/restaurant/1723470177_1_.jpg', '2024-08-12 13:42:57.000000'),
(279, 118, 'resources/restaurant/1723470177_1__.jpg', '2024-08-12 13:42:57.000000'),
(280, 153, 'resources/restaurant/1725356046_33_1.jpg', '2024-09-03 09:34:06.000000'),
(281, 153, 'resources/restaurant/1725356046_33_2.jpg', '2024-09-03 09:34:06.000000'),
(282, 154, 'resources/restaurant/1725356321_34_1.png', '2024-09-03 09:38:41.000000'),
(283, 155, 'resources/restaurant/1725356691_35.jpg', '2024-09-03 09:44:51.000000'),
(284, 156, 'resources/restaurant/1725356879_36.jpg', '2024-09-03 09:47:59.000000'),
(285, 156, 'resources/restaurant/1725356879_36_2.jpg', '2024-09-03 09:47:59.000000'),
(286, 157, 'resources/restaurant/1725356995_37_1.jpg', '2024-09-03 09:49:55.000000'),
(287, 157, 'resources/restaurant/1725356995_37_2.jpg', '2024-09-03 09:49:55.000000'),
(288, 157, 'resources/restaurant/1725356995_37_3.jpg', '2024-09-03 09:49:55.000000'),
(289, 158, 'resources/restaurant/1725357119_38_1.png', '2024-09-03 09:51:59.000000'),
(290, 159, 'resources/restaurant/1725357248_39_1.png', '2024-09-03 09:54:08.000000'),
(291, 159, 'resources/restaurant/1725357248_39_2.png', '2024-09-03 09:54:08.000000'),
(292, 160, 'resources/restaurant/1725359892_40_1.jpg', '2024-09-03 10:38:12.000000'),
(293, 160, 'resources/restaurant/1725359892_40_2.jpg', '2024-09-03 10:38:12.000000'),
(294, 163, 'resources/restaurant/1725360958_43_1.jpg', '2024-09-03 10:55:58.000000'),
(295, 163, 'resources/restaurant/1725360958_43_2.jpg', '2024-09-03 10:55:58.000000'),
(296, 164, 'resources/restaurant/1725361220_44_1.jpg', '2024-09-03 11:00:20.000000');

-- --------------------------------------------------------

--
-- Table structure for table `restaurantmenu`
--

CREATE TABLE `restaurantmenu` (
  `id` int(11) NOT NULL,
  `restroid` int(11) NOT NULL,
  `country` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `file_type` varchar(255) DEFAULT NULL,
  `pdffile` varchar(255) DEFAULT NULL,
  `imgfile` varchar(250) DEFAULT NULL,
  `menu_link` varchar(255) DEFAULT NULL,
  `createdon` datetime(6) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `linkurl` varchar(250) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `restaurantmenu`
--

INSERT INTO `restaurantmenu` (`id`, `restroid`, `country`, `city`, `file_type`, `pdffile`, `imgfile`, `menu_link`, `createdon`, `created_at`, `updated_at`, `linkurl`) VALUES
(47, 72, 'France', 'Paris', 'pdf', 'resources/menus/1718873683.pdf', NULL, NULL, '2024-06-20 08:54:43.000000', '2024-06-20 03:24:43', '2024-06-20 03:24:43', NULL),
(48, 66, 'France', 'Paris', 'pdf', 'resources/menus/1718873940.pdf', NULL, NULL, '2024-06-20 08:59:00.000000', '2024-06-20 03:29:00', '2024-06-20 03:29:00', NULL),
(50, 67, 'France', 'Paris', 'img', NULL, 'resources/menus/1718874190.png', NULL, '2024-06-20 09:03:10.000000', '2024-06-20 03:33:10', '2024-06-20 03:33:10', NULL),
(52, 65, 'France', 'Paris', 'pdf', 'resources/menus/1718874466.pdf', NULL, NULL, '2024-06-20 09:07:46.000000', '2024-06-20 03:37:46', '2024-06-20 03:37:46', NULL),
(53, 68, 'France', 'Paris', 'img', NULL, 'resources/menus/1718874509.png', NULL, '2024-06-20 09:08:29.000000', '2024-06-20 03:38:29', '2024-06-20 03:38:29', NULL),
(54, 71, 'France', 'Paris', 'img', NULL, 'resources/menus/1718874544.png', NULL, '2024-06-20 09:09:04.000000', '2024-06-20 03:39:04', '2024-06-20 03:39:04', NULL),
(62, 87, 'France', 'Paris', 'link', NULL, NULL, 'https://labaignoirerestaurant.com/menu/', '2024-07-26 05:31:25.000000', '2024-07-26 00:01:25', '2024-07-26 00:01:25', NULL),
(63, 106, 'France', 'Paris', 'img', NULL, 'resources/menus/1722577100.jpg', '', '2024-08-02 05:38:21.000000', '2024-08-02 00:08:21', '2024-08-02 00:08:21', NULL),
(65, 64, 'France', 'Paris', 'pdf', 'resources/menus/1722847449.pdf', NULL, '', '2024-08-05 08:44:09.000000', '2024-08-05 03:14:09', '2024-08-05 03:14:09', NULL),
(66, 104, 'France', 'Paris', 'img', NULL, 'resources/menus/1722847559.jpg', '', '2024-08-05 08:45:59.000000', '2024-08-05 03:15:59', '2024-08-05 03:15:59', NULL),
(67, 107, 'Spain', 'Madrid', 'link', NULL, NULL, 'https://74.208.234.164:8443/smb/file-manager/list/domainId/6', '2024-08-05 08:46:32.000000', '2024-08-05 03:16:32', '2024-08-05 03:16:32', NULL),
(68, 106, 'France', 'Paris', 'pdf', 'resources/menus/1722848804.pdf', NULL, '', '2024-08-05 09:06:44.000000', '2024-08-05 03:36:44', '2024-08-05 03:36:44', NULL),
(69, 110, 'France', 'Eure', 'img', NULL, 'resources/menus/1723125574.jpg', '', '2024-08-08 13:59:34.000000', '2024-08-08 08:29:34', '2024-08-08 08:29:34', NULL),
(71, 114, 'India', 'Noida', 'img', NULL, 'resources/menus/1723213266.jpg', '', '2024-08-09 14:21:06.000000', '2024-08-09 08:51:06', '2024-08-09 08:51:06', NULL),
(72, 123, 'France', 'Paris', 'img', NULL, 'resources/menus/1723551429.jpg', '', '2024-08-13 12:17:09.000000', '2024-08-13 06:47:09', '2024-08-13 06:47:09', NULL),
(73, 159, 'France', 'Paris', 'img', NULL, 'resources/menus/1725358889.png', '', '2024-09-03 10:21:29.000000', '2024-09-03 04:51:29', '2024-09-03 04:51:29', NULL),
(74, 158, 'France', 'Paris', 'img', NULL, 'resources/menus/1725358958.png', '', '2024-09-03 10:22:38.000000', '2024-09-03 04:52:38', '2024-09-03 04:52:38', NULL),
(75, 157, 'France', 'Paris', 'img', NULL, 'resources/menus/1725359053.png', '', '2024-09-03 10:24:13.000000', '2024-09-03 04:54:13', '2024-09-03 04:54:13', NULL),
(76, 156, 'France', 'Paris', 'img', NULL, 'resources/menus/1725359239.png', '', '2024-09-03 10:27:19.000000', '2024-09-03 04:57:19', '2024-09-03 04:57:19', NULL),
(77, 155, 'France', 'Paris', 'img', NULL, 'resources/menus/1725359303.png', '', '2024-09-03 10:28:23.000000', '2024-09-03 04:58:23', '2024-09-03 04:58:23', NULL),
(78, 154, 'France', 'Paris', 'img', NULL, 'resources/menus/1725359431.png', '', '2024-09-03 10:30:31.000000', '2024-09-03 05:00:31', '2024-09-03 05:00:31', NULL),
(79, 153, 'France', 'Paris', 'img', NULL, 'resources/menus/1725359446.png', '', '2024-09-03 10:30:46.000000', '2024-09-03 05:00:46', '2024-09-03 05:00:46', NULL),
(80, 160, 'France', 'Paris', 'img', NULL, 'resources/menus/1725361285.png', '', '2024-09-03 11:01:25.000000', '2024-09-03 05:31:25', '2024-09-03 05:31:25', NULL),
(81, 161, 'France', 'Paris', 'img', NULL, 'resources/menus/1725361311.png', '', '2024-09-03 11:01:51.000000', '2024-09-03 05:31:51', '2024-09-03 05:31:51', NULL),
(82, 162, 'France', 'Paris', 'img', NULL, 'resources/menus/1725361327.png', '', '2024-09-03 11:02:07.000000', '2024-09-03 05:32:07', '2024-09-03 05:32:07', NULL),
(86, 164, 'France', 'Paris', 'img', NULL, 'resources/menus/1725545610.png', '', '2024-09-05 14:13:30.000000', '2024-09-05 08:43:30', '2024-09-05 08:43:30', NULL),
(94, 163, 'France', 'Paris', 'img', NULL, 'resources/menus/1725876195.png', NULL, '2024-09-09 10:03:15.000000', '2024-09-09 04:33:15', '2024-09-09 04:33:15', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `restaurantopenhour`
--

CREATE TABLE `restaurantopenhour` (
  `id` int(11) NOT NULL,
  `restroid` int(11) NOT NULL,
  `day` varchar(50) DEFAULT NULL,
  `timerange` varchar(50) DEFAULT NULL,
  `createdon` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `restaurantopenhour`
--

INSERT INTO `restaurantopenhour` (`id`, `restroid`, `day`, `timerange`, `createdon`) VALUES
(1, 1, 'Monday', '08.00-23.00', '2023-11-17 12:21:09.000000'),
(2, 1, 'Tuesday', '08.00-23.00', '2023-11-17 12:21:09.000000'),
(3, 1, 'Wednesday', '08.00-23.00', '2023-11-17 12:21:49.000000'),
(4, 1, 'Thursday', '08.00-23.59', '2023-11-17 12:21:49.000000'),
(5, 1, 'Friday', '08.00-23.59', '2023-11-17 12:23:05.000000'),
(6, 1, 'Saturday', '08.00-23.59', '2023-11-17 12:23:05.000000'),
(7, 1, 'Sunday', 'Closed', '2023-11-17 12:23:38.000000'),
(8, 2, 'Monday', '12:00-22:00', '2023-12-05 00:00:00.000000'),
(9, 2, 'Tuesday', '12:00-22:00', '2023-12-05 00:00:00.000000'),
(10, 2, 'Wednesday', '12:00-22:00', '2023-12-05 00:00:00.000000'),
(11, 2, 'Thursday', '12:00-23:00', '2023-12-05 00:00:00.000000'),
(12, 2, 'Friday', '12:00-23:00', '2023-12-05 00:00:00.000000'),
(13, 2, 'Saturday', '12:00-23:00', '2023-12-05 00:00:00.000000'),
(14, 2, 'Sunday', '12:00-22:00', '2023-12-05 00:00:00.000000'),
(15, 3, 'Monday', '12:00-15:00', '2023-12-05 00:00:00.000000'),
(16, 3, 'Tuesday', '12:00-15:00', '2023-12-05 00:00:00.000000'),
(17, 3, 'Wednesday', '12:00-15:00, 17.30-19.45', '2023-12-05 00:00:00.000000'),
(18, 3, 'Thursday', '12:00-15:00, 17.30-19.45', '2023-12-05 00:00:00.000000'),
(19, 3, 'Friday', '12:00-15:00, 17.30-19.45', '2023-12-05 00:00:00.000000'),
(20, 3, 'Saturday', '12:00-15:00, 17.30-19.45', '2023-12-05 00:00:00.000000'),
(21, 3, 'Sunday', '12:00-15:00', '2023-12-05 00:00:00.000000'),
(22, 4, 'Monday', '06:30-22:30', '2023-12-05 00:00:00.000000'),
(23, 4, 'Tuesday', '06:30-22:30', '2023-12-05 00:00:00.000000'),
(24, 4, 'Wednesday', '06:30-22:30', '2023-12-05 00:00:00.000000'),
(25, 4, 'Thursday', '06:30-22:30', '2023-12-05 00:00:00.000000'),
(26, 4, 'Friday', '06:30-22:30', '2023-12-05 00:00:00.000000'),
(27, 4, 'Saturday', '07:00-22:30', '2023-12-05 00:00:00.000000'),
(28, 4, 'Sunday', '07:00-22:30', '2023-12-05 00:00:00.000000'),
(29, 5, 'Monday', '12:00-22:00', '2023-12-05 00:00:00.000000'),
(30, 5, 'Tuesday', '12:00-22:00', '2023-12-05 00:00:00.000000'),
(31, 5, 'Wednesday', '12:00-22:00', '2023-12-05 00:00:00.000000'),
(32, 5, 'Thursday', '12:00-22:00', '2023-12-05 00:00:00.000000'),
(33, 5, 'Friday', '12:00-22:00', '2023-12-05 00:00:00.000000'),
(34, 5, 'Saturday', '12:00-22:00', '2023-12-05 00:00:00.000000'),
(35, 5, 'Sunday', 'Closed', '2023-12-05 00:00:00.000000'),
(36, 6, 'Monday', '17:00-21:45', '2023-12-05 00:00:00.000000'),
(37, 6, 'Tuesday', '17:00-21:45', '2023-12-05 00:00:00.000000'),
(38, 6, 'Wednesday', '17:00-21:45', '2023-12-05 00:00:00.000000'),
(39, 6, 'Thursday', '17:00-21:45', '2023-12-05 00:00:00.000000'),
(40, 6, 'Friday', '17:00-22:45', '2023-12-05 00:00:00.000000'),
(41, 6, 'Saturday', '17:00-22:45', '2023-12-05 00:00:00.000000'),
(42, 6, 'Sunday', '17:00-21:45', '2023-12-05 00:00:00.000000'),
(43, 7, 'Monday', '11:30-17:00', '2023-12-05 00:00:00.000000'),
(44, 7, 'Tuesday', '11:30-17:00', '2023-12-05 00:00:00.000000'),
(45, 7, 'Wednesday', '11:30-17:00', '2023-12-05 00:00:00.000000'),
(46, 7, 'Thursday', '11:30-17:00', '2023-12-05 00:00:00.000000'),
(47, 7, 'Friday', '11:30-17:00', '2023-12-05 00:00:00.000000'),
(48, 7, 'Saturday', '11:30-17:00', '2023-12-05 00:00:00.000000'),
(49, 7, 'Sunday', '11:00-16:00', '2023-12-05 00:00:00.000000'),
(50, 8, 'Monday', '07.30-16.00', '2023-11-17 12:21:09.000000'),
(51, 8, 'Tuesday', '07.30-16.00', '2023-11-17 12:21:09.000000'),
(52, 8, 'Wednesday', '07.30-16.00', '2023-11-17 12:21:49.000000'),
(53, 8, 'Thursday', '07.30-16.00', '2023-11-17 12:21:49.000000'),
(54, 8, 'Friday', '07.30-16.00', '2023-11-17 12:23:05.000000'),
(55, 8, 'Saturday', '09.00-16.00', '2023-11-17 12:23:05.000000'),
(56, 8, 'Sunday', '09.00-16.00', '2023-11-17 12:23:38.000000');

-- --------------------------------------------------------

--
-- Table structure for table `restaurantreview`
--

CREATE TABLE `restaurantreview` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `userName` varchar(255) NOT NULL,
  `review_country` varchar(255) DEFAULT NULL,
  `review_city` varchar(255) DEFAULT NULL,
  `restaurantid` int(11) NOT NULL,
  `comments` longtext DEFAULT NULL,
  `rating` decimal(18,2) NOT NULL DEFAULT 1.00,
  `is_disabled` enum('0','1') NOT NULL,
  `createdon` datetime(6) NOT NULL,
  `isactive` int(11) NOT NULL DEFAULT 1,
  `totreply` int(11) NOT NULL DEFAULT 0,
  `parentuserid` int(11) NOT NULL DEFAULT 0,
  `updatedon` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `restaurantreview`
--

INSERT INTO `restaurantreview` (`id`, `userid`, `userName`, `review_country`, `review_city`, `restaurantid`, `comments`, `rating`, `is_disabled`, `createdon`, `isactive`, `totreply`, `parentuserid`, `updatedon`) VALUES
(1, 0, 'John Abreto', 'France', 'Eure', 110, 'As an experienced copywriting expert specializing in writing professional product reviews, I have crafted a realistic and personalized review for your product, [product name], based on the description provided.', 3.50, '0', '2024-08-30 06:50:00.000000', 1, 0, 24, NULL),
(2, 0, 'Suraj Sharma', 'India', 'Noida', 114, 'I recently had the opportunity to try out [product name], and I must say, I was thoroughly impressed by its performance and quality. Designed with [product description], this product truly stands out in the crowded market of', 4.00, '1', '2024-08-30 06:50:52.000000', 1, 0, 24, NULL),
(3, 0, 'Louis jane', 'France', 'Paris', 108, 'One of the key features that immediately caught my attention was the La Mansion , which enhanced the overall user experience. Whether you are a novice or an experienced user, this feature adds a level of convenience that is hard to overlook.', 4.50, '0', '2024-08-30 06:51:55.000000', 1, 0, 24, NULL),
(5, 0, 'Lucas Maël', 'France', 'Paris', 104, 'In terms of functionality, Andia-la Gagre excels in delivering on its promises. The Restaurant provided exceptional results, making it a valuable addition to any user\\\'s toolkit. Furthermore, the [keyword] feature was particularly useful, making tasks seamless and efficient.', 4.50, '0', '2024-08-30 06:54:08.000000', 1, 0, 24, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `restaurants`
--

CREATE TABLE `restaurants` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `added_by` int(11) NOT NULL,
  `categoryid` longtext DEFAULT NULL,
  `categoryname` longtext DEFAULT NULL,
  `tags` varchar(500) DEFAULT NULL,
  `tagsid` varchar(255) NOT NULL,
  `shortdescription` varchar(500) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `location` longtext DEFAULT NULL,
  `address_1` varchar(255) NOT NULL,
  `address_2` varchar(255) DEFAULT 'N/A',
  `city` longtext DEFAULT NULL,
  `state` longtext DEFAULT NULL,
  `docuntry` longtext DEFAULT NULL,
  `totfav` int(11) NOT NULL DEFAULT 0,
  `totbeen` int(11) NOT NULL DEFAULT 0,
  `tottry` int(11) NOT NULL DEFAULT 0,
  `pincode` longtext DEFAULT NULL,
  `phone` longtext DEFAULT NULL,
  `alternate_phone` varchar(255) NOT NULL,
  `lat` longtext DEFAULT NULL,
  `lng` longtext DEFAULT NULL,
  `fblink` longtext DEFAULT NULL,
  `instalink` longtext DEFAULT NULL,
  `rating` decimal(18,2) NOT NULL DEFAULT 0.00,
  `rating_link` longtext DEFAULT NULL,
  `price` varchar(255) NOT NULL,
  `totreviews` int(11) NOT NULL DEFAULT 0,
  `barcode` longtext DEFAULT NULL,
  `slug` longtext DEFAULT NULL,
  `createdon` datetime(6) NOT NULL,
  `updatedon` datetime(6) DEFAULT NULL,
  `isactive` int(11) NOT NULL DEFAULT 0,
  `isexclusive` int(11) NOT NULL DEFAULT 0,
  `isperks` int(11) NOT NULL DEFAULT 0,
  `mainimg` varchar(250) DEFAULT NULL,
  `subregion` varchar(100) DEFAULT NULL,
  `use_third_party_check` int(11) NOT NULL DEFAULT 0,
  `use_third_party_book_url` varchar(255) DEFAULT NULL,
  `booking_url` varchar(255) NOT NULL,
  `updated_ip` varchar(255) NOT NULL DEFAULT 'N/A',
  `updated_by` int(11) NOT NULL DEFAULT 0,
  `updated_by_name` varchar(255) NOT NULL DEFAULT 'N/A',
  `added_by_super` int(11) NOT NULL DEFAULT 0,
  `deleted` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `restaurants`
--

INSERT INTO `restaurants` (`id`, `name`, `added_by`, `categoryid`, `categoryname`, `tags`, `tagsid`, `shortdescription`, `description`, `location`, `address_1`, `address_2`, `city`, `state`, `docuntry`, `totfav`, `totbeen`, `tottry`, `pincode`, `phone`, `alternate_phone`, `lat`, `lng`, `fblink`, `instalink`, `rating`, `rating_link`, `price`, `totreviews`, `barcode`, `slug`, `createdon`, `updatedon`, `isactive`, `isexclusive`, `isperks`, `mainimg`, `subregion`, `use_third_party_check`, `use_third_party_book_url`, `booking_url`, `updated_ip`, `updated_by`, `updated_by_name`, `added_by_super`, `deleted`, `created_at`, `updated_at`) VALUES
(1, 'Milk Beach', 0, '1', 'Cuisines', 'australian, relaxed, chic, stylish, catch up with friends, double date, date night, terrace, girls lunch, girls night, sharing style, small plates, outside seating, girls lunch, girls night, good vegan options, good vegetarian options, perfectfordate, dogsfriendly', '', 'Following a successful opening in Queens Park, Australian restaurant Milk Beach comes to Soho, this time focused on a superb dinner menu in a beautiful, warm setting.', 'Following a successful opening in Queens Park, Australian restaurant Milk Beach comes to Soho, this time focused on a superb dinner menu in a beautiful, warm setting.\nExpect high ceilings, an abundance of natural light, a large courtyard and a delicious menu featuring small plates like grilled oyster mushrooms with macadamia nut hummus, through to a whole deep fried seabass and grilled \"prawns on the barbie.\n\nSister Spot: Queens Park', 'Ilona Rose House, Manette Street, Soho, London, W1D 4AL', '', 'N/A', 'Soho', 'London', 'UK', 0, 1, 0, 'W1D 4AL', NULL, '', '51.514230', '-0.130810', NULL, 'https://www.instagram.com/milkbeachlondon', 4.60, 'https://www.google.com/search?si=ACC90nwO9xEzySNrBbeVuYhtSl5s84rzWVZlRreGH3L-IdoVybOPGo_7z_CvDm1yog9fpK8YuzdCuF37SEHrzgMmgN2lWJ3PYoof9hYGTCbs3lI8Q0F4muHXiHWc2MmrUKQkB7fd0m6aRVZOXsaE_mcfG2Y0MVddow%3D%3D&q=Milk%20Beach%20Soho%20Reviews&sa=X&ved=0CBYQqe0LahcKEwjAmoWC_aiHAxUAAAAAHQAAAAAQBg&biw=1536&bih=730&dpr=1.25', '', 0, NULL, 'milk_beach', '2023-11-17 12:05:20.000000', NULL, 1, 0, 0, 'resources/restaurant/milk_beach/377c2ee0-b1fe-447e-8fc8-e61d9cb5d5b4.png', NULL, 0, NULL, 'https://fudd.galileosoft.com/reservations/milk_beach', 'N/A', 0, 'N/A', 0, 1, NULL, '2024-04-06 06:22:09'),
(2, 'Burger and Beyond', 1, '1', 'Cuisines', 'catch up with friends, good for groups, burgers, american, casual, industrial, perfectfordate, chilled', '', 'The street food specialists bring their beloved burgers to Soho with a minimalist, concrete aesthetic.', 'The street food specialists bring their beloved burgers to Soho with a minimalist, concrete aesthetic. Sister Spots: Shoreditch, London Bridge', '10 Old Compton Street', '', 'N/A', 'Soho', 'London', 'UK', 0, 0, 0, 'W1D 4TF', '2045801289', '', '51.513811', '-0.12998', NULL, 'https://www.instagram.com/burgerandbeyond', 4.30, 'https://www.google.com/search?si=ACC90nwO9xEzySNrBbeVuYhtSl5s84rzWVZlRreGH3L-IdoVybOPGo_7z_CvDm1yog9fpK9Nq-ISmeIZVg3f5d0kWPVT7hyu-3QvJdDr7e_wEIIaP0KwDyqx_dt3Nzm_ZGcCBpBQf2itiC5YQnFr4t92v5sifOX3UiDpYWmq8gQpOvakcjveL0Q%3D&q=Burger%20and%20Beyond%20Soho%20Reviews&sa=X&ved=0CBcQqe0LahcKEwigp63R_aiHAxUAAAAAHQAAAAAQBw&biw=1536&bih=730&dpr=1.25', '', 0, NULL, 'Burger-and-Beyond', '2023-12-05 00:00:00.000000', NULL, 1, 0, 0, 'resources/restaurant/Burger_and_Beyond/19392e9f-1cec-4af5-820d-98ca237a6b85.png', NULL, 0, NULL, 'https://fudd.galileosoft.com/reservations/Burger-and-Beyond', 'N/A', 0, 'N/A', 0, 1, NULL, NULL),
(3, 'Rochelle Canteen', 1, '1', 'Cuisines', 'british, pretty, garden, plants, outside seating, date night, catch up with a friend, catch up with friends, perfectfordate terrace, good vegetarian options, female founded, female led, dogsfriendly', '', 'One of East London\'s hidden gems - Rochelle Canteen serves up delicious seasonal fuss-free British food from daily-changing menus. ', 'One of East London\'s hidden gems - Rochelle Canteen serves up delicious seasonal fuss-free British food from daily-changing menus. The Canteen sits through an unmarked door in the converted bike shed of the old Rochelle School, looking out to the trees of Arnold Circus beyond, with outside tables and a secret garden ready for lovely days in London.Signature Dish: the Pecorino, Girolles & Onion Tart', '16 Playground Gardens', '', 'N/A', 'Shoreditch', 'London', 'UK', 0, 0, 0, 'E2 7FA', '2039288328', '', '51.525767', ',-0.074292', NULL, 'https://www.instagram.com/rochellecanteen', 4.40, 'https://www.google.com/search?q=Rochelle+Canteen&sca_esv=8c2b0740c73d74e6&sxsrf=ADLYWILE5zz07SkmPftNpWagj2E5rrapDg%3A1721046403472&ei=gxWVZs--HJ-jvr0P-Lvk-Qs&ved=0ahUKEwiPjJW8hamHAxWfka8BHfgdOb8Q4dUDCA8&uact=5&oq=Rochelle+Canteen&gs_lp=Egxnd3Mtd2l6LXNlcnAiEFJvY2hlbGxlIENhbnRlZW4yBBAjGCcyERAuGIAEGJECGMcBGIoFGK8BMgYQABgHGB4yBRAAGIAEMgUQABiABDIFEAAYgAQyBRAAGIAEMgUQABiABDIFEAAYgAQyBRAAGIAESPUQUABYtQ9wAHgBkAEAmAGZAaABrASqAQMwLjS4AQPIAQD4AQL4AQGYAgSgAsQEwgIEEAAYHsICBxAjGLECGCeYAwCSBwMwLjSgB5cb&sclient=gws-wiz-serp#', '', 0, NULL, 'Rochelle-Canteen', '2023-12-05 00:00:00.000000', NULL, 1, 0, 0, 'resources/restaurant/Rochelle_Canteen/2b512926-fd03-4264-927d-8c2adcbe8d89.png', NULL, 0, NULL, 'https://fudd.galileosoft.com/reservations/Rochelle-Canteen', 'N/A', 0, 'N/A', 0, 1, NULL, NULL),
(4, 'Pavyllon at The Four Seasons', 1, '2', 'Occasions', 'french, british, business breakfast, business lunch, business dinner, business/corporate, elegant, decadent, classic, bright, counter dining, open kitchen, light-filled, beautiful, treat your mum, special occasion, luxury, kidsfriendly', '', 'French Chef Yannick Alléno, with 15 Michelin stars to his name, has crossed the channel to make his mark by opening Pavyllon London at the Four Seasons Hotel London at Park Lane. ', 'French Chef Yannick Alléno, with 15 Michelin stars to his name, has crossed the channel to make his mark by opening Pavyllon London at the Four Seasons Hotel London at Park Lane.  The restaurant serves a British expression of his signature modern French dishes, running service from breakfast to dinner.', 'Park Lane, Hamilton Place', '', 'N/A', ' Mayfair', 'London', 'UK', 0, 0, 0, 'W1J 7DR', '2074990888', '', '51.504439', '-0.149911', 'https://www.facebook.com/PavyllonLondon/', 'https://www.instagram.com/pavyllon_london', 4.70, 'https://www.google.com/search?q=Pavyllon+at+The+Four+Seasons&sca_esv=8c2b0740c73d74e6&sxsrf=ADLYWILcmMgjvfQ0OlwWNdpQ7Y_Y9mc3dA%3A1721046389359&ei=dRWVZuDPFdG9vr0Piv6MgAI&ved=0ahUKEwig3re1hamHAxXRnq8BHQo_AyAQ4dUDCA8&uact=5&oq=Pavyllon+at+The+Four+Seasons&gs_lp=Egxnd3Mtd2l6LXNlcnAiHFBhdnlsbG9uIGF0IFRoZSBGb3VyIFNlYXNvbnMyBBAjGCcyBBAjGCcyBBAjGCcyBRAAGIAEMgsQABiABBiGAxiKBTILEAAYgAQYhgMYigUyCBAAGIAEGKIEMggQABiABBiiBDIIEAAYgAQYogQyCBAAGIAEGKIESORLUKEFWIBJcAJ4AZABAJgB0AGgAYQLqgEGMC4xMC4xuAEDyAEA-AEBmAIEoAKCA8ICChAAGLADGNYEGEfCAgYQABgHGB6YAwCIBgGQBgiSBwUyLjEuMaAHjBU&sclient=gws-wiz-serp#', '', 0, NULL, 'Pavyllon -at-The-Four-Seasons', '2023-12-05 00:00:00.000000', NULL, 1, 0, 0, 'resources/restaurant/Pavyilon_at_The_Four_Seasons/e69671ed-57ac-4cc7-be38-75cfd529863b.png', NULL, 0, NULL, 'https://fudd.galileosoft.com/reservations/Pavyllon -at-The-Four-Seasons', 'N/A', 0, 'N/A', 0, 1, NULL, NULL),
(5, 'Gunpowder', 1, '2', 'Occasions', 'date night, catch up with a friend, private dining room, indian, intimate, double date, sleek, sharing style, perfectfordate', '', 'Serving home-style Indian cuisine, Gunpowder showcases the vibrant, confident flavours of family recipes.', 'Serving home-style Indian cuisine, Gunpowder showcases the vibrant, confident flavours of family recipes.  With aesthetics inspired by historic private members clubs and golf clubs of Kolkata, Mumbai and Delhi, family recipes have influenced the sharing style menu.  Sister Spots: Spitalfields, Tower Bridge  PDR & GROUP DINING: Private dining (up to 26 guests) and exclusive hire (up to 60 guests) are available.  Email events@gunpowderrestaurants.com for more information. ', '20 Greek Street', '', 'N/A', 'Soho', 'London', 'UK', 1, 1, 1, 'W1D 4EF', '2072872870', '', '51.513861', '-0.130602', NULL, 'https://www.instagram.com/gunpowder_london', 4.30, 'https://www.google.com/search?si=ACC90nwO9xEzySNrBbeVuYhtSl5s84rzWVZlRreGH3L-IdoVybOPGo_7z_CvDm1yog9fpK-mpz4CgshyT_pu1TR8CK5ymzuuQ4uVFiMObrlCbx3DVaOgjfjtPE4lEmY1XF7ZmJ2YQb87nKlFfWH7n9Un0-wli1v_qg%3D%3D&q=Gunpowder%20Soho%20Reviews&sa=X&ved=0CBgQqe0LahcKEwjgtp7ugKmHAxUAAAAAHQAAAAAQBg&biw=1536&bih=730&dpr=1.25', '', 0, NULL, 'gunpowder', '2023-12-05 00:00:00.000000', NULL, 1, 0, 0, 'resources/restaurant/Gunpowder/92d86637-f281-4be3-abc8-380788c6ae84.png', NULL, 0, NULL, 'https://fudd.galileosoft.com/reservations/gunpowder', 'N/A', 0, 'N/A', 0, 1, NULL, NULL),
(6, 'Daddy Bao', 1, '3', 'Vibes', 'taiwanese, bao, dogsfriendly, date night, perfectfordate, neighbourhood, sleek, contemporary, cheap eats, weekend brunch', '', 'Taiwanese steamed buns & Asian small plates are offered in a sleek, contemporary space at this buzzy, neighbourhood spot.', 'Taiwanese steamed buns & Asian small plates are offered in a sleek, contemporary space at this buzzy, neighbourhood spot. Sister Spot: Mr Bao Peckham', '113 Mitcham Road', '', 'N/A', 'Tooting', 'London', 'UK', 1, 2, 0, 'SW17 9PE', '2036013232', '', '51.425573', '-0.164319', 'https://www.facebook.com/daddybao/', 'https://www.instagram.com/daddybao', 4.60, 'https://www.google.com/search?q=daddy+bao&sca_esv=8c2b0740c73d74e6&sxsrf=ADLYWILq72MylA0gc6eQ6mTnTddlXAvvGw%3A1721046226902&ei=0hSVZrDmNvPb1e8P14KJoQs&oq=Daddy-Bao&gs_lp=Egxnd3Mtd2l6LXNlcnAiCURhZGR5LUJhbyoCCAAyBBAAGB4yBBAAGB4yBBAAGB4yBBAAGB4yBhAAGA0YHjIEEAAYHjIGEAAYDRgeMgQQABgeMgYQABgNGB4yBBAAGB5I0wxQAFgAcAB4AZABAJgBoQGgAaEBqgEDMC4xuAEByAEA-AEC-AEBmAIBoAKlAZgDAJIHAzAuMaAH0QU&sclient=gws-wiz-serp#', '', 0, NULL, 'Daddy-Bao', '2023-12-05 00:00:00.000000', NULL, 1, 0, 0, 'resources/restaurant/Daddy_Bao/7f91030f-f96e-4b72-9099-0036b1745b63.png', NULL, 0, NULL, 'https://fudd.galileosoft.com/reservations/Daddy-Bao', 'N/A', 0, 'N/A', 0, 1, NULL, NULL),
(8, 'Black Rabbit Cafe', 1, '1', 'Cuisines', 'casual, dogsfriendly, meeting spot, catch up with a friend, cafe', '', 'Casual nighbourhood cafe in Earls Court serving simple, classic brunch dishes and specialty coffee in a friendly, laidback setting.', '', '308 Old Brompton Road', '', 'N/A', 'Earls Court', 'London', 'UK', 1, 3, 2, 'SW5 9JF', NULL, '', '51.488348', '-0.1935765', NULL, 'https://www.instagram.com/blackrabbit_cafe/', 3.80, 'https://www.google.com/search?q=black+rabbit+cafe&sca_esv=8c2b0740c73d74e6&sxsrf=ADLYWIK04IhfvWHD3iT3KF8LV3yS7SX_6A%3A1721046283448&ei=CxWVZpmHG8mjvr0P8OKzmAk&ved=0ahUKEwjZuPeChamHAxXJka8BHXDxDJMQ4dUDCA8&uact=5&oq=black+rabbit+cafe&gs_lp=Egxnd3Mtd2l6LXNlcnAiEWJsYWNrIHJhYmJpdCBjYWZlMgoQIxiABBgnGIoFMgYQABgHGB4yCxAuGIAEGMcBGK8BMgUQABiABDIFEAAYgAQyBRAAGIAEMgUQABiABDIFEAAYgAQyBRAAGIAEMgUQABiABEjZIlAAWPgdcAB4AJABAJgBvgGgAd8HqgEDMC43uAEDyAEA-AEC-AEBmAIHoAKGCMICBxAjGLACGCfCAg0QLhiABBjHARgNGK8BwgIHEAAYgAQYDZgDAJIHBTAuNi4xoAeuRA&sclient=gws-wiz-serp#', '', 0, NULL, 'black_rabbit_cafe', '2023-11-17 12:05:20.000000', NULL, 1, 0, 0, 'resources/restaurant/black_rabbit_cafe/ckur45g0iz59a0886r2k925nk1702460746505.jpeg', NULL, 0, NULL, 'https://fudd.galileosoft.com/reservations/black_rabbit_cafe', 'N/A', 0, 'N/A', 0, 1, NULL, NULL),
(11, 'Nigeria', 6, '1', 'Cuisines', 'francaise,India Vibes', '47,46', 'Best Disss Here', 'Best Diss Here', 'St Johns', '5ème  Métro Cluny Sorbonne', 'N/A', 'Paris', 'Paris', 'FR', 0, 0, 0, '987898', '9809878080', '', '7909090', '-79090000', 'https://www.facebook.com/Embassy-of-Nigeria-Paris-518452521525214/', NULL, 3.50, NULL, '20-40€', 0, 'N/A', 'N/A', '2024-06-20 12:37:35.000000', '2024-06-20 12:37:35.000000', 1, 0, 0, 'resources/restaurant/1718887055_rest.jpg', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/N/A', '49.47.132.113', 24, 'Super Admin', 1, 1, NULL, '2024-06-20 07:07:35'),
(64, 'Pepita Paris', 22, '1', 'Cuisines', 'Italian,Italian', '31,30', 'Au cœur de Saint-Germain, dans le 5ème arrondissement parisien, Pepita vous', 'Au cœur de Saint-Germain, dans le 5ème arrondissement parisien, Pepita vous accueille dans son espace chaleureux pour une escapade culinaire italienne authentique. La brasserie italienne se distingue par une carte riche en saveurs, célébrant les classiques de l\\\'Italie comme les pizzas artisanales, pâtes fraîches, et une sélection d\\\'antipasti, le tout dans l\\\'ambiance conviviale et élégante de Paris. Chez Pepita, chaque repas est une invitation à découvrir les délices de l\\\'Italie, au cœur de Saint-Germain.\r\n\r\nIn the heart of Saint-Germain, in the 5th arrondissement of Paris, Pepita welcomes you to its warm space for an authentic Italian culinary escapade. The Italian brasserie stands out with a menu rich in flavors, celebrating Italian classics such as artisanal pizzas, fresh pastas, and a selection of antipasti, all in the friendly and elegant atmosphere of Paris. At Pepita, each meal is an invitation to discover the delights of Italy, in the heart of Saint-Germain.', 'Cluny La Sorbonne, Paris, France', '5ème  Métro Cluny Sorbonne', '', 'Paris', 'Paris', 'FR', 1, 1, 1, '75005', '3456576767', '', '48.85089120000001', '2.3452743', 'https://www.facebook.com/pepitastgermain', 'https://www.instagram.com/pepita_paris/?hl=fr', 4.70, 'https://www.google.com/search?q=Pepita+Paris&sca_esv=8c2b0740c73d74e6&sxsrf=ADLYWILQKWd6g5rVTB8uqEmH9IfV0pu-qw%3A1721045533132&ei=HRKVZu7XB4qg1e8Pj-f04Ag&ved=0ahUKEwiu2pOdgqmHAxUKUPUHHY8zHYwQ4dUDCA8&uact=5&oq=Pepita+Paris&gs_lp=Egxnd3Mtd2l6LXNlcnAiDFBlcGl0YSBQYXJpczIKECMYgAQYJxiKBTILEC4YgAQYxwEYrwEyBRAAGIAEMgUQABiABDIFEAAYgAQyBhAAGBYYHjIGEAAYFhgeMgYQABgWGB4yBhAAGBYYHjIIEAAYFhgKGB4yGhAuGIAEGMcBGK8BGJcFGNwEGN4EGOAE2AEBSOoMUL4FWL4FcAF4AZABAJgBrQGgAa0BqgEDMC4xuAEDyAEA-AEC-AEBmAICoAK-AcICChAAGLADGNYEGEeYAwCIBgGQBgi6BgYIARABGBSSBwMxLjGgB6wJ&sclient=gws-wiz-serp#', '20-40€', 0, 'N/A', 'Pepita_Paris', '2024-06-20 12:36:21.000000', '2024-06-20 12:36:21.000000', 1, 0, 0, 'resources/restaurant/1718886981_1.jpg', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Pepita_Paris', '49.47.132.113', 24, 'Super Admin', 1, 1, '2024-06-04 07:41:40', '2024-06-20 07:06:21'),
(65, 'Neko Ramen Green', 22, '2', 'Occasions', 'budgetfriendly, goodformoney, authenticfood, veganoptions, japonesefood, Japonais, Japonese', '31,30', 'Passionné par le Japon et sa cuisine depuis son enfance, le propriétaire Sedrik est parti au Japon pour faire une école de cuisine.', 'Passionné par le Japon et sa cuisine depuis son enfance, le propriétaire Sedrik est parti au Japon pour faire une école de cuisine. Avec son diplôme de la meilleure école de Ramens en poche, il a ensuite ouvert deux restaurants à Paris. C\\\'est une cuisine authentique et bio qu\\\'il propose à la carte.\r\n\r\nPassionate about Japan cuisine since childhood, owner Sedrik went to Japan to attend cooking school. With his diploma from the best Ramens school in hand, he then opened two restaurants in Paris. Authentic and organic cuisine that he offers à la carte.', 'Poissonnière, Paris, France', '10ème  Métro Poissonière', '', 'Paris', 'Paris', 'FR', 1, 1, 1, '75010', '4343109011', '', '48.8773174', '2.3491434', NULL, NULL, 0.00, 'https://www.google.com/search?q=neko+ramen+green+paris&oq=Neko+Ramen+Green&gs_lcrp=EgZjaHJvbWUqDAgCEAAYFBiHAhiABDIKCAAQABjjAhiABDINCAEQLhivARjHARiABDIMCAIQABgUGIcCGIAEMgcIAxAAGIAEMgcIBBAAGIAEMgcIBRAAGIAEMggIBhAAGBYYHjIICAcQABgWGB4yCAgIEAAYFhgeMggICRAAGBYYHtIBCDM2MDZqMGo0qAIAsAIB&sourceid=chrome&ie=UTF-8#', '0', 0, 'N/A', 'Neko_Ramen_Green', '2024-06-05 05:01:45.000000', '2024-06-05 05:01:45.000000', 1, 0, 0, 'resources/restaurant/1717563705_2.jpg', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Neko_Ramen_Green', '49.47.132.113', 24, 'Super Admin', 1, 1, '2024-06-04 08:04:27', '2024-06-04 23:31:45'),
(66, 'Madonna', 6, '2', 'Occasions', 'instagramfamous, perfectforadate, italianfood, Italien, cocktaillover, nicebar, dogsfriendly', '31,30', 'Inspirée des Grands Cafés du Nord de l\\\'Italie et des Osterias Milanaises', 'Inspirée des Grands Cafés du Nord de l\\\'Italie et des Osterias Milanaises, l\\\'osteria Madonna propose une belle sélection de cocktails italiens et une carte conçus par le Chef d\\\'Aquila. A la carte, pas de pizzas mais un menu fait d\\\'antipasti, primi piatti et secondi piatti.\r\n\r\nInspired by the Grand Cafés of Northern Italy and the Milanese Osterias, the osteria Madonna offers a fine selection of Italian cocktails and a menu designed by the Chef d\\\'Aquila. On the menu, no pizzas but plenty of antipasti, primi piatti and secondi piatti to choose from.', 'Le Peletier, Rue de la Victoire, Paris, France', '9ème  Métro Le Peletier', '', 'Paris', 'Paris', 'FR', 1, 0, 0, '75009', '4343434311', '', '48.87469830000001', '2.3398479', NULL, 'https://www.instagram.com/madonna.osteria/', 4.60, 'https://www.google.com/search?q=madonna+paris+restaurant&sca_esv=8c2b0740c73d74e6&sxsrf=ADLYWIJXzYEe8TWfvUJ3xXUCkNuz3iDhvQ%3A1721045797150&ei=JROVZpDwCPypvr0Pmb-mcA&oq=Madonna+paris+res&gs_lp=Egxnd3Mtd2l6LXNlcnAiEU1hZG9ubmEgcGFyaXMgcmVzKgIIADIFEAAYgAQyBRAAGIAEMgYQABgWGB4yBhAAGBYYHjIIEAAYFhgKGB4yBhAAGBYYHjIGEAAYFhgeMgYQABgWGB4yBhAAGBYYHjILEAAYgAQYhgMYigVIpSRQAFiZGnAAeAGQAQCYAYECoAH0DaoBBTAuOS4yuAEByAEA-AEBmAILoAKhDsICChAjGIAEGCcYigXCAg0QABiABBixAxhDGIoFwgIKEC4YgAQYQxiKBcICChAAGIAEGEMYigXCAg0QLhiABBixAxhDGIoFwgIFEC4YgATCAgsQABiABBiRAhiKBcICCxAuGIAEGJECGIoFwgIXEC4YgAQYkQIYxwEYmAUYmQUYigUYrwHCAg4QLhiABBjHARiOBRivAcICCxAuGIAEGMcBGK8BwgIKEAAYgAQYFBiHApgDAJIHBTAuOS4yoAe4ggE&sclient=gws-wiz-serp#', '0', 0, 'N/A', 'Madonna', '2024-06-06 05:40:09.000000', '2024-06-06 05:40:09.000000', 1, 0, 0, 'resources/restaurant/1717652409_3.jpg', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Madonna', 'N/A', 0, 'N/A', 1, 1, '2024-06-06 00:10:09', '2024-06-06 00:10:09'),
(67, 'Chez Minna', 6, '3', 'Vibes', 'Corsica, Corse, authenticfood, corsicanfood, warmatmosphere', '32,33', 'Voyage en Corse au coeur du 10ème arrondissement.', 'Voyage en Corse au coeur du 10ème arrondissement.\r\nA deux pas des Grands Boulevards, de ses célèbres théâtres et cinémas, la Corse haute en couleurs et en saveurs se déguste dans un cadre vintage original et chaleureux. Découvrez la cuisine, goûteuse et de qualité, du restaurant Chez Minnà, votre grand-mère Corse !\r\n\r\nTravel to Corsica in the heart of the 10th arrondissement. A stone\\\'s throw from the Grands Boulevards and its famous theaters and cinemas, Corsica full of colors and flavors can be enjoyed in an original and warm vintage setting. Discover the tasty and quality cuisine of the restaurant Chez Minnà, your Corsican grandmother!', 'Métro Strasbourg St Denis Ligne 4, 8 et 9, Boulevard de Bonne Nouvelle, Paris, France', '10ème  Métro Strasbourg St Denis', '', 'Paris', 'Paris', 'FR', 1, 0, 0, '75002', '4341119011', '', '48.8696999', '2.3520199', NULL, 'https://www.instagram.com/chezminna/', 4.60, 'https://www.google.com/search?q=chez+minna+paris&sca_esv=8c2b0740c73d74e6&sxsrf=ADLYWIIQLQKjPasitBhmF5iOJXIIXt6PnQ%3A1721045803644&ei=KxOVZrH_Jvapvr0Pqv-H-QM&oq=Chez_Minna&gs_lp=Egxnd3Mtd2l6LXNlcnAiCkNoZXpfTWlubmEqAggBMgQQABgeMgQQABgeMgQQABgeMgQQABgeMgQQABgeMgQQABgeMgQQABgeMgQQABgeMgQQABgeMgQQABgeSJcOUABYAHAAeACQAQCYAbQBoAG0AaoBAzAuMbgBAcgBAPgBAvgBAZgCAaACuQGYAwCSBwMwLjGgB9AF&sclient=gws-wiz-serp#', '0', 0, 'N/A', 'Chez_Minna', '2024-06-06 05:46:08.000000', '2024-06-06 05:46:08.000000', 1, 0, 0, 'resources/restaurant/1717652768_4.jpg', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Chez_Minna', 'N/A', 0, 'N/A', 1, 1, '2024-06-06 00:16:08', '2024-06-06 00:16:08'),
(68, 'Malro', 6, '3', 'Vibes', 'authenticfood, mediterraneanfood, warmatmosphere, nicebar, cocktaillover, openlate', '35,34', 'En plein coeur du Haut-Marais, une néo-brasserie méditerranéenne,un cadre aux volumes impressionnants et un jardin d\\\'hiver chaleureux', 'En plein coeur du Haut-Marais, une néo-brasserie méditerranéenne,un cadre aux volumes impressionnants et un jardin d\\\'hiver chaleureux,\r\nMalro propose une cuisine de saison, colorée et conviviale, un bar qui saura satisfaire les plus grands amateurs de cocktails , ainsi qu\\\'un espace Take Away pour le déjeuner.\r\n\r\nIn the heart of Haut-Marais, a Mediterranean neo-brasserie, a setting with impressive volumes and a warm winter garden,\r\nMalro offers seasonal, colorful and friendly cuisine, a bar that will satisfy the biggest cocktail lovers, as well as a Take Away area for lunch.', 'Metro Saint-Sébastien - Froissart, Paris, France', '3ème  Métro Sebastien-Froissard', '', 'Paris', 'Paris', 'FR', 0, 1, 0, '75011', '4343119011', '', '48.8611339', '2.3673656', NULL, 'https://www.instagram.com/malro_restaurant/', 4.30, 'https://www.google.com/search?q=Malro+paris&sca_esv=8c2b0740c73d74e6&sxsrf=ADLYWIIIIhDb8HefKdRVPG-pXpLRxs51dw%3A1721045982138&ei=3hOVZveRCJC1vr0P_7S9-Ak&ved=0ahUKEwj3-KDzg6mHAxWQmq8BHX9aD58Q4dUDCA8&uact=5&oq=Malro+paris&gs_lp=Egxnd3Mtd2l6LXNlcnAiC01hbHJvIHBhcmlzMgYQABgHGB4yCxAuGIAEGMcBGK8BMgYQABgHGB4yBhAAGAcYHjIGEAAYBxgeMgUQABiABDIEEAAYHjIEEAAYHjIEEAAYHjIEEAAYHkibAlAAWABwAHgAkAEAmAG1AaABtQGqAQMwLjG4AQPIAQD4AQL4AQGYAgGgAr0BmAMAkgcDMC4xoAeTCA&sclient=gws-wiz-serp#', '0', 0, 'N/A', 'Malro', '2024-06-14 05:37:22.000000', '2024-06-14 05:37:22.000000', 1, 0, 0, 'resources/restaurant/1718343442_5_.jpg', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Malro', '49.47.132.113', 24, 'Super Admin', 1, 2, '2024-06-06 00:20:00', '2024-06-14 00:07:22'),
(69, 'Brasserie Des Prés', 6, '1', 'Cuisines', 'budgetfriendly, authenticfood, veganoptions, instagramfamou, frenchcuisine, authenticbrasserie', '38,37,36', 'Nichée au coeur de l’adorable Cour du Commerce à Saint-Germain-Des-Prés, la', 'Nichée au coeur de l’adorable Cour du Commerce à Saint-Germain-Des-Prés, la Brasserie Des Prés, quatrième adresse de la Nouvelle Garde, embrase les désirs d’escapade sur la rive gauche. Elle offre près de 180 couverts dedans et se gonfle de 40 places en terrasse. Cette fière table de terroir à l’ambiance toujours aussi cadencée se frotte pour la première fois aux grands classiques presque bourgeois de la cuisine traditionnelle française.\r\n\r\nNestled in the heart of the adorable Cour du Commerce in Saint-Germain-Des-Prés, Brasserie Des Prés, the fourth address of the Nouvelle Garde, ignites the desire for a getaway on the left bank. It offers nearly 180 seats inside and expands to 40 seats on the terrace. This proud local restaurant with its always rhythmic atmosphere rubs shoulders for the first time with the great, almost bourgeois classics of traditional French cuisine.', 'Odéon, Paris, France', '6ème  Métro Odéon', '', 'Paris', 'Paris', 'FR', 0, 1, 0, '75006', '4343109000', '', '48.8521528', '2.3396232', 'https://www.facebook.com/nouvellegardegroupe', 'https://www.instagram.com/lanouvellegarde/', 4.70, 'https://www.google.com/search?q=Brasserie+Des+Pr%C3%A9s&sca_esv=8c2b0740c73d74e6&sxsrf=ADLYWIJlpdUoDcEEag-2S6CVlEbRzUMFNg%3A1721046027545&ei=CxSVZqb7IJ_p1e8P5ZTtuAc&ved=0ahUKEwjmrPSIhKmHAxWfdPUHHWVKG3cQ4dUDCA8&uact=5&oq=Brasserie+Des+Pr%C3%A9s&gs_lp=Egxnd3Mtd2l6LXNlcnAiE0JyYXNzZXJpZSBEZXMgUHLDqXMyBhAAGAcYHjIGEAAYBxgeMgYQABgHGB4yBRAAGIAEMgUQABiABDIFEAAYgAQyBRAAGIAEMgUQABiABDIFEAAYgAQyBRAAGIAESKI_UABY_zZwAXgAkAEAmAGyAaABsAmqAQMwLji4AQPIAQD4AQL4AQGYAgmgAtkJwgIEEAAYHsICDRAuGIAEGMcBGA0YrwHCAgcQABiABBgNmAMAkgcDMS44oAf4Nw&sclient=gws-wiz-serp#', '20-40€', 0, 'N/A', 'Brasserie_Des_Prés', '2024-06-18 10:54:22.000000', '2024-06-18 10:54:22.000000', 1, 0, 0, 'resources/restaurant/1718344745_6.jpg', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Brasserie_Des_Prés', '49.47.132.113', 24, 'Super Admin', 1, 2, '2024-06-06 00:25:52', '2024-06-18 05:24:22'),
(70, 'Marie Akaneya', 6, '1', 'Cuisines', 'uniqueexperience, finedining, japonesecuisine\n', '40,39,38', 'Le restaurant Marie Akaneya ouvre ses portes en mai 2023. C’est le premier sumibiyaki de Paris et le premier', 'Le restaurant Marie Akaneya ouvre ses portes en mai 2023. C’est le premier sumibiyaki de Paris et le premier restaurant implanté hors du Japon proposant de la viande provenant d’Ito Ranch, la ferme produisant du Matsusaka Beef la plus récompensée et exclusive du pays. C’est également le premier établissement en France et l’un des trois seuls établissements en Europe proposant le ‘muskmelon’ Crown Melon de Fukuroi.\r\n\r\nThe Marie Akaneya restaurant opens its doors in May 2023. It is the first sumibiyaki in Paris and the first restaurant outside Japan offering meat from Ito Ranch, the country\\\'s most awarded and exclusive Matsusaka Beef farm. . It is also the first establishment in France and one of only three establishments in Europe offering Fukuroi Crown Melon ‘muskmelon’.', 'Métro Madeleine, Rue Tronchet, Paris, France', '9ème  Métro Madeleine', '', 'Paris', 'Paris', 'FR', 0, 0, 1, '75008', '2143109011', '', '48.87118470000001', '2.3250394', NULL, 'https://www.instagram.com/marieakaneya/', 4.70, 'https://www.google.com/search?q=marie+akaneya&oq=Marie+Akaneya&gs_lcrp=EgZjaHJvbWUqCggAEAAY4wIYgAQyCggAEAAY4wIYgAQyDQgBEC4YrwEYxwEYgAQyBwgCEAAYgAQyBwgDEAAYgAQyBwgEEAAYgAQyBwgFEAAYgAQyBggGEAAYHjIGCAcQABgeMgYICBAAGB4yCAgJEAAYBRge0gEIMjU1M2owajSoAgCwAgE&sourceid=chrome&ie=UTF-8#', '100€+', 0, 'N/A', 'Marie_Akaneya', '2024-06-14 05:57:29.000000', '2024-06-14 05:57:29.000000', 1, 0, 0, 'resources/restaurant/1717653694_7.jpg', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Marie_Akaneya', '49.47.132.113', 24, 'Super Admin', 1, 2, '2024-06-06 00:31:34', '2024-06-14 00:27:29'),
(71, 'Choukran', 6, '2,1', 'Cuisines,Occasion', 'Cuisine,Moroccan,Marocain', '42,41,38', 'Les meilleurs couscous du monde selon le chef Abdel Alaoui dans une ambiance marocaine chaleureuse et cool où rires riment avec partage. Plats à emporter.', 'Les meilleurs couscous du monde selon le chef Abdel Alaoui dans une ambiance marocaine chaleureuse et cool où rires riment avec partage. Plats à emporter.\r\n\r\nThe best couscous in the world according to chef Abdel Alaoui in a warm and cool Moroccan atmosphere where laughter rhymes with sharing. Take away available.', 'Notre-Dame-de-Lorette, Rue Bourdaloue, Paris, France', '9ème  Métro Notre-Dame-de-Lorette', '', 'Paris', 'Paris', 'FR', 1, 4, 3, '75009', '2134567678', '', '48.87616990000001', '2.3385969', 'N/A', 'https://www.instagram.com/choukran.club/', 4.70, 'https://www.google.com/search?q=Choukran+paris&sca_esv=8c2b0740c73d74e6&sxsrf=ADLYWIIK8Y4COYM8zBaeJXQ03bjrO6Vezg%3A1721046149537&ei=hRSVZv3AIOyOseMPy7uuuAU&ved=0ahUKEwi9l4rDhKmHAxVsR2wGHcudC1cQ4dUDCA8&uact=5&oq=Choukran+paris&gs_lp=Egxnd3Mtd2l6LXNlcnAiDkNob3VrcmFuIHBhcmlzMgUQABiABDIFEAAYgAQyBhAAGBYYHjIGEAAYFhgeMgYQABgWGB4yBhAAGBYYHjIIEAAYFhgKGB4yChAAGIAEGBQYhwIyBhAAGBYYHjIGEAAYFhgeSJ8eUP8EWOEccAF4AZABAJgBmgGgAYMIqgEDMC43uAEDyAEA-AEC-AEBmAIJoALrD8ICChAAGLADGNYEGEfCAg0QABiABBiwAxhDGIoFwgINEC4YgAQYsAMYQxiKBcICCxAuGIAEGMcBGK8BwgIaEC4YgAQYxwEYrwEYlwUY3AQY3gQY4ATYAQHCAgUQLhiABMICBxAAGIAEGAqYAwCIBgGQBgq6BgYIARABGBSSBwcxLjcuNi0xoAfzLQ&sclient=gws-wiz-serp#', '10-20€', 0, 'N/A', 'Choukran', '2024-07-23 13:31:21.000000', '2024-07-23 13:31:21.000000', 1, 0, 0, 'resources/restaurant/1718340650_9.jpg', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Choukran', '49.47.132.165', 24, 'Super Admin', 1, 2, '2024-06-06 00:36:15', '2024-07-23 08:01:21'),
(72, 'Boubale', 6, '1', 'Cuisines', 'Cuisine,Europe de l\\\'Est,Eastern,European', '45,44,43,38', 'Niché au sein de l’hôtel le Grand Mazarin, Boubalé est cet espace aux multiples et scintillantes facettes.', 'Niché au sein de l’hôtel le Grand Mazarin, Boubalé est cet espace aux multiples et scintillantes facettes.\r\nExpression favorite des grands-mères ashkénazes, Boubalé est le nom tendre pour dire «ma petite poupée, ma petite chérie » en yiddish. C’est fort de cette mémoire que le chef étoilé Assaf Granit réinvente cette cuisine qui vient du plus profond de l’âme. \r\nPorte ouverte sur un art de vivre et un art de vie, Boubalé nourrit les cœurs comme les corps en réinventant un audacieux, chic et très inédit festin contemporain inspiré par les régals d’une Europe de l’Est chatoyante et gourmande.\r\n\r\nNestled within the Grand Mazarin hotel, Boubalé is this space with multiple and scintillating facets.\r\nA favorite expression of Ashkenazi grandmothers, Boubalé is the tender name for “my little doll, my little darling” in Yiddish. It is with this memory that star chef Assaf Granit reinvents this cuisine that comes from the depths of the soul.\r\nAn open door to an art of living and an art of living, Boubalé nourishes hearts and bodies by reinventing a daring, chic and very unique contemporary feast inspired by the delights of a shimmering and gourmet Eastern Europe.', 'metro, Rue Sainte-Croix de la Bretonnerie, Paris, France', '4ème  Métro Hotel de Ville', '', 'Paris', 'Paris', 'FR', 1, 1, 2, '75004', '4343109012', '', '48.85858270000001', '2.354628900000001', NULL, 'https://www.instagram.com/boubale.paris/', 4.30, 'https://www.google.com/search?q=boubal%C3%A9+restaurant&sca_esv=8c2b0740c73d74e6&sxsrf=ADLYWII3JFvjXj5Ep-M2NfEMkiZlmo9iBA%3A1721046188187&ei=rBSVZpOOC5yavr0Pnr6I8Q4&oq=Boubale&gs_lp=Egxnd3Mtd2l6LXNlcnAiB0JvdWJhbGUqAggBMgsQLhiABBjHARivATIKEAAYgAQYFBiHAjIFEAAYgAQyBRAAGIAEMgUQABiABDIHEAAYgAQYCjIFEAAYgAQyBRAAGIAEMgoQABiABBgUGIcCMgUQABiABEiAD1AAWABwAHgBkAEAmAG5AaABuQGqAQMwLjG4AQPIAQD4AQL4AQGYAgOgAskdwgIaEC4YgAQYxwEYrwEYlwUY3AQY3gQY4ATYAQGYAwC6BgYIARABGBSSBwcwLjEuNy0yoAf4Bw&sclient=gws-wiz-serp#', '50-60€', 0, 'N/A', 'Boubale', '2024-06-20 05:47:57.000000', '2024-06-20 05:47:57.000000', 1, 0, 0, 'resources/restaurant/1718341486_10.jpg', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Boubale', '49.47.132.113', 24, 'Super Admin', 1, 2, '2024-06-06 00:44:07', '2024-06-20 00:17:57'),
(85, 'Tarun Desi Tadka', 40, '7', 'Desi Vibes', 'India Vibes', '47', 'ABC Tarun Update', 'Test Tarun Update', 'Mayur Vihar Phase I, Delhi, India', 'B Saket Block', '', 'Noida', 'Uttar Pradesh', 'IN', 0, 0, 0, '110091', '8851223376', '8447880910', '28.6146243', '77.3121575', NULL, NULL, 3.00, NULL, '0', 0, 'N/A', 'Tarun_Desi_Tadka', '2024-06-20 13:49:38.000000', '2024-06-20 13:49:38.000000', 1, 0, 0, 'resources/restaurant/1718886227_image_2024_06_20T07_16_29_217Z.png', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Tarun_Desi_Tadka', '49.47.132.113', 24, 'Super Admin', 1, 2, '2024-06-20 06:53:47', '2024-06-20 08:19:38'),
(86, 'Oktobre', 22, '1', 'Cuisines', 'francaise,finedining,localproducts,uniqueexperience,michelinstyle,perfectforadate,nicedecor', '53,52,51,50,49,48,46', 'Expression favorite des grands-mères ashkénazes, Boubalé est le nom tendre pour dire «ma petite poupée.', 'Expression favorite des grands-mères ashkénazes, Boubalé est le nom tendre pour dire «ma petite poupée, ma petite chérie » en yiddish. C’est fort de cette mémoire que le chef étoilé Assaf Granit réinvente cette cuisine qui vient du plus profond de l’âme.', '25 Rue des Grands Augustins, 75006 Paris, France', '25 Rue des Grands Augustins, 75006 Paris', '', 'Paris', 'Paris', 'FR', 0, 0, 0, '75006', '00000000000', '', '48.8537502', '2.3403691', 'N/A', 'https://instagram.com/restaurant.oktobre?igshid=MzRlODBiNWFlZA==', 4.80, 'https://www.google.fr/search?q=oktobre&sca_esv=d7a9dca790d176ff&ei=8yCjZurPJ8OZvr0P0sbp0QY&ved=0ahUKEwiqlbes6sOHAxXDjK8BHVJjOmoQ4dUDCBA&uact=5&oq=oktobre&gs_lp=Egxnd3Mtd2l6LXNlcnAiB29rdG9icmUyChAAGIAEGEMYigUyBRAAGIAEMgUQABiABDIFEAAYgAQyBRAAGIAEMgUQABiABDIFEAAYgAQyBRAAGIAEMgUQABiABDIKEAAYgAQYyQMYCkjyCFDdBVjxBnACeAGQAQCYAYsBoAGAAqoBAzAuMrgBA8gBAPgBAZgCBKAClQLCAgoQABiwAxjWBBhHwgIHEAAYgAQYCpgDAIgGAZAGBZIHAzIuMqAHxwo&sclient=gws-wiz-serp#', '100€+', 0, 'N/A', 'Oktobre', '2024-07-26 04:22:06.000000', '2024-07-26 04:22:06.000000', 1, 0, 0, 'resources/restaurant/1721967726_Oktobre.webp', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Oktobre', '103.46.200.69', 24, 'Super Admin', 1, 1, '2024-07-25 22:50:54', '2024-07-25 22:52:06'),
(87, 'La Baignoire', 22, '1', 'Cuisines', 'francaise,uniqueexperience,perfectforadate,instagramfamous,idealwithfriends,greatatmosphere,fuud favourite,finedining,fivestarservice,openlate', '46,54,55,56,57,58,59,60,61,62', 'Porte ouverte sur un art de vivre et un art de vie, Boubalé nourrit les cœurs comme les corps en réinventant un audacieux.', 'Porte ouverte sur un art de vivre et un art de vie, Boubalé nourrit les cœurs comme les corps en réinventant un audacieux, chic et très inédit festin contemporain inspiré par les régals d’une Europe de l’Est chatoyante et gourmande.', '7 Rue Notre Dame de Bonne Nouvelle, 75002 Paris, France', '7 Rue Notre Dame de Bonne Nouvelle', '', 'Paris', 'Paris', 'FR', 0, 0, 0, '75002', '000000000', '', '48.8697165', '2.3496815', 'N/A', 'N/A', 4.50, 'https://www.google.com/search?q=labaignoirerestaurant&oq=labaignoirerestaurant&gs_lcrp=EgZjaHJvbWUyBggAEEUYOTIJCAEQABgNGIAEMggIAhAAGA0YHjIICAMQABgNGB4yDQgEEAAYhgMYgAQYigUyDQgFEAAYhgMYgAQYigUyDQgGEAAYhgMYgAQYigUyCggHEAAYgAQYogQyCggIEAAYgAQYogQyCggJEAAYgAQYogTSAQkxMDE4ajBqMTWoAgiwAgE&sourceid=chrome&ie=UTF-8#', '50-60€', 0, 'N/A', 'La_Baignoire', '2024-07-26 04:53:01.000000', '2024-07-26 04:53:01.000000', 1, 0, 0, 'resources/restaurant/1721969581_P1120225-2048x1536.webp', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/La_Baignoire', 'N/A', 0, 'N/A', 1, 1, '2024-07-25 23:23:01', '2024-07-25 23:23:01'),
(88, 'Legendrement Bon', 22, '1', 'Cuisines', 'francaise,delishop,tastingtable,epiceriefine,traiteuravectables,authenticfood,frenchcuisine,intimateexperience,perfectforadate,heeselover', '46,63,64,65,66,67,68,69,70,71', '', '', '46 Rue Legendre, 75017 Paris, France', '46 Rue Legendre,', '', 'Paris', 'Paris', 'FR', 0, 0, 0, '75017', '000000000', '', '48.8847142', '2.3154211', 'N/A', 'N/A', 5.00, 'N/A', '40-60€', 0, 'N/A', 'Legendrement_Bon', '2024-07-26 05:09:49.000000', '2024-07-26 05:09:49.000000', 1, 0, 0, 'resources/restaurant/1721970589_version_400_charchuteries.jpeg', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Legendrement_Bon', 'N/A', 0, 'N/A', 1, 1, '2024-07-25 23:39:49', '2024-07-25 23:39:49'),
(89, 'Sinner Paris', 22, '1', 'Cuisines', 'uniqueexperience,inedinging,mediterranean,instagramfamous,partyplace,idealwithfriends,celebration,ethnicfood,warmatmosphere,nicebar,cocktaillover,openlate', ',72,73,74,75,76,77,78,79,80,81,82,83', 'Nestled within the Grand Mazarin hotel, Boubalé is this space with multiple and scintillating facets.', 'Nestled within the Grand Mazarin hotel, Boubalé is this space with multiple and scintillating facets.', '116 Rue du Temple, 75003 Paris, France', '116 Rue du Temple,', '', 'Paris', 'Paris', 'FR', 0, 0, 1, '75003', '', '', '48.8630854', '2.3581492', 'N/A', 'N/A', 4.10, 'N/A', '60-200€', 0, 'N/A', 'Sinner_Paris', '2024-07-26 05:25:16.000000', '2024-07-26 05:25:16.000000', 1, 0, 0, 'resources/restaurant/1721971516_SINNER_patisserie_Celeste_luxe_3emeGuillaume_Czerw_Agent_Mel.jpg', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Sinner_Paris', 'N/A', 0, 'N/A', 1, 1, '2024-07-25 23:55:16', '2024-07-25 23:55:16'),
(90, 'Alluma', 22, '1', 'Cuisines', 'finedining,localproducts,uniqueexperience,michelinstyle,perfectforadate,nicedecor', '89,88,87,86,85,84', 'A favorite expression of Ashkenazi grandmothers, Boubalé is the tender name for “my little doll, my little darling” in Yiddish.', 'A favorite expression of Ashkenazi grandmothers, Boubalé is the tender name for “my little doll, my little darling” in Yiddish. It is with this memory that star chef Assaf Granit reinvents this cuisine that comes from the depths of the soul.', '151 Rue Saint-Maur, 75011 Paris, France', '151 Rue Saint-Maur,', '', 'Paris', 'Paris', 'FR', 0, 0, 0, '75011', '', '', '48.8681517', '2.3749043', 'N/A', 'https://www.instagram.com/alluma.paris', 4.80, 'N/A', '60-200€', 0, 'N/A', 'Alluma', '2024-07-26 05:30:40.000000', '2024-07-26 05:30:40.000000', 1, 0, 0, 'resources/restaurant/1721971792_Copy-of-alluma-oct22@lephotographedudimanche-90-768x1152.jpg', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Alluma', '152.59.46.25', 24, 'Super Admin', 1, 1, '2024-07-25 23:59:52', '2024-07-26 00:00:40'),
(91, 'Maison Sauvage', 22, '1', 'Cuisines', 'brunch,cocktaillover,instagramfamous,openlate', ',90,91,92,93', 'An open door to an art of living and an art of living, Boubalé nourishes hearts and bodies by reinventing a daring', 'An open door to an art of living and an art of living, Boubalé nourishes hearts and bodies by reinventing a daring, chic and very unique contemporary feast inspired by the delights of a shimmering and gourmet Eastern Europe.', '5 Rue de Buci, 75006 Paris, France', '5 Rue de Buci,', '', 'Paris', 'Paris', 'FR', 0, 0, 0, '75006', '', '', '48.8536802', '2.338084', 'https://www.facebook.com/MaisonSauvageParis', 'https://www.instagram.com/maisonsauvageparis', 3.80, 'N/A', '0', 0, 'N/A', 'Maison_Sauvage', '2024-07-26 05:35:00.000000', '2024-07-26 05:35:00.000000', 1, 0, 0, 'resources/restaurant/1721972100_ILLUSTRATION-MS-VH.png', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Maison_Sauvage', 'N/A', 0, 'N/A', 1, 1, '2024-07-26 00:05:00', '2024-07-26 00:05:00'),
(92, 'Sosso Restaurant', 22, '1', 'Cuisines', 'authenticfood,lebanese,mediterranean,sharingplates,brunch,idealwithfriends,kidsfriendly,budgetfriendly', ',94,95,96,97,98,99,100,101', '\\\"Soraya, dite « Sosso », c’est un peu la mamma méditerranéenne que l’on a tous rêvé de connaître.', '\\\"Soraya, dite « Sosso », c’est un peu la mamma méditerranéenne que l’on a tous rêvé de connaître.\r\nD’origine libano-égyptienne, Soraya est aujourd’hui traiteur et régale l’Île de France de ses meilleures recettes méditerranéennes depuis plus de 10 ans.\r\nElle s’associe aujourd’hui à Olivier, son fils, et à Quentin et Tristan, les plus proches amis d’Olivier, pour monter un restaurant à son image : convivial et chaleureux.\r\n\r\nSoraya, known as “Sosso”, is a bit like the Mediterranean mamma that we all dreamed of knowing.\r\nOf Lebanese-Egyptian origin, Soraya is now a caterer and has been delighting the Île de France with her best Mediterranean recipes for more than 10 years.\r\nToday she is joining forces with Olivier, her son, and Quentin and Tristan, Olivier\\\'s closest friends, to set up a restaurant in her image: friendly and warm.\\\"', '36 Rue Ramey, 75018 Paris, France', '36 Rue Ramey,', '', 'Paris', 'Paris', 'FR', 0, 0, 0, '75018', '', '', '48.8895945', '2.3463027', 'N/A', 'N/A', 4.80, 'N/A', '20-30€', 0, 'N/A', 'Sosso_Restaurant', '2024-07-26 05:38:46.000000', '2024-07-26 05:38:46.000000', 1, 0, 0, 'resources/restaurant/1721972326_SOSSO-92.webp', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Sosso_Restaurant', 'N/A', 0, 'N/A', 1, 1, '2024-07-26 00:08:46', '2024-07-26 00:08:46'),
(93, 'Jinchan shokudo', 22, '1', 'Cuisines', 'budgetfriendly,authenticfood,veganoptions,japonesefood,instagramfamous,takeaway', ',102,103,104,105,106,107', 'Une mission simple : exporter la culture japonaise populaire dans le monde !\r\nC’est avec cette idée en tête que Miyo et Alban reviennent à Paris après 3 ans de vie commune au Japon.', '\\\"Une mission simple : exporter la culture japonaise populaire dans le monde !\r\nC’est avec cette idée en tête que Miyo et Alban reviennent à Paris après 3 ans de vie commune au Japon. Grands fans de cuisine japonaise et des ambiances conviviales des Izakaya, rien de plus logique que démarrer ce projet par la restauration.\r\n\r\nA simple mission: export popular Japanese culture to the world!\r\nIt is with this idea in mind that Miyo and Alban return to Paris after 3 years of living together in Japan. Big fans of Japanese cuisine and the friendly atmosphere of Izakaya, nothing is more logical than starting this project with catering.\\\"', '154 Rue du Faubourg Saint-Antoine, 75012 Paris, France', '154 Rue du Faubourg Saint-Antoine,', '', 'Paris', 'Paris', 'FR', 0, 0, 0, '75012', '', '', '48.8502634', '2.3804827', 'N/A', 'N/A', 4.70, 'N/A', '20-30€', 0, 'N/A', 'Jinchan_shokudo', '2024-07-26 05:44:01.000000', '2024-07-26 05:44:01.000000', 1, 0, 0, 'resources/restaurant/1721972641_mission1.webp', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Jinchan_shokudo', 'N/A', 0, 'N/A', 1, 1, '2024-07-26 00:14:01', '2024-07-26 00:14:01'),
(94, 'Auteuil Brasserie', 22, '1', 'Cuisines', 'rooftop,greatatmosphere,budgetfriendly,nicedecor,idealwithfriends,summervibe,kidsfriendly,cocktaillover,openlate', ',108,109,110,111,112,113,114,115,116', 'Installée Porte d’Auteuil, en plein cœur du 16ème arrondissement, Auteuil Brasserie est un lieu unique et branché. Son rooftop couvert et chauffé en hiver, propose un cadre chaleureux où banquettes et coussins donnent une allure unique à cette terrasse perchée.', '\\\"Installée Porte d’Auteuil, en plein cœur du 16ème arrondissement, Auteuil Brasserie est un lieu unique et branché. Son rooftop couvert et chauffé en hiver, propose un cadre chaleureux où banquettes et coussins donnent une allure unique à cette terrasse perchée.\r\nEntre collègues ou entre amis, Auteuil Brasserie est le lieu idéal pour siroter un cocktail en terrasse, partager une burrata, des pizzas, une planche ou pour découvrir en toute convivialité une cuisine à l’influence italienne. Les produits sont frais et de saison, et les plats variés et originaux.\r\n\r\nLocated at Porte d’Auteuil, in the heart of the 16th arrondissement, Auteuil Brasserie is a unique and trendy place. Its covered rooftop, heated in winter, offers a warm setting where benches and cushions give a unique look to this perched terrace.\r\nWith colleagues or friends, Auteuil Brasserie is the ideal place to sip a cocktail on the terrace, share a burrata, pizzas, a board or to discover, in a friendly atmosphere, cuisine with an Italian influence. The products are fresh and seasonal, and the dishes varied and original.\\\"', '78 Rue d\\\'Auteuil, 75016 Paris, France', '78 Rue d\\\'Auteuil,', '', 'Paris', 'Paris', 'FR', 0, 0, 0, '75016', '', '', '48.8483252', '2.2598454', 'https://www.facebook.com/auteuilbrasserie', 'https://www.instagram.com/auteuilbrasserie/', 4.00, 'N/A', '30-40€', 0, 'N/A', 'Auteuil_Brasserie', '2024-07-26 05:49:34.000000', '2024-07-26 05:49:34.000000', 1, 0, 0, 'resources/restaurant/1721972974_784e058e6acb943756703440b1eb2e9b.website.jpg', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Auteuil_Brasserie', 'N/A', 0, 'N/A', 1, 1, '2024-07-26 00:19:34', '2024-07-26 00:19:34'),
(95, 'Papi restaurant', 22, '1', 'Cuisines', 'authenticfood,freshpasta,nicedecor,vegan,localproducts', ',117,118,119,120,121', 'À la fois restaurant italien, adresse de quartier, plats de pasta et aussi végétariens, PAPI c’est tout cela à la fois.', '\\\"À la fois restaurant italien, adresse de quartier, plats de pasta et aussi végétariens, PAPI c’est tout cela à la fois.\r\n\r\nPart Italian restaurant, part neighborhood address, pasta and also vegetarian dishes, PAPI is all of that at the same time.\r\n\\\"', '46 Rue Richer, 75009 Paris, France', '46 Rue Richer,', '', 'Paris', 'Paris', 'FR', 0, 0, 0, '75009', '', '', '48.8742009', '2.3437086', 'N/A', 'N/A', 4.50, 'N/A', '40-50€', 0, 'N/A', 'Papi_restaurant', '2024-07-26 05:54:44.000000', '2024-07-26 05:54:44.000000', 1, 0, 0, 'resources/restaurant/1721973284_papi-3-520x780-1 (1).webp', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Papi_restaurant', 'N/A', 0, 'N/A', 1, 1, '2024-07-26 00:24:44', '2024-07-26 00:24:44'),
(96, 'Frenchie bar à vin', 22, '1', 'Cuisines', 'authenticfood,winebar,greatatmosphe,goodwine,intimate,perfectforadate,naturalwine,music,localproducts', ',122,123,124,125,126,127,128,129,130', 'Il vous est proposé des petites portions, plats à partager, légumes, viandes, poissons, fromages et desserts.', '\\\"Il vous est proposé des petites portions, plats à partager, légumes, viandes, poissons, fromages et desserts. A apprécier avec des vins blancs, rouges, jaunes, rosés, sakés, digestifs, Français, d’Europe ou d’Amérique.\r\n\r\nYou are offered small portions, dishes to share, vegetables, meats, fish, cheeses and desserts. To be enjoyed with white, red, yellow, rosé, sake, digestive, French, European or American wines.\\\"', '6 Rue du Nil, 75002 Paris, France', '6 Rue du Nil,', '', 'Paris', 'Paris', 'FR', 0, 0, 0, '75002', '', '', '48.8678359', '2.3479034', 'N/A', 'N/A', 4.60, 'N/A', '30-40€', 0, 'N/A', 'Frenchie_bar_à_vin', '2024-07-26 06:04:30.000000', '2024-07-26 06:04:30.000000', 1, 0, 0, 'resources/restaurant/1721973870_1.png', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Frenchie_bar_à_vin', 'N/A', 0, 'N/A', 1, 1, '2024-07-26 00:34:30', '2024-07-26 00:34:30'),
(97, 'Canopy Paris - Mont Trocadéro', 22, '1', 'Cuisines', 'cocktaillover,rooftop,openlate,barwithaview,summervibe', ',131,132,133,134,135', '\\\"Savourez des sandwichs, des cafés et des collations légères dans notre bar-salon et admirez la vue sur la tour Eiffel avec des cocktails, des bières artisanales et des vins dans notre bar sur le toit.\r\n\r\nEnjoy sandwiches, coffees and light bites in our Bar Lounge and take in views of the Eiffel Tower with cocktails, craft beers, and wines in our Rooftop bar.\\\"', '\\\"\\\"Savourez des sandwichs, des cafés et des collations légères dans notre bar-salon et admirez la vue sur la tour Eiffel avec des cocktails, des bières artisanales et des vins dans notre bar sur le toit.\r\n\r\nEnjoy sandwiches, coffees and light bites in our Bar Lounge and take in views of the Eiffel Tower with cocktails, craft beers, and wines in our Rooftop bar.\\\"\r\n\r\n\r\nEnjoy sandwiches, coffees and light bites in our Bar Lounge and take in views of the Eiffel Tower with cocktails, craft beers, and wines in our Rooftop bar.\\\"', '16 Av. d\\\'Eylau, 75116 Paris, France', '16 Av. d\\\'Eylau,', '', 'Paris', 'Paris', 'FR', 0, 0, 0, '75116', '', '', '48.86443819999999', '2.2850646', 'N/A', 'N/A', 4.40, 'N/A', '30-40€', 0, 'N/A', 'Canopy_Paris_-_Mont_Trocadéro', '2024-07-26 06:08:24.000000', '2024-07-26 06:08:24.000000', 1, 0, 0, 'resources/restaurant/1721974104_704-terrasse-2-.avif', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Canopy_Paris_-_Mont_Trocadéro', 'N/A', 0, 'N/A', 1, 1, '2024-07-26 00:38:24', '2024-07-26 00:38:24'),
(98, 'Hotel Henriette', 22, '1', 'Cuisines', 'intimate,breakfast,summervibe,patio', ',136,137,138,139', 'Le petit-déjeuner buffet est servi de 7h à 10h30 du matin et jusqu\\\'à 11h00 le week-end.', '\\\"Le petit-déjeuner buffet est servi de 7h à 10h30 du matin et jusqu\\\'à 11h00 le week-end.\r\nLe petit-déjeuner se déroule dans la salle à manger, avec vue sur le joli patio cosy vintage d\\\'Henriette. Vous pouvez également profiter du petit-déjeuner dans le patio les jours de beau temps.\r\n\r\nBuffet breakfast is served from 7:00 a.m. to 10:30 a.m. and until 11:00 a.m. on weekends.\r\nBreakfast takes place in the dining room, with a view of Henriette\\\'s pretty cozy vintage patio. You can also enjoy breakfast on the patio on nice weather days.\\\"', '9 Rue des Gobelins, 75013 Paris, France', '9 Rue des Gobelins,', '', 'Paris', 'Paris', 'FR', 0, 0, 0, '75013', '', '', '48.8357605', '2.3513634', 'N/A', 'N/A', 4.80, 'N/A', '17 €', 0, 'N/A', 'Hotel_Henriette', '2024-07-26 06:11:50.000000', '2024-07-26 06:11:50.000000', 1, 0, 0, 'resources/restaurant/1721974310_4192206-1318326_0_222_850_700_525_432.jpg', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Hotel_Henriette', 'N/A', 0, 'N/A', 1, 1, '2024-07-26 00:41:50', '2024-07-26 00:41:50'),
(99, 'Augustin Marchand d\\\'Vins', 22, '1', 'Cuisines', 'authenticfood,winebar,greatatmosphe,goodwine,intimate,perfectforadate,naturalwine,music,localproducts', ',140,141,142,143,144,145,146,147,148', 'Augustin Marchand d’Vins, ce n’est pas que du vin, c’est aussi à manger… ou plutôt à déguster ! Produits d’exception, truffe, légumes de maraîchers en agriculture biologique, assaisonnements détonnants :\r\nça cuisine chez Augustin.26 Rue des Grands Augustins, 75006 Paris', '\\\"Augustin Marchand d’Vins, ce n’est pas que du vin, c’est aussi à manger… ou plutôt à déguster ! Produits d’exception, truffe, légumes de maraîchers en agriculture biologique, assaisonnements détonnants :\r\nça cuisine chez Augustin.\r\n\r\nAugustin Marchand d’Vins is not just about wine, it’s also about eating… or rather tasting! Exceptional products, truffles, organic market garden vegetables, explosive seasonings:\r\nit\\\'s cooking at Augustin\\\'s.\\\"', '26 Rue des Grands Augustins, 75006 Paris, France', '26 Rue des Grands Augustins,', '', 'Paris', 'Paris', 'FR', 0, 0, 0, '75006', '', '', '48.85365969999999', '2.3401642', 'N/A', 'N/A', 4.80, 'N/A', '50-60€', 0, 'N/A', 'Augustin_Marchand_d\\\'Vins', '2024-07-26 06:18:24.000000', '2024-07-26 06:18:24.000000', 1, 0, 0, 'resources/restaurant/1721974704_exterieur.jpeg', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Augustin_Marchand_d\\\'Vins', 'N/A', 0, 'N/A', 1, 1, '2024-07-26 00:48:24', '2024-07-26 00:48:24');
INSERT INTO `restaurants` (`id`, `name`, `added_by`, `categoryid`, `categoryname`, `tags`, `tagsid`, `shortdescription`, `description`, `location`, `address_1`, `address_2`, `city`, `state`, `docuntry`, `totfav`, `totbeen`, `tottry`, `pincode`, `phone`, `alternate_phone`, `lat`, `lng`, `fblink`, `instalink`, `rating`, `rating_link`, `price`, `totreviews`, `barcode`, `slug`, `createdon`, `updatedon`, `isactive`, `isexclusive`, `isperks`, `mainimg`, `subregion`, `use_third_party_check`, `use_third_party_book_url`, `booking_url`, `updated_ip`, `updated_by`, `updated_by_name`, `added_by_super`, `deleted`, `created_at`, `updated_at`) VALUES
(100, 'The Hoxton Paris', 22, '1', 'Cuisines', 'budgetfriendly,authenticfood,greatatmosphe,goodwine,naturalwine,music,cocktaillover,winebar,nicebar,nicedecor,idealwithfriends,kidsfriendly,solodinner,perfectforadate', ',149,150,151,152,153,154,155,156,157,158,159,160,161,162', 'Rivié est une brasserie ouverte toute la journée au rez-de-chaussée de The Hoxton, Paris, qui propose une cuisine française moderne et créative.', '\\\"Rivié est une brasserie ouverte toute la journée au rez-de-chaussée de The Hoxton, Paris, qui propose une cuisine française moderne et créative.\r\n\r\nUn bar à cocktails intime à Paris auquel on accède par un escalier en colimaçon original du 18e siècle, à The Hoxton, Paris. Sans aucun doute l\\\'un des meilleurs bars à cocktails de Paris, une visite ici sera inoubliable.\r\n\r\nBar à vin décontracté situé dans une cour intérieure qui sert exclusivement des vins biodynamiques et biologiques. À déguster entre amis et à partager autour de charcuteries, fromages et de petites assiettes.\r\n\r\nRivié is all-day brasserie on the ground floor of The Hoxton, Paris, offering creative modern French dishes.\r\n\r\nAn intimate cocktail bar in Paris accessed via an original 18th century spiral staircase in The Hoxton, Paris. Undoubtably one of the best cocktail bars in Paris, a visit here will be one you will never forget.\r\n\r\nCasual courtyard wine bar that serves exclusively biodynamic and organic wines, to be enjoyed with friends and shared over charcuteries, cheeses and small plates.\\\"', '30-32 Rue du Sentier, 75002 Paris, France', '30-32 Rue du Sentier,', '', 'Paris', 'Paris', 'FR', 0, 0, 0, '75002', '', '', '48.87016980000001', '2.3466201', 'N/A', 'N/A', 4.40, 'N/A', '30-50€', 0, 'N/A', 'The_Hoxton_Paris', '2024-07-26 06:23:51.000000', '2024-07-26 06:23:51.000000', 1, 0, 0, 'resources/restaurant/1721975031_Paris-1.webp', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/The_Hoxton_Paris', 'N/A', 0, 'N/A', 1, 1, '2024-07-26 00:53:51', '2024-07-26 00:53:51'),
(101, 'Kodawari Ramen (Tsukiji)', 22, '1', 'Cuisines', 'budgetfriendly,authenticfood,veganoptions,japonesefood,instagramfamous,ramen,uniqueexperience,openlate', ',163,164,165,166,167,168,169,170', 'Tsukiji • marché aux poissons historique de la métropole de Tokyo, créé en 1935 et fermé en 2018.', '\\\"Tsukiji • marché aux poissons historique de la métropole de Tokyo, créé en 1935 et fermé en 2018. Plus grand marché de gros du monde pour les poissons et les fruits de mer.\r\n\r\nTsukiji • historic fish market in metropolitan Tokyo, established in 1935 and closed in 2018. The world\\\'s largest wholesale market for fish and seafood.\\\"', '12 Rue de Richelieu, 75001 Paris, France', '12 Rue de Richelieu,', '', 'Paris', 'Paris', 'FR', 0, 1, 1, '75001', '', '', '48.8643706', '2.336255200000001', 'N/A', 'N/A', 4.40, 'N/A', '20-40€', 0, 'N/A', 'Kodawari_Ramen_(Tsukiji)', '2024-07-26 06:27:08.000000', '2024-07-26 06:27:08.000000', 1, 0, 0, 'resources/restaurant/1721975228_kodawari-yokocho-homepage.jpg', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Kodawari_Ramen_(Tsukiji)', 'N/A', 0, 'N/A', 1, 1, '2024-07-26 00:57:08', '2024-07-26 00:57:08'),
(102, 'Kodawari Ramen (Yokochō)', 22, '1', 'Cuisines', 'budgetfriendly,authenticfood,veganoptions,japonesefood,instagramfamous,ramen,uniqueexperience,openlate', ',171,172,173,174,175,176,177,178', 'Yokocho • signifie « allée » en japonais. Par extension, ruelle étroite abritant des izakaya, des bars et des petits restaurants japonais.', '\\\"Yokocho • signifie « allée » en japonais. Par extension, ruelle étroite abritant des izakaya, des bars et des petits restaurants japonais.\r\n\r\nYokocho • means “alley” in Japanese. By extension, narrow alley housing izakaya, bars and small Japanese restaurants.\\\"', '29 Rue Mazarine, 75006 Paris, France', '29 Rue Mazarine,', '', 'Paris', 'Paris', 'FR', 0, 0, 0, '75006', '', '', '48.8546564', '2.3381418', 'N/A', 'N/A', 4.50, 'N/A', '20-40€', 0, 'N/A', 'Kodawari_Ramen_(Yokochō)', '2024-07-26 06:31:39.000000', '2024-07-26 06:31:39.000000', 1, 0, 0, 'resources/restaurant/1721975499_kodawari-yokocho-homepage.jpg', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Kodawari_Ramen_(Yokochō)', 'N/A', 0, 'N/A', 1, 1, '2024-07-26 01:01:39', '2024-07-26 01:01:39'),
(103, 'Brach Paris - Evok Collection', 22, '1', 'Cuisines', 'authenticfood,greatatmosphe,goodwine,music,cocktaillover,winebar,nicebar,nicedecor,idealwithfriends,kidsfriendly,solodinner,perfectforadate,rooftop,summervibe,finedining', ',179,180,181,182,183,184,185,186,187,188,189,190,191,192,193', 'Les tables du Brach Paris sont des tables de partage colorées et vivantes qui vibrent au rythme de la ville du matin jusqu’au soir et invitent à un voyage immobile.', '\\\"Les tables du Brach Paris sont des tables de partage colorées et vivantes qui vibrent au rythme de la ville du matin jusqu’au soir et invitent à un voyage immobile. Brach Restaurant est une immersion dans les cuisines généreuses de la Méditerranée, la Terrasse du 1er propose un autre voyage aux saveurs ibériques. Aux beaux jours, c’est une envolée plein ciel qu’offre le potager sur le rooftop. Les cartes portent la signature chaleureuse et généreuse d’Adam Bentalha.\r\n\r\nBrach Paris’ tables are shared, colorful, lively tables that resonate both day and night to the rhythm  of the city. A journey in of itself. Brach restaurant is an immersion in the generous cuisines of the Mediterranean, The Terrasse of the second floor offers a separate journey with Iberian flavors, while on sunny days, the kitchen garden on the rooftop offers a soaring sky. All those spaces are signed by Chef Adam Bentalha to reflect his warm and generous touch.\\\"', '1-7 Rue Jean Richepin, 75116 Paris, France', '1-7 Rue Jean Richepin,', '', 'Paris', 'Paris', 'FR', 1, 0, 0, '75116', '', '', '48.8613299', '2.2747033', 'N/A', 'N/A', 4.30, 'N/A', '50-60€', 0, 'N/A', 'Brach_Paris_-_Evok_Collection', '2024-07-26 06:36:27.000000', '2024-07-26 06:36:27.000000', 1, 0, 0, 'resources/restaurant/1721975787_04_Brach_Restaurant_31_GuillaumedeLaubier_hotel_paris_luxe-1500x1001.jpg.webp', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Brach_Paris_-_Evok_Collection', 'N/A', 0, 'N/A', 1, 1, '2024-07-26 01:06:27', '2024-07-26 01:06:27'),
(104, 'ANDIA - La Gare', 22, '1', 'Cuisines', 'greatatmosphe,goodwine,music,cocktaillover,nicedecor,idealwithfriends,perfectforadate,instagramfamous,finedining', ',194,195,196,197,198,199,200,201,202', 'Andia surgit au cœur du 16ème arr. comme une promesse de fraîcheur, d’exotisme et d’horizons lointains.', '\\\"Andia surgit au cœur du 16ème arr. comme une promesse de fraîcheur, d’exotisme et d’horizons lointains.\r\nL’adresse, dans le décor comme en cuisine, invite au voyage sur une carte latine allant des sommets andins, de la jungle amazonienne à la côte Caraïbe du Mexique.\r\nViandes grillées, Andia rolls, crudo y marinado, arroz misti comme à Lima : on fond pour la carte qui fait honneur aux mets Nikkei et Andins.\r\n\r\nAndia emerges in the heart of the 16th district as a promise of freshness, exoticism and distant horizons. \r\nThe address, in the decoration as in the kitchen, invites us to travel on a Latin map going from the Andean summits, from the Amazonian jungle to the Caribbean coast of Mexico.\r\nGrilled meats, Andia rolls, crudo y marinado, arroz misti as in Lima: we melt for the menu that honors Nikkei and Andean dishes.\\\"', '19 Chau. de la Muette, 75016 Paris, France', '19 Chau. de la Muette,', '', 'Paris', 'Paris', 'FR', 0, 0, 0, '75016', '', '', '48.8581198', '2.2722829', 'https://www.facebook.com/andia.lagare', 'https://www.instagram.com/andia_paris/', 4.10, 'N/A', '60-70€', 0, 'N/A', 'ANDIA_-_La_Gare', '2024-07-26 06:41:13.000000', '2024-07-26 06:41:13.000000', 1, 0, 0, 'resources/restaurant/1721976073_andia-logos.webp', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/ANDIA_-_La_Gare', 'N/A', 0, 'N/A', 1, 1, '2024-07-26 01:11:13', '2024-07-26 01:11:13'),
(105, 'Café 52', 22, '1', 'Cuisines', 'healthyfood,veganoptions,localproducts,nicedecor,cosy,greatatmosphere,cocktaillover,perfectforadate,openlate,brunch,breakfast', ',203,204,205,206,207,208,209,210,211,212,213', 'L’équipe du Café 52 Paris 8 s’engage pour une cuisine qui prône le bien-être, autant que le respect de l’environnement.', '\\\"L’équipe du Café 52 Paris 8 s’engage pour une cuisine qui prône le bien-être, autant que le respect de l’environnement.\r\nTous acteurs de cette volonté, nos partenaires travaillent les produits en circuits courts, à travers des élevages et labels certifiés, ou des pêches responsables et mesurées.\r\nAu rythme des saisons, nous sublimons ces produits d’exception pour satisfaire tous les appétits, en proposant des options végétariennes, sans gluten ou sans lactose, dans des recettes healthy mais jamais sans plaisir. \r\n\r\nThe Café 52 Paris 8 team is committed to a cuisine that promotes well-being as well as respect for the environment.\r\nAll actors of this will, our partners work in short circuits, and our products come from certified farms and labels, our fish are from measured fishing. \r\nAccording to the seasons, we sublimate these exceptional products to satisfy all appetites, offering vegetarian options, gluten-free or lactose-free, in healthy recipes but never without pleasure.\\\"', '52 Rue François 1er, 75008 Paris, France', '52 Rue François 1er,', '', 'Paris', 'Paris', 'FR', 0, 0, 0, '75008', '', '', '48.8692228', '2.3031298', 'N/A', 'N/A', 4.30, 'N/A', '40-50€', 0, 'N/A', 'Café_52', '2024-07-26 06:47:57.000000', '2024-07-26 06:47:57.000000', 1, 0, 0, 'resources/restaurant/1721976477_virtuoso-.jpeg.webp', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Café_52', 'N/A', 0, 'N/A', 1, 1, '2024-07-26 01:17:57', '2024-07-26 01:17:57'),
(106, 'Café 52', 22, '1', 'Cuisines', 'healthyfood,veganoptions,localproducts,nicedecor,cosy,greatatmosphere,cocktaillover,idealwithfriends,brunch,breakfast', ',214,215,216,217,218,219,220,221,222,223', 'Nouvelle adresse healthy du quartier, le Café 52 Paris 1er propose des suggestions équilibrées et de saison ainsi que quelques incontournables parfaitement orchestrés par le chef Maxime Raab, qui s’est précédemment illustré au Fouquet’s.', '\\\"Nouvelle adresse healthy du quartier, le Café 52 Paris 1er propose des suggestions équilibrées et de saison ainsi que quelques incontournables parfaitement orchestrés par le chef Maxime Raab, qui s’est précédemment illustré au Fouquet’s. Sa cuisine est guidée par l’amour du produit et de la juste saveur.\r\nTout près, le bar, écrin intimiste aux tonalités chaudes et fleuries invite ses hôtes et les parisiens à découvrir cocktails et finger food, à la signature audacieuse.\r\n\r\nA new healthy address in the neighborhood, Café 52 Paris 1er offers balanced and seasonal suggestions as well as a few must-try dishes perfectly orchestrated by the chef Maxime Raab, who previously distinguished himself at Fouquet\\\'s. His cuisine is guided by a love of the product and the right flavor.\r\nNearby, the bar, an intimate setting with warm, flowery tones, invites guests and Parisians to discover cocktails and finger food with a bold signature.\\\"', '4 Rue de Valois, 75001 Paris, France', '4 Rue de Valois,', '', 'Paris', 'Paris', 'FR', 0, 0, 0, '75001', '', '', '48.8631637', '2.3378569', 'N/A', 'N/A', 4.40, 'N/A', '40-50€', 0, 'N/A', 'Cafés_52', '2024-07-26 06:52:57.000000', '2024-07-26 06:52:57.000000', 1, 0, 0, 'resources/restaurant/1721976777_virtuoso-.jpeg.webp', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Cafés_52', 'N/A', 0, 'N/A', 1, 1, '2024-07-26 01:22:57', '2024-07-26 01:22:57'),
(107, 'Test Restro', 41, '1', 'Cuisines', 'veganoptions,localproducts,cosy', '218,216,215', 'Testing only', 'Testing purposes', 'Kilómetros de Pizza, Av. de Brasil, 6, Tetuán, 28020 Madrid, Spain', 'Kilómetros de Pizza, Av. de Brasil, 6, Tetuán, 28020 Madrid, Spain', '', 'Madrid', 'Madrid', 'SP', 0, 0, 0, '28020', '', '', '40.45410749999999', '-3.6932136', 'N/A', 'N/A', 4.30, 'N/A', '100€+', 0, 'N/A', 'Test_Restro', '2024-07-26 07:15:33.000000', '2024-07-26 07:15:33.000000', 1, 0, 0, 'resources/restaurant/1721978133_2024-06-02.jpg', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Test_Restro', 'N/A', 0, 'N/A', 1, 1, '2024-07-26 01:45:33', '2024-07-26 01:45:33'),
(108, 'La Maison Plisson', 22, '1', 'Cuisines', 'brunch', '231', 'Venez vous attabler et déguster une cuisine de bistrot, française et généreuse en service continu 7 jours sur 7.', 'Venez vous attabler et déguster une cuisine de bistrot, française et généreuse en service continu 7 jours sur 7.\r\nTous les jours, une cuisine saine met à l’honneur des recettes maison et les produits du marché frais. Petit-déjeuner, déjeuner, goûter et apéritif, toutes les occasions sont bonnes pour nous rendre une visite. En terrasse ou en salle.\r\n\r\nCome sit down and enjoy generous French bistro cuisine, available 7 days a week.\r\nEvery day, healthy cuisine highlights homemade recipes and fresh market products. Breakfast, lunch, snack and aperitif, any opportunity is good to visit us. On the terrace or insde.', '93 Bd Beaumarchais, 75003 Paris, France', '93 Bd Beaumarchais,', '', 'Paris', 'Paris', 'FR', 1, 0, 0, '75003', '', '', '48.8595501', '2.3673095', 'N/A', 'N/A', 4.10, 'N/A', '30-40€', 0, 'N/A', 'La_Maison_Plisson', '2024-08-10 06:49:02.000000', '2024-08-10 06:49:02.000000', 1, 0, 0, 'resources/restaurant/1721986330_27560c2b4a1caf0f23ba16e4-eec6b22cc488e76f66d4f511.jpeg', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/La_Maison_Plisson', '49.47.132.194', 24, 'Super Admin', 1, 1, '2024-07-26 04:02:10', '2024-08-10 01:19:02'),
(110, 'Mine_Rest1', 22, '7,4,3', 'Vibes,Top,Desi Vibes', 'healthyfood,cosy,brunch', '231,207,203', 'Mine Restaurant First choosen', 'Mine Restaurant First choosen', 'Eure, France', 'Eure addres metros', '', 'Eure', 'Eure', 'FR', 0, 0, 0, '27110', '', '', '49.11817629999999', '0.9582113999999999', 'N/A', 'N/A', 0.00, 'N/A', '0', 0, 'N/A', 'Mine_Rest1', '2024-08-08 13:27:51.000000', '2024-08-08 13:27:51.000000', 1, 0, 0, 'resources/restaurant/1723122618_4___.jpg', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Mine_Rest1', '49.47.132.194', 24, 'Super Admin', 1, 1, '2024-08-08 07:40:18', '2024-08-08 07:57:51'),
(114, 'Jha ji Dhaba', 42, '4', 'Top', 'Méditerranéen,rooftop,vegan,greatatmosphe,breakfast,healthyfood,rooftops', '203,137,124,120,108,35,235', 'Average Cost\r\n₹200 for two people (approx.)\r\nExclusive of applicable taxes and charges, if any', 'Jha Ji Restaurant in Agra. Restaurants with Address, Contact Number, Photos, Maps. View Jha Ji Restaurant.\r\nRestaurants in Agra provide various cuisines with an aesthetic seating arrangement and the best services. Restaurants act as great places for many situations. From team meetings to family dinners, it can help serve a wide range of audiences. Many restaurants are aware of their customer preferences, hence, you can find a wide variety of vegetarian, non-vegetarian, vegan and gluten free options.', 'Om Sai Enclave Chipiyana, Chipiyana Buzurg, Ghaziabad, Uttar Pradesh, India', 'H.No.-2, Serial No.-18, Gali No.-7, Om Sai Enclave', '', 'Noida', 'Uttar Pradesh', 'IN', 0, 0, 0, '201009', '9953509796', '', '28.6208417', '77.4484719', 'N/A', 'N/A', 4.30, 'https://www.google.com/search?q=jha+je+dhaba&oq=jha+je+dhaba&gs_lcrp=EgZjaHJvbWUyBggAEEUYOTIPCAEQLhgNGK8BGMcBGIAEMgYIAhBFGEAyDQgDEAAYhgMYgAQYigUyDQgEEAAYhgMYgAQYigUyCggFEAAYgAQYogQyCggGEAAYgAQYogQyCggHEAAYgAQYogTSAQgyNjAwajBqN6gCCLACAQ&sourceid=chrome&ie=UTF-8#', '0', 0, 'N/A', 'Jha_ji_Dhaba', '2024-08-12 08:43:13.000000', '2024-08-12 08:43:13.000000', 1, 0, 1, 'resources/restaurant/1723185987_0c7baca104-vegan-restaurants-2-fkaii.jpg', 'Uttar Pradesh', 0, NULL, 'https://fudd.galileosoft.com/reservations/Jha_ji_Dhaba', '49.47.132.194', 24, 'Super Admin', 1, 1, '2024-08-09 01:16:27', '2024-08-12 03:13:13'),
(123, 'Radisun Blue', 6, '4', 'Top', 'brunch', '231', 'Amarré juste en face de la tour Eiffet.', 'Amarré juste en face de la tour Eiffet.', '47 Quai Charles Pasqua, 92300 Levallois-Perret', '47 Quai Charles Pasqua, 92300 Levallois-Perret', '', 'Paris', 'Paris', 'FR', 0, 0, 0, '876123', '98765600532', 'N/A', '48.9004423', '2.28132', 'www.facebook.conm', 'www.instagram.conm', 0.00, 'N/A', 'N/A', 0, 'N/A', 'Radisun_Blue', '2024-08-13 12:39:33.000000', '2024-08-13 12:39:33.000000', 1, 0, 1, 'resources/restaurant/1723552773_radisun.jpg', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Radisun_Blue', '49.47.132.70', 24, 'Super Admin', 1, 1, '2024-08-12 23:34:06', '2024-08-13 07:09:33'),
(153, 'Yaai Thaï Daguerre', 22, '1', 'Cuisines', 'brunch,thaifood', '238,231', 'Yaai Thaï vous ouvre les portes de la cuisine traditionnelle et authentique Thaïlandaise', 'Yaai Thaï vous ouvre les portes de la cuisine traditionnelle et authentique Thaïlandaise.. Entre décor authentique, qui rappelle les ruelles animées de Bangkok, échoppes colorées, enseignes animées, odeurs parfumées, carte aux milles saveurs, cuisine ouverte, le dépaysement est total et l’immersion assurée.\r\nAu menu, tous les codes de la cuisine thaïlandaise, cuisinés aux woks sous vos yeux à la minute : brochettes de poulet mariné, salade de papaye, Pad Thaï, currys, soupes parfumées, sautés, riz gluant à la mangue.\r\n\r\nYaai Thaï opens the doors to traditional and authentic Thai cuisine. Between authentic decor, reminiscent of the lively streets of Bangkok, colorful stalls, lively signs, fragrant smells, menu with a thousand flavors, open kitchen, the change of scenery is total and the immersion guaranteed.\r\nOn the menu, all the codes of Thai cuisine, cooked in woks before your eyes at the minute: marinated chicken skewers, papaya salad, Pad Thai, curries, flavored soups, stir-fries, sticky rice with mango.', '22 Rue Daguerre, 75014 Paris', '14èmeMétro Mouton-Duvernet', '', 'Paris', 'Paris', 'FR', 0, 0, 0, '75014', '', 'N/A', '48.8341253', '2.3294306', 'N/A', 'N/A', 4.40, 'N/A', '20-30€', 0, 'N/A', 'Yaai_Thaï_Daguerre', '2024-09-03 09:34:34.000000', '2024-09-03 09:34:34.000000', 1, 0, 1, 'resources/restaurant/1725356046_33.jpg', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Yaai_Thaï_Daguerre', '49.47.132.135', 24, 'Super Admin', 1, 1, '2024-09-03 04:01:33', '2024-09-03 04:04:34'),
(154, 'Carboni\\\'s', 22, '1', 'Cuisines', 'brunch,thaifood', '238,231', 'CARBONI\\\'S, une ode à l’Italie. Des classiques italiens réconfortants et magnifiquement exécutés, et parfois notre version de ces classiques ! Prenez un verre au BAR SOTTO et écoutez les vinyles de notre jukebox. Ouvert jusqu\\\'à 2h du matin.', 'CARBONI\\\'S, une ode à l’Italie. Des classiques italiens réconfortants et magnifiquement exécutés, et parfois notre version de ces classiques ! Prenez un verre au BAR SOTTO et écoutez les vinyles de notre jukebox. Ouvert jusqu\\\'à 2h du matin.\r\n\r\nCARBONI’S: An ode to all things Italian. Comforting, beautifully executed Italian classics our way.  Have a drink at our downstairs BAR SOTTO & enjoy tunes from our vinyl jukebox. Open until 2am.', '45 Rue de Poitou, 75003 Paris', '3ème Métro Sebastien-Froissard', '', 'Paris', 'Paris', 'FR', 0, 0, 0, '75003', '', 'N/A', '48.8616839', '2.3613358', 'N/A', 'N/A', 4.00, 'N/A', '40-60€', 0, 'N/A', 'Carboni\\\'s', '2024-09-03 09:38:41.000000', '2024-09-03 09:38:41.000000', 1, 0, 1, 'resources/restaurant/1725356321_34.png', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Carboni\\\'s', '49.47.132.135', 24, 'Super Admin', 1, 1, '2024-09-03 04:01:33', '2024-09-03 04:08:41'),
(155, 'Ama Siam', 22, '1', 'Cuisines', 'brunch,thaifood', '238,231', 'Un espace pour co-worker seul, à deux, entre amis, entre collègues…. Voire plus si affinités. coworking\r\nUne table d’hôtes, à l’abri des regards, pour se réunir, travailler ou festoyer en privé, déjeuner, goûter, dîner… table d’hôtes', 'En ouvrant les portes de chez Ama Siam, nous voulons perpétuer le savoir-faire familial, mettre à l’honneur les recettes de notre maman en vous proposant les plats que l’on mange à la maison depuis notre enfance. Chaque assiette raconte nos origines laotienne, vietnamienne et chinoise.\r\n\r\nBy opening the doors of Ama Siam, we want to perpetuate family know-how, honor our mother\\\'s recipes by offering you the dishes that we have been eating at home since our childhood. Each plate tells of our Laotian, Vietnamese and Chinese origins.', '49 Rue de Belleville, 75019 Paris, France', '19ème Métro Belleville', '', 'Paris', 'Paris', 'FR', 1, 0, 0, '75019', '', 'N/A', '48.8733916', '2.3807839', 'N/A', 'N/A', 4.50, 'N/A', '30-40€', 0, 'N/A', 'Ama_Siam', '2024-09-03 09:44:51.000000', '2024-09-03 09:44:51.000000', 1, 0, 1, 'resources/restaurant/1725356691_35_1.png', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Ama_Siam', '49.47.132.135', 24, 'Super Admin', 1, 1, '2024-09-03 04:01:33', '2024-09-03 04:14:51'),
(156, 'Café élémentaire', 22, '1', 'Cuisines', 'brunch,thaifood', '238,231', 'Un QG de quartier pour tous les gourmands et les gourmets.\r\nUn espace pour co-worker seul, à deux, entre amis, entre collègues…. Voire plus si affinités. coworking\r\nUne table d’hôtes, à l’abri des', 'By opening the doors of Ama Siam, we want to perpetuate family know-how, honor our mother\\\'s recipes by offering you the dishes that we have been eating at home since our childhood. Each plate tells of our Laotian, Vietnamese and Chinese origins.', '38 Rue Léopold Bellan, 75002 Paris, France', '2ème Métro Sentier', '', 'Paris', 'Paris', 'FR', 0, 0, 0, '75002', '', 'N/A', '48.8667881', '2.3446098', 'N/A', 'N/A', 4.20, 'N/A', '30-40€', 0, 'N/A', 'Café_élémentaire', '2024-09-03 09:47:59.000000', '2024-09-03 09:47:59.000000', 1, 0, 1, 'resources/restaurant/1725356879_36_1.jpg', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Café_élémentaire', '49.47.132.135', 24, 'Super Admin', 1, 1, '2024-09-03 04:01:33', '2024-09-03 04:17:59'),
(157, 'Liza', 22, '1', 'Cuisines', 'brunch,thaifood', '238,231', 'Un dîner avec des amis ou un brunch en famille, notre la cuisine est servie dans une atmosphère joyeuse et festive. Des mezzés twistés à partager, le gras en moins, des recettes ancestrales réinventées, le tout préparé avec beaucoup d’amour, de temps et de très bons produits frais.', 'Un dîner avec des amis ou un brunch en famille, notre la cuisine est servie dans une atmosphère joyeuse et festive. Des mezzés twistés à partager, le gras en moins, des recettes ancestrales réinventées, le tout préparé avec beaucoup d’amour, de temps et de très bons produits frais.\r\n\r\nA dinner with friends or a brunch with family, our cuisine is served in a joyful and festive atmosphere. Twisted mezzés to share, less fat, reinvented ancestral recipes, all prepared with a lot of love, time and very good fresh products.', '14 Rue de la Banque, 75002 Paris', '2ème Métro Bourse', '', 'Paris', 'Paris', 'FR', 0, 0, 0, '75002', '', 'N/A', '48.8675818', '2.3410265', 'N/A', 'N/A', 4.20, 'N/A', '40-50€', 0, 'N/A', 'Liza', '2024-09-03 09:49:55.000000', '2024-09-03 09:49:55.000000', 1, 0, 1, 'resources/restaurant/1725356995_37.jpg', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Liza', '49.47.132.135', 24, 'Super Admin', 1, 1, '2024-09-03 04:01:33', '2024-09-03 04:19:55'),
(158, 'Café Paulette', 22, '1', 'Cuisines', 'brunch,thaifood', '238,231', 'BRUNCHER, DÉJEUNER, DINER & BOIRE DES COUPS !\r\nDécouvrez la cuisine du marché, faite maison avec amour, et la sélection de bières artisanales & vins naturels.', 'BRUNCHER, DÉJEUNER, DINER & BOIRE DES COUPS !\r\nDécouvrez la cuisine du marché, faite maison avec amour, et la sélection de bières artisanales & vins naturels.\r\n\r\nBRUNCH, LUNCH, DINNER & DRINKS!\r\nDiscover market cuisine, homemade with love, and the selection of craft beers & natural wines.', '48 Bd Arago, 75013 Paris', '13ème Métro Glacière', '', 'Paris', 'Paris', 'FR', 1, 1, 0, '75013', '', 'N/A', '48.8354495', '2.345476', 'N/A', 'N/A', 4.40, 'N/A', '20-30€', 0, 'N/A', 'Café_Paulette', '2024-09-03 09:51:59.000000', '2024-09-03 09:51:59.000000', 1, 0, 1, 'resources/restaurant/1725357119_38.png', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Café_Paulette', '49.47.132.135', 24, 'Super Admin', 1, 1, '2024-09-03 04:01:33', '2024-09-03 04:21:59'),
(159, 'Chez Janou', 22, '1', 'Cuisines', 'brunch,thaifood', '238,231', 'Un coin de garrigue au cœur de Paris... Dans la salle à manger aux accents du sud ou en terrasse à l\\\'ombre des oliviers, vous pourrez y découvrir les saveurs d\\\'une cuisine provençale ensoleillée et vous étourdir à la vue de notre carte des pastis.', 'Un coin de garrigue au cœur de Paris... Dans la salle à manger aux accents du sud ou en terrasse à l\\\'ombre des oliviers, vous pourrez y découvrir les saveurs d\\\'une cuisine provençale ensoleillée et vous étourdir à la vue de notre carte des pastis.\r\n\r\nA corner of the garrigue in the heart of Paris... In the dining room with south of France accents or on the terrace in the shade of the olive trees, you can discover the flavors of sunny Provençal cuisine and be stunned by the sight of our pastis menu.', '2 Rue Roger Verlomme, 75003 Paris', '3ème Métro Chemin Vert', '', 'Paris', 'Paris', 'FR', 0, 0, 0, '75003', '', 'N/A', '48.8567455', '2.3672081', 'N/A', 'N/A', 4.30, 'N/A', '30-40€', 0, 'N/A', 'Chez_Janou', '2024-09-03 09:54:08.000000', '2024-09-03 09:54:08.000000', 1, 0, 1, 'resources/restaurant/1725357248_39.png', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Chez_Janou', '49.47.132.135', 24, 'Super Admin', 1, 1, '2024-09-03 04:01:33', '2024-09-03 04:24:08'),
(160, 'Daroco Bourse', 22, '2', 'Occasion', 'nicedecor,instagramfamous,idealwithfriends,greatatmosphere,authenticfood,cocktaillover,veganoptions,winebar,localprodcts,fuudfavourite,italianfood', '244,239,123,104,82,67,58,57,56,53,245', 'Installé dans les anciens ateliers de couture de Jean-Paul Gaultier, DAROCO Bourse c’est un design unique, pensé par les architectes Olivier Delannoy et Francesca Errico, récompensé du prix Fooding du « Meilleur décor » en 2017.', 'Installé dans les anciens ateliers de couture de Jean-Paul Gaultier, DAROCO Bourse c’est un design unique, pensé par les architectes Olivier Delannoy et Francesca Errico, récompensé du prix Fooding du « Meilleur décor » en 2017. \r\nDAROCO Bourse envoie le meilleur des produits frais italiens, sourcés au plus près des producteurs de sa « Botte secrète » : des pâtes fabriquées sur place à la meilleure pizza de Paris du chef Federico Schiavon, maestro des grands classiques de la trattoria.\r\n\r\nInstalled in the former sewing workshops of Jean-Paul Gaultier, DAROCO Bourse is a unique design, designed by architects Olivier Delannoy and Francesca Errico, awarded the Fooding prize for “Best decor” in 2017.\r\nDAROCO Bourse sends the best of fresh Italian products, sourced as close as possible to the producers of its “Secret Boot”: from pasta made on site to the best pizza in Paris from chef Federico Schiavon, maestro of the great trattoria classics.', '6 Rue Vivienne, 75002 Paris, France', '2ème  Métro Bourse', '', 'Paris', 'Paris', 'FR', 0, 0, 0, '75002', '', '', '48.8671501', '2.3392434', 'N/A', 'N/A', 4.20, 'N/A', '30-40€', 0, 'N/A', 'Daroco_Bourse', '2024-09-03 10:38:12.000000', '2024-09-03 10:38:12.000000', 1, 0, 1, 'resources/restaurant/1725359892_40.jpg', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Daroco_Bourse', 'N/A', 0, 'N/A', 1, 1, '2024-09-03 05:08:12', '2024-09-03 05:08:12'),
(161, 'Le Rouge à Lèvres', 22, '2', 'Occasion', 'localproducts,perfectforadate,nicedecor,instagramfamous,greatatmosphere,authenticfood,winebar,goodwine,intimate,naturalwine,music', '129,128,126,125,123,67,58,56,53,52,49', 'Bar à vin avec un décor intimiste et exotique, qui sert des tapas avec produits de saison.', 'Bar à vin avec un décor intimiste et exotique, qui sert des tapas avec produits de saison.\r\n\r\nWine bar with intimate and exotic decor, that serves tapas with seasonal products.', '6 Rue Rougemont, 75009 Paris, France', '9ème  Métro Bonne Nouvelle', '', 'Paris', 'Paris', 'FR', 1, 1, 1, '75009', '', '', '48.87161099999999', '2.3461122', 'N/A', 'N/A', 4.20, 'N/A', '20-30€', 0, 'N/A', 'Le_Rouge_à_Lèvres', '2024-09-03 10:44:56.000000', '2024-09-03 10:44:56.000000', 1, 0, 1, 'resources/restaurant/1725360296_34.png', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Le_Rouge_à_Lèvres', 'N/A', 0, 'N/A', 1, 1, '2024-09-03 05:14:56', '2024-09-03 05:14:56'),
(162, 'Ōrtensia', 22, '2', 'Occasion', 'finedining,localproducts,uniqueexperience,michelinstyle,perfectforadate,nicedecor', '53,52,51,50,49,48', 'Niché dans la rue Beethoven, Ōrtensia est un joyau intime d’une vingtaine de couverts, niché à deux pas du Trocadéro, où le Chef Terumitsu Saito invite les passionnés de haute gastronomie à découvrir des mets minutieusement élaborés et des vins soigneusement choisis avec une passion débordante.', 'Niché dans la rue Beethoven, Ōrtensia est un joyau intime d’une vingtaine de couverts, niché à deux pas du Trocadéro, où le Chef Terumitsu Saito invite les passionnés de haute gastronomie à découvrir des mets minutieusement élaborés et des vins soigneusement choisis avec une passion débordante.\r\n\r\nNestled in rue Beethoven, Ōrtensia is an intimate jewel with around twenty seats, nestled a stone\\\'s throw from the Trocadéro, where Chef Terumitsu Saito invites lovers of haute cuisine to discover carefully crafted dishes and wines carefully chosen with passion. overflowing.', '4 Rue Beethoven, 75016 Paris, France', '16ème  Métro Passy', '', 'Paris', 'Paris', 'FR', 1, 1, 0, '75016', '', '', '48.85837839999999', '2.287571299999999', 'N/A', 'N/A', 4.80, 'N/A', '100€+', 0, 'N/A', 'Ōrtensia', '2024-09-03 10:52:02.000000', '2024-09-03 10:52:02.000000', 1, 0, 1, 'resources/restaurant/1725360722_42.webp', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Ōrtensia', 'N/A', 0, 'N/A', 1, 1, '2024-09-03 05:22:02', '2024-09-03 05:22:02'),
(163, 'Francette', 22, '1', 'Cuisines', 'nicedecor,cocktaillover,goodwine,intimate,naturalwine,music,thaifood nicedecor,seafood', '237,129,128,126,125,82,53,246', 'Amarré juste en face de la tour Eiffel, le bateau à quai propose de s’évader tout au long de l’année grâce à ses trois espaces : un penthouse sur le toit avec vue imprenable sur la Tour Eiffel, un restaurant mettant la gastronomie française à l’honneur avec Marie Pacotte en cuisine, et enfin un cave inédite sous l’eau.', 'Amarré juste en face de la tour Eiffel, le bateau à quai propose de s’évader tout au long de l’année grâce à ses trois espaces : un penthouse sur le toit avec vue imprenable sur la Tour Eiffel, un restaurant mettant la gastronomie française à l’honneur avec Marie Pacotte en cuisine, et enfin un cave inédite sous l’eau.\r\n\r\nMoored right in front of the Eiffel Tower, the boat at the dock offers an escape all year round thanks to its three spaces: a penthouse on the roof with a breathtaking view of the Eiffel Tower, a restaurant showcasing French gastronomy in the spotlight with Marie Pacotte in the kitchen, and finally a unique underwater cellar.', '1 Port de Suffren, 75007 Paris, France', '7ème  Métro Bir-Hakeim', '', 'Paris', 'Paris', 'FR', 1, 1, 1, '75007', '', '', '48.8590961', '2.2921884', 'N/A', 'N/A', 4.50, 'N/A', '30-50€', 0, 'N/A', 'Francette', '2024-09-03 10:55:58.000000', '2024-09-03 10:55:58.000000', 1, 0, 1, 'resources/restaurant/1725360958_43.jpg', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Francette', 'N/A', 0, 'N/A', 1, 1, '2024-09-03 05:25:58', '2024-09-03 05:25:58'),
(164, 'Polpo Brasserie', 22, '1', 'Cuisines', 'localproducts,perfectforadate,instagramfamous,idealwithfriends,authenticfood,cocktaillover,summervibe,winebar,greatatmosphe,goodwine,intimate,naturalwine,music,happyhour,seafood', '246,240,129,128,126,125,124,123,113,82,67,57,56,52,49', 'Amarré juste en face de la tour Eiffel, le bateau à quai propose de s’évader tout au long de l’année grâce à ses trois espaces : un penthouse sur le toit avec vue imprenable sur la Tour Eiffel, un restaurant mettant la gastronomie française à l’honneur avec Marie Pacotte en cuisine, et enfin un cave inédite sous l’eau.', 'Amarré juste en face de la tour Eiffel, le bateau à quai propose de s’évader tout au long de l’année grâce à ses trois espaces : un penthouse sur le toit avec vue imprenable sur la Tour Eiffel, un restaurant mettant la gastronomie française à l’honneur avec Marie Pacotte en cuisine, et enfin un cave inédite sous l’eau.\r\n\r\nMoored right in front of the Eiffel Tower, the boat at the dock offers an escape all year round thanks to its three spaces: a penthouse on the roof with a breathtaking view of the Eiffel Tower, a restaurant showcasing French gastronomy in the spotlight with Marie Pacotte in the kitchen, and finally a unique underwater cellar.', '47 Quai Charles Pasqua, 92300 Levallois-Perret, France', 'Levallois-Perret Métro Pont de Levallois Bécon', '', 'Paris', 'Paris', 'FR', 0, 0, 0, '92300', '', '', '48.90044229999999', '2.28132', 'N/A', 'N/A', 4.20, 'N/A', '40-50€', 0, 'N/A', 'Polpo_Brasserie', '2024-09-03 11:00:20.000000', '2024-09-03 11:00:20.000000', 1, 0, 1, 'resources/restaurant/1725361220_44.jpg', 'N/A', 0, NULL, 'https://fudd.galileosoft.com/reservations/Polpo_Brasserie', 'N/A', 0, 'N/A', 1, 1, '2024-09-03 05:30:20', '2024-09-03 05:30:20');

-- --------------------------------------------------------

--
-- Table structure for table `restaurant_business_hours`
--

CREATE TABLE `restaurant_business_hours` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `restaurant_id` int(11) NOT NULL,
  `country` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `shift_name` varchar(255) NOT NULL,
  `day_of_week` enum('monday','tuesday','wednesday','thursday','friday','saturday','sunday') NOT NULL,
  `slot_time` time DEFAULT NULL,
  `added_by` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `restaurant_business_hours`
--

INSERT INTO `restaurant_business_hours` (`id`, `restaurant_id`, `country`, `city`, `shift_name`, `day_of_week`, `slot_time`, `added_by`, `created_at`, `updated_at`) VALUES
(1306, 64, NULL, NULL, 'Lun-Dim', 'monday', '12:00:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1307, 64, NULL, NULL, 'Lun-Dim', 'monday', '12:50:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1308, 64, NULL, NULL, 'Lun-Dim', 'monday', '13:40:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1309, 64, NULL, NULL, 'Lun-Dim', 'monday', '14:30:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1310, 64, NULL, NULL, 'Lun-Dim', 'tuesday', '12:00:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1311, 64, NULL, NULL, 'Lun-Dim', 'monday', '15:20:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1312, 64, NULL, NULL, 'Lun-Dim', 'tuesday', '12:50:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1313, 64, NULL, NULL, 'Lun-Dim', 'monday', '16:10:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1314, 64, NULL, NULL, 'Lun-Dim', 'tuesday', '13:40:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1315, 64, NULL, NULL, 'Lun-Dim', 'monday', '17:00:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1316, 64, NULL, NULL, 'Lun-Dim', 'tuesday', '14:30:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1317, 64, NULL, NULL, 'Lun-Dim', 'monday', '17:50:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1318, 64, NULL, NULL, 'Lun-Dim', 'monday', '18:40:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1319, 64, NULL, NULL, 'Lun-Dim', 'tuesday', '15:20:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1320, 64, NULL, NULL, 'Lun-Dim', 'monday', '19:30:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1321, 64, NULL, NULL, 'Lun-Dim', 'tuesday', '16:10:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1322, 64, NULL, NULL, 'Lun-Dim', 'monday', '20:20:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1323, 64, NULL, NULL, 'Lun-Dim', 'tuesday', '17:00:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1324, 64, NULL, NULL, 'Lun-Dim', 'monday', '21:10:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1325, 64, NULL, NULL, 'Lun-Dim', 'tuesday', '17:50:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1326, 64, NULL, NULL, 'Lun-Dim', 'friday', '12:00:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1327, 64, NULL, NULL, 'Lun-Dim', 'monday', '22:00:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1328, 64, NULL, NULL, 'Lun-Dim', 'tuesday', '18:40:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1329, 64, NULL, NULL, 'Lun-Dim', 'friday', '12:50:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1330, 64, NULL, NULL, 'Lun-Dim', 'monday', '22:50:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1331, 64, NULL, NULL, 'Lun-Dim', 'tuesday', '19:30:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1332, 64, NULL, NULL, 'Lun-Dim', 'friday', '13:40:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1333, 64, NULL, NULL, 'Lun-Dim', 'tuesday', '20:20:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1334, 64, NULL, NULL, 'Lun-Dim', 'friday', '14:30:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1335, 64, NULL, NULL, 'Lun-Dim', 'tuesday', '21:10:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1336, 64, NULL, NULL, 'Lun-Dim', 'friday', '15:20:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1337, 64, NULL, NULL, 'Lun-Dim', 'tuesday', '22:00:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1338, 64, NULL, NULL, 'Lun-Dim', 'friday', '16:10:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1339, 64, NULL, NULL, 'Lun-Dim', 'tuesday', '22:50:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1340, 64, NULL, NULL, 'Lun-Dim', 'friday', '17:00:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1341, 64, NULL, NULL, 'Lun-Dim', 'friday', '17:50:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1342, 64, NULL, NULL, 'Lun-Dim', 'friday', '18:40:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1343, 64, NULL, NULL, 'Lun-Dim', 'friday', '19:30:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1344, 64, NULL, NULL, 'Lun-Dim', 'friday', '20:20:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1345, 64, NULL, NULL, 'Lun-Dim', 'friday', '21:10:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1346, 64, NULL, NULL, 'Lun-Dim', 'friday', '22:00:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1347, 64, NULL, NULL, 'Lun-Dim', 'friday', '22:50:00', 24, '2024-06-06 03:53:48', '2024-06-06 03:53:48'),
(1348, 64, NULL, NULL, 'Lun-Dim', 'thursday', '12:00:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1349, 64, NULL, NULL, 'Lun-Dim', 'thursday', '12:50:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1350, 64, NULL, NULL, 'Lun-Dim', 'thursday', '13:40:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1351, 64, NULL, NULL, 'Lun-Dim', 'thursday', '14:30:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1352, 64, NULL, NULL, 'Lun-Dim', 'saturday', '12:00:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1353, 64, NULL, NULL, 'Lun-Dim', 'thursday', '15:20:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1354, 64, NULL, NULL, 'Lun-Dim', 'saturday', '12:50:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1355, 64, NULL, NULL, 'Lun-Dim', 'thursday', '16:10:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1356, 64, NULL, NULL, 'Lun-Dim', 'saturday', '13:40:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1357, 64, NULL, NULL, 'Lun-Dim', 'thursday', '17:00:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1358, 64, NULL, NULL, 'Lun-Dim', 'saturday', '14:30:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1359, 64, NULL, NULL, 'Lun-Dim', 'thursday', '17:50:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1360, 64, NULL, NULL, 'Lun-Dim', 'saturday', '15:20:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1361, 64, NULL, NULL, 'Lun-Dim', 'thursday', '18:40:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1362, 64, NULL, NULL, 'Lun-Dim', 'saturday', '16:10:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1363, 64, NULL, NULL, 'Lun-Dim', 'thursday', '19:30:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1364, 64, NULL, NULL, 'Lun-Dim', 'saturday', '17:00:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1365, 64, NULL, NULL, 'Lun-Dim', 'thursday', '20:20:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1366, 64, NULL, NULL, 'Lun-Dim', 'saturday', '17:50:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1367, 64, NULL, NULL, 'Lun-Dim', 'thursday', '21:10:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1368, 64, NULL, NULL, 'Lun-Dim', 'thursday', '22:00:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1369, 64, NULL, NULL, 'Lun-Dim', 'saturday', '18:40:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1370, 64, NULL, NULL, 'Lun-Dim', 'thursday', '22:50:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1371, 64, NULL, NULL, 'Lun-Dim', 'saturday', '19:30:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1372, 64, NULL, NULL, 'Lun-Dim', 'saturday', '20:20:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1373, 64, NULL, NULL, 'Lun-Dim', 'saturday', '21:10:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1374, 64, NULL, NULL, 'Lun-Dim', 'saturday', '22:00:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1375, 64, NULL, NULL, 'Lun-Dim', 'saturday', '22:50:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1376, 64, NULL, NULL, 'Lun-Dim', 'sunday', '12:00:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1377, 64, NULL, NULL, 'Lun-Dim', 'sunday', '12:50:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1378, 64, NULL, NULL, 'Lun-Dim', 'wednesday', '12:00:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1379, 64, NULL, NULL, 'Lun-Dim', 'sunday', '13:40:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1380, 64, NULL, NULL, 'Lun-Dim', 'wednesday', '12:50:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1381, 64, NULL, NULL, 'Lun-Dim', 'sunday', '14:30:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1382, 64, NULL, NULL, 'Lun-Dim', 'wednesday', '13:40:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1383, 64, NULL, NULL, 'Lun-Dim', 'sunday', '15:20:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1384, 64, NULL, NULL, 'Lun-Dim', 'wednesday', '14:30:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1385, 64, NULL, NULL, 'Lun-Dim', 'sunday', '16:10:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1386, 64, NULL, NULL, 'Lun-Dim', 'wednesday', '15:20:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1387, 64, NULL, NULL, 'Lun-Dim', 'sunday', '17:00:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1388, 64, NULL, NULL, 'Lun-Dim', 'wednesday', '16:10:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1389, 64, NULL, NULL, 'Lun-Dim', 'sunday', '17:50:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1390, 64, NULL, NULL, 'Lun-Dim', 'wednesday', '17:00:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1391, 64, NULL, NULL, 'Lun-Dim', 'sunday', '18:40:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1392, 64, NULL, NULL, 'Lun-Dim', 'wednesday', '17:50:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1393, 64, NULL, NULL, 'Lun-Dim', 'sunday', '19:30:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1394, 64, NULL, NULL, 'Lun-Dim', 'wednesday', '18:40:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1395, 64, NULL, NULL, 'Lun-Dim', 'sunday', '20:20:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1396, 64, NULL, NULL, 'Lun-Dim', 'wednesday', '19:30:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1397, 64, NULL, NULL, 'Lun-Dim', 'sunday', '21:10:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1398, 64, NULL, NULL, 'Lun-Dim', 'wednesday', '20:20:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1399, 64, NULL, NULL, 'Lun-Dim', 'sunday', '22:00:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1400, 64, NULL, NULL, 'Lun-Dim', 'wednesday', '21:10:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1401, 64, NULL, NULL, 'Lun-Dim', 'sunday', '22:50:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1402, 64, NULL, NULL, 'Lun-Dim', 'wednesday', '22:00:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1403, 64, NULL, NULL, 'Lun-Dim', 'wednesday', '22:50:00', 24, '2024-06-06 03:53:49', '2024-06-06 03:53:49'),
(1404, 65, NULL, NULL, '', 'monday', '11:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1405, 65, NULL, NULL, '', 'monday', '12:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1406, 65, NULL, NULL, '', 'monday', '13:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1407, 65, NULL, NULL, '', 'monday', '14:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1408, 65, NULL, NULL, '', 'monday', '15:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1409, 65, NULL, NULL, '', 'monday', '16:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1410, 65, NULL, NULL, '', 'monday', '17:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1411, 65, NULL, NULL, '', 'monday', '18:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1412, 65, NULL, NULL, '', 'monday', '19:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1413, 65, NULL, NULL, '', 'monday', '20:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1414, 65, NULL, NULL, '', 'monday', '21:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1415, 65, NULL, NULL, '', 'monday', '22:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1416, 65, NULL, NULL, '', 'saturday', '11:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1417, 65, NULL, NULL, '', 'saturday', '12:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1418, 65, NULL, NULL, '', 'saturday', '13:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1419, 65, NULL, NULL, '', 'saturday', '14:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1420, 65, NULL, NULL, '', 'saturday', '15:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1421, 65, NULL, NULL, '', 'saturday', '16:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1422, 65, NULL, NULL, '', 'saturday', '17:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1423, 65, NULL, NULL, '', 'saturday', '18:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1424, 65, NULL, NULL, '', 'saturday', '19:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1425, 65, NULL, NULL, '', 'saturday', '20:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1426, 65, NULL, NULL, '', 'saturday', '21:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1427, 65, NULL, NULL, '', 'saturday', '22:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1428, 65, NULL, NULL, '', 'tuesday', '11:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1429, 65, NULL, NULL, '', 'tuesday', '12:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1430, 65, NULL, NULL, '', 'tuesday', '13:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1431, 65, NULL, NULL, '', 'tuesday', '14:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1432, 65, NULL, NULL, '', 'tuesday', '15:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1433, 65, NULL, NULL, '', 'tuesday', '16:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1434, 65, NULL, NULL, '', 'tuesday', '17:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1435, 65, NULL, NULL, '', 'tuesday', '18:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1436, 65, NULL, NULL, '', 'tuesday', '19:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1437, 65, NULL, NULL, '', 'tuesday', '20:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1438, 65, NULL, NULL, '', 'tuesday', '21:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1439, 65, NULL, NULL, '', 'tuesday', '22:30:00', 24, '2024-06-06 03:54:42', '2024-06-06 03:54:42'),
(1440, 66, NULL, NULL, 'Lun-Dim', 'tuesday', '15:00:00', 24, '2024-06-06 03:57:09', '2024-06-06 03:57:09'),
(1441, 66, NULL, NULL, 'Lun-Dim', 'tuesday', '22:45:00', 24, '2024-06-06 03:57:09', '2024-06-06 03:57:09'),
(1442, 66, NULL, NULL, 'Lun-Dim', 'monday', '15:00:00', 24, '2024-06-06 03:57:09', '2024-06-06 03:57:09'),
(1443, 66, NULL, NULL, 'Lun-Dim', 'monday', '22:45:00', 24, '2024-06-06 03:57:09', '2024-06-06 03:57:09'),
(1444, 70, NULL, NULL, '', 'monday', '19:00:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1445, 70, NULL, NULL, '', 'monday', '19:30:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1446, 70, NULL, NULL, '', 'monday', '20:00:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1447, 70, NULL, NULL, '', 'monday', '20:30:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1448, 70, NULL, NULL, '', 'monday', '21:00:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1449, 70, NULL, NULL, '', 'monday', '21:30:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1450, 70, NULL, NULL, '', 'monday', '22:00:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1451, 70, NULL, NULL, '', 'monday', '22:30:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1452, 70, NULL, NULL, '', 'monday', '23:00:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1453, 70, NULL, NULL, '', 'wednesday', '19:00:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1454, 70, NULL, NULL, '', 'tuesday', '19:00:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1455, 70, NULL, NULL, '', 'wednesday', '19:30:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1456, 70, NULL, NULL, '', 'tuesday', '19:30:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1457, 70, NULL, NULL, '', 'wednesday', '20:00:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1458, 70, NULL, NULL, '', 'tuesday', '20:00:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1459, 70, NULL, NULL, '', 'wednesday', '20:30:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1460, 70, NULL, NULL, '', 'tuesday', '20:30:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1461, 70, NULL, NULL, '', 'wednesday', '21:00:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1462, 70, NULL, NULL, '', 'tuesday', '21:00:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1463, 70, NULL, NULL, '', 'wednesday', '21:30:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1464, 70, NULL, NULL, '', 'tuesday', '21:30:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1465, 70, NULL, NULL, '', 'wednesday', '22:00:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1466, 70, NULL, NULL, '', 'tuesday', '22:00:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1467, 70, NULL, NULL, '', 'wednesday', '22:30:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1468, 70, NULL, NULL, '', 'tuesday', '22:30:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1469, 70, NULL, NULL, '', 'wednesday', '23:00:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1470, 70, NULL, NULL, '', 'tuesday', '23:00:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1471, 70, NULL, NULL, '', 'thursday', '19:00:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1472, 70, NULL, NULL, '', 'thursday', '19:30:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1473, 70, NULL, NULL, '', 'thursday', '20:00:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1474, 70, NULL, NULL, '', 'thursday', '20:30:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1475, 70, NULL, NULL, '', 'thursday', '21:00:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1476, 70, NULL, NULL, '', 'thursday', '21:30:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1477, 70, NULL, NULL, '', 'thursday', '22:00:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1478, 70, NULL, NULL, '', 'thursday', '22:30:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1479, 70, NULL, NULL, '', 'thursday', '23:00:00', 24, '2024-06-06 03:57:57', '2024-06-06 03:57:57'),
(1480, 70, NULL, NULL, '', 'friday', '13:00:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1481, 70, NULL, NULL, '', 'friday', '13:30:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1482, 70, NULL, NULL, '', 'friday', '14:00:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1483, 70, NULL, NULL, '', 'friday', '14:30:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1484, 70, NULL, NULL, '', 'friday', '15:00:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1485, 70, NULL, NULL, '', 'friday', '15:30:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1486, 70, NULL, NULL, '', 'friday', '16:00:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1487, 70, NULL, NULL, '', 'friday', '16:30:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1488, 70, NULL, NULL, '', 'friday', '17:00:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1489, 70, NULL, NULL, '', 'friday', '17:30:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1490, 70, NULL, NULL, '', 'friday', '18:00:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1491, 70, NULL, NULL, '', 'friday', '18:30:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1492, 70, NULL, NULL, '', 'friday', '19:00:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1493, 70, NULL, NULL, '', 'friday', '19:30:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1494, 70, NULL, NULL, '', 'friday', '20:00:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1495, 70, NULL, NULL, '', 'friday', '20:30:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1496, 70, NULL, NULL, '', 'friday', '21:00:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1497, 70, NULL, NULL, '', 'friday', '21:30:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1498, 70, NULL, NULL, '', 'friday', '22:00:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1499, 70, NULL, NULL, '', 'friday', '22:30:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1500, 70, NULL, NULL, '', 'friday', '23:00:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1501, 70, NULL, NULL, '', 'saturday', '13:00:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1502, 70, NULL, NULL, '', 'saturday', '13:30:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1503, 70, NULL, NULL, '', 'saturday', '14:00:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1504, 70, NULL, NULL, '', 'saturday', '14:30:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1505, 70, NULL, NULL, '', 'sunday', '13:00:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1506, 70, NULL, NULL, '', 'saturday', '15:00:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1507, 70, NULL, NULL, '', 'sunday', '13:30:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1508, 70, NULL, NULL, '', 'saturday', '15:30:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1509, 70, NULL, NULL, '', 'sunday', '14:00:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1510, 70, NULL, NULL, '', 'saturday', '16:00:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1511, 70, NULL, NULL, '', 'sunday', '14:30:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1512, 70, NULL, NULL, '', 'saturday', '16:30:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1513, 70, NULL, NULL, '', 'sunday', '15:00:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1514, 70, NULL, NULL, '', 'saturday', '17:00:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1515, 70, NULL, NULL, '', 'sunday', '15:30:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1516, 70, NULL, NULL, '', 'saturday', '17:30:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1517, 70, NULL, NULL, '', 'sunday', '16:00:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1518, 70, NULL, NULL, '', 'saturday', '18:00:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1519, 70, NULL, NULL, '', 'sunday', '16:30:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1520, 70, NULL, NULL, '', 'saturday', '18:30:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1521, 70, NULL, NULL, '', 'sunday', '17:00:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1522, 70, NULL, NULL, '', 'saturday', '19:00:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1523, 70, NULL, NULL, '', 'sunday', '17:30:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1524, 70, NULL, NULL, '', 'saturday', '19:30:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1525, 70, NULL, NULL, '', 'sunday', '18:00:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1526, 70, NULL, NULL, '', 'saturday', '20:00:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1527, 70, NULL, NULL, '', 'sunday', '18:30:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1528, 70, NULL, NULL, '', 'saturday', '20:30:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1529, 70, NULL, NULL, '', 'sunday', '19:00:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1530, 70, NULL, NULL, '', 'saturday', '21:00:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1531, 70, NULL, NULL, '', 'sunday', '19:30:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1532, 70, NULL, NULL, '', 'saturday', '21:30:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1533, 70, NULL, NULL, '', 'sunday', '20:00:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1534, 70, NULL, NULL, '', 'saturday', '22:00:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1535, 70, NULL, NULL, '', 'sunday', '20:30:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1536, 70, NULL, NULL, '', 'saturday', '22:30:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1537, 70, NULL, NULL, '', 'sunday', '21:00:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1538, 70, NULL, NULL, '', 'saturday', '23:00:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1539, 70, NULL, NULL, '', 'sunday', '21:30:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1540, 70, NULL, NULL, '', 'sunday', '22:00:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1541, 70, NULL, NULL, '', 'sunday', '22:30:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1542, 70, NULL, NULL, '', 'sunday', '23:00:00', 24, '2024-06-06 03:57:58', '2024-06-06 03:57:58'),
(1543, 71, NULL, NULL, '', 'tuesday', '13:00:00', 24, '2024-06-06 04:03:25', '2024-06-06 04:03:25'),
(1544, 71, NULL, NULL, '', 'tuesday', '21:45:00', 24, '2024-06-06 04:03:25', '2024-06-06 04:03:25'),
(1545, 71, NULL, NULL, '', 'monday', '13:00:00', 24, '2024-06-06 04:03:25', '2024-06-06 04:03:25'),
(1546, 71, NULL, NULL, '', 'monday', '21:45:00', 24, '2024-06-06 04:03:25', '2024-06-06 04:03:25'),
(1547, 71, NULL, NULL, '', 'wednesday', '13:00:00', 24, '2024-06-06 04:03:25', '2024-06-06 04:03:25'),
(1548, 71, NULL, NULL, '', 'wednesday', '21:45:00', 24, '2024-06-06 04:03:25', '2024-06-06 04:03:25'),
(1549, 71, NULL, NULL, '', 'monday', '12:00:00', 24, '2024-06-13 07:29:41', '2024-06-13 07:29:41'),
(1550, 71, NULL, NULL, '', 'monday', '12:45:00', 24, '2024-06-13 07:29:41', '2024-06-13 07:29:41'),
(1551, 71, NULL, NULL, '', 'monday', '13:30:00', 24, '2024-06-13 07:29:41', '2024-06-13 07:29:41'),
(1552, 71, NULL, NULL, '', 'monday', '14:15:00', 24, '2024-06-13 07:29:41', '2024-06-13 07:29:41'),
(1553, 71, NULL, NULL, '', 'monday', '15:00:00', 24, '2024-06-13 07:29:41', '2024-06-13 07:29:41'),
(1554, 71, NULL, NULL, '', 'monday', '15:45:00', 24, '2024-06-13 07:29:41', '2024-06-13 07:29:41'),
(1555, 71, NULL, NULL, '', 'monday', '16:30:00', 24, '2024-06-13 07:29:41', '2024-06-13 07:29:41'),
(1556, 71, NULL, NULL, '', 'monday', '17:15:00', 24, '2024-06-13 07:29:41', '2024-06-13 07:29:41'),
(1557, 71, NULL, NULL, '', 'monday', '18:00:00', 24, '2024-06-13 07:29:41', '2024-06-13 07:29:41'),
(1558, 71, NULL, NULL, '', 'monday', '18:45:00', 24, '2024-06-13 07:29:41', '2024-06-13 07:29:41'),
(1559, 71, NULL, NULL, '', 'monday', '19:30:00', 24, '2024-06-13 07:29:41', '2024-06-13 07:29:41'),
(1560, 71, NULL, NULL, '', 'monday', '20:15:00', 24, '2024-06-13 07:29:41', '2024-06-13 07:29:41'),
(1561, 71, NULL, NULL, '', 'monday', '21:00:00', 24, '2024-06-13 07:29:41', '2024-06-13 07:29:41'),
(1562, 72, NULL, NULL, 'lun', 'monday', '12:00:00', 24, '2024-06-13 08:07:48', '2024-06-13 08:07:48'),
(1563, 72, NULL, NULL, 'lun', 'monday', '12:45:00', 24, '2024-06-13 08:07:48', '2024-06-13 08:07:48'),
(1564, 72, NULL, NULL, 'lun', 'monday', '13:30:00', 24, '2024-06-13 08:07:48', '2024-06-13 08:07:48'),
(1565, 72, NULL, NULL, 'lun', 'monday', '14:15:00', 24, '2024-06-13 08:07:48', '2024-06-13 08:07:48'),
(1566, 72, NULL, NULL, 'lun', 'monday', '15:00:00', 24, '2024-06-13 08:07:48', '2024-06-13 08:07:48'),
(1567, 72, NULL, NULL, 'lun', 'monday', '15:45:00', 24, '2024-06-13 08:07:48', '2024-06-13 08:07:48'),
(1568, 72, NULL, NULL, 'lun', 'monday', '16:30:00', 24, '2024-06-13 08:07:48', '2024-06-13 08:07:48'),
(1569, 72, NULL, NULL, 'lun', 'monday', '17:15:00', 24, '2024-06-13 08:07:48', '2024-06-13 08:07:48'),
(1570, 72, NULL, NULL, 'lun', 'monday', '18:00:00', 24, '2024-06-13 08:07:48', '2024-06-13 08:07:48'),
(1571, 72, NULL, NULL, 'lun', 'monday', '18:45:00', 24, '2024-06-13 08:07:48', '2024-06-13 08:07:48'),
(1572, 72, NULL, NULL, 'lun', 'monday', '19:30:00', 24, '2024-06-13 08:07:48', '2024-06-13 08:07:48'),
(1573, 72, NULL, NULL, 'lun', 'monday', '20:15:00', 24, '2024-06-13 08:07:48', '2024-06-13 08:07:48'),
(1574, 72, NULL, NULL, 'lun', 'monday', '21:00:00', 24, '2024-06-13 08:07:48', '2024-06-13 08:07:48'),
(1575, 72, NULL, NULL, 'lun', 'monday', '21:45:00', 24, '2024-06-13 08:07:48', '2024-06-13 08:07:48'),
(1576, 72, NULL, NULL, 'lun', 'monday', '22:30:00', 24, '2024-06-13 08:07:48', '2024-06-13 08:07:48'),
(1577, 72, NULL, NULL, 'lun', 'monday', '23:15:00', 24, '2024-06-13 08:07:48', '2024-06-13 08:07:48'),
(1579, 66, NULL, NULL, 'lun', 'monday', '12:00:00', 24, '2024-06-14 00:59:51', '2024-06-14 00:59:51'),
(1580, 66, NULL, NULL, 'lun', 'monday', '12:45:00', 24, '2024-06-14 00:59:51', '2024-06-14 00:59:51'),
(1581, 66, NULL, NULL, 'lun', 'monday', '13:30:00', 24, '2024-06-14 00:59:51', '2024-06-14 00:59:51'),
(1582, 66, NULL, NULL, 'lun', 'monday', '14:15:00', 24, '2024-06-14 00:59:51', '2024-06-14 00:59:51'),
(1583, 66, NULL, NULL, 'lun', 'monday', '15:45:00', 24, '2024-06-14 00:59:51', '2024-06-14 00:59:51'),
(1584, 66, NULL, NULL, 'lun', 'monday', '16:30:00', 24, '2024-06-14 00:59:51', '2024-06-14 00:59:51'),
(1585, 66, NULL, NULL, 'lun', 'monday', '17:15:00', 24, '2024-06-14 00:59:51', '2024-06-14 00:59:51'),
(1586, 66, NULL, NULL, 'lun', 'monday', '18:00:00', 24, '2024-06-14 00:59:51', '2024-06-14 00:59:51'),
(1587, 66, NULL, NULL, 'lun', 'monday', '18:45:00', 24, '2024-06-14 00:59:51', '2024-06-14 00:59:51'),
(1588, 66, NULL, NULL, 'lun', 'monday', '19:30:00', 24, '2024-06-14 00:59:51', '2024-06-14 00:59:51'),
(1589, 66, NULL, NULL, 'lun', 'monday', '20:15:00', 24, '2024-06-14 00:59:51', '2024-06-14 00:59:51'),
(1590, 66, NULL, NULL, 'lun', 'monday', '21:00:00', 24, '2024-06-14 00:59:51', '2024-06-14 00:59:51'),
(1591, 66, NULL, NULL, 'lun', 'monday', '21:45:00', 24, '2024-06-14 00:59:51', '2024-06-14 00:59:51'),
(1592, 66, NULL, NULL, 'lun', 'monday', '22:30:00', 24, '2024-06-14 00:59:51', '2024-06-14 00:59:51'),
(1593, 66, NULL, NULL, 'lun', 'monday', '23:15:00', 24, '2024-06-14 00:59:51', '2024-06-14 00:59:51'),
(1595, 66, NULL, NULL, 'lun', 'tuesday', '12:00:00', 24, '2024-06-14 00:59:51', '2024-06-14 00:59:51'),
(1596, 66, NULL, NULL, 'lun', 'tuesday', '12:45:00', 24, '2024-06-14 00:59:51', '2024-06-14 00:59:51'),
(1597, 66, NULL, NULL, 'lun', 'tuesday', '13:30:00', 24, '2024-06-14 00:59:51', '2024-06-14 00:59:51'),
(1598, 66, NULL, NULL, 'lun', 'tuesday', '14:15:00', 24, '2024-06-14 00:59:51', '2024-06-14 00:59:51'),
(1599, 66, NULL, NULL, 'lun', 'tuesday', '15:45:00', 24, '2024-06-14 00:59:51', '2024-06-14 00:59:51'),
(1600, 66, NULL, NULL, 'lun', 'tuesday', '16:30:00', 24, '2024-06-14 00:59:51', '2024-06-14 00:59:51'),
(1601, 66, NULL, NULL, 'lun', 'tuesday', '17:15:00', 24, '2024-06-14 00:59:51', '2024-06-14 00:59:51'),
(1602, 66, NULL, NULL, 'lun', 'tuesday', '18:00:00', 24, '2024-06-14 00:59:51', '2024-06-14 00:59:51'),
(1603, 66, NULL, NULL, 'lun', 'tuesday', '18:45:00', 24, '2024-06-14 00:59:51', '2024-06-14 00:59:51'),
(1604, 66, NULL, NULL, 'lun', 'tuesday', '19:30:00', 24, '2024-06-14 00:59:51', '2024-06-14 00:59:51'),
(1605, 66, NULL, NULL, 'lun', 'tuesday', '20:15:00', 24, '2024-06-14 00:59:51', '2024-06-14 00:59:51'),
(1606, 66, NULL, NULL, 'lun', 'tuesday', '21:00:00', 24, '2024-06-14 00:59:51', '2024-06-14 00:59:51'),
(1607, 66, NULL, NULL, 'lun', 'tuesday', '21:45:00', 24, '2024-06-14 00:59:51', '2024-06-14 00:59:51'),
(1608, 66, NULL, NULL, 'lun', 'tuesday', '22:30:00', 24, '2024-06-14 00:59:51', '2024-06-14 00:59:51'),
(1609, 66, NULL, NULL, 'lun', 'tuesday', '23:15:00', 24, '2024-06-14 00:59:51', '2024-06-14 00:59:51'),
(1610, 66, NULL, NULL, 'lun', 'tuesday', '24:00:00', 24, '2024-06-14 00:59:51', '2024-06-14 00:59:51'),
(1611, 11, NULL, NULL, 'TEST', 'monday', '10:00:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1612, 11, NULL, NULL, 'TEST', 'monday', '10:45:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1613, 11, NULL, NULL, 'TEST', 'monday', '11:30:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1614, 11, NULL, NULL, 'TEST', 'monday', '12:15:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1615, 11, NULL, NULL, 'TEST', 'monday', '13:00:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1616, 11, NULL, NULL, 'TEST', 'monday', '13:45:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1617, 11, NULL, NULL, 'TEST', 'monday', '14:30:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1618, 11, NULL, NULL, 'TEST', 'monday', '15:15:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1619, 11, NULL, NULL, 'TEST', 'monday', '16:00:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1620, 11, NULL, NULL, 'TEST', 'monday', '16:45:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1621, 11, NULL, NULL, 'TEST', 'monday', '17:30:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1622, 11, NULL, NULL, 'TEST', 'monday', '18:15:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1623, 11, NULL, NULL, 'TEST', 'monday', '19:00:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1624, 11, NULL, NULL, 'TEST', 'monday', '19:45:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1625, 11, NULL, NULL, 'TEST', 'monday', '20:30:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1626, 11, NULL, NULL, 'TEST', 'monday', '21:15:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1627, 11, NULL, NULL, 'TEST', 'monday', '22:00:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1628, 11, NULL, NULL, 'TEST', 'monday', '22:45:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1629, 11, NULL, NULL, 'TEST', 'monday', '23:30:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1630, 11, NULL, NULL, 'TEST', 'tuesday', '10:00:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1631, 11, NULL, NULL, 'TEST', 'tuesday', '10:45:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1632, 11, NULL, NULL, 'TEST', 'tuesday', '11:30:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1633, 11, NULL, NULL, 'TEST', 'tuesday', '12:15:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1634, 11, NULL, NULL, 'TEST', 'tuesday', '13:00:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1635, 11, NULL, NULL, 'TEST', 'tuesday', '13:45:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1636, 11, NULL, NULL, 'TEST', 'tuesday', '14:30:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1637, 11, NULL, NULL, 'TEST', 'tuesday', '15:15:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1638, 11, NULL, NULL, 'TEST', 'tuesday', '16:00:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1639, 11, NULL, NULL, 'TEST', 'tuesday', '16:45:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1640, 11, NULL, NULL, 'TEST', 'tuesday', '17:30:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1641, 11, NULL, NULL, 'TEST', 'tuesday', '18:15:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1642, 11, NULL, NULL, 'TEST', 'tuesday', '19:00:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1643, 11, NULL, NULL, 'TEST', 'tuesday', '19:45:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1644, 11, NULL, NULL, 'TEST', 'tuesday', '20:30:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1645, 11, NULL, NULL, 'TEST', 'tuesday', '21:15:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1646, 11, NULL, NULL, 'TEST', 'tuesday', '22:00:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1647, 11, NULL, NULL, 'TEST', 'tuesday', '22:45:00', 24, '2024-06-20 00:57:55', '2024-06-20 00:57:55'),
(1648, 86, NULL, NULL, 'Lun&sam', 'friday', '12:15:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1649, 86, NULL, NULL, 'Lun&sam', 'wednesday', '12:15:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1650, 86, NULL, NULL, 'Lun&sam', 'friday', '12:50:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1651, 86, NULL, NULL, 'Lun&sam', 'wednesday', '12:50:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1652, 86, NULL, NULL, 'Lun&sam', 'friday', '13:25:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1653, 86, NULL, NULL, 'Lun&sam', 'wednesday', '13:25:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1654, 86, NULL, NULL, 'Lun&sam', 'friday', '14:00:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1655, 86, NULL, NULL, 'Lun&sam', 'wednesday', '14:00:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1656, 86, NULL, NULL, 'Lun&sam', 'friday', '14:35:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1657, 86, NULL, NULL, 'Lun&sam', 'wednesday', '14:35:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1658, 86, NULL, NULL, 'Lun&sam', 'friday', '15:10:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1659, 86, NULL, NULL, 'Lun&sam', 'wednesday', '15:10:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1660, 86, NULL, NULL, 'Lun&sam', 'friday', '15:45:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1661, 86, NULL, NULL, 'Lun&sam', 'wednesday', '15:45:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1662, 86, NULL, NULL, 'Lun&sam', 'friday', '16:20:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1663, 86, NULL, NULL, 'Lun&sam', 'wednesday', '16:20:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1664, 86, NULL, NULL, 'Lun&sam', 'friday', '16:55:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1665, 86, NULL, NULL, 'Lun&sam', 'wednesday', '16:55:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1666, 86, NULL, NULL, 'Lun&sam', 'wednesday', '17:30:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1667, 86, NULL, NULL, 'Lun&sam', 'friday', '17:30:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1668, 86, NULL, NULL, 'Lun&sam', 'friday', '18:05:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1669, 86, NULL, NULL, 'Lun&sam', 'wednesday', '18:05:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1670, 86, NULL, NULL, 'Lun&sam', 'friday', '18:40:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1671, 86, NULL, NULL, 'Lun&sam', 'wednesday', '18:40:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1672, 86, NULL, NULL, 'Lun&sam', 'friday', '19:15:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1673, 86, NULL, NULL, 'Lun&sam', 'wednesday', '19:15:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1674, 86, NULL, NULL, 'Lun&sam', 'friday', '19:50:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1675, 86, NULL, NULL, 'Lun&sam', 'wednesday', '19:50:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1676, 86, NULL, NULL, 'Lun&sam', 'friday', '20:25:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1677, 86, NULL, NULL, 'Lun&sam', 'wednesday', '20:25:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1678, 86, NULL, NULL, 'Lun&sam', 'friday', '21:00:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1679, 86, NULL, NULL, 'Lun&sam', 'wednesday', '21:00:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1680, 86, NULL, NULL, 'Lun&sam', 'friday', '21:35:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1681, 86, NULL, NULL, 'Lun&sam', 'wednesday', '21:35:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1682, 86, NULL, NULL, 'Lun&sam', 'saturday', '12:15:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1683, 86, NULL, NULL, 'Lun&sam', 'saturday', '12:50:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1684, 86, NULL, NULL, 'Lun&sam', 'saturday', '13:25:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1685, 86, NULL, NULL, 'Lun&sam', 'saturday', '14:00:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1686, 86, NULL, NULL, 'Lun&sam', 'saturday', '14:35:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1687, 86, NULL, NULL, 'Lun&sam', 'saturday', '15:10:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1688, 86, NULL, NULL, 'Lun&sam', 'saturday', '15:45:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1689, 86, NULL, NULL, 'Lun&sam', 'saturday', '16:20:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1690, 86, NULL, NULL, 'Lun&sam', 'saturday', '16:55:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1691, 86, NULL, NULL, 'Lun&sam', 'saturday', '17:30:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1692, 86, NULL, NULL, 'Lun&sam', 'saturday', '18:05:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1693, 86, NULL, NULL, 'Lun&sam', 'saturday', '18:40:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1694, 86, NULL, NULL, 'Lun&sam', 'saturday', '19:15:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1695, 86, NULL, NULL, 'Lun&sam', 'saturday', '19:50:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1696, 86, NULL, NULL, 'Lun&sam', 'saturday', '20:25:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1697, 86, NULL, NULL, 'Lun&sam', 'saturday', '21:00:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1698, 86, NULL, NULL, 'Lun&sam', 'saturday', '21:35:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1699, 86, NULL, NULL, 'Lun&sam', 'tuesday', '12:15:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1700, 86, NULL, NULL, 'Lun&sam', 'tuesday', '12:50:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1701, 86, NULL, NULL, 'Lun&sam', 'tuesday', '13:25:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1702, 86, NULL, NULL, 'Lun&sam', 'thursday', '12:15:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1703, 86, NULL, NULL, 'Lun&sam', 'tuesday', '14:00:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1704, 86, NULL, NULL, 'Lun&sam', 'thursday', '12:50:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1705, 86, NULL, NULL, 'Lun&sam', 'tuesday', '14:35:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1706, 86, NULL, NULL, 'Lun&sam', 'thursday', '13:25:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1707, 86, NULL, NULL, 'Lun&sam', 'tuesday', '15:10:00', 24, '2024-08-05 00:09:06', '2024-08-05 00:09:06'),
(1708, 86, NULL, NULL, 'Lun&sam', 'thursday', '14:00:00', 24, '2024-08-05 00:09:07', '2024-08-05 00:09:07'),
(1709, 86, NULL, NULL, 'Lun&sam', 'tuesday', '15:45:00', 24, '2024-08-05 00:09:07', '2024-08-05 00:09:07'),
(1710, 86, NULL, NULL, 'Lun&sam', 'thursday', '14:35:00', 24, '2024-08-05 00:09:07', '2024-08-05 00:09:07'),
(1711, 86, NULL, NULL, 'Lun&sam', 'tuesday', '16:20:00', 24, '2024-08-05 00:09:07', '2024-08-05 00:09:07'),
(1712, 86, NULL, NULL, 'Lun&sam', 'thursday', '15:10:00', 24, '2024-08-05 00:09:07', '2024-08-05 00:09:07'),
(1713, 86, NULL, NULL, 'Lun&sam', 'tuesday', '16:55:00', 24, '2024-08-05 00:09:07', '2024-08-05 00:09:07'),
(1714, 86, NULL, NULL, 'Lun&sam', 'thursday', '15:45:00', 24, '2024-08-05 00:09:07', '2024-08-05 00:09:07'),
(1715, 86, NULL, NULL, 'Lun&sam', 'tuesday', '17:30:00', 24, '2024-08-05 00:09:07', '2024-08-05 00:09:07'),
(1716, 86, NULL, NULL, 'Lun&sam', 'thursday', '16:20:00', 24, '2024-08-05 00:09:07', '2024-08-05 00:09:07'),
(1717, 86, NULL, NULL, 'Lun&sam', 'tuesday', '18:05:00', 24, '2024-08-05 00:09:07', '2024-08-05 00:09:07'),
(1718, 86, NULL, NULL, 'Lun&sam', 'thursday', '16:55:00', 24, '2024-08-05 00:09:07', '2024-08-05 00:09:07'),
(1719, 86, NULL, NULL, 'Lun&sam', 'tuesday', '18:40:00', 24, '2024-08-05 00:09:07', '2024-08-05 00:09:07'),
(1720, 86, NULL, NULL, 'Lun&sam', 'thursday', '17:30:00', 24, '2024-08-05 00:09:07', '2024-08-05 00:09:07'),
(1721, 86, NULL, NULL, 'Lun&sam', 'tuesday', '19:15:00', 24, '2024-08-05 00:09:07', '2024-08-05 00:09:07'),
(1722, 86, NULL, NULL, 'Lun&sam', 'thursday', '18:05:00', 24, '2024-08-05 00:09:07', '2024-08-05 00:09:07'),
(1723, 86, NULL, NULL, 'Lun&sam', 'tuesday', '19:50:00', 24, '2024-08-05 00:09:07', '2024-08-05 00:09:07'),
(1724, 86, NULL, NULL, 'Lun&sam', 'thursday', '18:40:00', 24, '2024-08-05 00:09:07', '2024-08-05 00:09:07'),
(1725, 86, NULL, NULL, 'Lun&sam', 'tuesday', '20:25:00', 24, '2024-08-05 00:09:07', '2024-08-05 00:09:07'),
(1726, 86, NULL, NULL, 'Lun&sam', 'thursday', '19:15:00', 24, '2024-08-05 00:09:07', '2024-08-05 00:09:07'),
(1727, 86, NULL, NULL, 'Lun&sam', 'tuesday', '21:00:00', 24, '2024-08-05 00:09:07', '2024-08-05 00:09:07'),
(1728, 86, NULL, NULL, 'Lun&sam', 'thursday', '19:50:00', 24, '2024-08-05 00:09:07', '2024-08-05 00:09:07'),
(1729, 86, NULL, NULL, 'Lun&sam', 'tuesday', '21:35:00', 24, '2024-08-05 00:09:07', '2024-08-05 00:09:07'),
(1730, 86, NULL, NULL, 'Lun&sam', 'thursday', '20:25:00', 24, '2024-08-05 00:09:07', '2024-08-05 00:09:07'),
(1731, 86, NULL, NULL, 'Lun&sam', 'thursday', '21:00:00', 24, '2024-08-05 00:09:07', '2024-08-05 00:09:07'),
(1732, 86, NULL, NULL, 'Lun&sam', 'thursday', '21:35:00', 24, '2024-08-05 00:09:07', '2024-08-05 00:09:07'),
(1733, 87, NULL, NULL, 'Mardi & Ven', 'thursday', '09:15:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1734, 87, NULL, NULL, 'Mardi & Ven', 'tuesday', '09:15:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1735, 87, NULL, NULL, 'Mardi & Ven', 'thursday', '10:00:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1736, 87, NULL, NULL, 'Mardi & Ven', 'friday', '09:15:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1737, 87, NULL, NULL, 'Mardi & Ven', 'tuesday', '10:00:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1738, 87, NULL, NULL, 'Mardi & Ven', 'friday', '10:00:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1739, 87, NULL, NULL, 'Mardi & Ven', 'thursday', '10:45:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1740, 87, NULL, NULL, 'Mardi & Ven', 'tuesday', '10:45:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1741, 87, NULL, NULL, 'Mardi & Ven', 'friday', '10:45:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1742, 87, NULL, NULL, 'Mardi & Ven', 'thursday', '11:30:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1743, 87, NULL, NULL, 'Mardi & Ven', 'tuesday', '11:30:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1744, 87, NULL, NULL, 'Mardi & Ven', 'friday', '11:30:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1745, 87, NULL, NULL, 'Mardi & Ven', 'thursday', '12:15:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1746, 87, NULL, NULL, 'Mardi & Ven', 'friday', '12:15:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1747, 87, NULL, NULL, 'Mardi & Ven', 'tuesday', '12:15:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1748, 87, NULL, NULL, 'Mardi & Ven', 'thursday', '13:00:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1749, 87, NULL, NULL, 'Mardi & Ven', 'friday', '13:00:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1750, 87, NULL, NULL, 'Mardi & Ven', 'tuesday', '13:00:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1751, 87, NULL, NULL, 'Mardi & Ven', 'thursday', '13:45:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1752, 87, NULL, NULL, 'Mardi & Ven', 'saturday', '09:15:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1753, 87, NULL, NULL, 'Mardi & Ven', 'friday', '13:45:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1754, 87, NULL, NULL, 'Mardi & Ven', 'tuesday', '13:45:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1755, 87, NULL, NULL, 'Mardi & Ven', 'saturday', '10:00:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1756, 87, NULL, NULL, 'Mardi & Ven', 'wednesday', '09:15:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1757, 87, NULL, NULL, 'Mardi & Ven', 'thursday', '14:30:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1758, 87, NULL, NULL, 'Mardi & Ven', 'friday', '14:30:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1759, 87, NULL, NULL, 'Mardi & Ven', 'saturday', '10:45:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1760, 87, NULL, NULL, 'Mardi & Ven', 'tuesday', '14:30:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1761, 87, NULL, NULL, 'Mardi & Ven', 'thursday', '15:15:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1762, 87, NULL, NULL, 'Mardi & Ven', 'wednesday', '10:00:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1763, 87, NULL, NULL, 'Mardi & Ven', 'friday', '15:15:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1764, 87, NULL, NULL, 'Mardi & Ven', 'saturday', '11:30:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1765, 87, NULL, NULL, 'Mardi & Ven', 'tuesday', '15:15:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1766, 87, NULL, NULL, 'Mardi & Ven', 'thursday', '16:00:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1767, 87, NULL, NULL, 'Mardi & Ven', 'wednesday', '10:45:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1768, 87, NULL, NULL, 'Mardi & Ven', 'friday', '16:00:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1769, 87, NULL, NULL, 'Mardi & Ven', 'saturday', '12:15:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1770, 87, NULL, NULL, 'Mardi & Ven', 'tuesday', '16:00:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1771, 87, NULL, NULL, 'Mardi & Ven', 'thursday', '16:45:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1772, 87, NULL, NULL, 'Mardi & Ven', 'friday', '16:45:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1773, 87, NULL, NULL, 'Mardi & Ven', 'wednesday', '11:30:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1774, 87, NULL, NULL, 'Mardi & Ven', 'saturday', '13:00:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1775, 87, NULL, NULL, 'Mardi & Ven', 'tuesday', '16:45:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1776, 87, NULL, NULL, 'Mardi & Ven', 'thursday', '17:30:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1777, 87, NULL, NULL, 'Mardi & Ven', 'friday', '17:30:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1778, 87, NULL, NULL, 'Mardi & Ven', 'wednesday', '12:15:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1779, 87, NULL, NULL, 'Mardi & Ven', 'saturday', '13:45:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1780, 87, NULL, NULL, 'Mardi & Ven', 'tuesday', '17:30:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1781, 87, NULL, NULL, 'Mardi & Ven', 'thursday', '18:15:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1782, 87, NULL, NULL, 'Mardi & Ven', 'friday', '18:15:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1783, 87, NULL, NULL, 'Mardi & Ven', 'wednesday', '13:00:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1784, 87, NULL, NULL, 'Mardi & Ven', 'tuesday', '18:15:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1785, 87, NULL, NULL, 'Mardi & Ven', 'saturday', '14:30:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1786, 87, NULL, NULL, 'Mardi & Ven', 'thursday', '19:00:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1787, 87, NULL, NULL, 'Mardi & Ven', 'friday', '19:00:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37');
INSERT INTO `restaurant_business_hours` (`id`, `restaurant_id`, `country`, `city`, `shift_name`, `day_of_week`, `slot_time`, `added_by`, `created_at`, `updated_at`) VALUES
(1788, 87, NULL, NULL, 'Mardi & Ven', 'tuesday', '19:00:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1789, 87, NULL, NULL, 'Mardi & Ven', 'wednesday', '13:45:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1790, 87, NULL, NULL, 'Mardi & Ven', 'saturday', '15:15:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1791, 87, NULL, NULL, 'Mardi & Ven', 'thursday', '19:45:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1792, 87, NULL, NULL, 'Mardi & Ven', 'friday', '19:45:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1793, 87, NULL, NULL, 'Mardi & Ven', 'wednesday', '14:30:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1794, 87, NULL, NULL, 'Mardi & Ven', 'tuesday', '19:45:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1795, 87, NULL, NULL, 'Mardi & Ven', 'saturday', '16:00:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1796, 87, NULL, NULL, 'Mardi & Ven', 'wednesday', '15:15:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1797, 87, NULL, NULL, 'Mardi & Ven', 'saturday', '16:45:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1798, 87, NULL, NULL, 'Mardi & Ven', 'wednesday', '16:00:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1799, 87, NULL, NULL, 'Mardi & Ven', 'saturday', '17:30:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1800, 87, NULL, NULL, 'Mardi & Ven', 'wednesday', '16:45:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1801, 87, NULL, NULL, 'Mardi & Ven', 'saturday', '18:15:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1802, 87, NULL, NULL, 'Mardi & Ven', 'wednesday', '17:30:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1803, 87, NULL, NULL, 'Mardi & Ven', 'wednesday', '18:15:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1804, 87, NULL, NULL, 'Mardi & Ven', 'saturday', '19:00:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1805, 87, NULL, NULL, 'Mardi & Ven', 'wednesday', '19:00:00', 24, '2024-08-05 00:10:37', '2024-08-05 00:10:37'),
(1806, 87, NULL, NULL, 'Mardi & Ven', 'wednesday', '19:45:00', 24, '2024-08-05 00:10:38', '2024-08-05 00:10:38'),
(1807, 87, NULL, NULL, 'Mardi & Ven', 'saturday', '19:45:00', 24, '2024-08-05 00:10:38', '2024-08-05 00:10:38'),
(1808, 87, NULL, NULL, 'Mardi & Ven', 'sunday', '09:30:00', 24, '2024-08-05 00:10:38', '2024-08-05 00:10:38'),
(1809, 87, NULL, NULL, 'Mardi & Ven', 'sunday', '10:15:00', 24, '2024-08-05 00:10:38', '2024-08-05 00:10:38'),
(1810, 87, NULL, NULL, 'Mardi & Ven', 'sunday', '11:00:00', 24, '2024-08-05 00:10:38', '2024-08-05 00:10:38'),
(1811, 87, NULL, NULL, 'Mardi & Ven', 'sunday', '11:45:00', 24, '2024-08-05 00:10:38', '2024-08-05 00:10:38'),
(1812, 87, NULL, NULL, 'Mardi & Ven', 'sunday', '12:30:00', 24, '2024-08-05 00:10:38', '2024-08-05 00:10:38'),
(1813, 87, NULL, NULL, 'Mardi & Ven', 'sunday', '13:15:00', 24, '2024-08-05 00:10:38', '2024-08-05 00:10:38'),
(1814, 88, NULL, NULL, '', 'saturday', '09:30:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1815, 88, NULL, NULL, '', 'saturday', '10:15:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1816, 88, NULL, NULL, '', 'saturday', '11:00:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1817, 88, NULL, NULL, '', 'saturday', '11:45:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1818, 88, NULL, NULL, '', 'saturday', '12:30:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1819, 88, NULL, NULL, '', 'saturday', '13:15:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1820, 88, NULL, NULL, '', 'thursday', '09:30:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1821, 88, NULL, NULL, '', 'thursday', '10:15:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1822, 88, NULL, NULL, '', 'thursday', '11:00:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1823, 88, NULL, NULL, '', 'thursday', '11:45:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1824, 88, NULL, NULL, '', 'thursday', '12:30:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1825, 88, NULL, NULL, '', 'thursday', '13:15:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1826, 88, NULL, NULL, '', 'wednesday', '09:30:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1827, 88, NULL, NULL, '', 'wednesday', '10:15:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1828, 88, NULL, NULL, '', 'wednesday', '11:00:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1829, 88, NULL, NULL, '', 'wednesday', '11:45:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1830, 88, NULL, NULL, '', 'wednesday', '12:30:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1831, 88, NULL, NULL, '', 'wednesday', '13:15:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1832, 88, NULL, NULL, '', 'tuesday', '09:30:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1833, 88, NULL, NULL, '', 'tuesday', '10:15:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1834, 88, NULL, NULL, '', 'tuesday', '11:00:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1835, 88, NULL, NULL, '', 'friday', '09:30:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1836, 88, NULL, NULL, '', 'tuesday', '11:45:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1837, 88, NULL, NULL, '', 'friday', '10:15:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1838, 88, NULL, NULL, '', 'tuesday', '12:30:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1839, 88, NULL, NULL, '', 'friday', '11:00:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1840, 88, NULL, NULL, '', 'tuesday', '13:15:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1841, 88, NULL, NULL, '', 'friday', '11:45:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1842, 88, NULL, NULL, '', 'friday', '12:30:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1843, 88, NULL, NULL, '', 'friday', '13:15:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1844, 88, NULL, NULL, '', 'monday', '09:30:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1845, 88, NULL, NULL, '', 'monday', '10:15:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1846, 88, NULL, NULL, '', 'monday', '11:00:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1847, 88, NULL, NULL, '', 'monday', '11:45:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1848, 88, NULL, NULL, '', 'monday', '12:30:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1849, 88, NULL, NULL, '', 'monday', '13:15:00', 24, '2024-08-05 00:11:13', '2024-08-05 00:11:13'),
(1850, 89, NULL, NULL, 'Lun&Dim', 'tuesday', '12:00:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1851, 89, NULL, NULL, 'Lun&Dim', 'tuesday', '12:35:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1852, 89, NULL, NULL, 'Lun&Dim', 'tuesday', '13:10:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1853, 89, NULL, NULL, 'Lun&Dim', 'tuesday', '13:45:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1854, 89, NULL, NULL, 'Lun&Dim', 'tuesday', '14:20:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1855, 89, NULL, NULL, 'Lun&Dim', 'tuesday', '14:55:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1856, 89, NULL, NULL, 'Lun&Dim', 'tuesday', '15:30:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1857, 89, NULL, NULL, 'Lun&Dim', 'tuesday', '16:05:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1858, 89, NULL, NULL, 'Lun&Dim', 'wednesday', '12:00:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1859, 89, NULL, NULL, 'Lun&Dim', 'tuesday', '16:40:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1860, 89, NULL, NULL, 'Lun&Dim', 'wednesday', '12:35:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1861, 89, NULL, NULL, 'Lun&Dim', 'tuesday', '17:15:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1862, 89, NULL, NULL, 'Lun&Dim', 'wednesday', '13:10:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1863, 89, NULL, NULL, 'Lun&Dim', 'tuesday', '17:50:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1864, 89, NULL, NULL, 'Lun&Dim', 'wednesday', '13:45:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1865, 89, NULL, NULL, 'Lun&Dim', 'tuesday', '18:25:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1866, 89, NULL, NULL, 'Lun&Dim', 'wednesday', '14:20:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1867, 89, NULL, NULL, 'Lun&Dim', 'tuesday', '19:00:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1868, 89, NULL, NULL, 'Lun&Dim', 'wednesday', '14:55:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1869, 89, NULL, NULL, 'Lun&Dim', 'tuesday', '19:35:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1870, 89, NULL, NULL, 'Lun&Dim', 'tuesday', '20:10:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1871, 89, NULL, NULL, 'Lun&Dim', 'wednesday', '15:30:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1872, 89, NULL, NULL, 'Lun&Dim', 'tuesday', '20:45:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1873, 89, NULL, NULL, 'Lun&Dim', 'wednesday', '16:05:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1874, 89, NULL, NULL, 'Lun&Dim', 'tuesday', '21:20:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1875, 89, NULL, NULL, 'Lun&Dim', 'wednesday', '16:40:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1876, 89, NULL, NULL, 'Lun&Dim', 'tuesday', '21:55:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1877, 89, NULL, NULL, 'Lun&Dim', 'wednesday', '17:15:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1878, 89, NULL, NULL, 'Lun&Dim', 'tuesday', '22:30:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1879, 89, NULL, NULL, 'Lun&Dim', 'wednesday', '17:50:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1880, 89, NULL, NULL, 'Lun&Dim', 'tuesday', '23:05:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1881, 89, NULL, NULL, 'Lun&Dim', 'wednesday', '18:25:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1882, 89, NULL, NULL, 'Lun&Dim', 'tuesday', '23:40:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1883, 89, NULL, NULL, 'Lun&Dim', 'wednesday', '19:00:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1884, 89, NULL, NULL, 'Lun&Dim', 'wednesday', '19:35:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1885, 89, NULL, NULL, 'Lun&Dim', 'wednesday', '20:10:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1886, 89, NULL, NULL, 'Lun&Dim', 'wednesday', '20:45:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1887, 89, NULL, NULL, 'Lun&Dim', 'wednesday', '21:20:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1888, 89, NULL, NULL, 'Lun&Dim', 'wednesday', '21:55:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1889, 89, NULL, NULL, 'Lun&Dim', 'wednesday', '22:30:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1890, 89, NULL, NULL, 'Lun&Dim', 'wednesday', '23:05:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1891, 89, NULL, NULL, 'Lun&Dim', 'wednesday', '23:40:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1892, 89, NULL, NULL, 'Lun&Dim', 'thursday', '12:00:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1893, 89, NULL, NULL, 'Lun&Dim', 'saturday', '12:00:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1894, 89, NULL, NULL, 'Lun&Dim', 'thursday', '12:35:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1895, 89, NULL, NULL, 'Lun&Dim', 'saturday', '12:35:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1896, 89, NULL, NULL, 'Lun&Dim', 'thursday', '13:10:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1897, 89, NULL, NULL, 'Lun&Dim', 'thursday', '13:45:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1898, 89, NULL, NULL, 'Lun&Dim', 'saturday', '13:10:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1899, 89, NULL, NULL, 'Lun&Dim', 'thursday', '14:20:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1900, 89, NULL, NULL, 'Lun&Dim', 'saturday', '13:45:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1901, 89, NULL, NULL, 'Lun&Dim', 'thursday', '14:55:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1902, 89, NULL, NULL, 'Lun&Dim', 'saturday', '14:20:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1903, 89, NULL, NULL, 'Lun&Dim', 'thursday', '15:30:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1904, 89, NULL, NULL, 'Lun&Dim', 'saturday', '14:55:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1905, 89, NULL, NULL, 'Lun&Dim', 'thursday', '16:05:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1906, 89, NULL, NULL, 'Lun&Dim', 'saturday', '15:30:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1907, 89, NULL, NULL, 'Lun&Dim', 'monday', '12:00:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1908, 89, NULL, NULL, 'Lun&Dim', 'thursday', '16:40:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1909, 89, NULL, NULL, 'Lun&Dim', 'sunday', '12:00:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1910, 89, NULL, NULL, 'Lun&Dim', 'saturday', '16:05:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1911, 89, NULL, NULL, 'Lun&Dim', 'sunday', '12:35:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1912, 89, NULL, NULL, 'Lun&Dim', 'saturday', '16:40:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1913, 89, NULL, NULL, 'Lun&Dim', 'thursday', '17:15:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1914, 89, NULL, NULL, 'Lun&Dim', 'monday', '12:35:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1915, 89, NULL, NULL, 'Lun&Dim', 'saturday', '17:15:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1916, 89, NULL, NULL, 'Lun&Dim', 'friday', '12:00:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1917, 89, NULL, NULL, 'Lun&Dim', 'thursday', '17:50:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1918, 89, NULL, NULL, 'Lun&Dim', 'monday', '13:10:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1919, 89, NULL, NULL, 'Lun&Dim', 'sunday', '13:10:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1920, 89, NULL, NULL, 'Lun&Dim', 'saturday', '17:50:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1921, 89, NULL, NULL, 'Lun&Dim', 'sunday', '13:45:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1922, 89, NULL, NULL, 'Lun&Dim', 'thursday', '18:25:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1923, 89, NULL, NULL, 'Lun&Dim', 'friday', '12:35:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1924, 89, NULL, NULL, 'Lun&Dim', 'monday', '13:45:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1925, 89, NULL, NULL, 'Lun&Dim', 'saturday', '18:25:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1926, 89, NULL, NULL, 'Lun&Dim', 'monday', '14:20:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1927, 89, NULL, NULL, 'Lun&Dim', 'thursday', '19:00:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1928, 89, NULL, NULL, 'Lun&Dim', 'sunday', '14:20:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1929, 89, NULL, NULL, 'Lun&Dim', 'friday', '13:10:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1930, 89, NULL, NULL, 'Lun&Dim', 'saturday', '19:00:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1931, 89, NULL, NULL, 'Lun&Dim', 'monday', '14:55:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1932, 89, NULL, NULL, 'Lun&Dim', 'thursday', '19:35:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1933, 89, NULL, NULL, 'Lun&Dim', 'sunday', '14:55:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1934, 89, NULL, NULL, 'Lun&Dim', 'friday', '13:45:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1935, 89, NULL, NULL, 'Lun&Dim', 'saturday', '19:35:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1936, 89, NULL, NULL, 'Lun&Dim', 'friday', '14:20:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1937, 89, NULL, NULL, 'Lun&Dim', 'sunday', '15:30:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1938, 89, NULL, NULL, 'Lun&Dim', 'thursday', '20:10:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1939, 89, NULL, NULL, 'Lun&Dim', 'monday', '15:30:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1940, 89, NULL, NULL, 'Lun&Dim', 'saturday', '20:10:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1941, 89, NULL, NULL, 'Lun&Dim', 'sunday', '16:05:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1942, 89, NULL, NULL, 'Lun&Dim', 'thursday', '20:45:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1943, 89, NULL, NULL, 'Lun&Dim', 'friday', '14:55:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1944, 89, NULL, NULL, 'Lun&Dim', 'monday', '16:05:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1945, 89, NULL, NULL, 'Lun&Dim', 'thursday', '21:20:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1946, 89, NULL, NULL, 'Lun&Dim', 'friday', '15:30:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1947, 89, NULL, NULL, 'Lun&Dim', 'sunday', '16:40:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1948, 89, NULL, NULL, 'Lun&Dim', 'saturday', '20:45:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1949, 89, NULL, NULL, 'Lun&Dim', 'thursday', '21:55:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1950, 89, NULL, NULL, 'Lun&Dim', 'friday', '16:05:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1951, 89, NULL, NULL, 'Lun&Dim', 'sunday', '17:15:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1952, 89, NULL, NULL, 'Lun&Dim', 'saturday', '21:20:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1953, 89, NULL, NULL, 'Lun&Dim', 'monday', '16:40:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1954, 89, NULL, NULL, 'Lun&Dim', 'thursday', '22:30:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1955, 89, NULL, NULL, 'Lun&Dim', 'friday', '16:40:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1956, 89, NULL, NULL, 'Lun&Dim', 'sunday', '17:50:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1957, 89, NULL, NULL, 'Lun&Dim', 'saturday', '21:55:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1958, 89, NULL, NULL, 'Lun&Dim', 'friday', '17:15:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1959, 89, NULL, NULL, 'Lun&Dim', 'thursday', '23:05:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1960, 89, NULL, NULL, 'Lun&Dim', 'sunday', '18:25:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1961, 89, NULL, NULL, 'Lun&Dim', 'saturday', '22:30:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1962, 89, NULL, NULL, 'Lun&Dim', 'monday', '17:15:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1963, 89, NULL, NULL, 'Lun&Dim', 'friday', '17:50:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1964, 89, NULL, NULL, 'Lun&Dim', 'thursday', '23:40:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1965, 89, NULL, NULL, 'Lun&Dim', 'sunday', '19:00:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1966, 89, NULL, NULL, 'Lun&Dim', 'saturday', '23:05:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1967, 89, NULL, NULL, 'Lun&Dim', 'monday', '17:50:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1968, 89, NULL, NULL, 'Lun&Dim', 'friday', '18:25:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1969, 89, NULL, NULL, 'Lun&Dim', 'saturday', '23:40:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1970, 89, NULL, NULL, 'Lun&Dim', 'sunday', '19:35:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1971, 89, NULL, NULL, 'Lun&Dim', 'monday', '18:25:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1972, 89, NULL, NULL, 'Lun&Dim', 'friday', '19:00:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1973, 89, NULL, NULL, 'Lun&Dim', 'sunday', '20:10:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1974, 89, NULL, NULL, 'Lun&Dim', 'monday', '19:00:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1975, 89, NULL, NULL, 'Lun&Dim', 'friday', '19:35:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1976, 89, NULL, NULL, 'Lun&Dim', 'sunday', '20:45:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1977, 89, NULL, NULL, 'Lun&Dim', 'friday', '20:10:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1978, 89, NULL, NULL, 'Lun&Dim', 'monday', '19:35:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1979, 89, NULL, NULL, 'Lun&Dim', 'sunday', '21:20:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1980, 89, NULL, NULL, 'Lun&Dim', 'monday', '20:10:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1981, 89, NULL, NULL, 'Lun&Dim', 'friday', '20:45:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1982, 89, NULL, NULL, 'Lun&Dim', 'sunday', '21:55:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1983, 89, NULL, NULL, 'Lun&Dim', 'friday', '21:20:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1984, 89, NULL, NULL, 'Lun&Dim', 'monday', '20:45:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1985, 89, NULL, NULL, 'Lun&Dim', 'sunday', '22:30:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1986, 89, NULL, NULL, 'Lun&Dim', 'friday', '21:55:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1987, 89, NULL, NULL, 'Lun&Dim', 'monday', '21:20:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1988, 89, NULL, NULL, 'Lun&Dim', 'sunday', '23:05:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1989, 89, NULL, NULL, 'Lun&Dim', 'friday', '22:30:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1990, 89, NULL, NULL, 'Lun&Dim', 'sunday', '23:40:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1991, 89, NULL, NULL, 'Lun&Dim', 'friday', '23:05:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1992, 89, NULL, NULL, 'Lun&Dim', 'monday', '21:55:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1993, 89, NULL, NULL, 'Lun&Dim', 'monday', '22:30:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1994, 89, NULL, NULL, 'Lun&Dim', 'friday', '23:40:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1995, 89, NULL, NULL, 'Lun&Dim', 'monday', '23:05:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1996, 89, NULL, NULL, 'Lun&Dim', 'monday', '23:40:00', 24, '2024-08-05 00:11:50', '2024-08-05 00:11:50'),
(1997, 90, NULL, NULL, 'Lun-Dim', 'monday', '12:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(1998, 90, NULL, NULL, 'Lun-Dim', 'monday', '12:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(1999, 90, NULL, NULL, 'Lun-Dim', 'monday', '13:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2000, 90, NULL, NULL, 'Lun-Dim', 'monday', '13:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2001, 90, NULL, NULL, 'Lun-Dim', 'tuesday', '12:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2002, 90, NULL, NULL, 'Lun-Dim', 'monday', '14:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2003, 90, NULL, NULL, 'Lun-Dim', 'tuesday', '12:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2004, 90, NULL, NULL, 'Lun-Dim', 'monday', '14:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2005, 90, NULL, NULL, 'Lun-Dim', 'tuesday', '13:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2006, 90, NULL, NULL, 'Lun-Dim', 'monday', '15:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2007, 90, NULL, NULL, 'Lun-Dim', 'monday', '15:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2008, 90, NULL, NULL, 'Lun-Dim', 'tuesday', '13:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2009, 90, NULL, NULL, 'Lun-Dim', 'monday', '16:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2010, 90, NULL, NULL, 'Lun-Dim', 'tuesday', '14:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2011, 90, NULL, NULL, 'Lun-Dim', 'tuesday', '14:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2012, 90, NULL, NULL, 'Lun-Dim', 'monday', '16:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2013, 90, NULL, NULL, 'Lun-Dim', 'tuesday', '15:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2014, 90, NULL, NULL, 'Lun-Dim', 'monday', '17:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2015, 90, NULL, NULL, 'Lun-Dim', 'tuesday', '15:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2016, 90, NULL, NULL, 'Lun-Dim', 'monday', '17:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2017, 90, NULL, NULL, 'Lun-Dim', 'tuesday', '16:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2018, 90, NULL, NULL, 'Lun-Dim', 'monday', '18:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2019, 90, NULL, NULL, 'Lun-Dim', 'tuesday', '16:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2020, 90, NULL, NULL, 'Lun-Dim', 'monday', '18:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2021, 90, NULL, NULL, 'Lun-Dim', 'tuesday', '17:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2022, 90, NULL, NULL, 'Lun-Dim', 'monday', '19:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2023, 90, NULL, NULL, 'Lun-Dim', 'tuesday', '17:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2024, 90, NULL, NULL, 'Lun-Dim', 'monday', '19:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2025, 90, NULL, NULL, 'Lun-Dim', 'tuesday', '18:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2026, 90, NULL, NULL, 'Lun-Dim', 'monday', '20:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2027, 90, NULL, NULL, 'Lun-Dim', 'tuesday', '18:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2028, 90, NULL, NULL, 'Lun-Dim', 'tuesday', '19:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2029, 90, NULL, NULL, 'Lun-Dim', 'monday', '20:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2030, 90, NULL, NULL, 'Lun-Dim', 'tuesday', '19:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2031, 90, NULL, NULL, 'Lun-Dim', 'monday', '21:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2032, 90, NULL, NULL, 'Lun-Dim', 'tuesday', '20:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2033, 90, NULL, NULL, 'Lun-Dim', 'monday', '21:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2034, 90, NULL, NULL, 'Lun-Dim', 'tuesday', '20:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2035, 90, NULL, NULL, 'Lun-Dim', 'monday', '22:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2036, 90, NULL, NULL, 'Lun-Dim', 'tuesday', '21:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2037, 90, NULL, NULL, 'Lun-Dim', 'monday', '22:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2038, 90, NULL, NULL, 'Lun-Dim', 'tuesday', '21:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2039, 90, NULL, NULL, 'Lun-Dim', 'monday', '23:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2040, 90, NULL, NULL, 'Lun-Dim', 'tuesday', '22:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2041, 90, NULL, NULL, 'Lun-Dim', 'monday', '23:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2042, 90, NULL, NULL, 'Lun-Dim', 'tuesday', '22:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2043, 90, NULL, NULL, 'Lun-Dim', 'monday', '24:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2044, 90, NULL, NULL, 'Lun-Dim', 'tuesday', '23:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2045, 90, NULL, NULL, 'Lun-Dim', 'tuesday', '23:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2046, 90, NULL, NULL, 'Lun-Dim', 'tuesday', '24:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2047, 90, NULL, NULL, 'Lun-Dim', 'wednesday', '12:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2048, 90, NULL, NULL, 'Lun-Dim', 'wednesday', '12:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2049, 90, NULL, NULL, 'Lun-Dim', 'wednesday', '13:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2050, 90, NULL, NULL, 'Lun-Dim', 'wednesday', '13:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2051, 90, NULL, NULL, 'Lun-Dim', 'wednesday', '14:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2052, 90, NULL, NULL, 'Lun-Dim', 'wednesday', '14:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2053, 90, NULL, NULL, 'Lun-Dim', 'wednesday', '15:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2054, 90, NULL, NULL, 'Lun-Dim', 'wednesday', '15:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2055, 90, NULL, NULL, 'Lun-Dim', 'wednesday', '16:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2056, 90, NULL, NULL, 'Lun-Dim', 'wednesday', '16:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2057, 90, NULL, NULL, 'Lun-Dim', 'wednesday', '17:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2058, 90, NULL, NULL, 'Lun-Dim', 'wednesday', '17:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2059, 90, NULL, NULL, 'Lun-Dim', 'wednesday', '18:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2060, 90, NULL, NULL, 'Lun-Dim', 'wednesday', '18:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2061, 90, NULL, NULL, 'Lun-Dim', 'wednesday', '19:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2062, 90, NULL, NULL, 'Lun-Dim', 'wednesday', '19:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2063, 90, NULL, NULL, 'Lun-Dim', 'wednesday', '20:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2064, 90, NULL, NULL, 'Lun-Dim', 'wednesday', '20:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2065, 90, NULL, NULL, 'Lun-Dim', 'wednesday', '21:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2066, 90, NULL, NULL, 'Lun-Dim', 'wednesday', '21:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2067, 90, NULL, NULL, 'Lun-Dim', 'wednesday', '22:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2068, 90, NULL, NULL, 'Lun-Dim', 'wednesday', '22:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2069, 90, NULL, NULL, 'Lun-Dim', 'wednesday', '23:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2070, 90, NULL, NULL, 'Lun-Dim', 'wednesday', '23:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2071, 90, NULL, NULL, 'Lun-Dim', 'wednesday', '24:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2072, 90, NULL, NULL, 'Lun-Dim', 'thursday', '12:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2073, 90, NULL, NULL, 'Lun-Dim', 'thursday', '12:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2074, 90, NULL, NULL, 'Lun-Dim', 'thursday', '13:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2075, 90, NULL, NULL, 'Lun-Dim', 'thursday', '13:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2076, 90, NULL, NULL, 'Lun-Dim', 'thursday', '14:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2077, 90, NULL, NULL, 'Lun-Dim', 'thursday', '14:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2078, 90, NULL, NULL, 'Lun-Dim', 'thursday', '15:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2079, 90, NULL, NULL, 'Lun-Dim', 'thursday', '15:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2080, 90, NULL, NULL, 'Lun-Dim', 'saturday', '12:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2081, 90, NULL, NULL, 'Lun-Dim', 'thursday', '16:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2082, 90, NULL, NULL, 'Lun-Dim', 'saturday', '12:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2083, 90, NULL, NULL, 'Lun-Dim', 'thursday', '16:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2084, 90, NULL, NULL, 'Lun-Dim', 'sunday', '12:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2085, 90, NULL, NULL, 'Lun-Dim', 'saturday', '13:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2086, 90, NULL, NULL, 'Lun-Dim', 'thursday', '17:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2087, 90, NULL, NULL, 'Lun-Dim', 'sunday', '12:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2088, 90, NULL, NULL, 'Lun-Dim', 'saturday', '13:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2089, 90, NULL, NULL, 'Lun-Dim', 'thursday', '17:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2090, 90, NULL, NULL, 'Lun-Dim', 'sunday', '13:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2091, 90, NULL, NULL, 'Lun-Dim', 'saturday', '14:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2092, 90, NULL, NULL, 'Lun-Dim', 'thursday', '18:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2093, 90, NULL, NULL, 'Lun-Dim', 'saturday', '14:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2094, 90, NULL, NULL, 'Lun-Dim', 'sunday', '13:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2095, 90, NULL, NULL, 'Lun-Dim', 'thursday', '18:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2096, 90, NULL, NULL, 'Lun-Dim', 'sunday', '14:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2097, 90, NULL, NULL, 'Lun-Dim', 'saturday', '15:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2098, 90, NULL, NULL, 'Lun-Dim', 'thursday', '19:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2099, 90, NULL, NULL, 'Lun-Dim', 'sunday', '14:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2100, 90, NULL, NULL, 'Lun-Dim', 'thursday', '19:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2101, 90, NULL, NULL, 'Lun-Dim', 'saturday', '15:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2102, 90, NULL, NULL, 'Lun-Dim', 'sunday', '15:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2103, 90, NULL, NULL, 'Lun-Dim', 'thursday', '20:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2104, 90, NULL, NULL, 'Lun-Dim', 'thursday', '20:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2105, 90, NULL, NULL, 'Lun-Dim', 'sunday', '15:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2106, 90, NULL, NULL, 'Lun-Dim', 'saturday', '16:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2107, 90, NULL, NULL, 'Lun-Dim', 'thursday', '21:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2108, 90, NULL, NULL, 'Lun-Dim', 'saturday', '16:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2109, 90, NULL, NULL, 'Lun-Dim', 'sunday', '16:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2110, 90, NULL, NULL, 'Lun-Dim', 'sunday', '16:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2111, 90, NULL, NULL, 'Lun-Dim', 'saturday', '17:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2112, 90, NULL, NULL, 'Lun-Dim', 'thursday', '21:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2113, 90, NULL, NULL, 'Lun-Dim', 'sunday', '17:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2114, 90, NULL, NULL, 'Lun-Dim', 'sunday', '17:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2115, 90, NULL, NULL, 'Lun-Dim', 'thursday', '22:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2116, 90, NULL, NULL, 'Lun-Dim', 'saturday', '17:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2117, 90, NULL, NULL, 'Lun-Dim', 'sunday', '18:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2118, 90, NULL, NULL, 'Lun-Dim', 'thursday', '22:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2119, 90, NULL, NULL, 'Lun-Dim', 'sunday', '18:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2120, 90, NULL, NULL, 'Lun-Dim', 'saturday', '18:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2121, 90, NULL, NULL, 'Lun-Dim', 'friday', '12:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2122, 90, NULL, NULL, 'Lun-Dim', 'thursday', '23:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2123, 90, NULL, NULL, 'Lun-Dim', 'sunday', '19:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2124, 90, NULL, NULL, 'Lun-Dim', 'friday', '12:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2125, 90, NULL, NULL, 'Lun-Dim', 'saturday', '18:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2126, 90, NULL, NULL, 'Lun-Dim', 'thursday', '23:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2127, 90, NULL, NULL, 'Lun-Dim', 'sunday', '19:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2128, 90, NULL, NULL, 'Lun-Dim', 'friday', '13:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2129, 90, NULL, NULL, 'Lun-Dim', 'sunday', '20:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2130, 90, NULL, NULL, 'Lun-Dim', 'thursday', '24:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2131, 90, NULL, NULL, 'Lun-Dim', 'saturday', '19:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2132, 90, NULL, NULL, 'Lun-Dim', 'friday', '13:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2133, 90, NULL, NULL, 'Lun-Dim', 'sunday', '20:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2134, 90, NULL, NULL, 'Lun-Dim', 'sunday', '21:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2135, 90, NULL, NULL, 'Lun-Dim', 'saturday', '19:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2136, 90, NULL, NULL, 'Lun-Dim', 'friday', '14:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2137, 90, NULL, NULL, 'Lun-Dim', 'sunday', '21:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2138, 90, NULL, NULL, 'Lun-Dim', 'saturday', '20:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2139, 90, NULL, NULL, 'Lun-Dim', 'friday', '14:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2140, 90, NULL, NULL, 'Lun-Dim', 'sunday', '22:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2141, 90, NULL, NULL, 'Lun-Dim', 'saturday', '20:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2142, 90, NULL, NULL, 'Lun-Dim', 'friday', '15:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2143, 90, NULL, NULL, 'Lun-Dim', 'sunday', '22:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2144, 90, NULL, NULL, 'Lun-Dim', 'saturday', '21:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2145, 90, NULL, NULL, 'Lun-Dim', 'friday', '15:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2146, 90, NULL, NULL, 'Lun-Dim', 'saturday', '21:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2147, 90, NULL, NULL, 'Lun-Dim', 'sunday', '23:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2148, 90, NULL, NULL, 'Lun-Dim', 'friday', '16:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2149, 90, NULL, NULL, 'Lun-Dim', 'sunday', '23:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2150, 90, NULL, NULL, 'Lun-Dim', 'saturday', '22:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2151, 90, NULL, NULL, 'Lun-Dim', 'friday', '16:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2152, 90, NULL, NULL, 'Lun-Dim', 'sunday', '24:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2153, 90, NULL, NULL, 'Lun-Dim', 'saturday', '22:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2154, 90, NULL, NULL, 'Lun-Dim', 'saturday', '23:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2155, 90, NULL, NULL, 'Lun-Dim', 'friday', '17:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2156, 90, NULL, NULL, 'Lun-Dim', 'saturday', '23:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2157, 90, NULL, NULL, 'Lun-Dim', 'friday', '17:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2158, 90, NULL, NULL, 'Lun-Dim', 'saturday', '24:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2159, 90, NULL, NULL, 'Lun-Dim', 'friday', '18:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2160, 90, NULL, NULL, 'Lun-Dim', 'friday', '18:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2161, 90, NULL, NULL, 'Lun-Dim', 'friday', '19:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2162, 90, NULL, NULL, 'Lun-Dim', 'friday', '19:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2163, 90, NULL, NULL, 'Lun-Dim', 'friday', '20:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2164, 90, NULL, NULL, 'Lun-Dim', 'friday', '20:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2165, 90, NULL, NULL, 'Lun-Dim', 'friday', '21:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2166, 90, NULL, NULL, 'Lun-Dim', 'friday', '21:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2167, 90, NULL, NULL, 'Lun-Dim', 'friday', '22:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2168, 90, NULL, NULL, 'Lun-Dim', 'friday', '22:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2169, 90, NULL, NULL, 'Lun-Dim', 'friday', '23:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2170, 90, NULL, NULL, 'Lun-Dim', 'friday', '23:30:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2171, 90, NULL, NULL, 'Lun-Dim', 'friday', '24:00:00', 24, '2024-08-05 00:12:30', '2024-08-05 00:12:30'),
(2172, 91, NULL, NULL, 'Mon-Dim', 'thursday', '07:00:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2173, 91, NULL, NULL, 'Mon-Dim', 'thursday', '07:45:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2174, 91, NULL, NULL, 'Mon-Dim', 'thursday', '08:30:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2175, 91, NULL, NULL, 'Mon-Dim', 'thursday', '09:15:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2176, 91, NULL, NULL, 'Mon-Dim', 'thursday', '10:00:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2177, 91, NULL, NULL, 'Mon-Dim', 'thursday', '10:45:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2178, 91, NULL, NULL, 'Mon-Dim', 'thursday', '11:30:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2179, 91, NULL, NULL, 'Mon-Dim', 'thursday', '12:15:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2180, 91, NULL, NULL, 'Mon-Dim', 'thursday', '13:00:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2181, 91, NULL, NULL, 'Mon-Dim', 'thursday', '13:45:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2182, 91, NULL, NULL, 'Mon-Dim', 'tuesday', '07:00:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2183, 91, NULL, NULL, 'Mon-Dim', 'tuesday', '07:45:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2184, 91, NULL, NULL, 'Mon-Dim', 'tuesday', '08:30:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2185, 91, NULL, NULL, 'Mon-Dim', 'tuesday', '09:15:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2186, 91, NULL, NULL, 'Mon-Dim', 'friday', '07:00:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2187, 91, NULL, NULL, 'Mon-Dim', 'friday', '07:45:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2188, 91, NULL, NULL, 'Mon-Dim', 'wednesday', '07:00:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2189, 91, NULL, NULL, 'Mon-Dim', 'wednesday', '07:45:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2190, 91, NULL, NULL, 'Mon-Dim', 'wednesday', '08:30:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2191, 91, NULL, NULL, 'Mon-Dim', 'tuesday', '10:00:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2192, 91, NULL, NULL, 'Mon-Dim', 'wednesday', '09:15:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2193, 91, NULL, NULL, 'Mon-Dim', 'tuesday', '10:45:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2194, 91, NULL, NULL, 'Mon-Dim', 'wednesday', '10:00:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2195, 91, NULL, NULL, 'Mon-Dim', 'tuesday', '11:30:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2196, 91, NULL, NULL, 'Mon-Dim', 'wednesday', '10:45:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2197, 91, NULL, NULL, 'Mon-Dim', 'tuesday', '12:15:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2198, 91, NULL, NULL, 'Mon-Dim', 'wednesday', '11:30:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2199, 91, NULL, NULL, 'Mon-Dim', 'tuesday', '13:00:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2200, 91, NULL, NULL, 'Mon-Dim', 'wednesday', '12:15:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2201, 91, NULL, NULL, 'Mon-Dim', 'tuesday', '13:45:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2202, 91, NULL, NULL, 'Mon-Dim', 'wednesday', '13:00:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2203, 91, NULL, NULL, 'Mon-Dim', 'wednesday', '13:45:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2204, 91, NULL, NULL, 'Mon-Dim', 'friday', '08:30:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2205, 91, NULL, NULL, 'Mon-Dim', 'saturday', '07:00:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2206, 91, NULL, NULL, 'Mon-Dim', 'saturday', '07:45:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2207, 91, NULL, NULL, 'Mon-Dim', 'saturday', '08:30:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2208, 91, NULL, NULL, 'Mon-Dim', 'saturday', '09:15:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2209, 91, NULL, NULL, 'Mon-Dim', 'saturday', '10:00:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2210, 91, NULL, NULL, 'Mon-Dim', 'saturday', '10:45:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2211, 91, NULL, NULL, 'Mon-Dim', 'saturday', '11:30:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2212, 91, NULL, NULL, 'Mon-Dim', 'saturday', '12:15:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2213, 91, NULL, NULL, 'Mon-Dim', 'saturday', '13:00:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2214, 91, NULL, NULL, 'Mon-Dim', 'saturday', '13:45:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2215, 91, NULL, NULL, 'Mon-Dim', 'monday', '07:00:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2216, 91, NULL, NULL, 'Mon-Dim', 'monday', '07:45:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2217, 91, NULL, NULL, 'Mon-Dim', 'monday', '08:30:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2218, 91, NULL, NULL, 'Mon-Dim', 'monday', '09:15:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2219, 91, NULL, NULL, 'Mon-Dim', 'monday', '10:00:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2220, 91, NULL, NULL, 'Mon-Dim', 'friday', '09:15:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2221, 91, NULL, NULL, 'Mon-Dim', 'friday', '10:00:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2222, 91, NULL, NULL, 'Mon-Dim', 'friday', '10:45:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2223, 91, NULL, NULL, 'Mon-Dim', 'friday', '11:30:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2224, 91, NULL, NULL, 'Mon-Dim', 'friday', '12:15:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2225, 91, NULL, NULL, 'Mon-Dim', 'friday', '13:00:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2226, 91, NULL, NULL, 'Mon-Dim', 'friday', '13:45:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2227, 91, NULL, NULL, 'Mon-Dim', 'monday', '10:45:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2228, 91, NULL, NULL, 'Mon-Dim', 'monday', '11:30:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2229, 91, NULL, NULL, 'Mon-Dim', 'monday', '12:15:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2230, 91, NULL, NULL, 'Mon-Dim', 'monday', '13:00:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2231, 91, NULL, NULL, 'Mon-Dim', 'monday', '13:45:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2232, 91, NULL, NULL, 'Mon-Dim', 'sunday', '07:00:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2233, 91, NULL, NULL, 'Mon-Dim', 'sunday', '07:45:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2234, 91, NULL, NULL, 'Mon-Dim', 'sunday', '08:30:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2235, 91, NULL, NULL, 'Mon-Dim', 'sunday', '09:15:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2236, 91, NULL, NULL, 'Mon-Dim', 'sunday', '10:00:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2237, 91, NULL, NULL, 'Mon-Dim', 'sunday', '10:45:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2238, 91, NULL, NULL, 'Mon-Dim', 'sunday', '11:30:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2239, 91, NULL, NULL, 'Mon-Dim', 'sunday', '12:15:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2240, 91, NULL, NULL, 'Mon-Dim', 'sunday', '13:00:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2241, 91, NULL, NULL, 'Mon-Dim', 'sunday', '13:45:00', 24, '2024-08-05 00:13:12', '2024-08-05 00:13:12'),
(2242, 92, NULL, NULL, 'Lun-Dim', 'friday', '12:00:00', 24, '2024-08-05 00:14:25', '2024-08-05 00:14:25'),
(2243, 92, NULL, NULL, 'Lun-Dim', 'friday', '12:35:00', 24, '2024-08-05 00:14:25', '2024-08-05 00:14:25'),
(2244, 92, NULL, NULL, 'Lun-Dim', 'friday', '13:10:00', 24, '2024-08-05 00:14:25', '2024-08-05 00:14:25'),
(2245, 92, NULL, NULL, 'Lun-Dim', 'saturday', '12:00:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2246, 92, NULL, NULL, 'Lun-Dim', 'saturday', '12:35:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2247, 92, NULL, NULL, 'Lun-Dim', 'friday', '13:45:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2248, 92, NULL, NULL, 'Lun-Dim', 'friday', '14:20:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2249, 92, NULL, NULL, 'Lun-Dim', 'saturday', '13:10:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2250, 92, NULL, NULL, 'Lun-Dim', 'friday', '14:55:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2251, 92, NULL, NULL, 'Lun-Dim', 'friday', '15:30:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2252, 92, NULL, NULL, 'Lun-Dim', 'saturday', '13:45:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2253, 92, NULL, NULL, 'Lun-Dim', 'friday', '16:05:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2254, 92, NULL, NULL, 'Lun-Dim', 'saturday', '14:20:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2255, 92, NULL, NULL, 'Lun-Dim', 'friday', '16:40:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2256, 92, NULL, NULL, 'Lun-Dim', 'saturday', '14:55:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2257, 92, NULL, NULL, 'Lun-Dim', 'friday', '17:15:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26');
INSERT INTO `restaurant_business_hours` (`id`, `restaurant_id`, `country`, `city`, `shift_name`, `day_of_week`, `slot_time`, `added_by`, `created_at`, `updated_at`) VALUES
(2258, 92, NULL, NULL, 'Lun-Dim', 'saturday', '15:30:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2259, 92, NULL, NULL, 'Lun-Dim', 'saturday', '16:05:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2260, 92, NULL, NULL, 'Lun-Dim', 'friday', '17:50:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2261, 92, NULL, NULL, 'Lun-Dim', 'saturday', '16:40:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2262, 92, NULL, NULL, 'Lun-Dim', 'saturday', '17:15:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2263, 92, NULL, NULL, 'Lun-Dim', 'friday', '18:25:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2264, 92, NULL, NULL, 'Lun-Dim', 'thursday', '12:00:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2265, 92, NULL, NULL, 'Lun-Dim', 'saturday', '17:50:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2266, 92, NULL, NULL, 'Lun-Dim', 'friday', '19:00:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2267, 92, NULL, NULL, 'Lun-Dim', 'saturday', '18:25:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2268, 92, NULL, NULL, 'Lun-Dim', 'thursday', '12:35:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2269, 92, NULL, NULL, 'Lun-Dim', 'friday', '19:35:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2270, 92, NULL, NULL, 'Lun-Dim', 'saturday', '19:00:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2271, 92, NULL, NULL, 'Lun-Dim', 'thursday', '13:10:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2272, 92, NULL, NULL, 'Lun-Dim', 'friday', '20:10:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2273, 92, NULL, NULL, 'Lun-Dim', 'saturday', '19:35:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2274, 92, NULL, NULL, 'Lun-Dim', 'friday', '20:45:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2275, 92, NULL, NULL, 'Lun-Dim', 'saturday', '20:10:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2276, 92, NULL, NULL, 'Lun-Dim', 'friday', '21:20:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2277, 92, NULL, NULL, 'Lun-Dim', 'saturday', '20:45:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2278, 92, NULL, NULL, 'Lun-Dim', 'thursday', '13:45:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2279, 92, NULL, NULL, 'Lun-Dim', 'wednesday', '12:00:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2280, 92, NULL, NULL, 'Lun-Dim', 'friday', '21:55:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2281, 92, NULL, NULL, 'Lun-Dim', 'saturday', '21:20:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2282, 92, NULL, NULL, 'Lun-Dim', 'wednesday', '12:35:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2283, 92, NULL, NULL, 'Lun-Dim', 'thursday', '14:20:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2284, 92, NULL, NULL, 'Lun-Dim', 'thursday', '14:55:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2285, 92, NULL, NULL, 'Lun-Dim', 'wednesday', '13:10:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2286, 92, NULL, NULL, 'Lun-Dim', 'saturday', '21:55:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2287, 92, NULL, NULL, 'Lun-Dim', 'friday', '22:30:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2288, 92, NULL, NULL, 'Lun-Dim', 'thursday', '15:30:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2289, 92, NULL, NULL, 'Lun-Dim', 'saturday', '22:30:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2290, 92, NULL, NULL, 'Lun-Dim', 'friday', '23:05:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2291, 92, NULL, NULL, 'Lun-Dim', 'wednesday', '13:45:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2292, 92, NULL, NULL, 'Lun-Dim', 'thursday', '16:05:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2293, 92, NULL, NULL, 'Lun-Dim', 'saturday', '23:05:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2294, 92, NULL, NULL, 'Lun-Dim', 'wednesday', '14:20:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2295, 92, NULL, NULL, 'Lun-Dim', 'friday', '23:40:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2296, 92, NULL, NULL, 'Lun-Dim', 'thursday', '16:40:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2297, 92, NULL, NULL, 'Lun-Dim', 'saturday', '23:40:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2298, 92, NULL, NULL, 'Lun-Dim', 'wednesday', '14:55:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2299, 92, NULL, NULL, 'Lun-Dim', 'thursday', '17:15:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2300, 92, NULL, NULL, 'Lun-Dim', 'wednesday', '15:30:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2301, 92, NULL, NULL, 'Lun-Dim', 'tuesday', '12:00:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2302, 92, NULL, NULL, 'Lun-Dim', 'thursday', '17:50:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2303, 92, NULL, NULL, 'Lun-Dim', 'tuesday', '12:35:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2304, 92, NULL, NULL, 'Lun-Dim', 'thursday', '18:25:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2305, 92, NULL, NULL, 'Lun-Dim', 'wednesday', '16:05:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2306, 92, NULL, NULL, 'Lun-Dim', 'thursday', '19:00:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2307, 92, NULL, NULL, 'Lun-Dim', 'wednesday', '16:40:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2308, 92, NULL, NULL, 'Lun-Dim', 'tuesday', '13:10:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2309, 92, NULL, NULL, 'Lun-Dim', 'tuesday', '13:45:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2310, 92, NULL, NULL, 'Lun-Dim', 'thursday', '19:35:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2311, 92, NULL, NULL, 'Lun-Dim', 'wednesday', '17:15:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2312, 92, NULL, NULL, 'Lun-Dim', 'wednesday', '17:50:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2313, 92, NULL, NULL, 'Lun-Dim', 'wednesday', '18:25:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2314, 92, NULL, NULL, 'Lun-Dim', 'tuesday', '14:20:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2315, 92, NULL, NULL, 'Lun-Dim', 'thursday', '20:10:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2316, 92, NULL, NULL, 'Lun-Dim', 'wednesday', '19:00:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2317, 92, NULL, NULL, 'Lun-Dim', 'thursday', '20:45:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2318, 92, NULL, NULL, 'Lun-Dim', 'wednesday', '19:35:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2319, 92, NULL, NULL, 'Lun-Dim', 'tuesday', '14:55:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2320, 92, NULL, NULL, 'Lun-Dim', 'thursday', '21:20:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2321, 92, NULL, NULL, 'Lun-Dim', 'wednesday', '20:10:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2322, 92, NULL, NULL, 'Lun-Dim', 'tuesday', '15:30:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2323, 92, NULL, NULL, 'Lun-Dim', 'thursday', '21:55:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2324, 92, NULL, NULL, 'Lun-Dim', 'wednesday', '20:45:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2325, 92, NULL, NULL, 'Lun-Dim', 'tuesday', '16:05:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2326, 92, NULL, NULL, 'Lun-Dim', 'thursday', '22:30:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2327, 92, NULL, NULL, 'Lun-Dim', 'thursday', '23:05:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2328, 92, NULL, NULL, 'Lun-Dim', 'tuesday', '16:40:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2329, 92, NULL, NULL, 'Lun-Dim', 'monday', '12:00:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2330, 92, NULL, NULL, 'Lun-Dim', 'wednesday', '21:20:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2331, 92, NULL, NULL, 'Lun-Dim', 'thursday', '23:40:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2332, 92, NULL, NULL, 'Lun-Dim', 'monday', '12:35:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2333, 92, NULL, NULL, 'Lun-Dim', 'tuesday', '17:15:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2334, 92, NULL, NULL, 'Lun-Dim', 'wednesday', '21:55:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2335, 92, NULL, NULL, 'Lun-Dim', 'wednesday', '22:30:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2336, 92, NULL, NULL, 'Lun-Dim', 'tuesday', '17:50:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2337, 92, NULL, NULL, 'Lun-Dim', 'monday', '13:10:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2338, 92, NULL, NULL, 'Lun-Dim', 'monday', '13:45:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2339, 92, NULL, NULL, 'Lun-Dim', 'tuesday', '18:25:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2340, 92, NULL, NULL, 'Lun-Dim', 'wednesday', '23:05:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2341, 92, NULL, NULL, 'Lun-Dim', 'tuesday', '19:00:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2342, 92, NULL, NULL, 'Lun-Dim', 'monday', '14:20:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2343, 92, NULL, NULL, 'Lun-Dim', 'tuesday', '19:35:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2344, 92, NULL, NULL, 'Lun-Dim', 'wednesday', '23:40:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2345, 92, NULL, NULL, 'Lun-Dim', 'monday', '14:55:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2346, 92, NULL, NULL, 'Lun-Dim', 'tuesday', '20:10:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2347, 92, NULL, NULL, 'Lun-Dim', 'monday', '15:30:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2348, 92, NULL, NULL, 'Lun-Dim', 'tuesday', '20:45:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2349, 92, NULL, NULL, 'Lun-Dim', 'monday', '16:05:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2350, 92, NULL, NULL, 'Lun-Dim', 'tuesday', '21:20:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2351, 92, NULL, NULL, 'Lun-Dim', 'monday', '16:40:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2352, 92, NULL, NULL, 'Lun-Dim', 'tuesday', '21:55:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2353, 92, NULL, NULL, 'Lun-Dim', 'monday', '17:15:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2354, 92, NULL, NULL, 'Lun-Dim', 'tuesday', '22:30:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2355, 92, NULL, NULL, 'Lun-Dim', 'monday', '17:50:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2356, 92, NULL, NULL, 'Lun-Dim', 'tuesday', '23:05:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2357, 92, NULL, NULL, 'Lun-Dim', 'monday', '18:25:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2358, 92, NULL, NULL, 'Lun-Dim', 'tuesday', '23:40:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2359, 92, NULL, NULL, 'Lun-Dim', 'monday', '19:00:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2360, 92, NULL, NULL, 'Lun-Dim', 'sunday', '12:00:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2361, 92, NULL, NULL, 'Lun-Dim', 'monday', '19:35:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2362, 92, NULL, NULL, 'Lun-Dim', 'sunday', '12:35:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2363, 92, NULL, NULL, 'Lun-Dim', 'monday', '20:10:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2364, 92, NULL, NULL, 'Lun-Dim', 'sunday', '13:10:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2365, 92, NULL, NULL, 'Lun-Dim', 'monday', '20:45:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2366, 92, NULL, NULL, 'Lun-Dim', 'sunday', '13:45:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2367, 92, NULL, NULL, 'Lun-Dim', 'monday', '21:20:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2368, 92, NULL, NULL, 'Lun-Dim', 'sunday', '14:20:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2369, 92, NULL, NULL, 'Lun-Dim', 'monday', '21:55:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2370, 92, NULL, NULL, 'Lun-Dim', 'sunday', '14:55:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2371, 92, NULL, NULL, 'Lun-Dim', 'monday', '22:30:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2372, 92, NULL, NULL, 'Lun-Dim', 'sunday', '15:30:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2373, 92, NULL, NULL, 'Lun-Dim', 'monday', '23:05:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2374, 92, NULL, NULL, 'Lun-Dim', 'sunday', '16:05:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2375, 92, NULL, NULL, 'Lun-Dim', 'monday', '23:40:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2376, 92, NULL, NULL, 'Lun-Dim', 'sunday', '16:40:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2377, 92, NULL, NULL, 'Lun-Dim', 'sunday', '17:15:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2378, 92, NULL, NULL, 'Lun-Dim', 'sunday', '17:50:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2379, 92, NULL, NULL, 'Lun-Dim', 'sunday', '18:25:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2380, 92, NULL, NULL, 'Lun-Dim', 'sunday', '19:00:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2381, 92, NULL, NULL, 'Lun-Dim', 'sunday', '19:35:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2382, 92, NULL, NULL, 'Lun-Dim', 'sunday', '20:10:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2383, 92, NULL, NULL, 'Lun-Dim', 'sunday', '20:45:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2384, 92, NULL, NULL, 'Lun-Dim', 'sunday', '21:20:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2385, 92, NULL, NULL, 'Lun-Dim', 'sunday', '21:55:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2386, 92, NULL, NULL, 'Lun-Dim', 'sunday', '22:30:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2387, 92, NULL, NULL, 'Lun-Dim', 'sunday', '23:05:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2388, 92, NULL, NULL, 'Lun-Dim', 'sunday', '23:40:00', 24, '2024-08-05 00:14:26', '2024-08-05 00:14:26'),
(2389, 106, NULL, NULL, '', 'tuesday', '07:00:00', 24, '2024-08-05 00:15:10', '2024-08-05 00:15:10'),
(2390, 106, NULL, NULL, '', 'tuesday', '07:45:00', 24, '2024-08-05 00:15:10', '2024-08-05 00:15:10'),
(2391, 106, NULL, NULL, '', 'tuesday', '08:30:00', 24, '2024-08-05 00:15:10', '2024-08-05 00:15:10'),
(2392, 106, NULL, NULL, '', 'tuesday', '09:15:00', 24, '2024-08-05 00:15:10', '2024-08-05 00:15:10'),
(2393, 106, NULL, NULL, '', 'tuesday', '10:00:00', 24, '2024-08-05 00:15:10', '2024-08-05 00:15:10'),
(2394, 106, NULL, NULL, '', 'tuesday', '10:45:00', 24, '2024-08-05 00:15:10', '2024-08-05 00:15:10'),
(2395, 106, NULL, NULL, '', 'tuesday', '11:30:00', 24, '2024-08-05 00:15:10', '2024-08-05 00:15:10'),
(2396, 106, NULL, NULL, '', 'tuesday', '12:15:00', 24, '2024-08-05 00:15:10', '2024-08-05 00:15:10'),
(2397, 106, NULL, NULL, '', 'tuesday', '13:00:00', 24, '2024-08-05 00:15:10', '2024-08-05 00:15:10'),
(2398, 106, NULL, NULL, '', 'thursday', '07:00:00', 24, '2024-08-05 00:15:10', '2024-08-05 00:15:10'),
(2399, 106, NULL, NULL, '', 'friday', '07:00:00', 24, '2024-08-05 00:15:10', '2024-08-05 00:15:10'),
(2400, 106, NULL, NULL, '', 'tuesday', '13:45:00', 24, '2024-08-05 00:15:10', '2024-08-05 00:15:10'),
(2401, 106, NULL, NULL, '', 'thursday', '07:45:00', 24, '2024-08-05 00:15:10', '2024-08-05 00:15:10'),
(2402, 106, NULL, NULL, '', 'tuesday', '14:30:00', 24, '2024-08-05 00:15:10', '2024-08-05 00:15:10'),
(2403, 106, NULL, NULL, '', 'tuesday', '15:15:00', 24, '2024-08-05 00:15:10', '2024-08-05 00:15:10'),
(2404, 106, NULL, NULL, '', 'thursday', '08:30:00', 24, '2024-08-05 00:15:10', '2024-08-05 00:15:10'),
(2405, 106, NULL, NULL, '', 'tuesday', '16:00:00', 24, '2024-08-05 00:15:10', '2024-08-05 00:15:10'),
(2406, 106, NULL, NULL, '', 'friday', '07:45:00', 24, '2024-08-05 00:15:10', '2024-08-05 00:15:10'),
(2407, 106, NULL, NULL, '', 'thursday', '09:15:00', 24, '2024-08-05 00:15:10', '2024-08-05 00:15:10'),
(2408, 106, NULL, NULL, '', 'tuesday', '16:45:00', 24, '2024-08-05 00:15:10', '2024-08-05 00:15:10'),
(2409, 106, NULL, NULL, '', 'friday', '08:30:00', 24, '2024-08-05 00:15:10', '2024-08-05 00:15:10'),
(2410, 106, NULL, NULL, '', 'tuesday', '17:30:00', 24, '2024-08-05 00:15:10', '2024-08-05 00:15:10'),
(2411, 106, NULL, NULL, '', 'friday', '09:15:00', 24, '2024-08-05 00:15:10', '2024-08-05 00:15:10'),
(2412, 106, NULL, NULL, '', 'tuesday', '18:15:00', 24, '2024-08-05 00:15:10', '2024-08-05 00:15:10'),
(2413, 106, NULL, NULL, '', 'thursday', '10:00:00', 24, '2024-08-05 00:15:10', '2024-08-05 00:15:10'),
(2414, 106, NULL, NULL, '', 'friday', '10:00:00', 24, '2024-08-05 00:15:10', '2024-08-05 00:15:10'),
(2415, 106, NULL, NULL, '', 'tuesday', '19:00:00', 24, '2024-08-05 00:15:10', '2024-08-05 00:15:10'),
(2416, 106, NULL, NULL, '', 'thursday', '10:45:00', 24, '2024-08-05 00:15:10', '2024-08-05 00:15:10'),
(2417, 106, NULL, NULL, '', 'friday', '10:45:00', 24, '2024-08-05 00:15:10', '2024-08-05 00:15:10'),
(2418, 106, NULL, NULL, '', 'tuesday', '19:45:00', 24, '2024-08-05 00:15:10', '2024-08-05 00:15:10'),
(2419, 106, NULL, NULL, '', 'thursday', '11:30:00', 24, '2024-08-05 00:15:10', '2024-08-05 00:15:10'),
(2420, 106, NULL, NULL, '', 'friday', '11:30:00', 24, '2024-08-05 00:15:10', '2024-08-05 00:15:10'),
(2421, 106, NULL, NULL, '', 'tuesday', '20:30:00', 24, '2024-08-05 00:15:10', '2024-08-05 00:15:10'),
(2422, 106, NULL, NULL, '', 'thursday', '12:15:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2423, 106, NULL, NULL, '', 'tuesday', '21:15:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2424, 106, NULL, NULL, '', 'thursday', '13:00:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2425, 106, NULL, NULL, '', 'saturday', '07:00:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2426, 106, NULL, NULL, '', 'wednesday', '07:00:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2427, 106, NULL, NULL, '', 'tuesday', '22:00:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2428, 106, NULL, NULL, '', 'wednesday', '07:45:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2429, 106, NULL, NULL, '', 'saturday', '07:45:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2430, 106, NULL, NULL, '', 'thursday', '13:45:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2431, 106, NULL, NULL, '', 'friday', '12:15:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2432, 106, NULL, NULL, '', 'tuesday', '22:45:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2433, 106, NULL, NULL, '', 'thursday', '14:30:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2434, 106, NULL, NULL, '', 'wednesday', '08:30:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2435, 106, NULL, NULL, '', 'saturday', '08:30:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2436, 106, NULL, NULL, '', 'friday', '13:00:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2437, 106, NULL, NULL, '', 'tuesday', '23:30:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2438, 106, NULL, NULL, '', 'saturday', '09:15:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2439, 106, NULL, NULL, '', 'thursday', '15:15:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2440, 106, NULL, NULL, '', 'friday', '13:45:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2441, 106, NULL, NULL, '', 'wednesday', '09:15:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2442, 106, NULL, NULL, '', 'saturday', '10:00:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2443, 106, NULL, NULL, '', 'friday', '14:30:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2444, 106, NULL, NULL, '', 'thursday', '16:00:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2445, 106, NULL, NULL, '', 'wednesday', '10:00:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2446, 106, NULL, NULL, '', 'saturday', '10:45:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2447, 106, NULL, NULL, '', 'saturday', '11:30:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2448, 106, NULL, NULL, '', 'thursday', '16:45:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2449, 106, NULL, NULL, '', 'wednesday', '10:45:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2450, 106, NULL, NULL, '', 'friday', '15:15:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2451, 106, NULL, NULL, '', 'sunday', '07:00:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2452, 106, NULL, NULL, '', 'saturday', '12:15:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2453, 106, NULL, NULL, '', 'thursday', '17:30:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2454, 106, NULL, NULL, '', 'wednesday', '11:30:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2455, 106, NULL, NULL, '', 'friday', '16:00:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2456, 106, NULL, NULL, '', 'saturday', '13:00:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2457, 106, NULL, NULL, '', 'thursday', '18:15:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2458, 106, NULL, NULL, '', 'sunday', '07:45:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2459, 106, NULL, NULL, '', 'wednesday', '12:15:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2460, 106, NULL, NULL, '', 'saturday', '13:45:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2461, 106, NULL, NULL, '', 'friday', '16:45:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2462, 106, NULL, NULL, '', 'thursday', '19:00:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2463, 106, NULL, NULL, '', 'sunday', '08:30:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2464, 106, NULL, NULL, '', 'wednesday', '13:00:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2465, 106, NULL, NULL, '', 'saturday', '14:30:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2466, 106, NULL, NULL, '', 'friday', '17:30:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2467, 106, NULL, NULL, '', 'thursday', '19:45:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2468, 106, NULL, NULL, '', 'sunday', '09:15:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2469, 106, NULL, NULL, '', 'wednesday', '13:45:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2470, 106, NULL, NULL, '', 'saturday', '15:15:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2471, 106, NULL, NULL, '', 'friday', '18:15:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2472, 106, NULL, NULL, '', 'thursday', '20:30:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2473, 106, NULL, NULL, '', 'sunday', '10:00:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2474, 106, NULL, NULL, '', 'wednesday', '14:30:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2475, 106, NULL, NULL, '', 'saturday', '16:00:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2476, 106, NULL, NULL, '', 'friday', '19:00:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2477, 106, NULL, NULL, '', 'thursday', '21:15:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2478, 106, NULL, NULL, '', 'sunday', '10:45:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2479, 106, NULL, NULL, '', 'saturday', '16:45:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2480, 106, NULL, NULL, '', 'wednesday', '15:15:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2481, 106, NULL, NULL, '', 'friday', '19:45:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2482, 106, NULL, NULL, '', 'thursday', '22:00:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2483, 106, NULL, NULL, '', 'sunday', '11:30:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2484, 106, NULL, NULL, '', 'saturday', '17:30:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2485, 106, NULL, NULL, '', 'wednesday', '16:00:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2486, 106, NULL, NULL, '', 'friday', '20:30:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2487, 106, NULL, NULL, '', 'thursday', '22:45:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2488, 106, NULL, NULL, '', 'wednesday', '16:45:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2489, 106, NULL, NULL, '', 'saturday', '18:15:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2490, 106, NULL, NULL, '', 'friday', '21:15:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2491, 106, NULL, NULL, '', 'thursday', '23:30:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2492, 106, NULL, NULL, '', 'sunday', '12:15:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2493, 106, NULL, NULL, '', 'wednesday', '17:30:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2494, 106, NULL, NULL, '', 'saturday', '19:00:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2495, 106, NULL, NULL, '', 'friday', '22:00:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2496, 106, NULL, NULL, '', 'sunday', '13:00:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2497, 106, NULL, NULL, '', 'wednesday', '18:15:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2498, 106, NULL, NULL, '', 'saturday', '19:45:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2499, 106, NULL, NULL, '', 'friday', '22:45:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2500, 106, NULL, NULL, '', 'sunday', '13:45:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2501, 106, NULL, NULL, '', 'saturday', '20:30:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2502, 106, NULL, NULL, '', 'wednesday', '19:00:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2503, 106, NULL, NULL, '', 'friday', '23:30:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2504, 106, NULL, NULL, '', 'sunday', '14:30:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2505, 106, NULL, NULL, '', 'wednesday', '19:45:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2506, 106, NULL, NULL, '', 'saturday', '21:15:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2507, 106, NULL, NULL, '', 'sunday', '15:15:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2508, 106, NULL, NULL, '', 'wednesday', '20:30:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2509, 106, NULL, NULL, '', 'saturday', '22:00:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2510, 106, NULL, NULL, '', 'monday', '07:00:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2511, 106, NULL, NULL, '', 'sunday', '16:00:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2512, 106, NULL, NULL, '', 'wednesday', '21:15:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2513, 106, NULL, NULL, '', 'saturday', '22:45:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2514, 106, NULL, NULL, '', 'monday', '07:45:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2515, 106, NULL, NULL, '', 'sunday', '16:45:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2516, 106, NULL, NULL, '', 'wednesday', '22:00:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2517, 106, NULL, NULL, '', 'saturday', '23:30:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2518, 106, NULL, NULL, '', 'monday', '08:30:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2519, 106, NULL, NULL, '', 'sunday', '17:30:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2520, 106, NULL, NULL, '', 'wednesday', '22:45:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2521, 106, NULL, NULL, '', 'monday', '09:15:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2522, 106, NULL, NULL, '', 'sunday', '18:15:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2523, 106, NULL, NULL, '', 'wednesday', '23:30:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2524, 106, NULL, NULL, '', 'monday', '10:00:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2525, 106, NULL, NULL, '', 'sunday', '19:00:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2526, 106, NULL, NULL, '', 'monday', '10:45:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2527, 106, NULL, NULL, '', 'sunday', '19:45:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2528, 106, NULL, NULL, '', 'sunday', '20:30:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2529, 106, NULL, NULL, '', 'monday', '11:30:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2530, 106, NULL, NULL, '', 'sunday', '21:15:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2531, 106, NULL, NULL, '', 'monday', '12:15:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2532, 106, NULL, NULL, '', 'sunday', '22:00:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2533, 106, NULL, NULL, '', 'monday', '13:00:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2534, 106, NULL, NULL, '', 'sunday', '22:45:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2535, 106, NULL, NULL, '', 'monday', '13:45:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2536, 106, NULL, NULL, '', 'sunday', '23:30:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2537, 106, NULL, NULL, '', 'monday', '14:30:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2538, 106, NULL, NULL, '', 'monday', '15:15:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2539, 106, NULL, NULL, '', 'monday', '16:00:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2540, 106, NULL, NULL, '', 'monday', '16:45:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2541, 106, NULL, NULL, '', 'monday', '17:30:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2542, 106, NULL, NULL, '', 'monday', '18:15:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2543, 106, NULL, NULL, '', 'monday', '19:00:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2544, 106, NULL, NULL, '', 'monday', '19:45:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2545, 106, NULL, NULL, '', 'monday', '20:30:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2546, 106, NULL, NULL, '', 'monday', '21:15:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2547, 106, NULL, NULL, '', 'monday', '22:00:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2548, 106, NULL, NULL, '', 'monday', '22:45:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2549, 106, NULL, NULL, '', 'monday', '23:30:00', 24, '2024-08-05 00:15:11', '2024-08-05 00:15:11'),
(2550, 105, NULL, NULL, '', 'tuesday', '12:00:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2551, 105, NULL, NULL, '', 'tuesday', '12:35:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2552, 105, NULL, NULL, '', 'tuesday', '13:10:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2553, 105, NULL, NULL, '', 'tuesday', '13:45:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2554, 105, NULL, NULL, '', 'tuesday', '14:20:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2555, 105, NULL, NULL, '', 'tuesday', '14:55:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2556, 105, NULL, NULL, '', 'tuesday', '15:30:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2557, 105, NULL, NULL, '', 'tuesday', '16:05:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2558, 105, NULL, NULL, '', 'monday', '12:00:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2559, 105, NULL, NULL, '', 'tuesday', '16:40:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2560, 105, NULL, NULL, '', 'monday', '12:35:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2561, 105, NULL, NULL, '', 'tuesday', '17:15:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2562, 105, NULL, NULL, '', 'monday', '13:10:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2563, 105, NULL, NULL, '', 'tuesday', '17:50:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2564, 105, NULL, NULL, '', 'monday', '13:45:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2565, 105, NULL, NULL, '', 'tuesday', '18:25:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2566, 105, NULL, NULL, '', 'monday', '14:20:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2567, 105, NULL, NULL, '', 'tuesday', '19:00:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2568, 105, NULL, NULL, '', 'monday', '14:55:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2569, 105, NULL, NULL, '', 'tuesday', '19:35:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2570, 105, NULL, NULL, '', 'monday', '15:30:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2571, 105, NULL, NULL, '', 'tuesday', '20:10:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2572, 105, NULL, NULL, '', 'monday', '16:05:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2573, 105, NULL, NULL, '', 'tuesday', '20:45:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2574, 105, NULL, NULL, '', 'monday', '16:40:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2575, 105, NULL, NULL, '', 'monday', '17:15:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2576, 105, NULL, NULL, '', 'monday', '17:50:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2577, 105, NULL, NULL, '', 'wednesday', '12:00:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2578, 105, NULL, NULL, '', 'monday', '18:25:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2579, 105, NULL, NULL, '', 'wednesday', '12:35:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2580, 105, NULL, NULL, '', 'monday', '19:00:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2581, 105, NULL, NULL, '', 'wednesday', '13:10:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2582, 105, NULL, NULL, '', 'monday', '19:35:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2583, 105, NULL, NULL, '', 'wednesday', '13:45:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2584, 105, NULL, NULL, '', 'monday', '20:10:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2585, 105, NULL, NULL, '', 'wednesday', '14:20:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2586, 105, NULL, NULL, '', 'monday', '20:45:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2587, 105, NULL, NULL, '', 'wednesday', '14:55:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2588, 105, NULL, NULL, '', 'wednesday', '15:30:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2589, 105, NULL, NULL, '', 'wednesday', '16:05:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2590, 105, NULL, NULL, '', 'wednesday', '16:40:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2591, 105, NULL, NULL, '', 'wednesday', '17:15:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2592, 105, NULL, NULL, '', 'wednesday', '17:50:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2593, 105, NULL, NULL, '', 'wednesday', '18:25:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2594, 105, NULL, NULL, '', 'wednesday', '19:00:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2595, 105, NULL, NULL, '', 'wednesday', '19:35:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2596, 105, NULL, NULL, '', 'wednesday', '20:10:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2597, 105, NULL, NULL, '', 'wednesday', '20:45:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2598, 105, NULL, NULL, '', 'sunday', '12:00:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2599, 105, NULL, NULL, '', 'sunday', '12:35:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2600, 105, NULL, NULL, '', 'sunday', '13:10:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2601, 105, NULL, NULL, '', 'sunday', '13:45:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2602, 105, NULL, NULL, '', 'sunday', '14:20:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2603, 105, NULL, NULL, '', 'sunday', '14:55:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2604, 105, NULL, NULL, '', 'sunday', '15:30:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2605, 105, NULL, NULL, '', 'sunday', '16:05:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2606, 105, NULL, NULL, '', 'sunday', '16:40:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2607, 105, NULL, NULL, '', 'sunday', '17:15:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2608, 105, NULL, NULL, '', 'sunday', '17:50:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2609, 105, NULL, NULL, '', 'sunday', '18:25:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2610, 105, NULL, NULL, '', 'sunday', '19:00:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2611, 105, NULL, NULL, '', 'sunday', '19:35:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2612, 105, NULL, NULL, '', 'sunday', '20:10:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2613, 105, NULL, NULL, '', 'sunday', '20:45:00', 24, '2024-08-05 00:15:43', '2024-08-05 00:15:43'),
(2614, 105, NULL, NULL, '', 'thursday', '12:00:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2615, 105, NULL, NULL, '', 'thursday', '12:35:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2616, 105, NULL, NULL, '', 'thursday', '13:10:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2617, 105, NULL, NULL, '', 'thursday', '13:45:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2618, 105, NULL, NULL, '', 'thursday', '14:20:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2619, 105, NULL, NULL, '', 'thursday', '14:55:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2620, 105, NULL, NULL, '', 'thursday', '15:30:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2621, 105, NULL, NULL, '', 'thursday', '16:05:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2622, 105, NULL, NULL, '', 'thursday', '16:40:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2623, 105, NULL, NULL, '', 'thursday', '17:15:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2624, 105, NULL, NULL, '', 'friday', '12:00:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2625, 105, NULL, NULL, '', 'thursday', '17:50:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2626, 105, NULL, NULL, '', 'friday', '12:35:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2627, 105, NULL, NULL, '', 'thursday', '18:25:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2628, 105, NULL, NULL, '', 'friday', '13:10:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2629, 105, NULL, NULL, '', 'thursday', '19:00:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2630, 105, NULL, NULL, '', 'friday', '13:45:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2631, 105, NULL, NULL, '', 'saturday', '12:00:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2632, 105, NULL, NULL, '', 'thursday', '19:35:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2633, 105, NULL, NULL, '', 'saturday', '12:35:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2634, 105, NULL, NULL, '', 'thursday', '20:10:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2635, 105, NULL, NULL, '', 'friday', '14:20:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2636, 105, NULL, NULL, '', 'saturday', '13:10:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2637, 105, NULL, NULL, '', 'friday', '14:55:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2638, 105, NULL, NULL, '', 'thursday', '20:45:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2639, 105, NULL, NULL, '', 'saturday', '13:45:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2640, 105, NULL, NULL, '', 'friday', '15:30:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2641, 105, NULL, NULL, '', 'saturday', '14:20:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2642, 105, NULL, NULL, '', 'friday', '16:05:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2643, 105, NULL, NULL, '', 'saturday', '14:55:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2644, 105, NULL, NULL, '', 'friday', '16:40:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2645, 105, NULL, NULL, '', 'saturday', '15:30:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2646, 105, NULL, NULL, '', 'friday', '17:15:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2647, 105, NULL, NULL, '', 'saturday', '16:05:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2648, 105, NULL, NULL, '', 'friday', '17:50:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2649, 105, NULL, NULL, '', 'saturday', '16:40:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2650, 105, NULL, NULL, '', 'friday', '18:25:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2651, 105, NULL, NULL, '', 'saturday', '17:15:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2652, 105, NULL, NULL, '', 'friday', '19:00:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2653, 105, NULL, NULL, '', 'saturday', '17:50:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2654, 105, NULL, NULL, '', 'friday', '19:35:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2655, 105, NULL, NULL, '', 'saturday', '18:25:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2656, 105, NULL, NULL, '', 'friday', '20:10:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2657, 105, NULL, NULL, '', 'saturday', '19:00:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2658, 105, NULL, NULL, '', 'friday', '20:45:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2659, 105, NULL, NULL, '', 'saturday', '19:35:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2660, 105, NULL, NULL, '', 'saturday', '20:10:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2661, 105, NULL, NULL, '', 'saturday', '20:45:00', 24, '2024-08-05 00:15:44', '2024-08-05 00:15:44'),
(2662, 104, NULL, NULL, 'Dim-Mer', 'tuesday', '19:00:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2663, 104, NULL, NULL, 'Dim-Mer', 'wednesday', '19:00:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2664, 104, NULL, NULL, 'Dim-Mer', 'tuesday', '19:35:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2665, 104, NULL, NULL, 'Dim-Mer', 'wednesday', '19:35:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2666, 104, NULL, NULL, 'Dim-Mer', 'tuesday', '20:10:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2667, 104, NULL, NULL, 'Dim-Mer', 'wednesday', '20:10:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2668, 104, NULL, NULL, 'Dim-Mer', 'tuesday', '20:45:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2669, 104, NULL, NULL, 'Dim-Mer', 'wednesday', '20:45:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2670, 104, NULL, NULL, 'Dim-Mer', 'tuesday', '21:20:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2671, 104, NULL, NULL, 'Dim-Mer', 'wednesday', '21:20:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2672, 104, NULL, NULL, 'Dim-Mer', 'tuesday', '21:55:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2673, 104, NULL, NULL, 'Dim-Mer', 'wednesday', '21:55:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2674, 104, NULL, NULL, 'Dim-Mer', 'thursday', '19:00:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2675, 104, NULL, NULL, 'Dim-Mer', 'friday', '19:00:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2676, 104, NULL, NULL, 'Dim-Mer', 'tuesday', '22:30:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2677, 104, NULL, NULL, 'Dim-Mer', 'wednesday', '22:30:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2678, 104, NULL, NULL, 'Dim-Mer', 'friday', '19:35:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2679, 104, NULL, NULL, 'Dim-Mer', 'tuesday', '23:05:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2680, 104, NULL, NULL, 'Dim-Mer', 'friday', '20:10:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2681, 104, NULL, NULL, 'Dim-Mer', 'tuesday', '23:40:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2682, 104, NULL, NULL, 'Dim-Mer', 'monday', '19:00:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2683, 104, NULL, NULL, 'Dim-Mer', 'friday', '20:45:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2684, 104, NULL, NULL, 'Dim-Mer', 'wednesday', '23:05:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2685, 104, NULL, NULL, 'Dim-Mer', 'monday', '19:35:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2686, 104, NULL, NULL, 'Dim-Mer', 'thursday', '19:35:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2687, 104, NULL, NULL, 'Dim-Mer', 'sunday', '19:00:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2688, 104, NULL, NULL, 'Dim-Mer', 'friday', '21:20:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2689, 104, NULL, NULL, 'Dim-Mer', 'thursday', '20:10:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2690, 104, NULL, NULL, 'Dim-Mer', 'sunday', '19:35:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2691, 104, NULL, NULL, 'Dim-Mer', 'wednesday', '23:40:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2692, 104, NULL, NULL, 'Dim-Mer', 'monday', '20:10:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2693, 104, NULL, NULL, 'Dim-Mer', 'friday', '21:55:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2694, 104, NULL, NULL, 'Dim-Mer', 'thursday', '20:45:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2695, 104, NULL, NULL, 'Dim-Mer', 'sunday', '20:10:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2696, 104, NULL, NULL, 'Dim-Mer', 'monday', '20:45:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2697, 104, NULL, NULL, 'Dim-Mer', 'sunday', '20:45:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2698, 104, NULL, NULL, 'Dim-Mer', 'thursday', '21:20:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2699, 104, NULL, NULL, 'Dim-Mer', 'friday', '22:30:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2700, 104, NULL, NULL, 'Dim-Mer', 'saturday', '19:00:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2701, 104, NULL, NULL, 'Dim-Mer', 'monday', '21:20:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2702, 104, NULL, NULL, 'Dim-Mer', 'friday', '23:05:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2703, 104, NULL, NULL, 'Dim-Mer', 'saturday', '19:35:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2704, 104, NULL, NULL, 'Dim-Mer', 'sunday', '21:20:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2705, 104, NULL, NULL, 'Dim-Mer', 'thursday', '21:55:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2706, 104, NULL, NULL, 'Dim-Mer', 'monday', '21:55:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2707, 104, NULL, NULL, 'Dim-Mer', 'friday', '23:40:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2708, 104, NULL, NULL, 'Dim-Mer', 'saturday', '20:10:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2709, 104, NULL, NULL, 'Dim-Mer', 'sunday', '21:55:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2710, 104, NULL, NULL, 'Dim-Mer', 'thursday', '22:30:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2711, 104, NULL, NULL, 'Dim-Mer', 'monday', '22:30:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2712, 104, NULL, NULL, 'Dim-Mer', 'sunday', '22:30:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2713, 104, NULL, NULL, 'Dim-Mer', 'saturday', '20:45:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2714, 104, NULL, NULL, 'Dim-Mer', 'thursday', '23:05:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2715, 104, NULL, NULL, 'Dim-Mer', 'monday', '23:05:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2716, 104, NULL, NULL, 'Dim-Mer', 'saturday', '21:20:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2717, 104, NULL, NULL, 'Dim-Mer', 'thursday', '23:40:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2718, 104, NULL, NULL, 'Dim-Mer', 'sunday', '23:05:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2719, 104, NULL, NULL, 'Dim-Mer', 'monday', '23:40:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2720, 104, NULL, NULL, 'Dim-Mer', 'sunday', '23:40:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2721, 104, NULL, NULL, 'Dim-Mer', 'saturday', '21:55:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2722, 104, NULL, NULL, 'Dim-Mer', 'saturday', '22:30:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2723, 104, NULL, NULL, 'Dim-Mer', 'saturday', '23:05:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2724, 104, NULL, NULL, 'Dim-Mer', 'saturday', '23:40:00', 24, '2024-08-05 00:16:21', '2024-08-05 00:16:21'),
(2725, 102, NULL, NULL, 'Lun&Dim', 'saturday', '11:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2726, 102, NULL, NULL, 'Lun&Dim', 'saturday', '12:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2727, 102, NULL, NULL, 'Lun&Dim', 'wednesday', '11:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2728, 102, NULL, NULL, 'Lun&Dim', 'saturday', '13:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2729, 102, NULL, NULL, 'Lun&Dim', 'wednesday', '12:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2730, 102, NULL, NULL, 'Lun&Dim', 'saturday', '13:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2731, 102, NULL, NULL, 'Lun&Dim', 'wednesday', '13:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2732, 102, NULL, NULL, 'Lun&Dim', 'tuesday', '11:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2733, 102, NULL, NULL, 'Lun&Dim', 'monday', '11:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2734, 102, NULL, NULL, 'Lun&Dim', 'saturday', '14:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2735, 102, NULL, NULL, 'Lun&Dim', 'monday', '12:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2736, 102, NULL, NULL, 'Lun&Dim', 'tuesday', '12:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2737, 102, NULL, NULL, 'Lun&Dim', 'wednesday', '13:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2738, 102, NULL, NULL, 'Lun&Dim', 'saturday', '15:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2739, 102, NULL, NULL, 'Lun&Dim', 'monday', '13:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2740, 102, NULL, NULL, 'Lun&Dim', 'tuesday', '13:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38');
INSERT INTO `restaurant_business_hours` (`id`, `restaurant_id`, `country`, `city`, `shift_name`, `day_of_week`, `slot_time`, `added_by`, `created_at`, `updated_at`) VALUES
(2741, 102, NULL, NULL, 'Lun&Dim', 'saturday', '15:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2742, 102, NULL, NULL, 'Lun&Dim', 'monday', '13:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2743, 102, NULL, NULL, 'Lun&Dim', 'wednesday', '14:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2744, 102, NULL, NULL, 'Lun&Dim', 'tuesday', '13:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2745, 102, NULL, NULL, 'Lun&Dim', 'wednesday', '15:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2746, 102, NULL, NULL, 'Lun&Dim', 'monday', '14:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2747, 102, NULL, NULL, 'Lun&Dim', 'saturday', '16:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2748, 102, NULL, NULL, 'Lun&Dim', 'tuesday', '14:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2749, 102, NULL, NULL, 'Lun&Dim', 'monday', '15:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2750, 102, NULL, NULL, 'Lun&Dim', 'saturday', '17:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2751, 102, NULL, NULL, 'Lun&Dim', 'tuesday', '15:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2752, 102, NULL, NULL, 'Lun&Dim', 'wednesday', '15:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2753, 102, NULL, NULL, 'Lun&Dim', 'saturday', '17:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2754, 102, NULL, NULL, 'Lun&Dim', 'monday', '15:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2755, 102, NULL, NULL, 'Lun&Dim', 'wednesday', '16:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2756, 102, NULL, NULL, 'Lun&Dim', 'tuesday', '15:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2757, 102, NULL, NULL, 'Lun&Dim', 'saturday', '18:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2758, 102, NULL, NULL, 'Lun&Dim', 'monday', '16:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2759, 102, NULL, NULL, 'Lun&Dim', 'tuesday', '16:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2760, 102, NULL, NULL, 'Lun&Dim', 'wednesday', '17:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2761, 102, NULL, NULL, 'Lun&Dim', 'saturday', '19:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2762, 102, NULL, NULL, 'Lun&Dim', 'monday', '17:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2763, 102, NULL, NULL, 'Lun&Dim', 'wednesday', '17:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2764, 102, NULL, NULL, 'Lun&Dim', 'monday', '17:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2765, 102, NULL, NULL, 'Lun&Dim', 'tuesday', '17:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2766, 102, NULL, NULL, 'Lun&Dim', 'saturday', '19:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2767, 102, NULL, NULL, 'Lun&Dim', 'wednesday', '18:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2768, 102, NULL, NULL, 'Lun&Dim', 'monday', '18:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2769, 102, NULL, NULL, 'Lun&Dim', 'tuesday', '17:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2770, 102, NULL, NULL, 'Lun&Dim', 'saturday', '20:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2771, 102, NULL, NULL, 'Lun&Dim', 'wednesday', '19:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2772, 102, NULL, NULL, 'Lun&Dim', 'monday', '19:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2773, 102, NULL, NULL, 'Lun&Dim', 'tuesday', '18:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2774, 102, NULL, NULL, 'Lun&Dim', 'saturday', '21:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2775, 102, NULL, NULL, 'Lun&Dim', 'wednesday', '19:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2776, 102, NULL, NULL, 'Lun&Dim', 'monday', '19:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2777, 102, NULL, NULL, 'Lun&Dim', 'tuesday', '19:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2778, 102, NULL, NULL, 'Lun&Dim', 'saturday', '21:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2779, 102, NULL, NULL, 'Lun&Dim', 'wednesday', '20:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2780, 102, NULL, NULL, 'Lun&Dim', 'monday', '20:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2781, 102, NULL, NULL, 'Lun&Dim', 'saturday', '22:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2782, 102, NULL, NULL, 'Lun&Dim', 'tuesday', '19:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2783, 102, NULL, NULL, 'Lun&Dim', 'wednesday', '21:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2784, 102, NULL, NULL, 'Lun&Dim', 'tuesday', '20:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2785, 102, NULL, NULL, 'Lun&Dim', 'thursday', '11:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2786, 102, NULL, NULL, 'Lun&Dim', 'tuesday', '21:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2787, 102, NULL, NULL, 'Lun&Dim', 'monday', '21:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2788, 102, NULL, NULL, 'Lun&Dim', 'wednesday', '21:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2789, 102, NULL, NULL, 'Lun&Dim', 'thursday', '12:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2790, 102, NULL, NULL, 'Lun&Dim', 'wednesday', '22:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2791, 102, NULL, NULL, 'Lun&Dim', 'tuesday', '21:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2792, 102, NULL, NULL, 'Lun&Dim', 'monday', '21:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2793, 102, NULL, NULL, 'Lun&Dim', 'thursday', '13:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2794, 102, NULL, NULL, 'Lun&Dim', 'monday', '22:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2795, 102, NULL, NULL, 'Lun&Dim', 'tuesday', '22:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2796, 102, NULL, NULL, 'Lun&Dim', 'thursday', '13:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2797, 102, NULL, NULL, 'Lun&Dim', 'thursday', '14:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2798, 102, NULL, NULL, 'Lun&Dim', 'thursday', '15:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2799, 102, NULL, NULL, 'Lun&Dim', 'thursday', '15:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2800, 102, NULL, NULL, 'Lun&Dim', 'thursday', '16:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2801, 102, NULL, NULL, 'Lun&Dim', 'thursday', '17:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2802, 102, NULL, NULL, 'Lun&Dim', 'thursday', '17:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2803, 102, NULL, NULL, 'Lun&Dim', 'thursday', '18:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2804, 102, NULL, NULL, 'Lun&Dim', 'thursday', '19:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2805, 102, NULL, NULL, 'Lun&Dim', 'thursday', '19:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2806, 102, NULL, NULL, 'Lun&Dim', 'thursday', '20:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2807, 102, NULL, NULL, 'Lun&Dim', 'thursday', '21:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2808, 102, NULL, NULL, 'Lun&Dim', 'thursday', '21:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2809, 102, NULL, NULL, 'Lun&Dim', 'thursday', '22:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2810, 102, NULL, NULL, 'Lun&Dim', 'sunday', '11:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2811, 102, NULL, NULL, 'Lun&Dim', 'sunday', '12:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2812, 102, NULL, NULL, 'Lun&Dim', 'sunday', '13:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2813, 102, NULL, NULL, 'Lun&Dim', 'sunday', '13:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2814, 102, NULL, NULL, 'Lun&Dim', 'friday', '11:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2815, 102, NULL, NULL, 'Lun&Dim', 'sunday', '14:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2816, 102, NULL, NULL, 'Lun&Dim', 'friday', '12:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2817, 102, NULL, NULL, 'Lun&Dim', 'sunday', '15:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2818, 102, NULL, NULL, 'Lun&Dim', 'friday', '13:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2819, 102, NULL, NULL, 'Lun&Dim', 'sunday', '15:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2820, 102, NULL, NULL, 'Lun&Dim', 'friday', '13:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2821, 102, NULL, NULL, 'Lun&Dim', 'sunday', '16:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2822, 102, NULL, NULL, 'Lun&Dim', 'friday', '14:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2823, 102, NULL, NULL, 'Lun&Dim', 'sunday', '17:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2824, 102, NULL, NULL, 'Lun&Dim', 'friday', '15:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2825, 102, NULL, NULL, 'Lun&Dim', 'sunday', '17:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2826, 102, NULL, NULL, 'Lun&Dim', 'friday', '15:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2827, 102, NULL, NULL, 'Lun&Dim', 'sunday', '18:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2828, 102, NULL, NULL, 'Lun&Dim', 'friday', '16:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2829, 102, NULL, NULL, 'Lun&Dim', 'sunday', '19:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2830, 102, NULL, NULL, 'Lun&Dim', 'friday', '17:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2831, 102, NULL, NULL, 'Lun&Dim', 'sunday', '19:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2832, 102, NULL, NULL, 'Lun&Dim', 'friday', '17:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2833, 102, NULL, NULL, 'Lun&Dim', 'sunday', '20:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2834, 102, NULL, NULL, 'Lun&Dim', 'friday', '18:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2835, 102, NULL, NULL, 'Lun&Dim', 'sunday', '21:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2836, 102, NULL, NULL, 'Lun&Dim', 'friday', '19:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2837, 102, NULL, NULL, 'Lun&Dim', 'sunday', '21:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2838, 102, NULL, NULL, 'Lun&Dim', 'friday', '19:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2839, 102, NULL, NULL, 'Lun&Dim', 'sunday', '22:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2840, 102, NULL, NULL, 'Lun&Dim', 'friday', '20:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2841, 102, NULL, NULL, 'Lun&Dim', 'friday', '21:05:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2842, 102, NULL, NULL, 'Lun&Dim', 'friday', '21:45:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2843, 102, NULL, NULL, 'Lun&Dim', 'friday', '22:25:00', 24, '2024-08-05 00:17:38', '2024-08-05 00:17:38'),
(2844, 101, NULL, NULL, 'Lun-Dim', 'friday', '11:45:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2845, 101, NULL, NULL, 'Lun-Dim', 'saturday', '11:45:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2846, 101, NULL, NULL, 'Lun-Dim', 'friday', '12:30:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2847, 101, NULL, NULL, 'Lun-Dim', 'saturday', '12:30:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2848, 101, NULL, NULL, 'Lun-Dim', 'friday', '13:15:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2849, 101, NULL, NULL, 'Lun-Dim', 'saturday', '13:15:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2850, 101, NULL, NULL, 'Lun-Dim', 'friday', '14:00:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2851, 101, NULL, NULL, 'Lun-Dim', 'saturday', '14:00:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2852, 101, NULL, NULL, 'Lun-Dim', 'monday', '11:45:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2853, 101, NULL, NULL, 'Lun-Dim', 'friday', '14:45:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2854, 101, NULL, NULL, 'Lun-Dim', 'saturday', '14:45:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2855, 101, NULL, NULL, 'Lun-Dim', 'monday', '12:30:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2856, 101, NULL, NULL, 'Lun-Dim', 'friday', '15:30:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2857, 101, NULL, NULL, 'Lun-Dim', 'saturday', '15:30:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2858, 101, NULL, NULL, 'Lun-Dim', 'monday', '13:15:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2859, 101, NULL, NULL, 'Lun-Dim', 'friday', '16:15:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2860, 101, NULL, NULL, 'Lun-Dim', 'saturday', '16:15:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2861, 101, NULL, NULL, 'Lun-Dim', 'monday', '14:00:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2862, 101, NULL, NULL, 'Lun-Dim', 'friday', '17:00:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2863, 101, NULL, NULL, 'Lun-Dim', 'saturday', '17:00:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2864, 101, NULL, NULL, 'Lun-Dim', 'monday', '14:45:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2865, 101, NULL, NULL, 'Lun-Dim', 'friday', '17:45:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2866, 101, NULL, NULL, 'Lun-Dim', 'saturday', '17:45:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2867, 101, NULL, NULL, 'Lun-Dim', 'monday', '15:30:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2868, 101, NULL, NULL, 'Lun-Dim', 'saturday', '18:30:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2869, 101, NULL, NULL, 'Lun-Dim', 'friday', '18:30:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2870, 101, NULL, NULL, 'Lun-Dim', 'monday', '16:15:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2871, 101, NULL, NULL, 'Lun-Dim', 'saturday', '19:15:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2872, 101, NULL, NULL, 'Lun-Dim', 'friday', '19:15:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2873, 101, NULL, NULL, 'Lun-Dim', 'monday', '17:00:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2874, 101, NULL, NULL, 'Lun-Dim', 'saturday', '20:00:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2875, 101, NULL, NULL, 'Lun-Dim', 'friday', '20:00:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2876, 101, NULL, NULL, 'Lun-Dim', 'monday', '17:45:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2877, 101, NULL, NULL, 'Lun-Dim', 'saturday', '20:45:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2878, 101, NULL, NULL, 'Lun-Dim', 'friday', '20:45:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2879, 101, NULL, NULL, 'Lun-Dim', 'monday', '18:30:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2880, 101, NULL, NULL, 'Lun-Dim', 'saturday', '21:30:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2881, 101, NULL, NULL, 'Lun-Dim', 'friday', '21:30:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2882, 101, NULL, NULL, 'Lun-Dim', 'monday', '19:15:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2883, 101, NULL, NULL, 'Lun-Dim', 'saturday', '22:15:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2884, 101, NULL, NULL, 'Lun-Dim', 'friday', '22:15:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2885, 101, NULL, NULL, 'Lun-Dim', 'monday', '20:00:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2886, 101, NULL, NULL, 'Lun-Dim', 'saturday', '23:00:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2887, 101, NULL, NULL, 'Lun-Dim', 'friday', '23:00:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2888, 101, NULL, NULL, 'Lun-Dim', 'monday', '20:45:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2889, 101, NULL, NULL, 'Lun-Dim', 'monday', '21:30:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2890, 101, NULL, NULL, 'Lun-Dim', 'monday', '22:15:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2891, 101, NULL, NULL, 'Lun-Dim', 'monday', '23:00:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2892, 101, NULL, NULL, 'Lun-Dim', 'thursday', '11:45:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2893, 101, NULL, NULL, 'Lun-Dim', 'thursday', '12:30:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2894, 101, NULL, NULL, 'Lun-Dim', 'thursday', '13:15:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2895, 101, NULL, NULL, 'Lun-Dim', 'thursday', '14:00:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2896, 101, NULL, NULL, 'Lun-Dim', 'thursday', '14:45:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2897, 101, NULL, NULL, 'Lun-Dim', 'thursday', '15:30:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2898, 101, NULL, NULL, 'Lun-Dim', 'thursday', '16:15:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2899, 101, NULL, NULL, 'Lun-Dim', 'thursday', '17:00:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2900, 101, NULL, NULL, 'Lun-Dim', 'thursday', '17:45:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2901, 101, NULL, NULL, 'Lun-Dim', 'thursday', '18:30:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2902, 101, NULL, NULL, 'Lun-Dim', 'tuesday', '11:45:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2903, 101, NULL, NULL, 'Lun-Dim', 'thursday', '19:15:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2904, 101, NULL, NULL, 'Lun-Dim', 'wednesday', '11:45:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2905, 101, NULL, NULL, 'Lun-Dim', 'tuesday', '12:30:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2906, 101, NULL, NULL, 'Lun-Dim', 'thursday', '20:00:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2907, 101, NULL, NULL, 'Lun-Dim', 'wednesday', '12:30:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2908, 101, NULL, NULL, 'Lun-Dim', 'tuesday', '13:15:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2909, 101, NULL, NULL, 'Lun-Dim', 'thursday', '20:45:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2910, 101, NULL, NULL, 'Lun-Dim', 'tuesday', '14:00:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2911, 101, NULL, NULL, 'Lun-Dim', 'thursday', '21:30:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2912, 101, NULL, NULL, 'Lun-Dim', 'sunday', '11:45:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2913, 101, NULL, NULL, 'Lun-Dim', 'wednesday', '13:15:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2914, 101, NULL, NULL, 'Lun-Dim', 'tuesday', '14:45:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2915, 101, NULL, NULL, 'Lun-Dim', 'thursday', '22:15:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2916, 101, NULL, NULL, 'Lun-Dim', 'wednesday', '14:00:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2917, 101, NULL, NULL, 'Lun-Dim', 'tuesday', '15:30:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2918, 101, NULL, NULL, 'Lun-Dim', 'thursday', '23:00:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2919, 101, NULL, NULL, 'Lun-Dim', 'wednesday', '14:45:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2920, 101, NULL, NULL, 'Lun-Dim', 'tuesday', '16:15:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2921, 101, NULL, NULL, 'Lun-Dim', 'sunday', '12:30:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2922, 101, NULL, NULL, 'Lun-Dim', 'wednesday', '15:30:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2923, 101, NULL, NULL, 'Lun-Dim', 'sunday', '13:15:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2924, 101, NULL, NULL, 'Lun-Dim', 'tuesday', '17:00:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2925, 101, NULL, NULL, 'Lun-Dim', 'wednesday', '16:15:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2926, 101, NULL, NULL, 'Lun-Dim', 'sunday', '14:00:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2927, 101, NULL, NULL, 'Lun-Dim', 'sunday', '14:45:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2928, 101, NULL, NULL, 'Lun-Dim', 'wednesday', '17:00:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2929, 101, NULL, NULL, 'Lun-Dim', 'tuesday', '17:45:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2930, 101, NULL, NULL, 'Lun-Dim', 'sunday', '15:30:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2931, 101, NULL, NULL, 'Lun-Dim', 'tuesday', '18:30:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2932, 101, NULL, NULL, 'Lun-Dim', 'sunday', '16:15:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2933, 101, NULL, NULL, 'Lun-Dim', 'wednesday', '17:45:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2934, 101, NULL, NULL, 'Lun-Dim', 'tuesday', '19:15:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2935, 101, NULL, NULL, 'Lun-Dim', 'wednesday', '18:30:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2936, 101, NULL, NULL, 'Lun-Dim', 'sunday', '17:00:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2937, 101, NULL, NULL, 'Lun-Dim', 'tuesday', '20:00:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2938, 101, NULL, NULL, 'Lun-Dim', 'wednesday', '19:15:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2939, 101, NULL, NULL, 'Lun-Dim', 'sunday', '17:45:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2940, 101, NULL, NULL, 'Lun-Dim', 'tuesday', '20:45:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2941, 101, NULL, NULL, 'Lun-Dim', 'wednesday', '20:00:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2942, 101, NULL, NULL, 'Lun-Dim', 'sunday', '18:30:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2943, 101, NULL, NULL, 'Lun-Dim', 'wednesday', '20:45:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2944, 101, NULL, NULL, 'Lun-Dim', 'tuesday', '21:30:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2945, 101, NULL, NULL, 'Lun-Dim', 'sunday', '19:15:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2946, 101, NULL, NULL, 'Lun-Dim', 'wednesday', '21:30:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2947, 101, NULL, NULL, 'Lun-Dim', 'tuesday', '22:15:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2948, 101, NULL, NULL, 'Lun-Dim', 'sunday', '20:00:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2949, 101, NULL, NULL, 'Lun-Dim', 'wednesday', '22:15:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2950, 101, NULL, NULL, 'Lun-Dim', 'sunday', '20:45:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2951, 101, NULL, NULL, 'Lun-Dim', 'tuesday', '23:00:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2952, 101, NULL, NULL, 'Lun-Dim', 'wednesday', '23:00:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2953, 101, NULL, NULL, 'Lun-Dim', 'sunday', '21:30:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2954, 101, NULL, NULL, 'Lun-Dim', 'sunday', '22:15:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2955, 101, NULL, NULL, 'Lun-Dim', 'sunday', '23:00:00', 24, '2024-08-05 00:18:35', '2024-08-05 00:18:35'),
(2956, 100, NULL, NULL, 'All Day', 'thursday', '09:00:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2957, 100, NULL, NULL, 'All Day', 'thursday', '09:45:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2958, 100, NULL, NULL, 'All Day', 'thursday', '10:30:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2959, 100, NULL, NULL, 'All Day', 'thursday', '11:15:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2960, 100, NULL, NULL, 'All Day', 'thursday', '12:00:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2961, 100, NULL, NULL, 'All Day', 'thursday', '12:45:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2962, 100, NULL, NULL, 'All Day', 'thursday', '13:30:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2963, 100, NULL, NULL, 'All Day', 'thursday', '14:15:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2964, 100, NULL, NULL, 'All Day', 'thursday', '15:00:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2965, 100, NULL, NULL, 'All Day', 'thursday', '15:45:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2966, 100, NULL, NULL, 'All Day', 'friday', '09:00:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2967, 100, NULL, NULL, 'All Day', 'friday', '09:45:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2968, 100, NULL, NULL, 'All Day', 'thursday', '16:30:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2969, 100, NULL, NULL, 'All Day', 'friday', '10:30:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2970, 100, NULL, NULL, 'All Day', 'thursday', '17:15:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2971, 100, NULL, NULL, 'All Day', 'friday', '11:15:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2972, 100, NULL, NULL, 'All Day', 'wednesday', '09:00:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2973, 100, NULL, NULL, 'All Day', 'thursday', '18:00:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2974, 100, NULL, NULL, 'All Day', 'thursday', '18:45:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2975, 100, NULL, NULL, 'All Day', 'wednesday', '09:45:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2976, 100, NULL, NULL, 'All Day', 'thursday', '19:30:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2977, 100, NULL, NULL, 'All Day', 'wednesday', '10:30:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2978, 100, NULL, NULL, 'All Day', 'thursday', '20:15:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2979, 100, NULL, NULL, 'All Day', 'wednesday', '11:15:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2980, 100, NULL, NULL, 'All Day', 'friday', '12:00:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2981, 100, NULL, NULL, 'All Day', 'thursday', '21:00:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2982, 100, NULL, NULL, 'All Day', 'wednesday', '12:00:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2983, 100, NULL, NULL, 'All Day', 'monday', '09:00:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2984, 100, NULL, NULL, 'All Day', 'friday', '12:45:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2985, 100, NULL, NULL, 'All Day', 'friday', '13:30:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2986, 100, NULL, NULL, 'All Day', 'tuesday', '09:00:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2987, 100, NULL, NULL, 'All Day', 'monday', '09:45:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2988, 100, NULL, NULL, 'All Day', 'wednesday', '12:45:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2989, 100, NULL, NULL, 'All Day', 'thursday', '21:45:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2990, 100, NULL, NULL, 'All Day', 'friday', '14:15:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2991, 100, NULL, NULL, 'All Day', 'monday', '10:30:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2992, 100, NULL, NULL, 'All Day', 'thursday', '22:30:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2993, 100, NULL, NULL, 'All Day', 'wednesday', '13:30:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2994, 100, NULL, NULL, 'All Day', 'tuesday', '09:45:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2995, 100, NULL, NULL, 'All Day', 'friday', '15:00:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2996, 100, NULL, NULL, 'All Day', 'monday', '11:15:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2997, 100, NULL, NULL, 'All Day', 'wednesday', '14:15:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2998, 100, NULL, NULL, 'All Day', 'thursday', '23:15:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(2999, 100, NULL, NULL, 'All Day', 'tuesday', '10:30:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(3000, 100, NULL, NULL, 'All Day', 'friday', '15:45:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(3001, 100, NULL, NULL, 'All Day', 'monday', '12:00:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(3002, 100, NULL, NULL, 'All Day', 'wednesday', '15:00:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(3003, 100, NULL, NULL, 'All Day', 'friday', '16:30:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(3004, 100, NULL, NULL, 'All Day', 'thursday', '24:00:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(3005, 100, NULL, NULL, 'All Day', 'monday', '12:45:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(3006, 100, NULL, NULL, 'All Day', 'wednesday', '15:45:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(3007, 100, NULL, NULL, 'All Day', 'friday', '17:15:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(3008, 100, NULL, NULL, 'All Day', 'saturday', '09:00:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(3009, 100, NULL, NULL, 'All Day', 'monday', '13:30:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3010, 100, NULL, NULL, 'All Day', 'friday', '18:00:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3011, 100, NULL, NULL, 'All Day', 'saturday', '09:45:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3012, 100, NULL, NULL, 'All Day', 'monday', '14:15:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3013, 100, NULL, NULL, 'All Day', 'friday', '18:45:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3014, 100, NULL, NULL, 'All Day', 'monday', '15:00:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3015, 100, NULL, NULL, 'All Day', 'saturday', '10:30:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3016, 100, NULL, NULL, 'All Day', 'friday', '19:30:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3017, 100, NULL, NULL, 'All Day', 'monday', '15:45:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3018, 100, NULL, NULL, 'All Day', 'tuesday', '11:15:00', 24, '2024-08-05 00:19:20', '2024-08-05 00:19:20'),
(3019, 100, NULL, NULL, 'All Day', 'saturday', '11:15:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3020, 100, NULL, NULL, 'All Day', 'friday', '20:15:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3021, 100, NULL, NULL, 'All Day', 'wednesday', '16:30:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3022, 100, NULL, NULL, 'All Day', 'monday', '16:30:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3023, 100, NULL, NULL, 'All Day', 'tuesday', '12:00:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3024, 100, NULL, NULL, 'All Day', 'friday', '21:00:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3025, 100, NULL, NULL, 'All Day', 'wednesday', '17:15:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3026, 100, NULL, NULL, 'All Day', 'saturday', '12:00:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3027, 100, NULL, NULL, 'All Day', 'monday', '17:15:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3028, 100, NULL, NULL, 'All Day', 'wednesday', '18:00:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3029, 100, NULL, NULL, 'All Day', 'saturday', '12:45:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3030, 100, NULL, NULL, 'All Day', 'friday', '21:45:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3031, 100, NULL, NULL, 'All Day', 'tuesday', '12:45:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3032, 100, NULL, NULL, 'All Day', 'monday', '18:00:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3033, 100, NULL, NULL, 'All Day', 'tuesday', '13:30:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3034, 100, NULL, NULL, 'All Day', 'wednesday', '18:45:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3035, 100, NULL, NULL, 'All Day', 'saturday', '13:30:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3036, 100, NULL, NULL, 'All Day', 'friday', '22:30:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3037, 100, NULL, NULL, 'All Day', 'monday', '18:45:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3038, 100, NULL, NULL, 'All Day', 'tuesday', '14:15:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3039, 100, NULL, NULL, 'All Day', 'saturday', '14:15:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3040, 100, NULL, NULL, 'All Day', 'wednesday', '19:30:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3041, 100, NULL, NULL, 'All Day', 'monday', '19:30:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3042, 100, NULL, NULL, 'All Day', 'wednesday', '20:15:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3043, 100, NULL, NULL, 'All Day', 'friday', '23:15:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3044, 100, NULL, NULL, 'All Day', 'tuesday', '15:00:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3045, 100, NULL, NULL, 'All Day', 'saturday', '15:00:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3046, 100, NULL, NULL, 'All Day', 'monday', '20:15:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3047, 100, NULL, NULL, 'All Day', 'wednesday', '21:00:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3048, 100, NULL, NULL, 'All Day', 'friday', '24:00:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3049, 100, NULL, NULL, 'All Day', 'tuesday', '15:45:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3050, 100, NULL, NULL, 'All Day', 'wednesday', '21:45:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3051, 100, NULL, NULL, 'All Day', 'saturday', '15:45:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3052, 100, NULL, NULL, 'All Day', 'monday', '21:00:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3053, 100, NULL, NULL, 'All Day', 'tuesday', '16:30:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3054, 100, NULL, NULL, 'All Day', 'monday', '21:45:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3055, 100, NULL, NULL, 'All Day', 'wednesday', '22:30:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3056, 100, NULL, NULL, 'All Day', 'saturday', '16:30:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3057, 100, NULL, NULL, 'All Day', 'tuesday', '17:15:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3058, 100, NULL, NULL, 'All Day', 'monday', '22:30:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3059, 100, NULL, NULL, 'All Day', 'wednesday', '23:15:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3060, 100, NULL, NULL, 'All Day', 'saturday', '17:15:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3061, 100, NULL, NULL, 'All Day', 'tuesday', '18:00:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3062, 100, NULL, NULL, 'All Day', 'wednesday', '24:00:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3063, 100, NULL, NULL, 'All Day', 'saturday', '18:00:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3064, 100, NULL, NULL, 'All Day', 'tuesday', '18:45:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3065, 100, NULL, NULL, 'All Day', 'monday', '23:15:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3066, 100, NULL, NULL, 'All Day', 'sunday', '09:00:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3067, 100, NULL, NULL, 'All Day', 'monday', '24:00:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3068, 100, NULL, NULL, 'All Day', 'tuesday', '19:30:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3069, 100, NULL, NULL, 'All Day', 'saturday', '18:45:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3070, 100, NULL, NULL, 'All Day', 'sunday', '09:45:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3071, 100, NULL, NULL, 'All Day', 'tuesday', '20:15:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3072, 100, NULL, NULL, 'All Day', 'saturday', '19:30:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3073, 100, NULL, NULL, 'All Day', 'sunday', '10:30:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3074, 100, NULL, NULL, 'All Day', 'saturday', '20:15:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3075, 100, NULL, NULL, 'All Day', 'tuesday', '21:00:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3076, 100, NULL, NULL, 'All Day', 'sunday', '11:15:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3077, 100, NULL, NULL, 'All Day', 'saturday', '21:00:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3078, 100, NULL, NULL, 'All Day', 'tuesday', '21:45:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3079, 100, NULL, NULL, 'All Day', 'saturday', '21:45:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3080, 100, NULL, NULL, 'All Day', 'sunday', '12:00:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3081, 100, NULL, NULL, 'All Day', 'tuesday', '22:30:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3082, 100, NULL, NULL, 'All Day', 'sunday', '12:45:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3083, 100, NULL, NULL, 'All Day', 'saturday', '22:30:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3084, 100, NULL, NULL, 'All Day', 'tuesday', '23:15:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3085, 100, NULL, NULL, 'All Day', 'sunday', '13:30:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3086, 100, NULL, NULL, 'All Day', 'tuesday', '24:00:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3087, 100, NULL, NULL, 'All Day', 'sunday', '14:15:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3088, 100, NULL, NULL, 'All Day', 'sunday', '15:00:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3089, 100, NULL, NULL, 'All Day', 'sunday', '15:45:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3090, 100, NULL, NULL, 'All Day', 'sunday', '16:30:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3091, 100, NULL, NULL, 'All Day', 'sunday', '17:15:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3092, 100, NULL, NULL, 'All Day', 'saturday', '23:15:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3093, 100, NULL, NULL, 'All Day', 'sunday', '18:00:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3094, 100, NULL, NULL, 'All Day', 'saturday', '24:00:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3095, 100, NULL, NULL, 'All Day', 'sunday', '18:45:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3096, 100, NULL, NULL, 'All Day', 'sunday', '19:30:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3097, 100, NULL, NULL, 'All Day', 'sunday', '20:15:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3098, 100, NULL, NULL, 'All Day', 'sunday', '21:00:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3099, 100, NULL, NULL, 'All Day', 'sunday', '21:45:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3100, 100, NULL, NULL, 'All Day', 'sunday', '22:30:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3101, 100, NULL, NULL, 'All Day', 'sunday', '23:15:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3102, 100, NULL, NULL, 'All Day', 'sunday', '24:00:00', 24, '2024-08-05 00:19:21', '2024-08-05 00:19:21'),
(3103, 99, NULL, NULL, 'Mar-Dim', 'tuesday', '17:00:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3104, 99, NULL, NULL, 'Mar-Dim', 'tuesday', '17:45:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3105, 99, NULL, NULL, 'Mar-Dim', 'tuesday', '18:30:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3106, 99, NULL, NULL, 'Mar-Dim', 'tuesday', '19:15:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3107, 99, NULL, NULL, 'Mar-Dim', 'tuesday', '20:00:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3108, 99, NULL, NULL, 'Mar-Dim', 'tuesday', '20:45:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3109, 99, NULL, NULL, 'Mar-Dim', 'thursday', '17:00:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3110, 99, NULL, NULL, 'Mar-Dim', 'monday', '17:00:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3111, 99, NULL, NULL, 'Mar-Dim', 'sunday', '17:00:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3112, 99, NULL, NULL, 'Mar-Dim', 'sunday', '17:45:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3113, 99, NULL, NULL, 'Mar-Dim', 'thursday', '17:45:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3114, 99, NULL, NULL, 'Mar-Dim', 'monday', '17:45:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3115, 99, NULL, NULL, 'Mar-Dim', 'tuesday', '21:30:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3116, 99, NULL, NULL, 'Mar-Dim', 'sunday', '18:30:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3117, 99, NULL, NULL, 'Mar-Dim', 'monday', '18:30:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3118, 99, NULL, NULL, 'Mar-Dim', 'sunday', '19:15:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3119, 99, NULL, NULL, 'Mar-Dim', 'monday', '19:15:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3120, 99, NULL, NULL, 'Mar-Dim', 'sunday', '20:00:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3121, 99, NULL, NULL, 'Mar-Dim', 'thursday', '18:30:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3122, 99, NULL, NULL, 'Mar-Dim', 'monday', '20:00:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3123, 99, NULL, NULL, 'Mar-Dim', 'sunday', '20:45:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3124, 99, NULL, NULL, 'Mar-Dim', 'thursday', '19:15:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3125, 99, NULL, NULL, 'Mar-Dim', 'monday', '20:45:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3126, 99, NULL, NULL, 'Mar-Dim', 'sunday', '21:30:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3127, 99, NULL, NULL, 'Mar-Dim', 'thursday', '20:00:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3128, 99, NULL, NULL, 'Mar-Dim', 'wednesday', '17:00:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3129, 99, NULL, NULL, 'Mar-Dim', 'monday', '21:30:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3130, 99, NULL, NULL, 'Mar-Dim', 'thursday', '20:45:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3131, 99, NULL, NULL, 'Mar-Dim', 'thursday', '21:30:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3132, 99, NULL, NULL, 'Mar-Dim', 'friday', '17:00:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3133, 99, NULL, NULL, 'Mar-Dim', 'friday', '17:45:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3134, 99, NULL, NULL, 'Mar-Dim', 'wednesday', '17:45:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3135, 99, NULL, NULL, 'Mar-Dim', 'friday', '18:30:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3136, 99, NULL, NULL, 'Mar-Dim', 'saturday', '17:00:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3137, 99, NULL, NULL, 'Mar-Dim', 'wednesday', '18:30:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3138, 99, NULL, NULL, 'Mar-Dim', 'saturday', '17:45:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3139, 99, NULL, NULL, 'Mar-Dim', 'friday', '19:15:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3140, 99, NULL, NULL, 'Mar-Dim', 'wednesday', '19:15:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3141, 99, NULL, NULL, 'Mar-Dim', 'saturday', '18:30:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3142, 99, NULL, NULL, 'Mar-Dim', 'friday', '20:00:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3143, 99, NULL, NULL, 'Mar-Dim', 'wednesday', '20:00:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3144, 99, NULL, NULL, 'Mar-Dim', 'saturday', '19:15:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3145, 99, NULL, NULL, 'Mar-Dim', 'friday', '20:45:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3146, 99, NULL, NULL, 'Mar-Dim', 'wednesday', '20:45:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3147, 99, NULL, NULL, 'Mar-Dim', 'saturday', '20:00:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3148, 99, NULL, NULL, 'Mar-Dim', 'friday', '21:30:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3149, 99, NULL, NULL, 'Mar-Dim', 'wednesday', '21:30:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3150, 99, NULL, NULL, 'Mar-Dim', 'saturday', '20:45:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3151, 99, NULL, NULL, 'Mar-Dim', 'saturday', '21:30:00', 24, '2024-08-05 00:20:00', '2024-08-05 00:20:00'),
(3152, 108, NULL, NULL, '', 'tuesday', '09:00:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3154, 108, NULL, NULL, '', 'tuesday', '10:30:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3155, 108, NULL, NULL, '', 'tuesday', '11:15:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3156, 108, NULL, NULL, '', 'tuesday', '12:00:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3157, 108, NULL, NULL, '', 'tuesday', '12:45:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3158, 108, NULL, NULL, '', 'tuesday', '13:30:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3159, 108, NULL, NULL, '', 'tuesday', '14:15:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3160, 108, NULL, NULL, '', 'tuesday', '15:00:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3161, 108, NULL, NULL, '', 'tuesday', '15:45:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3162, 108, NULL, NULL, '', 'tuesday', '16:30:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3163, 108, NULL, NULL, '', 'tuesday', '17:15:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3164, 108, NULL, NULL, '', 'monday', '09:00:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3165, 108, NULL, NULL, '', 'tuesday', '18:00:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3166, 108, NULL, NULL, '', 'monday', '09:45:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3167, 108, NULL, NULL, '', 'tuesday', '18:45:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3168, 108, NULL, NULL, '', 'monday', '10:30:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3169, 108, NULL, NULL, '', 'tuesday', '19:30:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3170, 108, NULL, NULL, '', 'monday', '11:15:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3171, 108, NULL, NULL, '', 'monday', '12:00:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3172, 108, NULL, NULL, '', 'monday', '12:45:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3173, 108, NULL, NULL, '', 'monday', '13:30:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3174, 108, NULL, NULL, '', 'thursday', '09:00:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3175, 108, NULL, NULL, '', 'monday', '14:15:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3176, 108, NULL, NULL, '', 'thursday', '09:45:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3177, 108, NULL, NULL, '', 'monday', '15:00:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3178, 108, NULL, NULL, '', 'thursday', '10:30:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3179, 108, NULL, NULL, '', 'monday', '15:45:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3180, 108, NULL, NULL, '', 'thursday', '11:15:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3181, 108, NULL, NULL, '', 'monday', '16:30:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3182, 108, NULL, NULL, '', 'thursday', '12:00:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3183, 108, NULL, NULL, '', 'monday', '17:15:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3184, 108, NULL, NULL, '', 'thursday', '12:45:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3185, 108, NULL, NULL, '', 'monday', '18:00:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3186, 108, NULL, NULL, '', 'thursday', '13:30:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3187, 108, NULL, NULL, '', 'monday', '18:45:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3188, 108, NULL, NULL, '', 'thursday', '14:15:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3189, 108, NULL, NULL, '', 'monday', '19:30:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3190, 108, NULL, NULL, '', 'thursday', '15:00:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3191, 108, NULL, NULL, '', 'thursday', '15:45:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3192, 108, NULL, NULL, '', 'thursday', '16:30:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3193, 108, NULL, NULL, '', 'thursday', '17:15:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3194, 108, NULL, NULL, '', 'thursday', '18:00:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3195, 108, NULL, NULL, '', 'thursday', '18:45:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3196, 108, NULL, NULL, '', 'thursday', '19:30:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3197, 108, NULL, NULL, '', 'wednesday', '09:00:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3198, 108, NULL, NULL, '', 'wednesday', '09:45:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3199, 108, NULL, NULL, '', 'wednesday', '10:30:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3200, 108, NULL, NULL, '', 'wednesday', '11:15:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3201, 108, NULL, NULL, '', 'wednesday', '12:00:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3202, 108, NULL, NULL, '', 'wednesday', '12:45:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3203, 108, NULL, NULL, '', 'wednesday', '13:30:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3204, 108, NULL, NULL, '', 'friday', '09:00:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3205, 108, NULL, NULL, '', 'wednesday', '14:15:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3206, 108, NULL, NULL, '', 'friday', '09:45:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3207, 108, NULL, NULL, '', 'wednesday', '15:00:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3208, 108, NULL, NULL, '', 'friday', '10:30:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3209, 108, NULL, NULL, '', 'wednesday', '15:45:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3210, 108, NULL, NULL, '', 'saturday', '09:00:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09');
INSERT INTO `restaurant_business_hours` (`id`, `restaurant_id`, `country`, `city`, `shift_name`, `day_of_week`, `slot_time`, `added_by`, `created_at`, `updated_at`) VALUES
(3211, 108, NULL, NULL, '', 'friday', '11:15:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3212, 108, NULL, NULL, '', 'sunday', '09:00:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3213, 108, NULL, NULL, '', 'wednesday', '16:30:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3214, 108, NULL, NULL, '', 'saturday', '09:45:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3215, 108, NULL, NULL, '', 'sunday', '09:45:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3216, 108, NULL, NULL, '', 'friday', '12:00:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3217, 108, NULL, NULL, '', 'wednesday', '17:15:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3218, 108, NULL, NULL, '', 'saturday', '10:30:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3219, 108, NULL, NULL, '', 'friday', '12:45:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3220, 108, NULL, NULL, '', 'sunday', '10:30:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3221, 108, NULL, NULL, '', 'wednesday', '18:00:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3222, 108, NULL, NULL, '', 'saturday', '11:15:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3223, 108, NULL, NULL, '', 'friday', '13:30:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3224, 108, NULL, NULL, '', 'sunday', '11:15:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3225, 108, NULL, NULL, '', 'wednesday', '18:45:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3226, 108, NULL, NULL, '', 'sunday', '12:00:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3227, 108, NULL, NULL, '', 'saturday', '12:00:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3228, 108, NULL, NULL, '', 'friday', '14:15:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3229, 108, NULL, NULL, '', 'wednesday', '19:30:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3230, 108, NULL, NULL, '', 'sunday', '12:45:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3231, 108, NULL, NULL, '', 'saturday', '12:45:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3232, 108, NULL, NULL, '', 'friday', '15:00:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3233, 108, NULL, NULL, '', 'sunday', '13:30:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3234, 108, NULL, NULL, '', 'saturday', '13:30:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3235, 108, NULL, NULL, '', 'friday', '15:45:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3236, 108, NULL, NULL, '', 'sunday', '14:15:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3237, 108, NULL, NULL, '', 'saturday', '14:15:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3238, 108, NULL, NULL, '', 'sunday', '15:00:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3239, 108, NULL, NULL, '', 'friday', '16:30:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3240, 108, NULL, NULL, '', 'saturday', '15:00:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3241, 108, NULL, NULL, '', 'sunday', '15:45:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3242, 108, NULL, NULL, '', 'friday', '17:15:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3243, 108, NULL, NULL, '', 'saturday', '15:45:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3244, 108, NULL, NULL, '', 'sunday', '16:30:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3245, 108, NULL, NULL, '', 'saturday', '16:30:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3246, 108, NULL, NULL, '', 'friday', '18:00:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3247, 108, NULL, NULL, '', 'sunday', '17:15:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3248, 108, NULL, NULL, '', 'friday', '18:45:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3249, 108, NULL, NULL, '', 'saturday', '17:15:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3250, 108, NULL, NULL, '', 'sunday', '18:00:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3251, 108, NULL, NULL, '', 'saturday', '18:00:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3252, 108, NULL, NULL, '', 'friday', '19:30:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3253, 108, NULL, NULL, '', 'sunday', '18:45:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3254, 108, NULL, NULL, '', 'saturday', '18:45:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3255, 108, NULL, NULL, '', 'sunday', '19:30:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3256, 108, NULL, NULL, '', 'saturday', '19:30:00', 24, '2024-08-05 01:03:09', '2024-08-05 01:03:09'),
(3257, 110, 'France', 'Eure', '', 'monday', '09:00:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3258, 110, 'France', 'Eure', '', 'monday', '09:45:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3259, 110, 'France', 'Eure', '', 'monday', '10:30:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3260, 110, 'France', 'Eure', '', 'monday', '11:15:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3261, 110, 'France', 'Eure', '', 'monday', '12:00:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3262, 110, 'France', 'Eure', '', 'monday', '12:45:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3263, 110, 'France', 'Eure', '', 'monday', '13:30:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3264, 110, 'France', 'Eure', '', 'monday', '14:15:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3265, 110, 'France', 'Eure', '', 'monday', '15:00:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3266, 110, 'France', 'Eure', '', 'monday', '15:45:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3267, 110, 'France', 'Eure', '', 'monday', '16:30:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3268, 110, 'France', 'Eure', '', 'monday', '17:15:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3269, 110, 'France', 'Eure', '', 'monday', '18:00:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3270, 110, 'France', 'Eure', '', 'monday', '18:45:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3271, 110, 'France', 'Eure', '', 'monday', '19:30:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3272, 110, 'France', 'Eure', '', 'monday', '20:15:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3273, 110, 'France', 'Eure', '', 'monday', '21:00:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3274, 110, 'France', 'Eure', '', 'monday', '21:45:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3275, 110, 'France', 'Eure', '', 'monday', '22:30:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3276, 110, 'France', 'Eure', '', 'tuesday', '09:00:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3277, 110, 'France', 'Eure', '', 'tuesday', '09:45:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3278, 110, 'France', 'Eure', '', 'tuesday', '10:30:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3279, 110, 'France', 'Eure', '', 'tuesday', '11:15:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3280, 110, 'France', 'Eure', '', 'tuesday', '12:00:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3281, 110, 'France', 'Eure', '', 'tuesday', '12:45:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3282, 110, 'France', 'Eure', '', 'tuesday', '13:30:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3283, 110, 'France', 'Eure', '', 'tuesday', '14:15:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3284, 110, 'France', 'Eure', '', 'tuesday', '15:00:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3285, 110, 'France', 'Eure', '', 'tuesday', '15:45:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3286, 110, 'France', 'Eure', '', 'tuesday', '16:30:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3287, 110, 'France', 'Eure', '', 'tuesday', '17:15:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3288, 110, 'France', 'Eure', '', 'tuesday', '18:00:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3289, 110, 'France', 'Eure', '', 'tuesday', '18:45:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3290, 110, 'France', 'Eure', '', 'tuesday', '19:30:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3291, 110, 'France', 'Eure', '', 'tuesday', '20:15:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3292, 110, 'France', 'Eure', '', 'tuesday', '21:00:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3293, 110, 'France', 'Eure', '', 'tuesday', '21:45:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3294, 110, 'France', 'Eure', '', 'tuesday', '22:30:00', 22, '2024-08-08 08:33:37', '2024-08-08 08:33:37'),
(3295, 110, 'France', 'Eure', 'lun-dim', 'wednesday', '09:00:00', 24, '2024-08-08 08:35:25', '2024-08-08 08:35:25'),
(3296, 110, 'France', 'Eure', 'lun-dim', 'wednesday', '09:55:00', 24, '2024-08-08 08:35:25', '2024-08-08 08:35:25'),
(3297, 110, 'France', 'Eure', 'lun-dim', 'wednesday', '10:50:00', 24, '2024-08-08 08:35:25', '2024-08-08 08:35:25'),
(3298, 110, 'France', 'Eure', 'lun-dim', 'wednesday', '11:45:00', 24, '2024-08-08 08:35:25', '2024-08-08 08:35:25'),
(3299, 110, 'France', 'Eure', 'lun-dim', 'wednesday', '12:40:00', 24, '2024-08-08 08:35:25', '2024-08-08 08:35:25'),
(3300, 110, 'France', 'Eure', 'lun-dim', 'wednesday', '13:35:00', 24, '2024-08-08 08:35:25', '2024-08-08 08:35:25'),
(3301, 110, 'France', 'Eure', 'lun-dim', 'wednesday', '14:30:00', 24, '2024-08-08 08:35:25', '2024-08-08 08:35:25'),
(3302, 110, 'France', 'Eure', 'lun-dim', 'wednesday', '15:25:00', 24, '2024-08-08 08:35:25', '2024-08-08 08:35:25'),
(3303, 110, 'France', 'Eure', 'lun-dim', 'wednesday', '16:20:00', 24, '2024-08-08 08:35:25', '2024-08-08 08:35:25'),
(3304, 110, 'France', 'Eure', 'lun-dim', 'wednesday', '17:15:00', 24, '2024-08-08 08:35:25', '2024-08-08 08:35:25'),
(3305, 110, 'France', 'Eure', 'lun-dim', 'wednesday', '18:10:00', 24, '2024-08-08 08:35:25', '2024-08-08 08:35:25'),
(3306, 110, 'France', 'Eure', 'lun-dim', 'wednesday', '19:05:00', 24, '2024-08-08 08:35:25', '2024-08-08 08:35:25'),
(3307, 110, 'France', 'Eure', 'lun-dim', 'wednesday', '20:00:00', 24, '2024-08-08 08:35:25', '2024-08-08 08:35:25'),
(3308, 110, 'France', 'Eure', 'lun-dim', 'wednesday', '20:55:00', 24, '2024-08-08 08:35:25', '2024-08-08 08:35:25'),
(3309, 110, 'France', 'Eure', 'lun-dim', 'wednesday', '21:50:00', 24, '2024-08-08 08:35:25', '2024-08-08 08:35:25'),
(3310, 110, 'France', 'Eure', 'lun-dim', 'wednesday', '22:45:00', 24, '2024-08-08 08:35:25', '2024-08-08 08:35:25'),
(3311, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '13:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3312, 114, 'India', 'Noida', 'Day-Night', 'monday', '13:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3313, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '13:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3314, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '13:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3315, 114, 'India', 'Noida', 'Day-Night', 'monday', '13:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3316, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '13:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3317, 114, 'India', 'Noida', 'Day-Night', 'monday', '13:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3318, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '14:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3319, 114, 'India', 'Noida', 'Day-Night', 'monday', '13:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3320, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '14:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3321, 114, 'India', 'Noida', 'Day-Night', 'monday', '14:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3322, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '14:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3323, 114, 'India', 'Noida', 'Day-Night', 'monday', '14:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3324, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '14:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3325, 114, 'India', 'Noida', 'Day-Night', 'monday', '14:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3326, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '15:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3327, 114, 'India', 'Noida', 'Day-Night', 'monday', '14:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3328, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '15:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3329, 114, 'India', 'Noida', 'Day-Night', 'monday', '15:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3330, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '15:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3331, 114, 'India', 'Noida', 'Day-Night', 'monday', '15:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3332, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '15:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3333, 114, 'India', 'Noida', 'Day-Night', 'monday', '15:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3334, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '16:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3335, 114, 'India', 'Noida', 'Day-Night', 'monday', '15:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3336, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '16:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3337, 114, 'India', 'Noida', 'Day-Night', 'monday', '16:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3338, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '16:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3339, 114, 'India', 'Noida', 'Day-Night', 'monday', '16:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3340, 114, 'India', 'Noida', 'Day-Night', 'monday', '16:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3341, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '16:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3342, 114, 'India', 'Noida', 'Day-Night', 'monday', '16:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3343, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '17:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3344, 114, 'India', 'Noida', 'Day-Night', 'monday', '17:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3345, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '17:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3346, 114, 'India', 'Noida', 'Day-Night', 'monday', '17:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3347, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '17:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3348, 114, 'India', 'Noida', 'Day-Night', 'monday', '17:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3349, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '17:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3350, 114, 'India', 'Noida', 'Day-Night', 'monday', '17:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3351, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '18:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3352, 114, 'India', 'Noida', 'Day-Night', 'monday', '18:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3353, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '18:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3354, 114, 'India', 'Noida', 'Day-Night', 'monday', '18:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3355, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '18:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3356, 114, 'India', 'Noida', 'Day-Night', 'monday', '18:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3357, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '18:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3358, 114, 'India', 'Noida', 'Day-Night', 'monday', '18:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3359, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '19:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3360, 114, 'India', 'Noida', 'Day-Night', 'monday', '19:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3361, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '19:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3362, 114, 'India', 'Noida', 'Day-Night', 'monday', '19:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3363, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '19:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3364, 114, 'India', 'Noida', 'Day-Night', 'monday', '19:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3365, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '19:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3366, 114, 'India', 'Noida', 'Day-Night', 'monday', '19:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3367, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '20:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3368, 114, 'India', 'Noida', 'Day-Night', 'monday', '20:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3369, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '20:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3370, 114, 'India', 'Noida', 'Day-Night', 'monday', '20:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3371, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '20:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3372, 114, 'India', 'Noida', 'Day-Night', 'monday', '20:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3373, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '20:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3374, 114, 'India', 'Noida', 'Day-Night', 'monday', '20:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3375, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '21:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3376, 114, 'India', 'Noida', 'Day-Night', 'monday', '21:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3377, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '21:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3378, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '21:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3379, 114, 'India', 'Noida', 'Day-Night', 'monday', '21:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3380, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '21:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3381, 114, 'India', 'Noida', 'Day-Night', 'monday', '21:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3382, 114, 'India', 'Noida', 'Day-Night', 'tuesday', '22:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3383, 114, 'India', 'Noida', 'Day-Night', 'monday', '21:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3384, 114, 'India', 'Noida', 'Day-Night', 'thursday', '13:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3385, 114, 'India', 'Noida', 'Day-Night', 'monday', '22:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3386, 114, 'India', 'Noida', 'Day-Night', 'thursday', '13:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3387, 114, 'India', 'Noida', 'Day-Night', 'friday', '13:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3388, 114, 'India', 'Noida', 'Day-Night', 'thursday', '13:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3389, 114, 'India', 'Noida', 'Day-Night', 'friday', '13:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3390, 114, 'India', 'Noida', 'Day-Night', 'thursday', '13:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3391, 114, 'India', 'Noida', 'Day-Night', 'friday', '13:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3392, 114, 'India', 'Noida', 'Day-Night', 'thursday', '14:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3393, 114, 'India', 'Noida', 'Day-Night', 'friday', '13:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3394, 114, 'India', 'Noida', 'Day-Night', 'thursday', '14:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3395, 114, 'India', 'Noida', 'Day-Night', 'friday', '14:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3396, 114, 'India', 'Noida', 'Day-Night', 'thursday', '14:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3397, 114, 'India', 'Noida', 'Day-Night', 'thursday', '14:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3398, 114, 'India', 'Noida', 'Day-Night', 'friday', '14:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3399, 114, 'India', 'Noida', 'Day-Night', 'thursday', '15:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3400, 114, 'India', 'Noida', 'Day-Night', 'friday', '14:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3401, 114, 'India', 'Noida', 'Day-Night', 'thursday', '15:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3402, 114, 'India', 'Noida', 'Day-Night', 'friday', '14:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3403, 114, 'India', 'Noida', 'Day-Night', 'thursday', '15:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3404, 114, 'India', 'Noida', 'Day-Night', 'friday', '15:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3405, 114, 'India', 'Noida', 'Day-Night', 'thursday', '15:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3406, 114, 'India', 'Noida', 'Day-Night', 'friday', '15:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3407, 114, 'India', 'Noida', 'Day-Night', 'thursday', '16:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3408, 114, 'India', 'Noida', 'Day-Night', 'friday', '15:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3409, 114, 'India', 'Noida', 'Day-Night', 'thursday', '16:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3410, 114, 'India', 'Noida', 'Day-Night', 'thursday', '16:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3411, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '13:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3412, 114, 'India', 'Noida', 'Day-Night', 'friday', '15:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3413, 114, 'India', 'Noida', 'Day-Night', 'thursday', '16:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3414, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '13:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3415, 114, 'India', 'Noida', 'Day-Night', 'friday', '16:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3416, 114, 'India', 'Noida', 'Day-Night', 'thursday', '17:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3417, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '13:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3418, 114, 'India', 'Noida', 'Day-Night', 'friday', '16:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3419, 114, 'India', 'Noida', 'Day-Night', 'thursday', '17:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3420, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '13:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3421, 114, 'India', 'Noida', 'Day-Night', 'friday', '16:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3422, 114, 'India', 'Noida', 'Day-Night', 'thursday', '17:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3423, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '14:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3424, 114, 'India', 'Noida', 'Day-Night', 'thursday', '17:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3425, 114, 'India', 'Noida', 'Day-Night', 'friday', '16:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3426, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '14:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3427, 114, 'India', 'Noida', 'Day-Night', 'thursday', '18:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3428, 114, 'India', 'Noida', 'Day-Night', 'friday', '17:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3429, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '14:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3430, 114, 'India', 'Noida', 'Day-Night', 'thursday', '18:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3431, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '14:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3432, 114, 'India', 'Noida', 'Day-Night', 'friday', '17:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3433, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '15:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3434, 114, 'India', 'Noida', 'Day-Night', 'thursday', '18:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3435, 114, 'India', 'Noida', 'Day-Night', 'friday', '17:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3436, 114, 'India', 'Noida', 'Day-Night', 'thursday', '18:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3437, 114, 'India', 'Noida', 'Day-Night', 'friday', '17:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3438, 114, 'India', 'Noida', 'Day-Night', 'thursday', '19:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3439, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '15:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3440, 114, 'India', 'Noida', 'Day-Night', 'friday', '18:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3441, 114, 'India', 'Noida', 'Day-Night', 'thursday', '19:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3442, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '15:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3443, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '15:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3444, 114, 'India', 'Noida', 'Day-Night', 'friday', '18:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3445, 114, 'India', 'Noida', 'Day-Night', 'thursday', '19:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3446, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '16:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3447, 114, 'India', 'Noida', 'Day-Night', 'friday', '18:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3448, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '16:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3449, 114, 'India', 'Noida', 'Day-Night', 'thursday', '19:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3450, 114, 'India', 'Noida', 'Day-Night', 'friday', '18:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3451, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '16:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3452, 114, 'India', 'Noida', 'Day-Night', 'thursday', '20:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3453, 114, 'India', 'Noida', 'Day-Night', 'friday', '19:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3454, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '16:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3455, 114, 'India', 'Noida', 'Day-Night', 'thursday', '20:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3456, 114, 'India', 'Noida', 'Day-Night', 'friday', '19:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3457, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '17:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3458, 114, 'India', 'Noida', 'Day-Night', 'thursday', '20:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3459, 114, 'India', 'Noida', 'Day-Night', 'friday', '19:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3460, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '17:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3461, 114, 'India', 'Noida', 'Day-Night', 'friday', '19:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3462, 114, 'India', 'Noida', 'Day-Night', 'thursday', '20:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3463, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '17:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3464, 114, 'India', 'Noida', 'Day-Night', 'friday', '20:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3465, 114, 'India', 'Noida', 'Day-Night', 'thursday', '21:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3466, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '17:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3467, 114, 'India', 'Noida', 'Day-Night', 'friday', '20:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3468, 114, 'India', 'Noida', 'Day-Night', 'thursday', '21:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3469, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '18:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3470, 114, 'India', 'Noida', 'Day-Night', 'friday', '20:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3471, 114, 'India', 'Noida', 'Day-Night', 'thursday', '21:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3472, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '18:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3473, 114, 'India', 'Noida', 'Day-Night', 'friday', '20:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3474, 114, 'India', 'Noida', 'Day-Night', 'thursday', '21:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3475, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '18:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3476, 114, 'India', 'Noida', 'Day-Night', 'friday', '21:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3477, 114, 'India', 'Noida', 'Day-Night', 'thursday', '22:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3478, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '18:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3479, 114, 'India', 'Noida', 'Day-Night', 'friday', '21:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3480, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '19:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3481, 114, 'India', 'Noida', 'Day-Night', 'friday', '21:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3482, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '19:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3483, 114, 'India', 'Noida', 'Day-Night', 'friday', '21:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3484, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '19:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3485, 114, 'India', 'Noida', 'Day-Night', 'friday', '22:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3486, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '19:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3487, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '20:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3488, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '20:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3489, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '20:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3490, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '20:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3491, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '21:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3492, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '21:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3493, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '21:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3494, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '21:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3495, 114, 'India', 'Noida', 'Day-Night', 'wednesday', '22:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3496, 114, 'India', 'Noida', 'Day-Night', 'sunday', '09:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3497, 114, 'India', 'Noida', 'Day-Night', 'sunday', '09:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3498, 114, 'India', 'Noida', 'Day-Night', 'sunday', '10:00:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3499, 114, 'India', 'Noida', 'Day-Night', 'sunday', '10:15:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3500, 114, 'India', 'Noida', 'Day-Night', 'sunday', '10:30:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3501, 114, 'India', 'Noida', 'Day-Night', 'saturday', '09:15:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3502, 114, 'India', 'Noida', 'Day-Night', 'sunday', '10:45:00', 24, '2024-08-09 09:10:26', '2024-08-09 09:10:26'),
(3503, 114, 'India', 'Noida', 'Day-Night', 'sunday', '11:00:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3504, 114, 'India', 'Noida', 'Day-Night', 'sunday', '11:15:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3505, 114, 'India', 'Noida', 'Day-Night', 'sunday', '11:30:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3506, 114, 'India', 'Noida', 'Day-Night', 'sunday', '11:45:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3507, 114, 'India', 'Noida', 'Day-Night', 'sunday', '12:00:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3508, 114, 'India', 'Noida', 'Day-Night', 'sunday', '12:15:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3509, 114, 'India', 'Noida', 'Day-Night', 'sunday', '12:30:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3510, 114, 'India', 'Noida', 'Day-Night', 'sunday', '12:45:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3511, 114, 'India', 'Noida', 'Day-Night', 'sunday', '13:00:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3512, 114, 'India', 'Noida', 'Day-Night', 'sunday', '13:15:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3513, 114, 'India', 'Noida', 'Day-Night', 'sunday', '13:30:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3514, 114, 'India', 'Noida', 'Day-Night', 'sunday', '13:45:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3515, 114, 'India', 'Noida', 'Day-Night', 'sunday', '14:00:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3516, 114, 'India', 'Noida', 'Day-Night', 'sunday', '14:15:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3517, 114, 'India', 'Noida', 'Day-Night', 'sunday', '14:30:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3518, 114, 'India', 'Noida', 'Day-Night', 'sunday', '14:45:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3519, 114, 'India', 'Noida', 'Day-Night', 'sunday', '15:00:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3520, 114, 'India', 'Noida', 'Day-Night', 'saturday', '09:30:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3521, 114, 'India', 'Noida', 'Day-Night', 'sunday', '15:15:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3522, 114, 'India', 'Noida', 'Day-Night', 'sunday', '15:30:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3523, 114, 'India', 'Noida', 'Day-Night', 'saturday', '09:45:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3524, 114, 'India', 'Noida', 'Day-Night', 'sunday', '15:45:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3525, 114, 'India', 'Noida', 'Day-Night', 'sunday', '16:00:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3526, 114, 'India', 'Noida', 'Day-Night', 'sunday', '16:15:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3527, 114, 'India', 'Noida', 'Day-Night', 'sunday', '16:30:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3528, 114, 'India', 'Noida', 'Day-Night', 'sunday', '16:45:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3529, 114, 'India', 'Noida', 'Day-Night', 'sunday', '17:00:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3530, 114, 'India', 'Noida', 'Day-Night', 'sunday', '17:15:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3531, 114, 'India', 'Noida', 'Day-Night', 'sunday', '17:30:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3532, 114, 'India', 'Noida', 'Day-Night', 'sunday', '17:45:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3533, 114, 'India', 'Noida', 'Day-Night', 'saturday', '10:00:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3534, 114, 'India', 'Noida', 'Day-Night', 'sunday', '18:00:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3535, 114, 'India', 'Noida', 'Day-Night', 'saturday', '10:15:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3536, 114, 'India', 'Noida', 'Day-Night', 'sunday', '18:15:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3537, 114, 'India', 'Noida', 'Day-Night', 'saturday', '10:30:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3538, 114, 'India', 'Noida', 'Day-Night', 'sunday', '18:30:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3539, 114, 'India', 'Noida', 'Day-Night', 'saturday', '10:45:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3540, 114, 'India', 'Noida', 'Day-Night', 'sunday', '18:45:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3541, 114, 'India', 'Noida', 'Day-Night', 'saturday', '11:00:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3542, 114, 'India', 'Noida', 'Day-Night', 'sunday', '19:00:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3543, 114, 'India', 'Noida', 'Day-Night', 'saturday', '11:15:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3544, 114, 'India', 'Noida', 'Day-Night', 'sunday', '19:15:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3545, 114, 'India', 'Noida', 'Day-Night', 'saturday', '11:30:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3546, 114, 'India', 'Noida', 'Day-Night', 'sunday', '19:30:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3547, 114, 'India', 'Noida', 'Day-Night', 'saturday', '11:45:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3548, 114, 'India', 'Noida', 'Day-Night', 'sunday', '19:45:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3549, 114, 'India', 'Noida', 'Day-Night', 'sunday', '20:00:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3550, 114, 'India', 'Noida', 'Day-Night', 'saturday', '12:00:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3551, 114, 'India', 'Noida', 'Day-Night', 'sunday', '20:15:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3552, 114, 'India', 'Noida', 'Day-Night', 'saturday', '12:15:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3553, 114, 'India', 'Noida', 'Day-Night', 'sunday', '20:30:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3554, 114, 'India', 'Noida', 'Day-Night', 'saturday', '12:30:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3555, 114, 'India', 'Noida', 'Day-Night', 'sunday', '20:45:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3556, 114, 'India', 'Noida', 'Day-Night', 'saturday', '12:45:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3557, 114, 'India', 'Noida', 'Day-Night', 'sunday', '21:00:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3558, 114, 'India', 'Noida', 'Day-Night', 'saturday', '13:00:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3559, 114, 'India', 'Noida', 'Day-Night', 'sunday', '21:15:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3560, 114, 'India', 'Noida', 'Day-Night', 'saturday', '13:15:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3561, 114, 'India', 'Noida', 'Day-Night', 'sunday', '21:30:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3562, 114, 'India', 'Noida', 'Day-Night', 'saturday', '13:30:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3563, 114, 'India', 'Noida', 'Day-Night', 'sunday', '21:45:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3564, 114, 'India', 'Noida', 'Day-Night', 'saturday', '13:45:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3565, 114, 'India', 'Noida', 'Day-Night', 'sunday', '22:00:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3566, 114, 'India', 'Noida', 'Day-Night', 'saturday', '14:00:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3567, 114, 'India', 'Noida', 'Day-Night', 'sunday', '22:15:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3568, 114, 'India', 'Noida', 'Day-Night', 'saturday', '14:15:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3569, 114, 'India', 'Noida', 'Day-Night', 'saturday', '14:30:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3570, 114, 'India', 'Noida', 'Day-Night', 'sunday', '22:30:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3571, 114, 'India', 'Noida', 'Day-Night', 'saturday', '14:45:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3572, 114, 'India', 'Noida', 'Day-Night', 'sunday', '22:45:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3573, 114, 'India', 'Noida', 'Day-Night', 'sunday', '23:00:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3574, 114, 'India', 'Noida', 'Day-Night', 'sunday', '23:15:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3575, 114, 'India', 'Noida', 'Day-Night', 'saturday', '15:00:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3576, 114, 'India', 'Noida', 'Day-Night', 'sunday', '23:30:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3577, 114, 'India', 'Noida', 'Day-Night', 'saturday', '15:15:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3578, 114, 'India', 'Noida', 'Day-Night', 'sunday', '23:45:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3579, 114, 'India', 'Noida', 'Day-Night', 'saturday', '15:30:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3580, 114, 'India', 'Noida', 'Day-Night', 'saturday', '15:45:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3581, 114, 'India', 'Noida', 'Day-Night', 'saturday', '16:00:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3582, 114, 'India', 'Noida', 'Day-Night', 'saturday', '16:15:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3583, 114, 'India', 'Noida', 'Day-Night', 'saturday', '16:30:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3584, 114, 'India', 'Noida', 'Day-Night', 'saturday', '16:45:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3585, 114, 'India', 'Noida', 'Day-Night', 'saturday', '17:00:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3586, 114, 'India', 'Noida', 'Day-Night', 'saturday', '17:15:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3587, 114, 'India', 'Noida', 'Day-Night', 'saturday', '17:30:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3588, 114, 'India', 'Noida', 'Day-Night', 'saturday', '17:45:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3589, 114, 'India', 'Noida', 'Day-Night', 'saturday', '18:00:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3590, 114, 'India', 'Noida', 'Day-Night', 'saturday', '18:15:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3591, 114, 'India', 'Noida', 'Day-Night', 'saturday', '18:30:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3592, 114, 'India', 'Noida', 'Day-Night', 'saturday', '18:45:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3593, 114, 'India', 'Noida', 'Day-Night', 'saturday', '19:00:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3594, 114, 'India', 'Noida', 'Day-Night', 'saturday', '19:15:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3595, 114, 'India', 'Noida', 'Day-Night', 'saturday', '19:30:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3596, 114, 'India', 'Noida', 'Day-Night', 'saturday', '19:45:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3597, 114, 'India', 'Noida', 'Day-Night', 'saturday', '20:00:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3598, 114, 'India', 'Noida', 'Day-Night', 'saturday', '20:15:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3599, 114, 'India', 'Noida', 'Day-Night', 'saturday', '20:30:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3600, 114, 'India', 'Noida', 'Day-Night', 'saturday', '20:45:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3601, 114, 'India', 'Noida', 'Day-Night', 'saturday', '21:00:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3602, 114, 'India', 'Noida', 'Day-Night', 'saturday', '21:15:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3603, 114, 'India', 'Noida', 'Day-Night', 'saturday', '21:30:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3604, 114, 'India', 'Noida', 'Day-Night', 'saturday', '21:45:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3605, 114, 'India', 'Noida', 'Day-Night', 'saturday', '22:00:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3606, 114, 'India', 'Noida', 'Day-Night', 'saturday', '22:15:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3607, 114, 'India', 'Noida', 'Day-Night', 'saturday', '22:30:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3608, 114, 'India', 'Noida', 'Day-Night', 'saturday', '22:45:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3609, 114, 'India', 'Noida', 'Day-Night', 'saturday', '23:00:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3610, 114, 'India', 'Noida', 'Day-Night', 'saturday', '23:15:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3611, 114, 'India', 'Noida', 'Day-Night', 'saturday', '23:30:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3612, 114, 'India', 'Noida', 'Day-Night', 'saturday', '23:45:00', 24, '2024-08-09 09:10:27', '2024-08-09 09:10:27'),
(3613, 123, 'France', 'Paris', 'N/A', 'tuesday', '09:00:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3614, 123, 'France', 'Paris', 'N/A', 'tuesday', '09:45:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3615, 123, 'France', 'Paris', 'N/A', 'tuesday', '10:30:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3616, 123, 'France', 'Paris', 'N/A', 'tuesday', '11:15:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3617, 123, 'France', 'Paris', 'N/A', 'tuesday', '12:00:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3618, 123, 'France', 'Paris', 'N/A', 'tuesday', '12:45:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3619, 123, 'France', 'Paris', 'N/A', 'tuesday', '13:30:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3620, 123, 'France', 'Paris', 'N/A', 'thursday', '09:00:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3621, 123, 'France', 'Paris', 'N/A', 'tuesday', '14:15:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3622, 123, 'France', 'Paris', 'N/A', 'thursday', '09:45:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3623, 123, 'France', 'Paris', 'N/A', 'tuesday', '15:00:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3624, 123, 'France', 'Paris', 'N/A', 'thursday', '10:30:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3625, 123, 'France', 'Paris', 'N/A', 'tuesday', '15:45:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3626, 123, 'France', 'Paris', 'N/A', 'thursday', '11:15:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3627, 123, 'France', 'Paris', 'N/A', 'tuesday', '16:30:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3628, 123, 'France', 'Paris', 'N/A', 'thursday', '12:00:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3629, 123, 'France', 'Paris', 'N/A', 'tuesday', '17:15:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3630, 123, 'France', 'Paris', 'N/A', 'thursday', '12:45:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3631, 123, 'France', 'Paris', 'N/A', 'tuesday', '18:00:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3632, 123, 'France', 'Paris', 'N/A', 'thursday', '13:30:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3633, 123, 'France', 'Paris', 'N/A', 'tuesday', '18:45:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3634, 123, 'France', 'Paris', 'N/A', 'thursday', '14:15:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3635, 123, 'France', 'Paris', 'N/A', 'tuesday', '19:30:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3636, 123, 'France', 'Paris', 'N/A', 'thursday', '15:00:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3637, 123, 'France', 'Paris', 'N/A', 'thursday', '15:45:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3638, 123, 'France', 'Paris', 'N/A', 'tuesday', '20:15:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3639, 123, 'France', 'Paris', 'N/A', 'thursday', '16:30:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3640, 123, 'France', 'Paris', 'N/A', 'tuesday', '21:00:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3641, 123, 'France', 'Paris', 'N/A', 'thursday', '17:15:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3642, 123, 'France', 'Paris', 'N/A', 'thursday', '18:00:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3643, 123, 'France', 'Paris', 'N/A', 'thursday', '18:45:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3644, 123, 'France', 'Paris', 'N/A', 'thursday', '19:30:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3645, 123, 'France', 'Paris', 'N/A', 'thursday', '20:15:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3646, 123, 'France', 'Paris', 'N/A', 'thursday', '21:00:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3647, 123, 'France', 'Paris', 'N/A', 'thursday', '21:45:00', 24, '2024-08-13 07:01:39', '2024-08-13 07:01:39'),
(3648, 123, 'France', 'Paris', 'N/A', 'wednesday', '09:00:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3649, 123, 'France', 'Paris', 'N/A', 'wednesday', '09:45:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3650, 123, 'France', 'Paris', 'N/A', 'wednesday', '10:30:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3651, 123, 'France', 'Paris', 'N/A', 'wednesday', '11:15:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3652, 123, 'France', 'Paris', 'N/A', 'wednesday', '12:00:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3653, 123, 'France', 'Paris', 'N/A', 'wednesday', '12:45:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40');
INSERT INTO `restaurant_business_hours` (`id`, `restaurant_id`, `country`, `city`, `shift_name`, `day_of_week`, `slot_time`, `added_by`, `created_at`, `updated_at`) VALUES
(3654, 123, 'France', 'Paris', 'N/A', 'wednesday', '13:30:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3655, 123, 'France', 'Paris', 'N/A', 'wednesday', '14:15:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3656, 123, 'France', 'Paris', 'N/A', 'wednesday', '15:00:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3657, 123, 'France', 'Paris', 'N/A', 'wednesday', '15:45:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3658, 123, 'France', 'Paris', 'N/A', 'wednesday', '16:30:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3659, 123, 'France', 'Paris', 'N/A', 'wednesday', '17:15:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3660, 123, 'France', 'Paris', 'N/A', 'wednesday', '18:00:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3661, 123, 'France', 'Paris', 'N/A', 'wednesday', '18:45:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3662, 123, 'France', 'Paris', 'N/A', 'wednesday', '19:30:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3663, 123, 'France', 'Paris', 'N/A', 'wednesday', '20:15:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3664, 123, 'France', 'Paris', 'N/A', 'wednesday', '21:00:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3665, 123, 'France', 'Paris', 'N/A', 'monday', '09:00:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3666, 123, 'France', 'Paris', 'N/A', 'monday', '09:45:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3667, 123, 'France', 'Paris', 'N/A', 'monday', '10:30:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3668, 123, 'France', 'Paris', 'N/A', 'monday', '11:15:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3669, 123, 'France', 'Paris', 'N/A', 'monday', '12:00:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3670, 123, 'France', 'Paris', 'N/A', 'saturday', '09:00:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3671, 123, 'France', 'Paris', 'N/A', 'monday', '12:45:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3672, 123, 'France', 'Paris', 'N/A', 'saturday', '09:45:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3673, 123, 'France', 'Paris', 'N/A', 'monday', '13:30:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3674, 123, 'France', 'Paris', 'N/A', 'saturday', '10:30:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3675, 123, 'France', 'Paris', 'N/A', 'monday', '14:15:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3676, 123, 'France', 'Paris', 'N/A', 'saturday', '11:15:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3677, 123, 'France', 'Paris', 'N/A', 'monday', '15:00:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3678, 123, 'France', 'Paris', 'N/A', 'saturday', '12:00:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3679, 123, 'France', 'Paris', 'N/A', 'monday', '15:45:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3680, 123, 'France', 'Paris', 'N/A', 'saturday', '12:45:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3681, 123, 'France', 'Paris', 'N/A', 'monday', '16:30:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3682, 123, 'France', 'Paris', 'N/A', 'saturday', '13:30:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3683, 123, 'France', 'Paris', 'N/A', 'monday', '17:15:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3684, 123, 'France', 'Paris', 'N/A', 'saturday', '14:15:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3685, 123, 'France', 'Paris', 'N/A', 'monday', '18:00:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3686, 123, 'France', 'Paris', 'N/A', 'saturday', '15:00:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3687, 123, 'France', 'Paris', 'N/A', 'monday', '18:45:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3688, 123, 'France', 'Paris', 'N/A', 'saturday', '15:45:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3689, 123, 'France', 'Paris', 'N/A', 'monday', '19:30:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3690, 123, 'France', 'Paris', 'N/A', 'saturday', '16:30:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3691, 123, 'France', 'Paris', 'N/A', 'saturday', '17:15:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3692, 123, 'France', 'Paris', 'N/A', 'saturday', '18:00:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3693, 123, 'France', 'Paris', 'N/A', 'saturday', '18:45:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3694, 123, 'France', 'Paris', 'N/A', 'saturday', '19:30:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3695, 123, 'France', 'Paris', 'N/A', 'saturday', '20:15:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3696, 123, 'France', 'Paris', 'N/A', 'friday', '09:00:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3697, 123, 'France', 'Paris', 'N/A', 'friday', '09:45:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3698, 123, 'France', 'Paris', 'N/A', 'friday', '10:30:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3699, 123, 'France', 'Paris', 'N/A', 'friday', '11:15:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3700, 123, 'France', 'Paris', 'N/A', 'friday', '12:00:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3701, 123, 'France', 'Paris', 'N/A', 'friday', '12:45:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3702, 123, 'France', 'Paris', 'N/A', 'friday', '13:30:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3703, 123, 'France', 'Paris', 'N/A', 'friday', '14:15:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3704, 123, 'France', 'Paris', 'N/A', 'friday', '15:00:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3705, 123, 'France', 'Paris', 'N/A', 'friday', '15:45:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3706, 123, 'France', 'Paris', 'N/A', 'friday', '16:30:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3707, 123, 'France', 'Paris', 'N/A', 'friday', '17:15:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3708, 123, 'France', 'Paris', 'N/A', 'friday', '18:00:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3709, 123, 'France', 'Paris', 'N/A', 'friday', '18:45:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3710, 123, 'France', 'Paris', 'N/A', 'friday', '19:30:00', 24, '2024-08-13 07:01:40', '2024-08-13 07:01:40'),
(3711, 153, 'France', 'Paris', 'N/A', 'tuesday', '12:00:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3712, 153, 'France', 'Paris', 'N/A', 'thursday', '12:00:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3713, 153, 'France', 'Paris', 'N/A', 'tuesday', '12:45:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3714, 153, 'France', 'Paris', 'N/A', 'thursday', '12:45:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3715, 153, 'France', 'Paris', 'N/A', 'tuesday', '13:30:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3716, 153, 'France', 'Paris', 'N/A', 'thursday', '13:30:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3717, 153, 'France', 'Paris', 'N/A', 'tuesday', '14:15:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3718, 153, 'France', 'Paris', 'N/A', 'thursday', '14:15:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3719, 153, 'France', 'Paris', 'N/A', 'tuesday', '15:00:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3720, 153, 'France', 'Paris', 'N/A', 'thursday', '15:00:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3721, 153, 'France', 'Paris', 'N/A', 'tuesday', '15:45:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3722, 153, 'France', 'Paris', 'N/A', 'thursday', '15:45:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3723, 153, 'France', 'Paris', 'N/A', 'tuesday', '16:30:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3724, 153, 'France', 'Paris', 'N/A', 'tuesday', '17:15:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3725, 153, 'France', 'Paris', 'N/A', 'thursday', '16:30:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3726, 153, 'France', 'Paris', 'N/A', 'tuesday', '18:00:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3727, 153, 'France', 'Paris', 'N/A', 'thursday', '17:15:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3728, 153, 'France', 'Paris', 'N/A', 'tuesday', '18:45:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3729, 153, 'France', 'Paris', 'N/A', 'thursday', '18:00:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3730, 153, 'France', 'Paris', 'N/A', 'tuesday', '19:30:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3731, 153, 'France', 'Paris', 'N/A', 'thursday', '18:45:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3732, 153, 'France', 'Paris', 'N/A', 'thursday', '19:30:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3733, 153, 'France', 'Paris', 'N/A', 'monday', '12:00:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3734, 153, 'France', 'Paris', 'N/A', 'monday', '12:45:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3735, 153, 'France', 'Paris', 'N/A', 'monday', '13:30:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3736, 153, 'France', 'Paris', 'N/A', 'monday', '14:15:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3737, 153, 'France', 'Paris', 'N/A', 'monday', '15:00:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3738, 153, 'France', 'Paris', 'N/A', 'monday', '15:45:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3739, 153, 'France', 'Paris', 'N/A', 'monday', '16:30:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3740, 153, 'France', 'Paris', 'N/A', 'monday', '17:15:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3741, 153, 'France', 'Paris', 'N/A', 'monday', '18:00:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3742, 153, 'France', 'Paris', 'N/A', 'monday', '18:45:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3743, 153, 'France', 'Paris', 'N/A', 'monday', '19:30:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3744, 153, 'France', 'Paris', 'N/A', 'friday', '12:00:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3745, 153, 'France', 'Paris', 'N/A', 'saturday', '12:00:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3746, 153, 'France', 'Paris', 'N/A', 'friday', '12:45:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3747, 153, 'France', 'Paris', 'N/A', 'saturday', '12:45:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3748, 153, 'France', 'Paris', 'N/A', 'wednesday', '12:00:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3749, 153, 'France', 'Paris', 'N/A', 'friday', '13:30:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3750, 153, 'France', 'Paris', 'N/A', 'saturday', '13:30:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3751, 153, 'France', 'Paris', 'N/A', 'friday', '14:15:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3752, 153, 'France', 'Paris', 'N/A', 'wednesday', '12:45:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3753, 153, 'France', 'Paris', 'N/A', 'saturday', '14:15:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3754, 153, 'France', 'Paris', 'N/A', 'wednesday', '13:30:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3755, 153, 'France', 'Paris', 'N/A', 'friday', '15:00:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3756, 153, 'France', 'Paris', 'N/A', 'saturday', '15:00:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3757, 153, 'France', 'Paris', 'N/A', 'wednesday', '14:15:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3758, 153, 'France', 'Paris', 'N/A', 'saturday', '15:45:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3759, 153, 'France', 'Paris', 'N/A', 'friday', '15:45:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3760, 153, 'France', 'Paris', 'N/A', 'wednesday', '15:00:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3761, 153, 'France', 'Paris', 'N/A', 'saturday', '16:30:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3762, 153, 'France', 'Paris', 'N/A', 'wednesday', '15:45:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3763, 153, 'France', 'Paris', 'N/A', 'friday', '16:30:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3764, 153, 'France', 'Paris', 'N/A', 'saturday', '17:15:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3765, 153, 'France', 'Paris', 'N/A', 'friday', '17:15:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3766, 153, 'France', 'Paris', 'N/A', 'wednesday', '16:30:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3767, 153, 'France', 'Paris', 'N/A', 'saturday', '18:00:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3768, 153, 'France', 'Paris', 'N/A', 'wednesday', '17:15:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3769, 153, 'France', 'Paris', 'N/A', 'saturday', '18:45:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3770, 153, 'France', 'Paris', 'N/A', 'friday', '18:00:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3771, 153, 'France', 'Paris', 'N/A', 'wednesday', '18:00:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3772, 153, 'France', 'Paris', 'N/A', 'friday', '18:45:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3773, 153, 'France', 'Paris', 'N/A', 'saturday', '19:30:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3774, 153, 'France', 'Paris', 'N/A', 'wednesday', '18:45:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3775, 153, 'France', 'Paris', 'N/A', 'friday', '19:30:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3776, 153, 'France', 'Paris', 'N/A', 'wednesday', '19:30:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3777, 153, 'France', 'Paris', 'N/A', 'sunday', '12:00:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3778, 153, 'France', 'Paris', 'N/A', 'sunday', '12:45:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3779, 153, 'France', 'Paris', 'N/A', 'sunday', '13:30:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3780, 153, 'France', 'Paris', 'N/A', 'sunday', '14:15:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3781, 153, 'France', 'Paris', 'N/A', 'sunday', '15:00:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3782, 153, 'France', 'Paris', 'N/A', 'sunday', '15:45:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3783, 153, 'France', 'Paris', 'N/A', 'sunday', '16:30:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3784, 153, 'France', 'Paris', 'N/A', 'sunday', '17:15:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3785, 153, 'France', 'Paris', 'N/A', 'sunday', '18:00:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3786, 153, 'France', 'Paris', 'N/A', 'sunday', '18:45:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3787, 153, 'France', 'Paris', 'N/A', 'sunday', '19:30:00', 24, '2024-09-03 04:40:59', '2024-09-03 04:40:59'),
(3788, 154, 'France', 'Paris', 'N/A', 'friday', '12:00:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3789, 154, 'France', 'Paris', 'N/A', 'friday', '12:25:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3790, 154, 'France', 'Paris', 'N/A', 'friday', '12:50:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3791, 154, 'France', 'Paris', 'N/A', 'friday', '13:15:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3792, 154, 'France', 'Paris', 'N/A', 'friday', '13:40:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3793, 154, 'France', 'Paris', 'N/A', 'friday', '14:05:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3794, 154, 'France', 'Paris', 'N/A', 'friday', '14:30:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3795, 154, 'France', 'Paris', 'N/A', 'friday', '14:55:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3796, 154, 'France', 'Paris', 'N/A', 'friday', '15:20:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3797, 154, 'France', 'Paris', 'N/A', 'friday', '15:45:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3798, 154, 'France', 'Paris', 'N/A', 'friday', '16:10:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3799, 154, 'France', 'Paris', 'N/A', 'friday', '16:35:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3800, 154, 'France', 'Paris', 'N/A', 'friday', '17:00:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3801, 154, 'France', 'Paris', 'N/A', 'friday', '17:25:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3802, 154, 'France', 'Paris', 'N/A', 'friday', '17:50:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3803, 154, 'France', 'Paris', 'N/A', 'friday', '18:15:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3804, 154, 'France', 'Paris', 'N/A', 'friday', '18:40:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3805, 154, 'France', 'Paris', 'N/A', 'friday', '19:05:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3806, 154, 'France', 'Paris', 'N/A', 'friday', '19:30:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3807, 154, 'France', 'Paris', 'N/A', 'friday', '19:55:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3808, 154, 'France', 'Paris', 'N/A', 'friday', '20:20:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3809, 154, 'France', 'Paris', 'N/A', 'friday', '20:45:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3810, 154, 'France', 'Paris', 'N/A', 'friday', '21:10:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3811, 154, 'France', 'Paris', 'N/A', 'wednesday', '12:00:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3812, 154, 'France', 'Paris', 'N/A', 'friday', '21:35:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3813, 154, 'France', 'Paris', 'N/A', 'wednesday', '12:25:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3814, 154, 'France', 'Paris', 'N/A', 'friday', '22:00:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3815, 154, 'France', 'Paris', 'N/A', 'wednesday', '12:50:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3816, 154, 'France', 'Paris', 'N/A', 'friday', '22:25:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3817, 154, 'France', 'Paris', 'N/A', 'wednesday', '13:15:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3818, 154, 'France', 'Paris', 'N/A', 'friday', '22:50:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3819, 154, 'France', 'Paris', 'N/A', 'wednesday', '13:40:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3820, 154, 'France', 'Paris', 'N/A', 'friday', '23:15:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3821, 154, 'France', 'Paris', 'N/A', 'wednesday', '14:05:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3822, 154, 'France', 'Paris', 'N/A', 'friday', '23:40:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3823, 154, 'France', 'Paris', 'N/A', 'wednesday', '14:30:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3824, 154, 'France', 'Paris', 'N/A', 'monday', '12:00:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3825, 154, 'France', 'Paris', 'N/A', 'wednesday', '14:55:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3826, 154, 'France', 'Paris', 'N/A', 'wednesday', '15:20:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3827, 154, 'France', 'Paris', 'N/A', 'wednesday', '15:45:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3828, 154, 'France', 'Paris', 'N/A', 'monday', '12:25:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3829, 154, 'France', 'Paris', 'N/A', 'tuesday', '12:00:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3830, 154, 'France', 'Paris', 'N/A', 'wednesday', '16:10:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3831, 154, 'France', 'Paris', 'N/A', 'monday', '12:50:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3832, 154, 'France', 'Paris', 'N/A', 'tuesday', '12:25:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3833, 154, 'France', 'Paris', 'N/A', 'monday', '13:15:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3834, 154, 'France', 'Paris', 'N/A', 'tuesday', '12:50:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3835, 154, 'France', 'Paris', 'N/A', 'wednesday', '16:35:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3836, 154, 'France', 'Paris', 'N/A', 'monday', '13:40:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3837, 154, 'France', 'Paris', 'N/A', 'sunday', '12:00:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3838, 154, 'France', 'Paris', 'N/A', 'saturday', '12:00:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3839, 154, 'France', 'Paris', 'N/A', 'wednesday', '17:00:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3840, 154, 'France', 'Paris', 'N/A', 'tuesday', '13:15:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3841, 154, 'France', 'Paris', 'N/A', 'monday', '14:05:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3842, 154, 'France', 'Paris', 'N/A', 'tuesday', '13:40:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3843, 154, 'France', 'Paris', 'N/A', 'sunday', '12:25:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3844, 154, 'France', 'Paris', 'N/A', 'saturday', '12:25:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3845, 154, 'France', 'Paris', 'N/A', 'wednesday', '17:25:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3846, 154, 'France', 'Paris', 'N/A', 'monday', '14:30:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3847, 154, 'France', 'Paris', 'N/A', 'tuesday', '14:05:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3848, 154, 'France', 'Paris', 'N/A', 'sunday', '12:50:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3849, 154, 'France', 'Paris', 'N/A', 'saturday', '12:50:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3850, 154, 'France', 'Paris', 'N/A', 'wednesday', '17:50:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3851, 154, 'France', 'Paris', 'N/A', 'tuesday', '14:30:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3852, 154, 'France', 'Paris', 'N/A', 'monday', '14:55:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3853, 154, 'France', 'Paris', 'N/A', 'sunday', '13:15:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3854, 154, 'France', 'Paris', 'N/A', 'saturday', '13:15:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3855, 154, 'France', 'Paris', 'N/A', 'wednesday', '18:15:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3856, 154, 'France', 'Paris', 'N/A', 'monday', '15:20:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3857, 154, 'France', 'Paris', 'N/A', 'sunday', '13:40:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3858, 154, 'France', 'Paris', 'N/A', 'tuesday', '14:55:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3859, 154, 'France', 'Paris', 'N/A', 'saturday', '13:40:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3860, 154, 'France', 'Paris', 'N/A', 'wednesday', '18:40:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3861, 154, 'France', 'Paris', 'N/A', 'wednesday', '19:05:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3862, 154, 'France', 'Paris', 'N/A', 'sunday', '14:05:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3863, 154, 'France', 'Paris', 'N/A', 'tuesday', '15:20:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3864, 154, 'France', 'Paris', 'N/A', 'monday', '15:45:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3865, 154, 'France', 'Paris', 'N/A', 'saturday', '14:05:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3866, 154, 'France', 'Paris', 'N/A', 'wednesday', '19:30:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3867, 154, 'France', 'Paris', 'N/A', 'monday', '16:10:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3868, 154, 'France', 'Paris', 'N/A', 'tuesday', '15:45:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3869, 154, 'France', 'Paris', 'N/A', 'sunday', '14:30:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3870, 154, 'France', 'Paris', 'N/A', 'saturday', '14:30:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3871, 154, 'France', 'Paris', 'N/A', 'wednesday', '19:55:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3872, 154, 'France', 'Paris', 'N/A', 'monday', '16:35:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3873, 154, 'France', 'Paris', 'N/A', 'tuesday', '16:10:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3874, 154, 'France', 'Paris', 'N/A', 'sunday', '14:55:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3875, 154, 'France', 'Paris', 'N/A', 'saturday', '14:55:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3876, 154, 'France', 'Paris', 'N/A', 'monday', '17:00:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3877, 154, 'France', 'Paris', 'N/A', 'wednesday', '20:20:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3878, 154, 'France', 'Paris', 'N/A', 'tuesday', '16:35:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3879, 154, 'France', 'Paris', 'N/A', 'sunday', '15:20:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3880, 154, 'France', 'Paris', 'N/A', 'saturday', '15:20:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3881, 154, 'France', 'Paris', 'N/A', 'tuesday', '17:00:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3882, 154, 'France', 'Paris', 'N/A', 'monday', '17:25:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3883, 154, 'France', 'Paris', 'N/A', 'sunday', '15:45:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3884, 154, 'France', 'Paris', 'N/A', 'saturday', '15:45:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3885, 154, 'France', 'Paris', 'N/A', 'wednesday', '20:45:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3886, 154, 'France', 'Paris', 'N/A', 'monday', '17:50:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3887, 154, 'France', 'Paris', 'N/A', 'tuesday', '17:25:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3888, 154, 'France', 'Paris', 'N/A', 'sunday', '16:10:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3889, 154, 'France', 'Paris', 'N/A', 'wednesday', '21:10:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3890, 154, 'France', 'Paris', 'N/A', 'saturday', '16:10:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3891, 154, 'France', 'Paris', 'N/A', 'monday', '18:15:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3892, 154, 'France', 'Paris', 'N/A', 'tuesday', '17:50:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3893, 154, 'France', 'Paris', 'N/A', 'wednesday', '21:35:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3894, 154, 'France', 'Paris', 'N/A', 'sunday', '16:35:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3895, 154, 'France', 'Paris', 'N/A', 'saturday', '16:35:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3896, 154, 'France', 'Paris', 'N/A', 'monday', '18:40:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3897, 154, 'France', 'Paris', 'N/A', 'tuesday', '18:15:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3898, 154, 'France', 'Paris', 'N/A', 'sunday', '17:00:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3899, 154, 'France', 'Paris', 'N/A', 'wednesday', '22:00:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3900, 154, 'France', 'Paris', 'N/A', 'saturday', '17:00:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3901, 154, 'France', 'Paris', 'N/A', 'monday', '19:05:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3902, 154, 'France', 'Paris', 'N/A', 'tuesday', '18:40:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3903, 154, 'France', 'Paris', 'N/A', 'sunday', '17:25:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3904, 154, 'France', 'Paris', 'N/A', 'saturday', '17:25:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3905, 154, 'France', 'Paris', 'N/A', 'wednesday', '22:25:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3906, 154, 'France', 'Paris', 'N/A', 'monday', '19:30:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3907, 154, 'France', 'Paris', 'N/A', 'tuesday', '19:05:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3908, 154, 'France', 'Paris', 'N/A', 'sunday', '17:50:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3909, 154, 'France', 'Paris', 'N/A', 'wednesday', '22:50:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3910, 154, 'France', 'Paris', 'N/A', 'saturday', '17:50:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3911, 154, 'France', 'Paris', 'N/A', 'monday', '19:55:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3912, 154, 'France', 'Paris', 'N/A', 'tuesday', '19:30:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3913, 154, 'France', 'Paris', 'N/A', 'sunday', '18:15:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3914, 154, 'France', 'Paris', 'N/A', 'wednesday', '23:15:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3915, 154, 'France', 'Paris', 'N/A', 'saturday', '18:15:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3916, 154, 'France', 'Paris', 'N/A', 'monday', '20:20:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3917, 154, 'France', 'Paris', 'N/A', 'tuesday', '19:55:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3918, 154, 'France', 'Paris', 'N/A', 'wednesday', '23:40:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3919, 154, 'France', 'Paris', 'N/A', 'sunday', '18:40:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3920, 154, 'France', 'Paris', 'N/A', 'saturday', '18:40:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3921, 154, 'France', 'Paris', 'N/A', 'tuesday', '20:20:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3922, 154, 'France', 'Paris', 'N/A', 'monday', '20:45:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3923, 154, 'France', 'Paris', 'N/A', 'sunday', '19:05:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3924, 154, 'France', 'Paris', 'N/A', 'saturday', '19:05:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3925, 154, 'France', 'Paris', 'N/A', 'tuesday', '20:45:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3926, 154, 'France', 'Paris', 'N/A', 'monday', '21:10:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3927, 154, 'France', 'Paris', 'N/A', 'sunday', '19:30:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3928, 154, 'France', 'Paris', 'N/A', 'saturday', '19:30:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3929, 154, 'France', 'Paris', 'N/A', 'tuesday', '21:10:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3930, 154, 'France', 'Paris', 'N/A', 'monday', '21:35:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3931, 154, 'France', 'Paris', 'N/A', 'tuesday', '21:35:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3932, 154, 'France', 'Paris', 'N/A', 'monday', '22:00:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3933, 154, 'France', 'Paris', 'N/A', 'tuesday', '22:00:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3934, 154, 'France', 'Paris', 'N/A', 'monday', '22:25:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3935, 154, 'France', 'Paris', 'N/A', 'monday', '22:50:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3936, 154, 'France', 'Paris', 'N/A', 'tuesday', '22:25:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3937, 154, 'France', 'Paris', 'N/A', 'sunday', '19:55:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3938, 154, 'France', 'Paris', 'N/A', 'saturday', '19:55:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3939, 154, 'France', 'Paris', 'N/A', 'monday', '23:15:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3940, 154, 'France', 'Paris', 'N/A', 'tuesday', '22:50:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3941, 154, 'France', 'Paris', 'N/A', 'saturday', '20:20:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3942, 154, 'France', 'Paris', 'N/A', 'sunday', '20:20:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3943, 154, 'France', 'Paris', 'N/A', 'tuesday', '23:15:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3944, 154, 'France', 'Paris', 'N/A', 'monday', '23:40:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3945, 154, 'France', 'Paris', 'N/A', 'saturday', '20:45:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3946, 154, 'France', 'Paris', 'N/A', 'sunday', '20:45:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3947, 154, 'France', 'Paris', 'N/A', 'tuesday', '23:40:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3948, 154, 'France', 'Paris', 'N/A', 'sunday', '21:10:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3949, 154, 'France', 'Paris', 'N/A', 'saturday', '21:10:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3950, 154, 'France', 'Paris', 'N/A', 'sunday', '21:35:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3951, 154, 'France', 'Paris', 'N/A', 'sunday', '22:00:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3952, 154, 'France', 'Paris', 'N/A', 'saturday', '21:35:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3953, 154, 'France', 'Paris', 'N/A', 'sunday', '22:25:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3954, 154, 'France', 'Paris', 'N/A', 'saturday', '22:00:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3955, 154, 'France', 'Paris', 'N/A', 'sunday', '22:50:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3956, 154, 'France', 'Paris', 'N/A', 'saturday', '22:25:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3957, 154, 'France', 'Paris', 'N/A', 'sunday', '23:15:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3958, 154, 'France', 'Paris', 'N/A', 'saturday', '22:50:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3959, 154, 'France', 'Paris', 'N/A', 'sunday', '23:40:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3960, 154, 'France', 'Paris', 'N/A', 'saturday', '23:15:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3961, 154, 'France', 'Paris', 'N/A', 'saturday', '23:40:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3962, 154, 'France', 'Paris', 'N/A', 'thursday', '12:00:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3963, 154, 'France', 'Paris', 'N/A', 'thursday', '12:25:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3964, 154, 'France', 'Paris', 'N/A', 'thursday', '12:50:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3965, 154, 'France', 'Paris', 'N/A', 'thursday', '13:15:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3966, 154, 'France', 'Paris', 'N/A', 'thursday', '13:40:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3967, 154, 'France', 'Paris', 'N/A', 'thursday', '14:05:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3968, 154, 'France', 'Paris', 'N/A', 'thursday', '14:30:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3969, 154, 'France', 'Paris', 'N/A', 'thursday', '14:55:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3970, 154, 'France', 'Paris', 'N/A', 'thursday', '15:20:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3971, 154, 'France', 'Paris', 'N/A', 'thursday', '15:45:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3972, 154, 'France', 'Paris', 'N/A', 'thursday', '16:10:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3973, 154, 'France', 'Paris', 'N/A', 'thursday', '16:35:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3974, 154, 'France', 'Paris', 'N/A', 'thursday', '17:00:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3975, 154, 'France', 'Paris', 'N/A', 'thursday', '17:25:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3976, 154, 'France', 'Paris', 'N/A', 'thursday', '17:50:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3977, 154, 'France', 'Paris', 'N/A', 'thursday', '18:15:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3978, 154, 'France', 'Paris', 'N/A', 'thursday', '18:40:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3979, 154, 'France', 'Paris', 'N/A', 'thursday', '19:05:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3980, 154, 'France', 'Paris', 'N/A', 'thursday', '19:30:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3981, 154, 'France', 'Paris', 'N/A', 'thursday', '19:55:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3982, 154, 'France', 'Paris', 'N/A', 'thursday', '20:20:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3983, 154, 'France', 'Paris', 'N/A', 'thursday', '20:45:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3984, 154, 'France', 'Paris', 'N/A', 'thursday', '21:10:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3985, 154, 'France', 'Paris', 'N/A', 'thursday', '21:35:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3986, 154, 'France', 'Paris', 'N/A', 'thursday', '22:00:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3987, 154, 'France', 'Paris', 'N/A', 'thursday', '22:25:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3988, 154, 'France', 'Paris', 'N/A', 'thursday', '22:50:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3989, 154, 'France', 'Paris', 'N/A', 'thursday', '23:15:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3990, 154, 'France', 'Paris', 'N/A', 'thursday', '23:40:00', 24, '2024-09-03 04:43:00', '2024-09-03 04:43:00'),
(3991, 155, 'France', 'Paris', 'N/A', 'tuesday', '12:00:00', 24, '2024-09-03 04:43:33', '2024-09-03 04:43:33'),
(3992, 155, 'France', 'Paris', 'N/A', 'tuesday', '12:25:00', 24, '2024-09-03 04:43:33', '2024-09-03 04:43:33'),
(3993, 155, 'France', 'Paris', 'N/A', 'tuesday', '12:50:00', 24, '2024-09-03 04:43:33', '2024-09-03 04:43:33'),
(3994, 155, 'France', 'Paris', 'N/A', 'tuesday', '13:15:00', 24, '2024-09-03 04:43:33', '2024-09-03 04:43:33'),
(3995, 155, 'France', 'Paris', 'N/A', 'tuesday', '13:40:00', 24, '2024-09-03 04:43:33', '2024-09-03 04:43:33'),
(3996, 155, 'France', 'Paris', 'N/A', 'tuesday', '14:05:00', 24, '2024-09-03 04:43:33', '2024-09-03 04:43:33'),
(3997, 155, 'France', 'Paris', 'N/A', 'tuesday', '14:30:00', 24, '2024-09-03 04:43:33', '2024-09-03 04:43:33'),
(3998, 155, 'France', 'Paris', 'N/A', 'tuesday', '14:55:00', 24, '2024-09-03 04:43:33', '2024-09-03 04:43:33'),
(3999, 155, 'France', 'Paris', 'N/A', 'tuesday', '15:20:00', 24, '2024-09-03 04:43:33', '2024-09-03 04:43:33'),
(4000, 155, 'France', 'Paris', 'N/A', 'tuesday', '15:45:00', 24, '2024-09-03 04:43:33', '2024-09-03 04:43:33'),
(4001, 155, 'France', 'Paris', 'N/A', 'tuesday', '16:10:00', 24, '2024-09-03 04:43:33', '2024-09-03 04:43:33'),
(4002, 155, 'France', 'Paris', 'N/A', 'tuesday', '16:35:00', 24, '2024-09-03 04:43:33', '2024-09-03 04:43:33'),
(4003, 155, 'France', 'Paris', 'N/A', 'tuesday', '17:00:00', 24, '2024-09-03 04:43:33', '2024-09-03 04:43:33'),
(4004, 155, 'France', 'Paris', 'N/A', 'tuesday', '17:25:00', 24, '2024-09-03 04:43:33', '2024-09-03 04:43:33'),
(4005, 155, 'France', 'Paris', 'N/A', 'tuesday', '17:50:00', 24, '2024-09-03 04:43:33', '2024-09-03 04:43:33'),
(4006, 155, 'France', 'Paris', 'N/A', 'tuesday', '18:15:00', 24, '2024-09-03 04:43:33', '2024-09-03 04:43:33'),
(4007, 155, 'France', 'Paris', 'N/A', 'tuesday', '18:40:00', 24, '2024-09-03 04:43:33', '2024-09-03 04:43:33'),
(4008, 155, 'France', 'Paris', 'N/A', 'tuesday', '19:05:00', 24, '2024-09-03 04:43:33', '2024-09-03 04:43:33'),
(4009, 155, 'France', 'Paris', 'N/A', 'tuesday', '19:30:00', 24, '2024-09-03 04:43:33', '2024-09-03 04:43:33'),
(4010, 155, 'France', 'Paris', 'N/A', 'tuesday', '19:55:00', 24, '2024-09-03 04:43:33', '2024-09-03 04:43:33'),
(4011, 155, 'France', 'Paris', 'N/A', 'tuesday', '20:20:00', 24, '2024-09-03 04:43:33', '2024-09-03 04:43:33'),
(4012, 155, 'France', 'Paris', 'N/A', 'tuesday', '20:45:00', 24, '2024-09-03 04:43:33', '2024-09-03 04:43:33'),
(4013, 155, 'France', 'Paris', 'N/A', 'tuesday', '21:10:00', 24, '2024-09-03 04:43:33', '2024-09-03 04:43:33'),
(4014, 155, 'France', 'Paris', 'N/A', 'tuesday', '21:35:00', 24, '2024-09-03 04:43:33', '2024-09-03 04:43:33'),
(4015, 155, 'France', 'Paris', 'N/A', 'tuesday', '22:00:00', 24, '2024-09-03 04:43:33', '2024-09-03 04:43:33'),
(4016, 155, 'France', 'Paris', 'N/A', 'tuesday', '22:25:00', 24, '2024-09-03 04:43:33', '2024-09-03 04:43:33'),
(4017, 155, 'France', 'Paris', 'N/A', 'tuesday', '22:50:00', 24, '2024-09-03 04:43:33', '2024-09-03 04:43:33'),
(4018, 155, 'France', 'Paris', 'N/A', 'wednesday', '12:00:00', 24, '2024-09-03 04:43:33', '2024-09-03 04:43:33'),
(4019, 155, 'France', 'Paris', 'N/A', 'wednesday', '12:25:00', 24, '2024-09-03 04:43:33', '2024-09-03 04:43:33'),
(4020, 155, 'France', 'Paris', 'N/A', 'wednesday', '12:50:00', 24, '2024-09-03 04:43:33', '2024-09-03 04:43:33'),
(4021, 155, 'France', 'Paris', 'N/A', 'wednesday', '13:15:00', 24, '2024-09-03 04:43:33', '2024-09-03 04:43:33'),
(4022, 155, 'France', 'Paris', 'N/A', 'wednesday', '13:40:00', 24, '2024-09-03 04:43:33', '2024-09-03 04:43:33'),
(4023, 155, 'France', 'Paris', 'N/A', 'wednesday', '14:05:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4024, 155, 'France', 'Paris', 'N/A', 'wednesday', '14:30:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4025, 155, 'France', 'Paris', 'N/A', 'wednesday', '14:55:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4026, 155, 'France', 'Paris', 'N/A', 'wednesday', '15:20:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4027, 155, 'France', 'Paris', 'N/A', 'wednesday', '15:45:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4028, 155, 'France', 'Paris', 'N/A', 'wednesday', '16:10:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4029, 155, 'France', 'Paris', 'N/A', 'wednesday', '16:35:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4030, 155, 'France', 'Paris', 'N/A', 'wednesday', '17:00:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4031, 155, 'France', 'Paris', 'N/A', 'wednesday', '17:25:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4032, 155, 'France', 'Paris', 'N/A', 'wednesday', '17:50:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4033, 155, 'France', 'Paris', 'N/A', 'wednesday', '18:15:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4034, 155, 'France', 'Paris', 'N/A', 'wednesday', '18:40:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4035, 155, 'France', 'Paris', 'N/A', 'wednesday', '19:05:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4036, 155, 'France', 'Paris', 'N/A', 'wednesday', '19:30:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4037, 155, 'France', 'Paris', 'N/A', 'wednesday', '19:55:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4038, 155, 'France', 'Paris', 'N/A', 'wednesday', '20:20:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4039, 155, 'France', 'Paris', 'N/A', 'wednesday', '20:45:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4040, 155, 'France', 'Paris', 'N/A', 'wednesday', '21:10:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4041, 155, 'France', 'Paris', 'N/A', 'wednesday', '21:35:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4042, 155, 'France', 'Paris', 'N/A', 'wednesday', '22:00:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4043, 155, 'France', 'Paris', 'N/A', 'wednesday', '22:25:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4044, 155, 'France', 'Paris', 'N/A', 'wednesday', '22:50:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4045, 155, 'France', 'Paris', 'N/A', 'friday', '12:00:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4046, 155, 'France', 'Paris', 'N/A', 'friday', '12:25:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4047, 155, 'France', 'Paris', 'N/A', 'friday', '12:50:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4048, 155, 'France', 'Paris', 'N/A', 'friday', '13:15:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4049, 155, 'France', 'Paris', 'N/A', 'friday', '13:40:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4050, 155, 'France', 'Paris', 'N/A', 'friday', '14:05:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4051, 155, 'France', 'Paris', 'N/A', 'monday', '12:00:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4052, 155, 'France', 'Paris', 'N/A', 'friday', '14:30:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4053, 155, 'France', 'Paris', 'N/A', 'monday', '12:25:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4054, 155, 'France', 'Paris', 'N/A', 'friday', '14:55:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4055, 155, 'France', 'Paris', 'N/A', 'friday', '15:20:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4056, 155, 'France', 'Paris', 'N/A', 'friday', '15:45:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4057, 155, 'France', 'Paris', 'N/A', 'friday', '16:10:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4058, 155, 'France', 'Paris', 'N/A', 'friday', '16:35:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4059, 155, 'France', 'Paris', 'N/A', 'friday', '17:00:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4060, 155, 'France', 'Paris', 'N/A', 'friday', '17:25:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4061, 155, 'France', 'Paris', 'N/A', 'friday', '17:50:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4062, 155, 'France', 'Paris', 'N/A', 'friday', '18:15:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4063, 155, 'France', 'Paris', 'N/A', 'friday', '18:40:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4064, 155, 'France', 'Paris', 'N/A', 'friday', '19:05:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4065, 155, 'France', 'Paris', 'N/A', 'friday', '19:30:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4066, 155, 'France', 'Paris', 'N/A', 'friday', '19:55:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4067, 155, 'France', 'Paris', 'N/A', 'friday', '20:20:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4068, 155, 'France', 'Paris', 'N/A', 'monday', '12:50:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4069, 155, 'France', 'Paris', 'N/A', 'friday', '20:45:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4070, 155, 'France', 'Paris', 'N/A', 'monday', '13:15:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4071, 155, 'France', 'Paris', 'N/A', 'friday', '21:10:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4072, 155, 'France', 'Paris', 'N/A', 'friday', '21:35:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4073, 155, 'France', 'Paris', 'N/A', 'friday', '22:00:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4074, 155, 'France', 'Paris', 'N/A', 'friday', '22:25:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4075, 155, 'France', 'Paris', 'N/A', 'friday', '22:50:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4076, 155, 'France', 'Paris', 'N/A', 'monday', '13:40:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4077, 155, 'France', 'Paris', 'N/A', 'monday', '14:05:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4078, 155, 'France', 'Paris', 'N/A', 'monday', '14:30:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4079, 155, 'France', 'Paris', 'N/A', 'monday', '14:55:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4080, 155, 'France', 'Paris', 'N/A', 'thursday', '12:00:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4081, 155, 'France', 'Paris', 'N/A', 'thursday', '12:25:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4082, 155, 'France', 'Paris', 'N/A', 'monday', '15:20:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4083, 155, 'France', 'Paris', 'N/A', 'monday', '15:45:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4084, 155, 'France', 'Paris', 'N/A', 'thursday', '12:50:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4085, 155, 'France', 'Paris', 'N/A', 'monday', '16:10:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4086, 155, 'France', 'Paris', 'N/A', 'thursday', '13:15:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4087, 155, 'France', 'Paris', 'N/A', 'monday', '16:35:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4088, 155, 'France', 'Paris', 'N/A', 'thursday', '13:40:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4089, 155, 'France', 'Paris', 'N/A', 'monday', '17:00:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4090, 155, 'France', 'Paris', 'N/A', 'monday', '17:25:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4091, 155, 'France', 'Paris', 'N/A', 'thursday', '14:05:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4092, 155, 'France', 'Paris', 'N/A', 'sunday', '12:00:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4093, 155, 'France', 'Paris', 'N/A', 'monday', '17:50:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4094, 155, 'France', 'Paris', 'N/A', 'sunday', '12:25:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4095, 155, 'France', 'Paris', 'N/A', 'thursday', '14:30:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4096, 155, 'France', 'Paris', 'N/A', 'monday', '18:15:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4097, 155, 'France', 'Paris', 'N/A', 'thursday', '14:55:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4098, 155, 'France', 'Paris', 'N/A', 'sunday', '12:50:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4099, 155, 'France', 'Paris', 'N/A', 'monday', '18:40:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4100, 155, 'France', 'Paris', 'N/A', 'sunday', '13:15:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4101, 155, 'France', 'Paris', 'N/A', 'thursday', '15:20:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4102, 155, 'France', 'Paris', 'N/A', 'monday', '19:05:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4103, 155, 'France', 'Paris', 'N/A', 'sunday', '13:40:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4104, 155, 'France', 'Paris', 'N/A', 'thursday', '15:45:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4105, 155, 'France', 'Paris', 'N/A', 'monday', '19:30:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34');
INSERT INTO `restaurant_business_hours` (`id`, `restaurant_id`, `country`, `city`, `shift_name`, `day_of_week`, `slot_time`, `added_by`, `created_at`, `updated_at`) VALUES
(4106, 155, 'France', 'Paris', 'N/A', 'sunday', '14:05:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4107, 155, 'France', 'Paris', 'N/A', 'thursday', '16:10:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4108, 155, 'France', 'Paris', 'N/A', 'monday', '19:55:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4109, 155, 'France', 'Paris', 'N/A', 'sunday', '14:30:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4110, 155, 'France', 'Paris', 'N/A', 'monday', '20:20:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4111, 155, 'France', 'Paris', 'N/A', 'thursday', '16:35:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4112, 155, 'France', 'Paris', 'N/A', 'sunday', '14:55:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4113, 155, 'France', 'Paris', 'N/A', 'monday', '20:45:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4114, 155, 'France', 'Paris', 'N/A', 'thursday', '17:00:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4115, 155, 'France', 'Paris', 'N/A', 'saturday', '12:00:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4116, 155, 'France', 'Paris', 'N/A', 'sunday', '15:20:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4117, 155, 'France', 'Paris', 'N/A', 'saturday', '12:25:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4118, 155, 'France', 'Paris', 'N/A', 'monday', '21:10:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4119, 155, 'France', 'Paris', 'N/A', 'saturday', '12:50:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4120, 155, 'France', 'Paris', 'N/A', 'thursday', '17:25:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4121, 155, 'France', 'Paris', 'N/A', 'monday', '21:35:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4122, 155, 'France', 'Paris', 'N/A', 'sunday', '15:45:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4123, 155, 'France', 'Paris', 'N/A', 'saturday', '13:15:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4124, 155, 'France', 'Paris', 'N/A', 'monday', '22:00:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4125, 155, 'France', 'Paris', 'N/A', 'sunday', '16:10:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4126, 155, 'France', 'Paris', 'N/A', 'thursday', '17:50:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4127, 155, 'France', 'Paris', 'N/A', 'monday', '22:25:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4128, 155, 'France', 'Paris', 'N/A', 'thursday', '18:15:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4129, 155, 'France', 'Paris', 'N/A', 'saturday', '13:40:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4130, 155, 'France', 'Paris', 'N/A', 'sunday', '16:35:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4131, 155, 'France', 'Paris', 'N/A', 'monday', '22:50:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4132, 155, 'France', 'Paris', 'N/A', 'thursday', '18:40:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4133, 155, 'France', 'Paris', 'N/A', 'sunday', '17:00:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4134, 155, 'France', 'Paris', 'N/A', 'saturday', '14:05:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4135, 155, 'France', 'Paris', 'N/A', 'thursday', '19:05:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4136, 155, 'France', 'Paris', 'N/A', 'saturday', '14:30:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4137, 155, 'France', 'Paris', 'N/A', 'sunday', '17:25:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4138, 155, 'France', 'Paris', 'N/A', 'thursday', '19:30:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4139, 155, 'France', 'Paris', 'N/A', 'saturday', '14:55:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4140, 155, 'France', 'Paris', 'N/A', 'sunday', '17:50:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4141, 155, 'France', 'Paris', 'N/A', 'thursday', '19:55:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4142, 155, 'France', 'Paris', 'N/A', 'saturday', '15:20:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4143, 155, 'France', 'Paris', 'N/A', 'thursday', '20:20:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4144, 155, 'France', 'Paris', 'N/A', 'sunday', '18:15:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4145, 155, 'France', 'Paris', 'N/A', 'saturday', '15:45:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4146, 155, 'France', 'Paris', 'N/A', 'thursday', '20:45:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4147, 155, 'France', 'Paris', 'N/A', 'sunday', '18:40:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4148, 155, 'France', 'Paris', 'N/A', 'thursday', '21:10:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4149, 155, 'France', 'Paris', 'N/A', 'saturday', '16:10:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4150, 155, 'France', 'Paris', 'N/A', 'sunday', '19:05:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4151, 155, 'France', 'Paris', 'N/A', 'thursday', '21:35:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4152, 155, 'France', 'Paris', 'N/A', 'saturday', '16:35:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4153, 155, 'France', 'Paris', 'N/A', 'sunday', '19:30:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4154, 155, 'France', 'Paris', 'N/A', 'saturday', '17:00:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4155, 155, 'France', 'Paris', 'N/A', 'thursday', '22:00:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4156, 155, 'France', 'Paris', 'N/A', 'thursday', '22:25:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4157, 155, 'France', 'Paris', 'N/A', 'sunday', '19:55:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4158, 155, 'France', 'Paris', 'N/A', 'saturday', '17:25:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4159, 155, 'France', 'Paris', 'N/A', 'thursday', '22:50:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4160, 155, 'France', 'Paris', 'N/A', 'saturday', '17:50:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4161, 155, 'France', 'Paris', 'N/A', 'sunday', '20:20:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4162, 155, 'France', 'Paris', 'N/A', 'saturday', '18:15:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4163, 155, 'France', 'Paris', 'N/A', 'sunday', '20:45:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4164, 155, 'France', 'Paris', 'N/A', 'saturday', '18:40:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4165, 155, 'France', 'Paris', 'N/A', 'sunday', '21:10:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4166, 155, 'France', 'Paris', 'N/A', 'saturday', '19:05:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4167, 155, 'France', 'Paris', 'N/A', 'sunday', '21:35:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4168, 155, 'France', 'Paris', 'N/A', 'saturday', '19:30:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4169, 155, 'France', 'Paris', 'N/A', 'sunday', '22:00:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4170, 155, 'France', 'Paris', 'N/A', 'saturday', '19:55:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4171, 155, 'France', 'Paris', 'N/A', 'sunday', '22:25:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4172, 155, 'France', 'Paris', 'N/A', 'saturday', '20:20:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4173, 155, 'France', 'Paris', 'N/A', 'sunday', '22:50:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4174, 155, 'France', 'Paris', 'N/A', 'saturday', '20:45:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4175, 155, 'France', 'Paris', 'N/A', 'saturday', '21:10:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4176, 155, 'France', 'Paris', 'N/A', 'saturday', '21:35:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4177, 155, 'France', 'Paris', 'N/A', 'saturday', '22:00:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4178, 155, 'France', 'Paris', 'N/A', 'saturday', '22:25:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4179, 155, 'France', 'Paris', 'N/A', 'saturday', '22:50:00', 24, '2024-09-03 04:43:34', '2024-09-03 04:43:34'),
(4180, 156, 'France', 'Paris', 'N/A', 'monday', '09:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4181, 156, 'France', 'Paris', 'N/A', 'monday', '09:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4182, 156, 'France', 'Paris', 'N/A', 'monday', '10:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4183, 156, 'France', 'Paris', 'N/A', 'monday', '10:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4184, 156, 'France', 'Paris', 'N/A', 'monday', '11:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4185, 156, 'France', 'Paris', 'N/A', 'wednesday', '09:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4186, 156, 'France', 'Paris', 'N/A', 'wednesday', '09:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4187, 156, 'France', 'Paris', 'N/A', 'monday', '11:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4188, 156, 'France', 'Paris', 'N/A', 'wednesday', '10:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4189, 156, 'France', 'Paris', 'N/A', 'monday', '12:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4190, 156, 'France', 'Paris', 'N/A', 'thursday', '09:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4191, 156, 'France', 'Paris', 'N/A', 'wednesday', '10:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4192, 156, 'France', 'Paris', 'N/A', 'monday', '12:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4193, 156, 'France', 'Paris', 'N/A', 'wednesday', '11:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4194, 156, 'France', 'Paris', 'N/A', 'thursday', '09:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4195, 156, 'France', 'Paris', 'N/A', 'monday', '13:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4196, 156, 'France', 'Paris', 'N/A', 'wednesday', '11:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4197, 156, 'France', 'Paris', 'N/A', 'thursday', '10:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4198, 156, 'France', 'Paris', 'N/A', 'monday', '13:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4199, 156, 'France', 'Paris', 'N/A', 'wednesday', '12:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4200, 156, 'France', 'Paris', 'N/A', 'thursday', '10:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4201, 156, 'France', 'Paris', 'N/A', 'monday', '14:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4202, 156, 'France', 'Paris', 'N/A', 'wednesday', '12:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4203, 156, 'France', 'Paris', 'N/A', 'thursday', '11:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4204, 156, 'France', 'Paris', 'N/A', 'monday', '14:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4205, 156, 'France', 'Paris', 'N/A', 'wednesday', '13:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4206, 156, 'France', 'Paris', 'N/A', 'thursday', '11:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4207, 156, 'France', 'Paris', 'N/A', 'tuesday', '09:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4208, 156, 'France', 'Paris', 'N/A', 'wednesday', '13:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4209, 156, 'France', 'Paris', 'N/A', 'monday', '15:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4210, 156, 'France', 'Paris', 'N/A', 'friday', '09:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4211, 156, 'France', 'Paris', 'N/A', 'tuesday', '09:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4212, 156, 'France', 'Paris', 'N/A', 'thursday', '12:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4213, 156, 'France', 'Paris', 'N/A', 'tuesday', '10:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4214, 156, 'France', 'Paris', 'N/A', 'thursday', '12:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4215, 156, 'France', 'Paris', 'N/A', 'wednesday', '14:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4216, 156, 'France', 'Paris', 'N/A', 'monday', '15:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4217, 156, 'France', 'Paris', 'N/A', 'friday', '09:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4218, 156, 'France', 'Paris', 'N/A', 'monday', '16:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4219, 156, 'France', 'Paris', 'N/A', 'thursday', '13:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4220, 156, 'France', 'Paris', 'N/A', 'wednesday', '14:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4221, 156, 'France', 'Paris', 'N/A', 'tuesday', '10:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4222, 156, 'France', 'Paris', 'N/A', 'friday', '10:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4223, 156, 'France', 'Paris', 'N/A', 'thursday', '13:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4224, 156, 'France', 'Paris', 'N/A', 'wednesday', '15:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4225, 156, 'France', 'Paris', 'N/A', 'tuesday', '11:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4226, 156, 'France', 'Paris', 'N/A', 'friday', '10:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4227, 156, 'France', 'Paris', 'N/A', 'wednesday', '15:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4228, 156, 'France', 'Paris', 'N/A', 'thursday', '14:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4229, 156, 'France', 'Paris', 'N/A', 'tuesday', '11:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4230, 156, 'France', 'Paris', 'N/A', 'wednesday', '16:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4231, 156, 'France', 'Paris', 'N/A', 'friday', '11:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4232, 156, 'France', 'Paris', 'N/A', 'thursday', '14:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4233, 156, 'France', 'Paris', 'N/A', 'tuesday', '12:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4234, 156, 'France', 'Paris', 'N/A', 'friday', '11:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4235, 156, 'France', 'Paris', 'N/A', 'thursday', '15:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4236, 156, 'France', 'Paris', 'N/A', 'tuesday', '12:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4237, 156, 'France', 'Paris', 'N/A', 'friday', '12:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4238, 156, 'France', 'Paris', 'N/A', 'sunday', '09:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4239, 156, 'France', 'Paris', 'N/A', 'thursday', '15:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4240, 156, 'France', 'Paris', 'N/A', 'tuesday', '13:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4241, 156, 'France', 'Paris', 'N/A', 'friday', '12:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4242, 156, 'France', 'Paris', 'N/A', 'tuesday', '13:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4243, 156, 'France', 'Paris', 'N/A', 'thursday', '16:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4244, 156, 'France', 'Paris', 'N/A', 'sunday', '09:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4245, 156, 'France', 'Paris', 'N/A', 'friday', '13:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4246, 156, 'France', 'Paris', 'N/A', 'tuesday', '14:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4247, 156, 'France', 'Paris', 'N/A', 'saturday', '09:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4248, 156, 'France', 'Paris', 'N/A', 'sunday', '10:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4249, 156, 'France', 'Paris', 'N/A', 'tuesday', '14:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4250, 156, 'France', 'Paris', 'N/A', 'saturday', '09:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4251, 156, 'France', 'Paris', 'N/A', 'friday', '13:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4252, 156, 'France', 'Paris', 'N/A', 'friday', '14:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4253, 156, 'France', 'Paris', 'N/A', 'saturday', '10:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4254, 156, 'France', 'Paris', 'N/A', 'sunday', '10:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4255, 156, 'France', 'Paris', 'N/A', 'tuesday', '15:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4256, 156, 'France', 'Paris', 'N/A', 'friday', '14:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4257, 156, 'France', 'Paris', 'N/A', 'tuesday', '15:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4258, 156, 'France', 'Paris', 'N/A', 'saturday', '10:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4259, 156, 'France', 'Paris', 'N/A', 'sunday', '11:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4260, 156, 'France', 'Paris', 'N/A', 'friday', '15:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4261, 156, 'France', 'Paris', 'N/A', 'tuesday', '16:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4262, 156, 'France', 'Paris', 'N/A', 'sunday', '11:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4263, 156, 'France', 'Paris', 'N/A', 'saturday', '11:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4264, 156, 'France', 'Paris', 'N/A', 'friday', '15:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4265, 156, 'France', 'Paris', 'N/A', 'sunday', '12:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4266, 156, 'France', 'Paris', 'N/A', 'saturday', '11:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4267, 156, 'France', 'Paris', 'N/A', 'sunday', '12:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4268, 156, 'France', 'Paris', 'N/A', 'friday', '16:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4269, 156, 'France', 'Paris', 'N/A', 'saturday', '12:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4270, 156, 'France', 'Paris', 'N/A', 'sunday', '13:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4271, 156, 'France', 'Paris', 'N/A', 'saturday', '12:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4272, 156, 'France', 'Paris', 'N/A', 'sunday', '13:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4273, 156, 'France', 'Paris', 'N/A', 'saturday', '13:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4274, 156, 'France', 'Paris', 'N/A', 'sunday', '14:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4275, 156, 'France', 'Paris', 'N/A', 'saturday', '13:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4276, 156, 'France', 'Paris', 'N/A', 'sunday', '14:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4277, 156, 'France', 'Paris', 'N/A', 'saturday', '14:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4278, 156, 'France', 'Paris', 'N/A', 'sunday', '15:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4279, 156, 'France', 'Paris', 'N/A', 'saturday', '14:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4280, 156, 'France', 'Paris', 'N/A', 'sunday', '15:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4281, 156, 'France', 'Paris', 'N/A', 'saturday', '15:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4282, 156, 'France', 'Paris', 'N/A', 'sunday', '16:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4283, 156, 'France', 'Paris', 'N/A', 'saturday', '15:30:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4284, 156, 'France', 'Paris', 'N/A', 'saturday', '16:00:00', 24, '2024-09-03 04:44:27', '2024-09-03 04:44:27'),
(4285, 157, 'France', 'Paris', 'N/A', 'monday', '12:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4286, 157, 'France', 'Paris', 'N/A', 'monday', '12:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4287, 157, 'France', 'Paris', 'N/A', 'tuesday', '12:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4288, 157, 'France', 'Paris', 'N/A', 'monday', '13:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4289, 157, 'France', 'Paris', 'N/A', 'monday', '13:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4290, 157, 'France', 'Paris', 'N/A', 'tuesday', '12:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4291, 157, 'France', 'Paris', 'N/A', 'monday', '14:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4292, 157, 'France', 'Paris', 'N/A', 'tuesday', '13:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4293, 157, 'France', 'Paris', 'N/A', 'monday', '14:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4294, 157, 'France', 'Paris', 'N/A', 'tuesday', '13:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4295, 157, 'France', 'Paris', 'N/A', 'monday', '15:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4296, 157, 'France', 'Paris', 'N/A', 'tuesday', '14:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4297, 157, 'France', 'Paris', 'N/A', 'monday', '15:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4298, 157, 'France', 'Paris', 'N/A', 'monday', '16:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4299, 157, 'France', 'Paris', 'N/A', 'monday', '16:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4300, 157, 'France', 'Paris', 'N/A', 'tuesday', '14:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4301, 157, 'France', 'Paris', 'N/A', 'monday', '17:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4302, 157, 'France', 'Paris', 'N/A', 'monday', '17:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4303, 157, 'France', 'Paris', 'N/A', 'tuesday', '15:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4304, 157, 'France', 'Paris', 'N/A', 'monday', '18:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4305, 157, 'France', 'Paris', 'N/A', 'monday', '18:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4306, 157, 'France', 'Paris', 'N/A', 'tuesday', '15:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4307, 157, 'France', 'Paris', 'N/A', 'monday', '19:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4308, 157, 'France', 'Paris', 'N/A', 'monday', '19:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4309, 157, 'France', 'Paris', 'N/A', 'tuesday', '16:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4310, 157, 'France', 'Paris', 'N/A', 'monday', '20:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4311, 157, 'France', 'Paris', 'N/A', 'tuesday', '16:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4312, 157, 'France', 'Paris', 'N/A', 'monday', '20:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4313, 157, 'France', 'Paris', 'N/A', 'tuesday', '17:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4314, 157, 'France', 'Paris', 'N/A', 'monday', '21:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4315, 157, 'France', 'Paris', 'N/A', 'tuesday', '17:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4316, 157, 'France', 'Paris', 'N/A', 'tuesday', '18:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4317, 157, 'France', 'Paris', 'N/A', 'monday', '21:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4318, 157, 'France', 'Paris', 'N/A', 'tuesday', '18:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4319, 157, 'France', 'Paris', 'N/A', 'tuesday', '19:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4320, 157, 'France', 'Paris', 'N/A', 'monday', '22:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4321, 157, 'France', 'Paris', 'N/A', 'tuesday', '19:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4322, 157, 'France', 'Paris', 'N/A', 'tuesday', '20:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4323, 157, 'France', 'Paris', 'N/A', 'tuesday', '20:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4324, 157, 'France', 'Paris', 'N/A', 'tuesday', '21:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4325, 157, 'France', 'Paris', 'N/A', 'tuesday', '21:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4326, 157, 'France', 'Paris', 'N/A', 'tuesday', '22:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4327, 157, 'France', 'Paris', 'N/A', 'friday', '12:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4328, 157, 'France', 'Paris', 'N/A', 'friday', '12:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4329, 157, 'France', 'Paris', 'N/A', 'friday', '13:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4330, 157, 'France', 'Paris', 'N/A', 'friday', '13:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4331, 157, 'France', 'Paris', 'N/A', 'friday', '14:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4332, 157, 'France', 'Paris', 'N/A', 'friday', '14:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4333, 157, 'France', 'Paris', 'N/A', 'friday', '15:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4334, 157, 'France', 'Paris', 'N/A', 'friday', '15:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4335, 157, 'France', 'Paris', 'N/A', 'friday', '16:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4336, 157, 'France', 'Paris', 'N/A', 'friday', '16:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4337, 157, 'France', 'Paris', 'N/A', 'friday', '17:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4338, 157, 'France', 'Paris', 'N/A', 'friday', '17:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4339, 157, 'France', 'Paris', 'N/A', 'friday', '18:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4340, 157, 'France', 'Paris', 'N/A', 'friday', '18:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4341, 157, 'France', 'Paris', 'N/A', 'friday', '19:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4342, 157, 'France', 'Paris', 'N/A', 'sunday', '12:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4343, 157, 'France', 'Paris', 'N/A', 'friday', '19:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4344, 157, 'France', 'Paris', 'N/A', 'sunday', '12:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4345, 157, 'France', 'Paris', 'N/A', 'wednesday', '12:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4346, 157, 'France', 'Paris', 'N/A', 'friday', '20:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4347, 157, 'France', 'Paris', 'N/A', 'sunday', '13:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4348, 157, 'France', 'Paris', 'N/A', 'friday', '20:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4349, 157, 'France', 'Paris', 'N/A', 'wednesday', '12:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4350, 157, 'France', 'Paris', 'N/A', 'sunday', '13:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4351, 157, 'France', 'Paris', 'N/A', 'wednesday', '13:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4352, 157, 'France', 'Paris', 'N/A', 'friday', '21:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4353, 157, 'France', 'Paris', 'N/A', 'sunday', '14:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4354, 157, 'France', 'Paris', 'N/A', 'wednesday', '13:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4355, 157, 'France', 'Paris', 'N/A', 'friday', '21:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4356, 157, 'France', 'Paris', 'N/A', 'sunday', '14:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4357, 157, 'France', 'Paris', 'N/A', 'wednesday', '14:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4358, 157, 'France', 'Paris', 'N/A', 'friday', '22:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4359, 157, 'France', 'Paris', 'N/A', 'sunday', '15:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4360, 157, 'France', 'Paris', 'N/A', 'wednesday', '14:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4361, 157, 'France', 'Paris', 'N/A', 'sunday', '15:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4362, 157, 'France', 'Paris', 'N/A', 'wednesday', '15:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4363, 157, 'France', 'Paris', 'N/A', 'sunday', '16:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4364, 157, 'France', 'Paris', 'N/A', 'sunday', '16:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4365, 157, 'France', 'Paris', 'N/A', 'wednesday', '15:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4366, 157, 'France', 'Paris', 'N/A', 'sunday', '17:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4367, 157, 'France', 'Paris', 'N/A', 'wednesday', '16:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4368, 157, 'France', 'Paris', 'N/A', 'sunday', '17:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4369, 157, 'France', 'Paris', 'N/A', 'wednesday', '16:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4370, 157, 'France', 'Paris', 'N/A', 'sunday', '18:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4371, 157, 'France', 'Paris', 'N/A', 'wednesday', '17:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4372, 157, 'France', 'Paris', 'N/A', 'sunday', '18:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4373, 157, 'France', 'Paris', 'N/A', 'wednesday', '17:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4374, 157, 'France', 'Paris', 'N/A', 'sunday', '19:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4375, 157, 'France', 'Paris', 'N/A', 'wednesday', '18:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4376, 157, 'France', 'Paris', 'N/A', 'sunday', '19:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4377, 157, 'France', 'Paris', 'N/A', 'wednesday', '18:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4378, 157, 'France', 'Paris', 'N/A', 'sunday', '20:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4379, 157, 'France', 'Paris', 'N/A', 'wednesday', '19:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4380, 157, 'France', 'Paris', 'N/A', 'sunday', '20:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4381, 157, 'France', 'Paris', 'N/A', 'wednesday', '19:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4382, 157, 'France', 'Paris', 'N/A', 'sunday', '21:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4383, 157, 'France', 'Paris', 'N/A', 'wednesday', '20:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4384, 157, 'France', 'Paris', 'N/A', 'sunday', '21:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4385, 157, 'France', 'Paris', 'N/A', 'wednesday', '20:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4386, 157, 'France', 'Paris', 'N/A', 'sunday', '22:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4387, 157, 'France', 'Paris', 'N/A', 'wednesday', '21:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4388, 157, 'France', 'Paris', 'N/A', 'saturday', '12:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4389, 157, 'France', 'Paris', 'N/A', 'wednesday', '21:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4390, 157, 'France', 'Paris', 'N/A', 'saturday', '12:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4391, 157, 'France', 'Paris', 'N/A', 'wednesday', '22:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4392, 157, 'France', 'Paris', 'N/A', 'saturday', '13:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4393, 157, 'France', 'Paris', 'N/A', 'saturday', '13:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4394, 157, 'France', 'Paris', 'N/A', 'saturday', '14:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4395, 157, 'France', 'Paris', 'N/A', 'saturday', '14:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4396, 157, 'France', 'Paris', 'N/A', 'saturday', '15:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4397, 157, 'France', 'Paris', 'N/A', 'saturday', '15:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4398, 157, 'France', 'Paris', 'N/A', 'saturday', '16:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4399, 157, 'France', 'Paris', 'N/A', 'saturday', '16:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4400, 157, 'France', 'Paris', 'N/A', 'saturday', '17:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4401, 157, 'France', 'Paris', 'N/A', 'saturday', '17:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4402, 157, 'France', 'Paris', 'N/A', 'saturday', '18:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4403, 157, 'France', 'Paris', 'N/A', 'saturday', '18:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4404, 157, 'France', 'Paris', 'N/A', 'saturday', '19:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4405, 157, 'France', 'Paris', 'N/A', 'saturday', '19:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4406, 157, 'France', 'Paris', 'N/A', 'saturday', '20:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4407, 157, 'France', 'Paris', 'N/A', 'saturday', '20:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4408, 157, 'France', 'Paris', 'N/A', 'saturday', '21:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4409, 157, 'France', 'Paris', 'N/A', 'saturday', '21:30:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4410, 157, 'France', 'Paris', 'N/A', 'saturday', '22:00:00', 24, '2024-09-03 04:45:16', '2024-09-03 04:45:16'),
(4411, 157, 'France', 'Paris', 'N/A', 'thursday', '12:00:00', 24, '2024-09-03 04:45:17', '2024-09-03 04:45:17'),
(4412, 157, 'France', 'Paris', 'N/A', 'thursday', '12:30:00', 24, '2024-09-03 04:45:17', '2024-09-03 04:45:17'),
(4413, 157, 'France', 'Paris', 'N/A', 'thursday', '13:00:00', 24, '2024-09-03 04:45:17', '2024-09-03 04:45:17'),
(4414, 157, 'France', 'Paris', 'N/A', 'thursday', '13:30:00', 24, '2024-09-03 04:45:17', '2024-09-03 04:45:17'),
(4415, 157, 'France', 'Paris', 'N/A', 'thursday', '14:00:00', 24, '2024-09-03 04:45:17', '2024-09-03 04:45:17'),
(4416, 157, 'France', 'Paris', 'N/A', 'thursday', '14:30:00', 24, '2024-09-03 04:45:17', '2024-09-03 04:45:17'),
(4417, 157, 'France', 'Paris', 'N/A', 'thursday', '15:00:00', 24, '2024-09-03 04:45:17', '2024-09-03 04:45:17'),
(4418, 157, 'France', 'Paris', 'N/A', 'thursday', '15:30:00', 24, '2024-09-03 04:45:17', '2024-09-03 04:45:17'),
(4419, 157, 'France', 'Paris', 'N/A', 'thursday', '16:00:00', 24, '2024-09-03 04:45:17', '2024-09-03 04:45:17'),
(4420, 157, 'France', 'Paris', 'N/A', 'thursday', '16:30:00', 24, '2024-09-03 04:45:17', '2024-09-03 04:45:17'),
(4421, 157, 'France', 'Paris', 'N/A', 'thursday', '17:00:00', 24, '2024-09-03 04:45:17', '2024-09-03 04:45:17'),
(4422, 157, 'France', 'Paris', 'N/A', 'thursday', '17:30:00', 24, '2024-09-03 04:45:17', '2024-09-03 04:45:17'),
(4423, 157, 'France', 'Paris', 'N/A', 'thursday', '18:00:00', 24, '2024-09-03 04:45:17', '2024-09-03 04:45:17'),
(4424, 157, 'France', 'Paris', 'N/A', 'thursday', '18:30:00', 24, '2024-09-03 04:45:17', '2024-09-03 04:45:17'),
(4425, 157, 'France', 'Paris', 'N/A', 'thursday', '19:00:00', 24, '2024-09-03 04:45:17', '2024-09-03 04:45:17'),
(4426, 157, 'France', 'Paris', 'N/A', 'thursday', '19:30:00', 24, '2024-09-03 04:45:17', '2024-09-03 04:45:17'),
(4427, 157, 'France', 'Paris', 'N/A', 'thursday', '20:00:00', 24, '2024-09-03 04:45:17', '2024-09-03 04:45:17'),
(4428, 157, 'France', 'Paris', 'N/A', 'thursday', '20:30:00', 24, '2024-09-03 04:45:17', '2024-09-03 04:45:17'),
(4429, 157, 'France', 'Paris', 'N/A', 'thursday', '21:00:00', 24, '2024-09-03 04:45:17', '2024-09-03 04:45:17'),
(4430, 157, 'France', 'Paris', 'N/A', 'thursday', '21:30:00', 24, '2024-09-03 04:45:17', '2024-09-03 04:45:17'),
(4431, 157, 'France', 'Paris', 'N/A', 'thursday', '22:00:00', 24, '2024-09-03 04:45:17', '2024-09-03 04:45:17'),
(4432, 158, 'France', 'Paris', 'N/A', 'friday', '08:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4433, 158, 'France', 'Paris', 'N/A', 'friday', '08:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4434, 158, 'France', 'Paris', 'N/A', 'friday', '09:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4435, 158, 'France', 'Paris', 'N/A', 'friday', '10:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4436, 158, 'France', 'Paris', 'N/A', 'friday', '11:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4437, 158, 'France', 'Paris', 'N/A', 'friday', '11:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4438, 158, 'France', 'Paris', 'N/A', 'friday', '12:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4439, 158, 'France', 'Paris', 'N/A', 'friday', '13:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4440, 158, 'France', 'Paris', 'N/A', 'friday', '14:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4441, 158, 'France', 'Paris', 'N/A', 'friday', '14:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4442, 158, 'France', 'Paris', 'N/A', 'friday', '15:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4443, 158, 'France', 'Paris', 'N/A', 'friday', '16:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4444, 158, 'France', 'Paris', 'N/A', 'friday', '17:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4445, 158, 'France', 'Paris', 'N/A', 'friday', '17:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4446, 158, 'France', 'Paris', 'N/A', 'friday', '18:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4447, 158, 'France', 'Paris', 'N/A', 'friday', '19:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4448, 158, 'France', 'Paris', 'N/A', 'friday', '20:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4449, 158, 'France', 'Paris', 'N/A', 'friday', '20:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4450, 158, 'France', 'Paris', 'N/A', 'friday', '21:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4451, 158, 'France', 'Paris', 'N/A', 'friday', '22:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4452, 158, 'France', 'Paris', 'N/A', 'friday', '23:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4453, 158, 'France', 'Paris', 'N/A', 'friday', '23:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4454, 158, 'France', 'Paris', 'N/A', 'monday', '08:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4455, 158, 'France', 'Paris', 'N/A', 'monday', '08:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4456, 158, 'France', 'Paris', 'N/A', 'monday', '09:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4457, 158, 'France', 'Paris', 'N/A', 'monday', '10:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4458, 158, 'France', 'Paris', 'N/A', 'monday', '11:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4459, 158, 'France', 'Paris', 'N/A', 'monday', '11:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4460, 158, 'France', 'Paris', 'N/A', 'monday', '12:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4461, 158, 'France', 'Paris', 'N/A', 'monday', '13:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4462, 158, 'France', 'Paris', 'N/A', 'monday', '14:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4463, 158, 'France', 'Paris', 'N/A', 'monday', '14:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4464, 158, 'France', 'Paris', 'N/A', 'monday', '15:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4465, 158, 'France', 'Paris', 'N/A', 'monday', '16:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4466, 158, 'France', 'Paris', 'N/A', 'tuesday', '08:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4467, 158, 'France', 'Paris', 'N/A', 'monday', '17:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4468, 158, 'France', 'Paris', 'N/A', 'tuesday', '08:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4469, 158, 'France', 'Paris', 'N/A', 'monday', '17:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4470, 158, 'France', 'Paris', 'N/A', 'tuesday', '09:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4471, 158, 'France', 'Paris', 'N/A', 'monday', '18:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4472, 158, 'France', 'Paris', 'N/A', 'tuesday', '10:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4473, 158, 'France', 'Paris', 'N/A', 'monday', '19:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4474, 158, 'France', 'Paris', 'N/A', 'monday', '20:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4475, 158, 'France', 'Paris', 'N/A', 'tuesday', '11:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4476, 158, 'France', 'Paris', 'N/A', 'tuesday', '11:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4477, 158, 'France', 'Paris', 'N/A', 'monday', '20:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4478, 158, 'France', 'Paris', 'N/A', 'monday', '21:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4479, 158, 'France', 'Paris', 'N/A', 'tuesday', '12:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4480, 158, 'France', 'Paris', 'N/A', 'monday', '22:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4481, 158, 'France', 'Paris', 'N/A', 'tuesday', '13:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4482, 158, 'France', 'Paris', 'N/A', 'monday', '23:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4483, 158, 'France', 'Paris', 'N/A', 'tuesday', '14:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4484, 158, 'France', 'Paris', 'N/A', 'monday', '23:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4485, 158, 'France', 'Paris', 'N/A', 'tuesday', '14:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4486, 158, 'France', 'Paris', 'N/A', 'tuesday', '15:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4487, 158, 'France', 'Paris', 'N/A', 'tuesday', '16:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4488, 158, 'France', 'Paris', 'N/A', 'tuesday', '17:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4489, 158, 'France', 'Paris', 'N/A', 'tuesday', '17:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4490, 158, 'France', 'Paris', 'N/A', 'tuesday', '18:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4491, 158, 'France', 'Paris', 'N/A', 'tuesday', '19:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4492, 158, 'France', 'Paris', 'N/A', 'tuesday', '20:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4493, 158, 'France', 'Paris', 'N/A', 'tuesday', '20:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4494, 158, 'France', 'Paris', 'N/A', 'tuesday', '21:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4495, 158, 'France', 'Paris', 'N/A', 'wednesday', '08:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4496, 158, 'France', 'Paris', 'N/A', 'tuesday', '22:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4497, 158, 'France', 'Paris', 'N/A', 'wednesday', '08:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4498, 158, 'France', 'Paris', 'N/A', 'tuesday', '23:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4499, 158, 'France', 'Paris', 'N/A', 'wednesday', '09:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4500, 158, 'France', 'Paris', 'N/A', 'tuesday', '23:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4501, 158, 'France', 'Paris', 'N/A', 'wednesday', '10:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4502, 158, 'France', 'Paris', 'N/A', 'wednesday', '11:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4503, 158, 'France', 'Paris', 'N/A', 'thursday', '08:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4504, 158, 'France', 'Paris', 'N/A', 'wednesday', '11:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4505, 158, 'France', 'Paris', 'N/A', 'thursday', '08:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4506, 158, 'France', 'Paris', 'N/A', 'wednesday', '12:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4507, 158, 'France', 'Paris', 'N/A', 'thursday', '09:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4508, 158, 'France', 'Paris', 'N/A', 'wednesday', '13:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4509, 158, 'France', 'Paris', 'N/A', 'thursday', '10:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4510, 158, 'France', 'Paris', 'N/A', 'wednesday', '14:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4511, 158, 'France', 'Paris', 'N/A', 'thursday', '11:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4512, 158, 'France', 'Paris', 'N/A', 'wednesday', '14:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4513, 158, 'France', 'Paris', 'N/A', 'thursday', '11:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4514, 158, 'France', 'Paris', 'N/A', 'wednesday', '15:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4515, 158, 'France', 'Paris', 'N/A', 'thursday', '12:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4516, 158, 'France', 'Paris', 'N/A', 'wednesday', '16:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4517, 158, 'France', 'Paris', 'N/A', 'thursday', '13:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4518, 158, 'France', 'Paris', 'N/A', 'wednesday', '17:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4519, 158, 'France', 'Paris', 'N/A', 'thursday', '14:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4520, 158, 'France', 'Paris', 'N/A', 'saturday', '08:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4521, 158, 'France', 'Paris', 'N/A', 'wednesday', '17:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4522, 158, 'France', 'Paris', 'N/A', 'thursday', '14:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4523, 158, 'France', 'Paris', 'N/A', 'saturday', '08:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4524, 158, 'France', 'Paris', 'N/A', 'thursday', '15:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4525, 158, 'France', 'Paris', 'N/A', 'wednesday', '18:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4526, 158, 'France', 'Paris', 'N/A', 'saturday', '09:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4527, 158, 'France', 'Paris', 'N/A', 'wednesday', '19:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4528, 158, 'France', 'Paris', 'N/A', 'thursday', '16:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4529, 158, 'France', 'Paris', 'N/A', 'saturday', '10:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4530, 158, 'France', 'Paris', 'N/A', 'wednesday', '20:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4531, 158, 'France', 'Paris', 'N/A', 'thursday', '17:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4532, 158, 'France', 'Paris', 'N/A', 'saturday', '11:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4533, 158, 'France', 'Paris', 'N/A', 'wednesday', '20:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4534, 158, 'France', 'Paris', 'N/A', 'thursday', '17:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4535, 158, 'France', 'Paris', 'N/A', 'saturday', '11:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4536, 158, 'France', 'Paris', 'N/A', 'wednesday', '21:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4537, 158, 'France', 'Paris', 'N/A', 'thursday', '18:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4538, 158, 'France', 'Paris', 'N/A', 'saturday', '12:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4539, 158, 'France', 'Paris', 'N/A', 'wednesday', '22:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4540, 158, 'France', 'Paris', 'N/A', 'thursday', '19:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4541, 158, 'France', 'Paris', 'N/A', 'saturday', '13:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4542, 158, 'France', 'Paris', 'N/A', 'wednesday', '23:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4543, 158, 'France', 'Paris', 'N/A', 'thursday', '20:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4544, 158, 'France', 'Paris', 'N/A', 'saturday', '14:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4545, 158, 'France', 'Paris', 'N/A', 'wednesday', '23:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4546, 158, 'France', 'Paris', 'N/A', 'thursday', '20:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4547, 158, 'France', 'Paris', 'N/A', 'saturday', '14:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4548, 158, 'France', 'Paris', 'N/A', 'thursday', '21:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4549, 158, 'France', 'Paris', 'N/A', 'saturday', '15:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4550, 158, 'France', 'Paris', 'N/A', 'thursday', '22:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4551, 158, 'France', 'Paris', 'N/A', 'saturday', '16:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4552, 158, 'France', 'Paris', 'N/A', 'thursday', '23:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4553, 158, 'France', 'Paris', 'N/A', 'saturday', '17:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4554, 158, 'France', 'Paris', 'N/A', 'thursday', '23:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4555, 158, 'France', 'Paris', 'N/A', 'saturday', '17:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4556, 158, 'France', 'Paris', 'N/A', 'saturday', '18:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4557, 158, 'France', 'Paris', 'N/A', 'saturday', '19:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47');
INSERT INTO `restaurant_business_hours` (`id`, `restaurant_id`, `country`, `city`, `shift_name`, `day_of_week`, `slot_time`, `added_by`, `created_at`, `updated_at`) VALUES
(4558, 158, 'France', 'Paris', 'N/A', 'saturday', '20:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4559, 158, 'France', 'Paris', 'N/A', 'saturday', '20:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4560, 158, 'France', 'Paris', 'N/A', 'saturday', '21:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4561, 158, 'France', 'Paris', 'N/A', 'saturday', '22:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4562, 158, 'France', 'Paris', 'N/A', 'saturday', '23:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4563, 158, 'France', 'Paris', 'N/A', 'saturday', '23:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4564, 158, 'France', 'Paris', 'N/A', 'sunday', '08:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4565, 158, 'France', 'Paris', 'N/A', 'sunday', '08:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4566, 158, 'France', 'Paris', 'N/A', 'sunday', '09:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4567, 158, 'France', 'Paris', 'N/A', 'sunday', '10:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4568, 158, 'France', 'Paris', 'N/A', 'sunday', '11:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4569, 158, 'France', 'Paris', 'N/A', 'sunday', '11:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4570, 158, 'France', 'Paris', 'N/A', 'sunday', '12:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4571, 158, 'France', 'Paris', 'N/A', 'sunday', '13:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4572, 158, 'France', 'Paris', 'N/A', 'sunday', '14:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4573, 158, 'France', 'Paris', 'N/A', 'sunday', '14:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4574, 158, 'France', 'Paris', 'N/A', 'sunday', '15:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4575, 158, 'France', 'Paris', 'N/A', 'sunday', '16:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4576, 158, 'France', 'Paris', 'N/A', 'sunday', '17:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4577, 158, 'France', 'Paris', 'N/A', 'sunday', '17:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4578, 158, 'France', 'Paris', 'N/A', 'sunday', '18:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4579, 158, 'France', 'Paris', 'N/A', 'sunday', '19:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4580, 158, 'France', 'Paris', 'N/A', 'sunday', '20:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4581, 158, 'France', 'Paris', 'N/A', 'sunday', '20:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4582, 158, 'France', 'Paris', 'N/A', 'sunday', '21:30:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4583, 158, 'France', 'Paris', 'N/A', 'sunday', '22:15:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4584, 158, 'France', 'Paris', 'N/A', 'sunday', '23:00:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4585, 158, 'France', 'Paris', 'N/A', 'sunday', '23:45:00', 24, '2024-09-03 04:45:47', '2024-09-03 04:45:47'),
(4586, 159, 'France', 'Paris', 'N/A', 'wednesday', '08:00:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4587, 159, 'France', 'Paris', 'N/A', 'wednesday', '08:45:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4588, 159, 'France', 'Paris', 'N/A', 'monday', '08:00:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4589, 159, 'France', 'Paris', 'N/A', 'wednesday', '09:30:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4590, 159, 'France', 'Paris', 'N/A', 'monday', '08:45:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4591, 159, 'France', 'Paris', 'N/A', 'wednesday', '10:15:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4592, 159, 'France', 'Paris', 'N/A', 'monday', '09:30:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4593, 159, 'France', 'Paris', 'N/A', 'wednesday', '11:00:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4594, 159, 'France', 'Paris', 'N/A', 'monday', '10:15:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4595, 159, 'France', 'Paris', 'N/A', 'wednesday', '11:45:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4596, 159, 'France', 'Paris', 'N/A', 'monday', '11:00:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4597, 159, 'France', 'Paris', 'N/A', 'wednesday', '12:30:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4598, 159, 'France', 'Paris', 'N/A', 'monday', '11:45:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4599, 159, 'France', 'Paris', 'N/A', 'wednesday', '13:15:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4600, 159, 'France', 'Paris', 'N/A', 'monday', '12:30:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4601, 159, 'France', 'Paris', 'N/A', 'wednesday', '14:00:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4602, 159, 'France', 'Paris', 'N/A', 'monday', '13:15:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4603, 159, 'France', 'Paris', 'N/A', 'wednesday', '14:45:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4604, 159, 'France', 'Paris', 'N/A', 'monday', '14:00:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4605, 159, 'France', 'Paris', 'N/A', 'wednesday', '15:30:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4606, 159, 'France', 'Paris', 'N/A', 'monday', '14:45:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4607, 159, 'France', 'Paris', 'N/A', 'wednesday', '16:15:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4608, 159, 'France', 'Paris', 'N/A', 'monday', '15:30:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4609, 159, 'France', 'Paris', 'N/A', 'wednesday', '17:00:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4610, 159, 'France', 'Paris', 'N/A', 'monday', '16:15:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4611, 159, 'France', 'Paris', 'N/A', 'wednesday', '17:45:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4612, 159, 'France', 'Paris', 'N/A', 'monday', '17:00:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4613, 159, 'France', 'Paris', 'N/A', 'wednesday', '18:30:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4614, 159, 'France', 'Paris', 'N/A', 'monday', '17:45:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4615, 159, 'France', 'Paris', 'N/A', 'wednesday', '19:15:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4616, 159, 'France', 'Paris', 'N/A', 'monday', '18:30:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4617, 159, 'France', 'Paris', 'N/A', 'wednesday', '20:00:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4618, 159, 'France', 'Paris', 'N/A', 'monday', '19:15:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4619, 159, 'France', 'Paris', 'N/A', 'wednesday', '20:45:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4620, 159, 'France', 'Paris', 'N/A', 'monday', '20:00:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4621, 159, 'France', 'Paris', 'N/A', 'wednesday', '21:30:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4622, 159, 'France', 'Paris', 'N/A', 'monday', '20:45:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4623, 159, 'France', 'Paris', 'N/A', 'wednesday', '22:15:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4624, 159, 'France', 'Paris', 'N/A', 'monday', '21:30:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4625, 159, 'France', 'Paris', 'N/A', 'monday', '22:15:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4626, 159, 'France', 'Paris', 'N/A', 'wednesday', '23:00:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4627, 159, 'France', 'Paris', 'N/A', 'monday', '23:00:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4628, 159, 'France', 'Paris', 'N/A', 'wednesday', '23:45:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4629, 159, 'France', 'Paris', 'N/A', 'monday', '23:45:00', 24, '2024-09-03 04:46:21', '2024-09-03 04:46:21'),
(4630, 159, 'France', 'Paris', 'N/A', 'tuesday', '08:00:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4631, 159, 'France', 'Paris', 'N/A', 'tuesday', '08:45:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4632, 159, 'France', 'Paris', 'N/A', 'tuesday', '09:30:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4633, 159, 'France', 'Paris', 'N/A', 'tuesday', '10:15:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4634, 159, 'France', 'Paris', 'N/A', 'thursday', '08:00:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4635, 159, 'France', 'Paris', 'N/A', 'thursday', '08:45:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4636, 159, 'France', 'Paris', 'N/A', 'tuesday', '11:00:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4637, 159, 'France', 'Paris', 'N/A', 'thursday', '09:30:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4638, 159, 'France', 'Paris', 'N/A', 'tuesday', '11:45:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4639, 159, 'France', 'Paris', 'N/A', 'thursday', '10:15:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4640, 159, 'France', 'Paris', 'N/A', 'tuesday', '12:30:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4641, 159, 'France', 'Paris', 'N/A', 'thursday', '11:00:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4642, 159, 'France', 'Paris', 'N/A', 'tuesday', '13:15:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4643, 159, 'France', 'Paris', 'N/A', 'thursday', '11:45:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4644, 159, 'France', 'Paris', 'N/A', 'tuesday', '14:00:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4645, 159, 'France', 'Paris', 'N/A', 'thursday', '12:30:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4646, 159, 'France', 'Paris', 'N/A', 'tuesday', '14:45:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4647, 159, 'France', 'Paris', 'N/A', 'friday', '08:00:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4648, 159, 'France', 'Paris', 'N/A', 'friday', '08:45:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4649, 159, 'France', 'Paris', 'N/A', 'tuesday', '15:30:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4650, 159, 'France', 'Paris', 'N/A', 'thursday', '13:15:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4651, 159, 'France', 'Paris', 'N/A', 'friday', '09:30:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4652, 159, 'France', 'Paris', 'N/A', 'thursday', '14:00:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4653, 159, 'France', 'Paris', 'N/A', 'friday', '10:15:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4654, 159, 'France', 'Paris', 'N/A', 'tuesday', '16:15:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4655, 159, 'France', 'Paris', 'N/A', 'thursday', '14:45:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4656, 159, 'France', 'Paris', 'N/A', 'tuesday', '17:00:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4657, 159, 'France', 'Paris', 'N/A', 'friday', '11:00:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4658, 159, 'France', 'Paris', 'N/A', 'thursday', '15:30:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4659, 159, 'France', 'Paris', 'N/A', 'friday', '11:45:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4660, 159, 'France', 'Paris', 'N/A', 'tuesday', '17:45:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4661, 159, 'France', 'Paris', 'N/A', 'thursday', '16:15:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4662, 159, 'France', 'Paris', 'N/A', 'friday', '12:30:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4663, 159, 'France', 'Paris', 'N/A', 'tuesday', '18:30:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4664, 159, 'France', 'Paris', 'N/A', 'thursday', '17:00:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4665, 159, 'France', 'Paris', 'N/A', 'friday', '13:15:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4666, 159, 'France', 'Paris', 'N/A', 'tuesday', '19:15:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4667, 159, 'France', 'Paris', 'N/A', 'tuesday', '20:00:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4668, 159, 'France', 'Paris', 'N/A', 'thursday', '17:45:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4669, 159, 'France', 'Paris', 'N/A', 'friday', '14:00:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4670, 159, 'France', 'Paris', 'N/A', 'thursday', '18:30:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4671, 159, 'France', 'Paris', 'N/A', 'friday', '14:45:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4672, 159, 'France', 'Paris', 'N/A', 'tuesday', '20:45:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4673, 159, 'France', 'Paris', 'N/A', 'thursday', '19:15:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4674, 159, 'France', 'Paris', 'N/A', 'friday', '15:30:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4675, 159, 'France', 'Paris', 'N/A', 'tuesday', '21:30:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4676, 159, 'France', 'Paris', 'N/A', 'thursday', '20:00:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4677, 159, 'France', 'Paris', 'N/A', 'tuesday', '22:15:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4678, 159, 'France', 'Paris', 'N/A', 'friday', '16:15:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4679, 159, 'France', 'Paris', 'N/A', 'thursday', '20:45:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4680, 159, 'France', 'Paris', 'N/A', 'friday', '17:00:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4681, 159, 'France', 'Paris', 'N/A', 'tuesday', '23:00:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4682, 159, 'France', 'Paris', 'N/A', 'thursday', '21:30:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4683, 159, 'France', 'Paris', 'N/A', 'friday', '17:45:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4684, 159, 'France', 'Paris', 'N/A', 'tuesday', '23:45:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4685, 159, 'France', 'Paris', 'N/A', 'friday', '18:30:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4686, 159, 'France', 'Paris', 'N/A', 'thursday', '22:15:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4687, 159, 'France', 'Paris', 'N/A', 'friday', '19:15:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4688, 159, 'France', 'Paris', 'N/A', 'thursday', '23:00:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4689, 159, 'France', 'Paris', 'N/A', 'friday', '20:00:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4690, 159, 'France', 'Paris', 'N/A', 'thursday', '23:45:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4691, 159, 'France', 'Paris', 'N/A', 'friday', '20:45:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4692, 159, 'France', 'Paris', 'N/A', 'friday', '21:30:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4693, 159, 'France', 'Paris', 'N/A', 'saturday', '08:00:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4694, 159, 'France', 'Paris', 'N/A', 'friday', '22:15:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4695, 159, 'France', 'Paris', 'N/A', 'saturday', '08:45:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4696, 159, 'France', 'Paris', 'N/A', 'friday', '23:00:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4697, 159, 'France', 'Paris', 'N/A', 'saturday', '09:30:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4698, 159, 'France', 'Paris', 'N/A', 'friday', '23:45:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4699, 159, 'France', 'Paris', 'N/A', 'saturday', '10:15:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4700, 159, 'France', 'Paris', 'N/A', 'saturday', '11:00:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4701, 159, 'France', 'Paris', 'N/A', 'saturday', '11:45:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4702, 159, 'France', 'Paris', 'N/A', 'saturday', '12:30:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4703, 159, 'France', 'Paris', 'N/A', 'saturday', '13:15:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4704, 159, 'France', 'Paris', 'N/A', 'saturday', '14:00:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4705, 159, 'France', 'Paris', 'N/A', 'saturday', '14:45:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4706, 159, 'France', 'Paris', 'N/A', 'saturday', '15:30:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4707, 159, 'France', 'Paris', 'N/A', 'saturday', '16:15:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4708, 159, 'France', 'Paris', 'N/A', 'saturday', '17:00:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4709, 159, 'France', 'Paris', 'N/A', 'saturday', '17:45:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4710, 159, 'France', 'Paris', 'N/A', 'saturday', '18:30:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4711, 159, 'France', 'Paris', 'N/A', 'saturday', '19:15:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4712, 159, 'France', 'Paris', 'N/A', 'saturday', '20:00:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4713, 159, 'France', 'Paris', 'N/A', 'saturday', '20:45:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4714, 159, 'France', 'Paris', 'N/A', 'sunday', '08:00:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4715, 159, 'France', 'Paris', 'N/A', 'saturday', '21:30:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4716, 159, 'France', 'Paris', 'N/A', 'sunday', '08:45:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4717, 159, 'France', 'Paris', 'N/A', 'saturday', '22:15:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4718, 159, 'France', 'Paris', 'N/A', 'sunday', '09:30:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4719, 159, 'France', 'Paris', 'N/A', 'saturday', '23:00:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4720, 159, 'France', 'Paris', 'N/A', 'sunday', '10:15:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4721, 159, 'France', 'Paris', 'N/A', 'saturday', '23:45:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4722, 159, 'France', 'Paris', 'N/A', 'sunday', '11:00:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4723, 159, 'France', 'Paris', 'N/A', 'sunday', '11:45:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4724, 159, 'France', 'Paris', 'N/A', 'sunday', '12:30:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4725, 159, 'France', 'Paris', 'N/A', 'sunday', '13:15:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4726, 159, 'France', 'Paris', 'N/A', 'sunday', '14:00:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4727, 159, 'France', 'Paris', 'N/A', 'sunday', '14:45:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4728, 159, 'France', 'Paris', 'N/A', 'sunday', '15:30:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4729, 159, 'France', 'Paris', 'N/A', 'sunday', '16:15:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4730, 159, 'France', 'Paris', 'N/A', 'sunday', '17:00:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4731, 159, 'France', 'Paris', 'N/A', 'sunday', '17:45:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4732, 159, 'France', 'Paris', 'N/A', 'sunday', '18:30:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4733, 159, 'France', 'Paris', 'N/A', 'sunday', '19:15:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4734, 159, 'France', 'Paris', 'N/A', 'sunday', '20:00:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4735, 159, 'France', 'Paris', 'N/A', 'sunday', '20:45:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4736, 159, 'France', 'Paris', 'N/A', 'sunday', '21:30:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4737, 159, 'France', 'Paris', 'N/A', 'sunday', '22:15:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4738, 159, 'France', 'Paris', 'N/A', 'sunday', '23:00:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4739, 159, 'France', 'Paris', 'N/A', 'sunday', '23:45:00', 24, '2024-09-03 04:46:22', '2024-09-03 04:46:22'),
(4740, 160, 'France', 'Paris', 'N/A', 'monday', '12:00:00', 24, '2024-09-03 05:46:33', '2024-09-03 05:46:33'),
(4741, 160, 'France', 'Paris', 'N/A', 'tuesday', '12:00:00', 24, '2024-09-03 05:46:33', '2024-09-03 05:46:33'),
(4742, 160, 'France', 'Paris', 'N/A', 'monday', '12:45:00', 24, '2024-09-03 05:46:33', '2024-09-03 05:46:33'),
(4743, 160, 'France', 'Paris', 'N/A', 'tuesday', '12:45:00', 24, '2024-09-03 05:46:33', '2024-09-03 05:46:33'),
(4744, 160, 'France', 'Paris', 'N/A', 'monday', '13:30:00', 24, '2024-09-03 05:46:33', '2024-09-03 05:46:33'),
(4745, 160, 'France', 'Paris', 'N/A', 'tuesday', '13:30:00', 24, '2024-09-03 05:46:33', '2024-09-03 05:46:33'),
(4746, 160, 'France', 'Paris', 'N/A', 'monday', '14:15:00', 24, '2024-09-03 05:46:33', '2024-09-03 05:46:33'),
(4747, 160, 'France', 'Paris', 'N/A', 'tuesday', '14:15:00', 24, '2024-09-03 05:46:33', '2024-09-03 05:46:33'),
(4748, 160, 'France', 'Paris', 'N/A', 'monday', '15:00:00', 24, '2024-09-03 05:46:33', '2024-09-03 05:46:33'),
(4749, 160, 'France', 'Paris', 'N/A', 'tuesday', '15:00:00', 24, '2024-09-03 05:46:33', '2024-09-03 05:46:33'),
(4750, 160, 'France', 'Paris', 'N/A', 'monday', '15:45:00', 24, '2024-09-03 05:46:33', '2024-09-03 05:46:33'),
(4751, 160, 'France', 'Paris', 'N/A', 'tuesday', '15:45:00', 24, '2024-09-03 05:46:33', '2024-09-03 05:46:33'),
(4752, 160, 'France', 'Paris', 'N/A', 'monday', '16:30:00', 24, '2024-09-03 05:46:33', '2024-09-03 05:46:33'),
(4753, 160, 'France', 'Paris', 'N/A', 'tuesday', '16:30:00', 24, '2024-09-03 05:46:33', '2024-09-03 05:46:33'),
(4754, 160, 'France', 'Paris', 'N/A', 'monday', '17:15:00', 24, '2024-09-03 05:46:33', '2024-09-03 05:46:33'),
(4755, 160, 'France', 'Paris', 'N/A', 'tuesday', '17:15:00', 24, '2024-09-03 05:46:33', '2024-09-03 05:46:33'),
(4756, 160, 'France', 'Paris', 'N/A', 'monday', '18:00:00', 24, '2024-09-03 05:46:33', '2024-09-03 05:46:33'),
(4757, 160, 'France', 'Paris', 'N/A', 'tuesday', '18:00:00', 24, '2024-09-03 05:46:33', '2024-09-03 05:46:33'),
(4758, 160, 'France', 'Paris', 'N/A', 'monday', '18:45:00', 24, '2024-09-03 05:46:33', '2024-09-03 05:46:33'),
(4759, 160, 'France', 'Paris', 'N/A', 'tuesday', '18:45:00', 24, '2024-09-03 05:46:33', '2024-09-03 05:46:33'),
(4760, 160, 'France', 'Paris', 'N/A', 'monday', '19:30:00', 24, '2024-09-03 05:46:33', '2024-09-03 05:46:33'),
(4761, 160, 'France', 'Paris', 'N/A', 'tuesday', '19:30:00', 24, '2024-09-03 05:46:33', '2024-09-03 05:46:33'),
(4762, 160, 'France', 'Paris', 'N/A', 'monday', '20:15:00', 24, '2024-09-03 05:46:33', '2024-09-03 05:46:33'),
(4763, 160, 'France', 'Paris', 'N/A', 'tuesday', '20:15:00', 24, '2024-09-03 05:46:33', '2024-09-03 05:46:33'),
(4764, 160, 'France', 'Paris', 'N/A', 'monday', '21:00:00', 24, '2024-09-03 05:46:33', '2024-09-03 05:46:33'),
(4765, 160, 'France', 'Paris', 'N/A', 'tuesday', '21:00:00', 24, '2024-09-03 05:46:33', '2024-09-03 05:46:33'),
(4766, 160, 'France', 'Paris', 'N/A', 'monday', '21:45:00', 24, '2024-09-03 05:46:33', '2024-09-03 05:46:33'),
(4767, 160, 'France', 'Paris', 'N/A', 'tuesday', '21:45:00', 24, '2024-09-03 05:46:33', '2024-09-03 05:46:33'),
(4768, 160, 'France', 'Paris', 'N/A', 'monday', '22:30:00', 24, '2024-09-03 05:46:33', '2024-09-03 05:46:33'),
(4769, 160, 'France', 'Paris', 'N/A', 'tuesday', '22:30:00', 24, '2024-09-03 05:46:33', '2024-09-03 05:46:33'),
(4770, 160, 'France', 'Paris', 'N/A', 'friday', '12:00:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4771, 160, 'France', 'Paris', 'N/A', 'friday', '12:45:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4772, 160, 'France', 'Paris', 'N/A', 'friday', '13:30:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4773, 160, 'France', 'Paris', 'N/A', 'friday', '14:15:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4774, 160, 'France', 'Paris', 'N/A', 'friday', '15:00:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4775, 160, 'France', 'Paris', 'N/A', 'friday', '15:45:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4776, 160, 'France', 'Paris', 'N/A', 'friday', '16:30:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4777, 160, 'France', 'Paris', 'N/A', 'friday', '17:15:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4778, 160, 'France', 'Paris', 'N/A', 'sunday', '12:00:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4779, 160, 'France', 'Paris', 'N/A', 'friday', '18:00:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4780, 160, 'France', 'Paris', 'N/A', 'sunday', '12:45:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4781, 160, 'France', 'Paris', 'N/A', 'friday', '18:45:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4782, 160, 'France', 'Paris', 'N/A', 'sunday', '13:30:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4783, 160, 'France', 'Paris', 'N/A', 'friday', '19:30:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4784, 160, 'France', 'Paris', 'N/A', 'sunday', '14:15:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4785, 160, 'France', 'Paris', 'N/A', 'friday', '20:15:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4786, 160, 'France', 'Paris', 'N/A', 'sunday', '15:00:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4787, 160, 'France', 'Paris', 'N/A', 'friday', '21:00:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4788, 160, 'France', 'Paris', 'N/A', 'sunday', '15:45:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4789, 160, 'France', 'Paris', 'N/A', 'friday', '21:45:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4790, 160, 'France', 'Paris', 'N/A', 'sunday', '16:30:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4791, 160, 'France', 'Paris', 'N/A', 'friday', '22:30:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4792, 160, 'France', 'Paris', 'N/A', 'sunday', '17:15:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4793, 160, 'France', 'Paris', 'N/A', 'sunday', '18:00:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4794, 160, 'France', 'Paris', 'N/A', 'wednesday', '12:00:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4795, 160, 'France', 'Paris', 'N/A', 'sunday', '18:45:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4796, 160, 'France', 'Paris', 'N/A', 'wednesday', '12:45:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4797, 160, 'France', 'Paris', 'N/A', 'sunday', '19:30:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4798, 160, 'France', 'Paris', 'N/A', 'wednesday', '13:30:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4799, 160, 'France', 'Paris', 'N/A', 'sunday', '20:15:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4800, 160, 'France', 'Paris', 'N/A', 'wednesday', '14:15:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4801, 160, 'France', 'Paris', 'N/A', 'sunday', '21:00:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4802, 160, 'France', 'Paris', 'N/A', 'saturday', '12:00:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4803, 160, 'France', 'Paris', 'N/A', 'wednesday', '15:00:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4804, 160, 'France', 'Paris', 'N/A', 'sunday', '21:45:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4805, 160, 'France', 'Paris', 'N/A', 'saturday', '12:45:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4806, 160, 'France', 'Paris', 'N/A', 'wednesday', '15:45:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4807, 160, 'France', 'Paris', 'N/A', 'sunday', '22:30:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4808, 160, 'France', 'Paris', 'N/A', 'saturday', '13:30:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4809, 160, 'France', 'Paris', 'N/A', 'wednesday', '16:30:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4810, 160, 'France', 'Paris', 'N/A', 'saturday', '14:15:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4811, 160, 'France', 'Paris', 'N/A', 'wednesday', '17:15:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4812, 160, 'France', 'Paris', 'N/A', 'saturday', '15:00:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4813, 160, 'France', 'Paris', 'N/A', 'wednesday', '18:00:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4814, 160, 'France', 'Paris', 'N/A', 'saturday', '15:45:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4815, 160, 'France', 'Paris', 'N/A', 'wednesday', '18:45:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4816, 160, 'France', 'Paris', 'N/A', 'saturday', '16:30:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4817, 160, 'France', 'Paris', 'N/A', 'wednesday', '19:30:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4818, 160, 'France', 'Paris', 'N/A', 'saturday', '17:15:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4819, 160, 'France', 'Paris', 'N/A', 'wednesday', '20:15:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4820, 160, 'France', 'Paris', 'N/A', 'saturday', '18:00:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4821, 160, 'France', 'Paris', 'N/A', 'wednesday', '21:00:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4822, 160, 'France', 'Paris', 'N/A', 'saturday', '18:45:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4823, 160, 'France', 'Paris', 'N/A', 'wednesday', '21:45:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4824, 160, 'France', 'Paris', 'N/A', 'saturday', '19:30:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4825, 160, 'France', 'Paris', 'N/A', 'wednesday', '22:30:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4826, 160, 'France', 'Paris', 'N/A', 'saturday', '20:15:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4827, 160, 'France', 'Paris', 'N/A', 'saturday', '21:00:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4828, 160, 'France', 'Paris', 'N/A', 'saturday', '21:45:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4829, 160, 'France', 'Paris', 'N/A', 'saturday', '22:30:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4830, 160, 'France', 'Paris', 'N/A', 'thursday', '12:00:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4831, 160, 'France', 'Paris', 'N/A', 'thursday', '12:45:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4832, 160, 'France', 'Paris', 'N/A', 'thursday', '13:30:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4833, 160, 'France', 'Paris', 'N/A', 'thursday', '14:15:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4834, 160, 'France', 'Paris', 'N/A', 'thursday', '15:00:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4835, 160, 'France', 'Paris', 'N/A', 'thursday', '15:45:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4836, 160, 'France', 'Paris', 'N/A', 'thursday', '16:30:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4837, 160, 'France', 'Paris', 'N/A', 'thursday', '17:15:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4838, 160, 'France', 'Paris', 'N/A', 'thursday', '18:00:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4839, 160, 'France', 'Paris', 'N/A', 'thursday', '18:45:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4840, 160, 'France', 'Paris', 'N/A', 'thursday', '19:30:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4841, 160, 'France', 'Paris', 'N/A', 'thursday', '20:15:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4842, 160, 'France', 'Paris', 'N/A', 'thursday', '21:00:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4843, 160, 'France', 'Paris', 'N/A', 'thursday', '21:45:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4844, 160, 'France', 'Paris', 'N/A', 'thursday', '22:30:00', 24, '2024-09-03 05:46:34', '2024-09-03 05:46:34'),
(4845, 161, 'France', 'Paris', 'N/A', 'sunday', '18:00:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4846, 161, 'France', 'Paris', 'N/A', 'thursday', '18:00:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4847, 161, 'France', 'Paris', 'N/A', 'friday', '18:00:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4848, 161, 'France', 'Paris', 'N/A', 'sunday', '18:35:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4849, 161, 'France', 'Paris', 'N/A', 'saturday', '18:00:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4850, 161, 'France', 'Paris', 'N/A', 'monday', '18:00:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4851, 161, 'France', 'Paris', 'N/A', 'thursday', '18:35:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4852, 161, 'France', 'Paris', 'N/A', 'friday', '18:35:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4853, 161, 'France', 'Paris', 'N/A', 'sunday', '19:10:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4854, 161, 'France', 'Paris', 'N/A', 'saturday', '18:35:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4855, 161, 'France', 'Paris', 'N/A', 'thursday', '19:10:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4856, 161, 'France', 'Paris', 'N/A', 'monday', '18:35:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4857, 161, 'France', 'Paris', 'N/A', 'friday', '19:10:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4858, 161, 'France', 'Paris', 'N/A', 'sunday', '19:45:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4859, 161, 'France', 'Paris', 'N/A', 'thursday', '19:45:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4860, 161, 'France', 'Paris', 'N/A', 'saturday', '19:10:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4861, 161, 'France', 'Paris', 'N/A', 'monday', '19:10:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4862, 161, 'France', 'Paris', 'N/A', 'sunday', '20:20:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4863, 161, 'France', 'Paris', 'N/A', 'thursday', '20:20:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4864, 161, 'France', 'Paris', 'N/A', 'friday', '19:45:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4865, 161, 'France', 'Paris', 'N/A', 'saturday', '19:45:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4866, 161, 'France', 'Paris', 'N/A', 'monday', '19:45:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4867, 161, 'France', 'Paris', 'N/A', 'sunday', '20:55:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4868, 161, 'France', 'Paris', 'N/A', 'thursday', '20:55:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4869, 161, 'France', 'Paris', 'N/A', 'monday', '20:20:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4870, 161, 'France', 'Paris', 'N/A', 'sunday', '21:30:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4871, 161, 'France', 'Paris', 'N/A', 'friday', '20:20:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4872, 161, 'France', 'Paris', 'N/A', 'thursday', '21:30:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4873, 161, 'France', 'Paris', 'N/A', 'saturday', '20:20:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4874, 161, 'France', 'Paris', 'N/A', 'monday', '20:55:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4875, 161, 'France', 'Paris', 'N/A', 'sunday', '22:05:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4876, 161, 'France', 'Paris', 'N/A', 'friday', '20:55:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4877, 161, 'France', 'Paris', 'N/A', 'thursday', '22:05:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4878, 161, 'France', 'Paris', 'N/A', 'saturday', '20:55:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4879, 161, 'France', 'Paris', 'N/A', 'tuesday', '18:00:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4880, 161, 'France', 'Paris', 'N/A', 'monday', '21:30:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4881, 161, 'France', 'Paris', 'N/A', 'sunday', '22:40:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4882, 161, 'France', 'Paris', 'N/A', 'friday', '21:30:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4883, 161, 'France', 'Paris', 'N/A', 'thursday', '22:40:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4884, 161, 'France', 'Paris', 'N/A', 'tuesday', '18:35:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4885, 161, 'France', 'Paris', 'N/A', 'saturday', '21:30:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4886, 161, 'France', 'Paris', 'N/A', 'monday', '22:05:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4887, 161, 'France', 'Paris', 'N/A', 'sunday', '23:15:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4888, 161, 'France', 'Paris', 'N/A', 'friday', '22:05:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4889, 161, 'France', 'Paris', 'N/A', 'thursday', '23:15:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4890, 161, 'France', 'Paris', 'N/A', 'tuesday', '19:10:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4891, 161, 'France', 'Paris', 'N/A', 'saturday', '22:05:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4892, 161, 'France', 'Paris', 'N/A', 'monday', '22:40:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4893, 161, 'France', 'Paris', 'N/A', 'sunday', '23:50:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4894, 161, 'France', 'Paris', 'N/A', 'thursday', '23:50:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4895, 161, 'France', 'Paris', 'N/A', 'friday', '22:40:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4896, 161, 'France', 'Paris', 'N/A', 'tuesday', '19:45:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4897, 161, 'France', 'Paris', 'N/A', 'monday', '23:15:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4898, 161, 'France', 'Paris', 'N/A', 'saturday', '22:40:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4899, 161, 'France', 'Paris', 'N/A', 'friday', '23:15:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4900, 161, 'France', 'Paris', 'N/A', 'tuesday', '20:20:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4901, 161, 'France', 'Paris', 'N/A', 'monday', '23:50:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4902, 161, 'France', 'Paris', 'N/A', 'saturday', '23:15:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4903, 161, 'France', 'Paris', 'N/A', 'friday', '23:50:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4904, 161, 'France', 'Paris', 'N/A', 'tuesday', '20:55:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4905, 161, 'France', 'Paris', 'N/A', 'saturday', '23:50:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4906, 161, 'France', 'Paris', 'N/A', 'tuesday', '21:30:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4907, 161, 'France', 'Paris', 'N/A', 'tuesday', '22:05:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4908, 161, 'France', 'Paris', 'N/A', 'tuesday', '22:40:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4909, 161, 'France', 'Paris', 'N/A', 'tuesday', '23:15:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4910, 161, 'France', 'Paris', 'N/A', 'tuesday', '23:50:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4911, 161, 'France', 'Paris', 'N/A', 'wednesday', '18:00:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4912, 161, 'France', 'Paris', 'N/A', 'wednesday', '18:35:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4913, 161, 'France', 'Paris', 'N/A', 'wednesday', '19:10:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4914, 161, 'France', 'Paris', 'N/A', 'wednesday', '19:45:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4915, 161, 'France', 'Paris', 'N/A', 'wednesday', '20:20:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4916, 161, 'France', 'Paris', 'N/A', 'wednesday', '20:55:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4917, 161, 'France', 'Paris', 'N/A', 'wednesday', '21:30:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4918, 161, 'France', 'Paris', 'N/A', 'wednesday', '22:05:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4919, 161, 'France', 'Paris', 'N/A', 'wednesday', '22:40:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4920, 161, 'France', 'Paris', 'N/A', 'wednesday', '23:15:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4921, 161, 'France', 'Paris', 'N/A', 'wednesday', '23:50:00', 24, '2024-09-03 05:47:02', '2024-09-03 05:47:02'),
(4922, 162, 'France', 'Paris', 'N/A', 'monday', '12:30:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4923, 162, 'France', 'Paris', 'N/A', 'monday', '12:55:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4924, 162, 'France', 'Paris', 'N/A', 'tuesday', '12:30:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4925, 162, 'France', 'Paris', 'N/A', 'monday', '13:20:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4926, 162, 'France', 'Paris', 'N/A', 'monday', '13:45:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4927, 162, 'France', 'Paris', 'N/A', 'tuesday', '12:55:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4928, 162, 'France', 'Paris', 'N/A', 'monday', '14:10:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4929, 162, 'France', 'Paris', 'N/A', 'monday', '14:35:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4930, 162, 'France', 'Paris', 'N/A', 'tuesday', '13:20:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4931, 162, 'France', 'Paris', 'N/A', 'monday', '15:00:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4932, 162, 'France', 'Paris', 'N/A', 'tuesday', '13:45:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4933, 162, 'France', 'Paris', 'N/A', 'monday', '15:25:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4934, 162, 'France', 'Paris', 'N/A', 'tuesday', '14:10:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4935, 162, 'France', 'Paris', 'N/A', 'monday', '15:50:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4936, 162, 'France', 'Paris', 'N/A', 'tuesday', '14:35:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4937, 162, 'France', 'Paris', 'N/A', 'tuesday', '15:00:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4938, 162, 'France', 'Paris', 'N/A', 'monday', '16:15:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4939, 162, 'France', 'Paris', 'N/A', 'tuesday', '15:25:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4940, 162, 'France', 'Paris', 'N/A', 'monday', '16:40:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4941, 162, 'France', 'Paris', 'N/A', 'tuesday', '15:50:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4942, 162, 'France', 'Paris', 'N/A', 'monday', '17:05:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4943, 162, 'France', 'Paris', 'N/A', 'tuesday', '16:15:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4944, 162, 'France', 'Paris', 'N/A', 'monday', '17:30:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4945, 162, 'France', 'Paris', 'N/A', 'tuesday', '16:40:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4946, 162, 'France', 'Paris', 'N/A', 'monday', '17:55:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4947, 162, 'France', 'Paris', 'N/A', 'tuesday', '17:05:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4948, 162, 'France', 'Paris', 'N/A', 'monday', '18:20:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4949, 162, 'France', 'Paris', 'N/A', 'tuesday', '17:30:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4950, 162, 'France', 'Paris', 'N/A', 'monday', '18:45:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4951, 162, 'France', 'Paris', 'N/A', 'tuesday', '17:55:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4952, 162, 'France', 'Paris', 'N/A', 'monday', '19:10:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4953, 162, 'France', 'Paris', 'N/A', 'tuesday', '18:20:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4954, 162, 'France', 'Paris', 'N/A', 'monday', '19:35:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4955, 162, 'France', 'Paris', 'N/A', 'tuesday', '18:45:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4956, 162, 'France', 'Paris', 'N/A', 'tuesday', '19:10:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4957, 162, 'France', 'Paris', 'N/A', 'tuesday', '19:35:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4958, 162, 'France', 'Paris', 'N/A', 'tuesday', '20:00:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4959, 162, 'France', 'Paris', 'N/A', 'monday', '20:00:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4960, 162, 'France', 'Paris', 'N/A', 'friday', '12:30:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4961, 162, 'France', 'Paris', 'N/A', 'tuesday', '20:25:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4962, 162, 'France', 'Paris', 'N/A', 'monday', '20:25:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4963, 162, 'France', 'Paris', 'N/A', 'friday', '12:55:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4964, 162, 'France', 'Paris', 'N/A', 'tuesday', '20:50:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4965, 162, 'France', 'Paris', 'N/A', 'friday', '13:20:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4966, 162, 'France', 'Paris', 'N/A', 'monday', '20:50:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4967, 162, 'France', 'Paris', 'N/A', 'friday', '13:45:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4968, 162, 'France', 'Paris', 'N/A', 'sunday', '12:30:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4969, 162, 'France', 'Paris', 'N/A', 'friday', '14:10:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4970, 162, 'France', 'Paris', 'N/A', 'sunday', '12:55:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4971, 162, 'France', 'Paris', 'N/A', 'friday', '14:35:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4972, 162, 'France', 'Paris', 'N/A', 'sunday', '13:20:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4973, 162, 'France', 'Paris', 'N/A', 'friday', '15:00:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4974, 162, 'France', 'Paris', 'N/A', 'sunday', '13:45:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4975, 162, 'France', 'Paris', 'N/A', 'friday', '15:25:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4976, 162, 'France', 'Paris', 'N/A', 'sunday', '14:10:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4977, 162, 'France', 'Paris', 'N/A', 'friday', '15:50:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4978, 162, 'France', 'Paris', 'N/A', 'sunday', '14:35:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4979, 162, 'France', 'Paris', 'N/A', 'thursday', '12:30:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4980, 162, 'France', 'Paris', 'N/A', 'wednesday', '12:30:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4981, 162, 'France', 'Paris', 'N/A', 'friday', '16:15:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4982, 162, 'France', 'Paris', 'N/A', 'sunday', '15:00:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4983, 162, 'France', 'Paris', 'N/A', 'thursday', '12:55:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4984, 162, 'France', 'Paris', 'N/A', 'wednesday', '12:55:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4985, 162, 'France', 'Paris', 'N/A', 'friday', '16:40:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4986, 162, 'France', 'Paris', 'N/A', 'sunday', '15:25:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4987, 162, 'France', 'Paris', 'N/A', 'thursday', '13:20:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4988, 162, 'France', 'Paris', 'N/A', 'wednesday', '13:20:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4989, 162, 'France', 'Paris', 'N/A', 'friday', '17:05:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4990, 162, 'France', 'Paris', 'N/A', 'sunday', '15:50:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4991, 162, 'France', 'Paris', 'N/A', 'thursday', '13:45:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4992, 162, 'France', 'Paris', 'N/A', 'friday', '17:30:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4993, 162, 'France', 'Paris', 'N/A', 'wednesday', '13:45:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4994, 162, 'France', 'Paris', 'N/A', 'sunday', '16:15:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4995, 162, 'France', 'Paris', 'N/A', 'thursday', '14:10:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4996, 162, 'France', 'Paris', 'N/A', 'friday', '17:55:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4997, 162, 'France', 'Paris', 'N/A', 'wednesday', '14:10:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4998, 162, 'France', 'Paris', 'N/A', 'sunday', '16:40:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(4999, 162, 'France', 'Paris', 'N/A', 'friday', '18:20:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5000, 162, 'France', 'Paris', 'N/A', 'thursday', '14:35:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5001, 162, 'France', 'Paris', 'N/A', 'wednesday', '14:35:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5002, 162, 'France', 'Paris', 'N/A', 'sunday', '17:05:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5003, 162, 'France', 'Paris', 'N/A', 'friday', '18:45:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5004, 162, 'France', 'Paris', 'N/A', 'thursday', '15:00:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5005, 162, 'France', 'Paris', 'N/A', 'wednesday', '15:00:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5006, 162, 'France', 'Paris', 'N/A', 'sunday', '17:30:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5007, 162, 'France', 'Paris', 'N/A', 'friday', '19:10:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5008, 162, 'France', 'Paris', 'N/A', 'thursday', '15:25:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5009, 162, 'France', 'Paris', 'N/A', 'wednesday', '15:25:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42');
INSERT INTO `restaurant_business_hours` (`id`, `restaurant_id`, `country`, `city`, `shift_name`, `day_of_week`, `slot_time`, `added_by`, `created_at`, `updated_at`) VALUES
(5010, 162, 'France', 'Paris', 'N/A', 'sunday', '17:55:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5011, 162, 'France', 'Paris', 'N/A', 'friday', '19:35:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5012, 162, 'France', 'Paris', 'N/A', 'thursday', '15:50:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5013, 162, 'France', 'Paris', 'N/A', 'wednesday', '15:50:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5014, 162, 'France', 'Paris', 'N/A', 'sunday', '18:20:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5015, 162, 'France', 'Paris', 'N/A', 'friday', '20:00:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5016, 162, 'France', 'Paris', 'N/A', 'thursday', '16:15:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5017, 162, 'France', 'Paris', 'N/A', 'wednesday', '16:15:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5018, 162, 'France', 'Paris', 'N/A', 'sunday', '18:45:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5019, 162, 'France', 'Paris', 'N/A', 'friday', '20:25:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5020, 162, 'France', 'Paris', 'N/A', 'thursday', '16:40:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5021, 162, 'France', 'Paris', 'N/A', 'wednesday', '16:40:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5022, 162, 'France', 'Paris', 'N/A', 'sunday', '19:10:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5023, 162, 'France', 'Paris', 'N/A', 'friday', '20:50:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5024, 162, 'France', 'Paris', 'N/A', 'thursday', '17:05:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5025, 162, 'France', 'Paris', 'N/A', 'wednesday', '17:05:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5026, 162, 'France', 'Paris', 'N/A', 'sunday', '19:35:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5027, 162, 'France', 'Paris', 'N/A', 'thursday', '17:30:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5028, 162, 'France', 'Paris', 'N/A', 'wednesday', '17:30:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5029, 162, 'France', 'Paris', 'N/A', 'sunday', '20:00:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5030, 162, 'France', 'Paris', 'N/A', 'thursday', '17:55:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5031, 162, 'France', 'Paris', 'N/A', 'wednesday', '17:55:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5032, 162, 'France', 'Paris', 'N/A', 'sunday', '20:25:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5033, 162, 'France', 'Paris', 'N/A', 'thursday', '18:20:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5034, 162, 'France', 'Paris', 'N/A', 'wednesday', '18:20:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5035, 162, 'France', 'Paris', 'N/A', 'sunday', '20:50:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5036, 162, 'France', 'Paris', 'N/A', 'thursday', '18:45:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5037, 162, 'France', 'Paris', 'N/A', 'wednesday', '18:45:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5038, 162, 'France', 'Paris', 'N/A', 'thursday', '19:10:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5039, 162, 'France', 'Paris', 'N/A', 'wednesday', '19:10:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5040, 162, 'France', 'Paris', 'N/A', 'thursday', '19:35:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5041, 162, 'France', 'Paris', 'N/A', 'wednesday', '19:35:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5042, 162, 'France', 'Paris', 'N/A', 'thursday', '20:00:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5043, 162, 'France', 'Paris', 'N/A', 'wednesday', '20:00:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5044, 162, 'France', 'Paris', 'N/A', 'thursday', '20:25:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5045, 162, 'France', 'Paris', 'N/A', 'wednesday', '20:25:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5046, 162, 'France', 'Paris', 'N/A', 'thursday', '20:50:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5047, 162, 'France', 'Paris', 'N/A', 'wednesday', '20:50:00', 24, '2024-09-03 05:47:42', '2024-09-03 05:47:42'),
(5048, 162, 'France', 'Paris', 'N/A', 'saturday', '12:30:00', 24, '2024-09-03 05:47:43', '2024-09-03 05:47:43'),
(5049, 162, 'France', 'Paris', 'N/A', 'saturday', '12:55:00', 24, '2024-09-03 05:47:43', '2024-09-03 05:47:43'),
(5050, 162, 'France', 'Paris', 'N/A', 'saturday', '13:20:00', 24, '2024-09-03 05:47:43', '2024-09-03 05:47:43'),
(5051, 162, 'France', 'Paris', 'N/A', 'saturday', '13:45:00', 24, '2024-09-03 05:47:43', '2024-09-03 05:47:43'),
(5052, 162, 'France', 'Paris', 'N/A', 'saturday', '14:10:00', 24, '2024-09-03 05:47:43', '2024-09-03 05:47:43'),
(5053, 162, 'France', 'Paris', 'N/A', 'saturday', '14:35:00', 24, '2024-09-03 05:47:43', '2024-09-03 05:47:43'),
(5054, 162, 'France', 'Paris', 'N/A', 'saturday', '15:00:00', 24, '2024-09-03 05:47:43', '2024-09-03 05:47:43'),
(5055, 162, 'France', 'Paris', 'N/A', 'saturday', '15:25:00', 24, '2024-09-03 05:47:43', '2024-09-03 05:47:43'),
(5056, 162, 'France', 'Paris', 'N/A', 'saturday', '15:50:00', 24, '2024-09-03 05:47:43', '2024-09-03 05:47:43'),
(5057, 162, 'France', 'Paris', 'N/A', 'saturday', '16:15:00', 24, '2024-09-03 05:47:43', '2024-09-03 05:47:43'),
(5058, 162, 'France', 'Paris', 'N/A', 'saturday', '16:40:00', 24, '2024-09-03 05:47:43', '2024-09-03 05:47:43'),
(5059, 162, 'France', 'Paris', 'N/A', 'saturday', '17:05:00', 24, '2024-09-03 05:47:43', '2024-09-03 05:47:43'),
(5060, 162, 'France', 'Paris', 'N/A', 'saturday', '17:30:00', 24, '2024-09-03 05:47:43', '2024-09-03 05:47:43'),
(5061, 162, 'France', 'Paris', 'N/A', 'saturday', '17:55:00', 24, '2024-09-03 05:47:43', '2024-09-03 05:47:43'),
(5062, 162, 'France', 'Paris', 'N/A', 'saturday', '18:20:00', 24, '2024-09-03 05:47:43', '2024-09-03 05:47:43'),
(5063, 162, 'France', 'Paris', 'N/A', 'saturday', '18:45:00', 24, '2024-09-03 05:47:43', '2024-09-03 05:47:43'),
(5064, 162, 'France', 'Paris', 'N/A', 'saturday', '19:10:00', 24, '2024-09-03 05:47:43', '2024-09-03 05:47:43'),
(5065, 162, 'France', 'Paris', 'N/A', 'saturday', '19:35:00', 24, '2024-09-03 05:47:43', '2024-09-03 05:47:43'),
(5066, 162, 'France', 'Paris', 'N/A', 'saturday', '20:00:00', 24, '2024-09-03 05:47:43', '2024-09-03 05:47:43'),
(5067, 162, 'France', 'Paris', 'N/A', 'saturday', '20:25:00', 24, '2024-09-03 05:47:43', '2024-09-03 05:47:43'),
(5068, 162, 'France', 'Paris', 'N/A', 'saturday', '20:50:00', 24, '2024-09-03 05:47:43', '2024-09-03 05:47:43'),
(5069, 163, 'France', 'Paris', 'N/A', 'monday', '12:00:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5070, 163, 'France', 'Paris', 'N/A', 'monday', '12:35:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5071, 163, 'France', 'Paris', 'N/A', 'monday', '13:10:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5072, 163, 'France', 'Paris', 'N/A', 'monday', '13:45:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5073, 163, 'France', 'Paris', 'N/A', 'monday', '14:20:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5074, 163, 'France', 'Paris', 'N/A', 'monday', '14:55:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5075, 163, 'France', 'Paris', 'N/A', 'monday', '15:30:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5076, 163, 'France', 'Paris', 'N/A', 'monday', '16:05:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5077, 163, 'France', 'Paris', 'N/A', 'sunday', '12:00:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5078, 163, 'France', 'Paris', 'N/A', 'monday', '16:40:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5079, 163, 'France', 'Paris', 'N/A', 'sunday', '12:35:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5080, 163, 'France', 'Paris', 'N/A', 'monday', '17:15:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5081, 163, 'France', 'Paris', 'N/A', 'sunday', '13:10:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5082, 163, 'France', 'Paris', 'N/A', 'monday', '17:50:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5083, 163, 'France', 'Paris', 'N/A', 'sunday', '13:45:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5084, 163, 'France', 'Paris', 'N/A', 'monday', '18:25:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5085, 163, 'France', 'Paris', 'N/A', 'sunday', '14:20:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5086, 163, 'France', 'Paris', 'N/A', 'monday', '19:00:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5087, 163, 'France', 'Paris', 'N/A', 'sunday', '14:55:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5088, 163, 'France', 'Paris', 'N/A', 'monday', '19:35:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5089, 163, 'France', 'Paris', 'N/A', 'sunday', '15:30:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5090, 163, 'France', 'Paris', 'N/A', 'monday', '20:10:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5091, 163, 'France', 'Paris', 'N/A', 'sunday', '16:05:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5092, 163, 'France', 'Paris', 'N/A', 'monday', '20:45:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5093, 163, 'France', 'Paris', 'N/A', 'sunday', '16:40:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5094, 163, 'France', 'Paris', 'N/A', 'monday', '21:20:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5095, 163, 'France', 'Paris', 'N/A', 'sunday', '17:15:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5096, 163, 'France', 'Paris', 'N/A', 'monday', '21:55:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5097, 163, 'France', 'Paris', 'N/A', 'sunday', '17:50:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5098, 163, 'France', 'Paris', 'N/A', 'monday', '22:30:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5099, 163, 'France', 'Paris', 'N/A', 'sunday', '18:25:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5100, 163, 'France', 'Paris', 'N/A', 'monday', '23:05:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5101, 163, 'France', 'Paris', 'N/A', 'sunday', '19:00:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5102, 163, 'France', 'Paris', 'N/A', 'monday', '23:40:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5103, 163, 'France', 'Paris', 'N/A', 'sunday', '19:35:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5104, 163, 'France', 'Paris', 'N/A', 'sunday', '20:10:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5105, 163, 'France', 'Paris', 'N/A', 'sunday', '20:45:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5106, 163, 'France', 'Paris', 'N/A', 'sunday', '21:20:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5107, 163, 'France', 'Paris', 'N/A', 'sunday', '21:55:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5108, 163, 'France', 'Paris', 'N/A', 'sunday', '22:30:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5109, 163, 'France', 'Paris', 'N/A', 'sunday', '23:05:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5110, 163, 'France', 'Paris', 'N/A', 'sunday', '23:40:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5111, 163, 'France', 'Paris', 'N/A', 'friday', '12:00:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5112, 163, 'France', 'Paris', 'N/A', 'friday', '12:35:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5113, 163, 'France', 'Paris', 'N/A', 'friday', '13:10:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5114, 163, 'France', 'Paris', 'N/A', 'friday', '13:45:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5115, 163, 'France', 'Paris', 'N/A', 'friday', '14:20:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5116, 163, 'France', 'Paris', 'N/A', 'friday', '14:55:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5117, 163, 'France', 'Paris', 'N/A', 'friday', '15:30:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5118, 163, 'France', 'Paris', 'N/A', 'friday', '16:05:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5119, 163, 'France', 'Paris', 'N/A', 'friday', '16:40:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5120, 163, 'France', 'Paris', 'N/A', 'friday', '17:15:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5121, 163, 'France', 'Paris', 'N/A', 'friday', '17:50:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5122, 163, 'France', 'Paris', 'N/A', 'friday', '18:25:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5123, 163, 'France', 'Paris', 'N/A', 'friday', '19:00:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5124, 163, 'France', 'Paris', 'N/A', 'tuesday', '12:00:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5125, 163, 'France', 'Paris', 'N/A', 'friday', '19:35:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5126, 163, 'France', 'Paris', 'N/A', 'tuesday', '12:35:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5127, 163, 'France', 'Paris', 'N/A', 'friday', '20:10:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5128, 163, 'France', 'Paris', 'N/A', 'tuesday', '13:10:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5129, 163, 'France', 'Paris', 'N/A', 'friday', '20:45:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5130, 163, 'France', 'Paris', 'N/A', 'tuesday', '13:45:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5131, 163, 'France', 'Paris', 'N/A', 'friday', '21:20:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5132, 163, 'France', 'Paris', 'N/A', 'tuesday', '14:20:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5133, 163, 'France', 'Paris', 'N/A', 'friday', '21:55:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5134, 163, 'France', 'Paris', 'N/A', 'tuesday', '14:55:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5135, 163, 'France', 'Paris', 'N/A', 'friday', '22:30:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5136, 163, 'France', 'Paris', 'N/A', 'tuesday', '15:30:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5137, 163, 'France', 'Paris', 'N/A', 'friday', '23:05:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5138, 163, 'France', 'Paris', 'N/A', 'tuesday', '16:05:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5139, 163, 'France', 'Paris', 'N/A', 'wednesday', '12:00:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5140, 163, 'France', 'Paris', 'N/A', 'friday', '23:40:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5141, 163, 'France', 'Paris', 'N/A', 'tuesday', '16:40:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5142, 163, 'France', 'Paris', 'N/A', 'wednesday', '12:35:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5143, 163, 'France', 'Paris', 'N/A', 'tuesday', '17:15:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5144, 163, 'France', 'Paris', 'N/A', 'wednesday', '13:10:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5145, 163, 'France', 'Paris', 'N/A', 'tuesday', '17:50:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5146, 163, 'France', 'Paris', 'N/A', 'wednesday', '13:45:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5147, 163, 'France', 'Paris', 'N/A', 'wednesday', '14:20:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5148, 163, 'France', 'Paris', 'N/A', 'tuesday', '18:25:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5149, 163, 'France', 'Paris', 'N/A', 'wednesday', '14:55:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5150, 163, 'France', 'Paris', 'N/A', 'tuesday', '19:00:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5151, 163, 'France', 'Paris', 'N/A', 'wednesday', '15:30:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5152, 163, 'France', 'Paris', 'N/A', 'tuesday', '19:35:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5153, 163, 'France', 'Paris', 'N/A', 'wednesday', '16:05:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5154, 163, 'France', 'Paris', 'N/A', 'tuesday', '20:10:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5155, 163, 'France', 'Paris', 'N/A', 'wednesday', '16:40:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5156, 163, 'France', 'Paris', 'N/A', 'tuesday', '20:45:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5157, 163, 'France', 'Paris', 'N/A', 'wednesday', '17:15:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5158, 163, 'France', 'Paris', 'N/A', 'tuesday', '21:20:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5159, 163, 'France', 'Paris', 'N/A', 'wednesday', '17:50:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5160, 163, 'France', 'Paris', 'N/A', 'tuesday', '21:55:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5161, 163, 'France', 'Paris', 'N/A', 'wednesday', '18:25:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5162, 163, 'France', 'Paris', 'N/A', 'tuesday', '22:30:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5163, 163, 'France', 'Paris', 'N/A', 'wednesday', '19:00:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5164, 163, 'France', 'Paris', 'N/A', 'tuesday', '23:05:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5165, 163, 'France', 'Paris', 'N/A', 'wednesday', '19:35:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5166, 163, 'France', 'Paris', 'N/A', 'tuesday', '23:40:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5167, 163, 'France', 'Paris', 'N/A', 'wednesday', '20:10:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5168, 163, 'France', 'Paris', 'N/A', 'wednesday', '20:45:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5169, 163, 'France', 'Paris', 'N/A', 'wednesday', '21:20:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5170, 163, 'France', 'Paris', 'N/A', 'wednesday', '21:55:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5171, 163, 'France', 'Paris', 'N/A', 'wednesday', '22:30:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5172, 163, 'France', 'Paris', 'N/A', 'wednesday', '23:05:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5173, 163, 'France', 'Paris', 'N/A', 'wednesday', '23:40:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5174, 163, 'France', 'Paris', 'N/A', 'thursday', '12:00:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5175, 163, 'France', 'Paris', 'N/A', 'thursday', '12:35:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5176, 163, 'France', 'Paris', 'N/A', 'thursday', '13:10:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5177, 163, 'France', 'Paris', 'N/A', 'thursday', '13:45:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5178, 163, 'France', 'Paris', 'N/A', 'thursday', '14:20:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5179, 163, 'France', 'Paris', 'N/A', 'thursday', '14:55:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5180, 163, 'France', 'Paris', 'N/A', 'thursday', '15:30:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5181, 163, 'France', 'Paris', 'N/A', 'thursday', '16:05:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5182, 163, 'France', 'Paris', 'N/A', 'thursday', '16:40:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5183, 163, 'France', 'Paris', 'N/A', 'thursday', '17:15:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5184, 163, 'France', 'Paris', 'N/A', 'thursday', '17:50:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5185, 163, 'France', 'Paris', 'N/A', 'thursday', '18:25:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5186, 163, 'France', 'Paris', 'N/A', 'thursday', '19:00:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5187, 163, 'France', 'Paris', 'N/A', 'thursday', '19:35:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5188, 163, 'France', 'Paris', 'N/A', 'thursday', '20:10:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5189, 163, 'France', 'Paris', 'N/A', 'thursday', '20:45:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5190, 163, 'France', 'Paris', 'N/A', 'thursday', '21:20:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5191, 163, 'France', 'Paris', 'N/A', 'thursday', '21:55:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5192, 163, 'France', 'Paris', 'N/A', 'thursday', '22:30:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5193, 163, 'France', 'Paris', 'N/A', 'thursday', '23:05:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5194, 163, 'France', 'Paris', 'N/A', 'thursday', '23:40:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5195, 163, 'France', 'Paris', 'N/A', 'saturday', '12:00:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5196, 163, 'France', 'Paris', 'N/A', 'saturday', '12:35:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5197, 163, 'France', 'Paris', 'N/A', 'saturday', '13:10:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5198, 163, 'France', 'Paris', 'N/A', 'saturday', '13:45:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5199, 163, 'France', 'Paris', 'N/A', 'saturday', '14:20:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5200, 163, 'France', 'Paris', 'N/A', 'saturday', '14:55:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5201, 163, 'France', 'Paris', 'N/A', 'saturday', '15:30:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5202, 163, 'France', 'Paris', 'N/A', 'saturday', '16:05:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5203, 163, 'France', 'Paris', 'N/A', 'saturday', '16:40:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5204, 163, 'France', 'Paris', 'N/A', 'saturday', '17:15:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5205, 163, 'France', 'Paris', 'N/A', 'saturday', '17:50:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5206, 163, 'France', 'Paris', 'N/A', 'saturday', '18:25:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5207, 163, 'France', 'Paris', 'N/A', 'saturday', '19:00:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5208, 163, 'France', 'Paris', 'N/A', 'saturday', '19:35:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5209, 163, 'France', 'Paris', 'N/A', 'saturday', '20:10:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5210, 163, 'France', 'Paris', 'N/A', 'saturday', '20:45:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5211, 163, 'France', 'Paris', 'N/A', 'saturday', '21:20:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5212, 163, 'France', 'Paris', 'N/A', 'saturday', '21:55:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5213, 163, 'France', 'Paris', 'N/A', 'saturday', '22:30:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5214, 163, 'France', 'Paris', 'N/A', 'saturday', '23:05:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5215, 163, 'France', 'Paris', 'N/A', 'saturday', '23:40:00', 24, '2024-09-03 05:48:13', '2024-09-03 05:48:13'),
(5216, 164, 'France', 'Paris', 'N/A', 'saturday', '11:00:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5217, 164, 'France', 'Paris', 'N/A', 'saturday', '11:35:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5218, 164, 'France', 'Paris', 'N/A', 'saturday', '12:10:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5219, 164, 'France', 'Paris', 'N/A', 'saturday', '12:45:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5220, 164, 'France', 'Paris', 'N/A', 'saturday', '13:20:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5221, 164, 'France', 'Paris', 'N/A', 'saturday', '13:55:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5222, 164, 'France', 'Paris', 'N/A', 'tuesday', '11:00:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5223, 164, 'France', 'Paris', 'N/A', 'saturday', '14:30:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5224, 164, 'France', 'Paris', 'N/A', 'tuesday', '11:35:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5225, 164, 'France', 'Paris', 'N/A', 'friday', '11:00:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5226, 164, 'France', 'Paris', 'N/A', 'saturday', '15:05:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5227, 164, 'France', 'Paris', 'N/A', 'tuesday', '12:10:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5228, 164, 'France', 'Paris', 'N/A', 'friday', '11:35:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5229, 164, 'France', 'Paris', 'N/A', 'saturday', '15:40:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5230, 164, 'France', 'Paris', 'N/A', 'tuesday', '12:45:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5231, 164, 'France', 'Paris', 'N/A', 'friday', '12:10:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5232, 164, 'France', 'Paris', 'N/A', 'saturday', '16:15:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5233, 164, 'France', 'Paris', 'N/A', 'tuesday', '13:20:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5234, 164, 'France', 'Paris', 'N/A', 'friday', '12:45:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5235, 164, 'France', 'Paris', 'N/A', 'saturday', '16:50:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5236, 164, 'France', 'Paris', 'N/A', 'friday', '13:20:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5237, 164, 'France', 'Paris', 'N/A', 'tuesday', '13:55:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5238, 164, 'France', 'Paris', 'N/A', 'saturday', '17:25:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5239, 164, 'France', 'Paris', 'N/A', 'friday', '13:55:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5240, 164, 'France', 'Paris', 'N/A', 'tuesday', '14:30:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5241, 164, 'France', 'Paris', 'N/A', 'saturday', '18:00:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5242, 164, 'France', 'Paris', 'N/A', 'friday', '14:30:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5243, 164, 'France', 'Paris', 'N/A', 'tuesday', '15:05:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5244, 164, 'France', 'Paris', 'N/A', 'saturday', '18:35:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5245, 164, 'France', 'Paris', 'N/A', 'friday', '15:05:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5246, 164, 'France', 'Paris', 'N/A', 'tuesday', '15:40:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5247, 164, 'France', 'Paris', 'N/A', 'saturday', '19:10:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5248, 164, 'France', 'Paris', 'N/A', 'friday', '15:40:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5249, 164, 'France', 'Paris', 'N/A', 'tuesday', '16:15:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5250, 164, 'France', 'Paris', 'N/A', 'saturday', '19:45:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5251, 164, 'France', 'Paris', 'N/A', 'friday', '16:15:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5252, 164, 'France', 'Paris', 'N/A', 'tuesday', '16:50:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5253, 164, 'France', 'Paris', 'N/A', 'saturday', '20:20:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5254, 164, 'France', 'Paris', 'N/A', 'friday', '16:50:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5255, 164, 'France', 'Paris', 'N/A', 'tuesday', '17:25:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5256, 164, 'France', 'Paris', 'N/A', 'friday', '17:25:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5257, 164, 'France', 'Paris', 'N/A', 'thursday', '11:00:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5258, 164, 'France', 'Paris', 'N/A', 'saturday', '20:55:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5259, 164, 'France', 'Paris', 'N/A', 'tuesday', '18:00:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5260, 164, 'France', 'Paris', 'N/A', 'thursday', '11:35:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5261, 164, 'France', 'Paris', 'N/A', 'friday', '18:00:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5262, 164, 'France', 'Paris', 'N/A', 'saturday', '21:30:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5263, 164, 'France', 'Paris', 'N/A', 'tuesday', '18:35:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5264, 164, 'France', 'Paris', 'N/A', 'thursday', '12:10:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5265, 164, 'France', 'Paris', 'N/A', 'friday', '18:35:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5266, 164, 'France', 'Paris', 'N/A', 'saturday', '22:05:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5267, 164, 'France', 'Paris', 'N/A', 'tuesday', '19:10:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5268, 164, 'France', 'Paris', 'N/A', 'thursday', '12:45:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5269, 164, 'France', 'Paris', 'N/A', 'monday', '11:00:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5270, 164, 'France', 'Paris', 'N/A', 'friday', '19:10:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5271, 164, 'France', 'Paris', 'N/A', 'saturday', '22:40:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5272, 164, 'France', 'Paris', 'N/A', 'tuesday', '19:45:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5273, 164, 'France', 'Paris', 'N/A', 'monday', '11:35:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5274, 164, 'France', 'Paris', 'N/A', 'thursday', '13:20:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5275, 164, 'France', 'Paris', 'N/A', 'friday', '19:45:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5276, 164, 'France', 'Paris', 'N/A', 'tuesday', '20:20:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5277, 164, 'France', 'Paris', 'N/A', 'monday', '12:10:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5278, 164, 'France', 'Paris', 'N/A', 'friday', '20:20:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5279, 164, 'France', 'Paris', 'N/A', 'thursday', '13:55:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5280, 164, 'France', 'Paris', 'N/A', 'tuesday', '20:55:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5281, 164, 'France', 'Paris', 'N/A', 'monday', '12:45:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5282, 164, 'France', 'Paris', 'N/A', 'friday', '20:55:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5283, 164, 'France', 'Paris', 'N/A', 'wednesday', '11:00:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5284, 164, 'France', 'Paris', 'N/A', 'thursday', '14:30:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5285, 164, 'France', 'Paris', 'N/A', 'tuesday', '21:30:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5286, 164, 'France', 'Paris', 'N/A', 'monday', '13:20:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5287, 164, 'France', 'Paris', 'N/A', 'friday', '21:30:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5288, 164, 'France', 'Paris', 'N/A', 'wednesday', '11:35:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5289, 164, 'France', 'Paris', 'N/A', 'thursday', '15:05:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5290, 164, 'France', 'Paris', 'N/A', 'tuesday', '22:05:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5291, 164, 'France', 'Paris', 'N/A', 'wednesday', '12:10:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5292, 164, 'France', 'Paris', 'N/A', 'friday', '22:05:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5293, 164, 'France', 'Paris', 'N/A', 'monday', '13:55:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5294, 164, 'France', 'Paris', 'N/A', 'thursday', '15:40:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5295, 164, 'France', 'Paris', 'N/A', 'tuesday', '22:40:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5296, 164, 'France', 'Paris', 'N/A', 'wednesday', '12:45:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5297, 164, 'France', 'Paris', 'N/A', 'monday', '14:30:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5298, 164, 'France', 'Paris', 'N/A', 'thursday', '16:15:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5299, 164, 'France', 'Paris', 'N/A', 'friday', '22:40:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5300, 164, 'France', 'Paris', 'N/A', 'wednesday', '13:20:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5301, 164, 'France', 'Paris', 'N/A', 'thursday', '16:50:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5302, 164, 'France', 'Paris', 'N/A', 'monday', '15:05:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5303, 164, 'France', 'Paris', 'N/A', 'thursday', '17:25:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5304, 164, 'France', 'Paris', 'N/A', 'wednesday', '13:55:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5305, 164, 'France', 'Paris', 'N/A', 'monday', '15:40:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5306, 164, 'France', 'Paris', 'N/A', 'thursday', '18:00:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5307, 164, 'France', 'Paris', 'N/A', 'wednesday', '14:30:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5308, 164, 'France', 'Paris', 'N/A', 'monday', '16:15:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5309, 164, 'France', 'Paris', 'N/A', 'thursday', '18:35:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5310, 164, 'France', 'Paris', 'N/A', 'wednesday', '15:05:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5311, 164, 'France', 'Paris', 'N/A', 'monday', '16:50:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5312, 164, 'France', 'Paris', 'N/A', 'thursday', '19:10:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5313, 164, 'France', 'Paris', 'N/A', 'wednesday', '15:40:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5314, 164, 'France', 'Paris', 'N/A', 'monday', '17:25:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5315, 164, 'France', 'Paris', 'N/A', 'thursday', '19:45:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5316, 164, 'France', 'Paris', 'N/A', 'wednesday', '16:15:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5317, 164, 'France', 'Paris', 'N/A', 'monday', '18:00:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5318, 164, 'France', 'Paris', 'N/A', 'thursday', '20:20:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5319, 164, 'France', 'Paris', 'N/A', 'wednesday', '16:50:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5320, 164, 'France', 'Paris', 'N/A', 'monday', '18:35:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5321, 164, 'France', 'Paris', 'N/A', 'thursday', '20:55:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5322, 164, 'France', 'Paris', 'N/A', 'wednesday', '17:25:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5323, 164, 'France', 'Paris', 'N/A', 'monday', '19:10:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5324, 164, 'France', 'Paris', 'N/A', 'thursday', '21:30:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5325, 164, 'France', 'Paris', 'N/A', 'wednesday', '18:00:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5326, 164, 'France', 'Paris', 'N/A', 'monday', '19:45:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5327, 164, 'France', 'Paris', 'N/A', 'thursday', '22:05:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5328, 164, 'France', 'Paris', 'N/A', 'wednesday', '18:35:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5329, 164, 'France', 'Paris', 'N/A', 'monday', '20:20:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5330, 164, 'France', 'Paris', 'N/A', 'thursday', '22:40:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5331, 164, 'France', 'Paris', 'N/A', 'wednesday', '19:10:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5332, 164, 'France', 'Paris', 'N/A', 'monday', '20:55:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5333, 164, 'France', 'Paris', 'N/A', 'wednesday', '19:45:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5334, 164, 'France', 'Paris', 'N/A', 'monday', '21:30:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5335, 164, 'France', 'Paris', 'N/A', 'wednesday', '20:20:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5336, 164, 'France', 'Paris', 'N/A', 'monday', '22:05:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5337, 164, 'France', 'Paris', 'N/A', 'wednesday', '20:55:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5338, 164, 'France', 'Paris', 'N/A', 'monday', '22:40:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5339, 164, 'France', 'Paris', 'N/A', 'wednesday', '21:30:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5340, 164, 'France', 'Paris', 'N/A', 'wednesday', '22:05:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5341, 164, 'France', 'Paris', 'N/A', 'wednesday', '22:40:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5342, 164, 'France', 'Paris', 'N/A', 'sunday', '11:00:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5343, 164, 'France', 'Paris', 'N/A', 'sunday', '11:35:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5344, 164, 'France', 'Paris', 'N/A', 'sunday', '12:10:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5345, 164, 'France', 'Paris', 'N/A', 'sunday', '12:45:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5346, 164, 'France', 'Paris', 'N/A', 'sunday', '13:20:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5347, 164, 'France', 'Paris', 'N/A', 'sunday', '13:55:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5348, 164, 'France', 'Paris', 'N/A', 'sunday', '14:30:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5349, 164, 'France', 'Paris', 'N/A', 'sunday', '15:05:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5350, 164, 'France', 'Paris', 'N/A', 'sunday', '15:40:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5351, 164, 'France', 'Paris', 'N/A', 'sunday', '16:15:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5352, 164, 'France', 'Paris', 'N/A', 'sunday', '16:50:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5353, 164, 'France', 'Paris', 'N/A', 'sunday', '17:25:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5354, 164, 'France', 'Paris', 'N/A', 'sunday', '18:00:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5355, 164, 'France', 'Paris', 'N/A', 'sunday', '18:35:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5356, 164, 'France', 'Paris', 'N/A', 'sunday', '19:10:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5357, 164, 'France', 'Paris', 'N/A', 'sunday', '19:45:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5358, 164, 'France', 'Paris', 'N/A', 'sunday', '20:20:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5359, 164, 'France', 'Paris', 'N/A', 'sunday', '20:55:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5360, 164, 'France', 'Paris', 'N/A', 'sunday', '21:30:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5361, 164, 'France', 'Paris', 'N/A', 'sunday', '22:05:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5362, 164, 'France', 'Paris', 'N/A', 'sunday', '22:40:00', 24, '2024-09-03 05:51:51', '2024-09-03 05:51:51'),
(5363, 165, 'France', 'Paris', 'N/A', 'thursday', '10:30:00', 24, '2024-09-08 23:38:15', '2024-09-08 23:38:15'),
(5364, 165, 'France', 'Paris', 'N/A', 'thursday', '11:30:00', 24, '2024-09-08 23:38:15', '2024-09-08 23:38:15'),
(5365, 165, 'France', 'Paris', 'N/A', 'thursday', '12:15:00', 24, '2024-09-08 23:38:15', '2024-09-08 23:38:15'),
(5366, 165, 'France', 'Paris', 'N/A', 'thursday', '15:15:00', 24, '2024-09-08 23:38:15', '2024-09-08 23:38:15'),
(5367, 165, 'France', 'Paris', 'N/A', 'thursday', '20:00:00', 24, '2024-09-08 23:38:15', '2024-09-08 23:38:15'),
(5368, 165, 'France', 'Paris', 'N/A', 'thursday', '21:15:00', 24, '2024-09-08 23:38:15', '2024-09-08 23:38:15'),
(5369, 165, 'France', 'Paris', 'N/A', 'tuesday', '10:30:00', 24, '2024-09-08 23:38:15', '2024-09-08 23:38:15'),
(5370, 165, 'France', 'Paris', 'N/A', 'tuesday', '11:30:00', 24, '2024-09-08 23:38:15', '2024-09-08 23:38:15'),
(5371, 165, 'France', 'Paris', 'N/A', 'tuesday', '12:15:00', 24, '2024-09-08 23:38:15', '2024-09-08 23:38:15'),
(5372, 165, 'France', 'Paris', 'N/A', 'tuesday', '15:15:00', 24, '2024-09-08 23:38:15', '2024-09-08 23:38:15'),
(5373, 165, 'France', 'Paris', 'N/A', 'tuesday', '20:00:00', 24, '2024-09-08 23:38:15', '2024-09-08 23:38:15'),
(5374, 165, 'France', 'Paris', 'N/A', 'tuesday', '21:15:00', 24, '2024-09-08 23:38:15', '2024-09-08 23:38:15'),
(5375, 165, 'France', 'Paris', 'N/A', 'monday', '10:30:00', 24, '2024-09-08 23:38:15', '2024-09-08 23:38:15'),
(5376, 165, 'France', 'Paris', 'N/A', 'monday', '11:30:00', 24, '2024-09-08 23:38:15', '2024-09-08 23:38:15'),
(5377, 165, 'France', 'Paris', 'N/A', 'monday', '12:15:00', 24, '2024-09-08 23:38:15', '2024-09-08 23:38:15'),
(5378, 165, 'France', 'Paris', 'N/A', 'monday', '15:15:00', 24, '2024-09-08 23:38:15', '2024-09-08 23:38:15'),
(5379, 165, 'France', 'Paris', 'N/A', 'monday', '20:00:00', 24, '2024-09-08 23:38:15', '2024-09-08 23:38:15'),
(5380, 165, 'France', 'Paris', 'N/A', 'monday', '21:15:00', 24, '2024-09-08 23:38:15', '2024-09-08 23:38:15');

-- --------------------------------------------------------

--
-- Table structure for table `restaurant_shift_schedule`
--

CREATE TABLE `restaurant_shift_schedule` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `restaurant_id` int(11) NOT NULL,
  `added_by` int(11) NOT NULL,
  `deleted` enum('0','1') NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `restaurant_shift_schedule`
--

INSERT INTO `restaurant_shift_schedule` (`id`, `restaurant_id`, `added_by`, `deleted`, `created_at`, `updated_at`) VALUES
(31, 64, 24, '1', '2024-06-04 08:11:18', '2024-06-04 08:11:18'),
(32, 65, 24, '1', '2024-06-04 08:13:01', '2024-06-04 08:13:01'),
(33, 66, 24, '1', '2024-06-06 01:03:19', '2024-06-06 01:03:19'),
(34, 67, 24, '1', '2024-06-06 01:06:50', '2024-06-06 01:06:50'),
(35, 68, 24, '1', '2024-06-06 01:10:41', '2024-06-06 01:10:41'),
(36, 69, 24, '1', '2024-06-06 01:11:47', '2024-06-06 01:11:47'),
(37, 70, 24, '1', '2024-06-06 01:14:53', '2024-06-06 01:14:53'),
(38, 71, 24, '1', '2024-06-06 01:17:14', '2024-06-06 01:17:14'),
(39, 72, 24, '1', '2024-06-06 01:20:52', '2024-06-06 01:20:52'),
(41, 11, 24, '1', '2024-06-20 00:55:39', '2024-06-20 00:55:39'),
(42, 85, 24, '1', '2024-06-20 07:46:24', '2024-06-20 07:46:24'),
(43, 87, 24, '1', '2024-07-25 23:31:28', '2024-07-25 23:31:28'),
(44, 86, 24, '1', '2024-07-25 23:37:38', '2024-07-25 23:37:38'),
(45, 88, 24, '1', '2024-08-04 23:23:06', '2024-08-04 23:23:06'),
(46, 89, 24, '1', '2024-08-04 23:27:38', '2024-08-04 23:27:38'),
(47, 90, 24, '1', '2024-08-04 23:30:22', '2024-08-04 23:30:22'),
(48, 91, 24, '1', '2024-08-04 23:32:03', '2024-08-04 23:32:03'),
(49, 92, 24, '1', '2024-08-04 23:35:04', '2024-08-04 23:35:04'),
(50, 93, 24, '1', '2024-08-04 23:36:53', '2024-08-04 23:36:53'),
(51, 94, 24, '1', '2024-08-04 23:38:14', '2024-08-04 23:38:14'),
(52, 95, 24, '1', '2024-08-04 23:39:33', '2024-08-04 23:39:33'),
(53, 96, 24, '1', '2024-08-04 23:41:23', '2024-08-04 23:41:23'),
(54, 97, 24, '1', '2024-08-04 23:42:50', '2024-08-04 23:42:50'),
(55, 98, 24, '1', '2024-08-04 23:45:39', '2024-08-04 23:45:39'),
(56, 99, 24, '1', '2024-08-04 23:47:23', '2024-08-04 23:47:23'),
(57, 100, 24, '1', '2024-08-04 23:48:51', '2024-08-04 23:48:51'),
(58, 101, 24, '1', '2024-08-04 23:50:39', '2024-08-04 23:50:39'),
(59, 102, 24, '1', '2024-08-04 23:52:22', '2024-08-04 23:52:22'),
(60, 104, 24, '1', '2024-08-04 23:54:31', '2024-08-04 23:54:31'),
(61, 106, 24, '1', '2024-08-04 23:56:10', '2024-08-04 23:56:10'),
(62, 105, 24, '1', '2024-08-04 23:57:42', '2024-08-04 23:57:42'),
(63, 108, 24, '1', '2024-08-05 01:02:22', '2024-08-05 01:02:22'),
(64, 110, 24, '1', '2024-08-08 08:31:12', '2024-08-08 08:31:12'),
(65, 114, 24, '1', '2024-08-09 01:25:52', '2024-08-09 01:25:52'),
(66, 123, 24, '1', '2024-08-13 06:58:32', '2024-08-13 06:58:32'),
(67, 153, 24, '1', '2024-09-03 04:29:33', '2024-09-03 04:29:33'),
(68, 154, 24, '1', '2024-09-03 04:31:38', '2024-09-03 04:31:38'),
(69, 155, 24, '1', '2024-09-03 04:33:27', '2024-09-03 04:33:27'),
(70, 156, 24, '1', '2024-09-03 04:34:53', '2024-09-03 04:34:53'),
(71, 157, 24, '1', '2024-09-03 04:37:03', '2024-09-03 04:37:03'),
(72, 158, 24, '1', '2024-09-03 04:39:02', '2024-09-03 04:39:02'),
(73, 159, 24, '1', '2024-09-03 04:40:11', '2024-09-03 04:40:11'),
(74, 160, 24, '1', '2024-09-03 05:37:00', '2024-09-03 05:37:00'),
(75, 161, 24, '1', '2024-09-03 05:38:42', '2024-09-03 05:38:42'),
(76, 162, 24, '1', '2024-09-03 05:41:35', '2024-09-03 05:41:35'),
(77, 163, 24, '1', '2024-09-03 05:44:10', '2024-09-03 05:44:10'),
(78, 164, 24, '1', '2024-09-03 05:45:20', '2024-09-03 05:45:20');

-- --------------------------------------------------------

--
-- Table structure for table `restaurant_shift_timing`
--

CREATE TABLE `restaurant_shift_timing` (
  `time_id` bigint(20) UNSIGNED NOT NULL,
  `country` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `monday_start_time` time DEFAULT NULL,
  `monday_end_time` time DEFAULT NULL,
  `tuesday_start_time` time DEFAULT NULL,
  `tuesday_end_time` time DEFAULT NULL,
  `wednesday_start_time` time DEFAULT NULL,
  `wednesday_end_time` time DEFAULT NULL,
  `thursday_start_time` time DEFAULT NULL,
  `thursday_end_time` time DEFAULT NULL,
  `friday_start_time` time DEFAULT NULL,
  `friday_end_time` time DEFAULT NULL,
  `saturday_start_time` time DEFAULT NULL,
  `saturday_end_time` time DEFAULT NULL,
  `sunday_start_time` time DEFAULT NULL,
  `sunday_end_time` time DEFAULT NULL,
  `deleted` enum('0','1') NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `schedule_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `restaurant_shift_timing`
--

INSERT INTO `restaurant_shift_timing` (`time_id`, `country`, `city`, `monday_start_time`, `monday_end_time`, `tuesday_start_time`, `tuesday_end_time`, `wednesday_start_time`, `wednesday_end_time`, `thursday_start_time`, `thursday_end_time`, `friday_start_time`, `friday_end_time`, `saturday_start_time`, `saturday_end_time`, `sunday_start_time`, `sunday_end_time`, `deleted`, `created_at`, `updated_at`, `schedule_id`) VALUES
(25, 'France', 'Paris', '12:00:00', '23:15:00', '12:00:00', '23:15:00', '12:00:00', '23:15:00', '12:00:00', '23:15:00', '12:00:00', '23:15:00', '12:00:00', '23:15:00', '12:00:00', '23:15:00', '1', '2024-06-04 08:11:18', '2024-06-04 08:11:18', 31),
(26, 'France', 'Paris', '11:30:00', '23:00:00', '11:30:00', '23:00:00', '11:30:00', '23:00:00', '11:30:00', '23:00:00', '11:30:00', '23:00:00', '11:30:00', '23:00:00', '11:30:00', '23:00:00', '1', '2024-06-04 08:13:01', '2024-06-04 08:13:01', 32),
(27, 'France', 'Paris', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '1', '2024-06-06 01:03:19', '2024-06-06 01:03:19', 33),
(28, 'France', 'Paris', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '1', '2024-06-06 01:06:50', '2024-06-06 01:06:50', 34),
(29, 'France', 'Paris', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '1', '2024-06-06 01:10:41', '2024-06-06 01:10:41', 35),
(30, 'France', 'Paris', '11:30:00', '00:00:00', '11:30:00', '00:00:00', '11:30:00', '00:00:00', '11:30:00', '00:00:00', '11:30:00', '00:00:00', '11:30:00', '00:00:00', '11:30:00', '00:00:00', '1', '2024-06-06 01:11:47', '2024-06-06 01:11:47', 36),
(31, 'France', 'Paris', '19:00:00', '23:00:00', '19:00:00', '23:00:00', '19:00:00', '23:00:00', '19:00:00', '23:00:00', '13:00:00', '23:00:00', '13:00:00', '23:00:00', '13:00:00', '23:00:00', '1', '2024-06-06 01:14:53', '2024-06-06 01:14:53', 37),
(32, 'France', 'Paris', '12:00:00', '22:00:00', '12:00:00', '22:00:00', '12:00:00', '22:00:00', '12:00:00', '22:00:00', '12:00:00', '22:00:00', '12:00:00', '23:00:00', '12:00:00', '23:00:00', '1', '2024-06-06 01:17:14', '2024-06-06 01:17:14', 38),
(33, 'France', 'Paris', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '1', '2024-06-06 01:20:52', '2024-06-06 01:20:52', 39),
(35, 'France', 'Paris', '10:00:00', '00:00:00', '10:00:00', '23:00:00', '10:00:00', '23:00:00', NULL, NULL, '10:00:00', '23:00:00', '10:00:00', '23:00:00', '10:00:00', '23:00:00', '1', '2024-06-20 00:55:39', '2024-06-20 00:56:53', 41),
(36, 'India', 'Noida', NULL, NULL, '09:00:00', '23:00:00', '09:00:00', '23:00:00', '09:00:00', '23:00:00', '09:00:00', '23:00:00', '09:00:00', '23:00:00', '09:00:00', '23:00:00', '1', '2024-06-20 07:46:24', '2024-06-20 07:46:24', 42),
(37, 'France', 'Paris', NULL, NULL, '09:15:00', '20:00:00', '09:15:00', '20:00:00', '09:15:00', '20:00:00', '09:15:00', '20:00:00', '09:15:00', '20:00:00', '09:30:00', '13:30:00', '1', '2024-07-25 23:31:28', '2024-07-25 23:31:28', 43),
(38, 'France', 'Paris', NULL, NULL, '12:15:00', '21:45:00', '12:15:00', '21:45:00', '12:15:00', '21:45:00', '12:15:00', '21:45:00', '12:15:00', '21:45:00', NULL, NULL, '1', '2024-07-25 23:37:38', '2024-07-25 23:37:38', 44),
(39, 'France', 'Paris', '09:30:00', '13:30:00', '09:30:00', '13:30:00', '09:30:00', '13:30:00', '09:30:00', '13:30:00', '09:30:00', '13:30:00', '09:30:00', '13:30:00', '09:30:00', '13:30:00', '1', '2024-08-04 23:23:06', '2024-08-04 23:23:06', 45),
(40, 'France', 'Paris', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '1', '2024-08-04 23:27:38', '2024-08-04 23:27:38', 46),
(41, 'France', 'Paris', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '1', '2024-08-04 23:30:22', '2024-08-04 23:30:22', 47),
(42, 'France', 'Paris', '07:00:00', '14:00:00', '07:00:00', '14:00:00', '07:00:00', '14:00:00', '07:00:00', '14:00:00', '07:00:00', '14:00:00', '07:00:00', '14:00:00', '07:00:00', '14:00:00', '1', '2024-08-04 23:32:03', '2024-08-04 23:32:03', 48),
(43, 'France', 'Paris', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '1', '2024-08-04 23:35:04', '2024-08-04 23:35:04', 49),
(44, 'France', 'Paris', '19:00:00', '22:30:00', '19:00:00', '22:30:00', '19:00:00', '22:30:00', '19:00:00', '22:30:00', '19:00:00', '22:30:00', '19:00:00', '22:30:00', '19:00:00', '22:30:00', '1', '2024-08-04 23:36:53', '2024-08-04 23:36:53', 50),
(45, 'France', 'Paris', '09:00:00', '00:00:00', '09:00:00', '00:00:00', '09:00:00', '00:00:00', '09:00:00', '00:00:00', '09:00:00', '00:00:00', '09:00:00', '00:00:00', '09:00:00', '00:00:00', '1', '2024-08-04 23:38:14', '2024-08-04 23:38:14', 51),
(46, 'France', 'Paris', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '1', '2024-08-04 23:39:33', '2024-08-04 23:39:33', 52),
(47, 'France', 'Paris', '18:30:00', '23:00:00', '18:30:00', '23:00:00', '18:30:00', '23:00:00', '18:30:00', '23:00:00', '18:30:00', '23:00:00', '18:30:00', '23:00:00', '18:30:00', '23:00:00', '1', '2024-08-04 23:41:23', '2024-08-04 23:41:23', 53),
(48, 'France', 'Paris', '18:00:00', '23:00:00', '18:00:00', '23:00:00', '18:00:00', '23:00:00', '18:00:00', '23:00:00', '18:00:00', '23:00:00', '18:00:00', '23:00:00', '18:00:00', '23:00:00', '1', '2024-08-04 23:42:50', '2024-08-04 23:42:50', 54),
(49, 'France', 'Paris', '07:00:00', '11:00:00', '07:00:00', '11:00:00', '07:00:00', '11:00:00', '07:00:00', '11:00:00', '07:00:00', '11:00:00', '07:00:00', '11:00:00', '07:00:00', '11:00:00', '1', '2024-08-04 23:45:39', '2024-08-04 23:45:39', 55),
(50, 'France', 'Paris', '17:00:00', '22:00:00', '17:00:00', '22:00:00', '17:00:00', '22:00:00', '17:00:00', '22:00:00', '17:00:00', '22:00:00', '17:00:00', '22:00:00', '17:00:00', '22:00:00', '1', '2024-08-04 23:47:23', '2024-08-04 23:47:23', 56),
(51, 'France', 'Paris', '09:00:00', '00:00:00', '09:00:00', '00:00:00', '09:00:00', '00:00:00', '09:00:00', '00:00:00', '09:00:00', '00:00:00', '09:00:00', '00:00:00', '09:00:00', '00:00:00', '1', '2024-08-04 23:48:51', '2024-08-04 23:48:51', 57),
(52, 'France', 'Paris', '11:45:00', '23:00:00', '11:45:00', '23:00:00', '11:45:00', '23:00:00', '11:45:00', '23:00:00', '11:45:00', '23:00:00', '11:45:00', '23:00:00', '11:45:00', '23:00:00', '1', '2024-08-04 23:50:39', '2024-08-04 23:50:39', 58),
(53, NULL, NULL, '11:45:00', '23:00:00', '11:45:00', '23:00:00', '11:45:00', '23:00:00', '11:45:00', '23:00:00', '11:45:00', '23:00:00', '11:45:00', '23:00:00', '11:45:00', '23:00:00', '1', '2024-08-04 23:52:22', '2024-08-04 23:52:22', 59),
(54, NULL, NULL, '19:00:00', '00:00:00', '19:00:00', '00:00:00', '19:00:00', '00:00:00', '19:00:00', '00:00:00', '19:00:00', '00:00:00', '19:00:00', '00:00:00', '19:00:00', '00:00:00', '1', '2024-08-04 23:54:31', '2024-08-04 23:54:31', 60),
(55, NULL, NULL, '07:00:00', '00:00:00', '07:00:00', '00:00:00', '07:00:00', '00:00:00', '07:00:00', '00:00:00', '07:00:00', '00:00:00', '07:00:00', '00:00:00', '07:00:00', '00:00:00', '1', '2024-08-04 23:56:10', '2024-08-04 23:56:10', 61),
(56, NULL, NULL, '12:00:00', '21:00:00', '12:00:00', '21:00:00', '12:00:00', '21:00:00', '12:00:00', '21:00:00', '12:00:00', '21:00:00', '12:00:00', '21:00:00', '12:00:00', '21:00:00', '1', '2024-08-04 23:57:42', '2024-08-04 23:57:42', 62),
(57, NULL, NULL, '09:00:00', '20:00:00', '09:00:00', '20:00:00', '09:00:00', '20:00:00', '09:00:00', '20:00:00', '09:00:00', '20:00:00', '09:00:00', '20:00:00', '09:00:00', '20:00:00', '1', '2024-08-05 01:02:22', '2024-08-05 01:02:22', 63),
(58, 'France', 'Eure', '09:00:00', '23:00:00', '09:00:00', '23:00:00', '09:00:00', '23:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '2024-08-08 08:31:12', '2024-08-08 08:31:28', 64),
(59, 'India', 'Noida', '13:00:00', '22:00:00', '13:00:00', '22:00:00', '13:00:00', '22:00:00', '13:00:00', '22:00:00', '13:00:00', '22:00:00', '09:15:00', '23:45:00', '09:30:00', '23:59:00', '1', '2024-08-09 01:25:52', '2024-08-09 01:25:52', 65),
(60, 'France', 'Paris', '09:00:00', '20:00:00', '09:00:00', '21:00:00', '09:00:00', '21:30:00', '09:00:00', '22:00:00', '09:00:00', '20:00:00', '09:00:00', '20:30:00', '09:00:00', '22:45:00', '1', '2024-08-13 06:58:32', '2024-08-13 06:58:32', 66),
(61, 'France', 'Paris', '12:00:00', '20:00:00', '12:00:00', '20:00:00', '12:00:00', '20:00:00', '12:00:00', '20:00:00', '12:00:00', '20:00:00', '12:00:00', '20:00:00', '12:00:00', '20:00:00', '1', '2024-09-03 04:29:33', '2024-09-03 04:29:33', 67),
(62, 'France', 'Paris', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '1', '2024-09-03 04:31:38', '2024-09-03 04:31:38', 68),
(63, 'France', 'Paris', '12:00:00', '23:00:00', '12:00:00', '23:00:00', '12:00:00', '23:00:00', '12:00:00', '23:00:00', '12:00:00', '23:00:00', '12:00:00', '23:00:00', '12:00:00', '23:00:00', '1', '2024-09-03 04:33:27', '2024-09-03 04:33:27', 69),
(64, 'France', 'Paris', '09:00:00', '16:00:00', '09:00:00', '16:00:00', '09:00:00', '16:00:00', '09:00:00', '16:00:00', '09:00:00', '16:00:00', '09:00:00', '16:00:00', '09:00:00', '16:00:00', '1', '2024-09-03 04:34:53', '2024-09-03 04:34:53', 70),
(65, 'France', 'Paris', '12:00:00', '22:00:00', '12:00:00', '22:00:00', '12:00:00', '22:00:00', '12:00:00', '22:00:00', '12:00:00', '22:00:00', '12:00:00', '22:00:00', '12:00:00', '22:00:00', '1', '2024-09-03 04:37:03', '2024-09-03 04:37:03', 71),
(66, 'France', 'Paris', '08:00:00', '00:00:00', '08:00:00', '00:00:00', '08:00:00', '00:00:00', '08:00:00', '00:00:00', '08:00:00', '00:00:00', '08:00:00', '00:00:00', '08:00:00', '00:00:00', '1', '2024-09-03 04:39:02', '2024-09-03 04:39:02', 72),
(67, 'France', 'Paris', '08:00:00', '00:00:00', '08:00:00', '00:00:00', '08:00:00', '00:00:00', '08:00:00', '00:00:00', '08:00:00', '00:00:00', '08:00:00', '00:00:00', '08:00:00', '00:00:00', '1', '2024-09-03 04:40:11', '2024-09-03 04:40:11', 73),
(68, 'France', 'Paris', '12:00:00', '23:00:00', '12:00:00', '23:00:00', '12:00:00', '23:00:00', '12:00:00', '23:00:00', '12:00:00', '23:00:00', '12:00:00', '23:00:00', '12:00:00', '23:00:00', '1', '2024-09-03 05:37:00', '2024-09-03 05:37:00', 74),
(69, 'France', 'Paris', '18:00:00', '00:00:00', '18:00:00', '00:00:00', '18:00:00', '00:00:00', '18:00:00', '00:00:00', '18:00:00', '00:00:00', '18:00:00', '00:00:00', '18:00:00', '00:00:00', '1', '2024-09-03 05:38:42', '2024-09-03 05:38:42', 75),
(70, 'France', 'Paris', '12:30:00', '21:00:00', '12:30:00', '21:00:00', '12:30:00', '21:00:00', '12:30:00', '21:00:00', '12:30:00', '21:00:00', '12:30:00', '21:00:00', '12:30:00', '21:00:00', '1', '2024-09-03 05:41:35', '2024-09-03 05:41:35', 76),
(71, 'France', 'Paris', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '12:00:00', '00:00:00', '1', '2024-09-03 05:44:10', '2024-09-03 05:44:10', 77),
(72, 'France', 'Paris', '11:00:00', '23:00:00', '11:00:00', '23:00:00', '11:00:00', '23:00:00', '11:00:00', '23:00:00', '11:00:00', '23:00:00', '11:00:00', '23:00:00', '11:00:00', '23:00:00', '1', '2024-09-03 05:45:20', '2024-09-03 05:45:20', 78);

-- --------------------------------------------------------

--
-- Table structure for table `restaurant_tables`
--

CREATE TABLE `restaurant_tables` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `table_unique_id` varchar(255) NOT NULL,
  `rest_id` int(11) NOT NULL,
  `country` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `table_no` varchar(255) NOT NULL,
  `min_cover` int(11) NOT NULL,
  `max_cover` int(11) NOT NULL,
  `online_status` enum('0','1','2') NOT NULL DEFAULT '1',
  `table_area` varchar(255) DEFAULT 'N/A',
  `added_by` int(11) NOT NULL,
  `deleted` enum('0','1') NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `restaurant_tables`
--

INSERT INTO `restaurant_tables` (`id`, `table_unique_id`, `rest_id`, `country`, `city`, `table_no`, `min_cover`, `max_cover`, `online_status`, `table_area`, `added_by`, `deleted`, `created_at`, `updated_at`) VALUES
(17, 'SUP-TAB-1', 65, NULL, NULL, 'NR1', 2, 8, '1', 'Left Center-Corner', 24, '1', '2024-06-04 08:05:20', '2024-06-04 08:05:20'),
(18, 'SUP-TAB-18', 64, 'France', 'Paris', 'PP1', 2, 10, '1', 'Pepita Center', 24, '1', '2024-06-04 08:06:26', '2024-08-12 03:17:43'),
(19, 'SUP-TAB-19', 73, NULL, NULL, 'OK1', 2, 6, '1', 'OK-corner', 24, '1', '2024-06-06 00:52:20', '2024-06-06 00:52:20'),
(20, 'SUP-TAB-20', 66, 'France', 'Paris', 'MA-4', 2, 8, '1', '', 24, '1', '2024-06-06 00:53:44', '2024-08-12 03:18:11'),
(21, 'SUP-TAB-21', 67, 'France', 'Paris', 'CHM1', 2, 6, '1', 'CHM-2', 24, '1', '2024-06-06 00:54:49', '2024-08-12 03:18:29'),
(22, 'SUP-TAB-22', 68, 'France', 'Paris', 'MAR-2', 2, 4, '1', '', 24, '1', '2024-06-06 00:55:39', '2024-08-12 03:19:08'),
(23, 'SUP-TAB-23', 69, 'France', 'Paris', 'BRS-4a', 2, 5, '1', 'center-right', 24, '1', '2024-06-06 00:57:27', '2024-08-12 03:19:39'),
(24, 'SUP-TAB-24', 70, 'France', 'Paris', 'MKA-1c', 2, 8, '1', 'Left-center-corner', 24, '1', '2024-06-06 00:58:53', '2024-08-12 03:20:16'),
(25, 'SUP-TAB-25', 71, 'France', 'Paris', 'CHO-1e', 2, 6, '1', 'Center', 24, '1', '2024-06-06 00:59:44', '2024-08-12 03:20:41'),
(28, 'SUP-TAB-28', 72, NULL, NULL, 'BO1', 2, 5, '1', '', 24, '1', '2024-06-20 00:54:17', '2024-06-20 00:54:17'),
(29, 'SUP-TAB-29', 11, NULL, NULL, 'TESTNG1', 2, 8, '1', '', 24, '1', '2024-06-20 01:12:17', '2024-06-20 01:12:17'),
(30, 'SUP-TAB-30', 85, 'India', 'Noida', 'S1', 2, 3, '1', '', 24, '1', '2024-06-20 07:43:58', '2024-08-12 03:21:37'),
(31, 'SUP-TAB-31', 85, 'India', 'Noida', 'S2', 2, 3, '1', '', 24, '1', '2024-06-20 07:44:16', '2024-08-12 03:22:18'),
(32, 'SUP-TAB-32', 86, 'France', 'Paris', 'TB1', 2, 4, '1', 'Left Corner', 24, '1', '2024-07-25 23:27:56', '2024-08-12 03:22:34'),
(33, 'SUP-TAB-33', 86, NULL, NULL, 'TB2', 2, 6, '1', 'center', 24, '1', '2024-07-25 23:28:11', '2024-07-25 23:28:11'),
(34, 'SUP-TAB-34', 87, 'France', 'Paris', 'TB1', 2, 6, '1', 'Left', 24, '1', '2024-07-25 23:32:20', '2024-08-12 03:23:21'),
(35, 'SUP-TAB-35', 87, NULL, NULL, 'TB2', 2, 6, '1', 'Left2', 24, '1', '2024-07-25 23:32:33', '2024-07-25 23:32:33'),
(36, 'SUP-TAB-36', 88, 'France', 'Paris', 'LEGB', 2, 10, '1', '', 24, '1', '2024-08-04 23:58:54', '2024-08-12 03:24:48'),
(37, 'SUP-TAB-37', 89, 'France', 'Paris', 'SINPA1', 2, 8, '1', '', 24, '1', '2024-08-04 23:59:20', '2024-08-12 03:25:25'),
(38, 'SUP-TAB-38', 90, 'France', 'Paris', 'ALLU1', 2, 10, '1', '', 24, '1', '2024-08-04 23:59:35', '2024-08-12 03:26:03'),
(39, 'SUP-TAB-39', 91, 'France', 'Paris', 'MASS1', 2, 9, '1', '', 24, '1', '2024-08-04 23:59:54', '2024-08-12 03:26:50'),
(40, 'SUP-TAB-40', 92, 'France', 'Paris', 'SOSS1', 2, 12, '1', '', 24, '1', '2024-08-05 00:00:25', '2024-08-12 03:27:20'),
(41, 'SUP-TAB-41', 93, 'France', 'Paris', 'JIN-1', 2, 8, '1', '', 24, '1', '2024-08-05 00:00:45', '2024-08-12 03:27:45'),
(42, 'SUP-TAB-42', 94, 'France', 'Paris', 'AUB-1', 2, 8, '1', '', 24, '1', '2024-08-05 00:01:04', '2024-08-12 03:28:00'),
(43, 'SUP-TAB-43', 95, 'France', 'Paris', 'PAP-1', 2, 6, '1', '', 24, '1', '2024-08-05 00:01:20', '2024-08-12 03:28:34'),
(44, 'SUP-TAB-44', 96, 'France', 'Paris', 'FBAR-1', 2, 8, '1', '', 24, '1', '2024-08-05 00:01:37', '2024-08-12 03:29:02'),
(45, 'SUP-TAB-45', 97, 'France', 'Paris', 'CMOT-1', 2, 8, '1', '', 24, '1', '2024-08-05 00:02:13', '2024-08-12 03:29:36'),
(46, 'SUP-TAB-46', 98, 'France', 'Paris', 'HHE-1', 2, 8, '1', 'Center-right', 24, '1', '2024-08-05 00:02:33', '2024-08-12 03:30:01'),
(47, 'SUP-TAB-47', 99, 'France', 'Paris', 'AUMAR-1', 2, 8, '1', 'Right corner', 24, '1', '2024-08-05 00:03:03', '2024-08-12 03:30:18'),
(48, 'SUP-TAB-48', 100, 'France', 'Paris', 'HOXP-1', 2, 8, '1', 'Left center', 24, '1', '2024-08-05 00:03:22', '2024-08-12 03:30:44'),
(49, 'SUP-TAB-49', 101, NULL, NULL, 'KOD-1', 2, 8, '1', 'Center', 24, '1', '2024-08-05 00:04:01', '2024-08-05 00:04:01'),
(50, 'SUP-TAB-50', 102, NULL, NULL, 'KORA-1', 2, 10, '1', '', 24, '1', '2024-08-05 00:04:30', '2024-08-05 00:04:30'),
(51, 'SUP-TAB-51', 103, NULL, NULL, 'BRPAR-1', 2, 12, '1', '', 24, '1', '2024-08-05 00:05:10', '2024-08-05 00:05:10'),
(52, 'SUP-TAB-52', 104, NULL, NULL, 'ANLA-1', 2, 6, '1', 'Left Front', 24, '1', '2024-08-05 00:05:48', '2024-08-05 00:05:48'),
(53, 'SUP-TAB-53', 106, NULL, NULL, 'Cafs52-2', 2, 10, '1', '', 24, '1', '2024-08-05 00:06:06', '2024-08-05 00:06:06'),
(54, 'SUP-TAB-54', 105, NULL, NULL, 'CAF52-1', 2, 8, '1', '', 24, '1', '2024-08-05 00:06:23', '2024-08-05 00:06:23'),
(55, 'SUP-TAB-55', 108, NULL, NULL, 'LaMas-1', 2, 8, '1', '', 24, '1', '2024-08-05 01:03:31', '2024-08-05 01:03:31'),
(56, 'SUP-TAB-56', 110, 'France', 'Eure', 'MIREST1', 2, 14, '1', '', 24, '1', '2024-08-08 08:24:29', '2024-08-08 08:26:03'),
(57, 'SUP-TAB-57', 114, 'India', 'Noida', 'TB1', 2, 4, '1', 'Center', 24, '1', '2024-08-09 01:17:48', '2024-08-09 01:17:48'),
(58, 'SUP-TAB-58', 114, 'India', 'Noida', 'TB2', 2, 6, '1', 'Left Center', 24, '1', '2024-08-09 01:18:26', '2024-08-09 01:18:26'),
(59, 'SUP-TAB-59', 114, 'India', 'Noida', 'TB3', 2, 8, '1', 'left', 24, '1', '2024-08-09 01:19:00', '2024-08-09 01:19:00'),
(60, 'SUP-TAB-60', 115, 'France', 'Bhind', 'gvfggh', 1, 1, '1', '', 24, '1', '2024-08-09 07:28:07', '2024-08-09 07:28:07'),
(61, 'SUP-TAB-61', 114, 'India', 'Noida', 'TB4', 2, 6, '1', '', 24, '1', '2024-08-09 09:02:39', '2024-08-09 09:02:39'),
(62, 'SUP-TAB-62', 123, 'France', 'Paris', 'RAD_1', 2, 20, '1', '', 24, '1', '2024-08-13 06:50:03', '2024-08-13 06:50:03'),
(63, 'SUP-TAB-63', 153, 'France', 'Paris', 'YATD-1', 2, 20, '1', 'Right corner', 24, '1', '2024-09-03 04:25:02', '2024-09-03 04:25:02'),
(64, 'SUP-TAB-64', 154, 'France', 'Paris', 'CNI-1', 3, 15, '1', '', 24, '1', '2024-09-03 04:25:46', '2024-09-03 04:25:46'),
(65, 'SUP-TAB-65', 155, 'France', 'Paris', 'ASIM-1', 2, 10, '1', '', 24, '1', '2024-09-03 04:26:13', '2024-09-03 04:26:13'),
(66, 'SUP-TAB-66', 156, 'France', 'Paris', 'CAELE-1', 2, 20, '1', '', 24, '1', '2024-09-03 04:26:38', '2024-09-03 04:26:38'),
(67, 'SUP-TAB-67', 157, 'France', 'Paris', 'LZA-37', 2, 20, '1', '', 24, '1', '2024-09-03 04:27:24', '2024-09-03 04:27:24'),
(68, 'SUP-TAB-68', 158, 'France', 'Paris', 'CPAUl-38', 2, 15, '1', '', 24, '1', '2024-09-03 04:27:53', '2024-09-03 04:27:53'),
(69, 'SUP-TAB-69', 159, 'France', 'Paris', 'CJA-38', 2, 25, '1', '', 24, '1', '2024-09-03 04:28:20', '2024-09-03 04:28:20'),
(70, 'SUP-TAB-70', 160, 'France', 'Paris', 'DBR-40', 2, 20, '1', '', 24, '1', '2024-09-03 05:33:18', '2024-09-03 05:33:18'),
(71, 'SUP-TAB-71', 161, 'France', 'Paris', 'LRALEV-41', 2, 20, '1', '', 24, '1', '2024-09-03 05:33:56', '2024-09-03 05:33:56'),
(72, 'SUP-TAB-72', 162, 'France', 'Paris', 'OR-42', 2, 20, '1', '', 24, '1', '2024-09-03 05:34:41', '2024-09-03 05:34:41'),
(73, 'SUP-TAB-73', 163, 'France', 'Paris', 'FRN-43', 2, 20, '1', '', 24, '1', '2024-09-03 05:35:10', '2024-09-03 05:35:10'),
(74, 'SUP-TAB-74', 164, 'France', 'Paris', 'POBR-44', 2, 20, '1', '', 24, '1', '2024-09-03 05:35:32', '2024-09-03 05:35:32'),
(75, 'SUP-TAB-75', 165, 'France', 'Paris', 'TES-1', 2, 50, '1', '', 24, '1', '2024-09-08 23:26:01', '2024-09-08 23:26:01');

-- --------------------------------------------------------

--
-- Table structure for table `restaurant_tables_occupied_status`
--

CREATE TABLE `restaurant_tables_occupied_status` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `rest_id` int(11) NOT NULL,
  `table_id` int(11) NOT NULL,
  `free_space` int(11) NOT NULL,
  `total_space` int(11) NOT NULL,
  `is_occupied` enum('0','1','2') NOT NULL DEFAULT '0',
  `added_by` int(11) NOT NULL,
  `deleted` enum('0','1') NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `restroads`
--

CREATE TABLE `restroads` (
  `id` int(11) NOT NULL,
  `country` varchar(255) NOT NULL DEFAULT 'N/A',
  `city` varchar(255) NOT NULL DEFAULT 'N/A',
  `restroid` int(11) NOT NULL DEFAULT 0,
  `restroName` varchar(255) DEFAULT NULL,
  `reference_name` varchar(255) DEFAULT NULL,
  `ad_view` varchar(255) NOT NULL,
  `ad_type` varchar(255) NOT NULL,
  `adsposition` longtext DEFAULT NULL,
  `ad_placement_selector` longtext DEFAULT NULL,
  `ad_title` varchar(255) DEFAULT NULL,
  `target_url` varchar(255) NOT NULL,
  `is_disabled` enum('0','1') NOT NULL DEFAULT '0',
  `ad_image` varchar(255) DEFAULT NULL,
  `ad_description` longtext DEFAULT NULL,
  `startedon` datetime(6) NOT NULL,
  `endon` datetime(6) NOT NULL,
  `isactive` int(11) NOT NULL DEFAULT 1,
  `order` int(11) NOT NULL DEFAULT 0,
  `createdon` datetime(6) NOT NULL,
  `added_by` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `restroads`
--

INSERT INTO `restroads` (`id`, `country`, `city`, `restroid`, `restroName`, `reference_name`, `ad_view`, `ad_type`, `adsposition`, `ad_placement_selector`, `ad_title`, `target_url`, `is_disabled`, `ad_image`, `ad_description`, `startedon`, `endon`, `isactive`, `order`, `createdon`, `added_by`, `created_at`, `updated_at`) VALUES
(19, 'France', 'Paris', 69, 'Brasserie Des Prés', NULL, 'banner', 'banner', 'banner', 'banner', 'N/A', '', '0', NULL, 'N/A', '2024-08-05 00:00:00.000000', '2024-08-25 00:00:00.000000', 1, 1, '2024-08-05 06:34:39.000000', 24, '2024-07-22 12:09:17', '2024-09-09 01:21:19'),
(20, 'France', 'Paris', 72, 'Boubale', NULL, 'page', 'imageType', 'after top 10', 'aftertop10AdContainer', 'Try Our New Dish', '', '0', NULL, 'N/A', '1970-01-01 00:00:00.000000', '2025-01-02 00:00:00.000000', 1, 1, '2024-07-24 04:55:03.000000', 24, '2024-07-23 08:24:49', '2024-08-11 05:28:42'),
(22, 'France', 'Paris', 70, 'Marie Akaneya', NULL, 'page', 'imageType', 'after rooftop and terrace', 'afterrooftopandterraceAdContainer', 'N/A', '', '0', NULL, 'N/A', '1970-01-01 00:00:00.000000', '1970-01-01 00:00:00.000000', 1, 0, '2024-08-10 07:10:42.000000', 24, '2024-07-23 23:36:58', '2024-08-10 01:40:42'),
(28, 'France', 'Paris', 72, 'Boubale', NULL, 'page', 'imageType', 'after top 10', 'aftertop10AdContainer', 'undefined', '', '0', '', 'undefined', '2024-07-31 00:00:00.000000', '2024-09-30 00:00:00.000000', 1, 2, '2024-07-31 08:30:18.000000', 24, '2024-07-31 03:00:18', '2024-08-11 05:28:42'),
(29, 'France', 'Paris', 72, 'Boubale', NULL, 'page', 'imageType', 'top', 'topAdContainer', 'undefined', '', '0', 'resources/ads/1722419131_7-min.jpg', 'undefined', '2024-07-31 00:00:00.000000', '2024-08-31 00:00:00.000000', 1, 1, '2024-07-31 09:45:31.000000', 24, '2024-07-31 04:15:32', '2024-07-31 04:15:32'),
(30, 'France', 'Paris', 108, 'La Maison Plisson', '', 'page', 'imageType', 'after top 10', 'aftertop10AdContainer', 'undefined', '', '0', '', 'undefined', '2024-08-02 00:00:00.000000', '2024-09-02 00:00:00.000000', 1, 4, '2024-08-02 04:52:26.000000', 24, '2024-08-01 23:22:26', '2024-08-11 05:28:42'),
(31, 'France', 'Paris', 106, 'Café 52', '', 'page', 'imageType', 'after top 10', 'aftertop10AdContainer', 'undefined', '', '0', '', 'undefined', '2024-08-02 00:00:00.000000', '2024-09-30 00:00:00.000000', 1, 3, '2024-08-02 04:53:43.000000', 24, '2024-08-01 23:23:43', '2024-08-11 05:28:42'),
(32, 'France', 'Paris', 102, 'Kodawari Ramen (Yokochō)', '', 'page', 'imageType', 'after top 10', 'aftertop10AdContainer', 'undefined', '', '0', '', 'undefined', '2024-08-02 00:00:00.000000', '2024-09-02 00:00:00.000000', 1, 5, '2024-08-02 04:59:49.000000', 24, '2024-08-01 23:29:49', '2024-08-11 05:28:42'),
(33, 'France', 'Paris', 72, 'Boubale', '', 'banner', 'banner', 'banner', 'banner', 'undefined', '', '0', '', 'undefined', '2024-08-05 00:00:00.000000', '2024-12-31 00:00:00.000000', 1, 4, '2024-08-05 06:31:02.000000', 24, '2024-08-05 01:01:02', '2024-09-09 01:21:19'),
(34, 'France', 'Paris', 71, 'Choukran', '', 'banner', 'banner', 'banner', 'banner', 'undefined', '', '0', '', 'undefined', '2024-08-05 00:00:00.000000', '2024-11-30 00:00:00.000000', 1, 5, '2024-08-05 06:32:25.000000', 24, '2024-08-05 01:02:25', '2024-09-09 01:21:19'),
(35, 'France', 'Paris', 64, 'Pepita Paris', '', 'banner', 'banner', 'banner', 'banner', 'undefined', '', '0', '', 'undefined', '2024-08-05 00:00:00.000000', '2024-09-05 00:00:00.000000', 1, 2, '2024-08-05 06:32:43.000000', 24, '2024-08-05 01:02:43', '2024-09-09 01:21:19'),
(36, 'France', 'Paris', 67, 'Chez Minna', '', 'banner', 'banner', 'banner', 'banner', 'undefined', '', '0', '', 'undefined', '2024-08-05 00:00:00.000000', '2024-11-30 00:00:00.000000', 1, 3, '2024-08-05 06:33:03.000000', 24, '2024-08-05 01:03:03', '2024-09-09 01:21:19'),
(37, 'India', 'Noida', 114, 'Jha ji Dhaba', '', 'banner', 'banner', 'banner', 'banner', 'undefined', '', '0', '', 'undefined', '2024-08-09 00:00:00.000000', '2024-09-09 00:00:00.000000', 1, 7, '2024-08-09 15:48:09.000000', 24, '2024-08-09 10:18:09', '2024-09-09 01:21:19'),
(38, 'India', 'Noida', 0, NULL, 'Edunext', 'page', 'imageType', 'after top 10', 'aftertop10AdContainer', 'N/A', '', '0', 'resources/ads/1723218866_92973505_2891544477628462_3913115158305570816_n.png', 'N/A', '1970-01-01 00:00:00.000000', '2024-09-09 00:00:00.000000', 1, 6, '2024-08-10 07:20:00.000000', 24, '2024-08-09 10:24:26', '2024-08-10 01:50:00'),
(39, 'France', 'Paris', 162, 'Ōrtensia', '', 'banner', 'banner', 'banner', 'banner', 'undefined', '', '0', '', 'undefined', '2024-09-03 00:00:00.000000', '2024-10-03 00:00:00.000000', 1, 11, '2024-09-03 13:57:49.000000', 24, '2024-09-03 08:27:49', '2024-09-09 01:21:19'),
(40, 'France', 'Paris', 163, 'Francette', '', 'page', 'imageType', 'after top 10', 'aftertop10AdContainer', 'undefined', '', '0', '', 'undefined', '2024-09-03 00:00:00.000000', '2024-10-03 00:00:00.000000', 1, 7, '2024-09-03 13:59:04.000000', 24, '2024-09-03 08:29:04', '2024-09-03 08:29:04'),
(41, 'France', 'Paris', 87, 'La Baignoire', '', 'page', 'imageType', 'top', 'topAdContainer', 'undefined', '', '0', '', 'undefined', '2024-09-09 00:00:00.000000', '2024-10-09 00:00:00.000000', 1, 2, '2024-09-09 05:54:30.000000', 24, '2024-09-09 00:24:30', '2024-09-09 00:24:30'),
(42, 'France', 'Paris', 87, 'La Baignoire', '', 'banner', 'banner', 'banner', 'banner', 'undefined', '', '0', '', 'undefined', '2024-09-09 00:00:00.000000', '2024-10-09 00:00:00.000000', 1, 10, '2024-09-09 05:56:09.000000', 24, '2024-09-09 00:26:09', '2024-09-09 01:21:19'),
(43, 'India', 'Noida', 85, 'Tarun Desi Tadka', '', 'banner', 'banner', 'banner', 'banner', 'undefined', '', '0', '', 'undefined', '2024-09-09 00:00:00.000000', '2025-02-01 00:00:00.000000', 1, 6, '2024-09-09 06:48:00.000000', 24, '2024-09-09 01:18:00', '2024-09-09 01:21:19'),
(44, 'United Kingdom', 'Soho', 2, 'Burger and Beyond', '', 'banner', 'banner', 'banner', 'banner', 'undefined', '', '0', '', 'undefined', '2024-09-09 00:00:00.000000', '2024-12-31 00:00:00.000000', 1, 8, '2024-09-09 06:49:25.000000', 24, '2024-09-09 01:19:25', '2024-09-09 01:21:19'),
(46, 'United Kingdom', 'Tooting', 6, 'Daddy Bao', '', 'banner', 'banner', 'banner', 'banner', 'undefined', '', '0', '', 'undefined', '2024-09-09 00:00:00.000000', '2024-10-31 00:00:00.000000', 1, 9, '2024-09-09 06:50:38.000000', 24, '2024-09-09 01:20:38', '2024-09-09 01:21:19'),
(47, 'United Kingdom', 'Earls Court', 8, 'Black Rabbit Cafe', '', 'banner', 'banner', 'banner', 'banner', 'undefined', '', '0', '', 'undefined', '2024-09-09 00:00:00.000000', '2024-11-30 00:00:00.000000', 1, 12, '2024-09-09 06:52:20.000000', 24, '2024-09-09 01:22:20', '2024-09-09 01:22:20');

-- --------------------------------------------------------

--
-- Table structure for table `rewards`
--

CREATE TABLE `rewards` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `totpoints` decimal(18,2) NOT NULL DEFAULT 0.00,
  `createdon` datetime(6) NOT NULL,
  `updatedon` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `rewardsummary`
--

CREATE TABLE `rewardsummary` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `orderid` int(11) NOT NULL,
  `rewardpoints` decimal(18,2) NOT NULL DEFAULT 1.00,
  `iscredited` int(11) NOT NULL DEFAULT 0,
  `createdon` datetime(6) NOT NULL,
  `updatedon` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `searches`
--

CREATE TABLE `searches` (
  `id` int(11) NOT NULL,
  `qry` longtext DEFAULT NULL,
  `count` int(11) NOT NULL DEFAULT 0,
  `createdon` datetime(6) NOT NULL,
  `updatedon` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `seeder_track_list`
--

CREATE TABLE `seeder_track_list` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `seeder_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `seeder_track_list`
--

INSERT INTO `seeder_track_list` (`id`, `seeder_name`, `created_at`, `updated_at`) VALUES
(1, 'user_role_seeder', '2024-05-17 08:24:51', '2024-05-17 08:24:51');

-- --------------------------------------------------------

--
-- Table structure for table `subscriber`
--

CREATE TABLE `subscriber` (
  `id` int(11) NOT NULL,
  `email` varchar(200) DEFAULT NULL,
  `unsubreason` longtext DEFAULT NULL,
  `createdon` datetime(6) NOT NULL,
  `updatedon` datetime(6) DEFAULT NULL,
  `isactive` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `termsandconditions`
--

CREATE TABLE `termsandconditions` (
  `id` int(11) NOT NULL,
  `english_details` longtext DEFAULT NULL,
  `french_details` longtext DEFAULT NULL,
  `spanish_details` longtext DEFAULT NULL,
  `language` varchar(255) DEFAULT NULL,
  `createdon` datetime(6) NOT NULL,
  `isactive` int(11) NOT NULL DEFAULT 1,
  `updatedon` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `termsandconditions`
--

INSERT INTO `termsandconditions` (`id`, `english_details`, `french_details`, `spanish_details`, `language`, `createdon`, `isactive`, `updatedon`) VALUES
(1, '<p>English <strong><em>Terms and Conditions</em></strong> Here ..</p>', '<p><span style=\\\"color: rgb(47, 47, 59);\\\">French </span><em style=\\\"color: rgb(47, 47, 59);\\\">Terms and Conditions</em><span style=\\\"color: rgb(47, 47, 59);\\\"> Here ..</span></p>', '<p>Spanish <strong><em>Terms and Conditions</em></strong> Here ...</p><p><br></p>', NULL, '2024-08-06 05:14:20.000000', 1, '2024-08-06 05:14:20.000000');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `name` varchar(200) DEFAULT NULL,
  `firstname` varchar(255) DEFAULT NULL,
  `lastname` varchar(255) DEFAULT NULL,
  `email` varchar(200) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `token` varchar(50) DEFAULT NULL,
  `usertype` int(11) NOT NULL DEFAULT 1,
  `refercode` varchar(20) DEFAULT NULL,
  `referbyid` int(11) NOT NULL,
  `profileimg` varchar(200) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` varchar(500) DEFAULT NULL,
  `city` varchar(200) DEFAULT NULL,
  `state` varchar(200) DEFAULT NULL,
  `country` varchar(200) DEFAULT NULL,
  `pincode` varchar(10) DEFAULT NULL,
  `createdon` datetime(6) NOT NULL,
  `userrole` int(11) NOT NULL DEFAULT 0,
  `isactive` int(11) NOT NULL DEFAULT 1,
  `updatedon` datetime(6) DEFAULT NULL,
  `isdeleted` int(11) NOT NULL DEFAULT 0,
  `resetotp` int(11) NOT NULL DEFAULT 0,
  `isresetpass` int(11) NOT NULL DEFAULT 0,
  `resetotpcreated` datetime DEFAULT NULL,
  `deviceid` longtext DEFAULT NULL,
  `device_subscription` varchar(50) DEFAULT NULL,
  `lastlogindate` datetime DEFAULT NULL,
  `loginip` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `name`, `firstname`, `lastname`, `email`, `password`, `token`, `usertype`, `refercode`, `referbyid`, `profileimg`, `phone`, `address`, `city`, `state`, `country`, `pincode`, `createdon`, `userrole`, `isactive`, `updatedon`, `isdeleted`, `resetotp`, `isresetpass`, `resetotpcreated`, `deviceid`, `device_subscription`, `lastlogindate`, `loginip`) VALUES
(1, 'joji', NULL, NULL, 'jojijoji891@gmail.com', 'qFDwYnX6qww5H+dxoZGAIg==', NULL, 0, 'eb2a5c50', 0, '/resources/user/profile/avtar.jpg', NULL, NULL, NULL, NULL, NULL, NULL, '2023-11-01 14:15:47.012875', 0, 1, NULL, 1, 0, 0, '2024-07-19 23:45:47', NULL, NULL, '2024-07-19 23:45:47', NULL),
(2, 'joji xavier', NULL, NULL, 'jojixavier1234@gmail.com', 'qFDwYnX6qww5H+dxoZGAIg==', NULL, 0, '8a77ac64', 0, '/resources/user/profile/avtar.jpg', NULL, NULL, NULL, NULL, NULL, NULL, '2023-11-06 09:11:30.760112', 0, 1, NULL, 0, 0, 0, '2024-07-19 23:45:47', NULL, NULL, '2024-07-19 23:45:47', NULL),
(3, 'joji', NULL, NULL, 'joji@gmail.com', 'HylLA6Y4jzwI2QKr0IR28w==', NULL, 0, 'b3c0ccb8', 0, '/resources/user/profile/avtar.jpg', NULL, NULL, NULL, NULL, NULL, NULL, '2024-03-06 04:36:45.885682', 0, 1, NULL, 0, 0, 0, '2024-07-19 23:45:47', NULL, NULL, '2024-07-19 23:45:47', NULL),
(4, 'Tarun Kumar', NULL, NULL, 'srctkm@outlook.com', 'C6PCNPNU0Z0AqxiNhUk3Hg==', NULL, 0, 'e23aa35c', 0, '/resources/user/profile/avtar.jpg', NULL, NULL, NULL, NULL, NULL, NULL, '2024-03-15 13:01:59.158412', 0, 1, NULL, 0, 0, 0, '2024-07-19 23:45:47', NULL, NULL, '2024-07-19 23:45:47', NULL),
(5, 'ashutosh jha', NULL, NULL, 'ashutosh2jha@gmail.com', 'qaJimowdWl0qOZoKpxYa8w==', NULL, 0, '0cc3fc1d', 0, '/resources/user/profile/3o0ftnd5.jpg', '9953509796', 'paris', 'Paris', 'Paris', 'France', '53698', '2024-03-15 14:13:06.403044', 0, 1, '2024-07-19 22:36:13.754540', 0, 917842, 0, '2024-07-22 12:56:41', 'eoL77U-NSIuI8uQuNJ3m4o:APA91bEdC7T0rDLUnT24TB_TVYAXQeFSX_PKig_6hZNo9VtgB9vDj32x3xD-S7D6mxSrO-EvoF0ZVZ6abknUyAXaz2TauGMZ9AbIojtTzBap_RwgE-5hqucPodypSCHH1TuPFhm7FjR6', NULL, '2024-07-19 22:36:13', NULL),
(6, 'Tarun Dev Kumar', NULL, NULL, 'tarundevkumar22@gmail.com', 'qFDwYnX6qww5H+dxoZGAIg==', NULL, 0, '38c9a648', 0, '/resources/user/profile/avtar.jpg', NULL, NULL, NULL, NULL, NULL, NULL, '2024-03-21 23:32:57.958170', 0, 1, NULL, 0, 0, 0, '2024-07-19 23:45:47', NULL, NULL, '2024-07-19 23:45:47', NULL),
(7, 'Tarun Kumar', NULL, NULL, 'tarunmandal.1289@gmail.com', 'x+JbKgznlI+XzgUm7+U+1Q==', NULL, 0, '6fdbbab9', 0, '/resources/user/profile/pdfvmsoa.jpg', NULL, NULL, NULL, NULL, NULL, NULL, '2024-03-26 17:04:14.334867', 0, 1, '2025-07-03 19:03:41.905969', 0, 0, 0, '2024-07-19 23:45:47', NULL, NULL, '2025-07-03 19:03:41', NULL),
(8, 'kislay raj', NULL, NULL, 'kislayraj@gmail.com', 'qaJimowdWl0qOZoKpxYa8w==', NULL, 0, 'f1ed30a1', 0, '/resources/user/profile/avtar.jpg', NULL, NULL, NULL, NULL, NULL, NULL, '2024-06-06 12:37:30.783020', 0, 1, NULL, 0, 0, 0, '2024-07-19 23:45:47', NULL, NULL, '2024-07-19 23:45:47', NULL),
(9, 'dinesh', NULL, NULL, '7414055@gmail.com', 'b7x8Q3CrNqRGE03if8tHQw==', NULL, 0, '20963096', 0, '/resources/user/profile/avtar.jpg', NULL, NULL, NULL, NULL, NULL, NULL, '2024-06-12 12:52:17.125893', 0, 1, NULL, 0, 0, 0, '2024-07-19 23:45:47', NULL, NULL, '2024-07-19 23:45:47', NULL),
(10, '74140555@gmail.com', NULL, NULL, 'ok@123', 'aH/9qKnITTPQN4S9McoCwQ==', NULL, 0, 'd02539e4', 0, '/resources/user/profile/avtar.jpg', NULL, NULL, NULL, NULL, NULL, NULL, '2024-06-16 19:39:53.444612', 0, 1, NULL, 0, 0, 0, '2024-07-19 23:45:47', NULL, NULL, '2024-07-19 23:45:47', NULL),
(11, 'Hello', NULL, NULL, 'testsd@gmail.com', 'dDj57N7j4oR0E7mhK5Qblw==', NULL, 0, 'a1c71f46', 0, '/resources/user/profile/avtar.jpg', NULL, NULL, NULL, NULL, NULL, NULL, '2024-06-16 19:47:34.684736', 0, 1, NULL, 0, 0, 0, '2024-07-19 23:45:47', NULL, NULL, '2024-07-19 23:45:47', NULL),
(12, 'dk', NULL, NULL, 'digcharansab@gmail.com', 'YeT2bpB/Gfd03MVG9dOHpQ==', NULL, 0, '8daeffb6', 0, '/resources/user/profile/avtar.jpg', NULL, NULL, NULL, NULL, NULL, NULL, '2024-06-16 19:52:14.096671', 0, 1, NULL, 0, 0, 0, '2024-07-19 23:45:47', NULL, NULL, '2024-07-19 23:45:47', NULL),
(13, 'iqbal', NULL, NULL, 'iqbal.alam@gmail.com', 'LNlITN2EBIG8e+/DL+dMYQ==', NULL, 0, '00fe514f', 0, '/resources/user/profile/avtar.jpg', NULL, NULL, NULL, NULL, NULL, NULL, '2024-06-26 11:09:37.735189', 0, 1, NULL, 0, 0, 0, '2024-07-19 23:45:47', NULL, NULL, '2024-07-19 23:45:47', NULL),
(14, 'amit sharma ', NULL, NULL, 'test@test.com', 'qaJimowdWl0qOZoKpxYa8w==', NULL, 0, '581cc2fd', 0, '/resources/user/profile/akvv4nlc.jpg', '1234567890', 'address', 'city', 'state', 'country', '1234', '2024-06-29 12:33:22.284065', 0, 1, '2024-07-31 19:50:11.457271', 0, 736620, 0, '2025-01-04 14:31:06', 'cQmQm7UgS9yCDH2HDBKEcC:APA91bEBzBM9DeI7j0jZ9p1DSeHPbU5HRoqREZ0_6iSMpQHabu6i-4-2vsNel_Rlq9gd67MNGaCcfuyt8o2tzfMjKuXrjB6TWdFa-wbZs1dcHlVBFhzOGR8', NULL, '2024-07-31 19:50:11', NULL),
(15, 'Tarun Kumar', NULL, NULL, 'tarunmandal.1289@yahoo.com', 'x+JbKgznlI+XzgUm7+U+1Q==', NULL, 0, '914c4071', 0, '/resources/user/profile/avtar.jpg', NULL, NULL, NULL, NULL, NULL, NULL, '2024-07-04 18:00:25.956369', 0, 1, NULL, 0, 0, 0, '2024-07-19 23:45:47', NULL, NULL, '2024-07-19 23:45:47', NULL),
(16, 'olatz', NULL, NULL, 'olatz_aurrekoetxea@yahoo.com', 'Vu8pXlLHiKhIYP2EAuLxRw==', NULL, 0, '9d7faf11', 0, '/resources/user/profile/avtar.jpg', '603434210', 'Paseo de la Castellana 43', 'Madrid', 'Madrid', 'Spain', '28046', '2024-07-10 00:29:08.177118', 0, 1, '2024-07-26 13:19:38.328626', 0, 0, 0, '2024-07-19 23:45:47', NULL, NULL, '2024-07-26 13:19:38', NULL),
(17, 'jaipal', NULL, NULL, 'jaianimator@gmail.com', 'qaJimowdWl0qOZoKpxYa8w==', NULL, 0, 'f7da706e', 0, '/resources/user/profile/avtar.jpg', NULL, NULL, NULL, NULL, NULL, NULL, '2024-07-16 15:28:32.885607', 0, 1, NULL, 0, 0, 0, '2024-07-19 23:45:47', NULL, NULL, '2024-07-19 23:45:47', NULL),
(18, 'Tarun Kumar', NULL, NULL, 'tarunmandal.1288@yahoo.com', 'qaJimowdWl0qOZoKpxYa8w==', NULL, 0, 'bec36fb0', 0, '/resources/user/profile/avtar.jpg', NULL, NULL, NULL, NULL, NULL, NULL, '2024-07-16 21:01:45.609350', 0, 1, NULL, 0, 0, 0, '2024-07-19 23:45:47', NULL, NULL, '2024-07-19 23:45:47', NULL),
(19, 'Julia', NULL, NULL, 'juliaurruzmendi@icloud.com', 'oxzSNp5aHFSS3UCyHUvMxw==', NULL, 0, '41ddbd7b', 0, '/resources/user/profile/avtar.jpg', NULL, NULL, NULL, NULL, NULL, NULL, '2024-07-17 18:39:32.373340', 0, 1, NULL, 0, 0, 0, '2024-07-19 23:45:47', NULL, NULL, '2024-07-19 23:45:47', NULL),
(20, 'Tarun Kumar', NULL, NULL, 'tarunmamdal.1289@gmail.com', 'x+JbKgznlI+XzgUm7+U+1Q==', NULL, 0, 'cba47a2d', 0, '/resources/user/profile/avtar.jpg', NULL, NULL, NULL, NULL, NULL, NULL, '2024-07-22 12:16:20.215070', 0, 1, NULL, 0, 0, 0, NULL, NULL, NULL, '2024-07-22 12:16:20', NULL),
(21, 'Dhruv jha', NULL, NULL, 'dhruv2jha@gmail.com', 'qaJimowdWl0qOZoKpxYa8w==', NULL, 0, '0cdec000', 0, '/resources/user/profile/pyhbiujs.jpg', NULL, NULL, 'Noida', 'U.P.', 'India', NULL, '2024-07-24 13:00:16.479899', 0, 1, '2025-07-03 18:48:56.858747', 0, 119024, 0, '2024-12-16 15:11:18', 'dcmcbtNSQ6OGrRhNrBNg1q:APA91bHeOy11cx0TpqMJmRzB_nsQdSOTtkXeZIaGMtSBrOzG-YtsW3udzG7PGy1v72k1s8scjY0Tr1Fc1C5o0mp7FbudBK0uwItSQ7SDj7CrZMLWE9kijH0', NULL, '2025-08-05 21:30:27', '49.36.189.26'),
(22, 'Kislay raj', NULL, NULL, 'kislayraj69@gmail.com', 'J54DSgz3sHeThu0DejHLzA==', NULL, 0, '22fc2ab3', 0, '/resources/user/profile/m3c5sknl.jpg', NULL, NULL, 'Paris', 'Paris', 'France', NULL, '2024-08-04 18:23:50.752644', 0, 1, '2024-08-30 16:11:33.567476', 0, 0, 0, NULL, 'eT09t9jLRtyPP5uPGiHZia:APA91bGaKeMXXhtd7hTcDAVDpENhjFQb7-70XFWcUQxn8pjuDiHTN9qQmPu2bZMW7urMzwBI_WxTqknlUDWnjjcXO20BoMc1juO-c28Jzbtp4xjwWZE10hlhgfijo8IXuzejMNptVh2P', NULL, '2024-08-30 16:11:33', NULL),
(24, 'Dhruv Kumar', NULL, NULL, 'dhruv5jha@gmail.com', 'qaJimowdWl0qOZoKpxYa8w==', NULL, 0, '65a88ea6', 0, '/resources/user/profile/avtar.jpg', NULL, NULL, 'Noida', NULL, 'India', NULL, '2024-08-05 13:40:08.609992', 0, 1, NULL, 0, 0, 0, NULL, 'dVuHFQ6cRv6dsLjTc6aFhh:APA91bFuHJsS6oJLQjcpDxkYvbfZlvUsK7r4lmBXYkYfGlAx-JLDCUaFkRlr2710El1km7cElXVpTxTGoJUiEC72VLqwevlFEI_q8WkdbqRF8iOhqPvLvocDSsCsamjR8t6rdLxCe615', NULL, '2025-07-23 10:47:31', '223.181.33.8'),
(26, 'Francis Menon', 'Francis', 'Menon', 'kislay.raj.maventechie@gmail.com', NULL, NULL, 1, NULL, 0, NULL, '9876543212', NULL, 'Eure', NULL, 'France', NULL, '2024-08-31 10:26:30.000000', 0, 1, NULL, 0, 0, 0, NULL, NULL, NULL, '2024-08-31 10:26:30', NULL),
(27, 'shivam', NULL, NULL, 'shivam.sharma@maventechie.com', 'jFYer+hTC2MlJ1jlVj95QA==', NULL, 0, 'd5cb7985', 0, '/resources/user/profile/avtar.jpg', NULL, NULL, 'Mohali', NULL, 'India', NULL, '2025-01-08 15:56:43.876818', 0, 1, '2025-01-09 00:47:29.841452', 0, 338492, 0, '2025-01-08 16:45:15', 'dKdr0X0wR7qkwl-1SRtyQv:APA91bEuBuiPtV6NXIdkm-1sBw_E2FQKesvOPI0egBXxNCvnyHrbrOtdNQtYdacLzB1dAGcnYXuVITXFjVuLD5lwqjD8HsfsIwT2f9HGs7GOBtA_lyJQ_6Y', NULL, '2025-01-09 00:47:29', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `userchats`
--

CREATE TABLE `userchats` (
  `id` int(11) NOT NULL,
  `fromuserid` int(11) NOT NULL,
  `touserid` int(11) NOT NULL,
  `isread` int(11) NOT NULL DEFAULT 0,
  `createdon` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `usercurrentlocation`
--

CREATE TABLE `usercurrentlocation` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `country` varchar(200) DEFAULT NULL,
  `city` varchar(200) DEFAULT NULL,
  `updatedon` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `usercurrentlocation`
--

INSERT INTO `usercurrentlocation` (`id`, `userid`, `country`, `city`, `updatedon`) VALUES
(1, 2, 'FR', 'Paris', '0001-01-01 00:00:00.000000'),
(2, 1, 'UK', 'London', '0001-01-01 00:00:00.000000'),
(3, 0, 'FR', 'Paris', '0001-01-01 00:00:00.000000'),
(4, 9, 'FR', 'Chez Minna', '0001-01-01 00:00:00.000000'),
(5, 0, NULL, NULL, '2024-06-26 11:09:37.951942'),
(6, 0, NULL, NULL, '2024-06-29 12:33:22.487858'),
(7, 0, NULL, NULL, '2024-07-04 18:00:26.125866'),
(8, 14, 'FR', 'Paris', '0001-01-01 00:00:00.000000'),
(9, 5, 'FR', 'Paris', '0001-01-01 00:00:00.000000'),
(10, 0, NULL, NULL, '2024-07-10 00:29:08.407969'),
(11, 15, 'UK', 'London', '0001-01-01 00:00:00.000000'),
(12, 0, NULL, NULL, '2024-07-16 15:28:33.089339'),
(13, 17, 'UK', 'London', '0001-01-01 00:00:00.000000'),
(14, 0, NULL, NULL, '2024-07-16 21:01:45.789789'),
(15, 18, 'FR', 'Paris', '0001-01-01 00:00:00.000000'),
(16, 16, 'FR', 'Paris', '0001-01-01 00:00:00.000000'),
(17, 0, NULL, NULL, '2024-07-17 18:39:32.569159'),
(18, 19, 'FR', 'Paris', '0001-01-01 00:00:00.000000'),
(19, 0, NULL, NULL, '2024-07-22 12:16:20.291410'),
(20, 7, 'FR', 'Paris', '0001-01-01 00:00:00.000000'),
(21, 0, NULL, NULL, '2024-07-24 13:00:16.561549'),
(22, 0, NULL, NULL, '2024-08-04 18:23:51.002206'),
(23, 22, 'FR', 'Paris', '0001-01-01 00:00:00.000000'),
(24, 0, NULL, NULL, '2024-08-05 13:36:09.526294'),
(25, 0, 'IN', 'Ghaziabad', '2024-08-05 13:40:08.894351'),
(26, 24, 'FR', 'Paris', '0001-01-01 00:00:00.000000'),
(27, 21, 'UK', 'London', '0001-01-01 00:00:00.000000'),
(28, 0, 'IN', 'Mohali', '2025-01-08 15:56:43.969019'),
(29, 27, 'IN', 'Uttar Pradesh', '0001-01-01 00:00:00.000000');

-- --------------------------------------------------------

--
-- Table structure for table `userrights`
--

CREATE TABLE `userrights` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `adminmanage` int(11) NOT NULL,
  `customermanage` int(11) NOT NULL,
  `orderlist` int(11) NOT NULL,
  `productmodule` int(11) NOT NULL,
  `manufacturermodule` int(11) NOT NULL,
  `recipemodule` int(11) NOT NULL,
  `newslettermanage` int(11) NOT NULL,
  `taxdiscountmanage` int(11) NOT NULL,
  `couponmanage` int(11) NOT NULL,
  `pagemanage` int(11) NOT NULL,
  `generalsettings` int(11) NOT NULL,
  `notifytolowstock` int(11) NOT NULL,
  `createdon` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `wishlist`
--

CREATE TABLE `wishlist` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `restroid` int(11) NOT NULL,
  `createdon` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `wishlist`
--

INSERT INTO `wishlist` (`id`, `userid`, `restroid`, `createdon`) VALUES
(1, 21, 114, '2024-07-01 11:09:36.000000'),
(2, 24, 104, '2024-08-19 11:15:11.000000'),
(4, 24, 102, '2024-08-18 11:16:30.000000'),
(5, 22, 100, '2024-08-19 11:18:03.000000'),
(6, 22, 99, '2024-08-19 11:18:03.000000'),
(7, 22, 98, '2024-08-19 11:18:03.000000');

-- --------------------------------------------------------

--
-- Table structure for table `wish_try_tested_restaurants`
--

CREATE TABLE `wish_try_tested_restaurants` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL DEFAULT 0,
  `restroid` int(11) NOT NULL DEFAULT 0,
  `iswishlist` int(11) NOT NULL DEFAULT 0,
  `istrylist` int(11) NOT NULL DEFAULT 0,
  `istestedlist` int(11) NOT NULL DEFAULT 0,
  `createdon` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `wish_try_tested_restaurants`
--

INSERT INTO `wish_try_tested_restaurants` (`id`, `userid`, `restroid`, `iswishlist`, `istrylist`, `istestedlist`, `createdon`) VALUES
(3, 1, 2, 1, 0, 0, '2024-03-26 21:10:12.918399'),
(4, 14, 1, 0, 0, 1, '2024-07-06 15:07:59.847219'),
(5, 14, 2, 1, 0, 0, '2024-07-06 15:16:27.951786'),
(6, 14, 5, 1, 1, 1, '2024-07-06 15:25:40.515591'),
(7, 1, 1, 1, 0, 0, '2024-07-06 15:28:20.669112'),
(8, 5, 64, 1, 1, 1, '2024-07-09 13:10:30.453721'),
(9, 14, 8, 1, 0, 1, '2024-07-11 14:25:32.827618'),
(10, 5, 6, 1, 0, 1, '2024-07-12 09:06:10.731907'),
(11, 5, 71, 0, 0, 1, '2024-07-12 09:11:39.669993'),
(12, 5, 72, 0, 0, 0, '2024-07-12 10:45:46.864340'),
(13, 5, 65, 1, 1, 0, '2024-07-15 16:17:06.686997'),
(14, 17, 2, 0, 0, 0, '2024-07-16 15:30:15.244238'),
(15, 18, 8, 1, 0, 1, '2024-07-16 21:02:45.378940'),
(16, 18, 71, 1, 1, 1, '2024-07-16 21:04:10.439653'),
(17, 18, 66, 1, 0, 0, '2024-07-16 21:07:49.397871'),
(18, 16, 69, 0, 0, 0, '2024-07-21 23:52:58.155090'),
(19, 16, 68, 0, 0, 1, '2024-07-21 23:53:09.938638'),
(20, 16, 70, 0, 1, 0, '2024-07-21 23:53:17.320792'),
(21, 16, 71, 0, 1, 0, '2024-07-21 23:53:37.797047'),
(22, 18, 72, 1, 1, 1, '2024-07-22 12:11:33.601228'),
(23, 7, 8, 1, 1, 1, '2024-07-22 12:18:42.910653'),
(24, 7, 6, 1, 0, 1, '2024-07-22 12:20:26.740256'),
(25, 5, 69, 0, 0, 1, '2024-07-22 12:40:04.555658'),
(26, 5, 68, 0, 0, 1, '2024-07-22 12:41:39.908367'),
(27, 14, 72, 0, 0, 0, '2024-07-23 11:42:00.101994'),
(28, 14, 71, 1, 1, 1, '2024-07-23 11:50:22.453823'),
(29, 7, 71, 1, 0, 1, '2024-07-25 20:57:12.818485'),
(30, 7, 65, 0, 0, 1, '2024-07-25 21:00:56.286325'),
(31, 5, 67, 1, 0, 0, '2024-07-25 21:05:11.571719'),
(32, 22, 3, 0, 0, 0, '2024-08-05 14:23:04.916719'),
(33, 7, 72, 1, 1, 1, '2024-08-10 14:36:46.432235'),
(34, 22, 1, 0, 0, 1, '2024-08-30 12:44:54.475049'),
(35, 22, 6, 1, 0, 0, '2024-08-30 12:45:56.040126'),
(36, 22, 8, 1, 1, 0, '2024-08-30 12:48:54.668839'),
(37, 22, 103, 1, 0, 0, '2024-08-30 15:26:08.689977'),
(38, 22, 108, 1, 0, 0, '2024-08-30 16:03:41.369916'),
(39, 22, 155, 1, 0, 0, '2024-09-03 17:24:04.312447'),
(40, 7, 89, 0, 1, 0, '2024-10-05 13:33:49.558385'),
(41, 21, 162, 1, 0, 1, '2024-12-19 22:46:57.729163'),
(42, 21, 101, 0, 1, 1, '2024-12-19 22:47:06.916784'),
(43, 21, 163, 1, 1, 1, '2024-12-19 22:47:13.111251'),
(44, 21, 161, 1, 1, 1, '2024-12-19 22:47:55.269254'),
(45, 21, 158, 1, 0, 1, '2024-12-19 22:48:00.753211'),
(46, 21, 72, 1, 0, 0, '2024-12-19 22:48:45.192352'),
(47, 19, 66, 1, 0, 0, '2025-06-29 20:26:58.300191');

-- --------------------------------------------------------

--
-- Table structure for table `__efmigrationshistory`
--

CREATE TABLE `__efmigrationshistory` (
  `MigrationId` varchar(95) NOT NULL,
  `ProductVersion` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `__efmigrationshistory`
--

INSERT INTO `__efmigrationshistory` (`MigrationId`, `ProductVersion`) VALUES
('20231031084014_createinitialtable', '3.1.27'),
('20231117060236_changesrestotable', '3.1.27'),
('20231206143816_addcolsubregioninrestro', '3.1.27'),
('20240313025849_addcommunitytable', '3.1.27'),
('20240313025849_addcommunitytable3', '3.1.27'),
('20240313054046_addcommunitytable2', '3.1.27'),
('20240326110725_addtablewishtrytested', '3.1.27'),
('20240530173558_newentries', '3.1.27'),
('20240530183213_newentries2', '3.1.27'),
('20240530190852_newentries3', '3.1.27'),
('20240615171849_add-col-countries', '3.1.27'),
('20240615172439_addcolcountry', '3.1.27'),
('20240617092819_addtabuserlocation', '3.1.27'),
('20240701092312_addcolintabrestro5', '3.1.27'),
('20240711100225_addcolrestromenu', '3.1.27'),
('20240711101142_addcolrestromenu2', '3.1.27'),
('20240719161208_addcolusertab', '3.1.27'),
('20240719175627_addcolusertab2', '3.1.27'),
('20240724053359_adddevidinuser', '3.1.27'),
('20240730162532_addnewtab2', '3.1.27'),
('20240730162532_addnewtab3', '3.1.27'),
('20240730174423_addnewtabcontact', '3.1.27'),
('20240730174423_addnewtabcontact1', '3.1.27'),
('20240730175634_addnewtabcontact2', '3.1.27'),
('20240805064333_addcolorderinads', '3.1.27'),
('20240809043115_addtabfuud_push_notification', '3.1.27'),
('20240809043316_addcolfcminappsett', '3.1.27'),
('20240809054152_addcolpushnotify', '3.1.27'),
('20240809162722_addcolinads', '3.1.27'),
('20250109080814_addcolinuser', '3.1.27'),
('20250109102104_changecolsubscriptioninuser', '3.1.27'),
('20250723050549_addnewcolinuser', '3.1.27');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `appsetting`
--
ALTER TABLE `appsetting`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `beenlist`
--
ALTER TABLE `beenlist`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `community`
--
ALTER TABLE `community`
  ADD PRIMARY KEY (`id`),
  ADD KEY `community_creatorid_foreign` (`creatorid`);

--
-- Indexes for table `communitydislike`
--
ALTER TABLE `communitydislike`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `communitylike`
--
ALTER TABLE `communitylike`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `communityreply`
--
ALTER TABLE `communityreply`
  ADD PRIMARY KEY (`id`),
  ADD KEY `communityreply_communityid_foreign` (`communityid`);

--
-- Indexes for table `communityreplydislike`
--
ALTER TABLE `communityreplydislike`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `communityreplylike`
--
ALTER TABLE `communityreplylike`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `communityshare`
--
ALTER TABLE `communityshare`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `contactus`
--
ALTER TABLE `contactus`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `countries`
--
ALTER TABLE `countries`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `couponforrestaurant`
--
ALTER TABLE `couponforrestaurant`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `coupons`
--
ALTER TABLE `coupons`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `couponsuses`
--
ALTER TABLE `couponsuses`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `coupons_city`
--
ALTER TABLE `coupons_city`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `coupons_country`
--
ALTER TABLE `coupons_country`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `customer_email_change_otp`
--
ALTER TABLE `customer_email_change_otp`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `dailysalesreport`
--
ALTER TABLE `dailysalesreport`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `emailtemplate`
--
ALTER TABLE `emailtemplate`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `faq`
--
ALTER TABLE `faq`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `faqquestion`
--
ALTER TABLE `faqquestion`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `fuud_booking_logs`
--
ALTER TABLE `fuud_booking_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `fuud_booking_management`
--
ALTER TABLE `fuud_booking_management`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `fuud_customer_details`
--
ALTER TABLE `fuud_customer_details`
  ADD PRIMARY KEY (`cust_id`),
  ADD UNIQUE KEY `fuud_customer_details_cust_email_id_unique` (`cust_email_id`);

--
-- Indexes for table `fuud_cust_otp`
--
ALTER TABLE `fuud_cust_otp`
  ADD PRIMARY KEY (`otp_id`);

--
-- Indexes for table `fuud_push_notification`
--
ALTER TABLE `fuud_push_notification`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `fuud_registered_users`
--
ALTER TABLE `fuud_registered_users`
  ADD PRIMARY KEY (`reg_user_id`);

--
-- Indexes for table `fuud_restaurant_users`
--
ALTER TABLE `fuud_restaurant_users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `fuud_tags`
--
ALTER TABLE `fuud_tags`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `fuud_user_roles`
--
ALTER TABLE `fuud_user_roles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `gototrylist`
--
ALTER TABLE `gototrylist`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order`
--
ALTER TABLE `order`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `privacypolicy`
--
ALTER TABLE `privacypolicy`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `recentview`
--
ALTER TABLE `recentview`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `restaurantimages`
--
ALTER TABLE `restaurantimages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `restaurantmenu`
--
ALTER TABLE `restaurantmenu`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `restaurantopenhour`
--
ALTER TABLE `restaurantopenhour`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `restaurantreview`
--
ALTER TABLE `restaurantreview`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `restaurants`
--
ALTER TABLE `restaurants`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `restaurant_business_hours`
--
ALTER TABLE `restaurant_business_hours`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `restaurant_shift_schedule`
--
ALTER TABLE `restaurant_shift_schedule`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `restaurant_shift_timing`
--
ALTER TABLE `restaurant_shift_timing`
  ADD PRIMARY KEY (`time_id`),
  ADD KEY `restaurant_shift_timing_schedule_id_foreign` (`schedule_id`);

--
-- Indexes for table `restaurant_tables`
--
ALTER TABLE `restaurant_tables`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `restaurant_tables_occupied_status`
--
ALTER TABLE `restaurant_tables_occupied_status`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `restroads`
--
ALTER TABLE `restroads`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `rewards`
--
ALTER TABLE `rewards`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `rewardsummary`
--
ALTER TABLE `rewardsummary`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `searches`
--
ALTER TABLE `searches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `seeder_track_list`
--
ALTER TABLE `seeder_track_list`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `subscriber`
--
ALTER TABLE `subscriber`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `termsandconditions`
--
ALTER TABLE `termsandconditions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `userchats`
--
ALTER TABLE `userchats`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `usercurrentlocation`
--
ALTER TABLE `usercurrentlocation`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `userrights`
--
ALTER TABLE `userrights`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `wishlist`
--
ALTER TABLE `wishlist`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `wish_try_tested_restaurants`
--
ALTER TABLE `wish_try_tested_restaurants`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `__efmigrationshistory`
--
ALTER TABLE `__efmigrationshistory`
  ADD PRIMARY KEY (`MigrationId`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `appsetting`
--
ALTER TABLE `appsetting`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `beenlist`
--
ALTER TABLE `beenlist`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `community`
--
ALTER TABLE `community`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `communitydislike`
--
ALTER TABLE `communitydislike`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `communitylike`
--
ALTER TABLE `communitylike`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `communityreply`
--
ALTER TABLE `communityreply`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT for table `communityreplydislike`
--
ALTER TABLE `communityreplydislike`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `communityreplylike`
--
ALTER TABLE `communityreplylike`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `communityshare`
--
ALTER TABLE `communityshare`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `contactus`
--
ALTER TABLE `contactus`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `countries`
--
ALTER TABLE `countries`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `couponforrestaurant`
--
ALTER TABLE `couponforrestaurant`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=316;

--
-- AUTO_INCREMENT for table `coupons`
--
ALTER TABLE `coupons`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `couponsuses`
--
ALTER TABLE `couponsuses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `coupons_city`
--
ALTER TABLE `coupons_city`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `coupons_country`
--
ALTER TABLE `coupons_country`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `customer_email_change_otp`
--
ALTER TABLE `customer_email_change_otp`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `dailysalesreport`
--
ALTER TABLE `dailysalesreport`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `emailtemplate`
--
ALTER TABLE `emailtemplate`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `faq`
--
ALTER TABLE `faq`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `faqquestion`
--
ALTER TABLE `faqquestion`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `fuud_booking_logs`
--
ALTER TABLE `fuud_booking_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `fuud_booking_management`
--
ALTER TABLE `fuud_booking_management`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `fuud_customer_details`
--
ALTER TABLE `fuud_customer_details`
  MODIFY `cust_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `fuud_cust_otp`
--
ALTER TABLE `fuud_cust_otp`
  MODIFY `otp_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `fuud_push_notification`
--
ALTER TABLE `fuud_push_notification`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `fuud_registered_users`
--
ALTER TABLE `fuud_registered_users`
  MODIFY `reg_user_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=114;

--
-- AUTO_INCREMENT for table `fuud_restaurant_users`
--
ALTER TABLE `fuud_restaurant_users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `fuud_tags`
--
ALTER TABLE `fuud_tags`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=247;

--
-- AUTO_INCREMENT for table `fuud_user_roles`
--
ALTER TABLE `fuud_user_roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `gototrylist`
--
ALTER TABLE `gototrylist`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=163;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `order`
--
ALTER TABLE `order`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `privacypolicy`
--
ALTER TABLE `privacypolicy`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `recentview`
--
ALTER TABLE `recentview`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `restaurantimages`
--
ALTER TABLE `restaurantimages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=297;

--
-- AUTO_INCREMENT for table `restaurantmenu`
--
ALTER TABLE `restaurantmenu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=95;

--
-- AUTO_INCREMENT for table `restaurantopenhour`
--
ALTER TABLE `restaurantopenhour`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT for table `restaurantreview`
--
ALTER TABLE `restaurantreview`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `restaurants`
--
ALTER TABLE `restaurants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=166;

--
-- AUTO_INCREMENT for table `restaurant_business_hours`
--
ALTER TABLE `restaurant_business_hours`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5381;

--
-- AUTO_INCREMENT for table `restaurant_shift_schedule`
--
ALTER TABLE `restaurant_shift_schedule`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=80;

--
-- AUTO_INCREMENT for table `restaurant_shift_timing`
--
ALTER TABLE `restaurant_shift_timing`
  MODIFY `time_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=74;

--
-- AUTO_INCREMENT for table `restaurant_tables`
--
ALTER TABLE `restaurant_tables`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=76;

--
-- AUTO_INCREMENT for table `restaurant_tables_occupied_status`
--
ALTER TABLE `restaurant_tables_occupied_status`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `restroads`
--
ALTER TABLE `restroads`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `rewards`
--
ALTER TABLE `rewards`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `rewardsummary`
--
ALTER TABLE `rewardsummary`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `searches`
--
ALTER TABLE `searches`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `seeder_track_list`
--
ALTER TABLE `seeder_track_list`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `subscriber`
--
ALTER TABLE `subscriber`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `termsandconditions`
--
ALTER TABLE `termsandconditions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `userchats`
--
ALTER TABLE `userchats`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `usercurrentlocation`
--
ALTER TABLE `usercurrentlocation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `userrights`
--
ALTER TABLE `userrights`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `wishlist`
--
ALTER TABLE `wishlist`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `wish_try_tested_restaurants`
--
ALTER TABLE `wish_try_tested_restaurants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `community`
--
ALTER TABLE `community`
  ADD CONSTRAINT `community_creatorid_foreign` FOREIGN KEY (`creatorid`) REFERENCES `user` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `communityreply`
--
ALTER TABLE `communityreply`
  ADD CONSTRAINT `communityreply_communityid_foreign` FOREIGN KEY (`communityid`) REFERENCES `community` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `restaurant_shift_timing`
--
ALTER TABLE `restaurant_shift_timing`
  ADD CONSTRAINT `restaurant_shift_timing_schedule_id_foreign` FOREIGN KEY (`schedule_id`) REFERENCES `restaurant_shift_schedule` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
