CREATE TABLE `planets` (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL
);

CREATE TABLE `spaceports` (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    planet_id INT,
    CONSTRAINT fk_spaceports_planets FOREIGN KEY (planet_id)
        REFERENCES `planets` (id)
);

CREATE TABLE `spaceships` (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    manufacturer VARCHAR(30) NOT NULL,
    light_speed_rate INT DEFAULT 0
);

CREATE TABLE `colonists` (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    ucn CHAR(10) NOT NULL UNIQUE,
    birth_date DATE NOT NULL
);

CREATE TABLE `journeys` (
    id INT PRIMARY KEY AUTO_INCREMENT,
    journey_start DATETIME NOT NULL,
    journey_end DATETIME NOT NULL,
    purpose ENUM('Medical', 'Technical', 'Educational', 'Military'),
    destination_spaceport_id INT,
    spaceship_id INT,
    CONSTRAINT fk_journeys_spaceports FOREIGN KEY (destination_spaceport_id)
        REFERENCES `spaceports` (id),
    CONSTRAINT fk_journeys_spaceships FOREIGN KEY (spaceship_id)
        REFERENCES `spaceships` (id)
);

CREATE TABLE `travel_cards` (
    id INT PRIMARY KEY AUTO_INCREMENT,
    card_number CHAR(10) NOT NULL UNIQUE,
    job_during_journey ENUM('Pilot', 'Engineer', 'Trooper', 'Cleaner', 'Cook'),
    colonist_id INT,
    journey_id INT,
    CONSTRAINT fk_travel_cards_colonists FOREIGN KEY (colonist_id)
        REFERENCES `colonists` (id),
    CONSTRAINT fk_travel_cards_journeys FOREIGN KEY (journey_id)
        REFERENCES `journeys` (id)
);

#########################################

SELECT tc.card_number, tc.job_during_journey FROM `travel_cards` AS tc
ORDER BY tc.card_number;

#######################################

SELECT c.id, concat(c.first_name, ' ', c.last_name) AS `full_name`, c.ucn FROM `colonists` AS c
ORDER BY c.first_name, c.last_name, c.id;

#######################################

SELECT j.id, j.journey_start, j.journey_end FROM `journeys` AS j
WHERE j.purpose = 'Military'
ORDER BY DATE(j.journey_start);

########################################

SELECT c.id, concat(c.first_name, ' ', c.last_name) AS `full_name` FROM `colonists` AS c
INNER JOIN `travel_cards` AS tc ON c.id = tc.colonist_id
WHERE tc.job_during_journey = 'Pilot'
ORDER BY c.id;

########################################

SELECT COUNT(*) AS `count` FROM `colonists` AS c
INNER JOIN `travel_cards` AS tc ON c.id = tc.colonist_id
INNER JOIN `journeys` AS j ON tc.journey_id = j.id
WHERE j.purpose = 'Technical';

########################################

SELECT s.name, sp.name FROM `spaceships` AS s
INNER JOIN `journeys` AS j ON s.id = j.spaceship_id
INNER JOIN `spaceports` AS sp ON j.destination_spaceport_id = sp.id
ORDER BY s.light_speed_rate DESC
LIMIT 1;

######################################

SELECT s.name, s.manufacturer FROM `spaceships` AS s
INNER JOIN `journeys` AS j ON s.id = spaceship_id
INNER JOIN `travel_cards` AS tc ON j.id = tc.journey_id
INNER JOIN `colonists` AS c ON tc.colonist_id = c.id
WHERE tc.job_during_journey = 'Pilot' AND c.birth_date > '1989-01-01'
ORDER BY s.name;

#########################################

SELECT p.name, s.name FROM `planets` AS p
INNER JOIN `spaceports` AS s ON p.id = s.planet_id
INNER JOIN `journeys` AS j ON s.id = j.destination_spaceport_id
WHERE j.purpose = 'Educational'
ORDER BY s.name DESC;

########################################

