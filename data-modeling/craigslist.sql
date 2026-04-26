-- craigslist.sql
-- Schema for the Craigslist exercise.
--
-- Notes:
--   - Each user has a single preferred region.
--   - A post belongs to one user, one location (city), one region, and one
--     primary category. A post-category bridge table allows tagging with more
--     than one category if requirements grow.

DROP DATABASE IF EXISTS craigslist;
CREATE DATABASE craigslist;
\c craigslist

CREATE TABLE regions (
  id    SERIAL PRIMARY KEY,
  name  TEXT NOT NULL UNIQUE
);

CREATE TABLE users (
  id                  SERIAL PRIMARY KEY,
  username            TEXT NOT NULL UNIQUE,
  email               TEXT NOT NULL UNIQUE,
  preferred_region_id INTEGER REFERENCES regions(id)
);

CREATE TABLE categories (
  id    SERIAL PRIMARY KEY,
  name  TEXT NOT NULL UNIQUE
);

CREATE TABLE posts (
  id          SERIAL PRIMARY KEY,
  title       TEXT NOT NULL,
  body        TEXT NOT NULL,
  user_id     INTEGER NOT NULL REFERENCES users(id),
  region_id   INTEGER NOT NULL REFERENCES regions(id),
  location    TEXT NOT NULL,
  posted_at   TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE post_categories (
  post_id     INTEGER NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
  category_id INTEGER NOT NULL REFERENCES categories(id),
  PRIMARY KEY (post_id, category_id)
);

INSERT INTO regions (name) VALUES ('San Francisco'), ('Atlanta'), ('Seattle');

INSERT INTO categories (name) VALUES ('For Sale'), ('Housing'), ('Jobs');

INSERT INTO users (username, email, preferred_region_id) VALUES
  ('alice', 'alice@example.com', 1),
  ('bob',   'bob@example.com',   2);

INSERT INTO posts (title, body, user_id, region_id, location) VALUES
  ('Used Bike', 'Like-new mountain bike.', 1, 1, 'Mission District'),
  ('Studio Apartment', 'Quiet studio for rent.', 2, 2, 'Midtown');

INSERT INTO post_categories (post_id, category_id) VALUES
  (1, 1),
  (2, 2);
