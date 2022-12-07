/*
00.Create Database
*/

CREATE DATABASE `minions`;
USE `minions`;

/*
01.Create Tables 
*/

CREATE TABLE `minions`(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50),
age INT 
); 

CREATE TABLE `towns`(
town_id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50)
);

/*
02.Alter Minions Table 
*/

ALTER TABLE `minions`
ADD COLUMN `town_id` INT;

ALTER TABLE `minions`
ADD CONSTRAINT `fk_minions_towns`
  FOREIGN KEY `minions` (`town_id`)
  REFERENCES `towns` (`id`);

/*
03.Insert Records in Both Tables
*/

INSERT INTO `towns` (`id`, `name`)
VALUES
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna');
  
INSERT INTO `minions` (`id`, `name`, `age`, `town_id`)
VALUES
(1, 'Kevin', 22, 1),
(2, 'Bob', 15, 3),
(3, 'Steward', NULL, 2);

/*
04.Truncate Table Minions
*/

TRUNCATE TABLE `minions`;

/*
05.Drop All Tables
*/

DROP TABLE `minions`;
DROP TABLE `towns`;

/*
06.Create Table People
*/

CREATE TABLE `people` (
`id` INT PRIMARY KEY AUTO_INCREMENT, 
`name` VARCHAR(200) NOT NULL,
`picture` BLOB,
`height` DOUBLE(3, 2),
`weight` DOUBLE(5, 2),
`gender` CHAR(1) NOT NULL,
`birthdate` DATE NOT NULL,
`biography` TEXT	 
);

INSERT INTO `people` (`id`,`name`, `height`, `weight`, `gender`, `birthdate`, `biography`)
VALUES 
(548, 'John Johnson', 1.84, 90.00, 'm', '1963-08-10', 'hhhhhhhhhhhhhhhkjljhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhljhl' ),
(789, 'Lisi McDonalds', 1.84, 45.30, 'f', '1983-10-23', 'hhhhhhhhhhhhhhhkjljhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhljhl' ),
(235, 'Rob Johnson', 1.75, 78.00, 'm', '1972-06-15', 'hhhhhhhhhhhhhhhkjljhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhljhl' ),
(115, 'Peter Peterson', 1.80, 95.60, 'm', '1969-02-25', 'hhhhhhhhhhhhhhhkjljhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhljhl' ),
(248, 'John Johnson', 1.93, 100.10, 'm', '1990-04-10', 'hhhhhhhhhhhhhhhkjljhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhljhl' );

/*
07.Create Table Users
*/

CREATE TABLE `users` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`username` VARCHAR(30) NOT NULL,
`password` VARCHAR(26) NOT NULL,
`profile_picture` BLOB,
`last_Login_time` TIME,
`is_deleted` BOOLEAN);

INSERT INTO `users` (`username`, `password`, `last_login_time`, `is_deleted`)
VALUES
('John Johnson', 'Password', '10:54:30', false),
('Lisa Peterson', 'Password1', '22:24:38', false),
('Richard Cridon', 'Password2', '09:54:53', true),
('Manfred Tree', 'Password3', '10:54:11', false),
('Elizabeth Johnson', 'Password4', '07:54:40', true);

/*
08.Change Primary Key
*/

ALTER TABLE `users`
DROP PRIMARY KEY,
ADD CONSTRAINT `pk_users`
PRIMARY KEY `users` (`id`, `username`);

/*
09.Set Default Value of a Field
*/

ALTER TABLE `users`
MODIFY COLUMN `last_login_time` DATETIME DEFAULT NOW();

/*
10.Set Unique Field
*/

ALTER TABLE `users` 
DROP PRIMARY KEY,
ADD CONSTRAINT `pk_users`
PRIMARY KEY(`id`);

ALTER TABLE `users`
MODIFY COLUMN `username` VARCHAR(50) UNIQUE;

/*
11.Movies Database
*/

CREATE SCHEMA movies;
USE `movies`;

CREATE TABLE `directors` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`director_name` VARCHAR(30) NOT NULL,
`notes` TEXT 
);

INSERT INTO `directors` (`id`, `director_name`, `notes`)
VALUES
(1, 'Steven Spielburg', 'mkmmmmmmmmmmkkmmkvdfhfgsdg'),
(2, 'Uwe Boll', 'hfdjhgjahfgjkafhfdajklghjdfaklghjf'),
(3, 'Katrin Bigalow', 'hafdadfdsafadfsddgdadgdadgfd'),
(4, 'Jonh Filip', 'hdahkflhDJKLFHDJKFHJKADSHJFKASDA'),
(5, 'Miels Hoston', 'hhkflhDJKLFHDJKFHJKADSHJFKASDA');

CREATE TABLE `genres` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`genre_name` VARCHAR(30) NOT NULL,
`notes` TEXT
);

INSERT INTO `genres` (`id`, `genre_name`)
VALUES 
(1, 'Horror'),
(2, 'Action'),
(3, 'Comedy'),
(4, 'Drama'),
(5, 'Thriller');

CREATE TABLE `categories` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`category_name` VARCHAR(30) NOT NULL,
`notes` TEXT
 );

