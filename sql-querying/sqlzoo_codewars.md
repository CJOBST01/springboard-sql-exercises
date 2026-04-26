# SQL Zoo and Codewars Solutions

Reference solutions for the Part 1 SQL Zoo tutorials and Part 2 Codewars kata in the SQL Querying exercise.

## SQL Zoo: Tutorial 0 (SELECT basics)

```sql
-- 0.1 Population of Germany
SELECT population FROM world WHERE name = 'Germany';

-- 0.2 Per capita GDP for several countries
SELECT name, gdp/population FROM world WHERE name IN ('Sweden', 'Norway', 'Denmark');

-- 0.3 Area of countries between 200000 and 250000
SELECT name, area FROM world WHERE area BETWEEN 200000 AND 250000;
```

## SQL Zoo: Tutorial 1 (SELECT name)

```sql
-- 1.1 Country starts with Y
SELECT name FROM world WHERE name LIKE 'Y%';

-- 1.2 Country ends with Y
SELECT name FROM world WHERE name LIKE '%y';

-- 1.3 Contains 'x'
SELECT name FROM world WHERE name LIKE '%x%';

-- 1.4 Ends with 'land'
SELECT name FROM world WHERE name LIKE '%land';

-- 1.5 Starts with 'C' ends with 'ia'
SELECT name FROM world WHERE name LIKE 'C%ia';

-- 1.6 Contains 'oo'
SELECT name FROM world WHERE name LIKE '%oo%';

-- 1.7 Contains three or more 'a'
SELECT name FROM world WHERE name LIKE '%a%a%a%';

-- 1.8 't' is the second letter
SELECT name FROM world WHERE name LIKE '_t%' ORDER BY name;

-- 1.9 Two 'o' separated by two characters
SELECT name FROM world WHERE name LIKE '%o__o%';

-- 1.10 Exactly four characters
SELECT name FROM world WHERE name LIKE '____';
```

## SQL Zoo: Tutorial 2 (SELECT from world)

```sql
-- 2.1 Large countries (area >= 1000000)
SELECT name FROM world WHERE area >= 1000000;

-- 2.2 Per-capita GDP for big countries (population > 200,000,000)
SELECT name, gdp/population FROM world WHERE population > 200000000;

-- 2.3 Population in millions for South American countries
SELECT name, population/1000000 FROM world WHERE continent = 'South America';

-- 2.4 Specific countries
SELECT name, population FROM world WHERE name IN ('France', 'Germany', 'Italy');

-- 2.5 Country names containing 'United'
SELECT name FROM world WHERE name LIKE '%United%';

-- 2.6 Big or rich (area >= 3,000,000 or gdp >= 10,000,000,000,000)
SELECT name, population, area FROM world WHERE area >= 3000000 OR gdp >= 10000000000000;

-- 2.7 XOR style: big OR rich but not both
SELECT name, population, area FROM world
WHERE (area >= 3000000) <> (population >= 250000000);
```

## SQL Zoo: Tutorial 3 (nobel)

```sql
-- 3.1 Winners from 1950
SELECT yr, subject, winner FROM nobel WHERE yr = 1950;

-- 3.2 1962 Literature winner
SELECT winner FROM nobel WHERE yr = 1962 AND subject = 'Literature';

-- 3.3 Einstein
SELECT yr, subject FROM nobel WHERE winner = 'Albert Einstein';

-- 3.4 Recent peace
SELECT winner FROM nobel WHERE subject = 'Peace' AND yr >= 2000;

-- 3.5 Literature 1980 to 1989 inclusive
SELECT * FROM nobel WHERE subject = 'Literature' AND yr BETWEEN 1980 AND 1989;

-- 3.6 Presidents
SELECT * FROM nobel WHERE winner IN (
  'Theodore Roosevelt', 'Woodrow Wilson', 'Jimmy Carter', 'Barack Obama'
);

-- 3.7 First-name John
SELECT winner FROM nobel WHERE winner LIKE 'John %';

-- 3.8 Physics 1980 OR Chemistry 1984
SELECT * FROM nobel
WHERE (subject = 'Physics' AND yr = 1980)
   OR (subject = 'Chemistry' AND yr = 1984);

-- 3.9 1980 winners excluding Chemistry and Medicine
SELECT * FROM nobel
WHERE yr = 1980 AND subject NOT IN ('Chemistry', 'Medicine');

-- 3.10 Early Medicine vs late Literature
SELECT * FROM nobel
WHERE (subject = 'Medicine' AND yr < 1910)
   OR (subject = 'Literature' AND yr >= 2004);
```

## SQL Zoo: Tutorial 5 (SUM and COUNT)

```sql
-- 5.1 Total world population
SELECT SUM(population) FROM world;

-- 5.2 Distinct continents
SELECT DISTINCT continent FROM world;

-- 5.3 GDP of Africa
SELECT SUM(gdp) FROM world WHERE continent = 'Africa';

-- 5.4 Big countries (area >= 1,000,000)
SELECT COUNT(name) FROM world WHERE area >= 1000000;

-- 5.5 Total population of Estonia, Latvia, Lithuania
SELECT SUM(population) FROM world WHERE name IN ('Estonia', 'Latvia', 'Lithuania');

-- 5.6 Countries per continent
SELECT continent, COUNT(name) FROM world GROUP BY continent;

-- 5.7 Continents with population >= 10,000,000 countries
SELECT continent, COUNT(name) FROM world
WHERE population >= 10000000 GROUP BY continent;

-- 5.8 Continents with combined population >= 100,000,000
SELECT continent FROM world
GROUP BY continent HAVING SUM(population) >= 100000000;
```

## Codewars

```sql
-- Simple WHERE and ORDER BY
SELECT * FROM people WHERE age > 50 ORDER BY age DESC;

-- Simple SUM
SELECT SUM(age) AS total_age FROM people;

-- Simple MIN / MAX
SELECT MIN(age) AS minimum_age, MAX(age) AS maximum_age FROM people;

-- Find all active students
SELECT * FROM students WHERE is_active = TRUE;

-- Simple GROUP BY
SELECT department, COUNT(*) AS people_in_department
FROM people
GROUP BY department;

-- Simple HAVING
SELECT department, COUNT(*) AS people_in_department
FROM people
GROUP BY department
HAVING COUNT(*) > 2;
```
