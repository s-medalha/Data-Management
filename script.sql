/* ============================================================
   Bookstore
   ============================================================ */

DROP DATABASE bookstore_db;
CREATE DATABASE IF NOT EXISTS bookstore_db
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;
USE bookstore_db;

/* ============================================================
   Book Data
   ============================================================ */

-- Publishers
CREATE TABLE IF NOT EXISTS Publisher (
  Publisher_ID   INT AUTO_INCREMENT NOT NULL,
  Publisher_Name VARCHAR(30) UNIQUE NOT NULL,
  PRIMARY KEY (Publisher_ID)
) ;

-- Genres
CREATE TABLE IF NOT EXISTS Genre (
  Genre_ID   INT AUTO_INCREMENT NOT NULL,
  Genre_Name VARCHAR(20) UNIQUE NOT NULL,
 PRIMARY KEY (Genre_ID)
) ;

-- Authors
CREATE TABLE IF NOT EXISTS Author (
  Author_ID  INT AUTO_INCREMENT NOT NULL,
  Author_FirstName VARCHAR(20) NOT NULL,
  Author_LastName  VARCHAR(20) NOT NULL,
  PRIMARY KEY (Author_ID)
) ;

-- Book Formats (ebook, hardcover, etc.)
CREATE TABLE IF NOT EXISTS Book_Format (
  Format_ID  INT AUTO_INCREMENT NOT NULL,
  Format_Name VARCHAR(20) UNIQUE NOT NULL,
  PRIMARY KEY (Format_ID)
) ;

-- Books
CREATE TABLE IF NOT EXISTS Book (
  Book_ID		INT AUTO_INCREMENT NOT NULL,
  ISBN		    VARCHAR(13) UNIQUE NOT NULL,
  Publisher_ID  INT NOT NULL,
  Genre_ID      INT NOT NULL,
  Format_ID     INT NOT NULL,
  Title         VARCHAR(50) NOT NULL,
  Edition       VARCHAR(10),
  Price         DECIMAL(10,2) NOT NULL,
  Stock         INT NOT NULL DEFAULT 0, 
  PRIMARY KEY (Book_ID),
  FOREIGN KEY (Publisher_ID) REFERENCES Publisher(Publisher_ID) ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (Genre_ID)     REFERENCES Genre(Genre_ID) ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (Format_ID)    REFERENCES Book_Format(Format_ID) ON UPDATE CASCADE ON DELETE RESTRICT
) ;

-- Authors_Books junction table
CREATE TABLE IF NOT EXISTS Authors_Books (
  Author_ID INT NOT NULL,
  Book_ID   INT NOT NULL,
  PRIMARY KEY (Author_ID, Book_ID),
  FOREIGN KEY (Author_ID) REFERENCES Author(Author_ID) ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (Book_ID)   REFERENCES Book(Book_ID) ON UPDATE CASCADE ON DELETE RESTRICT
) ;

/* ============================================================
   Customers & Sales
   ============================================================ */

-- Customers
CREATE TABLE IF NOT EXISTS Customer (
  Customer_ID INT AUTO_INCREMENT NOT NULL,
  Customer_FirstName VARCHAR(20) NOT NULL,
  Customer_LastName VARCHAR(20) NOT NULL,
  Email      VARCHAR(100) UNIQUE,
  Phone      VARCHAR(20),
  PRIMARY KEY (Customer_ID)
) ;

-- Orders
CREATE TABLE IF NOT EXISTS Sale_Order (
  Order_ID    INT AUTO_INCREMENT NOT NULL,
  Customer_ID INT NOT NULL,
  Order_Date  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (Order_ID),
  FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID) ON UPDATE CASCADE ON DELETE RESTRICT
) ;

-- Order Items (for each order, store the sold quantity of a given book)
CREATE TABLE IF NOT EXISTS Sale_Order_Items (
  Order_ID   INT NOT NULL,
  Book_ID    INT NOT NULL,
  Quantity   INT NOT NULL,
  Unit_Price INT NOT NULL,
  PRIMARY KEY (Order_ID, Book_ID),
  FOREIGN KEY (Order_ID) REFERENCES Sale_Order(Order_ID) ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (Book_ID)  REFERENCES Book(Book_ID) ON UPDATE CASCADE ON DELETE RESTRICT
) ;

/* ============================================================
   User Interaction
   ============================================================ */

-- Wishlist
CREATE TABLE IF NOT EXISTS Wishlist (
  Customer_ID INT NOT NULL,
  Book_ID     INT NOT NULL,
  Added_At    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (Customer_ID, Book_ID),
  FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID) ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (Book_ID)     REFERENCES Book(Book_ID) ON UPDATE CASCADE ON DELETE RESTRICT
) ;

