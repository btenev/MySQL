/**/

/*
01.One-To-One Relationship
*/

CREATE TABLE `people` (
`person_id` INT PRIMARY KEY,
`first_name` VARCHAR(30),
`salary` DECIMAL(10,2) DEFAULT 0,
`passport_id` INT UNIQUE
);

INSERT INTO `people`
VALUES
(1, 'Roberto', 43300.00, 102),
(2, 'Tom', 56100.00, 103),
(3, 'Yana', 60200.00, 101);

CREATE TABLE `passports` (
`passport_id` INT PRIMARY KEY,
`passport_number` VARCHAR(30)
);

INSERT INTO `passports`
VALUES 
(101, 'N34FG21B'),
(102, 'K65LO4R7'),
(103, 'ZE657QP2');

ALTER TABLE `people`
ADD CONSTRAINT `fk_people_passports`
FOREIGN KEY (`passport_id`)
REFERENCES `passports`(`passport_id`);

/*
02.One-To-Many Relationship
*/

CREATE TABLE `manufacturers` (
`manufacturer_id` INT UNIQUE AUTO_INCREMENT,
`name` VARCHAR(30) NOT NULL,
`established_on` DATE
);

INSERT INTO `manufacturers`(`name`, `established_on`)
VALUES 
('BMW', '1916/03/01'),
('Tesla', '2003/01/01'),
('Lada', '1966/05/01');

CREATE TABLE `models` (
`model_id` INT UNIQUE AUTO_INCREMENT,
`name` VARCHAR(30) NOT NULL,
`manufacturer_id` INT
) AUTO_INCREMENT = 101;

INSERT INTO `models` (`name`, `manufacturer_id`)
VALUES 
('X1', 1),
('i6', 1),
('Model S', 2),
('Model X', 2),
('Model 3', 2),
('Nova', 3);

ALTER TABLE `manufacturers`
 ADD CONSTRAINT `pk_manufacturer`
 PRIMARY KEY (`manufacturer_id`);
 
ALTER TABLE `models`
 ADD CONSTRAINT `pk_model`
 PRIMARY KEY (`model_id`),
 ADD CONSTRAINT `fk_models_manufacturers`
 FOREIGN KEY (`manufacturer_id`)
 REFERENCES `manufacturers`(`manufacturer_id`);

/*
03.Many-To-Many Relationship
*/

CREATE TABLE `students` (
`student_id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(30) NOT NULL
);

CREATE TABLE `exams` (
`exam_id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(30) NOT NULL
)AUTO_INCREMENT = 101;

CREATE TABLE `students_exams` (
`student_id` INT NOT NUll,
`exam_id` INT NOT NULL,

CONSTRAINT `pk_students_exams`
PRIMARY KEY (`student_id`, `exam_id`),

CONSTRAINT `fk_students_exams_students`
FOREIGN KEY (`student_id`)
REFERENCES `students` (`student_id`),

CONSTRAINT `fk_students_exams_exams`
FOREIGN KEY (`exam_id`)
REFERENCES `exams`(`exam_id`)	
);

INSERT INTO `students` (`name`)
VALUES
('Mila'),
('Toni'),
('Ron');

INSERT INTO `exams` (`name`)
VALUES
('Spring MVC'),
('Neo4j'),
('Oracle 11g');

INSERT INTO `students_exams` (`student_id`, `exam_id`)
VALUES
(1, 101),
(1, 102),
(2, 101),
(3, 103),
(2, 102),
(2, 103);

/*
04.Self-Referencing
*/

CREATE TABLE `teachers` (
`teacher_id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(30) NOT NULL,
`manager_id` INT
) AUTO_INCREMENT = 101;

INSERT INTO `teachers`(`name`, `manager_id`)
VALUES
('John', NULL),
('Maya', 106),
('Silvia', 106),
('Ted', 105),
('Mark', 101),
('Greta', 101);

ALTER TABLE `teachers` 
ADD CONSTRAINT `fk_teacher_manager`
FOREIGN KEY (`manager_id`)
REFERENCES `teachers` (`teacher_id`);

/*
05.Online Store Database
*/

CREATE TABLE `cities` (
`city_id` INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(50)
);

CREATE TABLE `customers` (
`customer_id` INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(50),
`birthday` DATE,
`city_id` INT,

CONSTRAINT `fk_customers_cities`
 FOREIGN KEY (`city_id`)
 REFERENCES `cities` (`city_id`)
);

CREATE TABLE `orders` (
`order_id` INT AUTO_INCREMENT PRIMARY KEY,
`customer_id` INT,

CONSTRAINT `fk_orders_customers`
 FOREIGN KEY (`customer_id`)
 REFERENCES `customers` (`customer_id`)
);

CREATE TABLE `item_types` (
 `item_type_id` INT PRIMARY KEY AUTO_INCREMENT,
 `name` VARCHAR(50)
);

CREATE TABLE `items` (
`item_id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50),
`item_type_id` INT,

CONSTRAINT `fk_items_item_types`
 FOREIGN KEY (`item_type_id`)
 REFERENCES `item_types` (`item_type_id`)
);

CREATE TABLE `order_items` (
`order_id` INT,
`item_id` INT,

CONSTRAINT `pk_order_items`
 PRIMARY KEY(`order_id`, `item_id`),
 
CONSTRAINT `order_items_order`
FOREIGN KEY (`order_id`)
REFERENCES `orders` (`order_id`),

CONSTRAINT `order_items_items`
FOREIGN KEY (`item_id`)
REFERENCES `items` (`item_id`)
);

/*
06.University Database
*/

CREATE TABLE `majors` (
`major_id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50)
);

CREATE TABLE `students` (
`student_id` INT PRIMARY KEY AUTO_INCREMENT,
`student_number` VARCHAR(12),
`student_name` VARCHAR(50),
`major_id` INT,

CONSTRAINT `fk_students_majors`
FOREIGN KEY (`major_id`)
REFERENCES `majors` (`major_id`)
);

CREATE TABLE `payments` (
`payment_id` INT PRIMARY KEY AUTO_INCREMENT,
`payment_date` DATE,
`payment_amount`  DECIMAL(8,2),
`student_id` INT,

CONSTRAINT `fk_payments_students`
FOREIGN KEY (`student_id`)
REFERENCES `students` (`student_id`) 
);

CREATE TABLE `subjects` (
`subject_id` INT PRIMARY KEY AUTO_INCREMENT,
`subject_name` VARCHAR(50)
);

CREATE TABLE `agenda` (
`student_id` INT,
`subject_id` INT,

CONSTRAINT `pk_agenda`
PRIMARY KEY (`student_id`, `subject_id`),

CONSTRAINT `fk_agenda_students`
FOREIGN KEY (`student_id`)
REFERENCES `students` (`student_id`),

CONSTRAINT `fk_agenda_subject`
FOREIGN KEY (`subject_id`)
REFERENCES `subjects` (`subject_id`)
);

/*
07.SoftUni Design
*/

/*no msql solution required*/

/*
08.Geography Design
*/

/*no msql solution required*/

/*
09.Peaks in Rila
*/

SELECT `mountain_range`, `peak_name`, `elevation` FROM `mountains` AS m
JOIN `peaks` AS p ON
m.id = p.mountain_id
WHERE `mountain_range` = 'Rila'
ORDER BY `elevation` DESC;
