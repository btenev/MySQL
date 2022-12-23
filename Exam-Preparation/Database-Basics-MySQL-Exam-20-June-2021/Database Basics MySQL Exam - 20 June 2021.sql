/*
Section 1: Data Definition Language (DDL) – 40 pts
*/

/*
1.Table Design
*/

CREATE TABLE addresses (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(100) NOT NULL
);

CREATE TABLE categories (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(10) NOT NULL
);

CREATE TABLE clients (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`full_name` VARCHAR(50) NOT NULL,
`phone_number` VARCHAR(20) NOT NULL
);

CREATE TABLE drivers (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(30) NOT NULL,
`last_name` VARCHAR(30) NOT NULL,
`age` INT NOT NULL,
`rating` FLOAT DEFAULT 5.5
);

CREATE TABLE cars (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`make` VARCHAR(20) NOT NULL,
`model` VARCHAR(20),
`year` INT DEFAULT 0 NOT NULL,
`mileage` INT DEFAULT 0,
`condition` CHAR(1) NOT NULL,
`category_id` INT NOT NULL,

CONSTRAINT fk_cars_categories
FOREIGN KEY (`category_id`)
REFERENCES `categories` (`id`)
);

CREATE TABLE courses (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`from_address_id` INT NOT NULL,
`start` DATETIME NOT NULL,
`bill` DECIMAL(10, 2) DEFAULT 10,
`car_id` INT NOT NULL,
`client_id` INT NOT NULL,

CONSTRAINT fk_courses_addresses
FOREIGN KEY (`from_address_id`)
REFERENCES `addresses` (`id`),

CONSTRAINT fk_courses_cars
FOREIGN KEY (`car_id`)
REFERENCES `cars` (`id`),

CONSTRAINT fk_courses_clients
FOREIGN KEY (`client_id`)
REFERENCES `clients` (`id`)
);

CREATE TABLE cars_drivers (
`car_id` INT NOT NULL,
`driver_id` INT NOT NULL,

CONSTRAINT pk_cars_drivers
PRIMARY KEY (`car_id`, `driver_id`),

CONSTRAINT fk_cars_drivers_cars
FOREIGN KEY (`car_id`)
REFERENCES `cars` (`id`),

CONSTRAINT fk_cars_drivers_drivers
FOREIGN KEY (`driver_id`)
REFERENCES `drivers` (`id`)
);

/*
Section 2: Data Manipulation Language (DML) – 30 pts
*/

/*
2.Insert
*/

INSERT INTO clients (`full_name`, `phone_number`)
SELECT concat_ws(' ', first_name, last_name) AS full_name, concat('(088) 9999', id * 2) AS phone_number
FROM drivers
WHERE id BETWEEN 10 AND 20;

/*
3.Update
*/

UPDATE cars
SET `condition` = 'C'
WHERE mileage >= 800000 OR mileage IS NULL AND `year` <= 2010 AND `make` != 'Mercedes-Benz';

/*
4.Delete
*/

DELETE c.* FROM clients AS c
LEFT JOIN courses AS cs ON  c.id = cs.client_id
WHERE cs.client_id IS NULL AND  char_length(c.full_name) > 3;

/*
Section 3: Querying – 50 pts
*/

/*
5.Cars
*/

SELECT make, model, `condition`
FROM cars
ORDER BY id;

/*
6.Drivers and Cars
*/

SELECT d.first_name, d.last_name, c.make, c.model, c.mileage 
FROM drivers AS d
JOIN cars_drivers AS cd ON d.id = cd.driver_id
JOIN cars AS c ON cd.car_id = c.id
WHERE mileage IS NOT NULL
ORDER BY c.mileage DESC, d.first_name;

/*
7.Number of courses for each car
*/

SELECT c.id AS car_id, c.make, c.mileage, count(cs.id) AS count_of_courses, round(avg(cs.bill) , 2) AS avg_bill
FROM cars AS c
LEFT JOIN courses AS cs ON c.id = cs.car_id
GROUP BY c.id
HAVING count_of_courses != 2
ORDER BY count_of_courses DESC, c.id;

/*
8.Regular clients
*/

SELECT c.full_name, count(ca.model) AS count_of_cars, SUM(cs.bill) AS total_sum
FROM clients AS c
JOIN courses AS cs ON c.id = cs.client_id
JOIN cars AS ca ON cs.car_id = ca.id
GROUP BY c.id
HAVING substr(c.full_name, 2, 1) = 'a' AND count_of_cars > 1
ORDER BY c.full_name;

/*
9.Full information of courses
*/

SELECT a.name, 
CASE
 WHEN hour(cs.start) BETWEEN 6 AND 20 THEN 'Day'
 ELSE 'Night'
END  AS day_time, cs.bill, cl.full_name, ca.make, ca.model, cat.name
FROM addresses AS a
JOIN courses AS cs ON a.id = cs.from_address_id
JOIN clients AS cl ON cs.client_id = cl.id
JOIN cars AS ca ON cs.car_id = ca.id
JOIN categories AS cat ON ca.category_id = cat.id
ORDER BY cs.id;

/*
Section 4: Programmability – 30 pts
*/

/*
10.Find all courses by client’s phone number
*/

DELIMITER $$
CREATE FUNCTION udf_courses_by_client (phone_num VARCHAR (20))
RETURNS INT
DETERMINISTIC
BEGIN
	RETURN  (SELECT count(cs.id)
			FROM clients AS c
			JOIN courses AS cs ON c.id = cs.client_id
			WHERE c.phone_number = phone_num);
END
$$            

DELIMITER ;
SELECT udf_courses_by_client ('(803) 6386812') as `count`; 

/*
11.Full info for address
*/

DELIMITER $$
CREATE PROCEDURE udp_courses_by_address (address_name VARCHAR(100))
BEGIN
	SELECT a.name, cl.full_name, 
	CASE 
		WHEN cs.bill <= 20 THEN 'Low'
		WHEN cs.bill <= 30 THEN 'Medium'
		ELSE 'High' 
	END AS level_of_bill,
	 ca.make, ca.condition, cat.name AS cat_name
	FROM addresses AS a
	JOIN courses AS cs ON a.id = cs.from_address_id
	JOIN clients AS cl ON cs.client_id = cl.id
	JOIN cars AS ca ON cs.car_id = ca.id
	JOIN categories AS cat ON ca.category_id = cat.id
	WHERE a.name = address_name
	ORDER BY ca.make, cl.full_name;
END
$$
CALL udp_courses_by_address('66 Thompson Drive');