-- Surveys
CREATE TABLE IF NOT EXISTS Survey (
  Survey_ID     INT AUTO_INCREMENT NOT NULL,
  Order_ID      INT, -- this can be null in the case of a survey that's not linked to an order
  Sent_At_Date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (Survey_ID),
  FOREIGN KEY (Order_ID)    REFERENCES Sale_Order(Order_ID) ON UPDATE CASCADE ON DELETE RESTRICT
) ;

CREATE TABLE IF NOT EXISTS Survey_Response (
Survey_ID     INT AUTO_INCREMENT NOT NULL,
Customer_ID   INT NOT NULL,  
Rating        TINYINT NOT NULL,
Comments      VARCHAR(255),
Response_Date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
Primary KEY (Survey_ID, Customer_ID),
FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID) ON UPDATE CASCADE ON DELETE RESTRICT
) ;


/* ------------------------------------------------------------
   1) REFERENCE DATA: Publishers, Genres, Formats
   ------------------------------------------------------------ */

INSERT INTO Publisher (Publisher_ID, Publisher_Name) VALUES
(1, 'Penguin Random House'),
(2, 'HarperCollins'),
(3, 'Simon & Schuster'),
(4, 'O’Reilly Media'),
(5, 'No Starch Press'),
(6, 'Oxford University Press'),
(7, 'Pearson Education'),
(8, 'Hachette Book Group'),
(9, 'Macmillan'),
(10, 'Scholastic');

INSERT INTO Genre (Genre_ID, Genre_Name) VALUES
(1, 'Fiction'),
(2, 'Non-Fiction'),
(3, 'Science'),
(4, 'Technology'),
(5, 'Business'),
(6, 'Fantasy'),
(7, 'Mystery'),
(8, 'Romance'),
(9, 'Biography'),
(10, 'History');

INSERT INTO Book_Format (Format_ID, Format_Name) VALUES
(1, 'Hardcover'),
(2, 'Paperback'),
(3, 'eBook'),
(4, 'Audiobook');

/* ------------------------------------------------------------
   2) AUTHORS (40)
   ------------------------------------------------------------ */
INSERT INTO Author (Author_ID, Author_FirstName, Author_LastName) VALUES
(1,'George','Orwell'),
(2,'Harper','Lee'),
(3,'J.K.','Rowling'),
(4,'Yuval','Harari'),
(5,'Robert','Martin'),
(6,'Martin','Fowler'),
(7,'Paul','Barry'),
(8,'Eric','Matthes'),
(9,'Stephen','King'),
(10,'Jane','Austen'),
(11,'Mark','Twain'),
(12,'Ernest','Hemingway'),
(13,'Agatha','Christie'),
(14,'Dan','Brown'),
(15,'Neil','Gaiman'),
(16,'John','Grisham'),
(17,'J.R.R.','Tolkien'),
(18,'Isaac','Asimov'),
(19,'Arthur','Clarke'),
(20,'C.S.','Lewis'),
(21,'Michael','Crichton'),
(22,'Douglas','Adams'),
(23,'Philip','Dick'),
(24,'Suzanne','Collins'),
(25,'James','Patterson'),
(26,'Margaret','Atwood'),
(27,'Paulo','Coelho'),
(28,'Stephen','Hawking'),
(29,'Walter','Isaacson'),
(30,'Brandon','Sanderson'),
(31,'Rick','Riordan'),
(32,'Colleen','Hoover'),
(33,'Malcolm','Gladwell'),
(34,'Michelle','Obama'),
(35,'Tara','Westover'),
(36,'Andy','Weir'),
(37,'Delia','Owens'),
(38,'Anthony','Doerr'),
(39,'Gillian','Flynn'),
(40,'Sally','Rooney');

/* ------------------------------------------------------------
   3) BOOKS (50) — cycle publishers/genres/formats
   ISBNs are unique placeholders 97800000000xx (13 chars)
   ------------------------------------------------------------ */
