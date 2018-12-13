SELECT 
    e.employee_id, e.job_title, a.address_id, a.address_text
FROM
    `employees` AS e
        INNER JOIN
    `addresses` AS a ON e.address_id = a.address_id
ORDER BY a.address_id
LIMIT 5;

#################

SELECT 
    e.first_name, e.last_name, t.name, a.address_text
FROM
    `employees` AS e
        INNER JOIN
    `addresses` AS a ON e.address_id = a.address_id
        INNER JOIN
    `towns` AS t ON a.town_id = t.town_id
ORDER BY e.first_name , e.last_name
LIMIT 5;

#################

SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    d.name AS 'department_name'
FROM
    `employees` AS e
        INNER JOIN
    `departments` AS d ON e.department_id = d.department_id
WHERE
    d.name = 'Sales'
ORDER BY e.employee_id DESC;

##################

SELECT 
    e.employee_id,
    e.first_name,
    e.salary,
    d.name AS 'department_id'
FROM
    `employees` AS e
        INNER JOIN
    `departments` AS d ON e.department_id = d.department_id
WHERE
    e.salary > 15000
ORDER BY e.department_id DESC , e.employee_id
LIMIT 5;

##################

SELECT 
    e.employee_id, e.first_name
FROM
    `employees` AS e
        LEFT OUTER JOIN
    `employees_projects` AS ep ON e.employee_id = ep.employee_id
WHERE
    ep.employee_id IS NULL
ORDER BY e.employee_id DESC
LIMIT 3;

###################

SELECT 
    e.first_name,
    e.last_name,
    e.hire_date,
    d.name AS 'dept_name'
FROM
    `employees` AS e
        INNER JOIN
    `departments` AS d ON e.department_id = d.department_id
WHERE
    DATE(e.hire_date) > '1999/1/1'
        AND d.name IN ('Sales' , 'Finance')
ORDER BY e.hire_date;

#######################

SELECT 
    e.employee_id, e.first_name, p.name AS 'project_name'
FROM
    `employees` AS e
        INNER JOIN
    `employees_projects` AS ep ON e.employee_id = ep.employee_id
        INNER JOIN
    `projects` AS p ON p.project_id = ep.project_id
WHERE
    DATE(p.start_date) > '2002/08/13'
        AND p.end_date IS NULL
ORDER BY e.first_name , p.name
LIMIT 5;

###################

SELECT 
    e.employee_id,
    e.first_name,
    (CASE
        WHEN p.start_date >= '2005-01-01' THEN p.name = NULL
        ELSE p.name
    END) AS 'project_name'
FROM
    `employees` AS e
        INNER JOIN
    `employees_projects` AS ep ON e.employee_id = ep.employee_id
        INNER JOIN
    `projects` AS p ON p.project_id = ep.project_id
WHERE
    e.employee_id = 24
ORDER BY p.name;

#####################

SELECT 
    e.employee_id, e.first_name, e.manager_id, emp.first_name
FROM
    `employees` AS e
        INNER JOIN
    `employees` AS emp ON e.manager_id = emp.employee_id
WHERE
    e.manager_id IN (3 , 7)
ORDER BY e.first_name;

######################

SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS 'employee_name',
    CONCAT(emp.first_name, ' ', emp.last_name) AS 'manager_name',
    d.name AS 'department_name'
FROM
    `employees` AS e
        INNER JOIN
    `employees` AS emp ON e.manager_id = emp.employee_id
        INNER JOIN
    `departments` AS d ON e.department_id = d.department_id
ORDER BY e.employee_id
LIMIT 5;

#########################

SELECT 
    AVG(e.salary) AS 'min_average_salary'
FROM
    `employees` AS e
GROUP BY e.department_id
ORDER BY `min_average_salary`
LIMIT 1;

########################

SELECT 
    c.country_code, m.mountain_range, p.peak_name, p.elevation
FROM
    `countries` AS c
        INNER JOIN
    `mountains_countries` AS mc ON c.country_code = mc.country_code
        AND c.country_code = 'BG'
        INNER JOIN
    `mountains` AS m ON m.id = mc.mountain_id
        INNER JOIN
    `peaks` AS p ON p.mountain_id = mc.mountain_id
        AND p.elevation > 2835
ORDER BY p.elevation DESC;

#########################

SELECT 
    c.country_code, COUNT(m.mountain_range) AS 'mountain_range'
FROM
    `countries` AS c
        INNER JOIN
    `mountains_countries` AS mc ON c.country_code = mc.country_code
        AND c.iso_code IN ('RUS' , 'USA', 'BGR')
        INNER JOIN
    `mountains` AS m ON m.id = mc.mountain_id
GROUP BY c.country_code
ORDER BY `mountain_range` DESC;

##########################

SELECT 
    c.country_name, r.river_name
FROM
    `countries` AS c
        LEFT OUTER JOIN
    `countries_rivers` AS cr ON c.country_code = cr.country_code
        LEFT OUTER JOIN
    `rivers` AS r ON cr.river_id = r.id
WHERE
    c.continent_code = 'AF'
ORDER BY c.country_name
LIMIT 5;

############################

SELECT 
    c.continent_code,
    c.currency_code,
    COUNT(c.currency_code) AS 'count_currency'
FROM
    `countries` AS c
GROUP BY c.continent_code , c.currency_code
HAVING `count_currency` = (SELECT 
        COUNT(c1.currency_code) AS 'count_currency'
    FROM
        `countries` AS c1
    WHERE
        c1.continent_code = c.continent_code
    GROUP BY c1.currency_code
    ORDER BY `count_currency` DESC
    LIMIT 1)
    AND `count_currency` > 1
ORDER BY c.continent_code , c.currency_code;

############################

SELECT 
    COUNT(c.country_code) AS 'country_count'
FROM
    `countries` AS c
        LEFT OUTER JOIN
    `mountains_countries` AS mc ON c.country_code = mc.country_code
WHERE
    mc.country_code IS NULL;
	
#############################

SELECT 
    c.country_name,
    MAX(p.elevation) AS 'highest_peak_elevation',
    MAX(r.length) AS 'longest_river_length'
FROM
    `countries` AS c
        INNER JOIN
    `mountains_countries` AS mc ON c.country_code = mc.country_code
        INNER JOIN
    `countries_rivers` AS cr ON c.country_code = cr.country_code
        INNER JOIN
    `peaks` AS p ON mc.mountain_id = p.mountain_id
        INNER JOIN
    `rivers` AS r ON cr.river_id = r.id
GROUP BY c.country_name
ORDER BY `highest_peak_elevation` DESC , `longest_river_length` DESC , c.country_name
LIMIT 5;