-- crud.sql
-- Scratch file for products exercise. Confirmed queries are saved in queries_products.sql.

CREATE DATABASE products_db;
\c products_db

CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  price NUMERIC(10, 2) NOT NULL CHECK (price IS NOT NULL),
  can_be_returned BOOLEAN NOT NULL
);