INSERT INTO Book
(Book_ID, ISBN, Publisher_ID, Genre_ID, Format_ID, Title, Edition, Price, Stock)
VALUES
(1 ,'9780000000001', 1,1,2, 'Book Title 01','1st', 12.99, 60),
(2 ,'9780000000002', 2,2,1, 'Book Title 02','1st', 14.99, 55),
(3 ,'9780000000003', 3,3,2, 'Book Title 03','2nd', 16.49, 40),
(4 ,'9780000000004', 4,4,3, 'Book Title 04','1st', 29.99, 25),
(5 ,'9780000000005', 5,4,1, 'Book Title 05','1st', 34.00, 20),
(6 ,'9780000000006', 6,5,2, 'Book Title 06','1st', 18.99, 50),
(7 ,'9780000000007', 7,6,1, 'Book Title 07','3rd', 22.00, 35),
(8 ,'9780000000008', 8,7,2, 'Book Title 08','1st', 17.99, 45),
(9 ,'9780000000009', 9,8,4, 'Book Title 09','1st', 15.99, 30),
(10,'9780000000010',10,9,2, 'Book Title 10','2nd', 19.99, 38),
(11,'9780000000011', 1,10,1, 'Book Title 11','1st', 23.99, 26),
(12,'9780000000012', 2,1,2,  'Book Title 12','1st', 11.99, 48),
(13,'9780000000013', 3,2,3,  'Book Title 13','1st', 27.99, 22),
(14,'9780000000014', 4,3,4,  'Book Title 14','1st', 21.99, 33),
(15,'9780000000015', 5,4,2,  'Book Title 15','2nd', 31.99, 20),
(16,'9780000000016', 6,5,3,  'Book Title 16','1st', 24.99, 28),
(17,'9780000000017', 7,6,4,  'Book Title 17','1st', 20.99, 32),
(18,'9780000000018', 8,7,1,  'Book Title 18','1st', 12.50, 60),
(19,'9780000000019', 9,8,2,  'Book Title 19','1st', 13.50, 57),
(20,'9780000000020',10,9,3,  'Book Title 20','1st', 26.00, 24),
(21,'9780000000021', 1,10,4, 'Book Title 21','1st', 22.50, 29),
(22,'9780000000022', 2,1,1,  'Book Title 22','2nd', 18.50, 35),
(23,'9780000000023', 3,2,2,  'Book Title 23','1st', 14.00, 42),
(24,'9780000000024', 4,3,3,  'Book Title 24','1st', 28.00, 18),
(25,'9780000000025', 5,4,4,  'Book Title 25','1st', 32.00, 21),
(26,'9780000000026', 6,5,1,  'Book Title 26','1st', 16.99, 50),
(27,'9780000000027', 7,6,2,  'Book Title 27','1st', 19.50, 44),
(28,'9780000000028', 8,7,3,  'Book Title 28','1st', 25.00, 20),
(29,'9780000000029', 9,8,4,  'Book Title 29','1st', 21.00, 27),
(30,'9780000000030',10,9,1,  'Book Title 30','1st', 13.99, 55),
(31,'9780000000031', 1,10,2, 'Book Title 31','1st', 17.49, 47),
(32,'9780000000032', 2,1,3,  'Book Title 32','2nd', 29.49, 19),
(33,'9780000000033', 3,2,4,  'Book Title 33','1st', 24.49, 23),
(34,'9780000000034', 4,3,1,  'Book Title 34','1st', 26.49, 22),
(35,'9780000000035', 5,4,2,  'Book Title 35','1st', 34.49, 18),
(36,'9780000000036', 6,5,3,  'Book Title 36','1st', 15.99, 52),
(37,'9780000000037', 7,6,4,  'Book Title 37','1st', 22.99, 31),
(38,'9780000000038', 8,7,1,  'Book Title 38','1st', 27.99, 17),
(39,'9780000000039', 9,8,2,  'Book Title 39','1st', 19.49, 36),
(40,'9780000000040',10,9,3,  'Book Title 40','1st', 23.49, 28),
(41,'9780000000041', 1,10,4, 'Book Title 41','1st', 25.49, 21),
(42,'9780000000042', 2,1,1,  'Book Title 42','1st', 14.49, 49),
(43,'9780000000043', 3,2,2,  'Book Title 43','1st', 12.49, 58),
(44,'9780000000044', 4,3,3,  'Book Title 44','1st', 31.49, 16),
(45,'9780000000045', 5,4,4,  'Book Title 45','1st', 33.49, 19),
(46,'9780000000046', 6,5,1,  'Book Title 46','1st', 21.49, 30),
(47,'9780000000047', 7,6,2,  'Book Title 47','1st', 18.49, 38),
(48,'9780000000048', 8,7,3,  'Book Title 48','1st', 29.99, 14),
(49,'9780000000049', 9,8,4,  'Book Title 49','1st', 27.49, 20),
(50,'9780000000050',10,9,1,  'Book Title 50','1st', 16.49, 41);

/* ------------------------------------------------------------
   4) AUTHORS_BOOKS (map every book to at least one author)
   Simple pattern + a few multi-author examples
   ------------------------------------------------------------ */
