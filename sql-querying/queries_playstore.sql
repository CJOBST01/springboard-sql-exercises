-- queries_playstore.sql
-- Solutions for Part 4 of the SQL Querying exercise.

-- 1. App with id 1880
SELECT * FROM analytics WHERE id = 1880;

-- 2. ID and app name for apps last updated on August 01, 2018
SELECT id, name FROM analytics WHERE last_updated = '2018-08-01';

-- 3. Count of apps in each category
SELECT category, COUNT(*) AS app_count
FROM analytics
GROUP BY category
ORDER BY app_count DESC;

-- 4. Top 5 most-reviewed apps
SELECT name, reviews
FROM analytics
ORDER BY reviews DESC
LIMIT 5;

-- 5. App with the most reviews among apps rated >= 4.8
SELECT name, reviews, rating
FROM analytics
WHERE rating >= 4.8
ORDER BY reviews DESC
LIMIT 1;

-- 6. Average rating per category, highest to lowest
SELECT category, AVG(rating) AS avg_rating
FROM analytics
WHERE rating IS NOT NULL
GROUP BY category
ORDER BY avg_rating DESC;

-- 7. Name, price, rating of the most expensive app rated < 3
SELECT name, price, rating
FROM analytics
WHERE rating < 3
ORDER BY price DESC
LIMIT 1;

-- 8. Apps with min_installs <= 50 that have a rating, ordered by highest rated
SELECT *
FROM analytics
WHERE min_installs <= 50 AND rating IS NOT NULL
ORDER BY rating DESC;

-- 9. Apps rated < 3 with at least 10000 reviews
SELECT name
FROM analytics
WHERE rating < 3 AND reviews >= 10000;

-- 10. Top 10 most-reviewed apps priced between 10 cents and a dollar
SELECT name, reviews, price
FROM analytics
WHERE price BETWEEN 0.10 AND 1.00
ORDER BY reviews DESC
LIMIT 10;

-- 11. Most out of date app (oldest last_updated)
SELECT *
FROM analytics
WHERE last_updated = (SELECT MIN(last_updated) FROM analytics);

-- 12. Most expensive app
SELECT *
FROM analytics
WHERE price = (SELECT MAX(price) FROM analytics);

-- 13. Total number of reviews across the Play Store
SELECT SUM(reviews) AS total_reviews FROM analytics;

-- 14. Categories with more than 300 apps
SELECT category, COUNT(*) AS app_count
FROM analytics
GROUP BY category
HAVING COUNT(*) > 300;

-- 15. App with highest min_installs / reviews ratio, among apps installed >= 100000 times
SELECT name,
       reviews,
       min_installs,
       (min_installs::numeric / NULLIF(reviews, 0)) AS proportion
FROM analytics
WHERE min_installs >= 100000 AND reviews > 0
ORDER BY proportion DESC
LIMIT 1;

-- Bonus FS1. Top rated app per category, among apps installed >= 50000 times
SELECT DISTINCT ON (category) category, name, rating
FROM analytics
WHERE min_installs >= 50000 AND rating IS NOT NULL
ORDER BY category, rating DESC;

-- Bonus FS2. Apps with a name similar to "facebook"
SELECT name FROM analytics WHERE name ILIKE '%facebook%';

-- Bonus FS3. Apps with more than 1 genre
SELECT name, genres
FROM analytics
WHERE array_length(string_to_array(genres, ';'), 1) > 1;

-- Bonus FS4. Apps that include "Education" as a genre
SELECT name, genres
FROM analytics
WHERE 'Education' = ANY(string_to_array(genres, ';'));
