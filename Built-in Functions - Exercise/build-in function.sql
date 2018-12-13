#########################################################

SELECT e.first_name, e.last_name FROM `employees` AS e
WHERE `first_name` LIKE 'Sa%'
ORDER BY `employee_id`;

#########################################################

SELECT e.first_name, e.last_name FROM `employees` AS e
WHERE `last_name` LIKE '%ei%'
ORDER BY `employee_id`;

#######################################################

SELECT e.first_name FROM `employees` AS e
WHERE (`department_id` = 3 OR `department_id` = 10) AND (`hire_date` BETWEEN '1995-01-01' AND '2005-12-31')
ORDER BY `employee_id`;

#######################################################

SELECT e.first_name, e.last_name FROM `employees` AS e
WHERE `job_title` NOT LIKE '%engineer%'
ORDER BY `employee_id`;

##########################################################

SELECT t.name FROM `towns` AS t
WHERE char_length(`name`) = 5 OR char_length(`name`) = 6
ORDER BY `name`;

########################################################

SELECT * FROM `towns`
WHERE `name` LIKE 'M%' OR `name` LIKE 'B%' OR `name` LIKE 'K%' OR `name` LIKE 'E%'
ORDER BY `name`;

######################################################

SELECT * FROM `towns`
WHERE lower(LEFT(`name`, 1)) IN ('m', 'b', 'k', 'e')
ORDER BY `name`;

#######################################################

SELECT * FROM `towns`
WHERE NOT (`name` LIKE 'B%' OR `name` LIKE 'R%' OR `name` LIKE 'D%')
ORDER BY `name`;

######################################################

CREATE VIEW `v_employees_hired_after_2000` AS
SELECT e.first_name, e.last_name FROM `employees` AS e
WHERE `hire_date` > '2000-12-31';

#########################################################

SELECT e.first_name, e.last_name FROM `employees` AS e
WHERE char_length(`last_name`) = 5;

##########################################################

SELECT c.country_name, c.iso_code FROM `countries` AS c
WHERE `country_name` LIKE '%A%a%a%'
ORDER BY `iso_code`;

##########################################################

SELECT 
    p.peak_name,
    r.river_name,
    CONCAT(LOWER(`peak_name`),
            LOWER(SUBSTRING(`river_name`, 2))) AS 'mix'
FROM
    `peaks` AS p,
    `rivers` AS r
WHERE
    RIGHT(`peak_name`, 1) = LEFT(`river_name`, 1)
ORDER BY `mix`;

#############################################################

SELECT g.name, date_format(g.start, '%Y-%m-%d') FROM `games` AS g
WHERE `start` LIKE '2011%' OR `start` LIKE '2012%'
ORDER BY `start`, `name`
LIMIT 50;

##################################################################

SELECT u.user_name, substring(`email`, locate('@', `email`) + 1) AS 'Email Provider' FROM `users` u
ORDER BY `Email Provider`, `user_name`;

###################################################################

SELECT u.user_name, u.ip_address FROM `users` AS u
WHERE `ip_address` LIKE '___.1%.%.___'
ORDER BY `user_name`;

#################################################################

SELECT 
    g.name,
    (CASE
        WHEN
            EXTRACT(HOUR FROM g.start) >= 00
                AND EXTRACT(HOUR FROM g.start) < 12
        THEN
            'Morning'
        WHEN
            EXTRACT(HOUR FROM g.start) >= 12
                AND EXTRACT(HOUR FROM g.start) < 18
        THEN
            'Afternoon'
        WHEN
            EXTRACT(HOUR FROM g.start) >= 18
                AND EXTRACT(HOUR FROM g.start) < 24
        THEN
            'Evening'
    END) AS 'Part of the Day',
    (CASE
        WHEN g.duration <= 3 THEN 'Extra Short'
        WHEN g.duration BETWEEN 3 AND 6 THEN 'Short'
        WHEN g.duration BETWEEN 6 AND 10 THEN 'Long'
        ELSE 'Extra Long'
    END) AS 'Duration'
FROM
    `games` AS g;

##################################################################
	
SELECT 
    `product_name`,
    `order_date`,
    DATE_ADD(`order_date`, INTERVAL 3 DAY) AS 'pay_due',
    DATE_ADD(`order_date`, INTERVAL 1 MONTH) AS 'deliver_due'
FROM
    `orders`;