-- One main author per book (Author_ID cycles 1..40)
INSERT INTO Authors_Books (Author_ID, Book_ID) VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),
(6,6),(7,7),(8,8),(9,9),(10,10),
(11,11),(12,12),(13,13),(14,14),(15,15),
(16,16),(17,17),(18,18),(19,19),(20,20),
(21,21),(22,22),(23,23),(24,24),(25,25),
(26,26),(27,27),(28,28),(29,29),(30,30),
(31,31),(32,32),(33,33),(34,34),(35,35),
(36,36),(37,37),(38,38),(39,39),(40,40),
(1,41),(2,42),(3,43),(4,44),(5,45),
(6,46),(7,47),(8,48),(9,49),(10,50);

-- A few co-authored books
INSERT INTO Authors_Books (Author_ID, Book_ID) VALUES
(11,3), (12,10), (13,15), (14,20), (15,25),
(16,30), (17,35), (18,40), (19,45), (20,50);

/* ------------------------------------------------------------
   5) CUSTOMERS (100)
   ------------------------------------------------------------ */
INSERT INTO Customer
(Customer_ID, Customer_FirstName, Customer_LastName, Email, Phone) VALUES
(1,'Alice','Johnson','alice.johnson@example.com','+1555000001'),
(2,'Bob','Smith','bob.smith@example.com','+1555000002'),
(3,'Carol','Davis','carol.davis@example.com','+1555000003'),
(4,'David','Wilson','david.wilson@example.com','+1555000004'),
(5,'Emma','Brown','emma.brown@example.com','+1555000005'),
(6,'Frank','Garcia','frank.garcia@example.com','+1555000006'),
(7,'Grace','Martinez','grace.martinez@example.com','+1555000007'),
(8,'Henry','Lopez','henry.lopez@example.com','+1555000008'),
(9,'Isabella','Anderson','isabella.anderson@example.com','+1555000009'),
(10,'Jack','Thomas','jack.thomas@example.com','+1555000010'),
(11,'Katherine','Taylor','katherine.taylor@example.com','+1555000011'),
(12,'Liam','Moore','liam.moore@example.com','+1555000012'),
(13,'Mia','Jackson','mia.jackson@example.com','+1555000013'),
(14,'Noah','Martin','noah.martin@example.com','+1555000014'),
(15,'Olivia','Lee','olivia.lee@example.com','+1555000015'),
(16,'Paul','Perez','paul.perez@example.com','+1555000016'),
(17,'Quinn','White','quinn.white@example.com','+1555000017'),
(18,'Ryan','Harris','ryan.harris@example.com','+1555000018'),
(19,'Sophia','Clark','sophia.clark@example.com','+1555000019'),
(20,'Thomas','Lewis','thomas.lewis@example.com','+1555000020'),
(21,'Uma','Robinson','uma.robinson@example.com','+1555000021'),
(22,'Victor','Walker','victor.walker@example.com','+1555000022'),
(23,'Wendy','Young','wendy.young@example.com','+1555000023'),
(24,'Xavier','Allen','xavier.allen@example.com','+1555000024'),
(25,'Yara','King','yara.king@example.com','+1555000025'),
(26,'Zach','Wright','zach.wright@example.com','+1555000026'),
(27,'Aiden','Scott','aiden.scott@example.com','+1555000027'),
(28,'Bella','Torres','bella.torres@example.com','+1555000028'),
(29,'Caleb','Nguyen','caleb.nguyen@example.com','+1555000029'),
(30,'Diana','Hill','diana.hill@example.com','+1555000030'),
(31,'Ethan','Flores','ethan.flores@example.com','+1555000031'),
(32,'Fiona','Green','fiona.green@example.com','+1555000032'),
(33,'Gavin','Adams','gavin.adams@example.com','+1555000033'),
(34,'Hannah','Nelson','hannah.nelson@example.com','+1555000034'),
(35,'Ian','Baker','ian.baker@example.com','+1555000035'),
(36,'Julia','Hall','julia.hall@example.com','+1555000036'),
(37,'Kyle','Rivera','kyle.rivera@example.com','+1555000037'),
(38,'Lara','Campbell','lara.campbell@example.com','+1555000038'),
(39,'Mason','Mitchell','mason.mitchell@example.com','+1555000039'),
(40,'Nina','Carter','nina.carter@example.com','+1555000040'),
(41,'Owen','Roberts','owen.roberts@example.com','+1555000041'),
(42,'Piper','Gomez','piper.gomez@example.com','+1555000042'),
(43,'Reid','Phillips','reid.phillips@example.com','+1555000043'),
(44,'Sara','Evans','sara.evans@example.com','+1555000044'),
(45,'Troy','Turner','troy.turner@example.com','+1555000045'),
(46,'Ulrich','Diaz','ulrich.diaz@example.com','+1555000046'),
(47,'Vera','Parker','vera.parker@example.com','+1555000047'),
(48,'Wes','Cruz','wes.cruz@example.com','+1555000048'),
(49,'Yvonne','Edwards','yvonne.edwards@example.com','+1555000049'),
(50,'Zoe','Collins','zoe.collins@example.com','+1555000050'),
(51,'Aaron','Stewart','aaron.stewart@example.com','+1555000051'),
(52,'Bailey','Morris','bailey.morris@example.com','+1555000052'),
(53,'Chloe','Rogers','chloe.rogers@example.com','+1555000053'),
(54,'Derek','Reed','derek.reed@example.com','+1555000054'),
(55,'Elena','Cook','elena.cook@example.com','+1555000055'),
(56,'Felix','Morgan','felix.morgan@example.com','+1555000056'),
(57,'Gianna','Bell','gianna.bell@example.com','+1555000057'),
(58,'Hudson','Murphy','hudson.murphy@example.com','+1555000058'),
(59,'Ivy','Bailey','ivy.bailey@example.com','+1555000059'),
(60,'Jonah','Rivera','jonah.rivera@example.com','+1555000060'),
(61,'Kayla','Cooper','kayla.cooper@example.com','+1555000061'),
(62,'Logan','Richardson','logan.richardson@example.com','+1555000062'),
(63,'Megan','Cox','megan.cox@example.com','+1555000063'),
(64,'Nolan','Howard','nolan.howard@example.com','+1555000064'),
(65,'Olive','Ward','olive.ward@example.com','+1555000065'),
(66,'Peter','Peterson','peter.peterson@example.com','+1555000066'),
(67,'Queenie','Gray','queenie.gray@example.com','+1555000067'),
(68,'Riley','James','riley.james@example.com','+1555000068'),
(69,'Scarlett','Watson','scarlett.watson@example.com','+1555000069'),
(70,'Tristan','Brooks','tristan.brooks@example.com','+1555000070'),
(71,'Ulysses','Kelly','ulysses.kelly@example.com','+1555000071'),
(72,'Valerie','Sanders','valerie.sanders@example.com','+1555000072'),
(73,'Willa','Price','willa.price@example.com','+1555000073'),
(74,'Ximena','Bennett','ximena.bennett@example.com','+1555000074'),
(75,'Yosef','Wood','yosef.wood@example.com','+1555000075'),
(76,'Zara','Barnes','zara.barnes@example.com','+1555000076'),
(77,'Abel','Ross','abel.ross@example.com','+1555000077'),
(78,'Brianna','Henderson','brianna.henderson@example.com','+1555000078'),
(79,'Carter','Coleman','carter.coleman@example.com','+1555000079'),
(80,'Daisy','Jenkins','daisy.jenkins@example.com','+1555000080'),
(81,'Easton','Perry','easton.perry@example.com','+1555000081'),
(82,'Faith','Powell','faith.powell@example.com','+1555000082'),
(83,'Gage','Long','gage.long@example.com','+1555000083'),
(84,'Heidi','Patterson','heidi.patterson@example.com','+1555000084'),
(85,'Iris','Hughes','iris.hughes@example.com','+1555000085'),
(86,'Jasper','Flores','jasper.flores@example.com','+1555000086'),
(87,'Keira','Washington','keira.washington@example.com','+1555000087'),
(88,'Lukas','Butler','lukas.butler@example.com','+1555000088'),
(89,'Macy','Simmons','macy.simmons@example.com','+1555000089'),
(90,'Nate','Foster','nate.foster@example.com','+1555000090'),
(91,'Ophelia','Gonzalez','ophelia.gonzalez@example.com','+1555000091'),
(92,'Parker','Bryant','parker.bryant@example.com','+1555000092'),
(93,'Quincy','Alexander','quincy.alexander@example.com','+1555000093'),
(94,'Raelynn','Russell','raelynn.russell@example.com','+1555000094'),
(95,'Silas','Griffin','silas.griffin@example.com','+1555000095'),
(96,'Tessa','Hayes','tessa.hayes@example.com','+1555000096'),
(97,'Uriel','Myers','uriel.myers@example.com','+1555000097'),
(98,'Vivian','Ford','vivian.ford@example.com','+1555000098'),
(99,'Wyatt','Hamilton','wyatt.hamilton@example.com','+1555000099'),
(100,'Zion','Graham','zion.graham@example.com','+1555000100');

