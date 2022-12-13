/*
Part I – Queries for SoftUni Database
*/

/*
01.Find Names of All Employees by First Name
*/

/*most accurate*/
SELECT `first_name`, `last_name` FROM `employees`
WHERE substring(lower(`first_name`), 1, 2) = 'sa' 
ORDER BY `employee_id`;

/*zero test fails*/
SELECT `first_name`, `last_name` FROM `employees`
WHERE lower(`first_name`) LIKE 'sa%' 
ORDER BY `employee_id`;

/*zero test fails*/
SELECT `first_name`, `last_name` FROM `employees`
WHERE `first_name` REGEXP '^[SsAa]'
ORDER BY `employee_id`;

/*
02.Find Names of All Employees by Last Name
*/

SELECT `first_name`, `last_name` FROM `employees`
WHERE lower(`last_name`) LIKE '%ei%' 
ORDER BY `employee_id`;

/*
03.Find First Names of All Employees
*/

SELECT `first_name` FROM `employees`
WHERE `department_id` IN (3, 10) AND extract(YEAR FROM `hire_date`) BETWEEN 1995 AND 2005
ORDER BY `employee_id`;

/*
04.Find All Employees Except Engineers
*/

SELECT `first_name`, `last_name` FROM `employees`
WHERE NOT locate('engineer', `job_title`)
ORDER BY `employee_id`;

/*
05.Find Towns with Name Length
*/

SELECT `name` FROM `towns`
WHERE CHAR_LENGTH(`name`) = 5 OR CHAR_LENGTH(`name`) = 6
ORDER BY `name`; 

/*
06.Find Towns Starting With
*/

SELECT * FROM `towns`
WHERE `name` REGEXP '^[MmKkBbEe]'
ORDER BY `name`;

/*
07.Find Towns Not Starting With
*/

SELECT * FROM `towns`
WHERE `name` REGEXP '^[^R,r,B,b,D,d]'
ORDER BY `name`;

/*OR*/ 
SELECT * FROM `towns`
WHERE lower(`name`) NOT LIKE 'r%' 
      AND lower(`name`) NOT LIKE 'b%' 
      AND lower(`name`) NOT LIKE 'd%'
ORDER BY `name`;

/*
08.Create View Employees Hired After 2000 Year
*/

CREATE VIEW `v_employees_hired_after_2000`
AS SELECT `first_name`, `last_name` FROM `employees`
WHERE year(`hire_date`) > 2000;

/*
09.Length of Last Name
*/

SELECT `first_name`, `last_name` FROM `employees`
WHERE char_length(`last_name`) = 5;

/*
Part II – Queries for Geography Database 
*/

/*
10.Countries Holding 'A' 3 or More Times
*/

SELECT `country_name`, `iso_code` FROM `countries`
WHERE upper(`country_name`) LIKE '%A%A%A%'
ORDER BY `iso_code`; 

/*OR*/
SELECT `country_name`, `iso_code` FROM `countries`
WHERE upper(`country_name`) REGEXP '(.*A.*){3}' 
ORDER BY `iso_code`;

/*OR*/
SELECT `country_name`, `iso_code` FROM `countries`
WHERE (char_length(`country_name`) - char_length(replace(lower(`country_name`), 'a', ''))) >= 3
ORDER BY `iso_code`;

/*
11.Mix of Peak and River Names
*/

SELECT `peak_name`, `river_name`, lower(concat(`peak_name`, substring(`river_name`, 2))) AS 'mixx' FROM `peaks`, `rivers`
WHERE substring(reverse(`peak_name`), 1, 1) = substring(`river_name`, 1, 1)
ORDER BY `mixx`;

/*OR*/
SELECT `peak_name`, `river_name`, lower(concat(left(`peak_name`, char_length(`peak_name`) - 1), `river_name`)) AS 'mixx' FROM `peaks`, `rivers`
WHERE substring(reverse(`peak_name`), 1, 1) = substring(`river_name`, 1, 1)
ORDER BY `mixx`;

/*
Part III – Queries for Diablo Database
*/

/*
12.Games from 2011 and 2012 Year
*/

SELECT `name`, date_format(`start`, '%Y-%m-%d' ) AS `start` FROM `games`
WHERE year(`start`) BETWEEN 2011 AND 2012 
ORDER BY `start`, `name` LIMIT 50;

/*
13.User Email Providers
*/

SELECT `user_name`, substring(`email`, locate('@', `email`) + 1) AS 'email provider' FROM `users`
ORDER BY `email provider`, `user_name`;

/*
14.Get Users with IP Address Like Pattern
*/

SELECT `user_name`, `ip_address` FROM `users`
WHERE `ip_address` LIKE '___.1%.%.___'
ORDER BY `user_name`;

/*
15.Show All Games with Duration and Part of the Day
*/

SELECT `name`, 
CASE   
  WHEN hour(`start`) BETWEEN 0 AND 11 THEN 'Morning'
  WHEN hour(`start`) BETWEEN 12 AND 17 THEN 'Afternoon'
  ELSE 'Evening'
END AS 'Part of the day',
CASE
 WHEN `duration` <= 3 THEN 'Extra Short'
 WHEN `duration` BETWEEN 4 AND 6 THEN 'Short'
 WHEN `duration` BETWEEN 7 AND 10 THEN 'Long'
 ELSE 'Extra Long'
END AS 'Duration'
FROM `games`

/*
Part IV – Date Functions Queries
*/

/*
16.Orders Table
*/

SELECT `product_name`, `order_date`, 
adddate(`order_date`, INTERVAL 3 DAY) AS `pay_due`, 
adddate(`order_date`, INTERVAL 1 MONTH) AS `delivery_date`
FROM `orders`;
