###########################1

DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above_35000 ()
BEGIN
SELECT e.first_name, e.last_name FROM `employees` AS e
WHERE e.salary > 35000
ORDER BY e.first_name, e.last_name, e.employee_id;
END $$
DELIMITER ;

CALL usp_get_employees_salary_above_35000();

##########################2

DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above (salary_number DECIMAL(19,4))
BEGIN
SELECT e.first_name, e.last_name FROM `employees` AS e
WHERE e.salary >= salary_number
ORDER BY e.first_name, e.last_name, e.employee_id;
END $$
DELIMITER ;

CALL usp_get_employees_salary_above (48100);

###########################3

DELIMITER $$
CREATE PROCEDURE usp_get_towns_starting_with (town_starting_with VARCHAR(50))
BEGIN
SELECT t.name AS 'town_name' FROM `towns` AS t
WHERE lower(t.name) LIKE lower(CONCAT(town_starting_with, '%'))
ORDER BY t.name;
END $$
DELIMITER ;

CALL usp_get_towns_starting_with ('cal');

##########################4

DELIMITER $$
CREATE PROCEDURE usp_get_employees_from_town (town_name VARCHAR(50))
BEGIN
SELECT e.first_name, e.last_name FROM `employees` AS e
INNER JOIN `addresses` AS a ON e.address_id = a.address_id
INNER JOIN `towns` AS t ON a.town_id = t.town_id
WHERE t.name = town_name
ORDER BY e.first_name, e.last_name, e.employee_id;
END $$
DELIMITER ;

CALL usp_get_employees_from_town ('Sofia');

###########################5

DELIMITER $$
CREATE FUNCTION ufn_get_salary_level (employee_salary DECIMAL(19,4))
RETURNS VARCHAR(20)
BEGIN
	DECLARE salary_level VARCHAR(20);
	IF (employee_salary < 30000) THEN
    SET salary_level := 'Low';
    ELSEIF (employee_salary <= 50000) THEN
    SET salary_level := 'Average';
    ELSE
    SET salary_level := 'High';
    END IF;
    RETURN salary_level;
END $$
DELIMITER ;

SELECT e.first_name, ufn_get_salary_level(e.salary) FROM `employees` AS e;

##############################6

DELIMITER $$
CREATE PROCEDURE usp_get_employees_by_salary_level (salary_level VARCHAR(50))
BEGIN
	SELECT e.first_name, e.last_name FROM `employees` AS e
	WHERE lower(ufn_get_salary_level (e.salary)) = lower(salary_level)
    ORDER BY e.first_name DESC, e.last_name DESC;
END $$
DELIMITER ;

CALL usp_get_employees_by_salary_level ('high');

!!!!!!!!!!!!!!

DELIMITER $$
CREATE PROCEDURE usp_get_employees_by_salary_level (salary_level VARCHAR(50))
BEGIN
	SELECT e.first_name, e.last_name FROM `employees` AS e
	WHERE lower(
    CASE 
		WHEN e.salary < 30000 THEN 'low'
		WHEN e.salary <= 50000 THEN 'average'
		ELSE 'high'
    END) = lower(salary_level)
    ORDER BY e.first_name DESC, e.last_name DESC;
END $$
DELIMITER ;

#############################7

DELIMITER $$
CREATE FUNCTION ufn_is_word_comprised(set_of_letters varchar(50), word varchar(50))
RETURNS BIT
BEGIN
	DECLARE result BIT;
    DECLARE word_length INT;
    DECLARE current_index INT;
    
    SET word_length := char_length(word);
    SET current_index := 1;
    SET result := 1;
    
    WHILE (current_index <= word_length) DO
		IF (set_of_letters NOT LIKE (concat('%', SUBSTR(word, current_index, 1), '%'))) THEN
			SET result := 0;
        END IF;
        SET current_index := current_index + 1;
    END WHILE;
    
    RETURN result;
END $$
DELIMITER ;

SELECT ufn_is_word_comprised ('bobr', 'Rob');

!!!!!!!!!!!!!!!!

DELIMITER $$
CREATE FUNCTION ufn_is_word_comprised(set_of_letters varchar(50), word varchar(50))
RETURNS BIT
BEGIN
	RETURN word REGEXP (CONCAT('^[', set_of_letters, ']+$'));
END $$
DELIMITER ;

##############################8

DELIMITER $$
CREATE PROCEDURE usp_get_holders_full_name ()
BEGIN
	SELECT concat(ah.first_name, ' ', ah.last_name) AS 'full_name' FROM `account_holders` AS ah
    ORDER BY `full_name`, ah.id;
END $$
DELIMITER ;

#############################9

DELIMITER $$
CREATE PROCEDURE usp_get_holders_with_balance_higher_than (input_number DECIMAL(12,4))
BEGIN
	SELECT 
    ah.first_name, ah.last_name
	FROM
    `account_holders` AS ah
        INNER JOIN
    (SELECT 
        a.id, a.account_holder_id, SUM(a.balance) AS 'total'
    FROM
        `accounts` AS a
    GROUP BY a.account_holder_id) AS `total_sum` ON ah.id = total_sum.account_holder_id
	WHERE
    total_sum.total > input_number
