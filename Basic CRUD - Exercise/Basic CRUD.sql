##########################################

SELECT * FROM departments ORDER BY department_id;

##########################################

SELECT `name` FROM departments ORDER BY department_id;

###########################################

SELECT e.first_name, e.last_name, e.salary FROM employees AS e ORDER BY employee_id;

###########################################

SELECT e.first_name, e.middle_name, e.last_name FROM employees AS e ORDER BY employee_id;

###########################################

SELECT concat(first_name,'.',last_name,'@softuni.bg') AS 'full_email_address' FROM employees;

###############################################

SELECT DISTINCT `salary` FROM employees;

#############################################

SELECT * FROM employees
WHERE `job_title` = 'Sales Representative'
ORDER BY employee_id;

###################################################

SELECT e.first_name, e.last_name, e.job_title FROM employees AS e
WHERE `salary` BETWEEN 20000 AND 30000;

##################################################

SELECT concat_ws(' ', first_name, middle_name, last_name) AS 'Full Name' FROM employees
WHERE `salary` IN (25000, 14000, 12500, 23600);

###################################################

SELECT e.first_name, e.last_name FROM employees AS e
WHERE `manager_id` IS NULL;

#####################################################

SELECT e.first_name, e.last_name, e.salary FROM employees AS e
WHERE `salary` > 50000
ORDER BY `salary` DESC;

###################################################

SELECT e.first_name, e.last_name FROM employees AS e
ORDER BY `salary` DESC
LIMIT 5;

####################################################

SELECT e.first_name, e.last_name FROM employees AS e
WHERE `department_id` != 4;

#####################################################

SELECT * FROM employees
ORDER BY `salary` DESC,
`first_name`,
`last_name` DESC,
`middle_name`;

######################################################

CREATE VIEW `v_employees_salaries` AS
SELECT e.first_name, e.last_name, e.salary FROM employees AS e;

CREATE VIEW `v_employees_job_titles` AS
    SELECT 
        concat_ws(' ', `first_name`,
                (CASE
                    WHEN `middle_name` IS NULL THEN ''
                    ELSE `middle_name`
                END),
                `last_name`) AS 'full_name',
        `job_title`
    FROM
        `employees`;

############################################################
        
CREATE VIEW `v_employees_job_titles` AS
    SELECT 
        CONCAT_WS(' ',
                `first_name`,
                IFNULL(`middle_name`, ''),
                `last_name`) AS 'full_name',
        `job_title`
    FROM
        `employees`;

##############################################################

SELECT DISTINCT `job_title` FROM `employees` ORDER BY `job_title`;

#############################################################

SELECT * FROM `projects` 
ORDER BY `start_date`, `name`
LIMIT 10;

##############################################################

SELECT e.first_name, e.last_name, e.hire_date FROM `employees` AS e
ORDER BY `hire_date` DESC
LIMIT 7;

###############################################################

UPDATE `employees`
SET salary = salary * 1.12
WHERE `department_id` IN (1,2,4,11);

############################################################

SELECT e.salary FROM `employees` AS e;

########################################################

SELECT p.peak_name FROM `peaks` AS p
ORDER BY `peak_name`;

##########################################################

SELECT c.country_name, c.population FROM `countries` AS c
WHERE `continent_code` = 'EU'
ORDER BY `population` DESC,
`country_name`
LIMIT 30;

###########################################################

SELECT 
    c.country_name,
    c.country_code,
    (CASE
        WHEN c.currency_code != 'EUR' THEN 'Not Euro'
        WHEN c.currency_code = 'EUR' THEN 'Euro'
    END) AS `currency`
FROM
    `countries` AS c
ORDER BY `country_name`;

###########################################################

SELECT `name` FROM `characters`
ORDER BY `name`;