/* ------------------------------------------------------------
   6) ORDERS (80) — spread across customers
   ------------------------------------------------------------ */
INSERT INTO Sale_Order (Order_ID, Customer_ID, Order_Date) VALUES
(1001, 1, '2025-09-28 10:00:00'),
(1002, 2, '2025-09-20 11:00:00'),
(1003, 3, '2025-09-20 12:00:00'),
(1004, 4, '2025-09-20 13:00:00'),
(1005, 5, '2025-09-21 09:30:00'),
(1006, 6, '2025-09-21 10:30:00'),
(1007, 7, '2025-09-21 11:30:00'),
(1008, 8, '2025-09-21 12:30:00'),
(1009, 9, '2025-09-22 08:45:00'),
(1010,10, '2025-09-22 09:15:00'),
(1011,11, '2025-09-22 10:15:00'),
(1012,12, '2025-09-22 11:15:00'),
(1013,13, '2025-09-23 14:05:00'),
(1014,14, '2025-09-23 14:35:00'),
(1015,15, '2025-09-23 15:05:00'),
(1016,16, '2025-09-23 15:35:00'),
(1017,17, '2025-09-24 10:10:00'),
(1018,18, '2025-09-24 10:40:00'),
(1019,19, '2025-09-24 11:10:00'),
(1020,20, '2025-09-24 11:40:00'),
(1021,21, '2025-09-25 09:00:00'),
(1022,22, '2025-09-25 09:30:00'),
(1023,23, '2025-09-25 10:00:00'),
(1024,24, '2025-09-25 10:30:00'),
(1025,25, '2025-09-26 13:10:00'),
(1026,26, '2025-09-26 13:40:00'),
(1027,27, '2025-09-26 14:10:00'),
(1028,28, '2025-09-26 14:40:00'),
(1029,29, '2025-09-27 09:00:00'),
(1030,30, '2025-09-27 09:30:00'),
(1031,31, '2025-09-27 10:00:00'),
(1032,32, '2025-09-27 10:30:00'),
(1033,33, '2025-09-28 11:00:00'),
(1034,34, '2025-09-28 11:30:00'),
(1035,35, '2025-09-28 12:00:00'),
(1036,36, '2025-09-28 12:30:00'),
(1037,37, '2025-09-29 15:00:00'),
(1038,38, '2025-09-29 15:30:00'),
(1039,39, '2025-09-29 16:00:00'),
(1040,40, '2025-09-29 16:30:00'),
(1041,41, '2025-09-30 09:00:00'),
(1042,42, '2025-09-30 09:30:00'),
(1043,43, '2025-09-30 10:00:00'),
(1044,44, '2025-09-30 10:30:00'),
(1045,45, '2025-10-01 11:00:00'),
(1046,46, '2025-10-01 11:30:00'),
(1047,47, '2025-10-01 12:00:00'),
(1048,48, '2025-10-01 12:30:00'),
(1049,49, '2025-10-02 08:50:00'),
(1050,50, '2025-10-02 09:20:00'),
(1051,51, '2025-10-02 09:50:00'),
(1052,52, '2025-10-02 10:20:00'),
(1053,53, '2025-10-03 10:00:00'),
(1054,54, '2025-10-03 10:30:00'),
(1055,55, '2025-10-03 11:00:00'),
(1056,56, '2025-10-03 11:30:00'),
(1057,57, '2025-10-04 13:00:00'),
(1058,58, '2025-10-04 13:30:00'),
(1059,59, '2025-10-04 14:00:00'),
(1060,60, '2025-10-04 14:30:00'),
(1061,61, '2025-10-05 09:00:00'),
(1062,62, '2025-10-05 09:30:00'),
(1063,63, '2025-10-05 10:00:00'),
(1064,64, '2025-10-05 10:30:00'),
(1065,65, '2025-10-06 11:00:00'),
(1066,66, '2025-10-06 11:30:00'),
(1067,67, '2025-10-06 12:00:00'),
(1068,68, '2025-10-06 12:30:00'),
(1069,69, '2025-10-07 15:00:00'),
(1070,70, '2025-10-07 15:30:00'),
(1071,71, '2025-10-07 16:00:00'),
(1072,72, '2025-10-07 16:30:00'),
(1073,73, '2025-10-08 09:00:00'),
(1074,74, '2025-10-08 09:30:00'),
(1075,75, '2025-10-08 10:00:00'),
(1076,76, '2025-10-08 10:30:00'),
(1077,77, '2025-10-09 13:00:00'),
(1078,78, '2025-10-09 13:30:00'),
(1079,79, '2025-10-09 14:00:00'),
(1080,80, '2025-10-09 14:30:00');

