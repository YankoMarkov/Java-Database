CREATE DATABASE minions;

##################################

CREATE TABLE minions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    age INT(3)
);

################################

CREATE TABLE towns (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
);

##################################

ALTER TABLE minions
ADD town_id INT;

###################################

ALTER TABLE minions
ADD CONSTRAINT fk_minions_towns FOREIGN KEY(town_id)
REFERENCES towns(id);

#######################################

INSERT INTO towns (name) VALUES ('Sofia'), ('Plovdiv'), ('Varna');

###########################################

INSERT INTO minions (name,age,town_id) VALUES ('Kevin',22,1), ('Bob',15,3), ('Steward',NULL,2);

#############################################

TRUNCATE minions;

############################################

DROP TABLES minions, towns;

###########################################

CREATE DATABASE people;

############################################

CREATE TABLE people (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    name VARCHAR(200) NOT NULL,
    picture TINYBLOB,
    height FLOAT(4 , 2 ),
    weight FLOAT(4 , 2 ),
    gender ENUM('m', 'f') NOT NULL,
    birthdate DATE NOT NULL,
    biography TEXT
);

#############################################

INSERT INTO people (name,picture,height,weight,gender,birthdate,biography) 
VALUES ('Pesho', NULL, 1.80, 75, 'm', '1989-05-20', 'Hello I,m Pesho'),
('Gosho', NULL, 1.75, 70, 'm', '1987-02-20', 'Hello I,m Gosho'),
('Maria', NULL, 1.65, 50, 'f', '1978-05-10', 'Hello I,m Maria'),
('Ivan', NULL, 1.80, 80, 'm', '1992-04-15', 'Hello I,m Ivan'),
('Slavi', NULL, 1.83, 78, 'm', '1985-06-05', 'Hello I,m Slavi');

#########################################

SELECT * FROM people;

#############################################

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    username VARCHAR(30) NOT NULL,
    password VARCHAR(26) NOT NULL,
    profile_picture BLOB(921600),
    last_login_time DATETIME,
    is_deleted BOOL
);

#############################################

INSERT INTO users (username,password,profile_picture,last_login_time,is_deleted)
VALUES ('pesho', 'pesho1234', NULL, NULL, TRUE),
('gosho', 'gosho1234', NULL, NULL, TRUE),
('nasko', 'nasko1234', NULL, NULL, FALSE),
('ivan', 'ivan1234', NULL, NULL, TRUE),
('alex', 'alex1234', NULL, NULL, FALSE);

##############################################

SELECT * FROM users;

#################################################

ALTER TABLE users MODIFY id INT NOT NULL;
ALTER TABLE users DROP PRIMARY KEY;
ALTER TABLE users ADD PRIMARY KEY (id,username);

#################################################

UPDATE users
SET last_login_time = current_timestamp

#############################################

ALTER TABLE users
MODIFY COLUMN last_login_time DATETIME NOT NULL DEFAULT current_timestamp();

###########################################

ALTER TABLE users DROP PRIMARY KEY;
ALTER TABLE users MODIFY id INT NOT NULL PRIMARY KEY AUTO_INCREMENT;

##################################################

ALTER TABLE users ADD UNIQUE (username);

############################################

CREATE DATABASE movies;

######################################

USE movies;

######################################

CREATE TABLE directors (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    director_name VARCHAR(30) NOT NULL,
	notes TEXT
);

CREATE TABLE genres (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    genre_name VARCHAR(30) NOT NULL,
    notes TEXT
);

CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    category_name VARCHAR(30) NOT NULL,
    notes TEXT
);

CREATE TABLE movies (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    title VARCHAR(30) NOT NULL,
    director_id INT NOT NULL,
    copyright_year INT(4) NOT NULL,
    length INT(3) NOT NULL,
    genre_id INT NOT NULL,
    category_id INT NOT NULL,
    rating INT,
    notes TEXT
);

######################################

ALTER TABLE movies
ADD CONSTRAINT fk_movies_director FOREIGN KEY(director_id)
REFERENCES directors(id);

ALTER TABLE movies
ADD CONSTRAINT fk_movies_genre FOREIGN KEY(genre_id)
REFERENCES genres(id);

ALTER TABLE movies
ADD CONSTRAINT fk_movies_category FOREIGN KEY(category_id)
REFERENCES categories(id);

