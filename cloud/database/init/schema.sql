CREATE DATABASE IF NOT EXISTS `Pollster`;

USE `Pollster`;

DROP TABLE IF EXISTS `ANSWERS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ANSWERS` (
  `ANSWER_ID` int NOT NULL AUTO_INCREMENT,
  `QUESTION_ID` varchar(50) NOT NULL,
  `POLL_ID` varchar(50) NOT NULL,
  `RECIPIENT` int NOT NULL,
  `ANSWER` varchar(500) NOT NULL,
  PRIMARY KEY (`ANSWER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ANSWERS`
--

LOCK TABLES `ANSWERS` WRITE;
/*!40000 ALTER TABLE `ANSWERS` DISABLE KEYS */;
/*!40000 ALTER TABLE `ANSWERS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `POLLS`
--

DROP TABLE IF EXISTS `POLLS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `POLLS` (
  `POLL_AUTO_ID` int NOT NULL AUTO_INCREMENT,
  `POLL_ID` varchar(50) NOT NULL,
  `CREATOR` int NOT NULL,
  `TITLE` varchar(100) NOT NULL,
  `CREATED` date NOT NULL,
  PRIMARY KEY (`POLL_AUTO_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `POLLS`
--

LOCK TABLES `POLLS` WRITE;
/*!40000 ALTER TABLE `POLLS` DISABLE KEYS */;
/*!40000 ALTER TABLE `POLLS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `QUESTIONS`
--

DROP TABLE IF EXISTS `QUESTIONS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `QUESTIONS` (
  `QUESTION_ID` int NOT NULL AUTO_INCREMENT,
  `POLL_ID` varchar(50) NOT NULL,
  `PROMPT` varchar(500) NOT NULL,
  `CHOICES` varchar(500) NOT NULL,
  PRIMARY KEY (`QUESTION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `QUESTIONS`
--

LOCK TABLES `QUESTIONS` WRITE;
/*!40000 ALTER TABLE `QUESTIONS` DISABLE KEYS */;
/*!40000 ALTER TABLE `QUESTIONS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RECIPIENT`
--

DROP TABLE IF EXISTS `RECIPIENT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RECIPIENT` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `RECIPIENT` int NOT NULL,
  `CREATOR` int NOT NULL,
  `POLL_ID` varchar(50) NOT NULL,
  `ANSWERED` tinyint(1) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RECIPIENT`
--

LOCK TABLES `RECIPIENT` WRITE;
/*!40000 ALTER TABLE `RECIPIENT` DISABLE KEYS */;
/*!40000 ALTER TABLE `RECIPIENT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USERS`
--

DROP TABLE IF EXISTS `USERS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USERS` (
  `USER_ID` int NOT NULL AUTO_INCREMENT,
  `EMAIL` varchar(100) NOT NULL,
  `PASSWORD` varchar(100) NOT NULL,
  `PHONENUMBER` varchar(15) NOT NULL,
  `START_DATE` date NOT NULL,
  `LAST_ACCESS` datetime NOT NULL,
  PRIMARY KEY (`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USERS`
--

LOCK TABLES `USERS` WRITE;
/*!40000 ALTER TABLE `USERS` DISABLE KEYS */;
/*!40000 ALTER TABLE `USERS` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-02-24  1:04:39

CREATE USER 'admin'@'%' IDENTIFIED BY '';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION;