/* ------------------------------------------------------------
   7) ORDER ITEMS (~140) — 1–3 items per order
   (Unit_Price is INT in your schema)
   ------------------------------------------------------------ */
INSERT INTO Sale_Order_Items (Order_ID, Book_ID, Quantity, Unit_Price) VALUES
(1001,1,1,13),
(1001,5,1,32),
(1001,8,3,30),
(1002,3,1,19),
(1002,5,1,32),
(1003,8,2,30),
(1004,9,1,16),
(1004,10,1,20),
(1005,11,1,24),
(1006,12,1,12),
(1006,13,1,28),
(1007,14,4,22),
(1007,20,1,28), 
(1008,22,1,18),
(1008,15,3,32),
(1009,16,3,25),
(1010,17,1,21),
(1011,18,1,13),
(1011,19,1,14),
(1012,20,1,26),
(1012,31,1,17), 
(1013,33,1,24),  
(1014,35,1,34),  
(1014,22,6,18),
(1015,36,1,16),  
(1015,24,1,28),
(1016,37,1,23), 
(1017,38,1,28), 
(1017,26,1,17),
(1018,39,1,19),
(1019,40,1,23), 
(1019,28,1,25),
(1020,41,1,25),  
(1021,31,8,17),
(1022,32,1,29),
(1023,33,2,24),
(1023,34,1,26),
(1024,45,1,33),
(1025,46,1,21),
(1026,47,1,18),
(1027,48,1,30),
(1028,49,1,27),
(1029,50,1,16),
(1030,1,1,13),
(1030,42,1,14),
(1031,43,1,12),
(1032,44,6,31),
(1033,45,1,33),
(1034,46,1,21),
(1035,47,8,18),
(1036,48,1,30),
(1037,49,2,27),
(1038,50,1,16),
(1039,1,1,13),
(1040,2,1,15),
(1041,3,4,19),
(1042,4,1,30),
(1042,5,1,34),
(1043,6,2,19),
(1044,7,2,22),
(1045,8,1,18),
(1046,9,11,16),
(1047,10,2,20),
(1048,11,1,24),
(1049,12,1,12),
(1050,13,3,28),
(1050,14,1,22),
(1051,15,2,32),
(1052,16,3,25),
(1053,17,1,21),
(1054,18,4,13),
(1055,19,1,14),
(1056,20,5,26),
(1057,21,8,23),
(1057,22,1,18),
(1058,23,14,14),
(1059,24,1,28),
(1060,25,1,32),
(1061,26,3,17),
(1062,27,1,20),
(1063,28,1,25),
(1064,29,4,21),
(1065,30,1,14),
(1066,31,1,17),
(1066,32,1,29),
(1067,33,1,24),
(1068,34,5,26),
(1069,35,1,34),
(1070,36,1,16),
(1071,37,10,23),
(1072,38,1,28),
(1073,39,1,19),
(1074,40,11,23),
(1075,41,1,25),
(1076,42,5,14),
(1077,43,1,12),
(1078,44,2,31),
(1079,45,3,33),
(1080,46,1,21);

