#########################################

SELECT COUNT(*) AS 'count' FROM `wizzard_deposits`;

##########################################

SELECT MAX(a.magic_wand_size) AS 'longest_magic_wand' FROM `wizzard_deposits` AS a;

############################################

SELECT 
    a.deposit_group,
    MAX(a.magic_wand_size) AS 'longest_magic_wand'
FROM
    `wizzard_deposits` AS a
GROUP BY a.deposit_group
ORDER BY `longest_magic_wand` , a.deposit_group;

#################################################

SELECT 
    a.deposit_group
FROM
    `wizzard_deposits` AS a
GROUP BY a.deposit_group
ORDER BY AVG(a.magic_wand_size)
LIMIT 1;

##################################################

SELECT 
    a.deposit_group, SUM(a.deposit_amount) AS 'total_sum'
FROM
    `wizzard_deposits` AS a
GROUP BY a.deposit_group
ORDER BY `total_sum`;

###################################################

SELECT 
    a.deposit_group, SUM(a.deposit_amount) AS 'total_sum'
FROM
    `wizzard_deposits` AS a
WHERE
    a.magic_wand_creator = 'Ollivander family'
GROUP BY a.deposit_group
ORDER BY a.deposit_group;

#####################################################

SELECT 
    a.deposit_group, SUM(a.deposit_amount) AS 'total_sum'
FROM
    `wizzard_deposits` AS a
WHERE
    a.magic_wand_creator = 'Ollivander family'
GROUP BY a.deposit_group
HAVING `total_sum` < 150000
ORDER BY `total_sum` DESC;

######################################################

SELECT 
    a.deposit_group,
    a.magic_wand_creator,
    MIN(a.deposit_charge) AS 'min_deposit_charge'
FROM
    `wizzard_deposits` AS a
GROUP BY a.deposit_group , a.magic_wand_creator
ORDER BY a.magic_wand_creator , a.deposit_group;

#######################################################

SELECT 
    (CASE
        WHEN a.age BETWEEN 0 AND 10 THEN '[0-10]'
        WHEN a.age BETWEEN 11 AND 20 THEN '[11-20]'
        WHEN a.age BETWEEN 21 AND 30 THEN '[21-30]'
        WHEN a.age BETWEEN 31 AND 40 THEN '[31-40]'
        WHEN a.age BETWEEN 41 AND 50 THEN '[41-50]'
        WHEN a.age BETWEEN 51 AND 60 THEN '[51-60]'
        ELSE '[61+]'
    END) AS 'age_group',
    COUNT(a.age) AS 'wizard_count'
FROM
    `wizzard_deposits` AS a
GROUP BY `age_group`
ORDER BY `age_group`;

#######################################################

SELECT 
    LEFT(a.first_name, 1) AS 'first_letter'
FROM
    `wizzard_deposits` AS a
WHERE
    a.deposit_group = 'Troll Chest'
GROUP BY `first_letter`
ORDER BY `first_letter`;

##########################################################

SELECT 
    a.deposit_group,
    a.is_deposit_expired,
    AVG(a.deposit_interest) AS 'average_interest'
FROM
    `wizzard_deposits` AS a
WHERE
    a.deposit_start_date > '1985-01-01'
GROUP BY a.deposit_group , a.is_deposit_expired
ORDER BY a.deposit_group DESC , a.is_deposit_expired;

######################################################

SELECT 
    SUM(w1.deposit_amount - w2.deposit_amount) AS `sum_difference`
FROM
    `wizzard_deposits` AS w1,
    `wizzard_deposits` AS w2
WHERE
    w2.id = w1.id + 1;

#######################################################

SELECT 
    e.department_id, MIN(e.salary) AS 'minimum_salary'
FROM
    `employees` AS e
WHERE
    e.department_id IN (2 , 5, 7)
        AND e.hire_date > '200-01-01'
GROUP BY e.department_id
ORDER BY e.department_id ASC;

#########################################################

CREATE TABLE `high_paid_employees` LIKE `employees`;

##########################################################

INSERT INTO `high_paid_employees`
SELECT * FROM `employees`
WHERE `salary` > 30000;

#########################################################

DELETE FROM `high_paid_employees`
WHERE `manager_id` = 42;

###########################################################

UPDATE `high_paid_employees`
SET `salary` = `salary` + 5000
WHERE `department_id` = 1;

###########################################################

SELECT 
    a.department_id, AVG(a.salary)
FROM
    `high_paid_employees` AS a
GROUP BY a.department_id
ORDER BY a.department_id;
#######################################################

SELECT e.department_id, MAX(e.salary) AS `max_salary` FROM `employees` AS e
WHERE e.salary NOT BETWEEN 30000 AND 70000
GROUP BY e.department_id
ORDER BY e.department_id;

#######################################################

SELECT COUNT(e.employee_id) AS `count_employee` FROM `employees` AS e
WHERE `manager_id` IS NULL;

########################################################

SELECT 
    e1.department_id,
    (SELECT 
            e2.salary
        FROM
            `employees` AS e2
        WHERE
            e2.department_id = e1.department_id
        GROUP BY e2.salary
        ORDER BY e2.salary DESC
        LIMIT 2 , 1) AS `third_highest_salary`
FROM
    `employees` AS e1
GROUP BY e1.department_id
HAVING `third_highest_salary` IS NOT NULL
ORDER BY e1.department_id;

#######################################################

SELECT 
    e.first_name, e.last_name, e.department_id
FROM
    `employees` AS e,
    (SELECT 
        e.department_id, AVG(e.salary) AS `average_salary`
    FROM
        `employees` AS e
    GROUP BY e.department_id) AS `average_by_department`
WHERE
    e.department_id = average_by_department.department_id
        AND e.salary > average_by_department.average_salary
ORDER BY e.department_id
LIMIT 10;

#######################################################

SELECT e.department_id, SUM(e.salary) AS `total_salary` FROM `employees` AS e
GROUP BY e.department_id
ORDER BY e.department_id;