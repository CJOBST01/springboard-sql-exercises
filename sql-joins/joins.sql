-- joins.sql
-- Solutions for Part One of the SQL Joins exercise.

-- 1. Show every owner row joined to every car row, including owners with no cars.
SELECT owners.id,
       owners.first_name,
       owners.last_name,
       cars.id,
       cars.make,
       cars.model,
       cars.year,
       cars.price,
       cars.owner_id
FROM owners
LEFT JOIN cars ON cars.owner_id = owners.id
ORDER BY owners.id, cars.id;

-- 2. Number of cars per owner, ordered by first_name ascending.
SELECT owners.first_name,
       owners.last_name,
       COUNT(cars.id) AS count
FROM owners
JOIN cars ON cars.owner_id = owners.id
GROUP BY owners.id, owners.first_name, owners.last_name
ORDER BY owners.first_name ASC;

-- 3. Owners with more than one car and an average price > 10000, ordered by first_name desc.
SELECT owners.first_name,
       owners.last_name,
       AVG(cars.price)::INTEGER AS average_price,
       COUNT(cars.id) AS count
FROM owners
JOIN cars ON cars.owner_id = owners.id
GROUP BY owners.id, owners.first_name, owners.last_name
HAVING COUNT(cars.id) > 1 AND AVG(cars.price) > 10000
ORDER BY owners.first_name DESC;
