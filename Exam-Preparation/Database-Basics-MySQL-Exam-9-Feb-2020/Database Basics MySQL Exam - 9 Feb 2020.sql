/*
Section 1: Data Definition Language (DDL) – 40 pts
*/

/*
1.Table Design
*/

CREATE TABLE `countries` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(45) NOT NULL
);

CREATE TABLE `towns` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(45) NOT NULL,
`country_id` INT NOT NULL,
CONSTRAINT fk_towns_countries
FOREIGN KEY (`country_id`)
REFERENCES `countries` (`id`)
);

CREATE TABLE `stadiums` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(45) NOT NULL,
`capacity` INT NOT NULL,
`town_id` INT NOT NULL,
CONSTRAINT fk_stadiums_towns
FOREIGN KEY (`town_id`)
REFERENCES `towns` (`id`)
);

CREATE TABLE `teams` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(45) NOT NULL,
`established` DATE NOT NULL,
`fan_base` BIGINT NOT NULL DEFAULT 0,
`stadium_id` INT NOT NULL,
CONSTRAINT fk_teams_stadiums
FOREIGN KEY (`stadium_id`)
REFERENCES `stadiums` (`id`)
);

CREATE TABLE `skills_data` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`dribbling` INT DEFAULT 0,
`pace` INT DEFAULT 0,
`passing` INT DEFAULT 0,
`shooting` INT DEFAULT 0,
`speed` INT DEFAULT 0,
`strength` INT DEFAULT 0
);

CREATE TABLE `players` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(10) NOT NULL,
`last_name` VARCHAR(20) NOT NULL,
`age` INT NOT NULL DEFAULT 0,
`position` CHAR(1) NOT NULL,
`salary` DECIMAL(10, 2) NOT NULL DEFAULT 0,
`hire_date` DATETIME,
`skills_data_id` INT NOT NULL,
CONSTRAINT fk_players_skills_data
FOREIGN KEY (`skills_data_id`)
REFERENCES `skills_data` (`id`),
`team_id` INT,
CONSTRAINT fk_players_teams
FOREIGN KEY (`team_id`)
REFERENCES `teams` (`id`)
);

CREATE TABLE `coaches` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(10) NOT NULL,
`last_name` VARCHAR(20) NOT NULL,
`salary` DECIMAL(10,2) NOT NULL DEFAULT 0,
`coach_level` INT NOT NULL DEFAULT 0
);

CREATE TABLE `players_coaches` (
`player_id` INT,
`coach_id` INT,
CONSTRAINT pk_players_coaches
PRIMARY KEY (`player_id`, `coach_id`),

CONSTRAINT fk_players_coaches_players
FOREIGN KEY (`player_id`)
REFERENCES `players` (`id`),

CONSTRAINT fk_players_coaches_coaches
FOREIGN KEY (`coach_id`)
REFERENCES `coaches` (`id`)
);

/*
Section 2: Data Manipulation Language (DML) – 30 pts
*/

/*
2.Insert
*/

INSERT INTO coaches (first_name, last_name, salary, coach_level)
SELECT first_name, last_name, salary * 2, char_length(first_name)
FROM players 
WHERE age >= 45;

/*
3.Update
*/

UPDATE coaches AS c
JOIN players_coaches AS pc
ON c.id = pc.coach_id
SET c.coach_level = c.coach_level + 1
WHERE c.first_name LIKE 'A%';

/*
4.Delete
*/

DELETE FROM players 
WHERE age >= 45;

/*
Section 3: Querying – 50 pts
*/

/*
5.Players 
*/

SELECT p.first_name, p.age, p.salary
FROM players AS p
ORDER BY salary DESC;

/*
6.Young offense players without contract
*/

SELECT p.id, concat_ws(' ', p.first_name, p.last_name) AS full_name, p.age, p.position, p.hire_date
FROM players AS p
JOIN skills_data AS sd
ON p.skills_data_id = sd.id
WHERE age < 23 AND position LIKE 'A' AND hire_date IS NULL AND sd.strength > 50
ORDER BY salary, age;

/*
7.Detail info for all teams
*/

SELECT t.name, t.established, t.fan_base , count(p.id) AS players_count
FROM teams AS t
LEFT JOIN players As p
ON t.id = p.team_id
GROUP BY t.id
ORDER BY players_count DESC, t.fan_base DESC;

/*
8.The fastest player by towns
*/

SET sql_mode = 'ONLY_FUll_GROUP_BY';

SELECT max(sd.speed) AS max_speed, t.name
FROM towns AS t
LEFT JOIN stadiums AS s ON t.id = s.town_id
LEFT JOIN teams AS tm ON s.id = tm.stadium_id
LEFT JOIN players AS p ON tm.id = p.team_id
LEFT JOIN skills_data AS sd ON p.skills_data_id = sd.id
WHERE tm.name != 'Devify'
GROUP BY t.name
ORDER BY max_speed DESC, t.name;

/*
9.Total salaries and players by country
*/

SELECT c.name, count(p.id) AS total_count_of_players, sum(p.salary) AS total_sum_of_salaries
FROM countries AS c
LEFT JOIN towns AS t ON c.id = t.country_id
LEFT JOIN stadiums AS s ON t.id = s.town_id
LEFT JOIN teams AS tm ON s.id = tm.stadium_id
LEFT JOIN players AS p ON tm.id = p.team_id
GROUP BY c.id
ORDER BY total_count_of_players DESC, c.name;

/*
Section 4: Programmability – 30 pts
*/

/*
10.Find all players that play on stadium
*/

DELIMITER $$
CREATE FUNCTION udf_stadium_players_count (stadium_name VARCHAR(30)) 
RETURNS INT
DETERMINISTIC
BEGIN
RETURN	(SELECT count(p.id)
		FROM players As p
		JOIN teams AS t ON p.team_id = t.id
		JOIN stadiums As s ON t.stadium_id = s.id
		WHERE s.name = stadium_name);
END
$$
DELIMITER ;
SELECT udf_stadium_players_count ('Jaxworks') AS count;

/*
11.Find good playmaker by teams
*/

DELIMITER $$
CREATE PROCEDURE udp_find_playmaker(min_dribble_points INT, team_name VARCHAR(45))
BEGIN
	SELECT concat_ws(' ', p.first_name, p.last_name) AS full_name, p.age, p.salary, sd.dribbling, sd.speed, t.name AS team_name
	FROM players AS p
	JOIN skills_data AS sd ON p.skills_data_id = sd.id
	JOIN teams AS t ON p.team_id = t.id
	WHERE sd.dribbling > min_dribble_points AND t.name = team_name AND sd.speed > (SELECT AVG(speed) FROM skills_data)
    ORDER BY sd.speed DESC LIMIT 1;
END
$$

CALL udp_find_playmaker (20, 'Skyble')