/* ------------------------------------------------------------
   8) WISHLIST (50 entries)
   ------------------------------------------------------------ */
INSERT INTO Wishlist (Customer_ID, Book_ID, Added_At) VALUES
(1,1,'2025-09-28 07:00:00'),
(1,2,'2025-09-27 10:00:00'),
(1,3,'2025-09-27 09:00:00'),
(1,4,'2025-09-27 08:30:00'),
(1,5,'2025-09-26 15:00:00'),
(1,8,'2025-09-26 18:00:00'),
(2,5,'2025-09-18 10:00:00'),
(3,7,'2025-09-19 12:00:00'),
(4,9,'2025-09-18 13:00:00'),
(5,12,'2025-09-21 07:00:00'),
(6,15,'2025-09-19 10:00:00'),
(7,20,'2025-09-23 10:30:00'),
(8,22,'2025-09-24 11:00:00'),
(9,16,'2025-09-21 11:30:00'),
(10,28,'2025-09-22 06:45:00'),
(11,18,'2025-09-20 09:00:00'),
(11,19,'2025-09-20 09:05:00'),
(12,31,'2025-09-22 09:45:00'),
(13,33,'2025-09-20 09:30:00'),
(14,35,'2025-09-21 09:45:00'),
(15,36,'2025-09-22 10:00:00'),
(16,37,'2025-09-20 10:15:00'),
(17,38,'2025-09-22 10:30:00'),
(18,39,'2025-09-21 10:45:00'),
(19,40,'2025-09-22 11:00:00'),
(20,41,'2025-09-24 09:00:00'),
(21,42,'2025-09-23 11:30:00'),
(22,43,'2025-09-23 11:45:00'),
(23,44,'2025-09-24 12:00:00'),
(24,45,'2025-09-23 12:15:00'),
(25,46,'2025-09-24 12:30:00'),
(26,47,'2025-09-23 12:45:00'),
(27,48,'2025-09-24 13:00:00'),
(28,49,'2025-09-25 13:15:00'),
(29,50,'2025-09-24 13:30:00'),
(30,1,'2025-09-24 13:45:00'),
(31,2,'2025-09-24 14:00:00'),
(32,44,'2025-09-24 14:15:00'),
(33,4,'2025-09-24 14:30:00'),
(34,5,'2025-09-24 14:45:00'),
(35,6,'2025-09-24 15:00:00'),
(36,7,'2025-09-24 15:15:00'),
(37,8,'2025-09-24 15:30:00'),
(38,9,'2025-09-24 15:45:00'),
(39,10,'2025-09-24 16:00:00'),
(40,11,'2025-09-24 16:15:00'),
(41,12,'2025-09-24 16:30:00'),
(42,13,'2025-09-24 16:45:00'),
(43,14,'2025-09-24 17:00:00'),
(44,15,'2025-09-24 17:15:00'),
(45,16,'2025-09-24 17:30:00'),
(46,17,'2025-09-24 17:45:00'),
(47,18,'2025-09-24 18:00:00'),
(48,19,'2025-09-24 18:15:00'),
(49,12,'2025-09-24 18:30:00'),
(50,21,'2025-09-24 18:45:00');

