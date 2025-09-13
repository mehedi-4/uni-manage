-- MySQL dump 10.13  Distrib 8.4.6, for Linux (x86_64)
--
-- Host: localhost    Database: student_info
-- ------------------------------------------------------
-- Server version	8.4.6

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admins`
--

DROP TABLE IF EXISTS `admins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admins` (
  `reg` varchar(20) DEFAULT NULL,
  `pass` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admins`
--

LOCK TABLES `admins` WRITE;
/*!40000 ALTER TABLE `admins` DISABLE KEYS */;
INSERT INTO `admins` VALUES ('admin1','adfadfasdfasdf'),('admin2','jlk0p93492j');
/*!40000 ALTER TABLE `admins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_assignments`
--

DROP TABLE IF EXISTS `course_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_assignments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_code` varchar(20) DEFAULT NULL,
  `teacher_reg` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `course_code` (`course_code`),
  KEY `teacher_reg` (`teacher_reg`),
  CONSTRAINT `course_assignments_ibfk_1` FOREIGN KEY (`course_code`) REFERENCES `courses` (`code`),
  CONSTRAINT `course_assignments_ibfk_2` FOREIGN KEY (`teacher_reg`) REFERENCES `teachers` (`reg`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_assignments`
--

LOCK TABLES `course_assignments` WRITE;
/*!40000 ALTER TABLE `course_assignments` DISABLE KEYS */;
INSERT INTO `course_assignments` VALUES (6,'CSE101','T001'),(7,'CSE102','T003'),(8,'CSE202','T001'),(9,'CSE450','T004'),(10,'CSE303','T002'),(11,'CSE203','T002'),(12,'CSE302','T005'),(13,'CSE451','T005'),(14,'CSE103','T005'),(15,'CSE201','T005'),(16,'CSE453','T001'),(17,'CSE520','T003');
/*!40000 ALTER TABLE `course_assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_registration`
--

DROP TABLE IF EXISTS `course_registration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_registration` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_reg` varchar(20) NOT NULL,
  `course_code` varchar(20) NOT NULL,
  `semester` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `student_reg` (`student_reg`,`course_code`),
  KEY `course_code` (`course_code`),
  CONSTRAINT `course_registration_ibfk_1` FOREIGN KEY (`student_reg`) REFERENCES `students` (`reg`),
  CONSTRAINT `course_registration_ibfk_2` FOREIGN KEY (`course_code`) REFERENCES `courses` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_registration`
--

LOCK TABLES `course_registration` WRITE;
/*!40000 ALTER TABLE `course_registration` DISABLE KEYS */;
INSERT INTO `course_registration` VALUES (1,'2022331004','CSE201','2'),(2,'2022331004','CSE202','2'),(3,'2022331004','CSE450','4'),(4,'2022331004','CSE101','1'),(5,'2022331004','CSE102','1'),(6,'2022331004','CSE103','1'),(9,'2022331004','CSE203','2'),(11,'2022331004','CSE301','3'),(12,'2022331004','CSE302','3'),(13,'2022331004','CSE303','3'),(14,'2022331025','CSE201','2'),(15,'2022331025','CSE202','2'),(17,'2022331025','CSE302','3'),(20,'2022331025','CSE452','5'),(21,'2022331025','CSE301','3'),(26,'2022331025','CSE303','3'),(28,'2022331004','CSE451','5'),(30,'2022331025','CSE450','2'),(31,'2022331022','CSE201','2'),(32,'2022331022','CSE202','2'),(33,'2022331022','CSE302','3'),(34,'2022331022','CSE303','3'),(35,'2022331022','CSE453','2'),(36,'2022331004','CSE453','2'),(37,'2022331025','CSE453','2'),(38,'2022331022','CSE301','4'),(40,'2022331022','CSE450','4'),(41,'2022331003','CSE101','1'),(42,'2022331003','CSE102','1'),(43,'2022331003','CSE301','3'),(44,'2022331003','CSE302','3'),(45,'2022331003','CSE450','4'),(46,'2022331004','CSE520','6'),(47,'2022331022','CSE520','6');
/*!40000 ALTER TABLE `course_registration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courses`
--

DROP TABLE IF EXISTS `courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `courses` (
  `code` varchar(10) NOT NULL,
  `title` varchar(100) NOT NULL,
  `credit` float NOT NULL,
  `semester` int NOT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courses`
--

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
INSERT INTO `courses` VALUES ('CSE101','Introduction to Programming',3,1),('CSE102','Computer Fundamentals',3,1),('CSE103','Discrete Mathematics',3,1),('CSE201','Data Structures',3.5,2),('CSE202','Digital Logic Design',3,2),('CSE203','Object-Oriented Programming',3.5,2),('CSE301','Database Systems',3,3),('CSE302','Computer Architecture',3,3),('CSE303','Algorithms',3.5,3),('CSE450','Project II',3,4),('CSE451','adklfjal',3.5,5),('CSE452','alkdfal;kfjl',3.5,5),('CSE453','lksdafjkl asdlkjf',3,2),('CSE520','Computer Graphics',3,6);
/*!40000 ALTER TABLE `courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `students` (
  `reg` varchar(20) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `pass` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`reg`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES ('2022331001','Drubo Roy Bishwas','8vG#pR2!kTzQ'),('2022331002','Md. Sadman Saquib','fL3@uW8^xJmB'),('2022331003','Robin Dey Rudro','R7s*eY1!oVpN'),('2022331004','Mehedi Hasan Emon','kQ9$zC4@tLmH'),('2022331005','Nazmul Islam','W2v&nP5%qGxT'),('2022331006','Md. Hadisur Rahman Molla','jX8!aR7@dKfU'),('2022331007','MD.Abdullah Al Saim','T1m#oL6^pSgD'),('2022331008','Ihfaz Ahmed Adib','qB4&hZ9@vXnJ'),('2022331009','Deen Mohammed','pK3%tY5!lFwQ'),('2022331010','Tusher Ahmed','zH7$gU2@dMnB'),('2022331011','Alif Ibnay Hyder Ope','sE5^xC8!rLqT'),('2022331012','Md.Shahria Sarker','N9v&bJ3#tWpM'),('2022331013','Sabbir Islam Riyad','fU2!yR6@pZkH'),('2022331014','MD MASHRAFI','wQ5$gT8#nLmD'),('2022331015','MD Shajjadul Ferdous','C3^oF7!kXpVJ'),('2022331016','Shimul Das','tP6&zL1^mRbN'),('2022331017','Mashuk-ur Rahman Manik','hJ8!fS4@qXgD'),('2022331018','Shah Ahnaful Islam','L2%wM9#tVpQH'),('2022331019','Md. Nazmul Islam Mahin','yF7$kC3!dGnT'),('2022331020','Sajib Kumar Roy','uX5^oR2@lBmD'),('2022331021','Al-Mamun','G9&hT6#nWqKJ'),('2022331022','Md Bin Monjur Azmine','kM4!pV8@rSzQ'),('2022331023','Rantideb Roy','Z1^tL5!jFhXB'),('2022331024','Md. Farhan Hasin Anik','dR3&nG7#oMpT'),('2022331025','Ahsan Habib','aDDFsd45sf#%a');
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teachers`
--

DROP TABLE IF EXISTS `teachers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teachers` (
  `reg` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `pass` varchar(100) NOT NULL,
  PRIMARY KEY (`reg`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teachers`
--

LOCK TABLES `teachers` WRITE;
/*!40000 ALTER TABLE `teachers` DISABLE KEYS */;
INSERT INTO `teachers` VALUES ('T001','A.K.M Fakhrul Hossain','aDDFsd45sf#%a'),('T002','Md. Eamin Rahman','Z1^tL5!jFhXB'),('T003','Shadmim Hasan Sifat','N9v&bJ3#tWpM'),('T004','Abdullah Al Noman','iouowq()*DC'),('T005','Ishtiaque Zahid','lkasdf8(&*-84)');
/*!40000 ALTER TABLE `teachers` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-09-13 21:44:39
