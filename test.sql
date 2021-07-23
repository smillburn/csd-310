CREATE VIEW fullRoster AS
SELECT first_name, last_name, team_name 
FROM player
INNER JOIN team
ON player.team_id = team.team_id;

select * from fullRoster
WHERE team_name = 'TEAM SORA'
AND first_name != 'Mickey';

SELECT player_id, first_name, last_name, team_name 
FROM player 
INNER JOIN team 
ON player.team_id = team.team_id;

INSERT INTO player (first_name, last_name, team_id) VALUES('Smeagol', 'Shire Folk', 1);
UPDATE player SET team_id = 2, first_name = 'Gollum', last_name = 'Ring Stealer' WHERE first_name = 'Smeagol';
DELETE FROM player WHERE first_name = 'Gollum';


DROP USER IF EXISTS 'outland_adventures_user'@'localhost';

-- create outland_adventures_user and grant them all priveledges to the outland_adventures database
CREATE USER 'outland_adventures_user'@'localhost' IDENTIFIED WITH mysql_native_password By 'Cactusjuice17!';

-- grant all priveleges to the outland_adventures database to user outland_adventures_user on localhost
GRANT ALL PRIVILEGES ON outland_adventures.* TO 'outland_adventures_user'@'localhost';

DROP TABLE IF EXISTS trek;

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS employee_trek_history;
DROP TABLE IF EXISTS trek_history;
DROP TABLE IF EXISTS inventory;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS customers;

"""Create tables"""
CREATE TABLE customers (
    customer_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    f_name VARCHAR(75) NOT NULL, 
    l_name VARCHAR(75) NOT NULL, 
    address VARCHAR(75) NOT NULL, 
    city VARCHAR(75) NOT NULL, 
    state VARCHAR(75) NOT NULL, 
    zip_code VARCHAR(75) NOT NULL, 
    phone VARCHAR(75) NOT NULL);
CREATE TABLE trek_history (
    trek_history_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    customer_id INT NOT NULL, FOREIGN KEY(customer_id) REFERENCES customers(customer_id), 
    trek_id INT NOT NULL, FOREIGN KEY (trek_id) REFERENCES trek(trek_id),
    trek_name VARCHAR(75) NOT NULL, 
    trip_cost DOUBLE NOT NULL, 
    trip_date DATETIME NOT NULL);
CREATE TABLE trek (
    trek_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    trek_name VARCHAR(75) NOT NULL, 
    country VARCHAR(75) NOT NULL, 
    requires_visa BOOLEAN NOT NULL, 
    required_immunizations BOOLEAN NOT NULL);
CREATE TABLE orders (
    order_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    trek_history_id INT NOT NULL, FOREIGN KEY(trek_history_id) REFERENCES trek_history(trek_history_id),
    order_date DATETIME NOT NULL);
CREATE TABLE customer_rentals (
    rental_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL, FOREIGN KEY(order_id) REFERENCES orders(order_id),
    gear_id INT NOT NULL, FOREIGN KEY(gear_id) REFERENCES inventory(gear_id),
    rental_cost DOUBLE NOT NULL); 
CREATE TABLE customer_purchases (
    purchase_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL, FOREIGN KEY(order_id) REFERENCES orders(order_id),
    gear_id INT NOT NULL, FOREIGN KEY(gear_id) REFERENCES inventory(gear_id),
    purchase_cost DOUBLE NOT NULL); 
CREATE TABLE order_details ( 
    order_details INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL, FOREIGN KEY(order_id) REFERENCES orders(order_id),
    gear_id INT NOT NULL, FOREIGN KEY(gear_id) REFERENCES inventory(gear_id),
    purchase_cost DOUBLE NOT NULL,
    rental_cost DOUBLE NOT NULL
);
CREATE TABLE employees (
    employee_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    f_name VARCHAR(75) NOT NULL, 
    l_name VARCHAR(75) NOT NULL, 
    date_of_birth DATETIME NOT NULL, 
    title VARCHAR(75) NOT NULL, 
    supervisor_id INT); 