########################################

INSERT INTO categories (category_name, notes)
VALUES ('Comedy', 'alalalalalalalalala'),
('Drama', 'alalalalalalalalala'),
('Action', NULL),
('Anime', NULL),
('Uestern', 'jdjfgfjdkcf');

##########################################

INSERT INTO directors (director_name, notes)
VALUES ('Pesho', 'hdhdhdhdhdhdhdhd'),
('Ivan', NULL),
('Alex', 'kldfdsklfjsldfkjsd'),
('Meto', NULL),
('Yan', 'kkkkkkk');

###########################################

INSERT INTO genres (genre_name, notes)
VALUES ('Action', 'hdhdhdhdhdhdhdhd'),
('Drama', NULL),
('Comedy', 'kkdkdoieekdk'),
('Triler', NULL),
('Horrer', 'kkffyyjdd');

###########################################

INSERT INTO movies (title, director_id, copyright_year, length, genre_id, category_id, rating, notes)
VALUES ('Aladin', 2, 2010, 120, 1, 3, 5, 'kdjdhgfkskshff'),
('Toshiko', 2, 2013, 120, 2, 4, 1, NULL),
('Keriman', 2, 2015, 120, 5, 2, 4, NULL),
('Storm', 2, 2011, 120, 3, 5, 2, 'jjdlsikikee'),
('World', 2, 2017, 120, 3, 4, 1, NULL);

#####################################

CREATE DATABASE car_rental;

#####################################

CREATE TABLE categories (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    category VARCHAR(50) NOT NULL,
    daily_rate DOUBLE(4 , 2 ) NOT NULL,
    weekly_rate DOUBLE(5 , 2 ) NOT NULL,
    monthly_rate DOUBLE(6 , 2 ) NOT NULL,
    weekend_rate DOUBLE(5 , 2 ) NOT NULL
);

########################################

INSERT INTO categories (category, daily_rate, weekly_rate, monthly_rate, weekend_rate)
VALUES ('sedan', 20.8, 100, 350, 40),
('jeep', 30.8, 200, 650, 50),
('comby', 20.8, 100, 350, 40);

########################################

CREATE TABLE cars (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    plate_number VARCHAR(10) NOT NULL,
    make VARCHAR(30) NOT NULL,
    model VARCHAR(30) NOT NULL,
    car_year INT(4) NOT NULL,
    category_id INT NOT NULL,
    doors INT(1) NOT NULL,
    picture BLOB,
    car_condition TEXT,
    available BOOL NOT NULL
);

##################################

ALTER TABLE cars
ADD CONSTRAINT fk_cars_category FOREIGN KEY (category_id)
REFERENCES categories(id);

#####################################

INSERT INTO cars (plate_number, make, model, car_year, category_id, doors, picture, car_condition, available)
VALUES ('CA1010MK', 'Audi', 'A5', '2015', 1, 4, NULL, NULL, TRUE),
('CA1020MK', 'BMW', 'M5', '2015', 2, 5, NULL, NULL, TRUE),
('CA1030MK', 'Opel', 'corsa', '2015', 3, 5, NULL, NULL, TRUE);

#########################################
    
CREATE TABLE employees (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    title VARCHAR(10),
    notes TEXT
);

#########################################

INSERT INTO employees (first_name, last_name, title, notes)
VALUES ('Pesho', 'Hristov', NULL, NULL),
('Ivan', 'Petrov', NULL, NULL),
('Maria', 'Ivanova', NULL, NULL);

###########################################

CREATE TABLE customers (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    driver_licence_number INT NOT NULL,
    full_name VARCHAR(50) NOT NULL,
    address VARCHAR(60) NOT NULL,
    city VARCHAR(30) NOT NULL,
    zip_code INT(5) NOT NULL,
    notes TEXT
);

#####################################
INSERT INTO customers (driver_licence_number, full_name, address, city, zip_code, notes)
VALUES (876565, 'Pesho Ivanov', 'Sofia Mladost', 'Sofia', 1000, NULL),
(876565, 'Hristo Petrov', 'Sofia Mladost', 'Sofia', 1000, NULL),
(876565, 'Rosen Monev', 'Sofia Mladost', 'Sofia', 1000, NULL);

