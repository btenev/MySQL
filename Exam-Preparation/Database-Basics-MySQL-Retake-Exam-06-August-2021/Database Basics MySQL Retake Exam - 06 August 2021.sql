/*
Section 1: Data Definition Language (DDL) – 40 pts
*/

/*
1.Table Design
*/

CREATE TABLE addresses (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50) NOT NULL
);

CREATE TABLE categories (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(10) NOT NULL
);

CREATE TABLE offices (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`workspace_capacity` INT NOT NULL,
`website` VARCHAR(50),
`address_id` INT NOT NULL,
 
 CONSTRAINT fk_offices_addresses
 FOREIGN KEY (`address_id`)
 REFERENCES `addresses` (`id`)
);

CREATE TABLE employees (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(30) NOT NULL,
`last_name` VARCHAR(30) NOT NULL,
`age` INT NOT NULL,
`salary` DECIMAL(10, 2) NOT NULL,
`job_title` VARCHAR(20) NOT NULL,
`happiness_level` CHARACTER(1) NOT NULL
);

CREATE TABLE teams (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(40) NOT NULL,
`office_id` INT NOT	NULL,
`leader_id` INT UNIQUE NOT NULL,

CONSTRAINT fk_teams_offices
FOREIGN KEY (`office_id`)
REFERENCES `offices` (`id`),

CONSTRAINT fk_teams_employees
FOREIGN KEY (`leader_id`)
REFERENCES `employees` (`id`)
);

CREATE TABLE games ( 
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50) NOT NULL UNIQUE,
`description` TEXT,
`rating` FLOAT DEFAULT 0  NOT NULL,
`budget` DECIMAL(10,2) NOT NULL,
`release_date` DATE,
`team_id` INT NOT NULL,

CONSTRAINT fk_games_teams
FOREIGN KEY (`team_id`)
REFERENCES `teams` (`id`)
);

CREATE TABLE games_categories (
`game_id` INT NOT NULL,
`category_id` INT NOT NULL,

CONSTRAINT pk_games_categories
PRIMARY KEY (`game_id`, `category_id`),

CONSTRAINT fk_games_categories_games
FOREIGN KEY (`game_id`)
REFERENCES `games` (`id`),

CONSTRAINT fk_games_categories_categories
FOREIGN KEY (`category_id`)
REFERENCES `categories` (`id`)
);

/*
Section 2: Data Manipulation Language (DML) – 30 pts
*/

/*
2.Insert
*/

INSERT INTO games (name, rating, budget, team_id)
SELECT lower(reverse(substring(name, 2))) AS name, id, leader_id * 1000, id
FROM teams
WHERE id BETWEEN 1 AND 9;

/*
3.Update
*/

UPDATE employees 
SET salary = salary + 1000
WHERE age < 40 AND salary <= 5000;

/*
4.Delete
*/

DELETE g.* FROM games AS g
LEFT JOIN games_categories  AS c ON g.id = c.game_id
WHERE c.category_id IS NULL AND g.release_date IS NULL;

/*
Section 3: Querying – 50 pts
*/

/*
5.Employees
*/

SELECT first_name, last_name, age, salary, happiness_level
FROM employees
ORDER BY salary, id;

/*
6.Addresses of the teams
*/

SELECT t.name AS team_name, ad.name AS address_name, char_length(ad.name)
FROM teams AS t
JOIN offices AS o ON t.office_id = o.id
JOIN addresses AS ad ON o.address_id = ad.id
WHERE o.website IS NOT NULL
ORDER BY team_name, address_name;

/*
7.Categories Info
*/

SELECT c.name, count(g.id) AS games_count, round(avg(g.budget), 2) AS avg_budget, max(g.rating) AS max_rating
FROM categories AS c
JOIN games_categories AS gc ON c.id = gc.category_id
JOIN games AS g ON gc.game_id = g.id
GROUP BY c.name
HAVING max_rating >= 9.5
ORDER BY games_count DESC, c.name;

/*
8.Games of 2022
*/

SELECT g.name, g.release_date, concat(substring(g.description, 1, 10), '...') AS summary,
 CASE 
	WHEN month(g.release_date) IN (1,2,3) THEN 'Q1'
	WHEN month(g.release_date) IN (4,5,6)	THEN 'Q2'		
	WHEN month(g.release_date) IN (7,8,9)	THEN 'Q3'
	ELSE 'Q4'		
 END AS 'quarter', t.name AS team_name
FROM games AS g
JOIN teams AS t ON g.team_id = t.id
WHERE year(g.release_date) = '2022' AND month(g.release_date) % 2 = 0 AND substring(reverse(g.name),1,1) = 2
ORDER BY quarter;

/*
9.Full info for games
*/

SELECT g.name, 
IF(g.budget < 50000, 'Normal budget', 'Insufficient budget') AS budget_level, t.name AS team_name, ad.name AS address_name 
FROM games_categories AS gc
RIGHT JOIN games AS g ON gc.game_id = g.id
JOIN teams AS t ON g.team_id = t.id
JOIN offices AS o ON  t.office_id = o.id
JOIN addresses AS ad ON o.address_id = ad.id
WHERE  g.release_date IS NULL AND gc.category_id IS NULL
ORDER BY g.name

/*
Section 4: Programmability – 30 pts
*/

/*
10.Find all basic information for a game
*/

DELIMITER $$
CREATE FUNCTION udf_game_info_by_name (game_name VARCHAR (20))
RETURNS VARCHAR(200)
DETERMINISTIC
BEGIN
	DECLARE team_name VARCHAR(30);
    DECLARE text_of_address VARCHAR(30);
    SET team_name = (SELECT t.name
                       FROM games AS g
                       JOIN teams AS t ON g.team_id = t.id
                       WHERE g.name = game_name);
    SET text_of_address =  (SELECT a.name
                       FROM games AS g
                       JOIN teams AS t ON g.team_id = t.id
                       JOIN offices AS o ON t.office_id = o.id
                       JOIN addresses AS a ON o.address_id = a.id
                       WHERE g.name = game_name); 
     RETURN  concat('The', ' ', game_name, ' ', 'is developed by a', ' ', team_name, ' ', 'in an office with an address', ' ',text_of_address);               
END
$$
DELIMITER ;

SELECT udf_game_info_by_name('Bitwolf') AS info;

/*
11.Update budget of the games 
*/

DELIMITER $$
CREATE PROCEDURE udp_update_budget (min_game_rating FLOAT)
BEGIN
	UPDATE games_categories AS gc
	RIGHT JOIN games AS g ON gc.game_id = g.id
	SET g.budget = g.budget + 100000, 
		g.release_date =  date_add(g.release_date, INTERVAL 1 YEAR)
	WHERE category_id IS NULL AND g.rating > min_game_rating AND g.release_date IS NOT NULL;
END
$$
DELIMITER ;
CALL udp_update_budget (8);

	SELECT *
	FROM games_categories AS gc
	RIGHT JOIN games AS g ON gc.game_id = g.id
	WHERE category_id IS NULL AND g.rating > 8 AND g.release_date IS NOT NULL;