CREATE TABLE inventory (
    gear_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,  
    gear_name VARCHAR(75) NOT NULL, 
    for_rent BOOLEAN NOT NULL, 
    purchase_date DATETIME NOT NULL);
CREATE TABLE employee_trek_history (
    trek_history_id INT NOT NULL, FOREIGN KEY(trek_history_id) REFERENCES trek_history(trek_history_id), 
    employee_id INT NOT NULL, FOREIGN KEY(employee_id) REFERENCES employees(employee_id), 
    supervisor_id INT NOT NULL, FOREIGN KEY(supervisor_id) REFERENCES employees(employee_id)); 


SELECT trek_history.customer_id, customers.f_name, customers.l_name, COUNT(trek_history.trek_history_id) AS Total_Treks, SUM(trek_history.trip_cost) AS total_trek_cost FROM trek_history INNER JOIN customers ON customers.customer_id = trek_history.customer_id GROUP BY customer_id;
SELECT gear_id, gear_name, purchase_date FROM inventory;
SELECT gear_id, gear_name, purchase_date FROM inventory WHERE YEAR (purchase_date) < 2016;
SELECT trek_history.trip_date, trek.trek_id, trek.trek_name, trek.country, COUNT(trek_history.customer_id) AS Customers_On_Trip FROM trek_history INNER JOIN trek ON trek.trek_id = trek_history.trek_id GROUP BY trip_date, trek_id ORDER BY trip_date ASC;
SELECT inventory.gear_name, orders.gear_id, SUM(orders.quantity) AS Items_Ordered FROM orders INNER JOIN inventory ON orders.gear_id = inventory.gear_id GROUP BY gear_id;
DROP VIEW IF EXISTS customer_spending;
DROP VIEW IF EXISTS trek_rental_purchases;
CREATE VIEW customer_spending AS;
SELECT
    customers.customer_id, 
    customers.f_name, 
    customers.l_name, 
    th.number_of_treks,
    th.total_trip_cost,
    COUNT(CASE WHEN order_details.purchase_cost > 0 THEN 1 END) AS total_purchases,
    IFNULL(SUM(order_details.purchase_cost), 0) AS total_purchase_cost,
    COUNT(CASE WHEN order_details.rental_cost > 0 THEN 1 END) AS total_rentals,
    IFNULL(SUM(order_details.rental_cost), 0) AS total_rental_cost,
    (IFNULL(SUM(order_details.purchase_cost), 0) + IFNULL(SUM(order_details.rental_cost), 0) + th.total_trip_cost) as total_cost
    FROM (
        SELECT 
            trip_date, 
            trek_id, 
            customer_id,
            trek_history_id, 
            COUNT(trip_date) as number_of_treks,
            SUM(trip_cost) as total_trip_cost
        FROM trek_history 
        GROUP BY customer_id) 
    AS th
    INNER JOIN customers 
    ON customers.customer_id = th.customer_id
    LEFT JOIN orders
    ON th.trek_history_id = orders.trek_history_id
    LEFT JOIN order_details
    ON orders.order_id = order_details.order_id
    GROUP BY customers.customer_id
    ORDER BY total_cost DESC;
CREATE VIEW trek_rental_purchases AS
SELECT 
    trek_history.trip_date,
    trek_history.trek_id,
    trek.trek_name,
    COUNT(CASE WHEN order_details.purchase_cost > 0 THEN 1 END) AS total_purchases,
    IFNULL(SUM(order_details.purchase_cost), 0) AS total_purchase_cost,
    COUNT(CASE WHEN order_details.rental_cost > 0 THEN 1 END) AS total_rentals,
    IFNULL(SUM(order_details.rental_cost), 0) AS total_rental_cost,
    (IFNULL(SUM(order_details.purchase_cost), 0) + IFNULL(SUM(order_details.rental_cost), 0)) as total_cost
    FROM trek_history
    LEFT JOIN orders
    ON trek_history.trek_history_id = orders.trek_history_id
    LEFT JOIn order_details
    ON orders.order_id = order_details.order_id
    INNER JOIN trek
    ON trek_history.trek_id = trek.trek_id
    GROUP BY trip_date, trek_id
    ORDER BY trek_history.trip_date ASC;

