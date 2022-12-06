/*
01.Create tables
*/

CREATE TABLE employees (
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(50) NOT NULL, 
last_name VARCHAR(50) NOT NULL
);

CREATE TABLE categories (
id INT PRIMARY KEY AUTO_INCREMENT ,
`name` VARCHAR(50) NOT NULL
);

CREATE TABLE products (
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50) NOT NUll,
category_id INT NOT NULL
);

/*
02.Insert Data in Tables
*/

INSERT INTO employees (first_name, last_name)
VALUES ('Ivan', 'Ivanov');

INSERT INTO employees (first_name, last_name)
VALUES ('Georgi', 'Georgiev');

INSERT INTO employees (first_name, last_name)
VALUES ('Plamena', 'Plamanenova');

/*
03.Alter Tables
*/

ALTER TABLE employees
ADD COLUMN middle_name VARCHAR(50);

/*
04.Adding Constraints
*/

ALTER TABLE products
ADD CONSTRAINT `cat_fk`
FOREIGN KEY `products` (`category_id`)
REFERENCES `categories` (`id`);

/*
05.Modifying Columns
*/

ALTER TABLE employees
CHANGE COLUMN `middle_name` `middle_name` VARCHAR(100);