######################################
CREATE TABLE rental_orders (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    customer_id INT NOT NULL,
    car_id INT NOT NULL,
    car_condition VARCHAR(50) NOT NULL,
    tank_level INT(2) NOT NULL,
    kilometrage_start INT NOT NULL,
    kilometrage_end INT NOT NULL,
    total_kilometrage INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_days INT(3) NOT NULL,
    rate_applied DOUBLE(5 , 2 ) NOT NULL,
    tax_rate DOUBLE(5 , 2 ) NOT NULL,
    order_status BOOL NOT NULL,
    notes TEXT
);

#########################################

ALTER TABLE rental_orders
ADD CONSTRAINT fk_rental_order_employee FOREIGN KEY (employee_id)
REFERENCES 	employees(id);

######################################

ALTER TABLE rental_orders
ADD CONSTRAINT fk_rental_order_customer FOREIGN KEY (customer_id)
REFERENCES 	customers(id);

##########################################

ALTER TABLE rental_orders
ADD CONSTRAINT fk_rental_order_car FOREIGN KEY (car_id)
REFERENCES 	cars(id);

############################################

INSERT INTO rental_orders (employee_id, customer_id, car_id, car_condition, tank_level, kilometrage_start, kilometrage_end, total_kilometrage, start_date, end_date, total_days, rate_applied, tax_rate, order_status, notes)
VALUES (1, 1, 1, 'kjdhsajds', 60, 80000, 82000, 2000, '2018-03-25', '2018-03-27', 2, 23.5, 20, TRUE, NULL),
(2, 1, 2, 'kjdhsajds', 60, 80000, 82000, 2000, '2018-03-25', '2018-03-27', 2, 23.5, 20, TRUE, NULL),
(3, 2, 3, 'kjdhsajds', 60, 80000, 82000, 2000, '2018-03-25', '2018-03-27', 2, 23.5, 20, TRUE, NULL);

########################################

CREATE DATABASE hotel;

#######################################

CREATE TABLE employees (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    title VARCHAR(30) NOT NULL,
    notes TEXT
);

##########################################

INSERT  INTO employees (first_name, last_name, title, notes)
VALUES ('aaaaa', 'cccccc', 'fffff', NULL),
	('aabnaaa', 'ccvvccccc', 'ddddd', NULL),
    ('cvxcvxcv', 'cccccxcc', 'fffddff', NULL);

########################################

CREATE TABLE customers (
    account_number INT NOT NULL,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    phone_number CHAR(12) NOT NULL,
    emergency_name VARCHAR(50) NOT NULL,
    emergency_number CHAR(12) NOT NULL,
    notes TEXT
);

#######################################

INSERT INTO customers (account_number, first_name, last_name, phone_number, emergency_name, emergency_number, notes)
VALUES (65456456,'adsfgdsa','adasdasd',684654654,'ashhdfasdf',65465465,NULL),
(65456456,'adsfffdsa','adasdgggasd',684654654,'asdfaaasdf',65465465,NULL),
(65456456,'addddsdsa','adasdggasd',684654654,'asdssfasdf',65465465,NULL);

######################################

CREATE TABLE room_status (
    room_status BOOL NOT NULL,
    notes TEXT
);

######################################

INSERT INTO room_status (room_status, notes)
VALUES (TRUE, NULL),
(FALSE, NULL),
(TRUE, NULL);

######################################

CREATE TABLE room_types (
    room_type VARCHAR(50) NOT NULL,
    notes TEXT
);

#####################################

INSERT INTO room_types (room_type, notes)
VALUES ('dfgsdfg', NULL),
('fgdfg', NULL),
('dfgdfg', NULL);

######################################

CREATE TABLE bed_types (
    bed_type VARCHAR(30) NOT NULL,
    notes TEXT
);

#######################################

INSERT INTO bed_types (bed_type, notes)
VALUES ('dfgssdfg', NULL),
('fgdfg', NULL),
('dfgdfg', NULL);

#######################################

CREATE TABLE rooms (
    room_number INT(2) NOT NULL,
    room_type VARCHAR(30) NOT NULL,
    bed_type VARCHAR(30) NOT NULL,
    rate DOUBLE(5 , 2 ),
    room_status BOOL NOT NULL,
    notes TEXT
);

######################################

INSERT INTO rooms (room_number, room_type, bed_type, rate, room_status, notes)
VALUES (2,'gggg','dfgdfg',65.2,TRUE,NULL),
(4,'sdfg','dfgdfg',65.2,TRUE,NULL),
(23,'sdfg','dfgdfg',65.2,TRUE,NULL);

