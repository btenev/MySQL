/*use soft_uni database*/

/*
01.Managers
*/

SELECT emp.employee_id,concat_ws(' ', emp.first_name, emp.last_name) AS 'full_name' , d.department_id, d.name
FROM `employees` AS emp
RIGHT JOIN `departments` AS d
ON d.manager_id = emp.employee_id
ORDER BY `employee_id` LIMIT 5;

/*
02.Towns Addresses
*/

SELECT t.town_id, t.name AS 'town_name', a.address_text
FROM `towns` AS t
JOIN `addresses` AS a ON t.town_id = a.town_id
WHERE t.name IN ('San Francisco', 'Sofia', 'Carnation')
ORDER BY `town_id`, `address_id`

/*
03.Employees Without Managers
*/

SELECT `employee_id`, `first_name`, `last_name`, `department_id`, `salary` 
FROM `employees`
WHERE `manager_id` IS NULL;

/*
04.Higher Salary
*/

SELECT COUNT(`employee_id`)
FROM `employees`
WHERE `salary` > (SELECT AVG(`salary`) FROM `employees`)