/* ------------------------------------------------------------
   9) SURVEYS (20) — some linked to orders
   ------------------------------------------------------------ */
INSERT INTO Survey (Survey_ID, Order_ID, Sent_At_Date) VALUES
(1,1001,'2025-10-01 09:00:00'),
(2,1002,'2025-10-01 09:05:00'),
(3,1005,'2025-10-01 09:10:00'),
(4,1010,'2025-10-01 09:15:00'),
(5,1015,'2025-10-01 09:20:00'),
(6,1020,'2025-10-01 09:25:00'),
(7,1025,'2025-10-01 09:30:00'),
(8,1030,'2025-10-01 09:35:00'),
(9,1035,'2025-10-01 09:40:00'),
(10,1040,'2025-10-01 09:45:00'),
(11,NULL,'2025-10-02 10:00:00'),
(12,NULL,'2025-10-02 10:05:00'),
(13,NULL,'2025-10-02 10:10:00'),
(14,NULL,'2025-10-02 10:15:00'),
(15,NULL,'2025-10-02 10:20:00'),
(16,1045,'2025-10-03 11:00:00'),
(17,1050,'2025-10-03 11:05:00'),
(18,1055,'2025-10-03 11:10:00'),
(19,1060,'2025-10-03 11:15:00'),
(20,1070,'2025-10-03 11:20:00');

/* ------------------------------------------------------------
   10) SURVEY RESPONSES (20)
   Note: Your schema auto-increments Survey_Response.Survey_ID independently.
   We insert explicit IDs for clarity; they need not match Survey.Survey_ID.
   ------------------------------------------------------------ */
INSERT INTO Survey_Response (Survey_ID, Customer_ID, Rating, Comments, Response_Date) VALUES
(3001,1,5,'Great service and fast delivery.','2025-10-02 10:00:00'),
(3002,2,4,'Website was easy to use.','2025-10-02 10:10:00'),
(3003,3,3,'Delivery took a bit longer.','2025-10-02 10:20:00'),
(3004,4,5,'Site was very pleasant   .','2025-10-02 10:30:00'),
(3005,5,4,'Customer support was helpful.','2025-10-02 10:40:00'),
(3006,6,5,'Very satisfied overall.','2025-10-03 09:00:00'),
(3007,7,2,'Payment failed once, then worked.','2025-10-03 09:10:00'),
(3008,8,4,'Packaging was neat and safe.','2025-10-03 09:20:00'),
(3009,9,5,'Loved the quick pickup.','2025-10-03 09:30:00'),
(3010,10,3,'It was okay.','2025-10-03 09:40:00'),
(3011,11,4,'Good communication via email.','2025-10-03 10:00:00'),
(3012,12,5,'Super fast refund on a return.','2025-10-03 10:10:00'),
(3013,13,4,'Good website.','2025-10-03 10:20:00'),
(3014,14,5,'Will definitely buy again.','2025-10-03 10:30:00'),
(3015,15,2,'Site was slow at checkout.','2025-10-03 10:40:00'),
(3016,16,4,'Clear order tracking.','2025-10-03 11:00:00'),
(3017,17,5,'All good from end to end.','2025-10-03 11:10:00'),
(3018,18,3,'Average experience.','2025-10-03 11:20:00'),
(3019,19,4,'Delivery guy was polite.','2025-10-03 11:30:00'),
(3020,20,5,'Couldn’t be happier.','2025-10-03 11:40:00');


