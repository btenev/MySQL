/*use soft_uni database*/

/*
01.Count Employees by Town
*/

DELIMITER $$
CREATE FUNCTION ufn_count_employees_by_town(town_name VARCHAR(20))
RETURNS INT
DETERMINISTIC
BEGIN
	RETURN  (SELECT count(t.town_id)
			FROM towns AS t
			JOIN addresses AS a ON t.town_id = a.town_id
			JOIN employees AS e ON a.address_id = e.address_id
			GROUP BY t.name
			HAVING t.name = town_name);
END
$$
DELIMITER ;            

SELECT ufn_count_employees_by_town('Sofia');

/*
02.Employees Promotion
*/

DELIMITER $$
CREATE PROCEDURE usp_raise_salaries(department_name VARCHAR(20))
BEGIN 
	UPDATE employees AS e
	JOIN departments AS d ON e.department_id = d.department_id
    SET e.salary = e.salary * 1.05
	WHERE d.name = department_name;
END    
$$
DELIMITER ;

CALL usp_raise_salaries('Finance');

/*
03.Employees Promotion by ID
*/

DELIMITER $$
CREATE PROCEDURE usp_raise_salary_by_id(id INT)
BEGIN
     IF ((SELECT count(employee_id) FROM employees WHERE employee_id = id) > 0)   
	    THEN 
			 UPDATE employees
			 SET salary = salary * 1.05
			 WHERE employee_id = id;
      END IF;       
END
$$
DELIMITER ;

CALL usp_raise_salary_by_id(17);

SELECT *
FROM employees
WHERE employee_id = 17;

/*
04.Triggered
*/

CREATE TABLE deleted_employees(
`employee_id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(50),
`last_name` VARCHAR(50),
`middle_name` VARCHAR(50),
`job_title` VARCHAR (50),
`department_id` INT,
`salary` DECIMAL(19,4)
);

DELIMITER $$
CREATE TRIGGER tr_deleted_employees
AFTER DELETE 
ON employees
FOR EACH ROW
BEGIN
	INSERT INTO deleted_employees (`first_name`, `last_name`, `middle_name`, `job_title`, `department_id`, `salary`)
	VALUES (OLD.first_name, OLD.last_name, OLD.middle_name, OLD.job_title, OLD.department_id, OLD.salary);
END
$$
DELIMITER ;