INSERT INTO `categories` (`id`, `category_name`)
VALUES
(1, 'Test_Category1'),
(2, 'Test_Category2'),
(3, 'Test_Category3'),
(4, 'Test_Category4'),
(5, 'Test_Category5');

CREATE TABLE `movies` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`title` VARCHAR(30) NOT NULL,
`director_id` INT,
`copyright_year` INT,
`length` INT,
`genre_id` INT,
`category_id` INT,
`rating` DOUBLE,
`notes` TEXT
);

INSERT INTO `movies` (`title`)
VALUES
('Movie1'),
('Movie2'),
('Movie3'),
('Movie4'),
('Movie5');

/*
12.Car Rental Database
*/

CREATE SCHEMA car_rental;
USE `car_rental`;

CREATE TABLE `categories` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`category` VARCHAR(30) NOT NULL,
`daily_rate` DOUBLE,
`weekly_rate` DOUBLE,
`monthly_rate` DOUBLE,
`weekend_rate` DOUBLE
);

INSERT INTO `categories` (`category`) 
VALUES
('car'),
('SUV'),
('Truck');

CREATE TABLE `cars` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`plate_number` VARCHAR(30) NOT NULL,
`make` VARCHAR(30),
`model` VARCHAR(30),
`car_year` INT,
`category_id` INT,
`doors` INT,
`picture` BLOB,
`car_condion` VARCHAR(30),
`available` BOOLEAN
);

INSERT INTO `cars` (`plate_number`)
VALUES
('test_number1'),
('test_number2'),
('test_number3');

CREATE TABLE `employees`(
`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`first_name` VARCHAR(30) NOT NULL,
`last_name` VARCHAR(30) NOT NULL,
`title` VARCHAR(30),
`notes` TEXT
);

INSERT INTO `employees` (`first_name`, `last_name`)
VALUES
('Ivan', 'Ivanov'),
('Georgi', 'Georgiev'),
('Dancho', 'Cachev');

CREATE TABLE `customers` (
`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`driver_license_number` VARCHAR(20),
`full_name` VARCHAR(30),
`address` VARCHAR(50),
`city` VARCHAR(30),
`zip_code` VARCHAR(30),
`notes` TEXT  
);

INSERT INTO `customers` (`driver_license_number`, `full_name`)
VALUES 
('test_license1', 'Pencho Penchev'),
('test_license2', 'Dancho Danchev'),
('test_license3', 'Gencho Genchev');

CREATE TABLE `rental_orders` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`employee_id` INT,
`customer_id` INT,
`car_id` INT,
`car_condition` VARCHAR(30),
`tank_level` VARCHAR(30),
`kilometrage_start` INT,
`kilometrage_end` INT,
`total_kilometrage` INT,
`start_date` DATE,
`end_date` DATE,
`total_days` INT,
`rate_applied` DOUBLE,
`tax_rate` DOUBLE,
`order_status` VARCHAR(30),
`notes` TEXT
);

INSERT INTO	`rental_orders` (`employee_id`, `customer_id`)
VALUES
(1, 2),
(8, 9),
(7, 5);

/*
13.Basic Insert
*/

CREATE SCHEMA soft_uni;
USE `soft_uni`;

CREATE TABLE towns (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(20) NOT NULL
); 

/*submit only insert towns*/

INSERT INTO towns (`name`)
VALUES ('Sofia'), 
	   ('Plovdiv'), 
	   ('Varna'), 
	   ('Burgas');

CREATE TABLE addresses (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`address_text` VARCHAR(80) NOT NULL,
`town_id` INT NOT NULL
);

CREATE TABLE departments (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(20) NOT NULL
);

/*submit only insert departments*/

INSERT INTO departments (`name`)
VALUES ('Engineering'),
		('Sales'),
        ('Marketing'),
        ('Software Development'),
        ('Quality Assurance');

CREATE TABLE employees (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(20) NOT NULL,
`middle_name` VARCHAR(20),
`last_name` VARCHAR(20) NOT NULL,
`job_title` VARCHAR(20) NOT NULL,
`department_id` INT NOT NULL,
`hire_date` DATE NOT NULL,
`salary` DECIMAL NOT NULL,
`address_id` VARCHAR(80)
);

/*submit only insert employees*/

INSERT INTO employees (first_name, middle_name, last_name, job_title, department_id, hire_date, salary)
VALUES   ('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', '3500.00'),
		 ('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', '4000.00'),
		 ('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', '525.25'),
		 ('Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '2007-12-09', '3000.00'),
		 ('Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', '599.88');

/*
14.Basic Select All Fields
*/

SELECT *
FROM towns;

SELECT *
FROM departments;

SELECT *
FROM employees;

/*
15.Basic Select All Fields and Order Them
*/

SELECT *
FROM towns
ORDER BY name;

SELECT *
FROM departments
ORDER BY name;

SELECT *
FROM employees
ORDER BY salary DESC;

/*
16.Basic Select Some Fields
*/

SELECT name
FROM towns
ORDER BY name;

SELECT name
FROM departments
ORDER BY name;

SELECT first_name, last_name, job_title, salary
FROM employees
ORDER BY salary DESC;

/*
17.Increase Employees Salary
*/

UPDATE employees
SET salary = salary * 1.10;

SELECT salary
FROM employees;

/*
18.Delete All Records
*/

DELETE FROM occupancies;