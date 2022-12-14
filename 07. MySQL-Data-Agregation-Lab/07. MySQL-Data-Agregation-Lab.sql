/*use restaurant database*/

/*
01.Departments Info
*/

SELECT `department_id`, count(`department_id`) AS 'Number of employees'  FROM `employees`
GROUP BY `department_id`
ORDER BY `department_id`, `Number of employees`

/*
02.Average Salary
*/

SELECT `department_id`,round(AVG(`salary`), 2) AS 'Average salary' FROM `employees`
GROUP BY `department_id`
ORDER BY `department_id`;

/*
03.Min Salary
*/

SELECT `department_id`, round(MIN(`salary`), 2) AS `Min Salary` FROM `employees`
GROUP BY `department_id`
HAVING `Min Salary` > 800;

/*
04.Appetizers Count
*/

SELECT count(`name`) FROM `products`
WHERE `price` > 8
GROUP BY `category_id`
HAVING `category_id` = 2;

/*
05.Menu Prices
*/

SELECT `category_id`,
 round(AVG(`price`), 2) AS 'Average Price' ,
 round(MIN(`price`), 2) AS 'Cheapest Product',
 round(MAX(`price`), 2) AS 'Most Expensive Product'
 FROM `products`
GROUP BY `category_id`
