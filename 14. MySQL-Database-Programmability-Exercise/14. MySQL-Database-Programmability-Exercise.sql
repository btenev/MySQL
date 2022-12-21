/*
Part I – Queries for SoftUni Database
*/

/*
01.Employees with Salary Above 35000
*/

DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above_35000()
BEGIN
	SELECT e.first_name, e.last_name
	FROM employees AS e
	WHERE e.salary > 35000
	ORDER BY e.first_name, e.last_name, e.employee_id;
END
$$

CALL usp_get_employees_salary_above_35000()

/*
02.Employees with Salary Above Number
*/

DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above (salary_above DECIMAL(15,4))
BEGIN
	SELECT e.first_name, e.last_name
	FROM employees AS e
	WHERE e.salary >= salary_above
	ORDER BY e.first_name, e.last_name, e.employee_id;
END
$$ 

CALL usp_get_employees_salary_above (45000)

/*
03.Town Names Starting With
*/

DELIMITER $$
CREATE PROCEDURE usp_get_towns_starting_with(desired_town VARCHAR(50))
BEGIN
	SELECT t.name AS town_name
	FROM towns AS t
	WHERE t.name LIKE CONCAT(desired_town, '%')
    ORDER BY t.name;
END    
$$

CALL usp_get_towns_starting_with('b')

/*
04.Employees from Town
*/

DELIMITER $$
CREATE PROCEDURE usp_get_employees_from_town (desired_town VARCHAR (50))
BEGIN
	SELECT e.first_name, e.last_name
	FROM employees AS e
	JOIN addresses AS a
	ON e.address_id = a.address_id
	JOIN towns AS t
	ON a.town_id = t.town_id
	WHERE t.name = desired_town
	ORDER BY e.first_name, e.last_name, e.employee_id;
END
$$

CALL usp_get_employees_from_town('Sofia')

/*
05.Salary Level Function
*/

DELIMITER $$
CREATE FUNCTION ufn_get_salary_level (sort_by_salary_value DECIMAL)
RETURNS VARCHAR(100)
DETERMINISTIC

BEGIN
RETURN (CASE 
			WHEN sort_by_salary_value < 30000 THEN 'Low'
			WHEN sort_by_salary_value BETWEEN 30000 AND 50000 THEN 'Average'
			WHEN sort_by_salary_value > 50000 THEN 'High'
		END); 
END
$$

SELECT ufn_get_salary_level (43300.00)

/*
06.Employees by Salary Level
*/

CREATE PROCEDURE usp_get_employees_by_salary_level(salary_level VARCHAR(10))
BEGIN
	SELECT e.first_name, e.last_name
	FROM employees AS e
	WHERE  e.salary  < 30000 AND salary_level = 'low' 
		OR e.salary BETWEEN 30000 AND 50000 AND salary_level = 'average'
		OR e.salary > 50000 AND salary_level = 'high'
ORDER BY e.first_name DESC, e.last_name DESC;
END    

/*
07.Define Function
*/

DELIMITER $$
CREATE FUNCTION ufn_is_word_comprised(set_of_letters varchar(50), word varchar(50)) 
RETURNS INT 
DETERMINISTIC
BEGIN
	RETURN word REGEXP (concat('^[', set_of_letters, ']+$'));
END
$$

SELECT ufn_is_word_comprised ('oistmiahf', 'halves');

/*PART II – Queries for Bank Database*/

/*
08.Find Full Name
*/

DELIMITER $$
CREATE PROCEDURE usp_get_holders_full_name()
BEGIN
	SELECT concat_ws(' ', first_name, last_name) AS full_name
	FROM account_holders
    ORDER BY full_name, id;
END
$$

DELIMITER ;

CALL usp_get_holders_full_name();

/*
09.People with Balance Higher Than
*/

