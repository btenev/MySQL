/*use soft_uni database*/

/*
01.Employee Address
*/

SELECT e.employee_id, e.job_title, a.address_id, a.address_text
FROM employees AS e
JOIN addresses AS a 
USING (address_id)
ORDER BY a.address_id LIMIT 5;

/*
02.Addresses with Towns
*/

SELECT e.first_name, e.last_name, t.name, address_text
FROM employees AS e
JOIN addresses AS a
USING (address_id)
JOIN towns AS t
USING (town_id)
ORDER BY e.first_name, e.last_name LIMIT 5;

/*
03.Sales Employee
*/

SELECT e.employee_id, e.first_name, e.last_name, d.name
FROM employees AS e
JOIN departments AS d
ON e.department_id = d.department_id
WHERE d.name = 'Sales'
ORDER BY e.employee_id DESC	

/*
04.Employee Departments
*/

SELECT e.employee_id, e.first_name, e.salary, d.name AS 'department_name'
FROM employees AS e
JOIN departments d
ON e.department_id = d.department_id
WHERE e.salary > 15000 
ORDER BY d.department_id DESC LIMIT 5;

/*
05.Employees Without Project
*/

SELECT e.employee_id, e.first_name
FROM employees AS e
LEFT JOIN employees_projects AS ep
ON e.employee_id = ep.employee_id
WHERE ep.project_id IS NULL
ORDER BY e.employee_id DESC LIMIT 3;

/*
06.Employees Hired After
*/

SELECT e.first_name, e.last_name, date_format(e.hire_date, '%Y-%m-%d %H:%i:%i') AS 'hire_date', d.name AS 'dept_name'
FROM employees AS e
JOIN departments AS d
ON e.department_id = d.department_id
WHERE e.hire_date > '1999/1/1' AND d.name IN ('Sales', 'Finance')
ORDER BY e.hire_date ASC

/*
07.Employees with Project
*/

SELECT e.employee_id, e.first_name, pr.name
FROM employees AS e
JOIN employees_projects AS ep
ON e.employee_id = ep.employee_id
JOIN projects AS pr
ON ep.project_id = pr.project_id
WHERE DATE(pr.start_date) > '2002-08-13' AND pr.end_date IS NULL
ORDER BY e.first_name ASC, pr.name ASC LIMIT 5;

/*
08.Employee 24
*/

SELECT e.employee_id, e.first_name, if (year(pr.start_date ) >= 2005, ' ', pr.name) AS 'project_date'
FROM employees AS e
JOIN employees_projects AS ep
ON e.employee_id = ep.employee_id
JOIN projects AS pr
ON ep.project_id = pr.project_id
WHERE e.employee_id = 24 
ORDER BY pr.name;

/*
09.Employee Manager
*/

SELECT e.employee_id, e.first_name, e.manager_id, m.first_name AS 'manager_name'
FROM employees AS e
JOIN employees AS m
ON e.manager_id = m.employee_id
WHERE e.manager_id IN (3, 7)
ORDER BY e.first_name ASC

/*
10.Employee Summary
*/

SELECT e.employee_id, concat_ws(' ', e.first_name, e.last_name) AS 'employee_name',
 concat_ws(' ', m.first_name, m.last_name) AS 'manager_name', d.name AS 'department_name'
FROM employees AS e
JOIN employees AS m
ON e.manager_id = m.employee_id
JOIN departments AS d
ON e.department_id = d.department_id
ORDER BY e.employee_id LIMIT 5;

/*
11.Min Average Salary
*/

SELECT AVG(e.salary) AS 'min_average_salary'
FROM employees AS e
JOIN departments AS d
ON e.department_id = d.department_id
GROUP BY d.department_id
ORDER BY min_average_salary LIMIT 1;

/*use geography database*/

/*
12.Highest Peaks in Bulgaria
*/

SELECT c.country_code, m.mountain_range, p.peak_name, p.elevation
FROM countries AS c
JOIN mountains_countries AS mc
ON c.country_code = mc.country_code
JOIN mountains AS m
ON mc.mountain_id = m.id
JOIN peaks AS p
ON m.id = p.mountain_id
WHERE c.country_code = 'BG' AND p.elevation > 2835
ORDER BY p.elevation DESC

/*
13.Count Mountain Ranges
*/

SELECT c.country_code, COUNT(m.mountain_range) AS 'mountain_range'
FROM countries AS c
JOIN mountains_countries AS mc
ON c.country_code = mc.country_code
JOIN mountains AS m
ON mc.mountain_id = m.id
WHERE c.country_code IN ('US', 'BG', 'RU')
GROUP BY c.country_code
ORDER BY mountain_range DESC

/*
14.Countries with Rivers
*/

SELECT c.country_name, r.river_name
FROM countries AS c
LEFT JOIN countries_rivers AS cr
ON c.country_code = cr.country_code
LEFT JOIN rivers AS r
ON cr.river_id = r.id
WHERE c.continent_code = 'AF'
ORDER BY c.country_name ASC LIMIT 5

/*
15.*Continents and Currencies
*/

SELECT c.continent_code, cu.currency_code, count(cu.currency_code)  AS currency_usage 
FROM countries AS c
JOIN currencies AS cu
ON c.currency_code = cu.currency_code 
GROUP BY c.continent_code, cu.currency_code

HAVING currency_usage > 1 AND currency_usage = (
SELECT COUNT(*) AS 'most_used_currency'
FROM countries AS c2
WHERE c.continent_code = c2.continent_code
GROUP BY c2.currency_code
ORDER BY most_used_currency DESC LIMIT 1)

ORDER BY c.continent_code, cu.currency_code

/*
16.Countries Without Any Mountains
*/

SELECT COUNT(*) AS country_count
FROM countries AS c
LEFT JOIN mountains_countries AS cm
ON c.country_code = cm.country_code
WHERE cm.mountain_id IS NULL;

/*
17.Highest Peak and Longest River by Country
*/

SELECT c.country_name, p.elevation AS highest_peak_elevation, r.length AS longest_river_length
FROM countries AS c
LEFT JOIN mountains_countries AS mc
ON c.country_code = mc.country_code
LEFT JOIN mountains AS m
ON mc.mountain_id = m.id
LEFT JOIN  peaks AS p
ON m.id = p.mountain_id
LEFT JOIN countries_rivers AS cr
ON c.country_code = cr.country_code
LEFT JOIN rivers AS r 
ON cr.river_id = r.id
WHERE p.elevation = (SELECT p.elevation
   FROM countries AS c2
   JOIN mountains_countries AS mc
   ON c2.country_code = mc.country_code
   JOIN mountains AS m
   ON mc.mountain_id = m.id
   JOIN peaks AS p
   ON m.id = p.mountain_id
   WHERE c.country_name = c2.country_name 
   ORDER BY p.elevation DESC LIMIT 1)
AND 
r.length = (SELECT r2.length
  FROM countries AS c2
  JOIN countries_rivers AS cr2
  ON c2.country_code = cr2.country_code
  JOIN rivers AS r2
  ON cr2.river_id = r2.id
  WHERE c2.country_name = c.country_name
  ORDER BY length DESC LIMIT 1)
ORDER BY highest_peak_elevation DESC, longest_river_length DESC, c.country_name LIMIT 5

