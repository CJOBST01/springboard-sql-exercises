-- queries_products.sql
-- Solutions for Part 3 of the SQL Querying exercise.

-- 1. Add a chair (price 44.00, can_be_returned false)
INSERT INTO products (name, price, can_be_returned) VALUES ('chair', 44.00, false);

-- 2. Add a stool (price 25.99, can_be_returned true)
INSERT INTO products (name, price, can_be_returned) VALUES ('stool', 25.99, true);

-- 3. Add a table (price 124.00, can_be_returned false)
INSERT INTO products (name, price, can_be_returned) VALUES ('table', 124.00, false);

-- 4. Display all rows and columns
SELECT * FROM products;

-- 5. Display all product names
SELECT name FROM products;

-- 6. Display all product names and prices
SELECT name, price FROM products;

-- 7. Add a new product (made up)
INSERT INTO products (name, price, can_be_returned) VALUES ('lamp', 39.50, true);

-- 8. Display only products that can be returned
SELECT * FROM products WHERE can_be_returned = true;

-- 9. Display only products with a price less than 44.00
SELECT * FROM products WHERE price < 44.00;

-- 10. Display only products priced between 22.50 and 99.99
SELECT * FROM products WHERE price BETWEEN 22.50 AND 99.99;

-- 11. Sale: take $20 off everything
UPDATE products SET price = price - 20;

-- 12. Sold out: remove products under $25 after the sale
DELETE FROM products WHERE price < 25;

-- 13. Sale ends: increase remaining product prices by $20
UPDATE products SET price = price + 20;

-- 14. New policy: everything is returnable
UPDATE products SET can_be_returned = true;