########################################

CREATE TABLE payments (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    payment_date DATE NOT NULL,
    account_number INT NOT NULL,
    first_date_occupied DATE NOT NULL,
    last_date_occupied DATE NOT NULL,
    total_days INT(3) NOT NULL,
    amount_charged DOUBLE(5 , 2 ) NOT NULL,
    tax_rate DOUBLE(4 , 2 ) NOT NULL,
    tax_amount DOUBLE(4 , 2 ) NOT NULL,
    payment_total DOUBLE(5 , 2 ) NOT NULL,
    notes TEXT
);

#######################################

ALTER TABLE payments
ADD CONSTRAINT fk_payment_employee FOREIGN KEY(employee_id)
REFERENCES employees(id);

#####################################

INSERT INTO payments(employee_id, payment_date, account_number, first_date_occupied, last_date_occupied, total_days, amount_charged, tax_rate, tax_amount, payment_total, notes)
VALUES(2, '2011-02-20', 5646525, '2012-03-01', '2012-03-20', 10, 20.5, 21,20,567,NULL),
(1, '2011-02-20', 5646525, '2012-03-01', '2012-03-20', 10, 20.5, 21,20,567,NULL),
(3, '2011-02-20', 5646525, '2012-03-01', '2012-03-20', 10, 20.5, 21,20,567,NULL);

######################################

CREATE TABLE occupancies (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    date_occupied DATE NOT NULL,
    account_number INT NOT NULL,
    room_number INT(4) NOT NULL,
    rate_applied DOUBLE(5 , 2 ) NOT NULL,
    phone_charge DOUBLE(4 , 2 ) NOT NULL,
    notes TEXT
);

#####################################

INSERT INTO occupancies (employee_id, date_occupied, account_number, room_number, rate_applied, phone_charge, notes)
VALUES (2,'2010-02-03',4354254,23,45.6,5.5,NULL),
(2,'2010-02-03',4354254,23,45.6,5.5,NULL),
(1,'2010-02-03',4354254,23,45.6,5.5,NULL);

#####################################

CREATE DATABASE soft_uni;

###################################

CREATE TABLE towns (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE addresses (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    address_text VARCHAR(50) NOT NULL,
    town_id INT NOT NULL
);

CREATE TABLE departments (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE employees (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(30) NOT NULL,
    middle_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    job_title VARCHAR(50) NOT NULL,
    department_id INT NOT NULL,
    hire_date DATE NOT NULL,
    salary DOUBLE(8,2) NOT NULL,
    address_id INT
);

#########################################

ALTER TABLE employees
ADD CONSTRAINT fr_employee_department FOREIGN KEY(department_id)
REFERENCES departments(id);

##########################################

ALTER TABLE employees
ADD CONSTRAINT fr_employee_address FOREIGN KEY(address_id)
REFERENCES addresses(id);

###################################

INSERT INTO towns(name) 
VALUES ('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas');

#####################################

INSERT INTO departments(name)
VALUES ('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance');

######################################

INSERT INTO employees(first_name, middle_name, last_name, job_title, department_id, hire_date, salary)
VALUES ('Ivan','Ivanov','Ivanov','.NET Developer',4,'2013-02-01',3500.00),
('Petar','Petrov','Petrov','Senior Engineer',1,'2004-03-02',4000.00),
('Maria', 'Petrova', 'Ivanova', 'Intern', 5,'2016-08-28',525.25),
('Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00),
('Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88);

######################################

SELECT * FROM towns;

############################

SELECT * FROM departments;

############################

SELECT * FROM employees;

##############################

SELECT * FROM towns ORDER BY `name`;

################################

SELECT * FROM departments ORDER BY `name`;

################################

SELECT * FROM employees ORDER BY `salary` DESC;

################################

SELECT `name` FROM towns ORDER BY `name`;

#############################

SELECT `name` FROM departments ORDER BY `name`;

############################
SELECT `first_name`, `last_name`, `job_title`, `salary` FROM employees ORDER BY `salary` DESC;

###############################

UPDATE employees
SET salary = salary + (salary  * 10.0 / 100.0)
WHERE id > 0;

#################################

SELECT `salary` FROM employees;