SELECT p.name AS `planet_name`, COUNT(p.id) AS `journeys_count` FROM `planets` AS p
INNER JOIN `spaceports` AS s ON p.id = s.planet_id
INNER JOIN `journeys` AS j ON s.id = j.destination_spaceport_id
GROUP BY p.name
ORDER BY `journeys_count` DESC, `planet_name`;

#######################################

SELECT  `diference`.id, p.name, s.name, `diference`.purpose FROM `planets` AS p
INNER JOIN `spaceports` AS s ON p.id = s.planet_id
INNER JOIN
(SELECT *, TIMESTAMPDIFF(SECOND, j.journey_start, j.journey_end) AS `seconds_dif` FROM `journeys` AS j) AS `diference` ON s.id = `diference`.destination_spaceport_id
ORDER BY `diference`.`seconds_dif`
LIMIT 1;

######################################

DELIMITER $$
CREATE FUNCTION udf_count_colonists_by_destination_planet (planet_name VARCHAR (30))
RETURNS INT
BEGIN
	DECLARE colonist_count INT;
    SET colonist_count := (SELECT COUNT(*) AS `count` FROM `planets` AS p
    INNER JOIN `spaceports` AS s ON p.id = planet_id
    INNER JOIN `journeys` AS j ON s.id = j.destination_spaceport_id
    INNER JOIN `travel_cards` AS tc ON j.id = tc.journey_id
    INNER JOIN `colonists` AS c ON tc.colonist_id = c.id
    WHERE p.name = planet_name);
    RETURN colonist_count;
END $$
DELIMITER ;

SELECT p.name, udf_count_colonists_by_destination_planet('Otroyphus') AS `count` FROM `planets` AS p
WHERE p.name = 'Otroyphus';

####################################

DELIMITER $$
CREATE PROCEDURE udp_modify_spaceship_light_speed_rate (spaceship_name VARCHAR(50), light_speed_rate_increse INT(11))
BEGIN
    IF ((SELECT COUNT(*) FROM `spaceships` AS s WHERE s.name = spaceship_name) <> 1) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Spaceship you are trying to modify does not exists.';
    END IF;
    
    UPDATE `spaceships` AS s
    SET s.light_speed_rate = s.light_speed_rate + light_speed_rate_increse
    WHERE s.name = spaceship_name;
END $$
DELIMITER ;


CALL udp_modify_spaceship_light_speed_rate ('Na Pesho koraba', 1914);
SELECT s.name, s.light_speed_rate FROM `spaceships` AS s WHERE name = 'Na Pesho koraba';

CALL udp_modify_spaceship_light_speed_rate ('USS Templar', 5);
SELECT s.name, s.light_speed_rate FROM `spaceships` AS s WHERE name = 'USS Templar';

#####################################

INSERT INTO `travel_cards` (card_number, job_during_journey, colonist_id, journey_id)
SELECT 
CASE
	WHEN c.birth_date > '1980-01-01' THEN concat(YEAR(c.birth_date), DAY(c.birth_date), LEFT(c.ucn, 4))
    ELSE concat(YEAR(c.birth_date), MONTH(c.birth_date), RIGHT(c.ucn, 4))
END,
CASE
    WHEN c.id MOD 2 = 0 THEN 'Pilot'
    WHEN c.id MOD 3 = 0 THEN 'Cook'
    ELSE 'Engineer'
END,
c.id,
LEFT(c.ucn, 1) FROM `colonists` AS c
WHERE c.id BETWEEN 96 AND 100;

######################################

UPDATE `journeys`
SET `purpose` = 
CASE 
	WHEN `id` MOD 2 = 0 THEN 'Medical'
	WHEN `id` MOD 3 = 0 THEN 'Technical'
	WHEN `id` MOD 5 = 0 THEN 'Educational'
	WHEN `id` MOD 7 = 0 THEN 'Military'
END
WHERE (`id` MOD 2 = 0) OR (`id` MOD 3 = 0) OR (`id` MOD 5 = 0) OR (`id` MOD 7 = 0);

####################################

DELETE `colonists`
FROM `colonists`
LEFT JOIN `travel_cards` ON `colonists`.`id` = `travel_cards`.`colonist_id`
WHERE `travel_cards`.`id` IS NULL;