ORDER BY total_sum.id , ah.first_name , ah.last_name;
END $$
DELIMITER ;

##############################10

DELIMITER $$
CREATE FUNCTION ufn_calculate_future_value (initial_sum DECIMAL(20,10), yearly_interest_rate DOUBLE, number_of_years INT)
RETURNS DOUBLE
BEGIN
	DECLARE result DOUBLE;
    SET result := initial_sum * (pow((1 + yearly_interest_rate), number_of_years));
    RETURN result;
END $$
DELIMITER ;

SELECT ufn_calculate_future_value (1000,0.1,5);

############################11

DELIMITER $$
CREATE PROCEDURE usp_calculate_future_value_for_account(
    acc_id INT(11),
    rate DECIMAL(19,4))
BEGIN
    DECLARE value DECIMAL(19,4);
    DECLARE balance DECIMAL(19,4);
    SET balance := (SELECT a.balance FROM `accounts` AS a WHERE a.id = acc_id);
    SET value := balance * (pow(1 + rate, 5));
SELECT 
    a.id AS 'account_id',
    ah.first_name,
    ah.last_name,
    balance AS 'current_balance',
    value AS 'balance_in_5_years'
FROM
    accounts AS a
        JOIN
    account_holders AS ah ON a.account_holder_id = ah.id
        AND a.id = acc_id;
END $$
DELIMITER ;

############################12

DELIMITER $$
CREATE PROCEDURE usp_deposit_money (account_id INT, money_amount DECIMAL)
BEGIN
    START TRANSACTION;
		UPDATE accounts AS ac
		SET ac.balance = ac.balance + money_amount
		WHERE ac.id = account_id;
    IF (
		SELECT a.balance
		FROM accounts as a
		WHERE a.id = account_id
		) >= 0 THEN
		COMMIT;
    ELSE
		ROLLBACK;
    END IF;
END $$
DELIMITER ;

CALL usp_deposit_money(1,10);

##############################13

DELIMITER $$
CREATE PROCEDURE usp_withdraw_money (account_id INT, money_amount DECIMAL(20,4))
BEGIN
	IF (money_amount >= 0) THEN
		START TRANSACTION;
        IF ((SELECT COUNT(a.id) FROM `accounts` AS a
			WHERE a.id LIKE account_id) <> 1) THEN
		ROLLBACK;
        ELSEIF ((SELECT a.balance FROM `accounts` AS a 
            WHERE a.id = account_id) < money_amount) THEN
		ROLLBACK;
		ELSE UPDATE `accounts` AS a
			SET a.balance = a.balance - money_amount
            WHERE a.id = account_id;
		END IF;
	END IF;
END $$
DELIMITER ;

CALL usp_withdraw_money(1,15);

#############################14

DELIMITER $$
CREATE PROCEDURE usp_transfer_money(from_account_id INT, to_account_id INT, amount DECIMAL(20,4))
BEGIN
	DECLARE new_amount DECIMAL(20,4);
    IF (amount >= 0) THEN
		START TRANSACTION;
        SET new_amount := (SELECT a.balance FROM `accounts` AS a
				WHERE a.id = from_account_id);
		IF ((SELECT COUNT(a.id) FROM `accounts` AS a
			WHERE a.id LIKE from_account_id) <> 1) THEN
        ROLLBACK;
        ELSEIF ((SELECT COUNT(a.id) FROM `accounts` AS a
			WHERE a.id LIKE to_account_id) <> 1) THEN
		ROLLBACK;
        ELSEIF (new_amount < amount) THEN
		ROLLBACK;
        ELSE UPDATE `accounts` AS a
			SET a.balance = a.balance + amount
            WHERE a.id = to_account_id;
            UPDATE `accounts` AS a
            SET a.balance = a.balance - amount
            WHERE a.id = from_account_id;
		END IF;
	END IF;
END $$
DELIMITER ;

CALL usp_transfer_money(1,2,10);

#########################15

CREATE TABLE logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT,
    old_sum DECIMAL(20,4),
    new_sum DECIMAL(20,4)
);

DELIMITER $$
CREATE TRIGGER tr_update_accounts
AFTER UPDATE
ON `accounts`
FOR EACH ROW
BEGIN
	INSERT INTO `logs` (account_id, old_sum, new_sum)
    VALUES (OLD.id, OLD.balance, NEW.balance);
END $$
DELIMITER ;

UPDATE `accounts` AS a
SET a.balance = a.balance - 10
WHERE a.id = 2;

########################16

DELIMITER $$
CREATE TRIGGER tr_insert_logs
AFTER INSERT
ON `logs`
FOR EACH ROW
BEGIN
	DECLARE new_subject VARCHAR(50);
    DECLARE new_body VARCHAR(90);
    SET new_subject := concat('Balance change for account: ',NEW.account_id);
    SET new_body := concat('On ', NOW(), ' your balance was changed from ', NEW.old_sum, ' to ', NEW.new_sum, '.');
	INSERT INTO `notification_emails` (recipient, subject, body)
    VALUES (NEW.account_id, new_subject, new_body);
END $$
DELIMITER ;