DELIMITER $$
CREATE PROCEDURE usp_get_holders_with_balance_higher_than (number DECIMAL(19,4))
BEGIN
	SELECT ah.first_name, ah.last_name
	FROM account_holders AS ah
	JOIN accounts AS a ON ah.id = a.account_holder_id
	GROUP BY a.account_holder_id
	HAVING sum(a.balance) > number
	ORDER BY a.account_holder_id;
END
$$
DELIMITER ;
CALL usp_get_holders_with_balance_higher_than(10000);

/*
10.Future Value Function
*/

DELIMITER $$
CREATE FUNCTION ufn_calculate_future_value (sum DECIMAL(19,4), yearly_interest_rate DOUBLE, number_of_years INT)
RETURNS DECIMAL(19,4)
DETERMINISTIC
BEGIN
	DECLARE result DECIMAL(19,4);
    SET result := sum * (power((1 + yearly_interest_rate), number_of_years));
    RETURN result;
END
$$
DELIMITER ;

SELECT ufn_calculate_future_value (1000, 0.50, 5);

/*
11.Calculating Interest
*/

DELIMITER $$ 
CREATE PROCEDURE usp_calculate_future_value_for_account (id INT, interest_rate DOUBLE(10, 4))
BEGIN
	DECLARE current_balance DECIMAL(19,4);
	SET current_balance := (
		SELECT a.balance
		FROM account_holders AS ah
		JOIN accounts AS a ON ah.id = a.account_holder_id
		WHERE a.id= id);
	SELECT a.id AS account_id, ah.first_name, ah.last_name, a.balance,
    ufn_calculate_future_value (current_balance, interest_rate, 5) AS balance_in_5_years
    FROM account_holders AS ah
		JOIN accounts AS a ON ah.id = a.account_holder_id
	WHERE a.id= id;
END
$$    
DELIMITER ;

CALL usp_calculate_future_value_for_account (1, 0.1)

/*
12.Deposit Money
*/

DELIMITER $$
CREATE PROCEDURE usp_deposit_money(account_id INT, money_amount DECIMAL(19,4))
BEGIN
		START TRANSACTION;
        IF (money_amount < 0) 
          THEN
        ROLLBACK;
        ELSE 
			UPDATE accounts
            SET balance = balance + money_amount
            WHERE id = account_id;
		END IF;	
END
$$
DELIMITER ;         

CALL usp_deposit_money(1, 10);

/*
13.Withdraw Money
*/

DELIMITER $$
CREATE PROCEDURE usp_withdraw_money(account_id INT, money_amount DECIMAL(19,4))
BEGIN
	START TRANSACTION;
    IF (((SELECT balance FROM accounts WHERE id = account_id) - money_amount) < 0 OR money_amount < 0)
		THEN
	ROLLBACK;
	ELSE
		UPDATE accounts
        SET balance = balance - money_amount
        WHERE id = account_id;
    END IF;
END
$$
DELIMITER ;    
        
CALL usp_withdraw_money(1, 10)

/*
14.Money Transfer
*/

DELIMITER $$
CREATE PROCEDURE usp_transfer_money(from_account_id INT, to_account_id INT, amount DECIMAL(19,4))
BEGIN
     START TRANSACTION;
		 IF (from_account_id = to_account_id 
		 OR (SELECT count(*) FROM accounts WHERE id = from_account_id) = 0
		 OR (SELECT count(*) FROM accounts WHERE id = to_account_id) = 0
		 OR amount < 0 
		 OR (SELECT balance FROM accounts WHERE id = from_account_id) - amount < 0)
     THEN
     ROLLBACK;
     ELSE
		UPDATE accounts
        SET balance = balance - amount
        WHERE id = from_account_id;
        
        UPDATE accounts
        SET balance = balance + amount
        WHERE id = to_account_id;
     END IF;
END
$$
DELIMITER ;     
     
CALL usp_transfer_money(1, 2, 10);

/*
15.Log Accounts Trigger
*/

/*
16.Emails Trigger
*/

