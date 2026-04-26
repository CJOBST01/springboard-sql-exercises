# SQL Zoo Joins (Tutorials 6 and 7)

## Tutorial 6: JOIN (Football)

```sql
-- 6.1 Matches in 'POL'
SELECT matchid, player FROM goal WHERE teamid = 'GER';

-- 6.2 Match 1012 details
SELECT id, stadium, team1, team2 FROM game WHERE id = 1012;

-- 6.3 Players who scored, with stadium and team info
SELECT player, teamid, stadium, mdate
FROM game JOIN goal ON id = matchid;

-- 6.4 German players who scored
SELECT team1, team2, player FROM game
JOIN goal ON id = matchid
WHERE teamid = 'GER';

-- 6.5 Mario goals
SELECT player, teamid, coach, gtime
FROM goal JOIN eteam ON teamid = id
WHERE player LIKE 'Mario%';

-- 6.6 Goals scored in the first 10 minutes
SELECT player, teamid, coach, gtime
FROM goal JOIN eteam ON goal.teamid = eteam.id
WHERE gtime <= 10;

-- 6.7 Match dates and team coaches with Fernando Santos
SELECT mdate, teamname FROM game
JOIN eteam ON team1 = eteam.id
WHERE coach = 'Fernando Santos';

-- 6.8 Players who scored in National Stadium, Warsaw
SELECT player FROM game
JOIN goal ON id = matchid
WHERE stadium = 'National Stadium, Warsaw';

-- 6.9 German scorers against Germany
SELECT DISTINCT player FROM game
JOIN goal ON matchid = id
WHERE (team1 = 'GER' OR team2 = 'GER') AND teamid != 'GER';

-- 6.10 Team and goal counts
SELECT teamname, COUNT(*) FROM eteam
JOIN goal ON id = teamid
GROUP BY teamname;

-- 6.11 Stadium and goal counts
SELECT stadium, COUNT(*) FROM game
JOIN goal ON id = matchid
GROUP BY stadium;

-- 6.12 Polish matches and goal counts
SELECT matchid, mdate, COUNT(*) FROM game
JOIN goal ON matchid = id
WHERE team1 = 'POL' OR team2 = 'POL'
GROUP BY matchid, mdate;

-- 6.13 Match goals scored by Germany per match
SELECT matchid, mdate, COUNT(*) FROM game
JOIN goal ON matchid = id
WHERE teamid = 'GER'
GROUP BY matchid, mdate;

-- 6.14 Score progression per match
SELECT mdate,
       team1,
       SUM(CASE WHEN teamid = team1 THEN 1 ELSE 0 END) AS score1,
       team2,
       SUM(CASE WHEN teamid = team2 THEN 1 ELSE 0 END) AS score2
FROM game LEFT JOIN goal ON matchid = id
GROUP BY mdate, matchid, team1, team2
ORDER BY mdate, matchid, team1, team2;
```

## Tutorial 7: More JOIN (Movies)

```sql
-- 7.1 Year of Citizen Kane
SELECT yr FROM movie WHERE title = 'Citizen Kane';

-- 7.2 Star Trek list
SELECT id, title, yr FROM movie
WHERE title LIKE 'Star Trek%'
ORDER BY yr;

-- 7.3 Glenn Close id
SELECT id FROM actor WHERE name = 'Glenn Close';

-- 7.4 Casablanca id
SELECT id FROM movie WHERE title = 'Casablanca';

-- 7.5 Casablanca cast
SELECT name FROM actor
JOIN casting ON actor.id = actorid
WHERE movieid = 11768;

-- 7.6 Alien cast
SELECT name FROM actor
JOIN casting ON actor.id = actorid
JOIN movie ON movie.id = movieid
WHERE title = 'Alien';

-- 7.7 Harrison Ford filmography
SELECT title FROM movie
JOIN casting ON movie.id = movieid
JOIN actor ON actor.id = actorid
WHERE name = 'Harrison Ford';

-- 7.8 Harrison Ford supporting roles
SELECT title FROM movie
JOIN casting ON movie.id = movieid
JOIN actor ON actor.id = actorid
WHERE name = 'Harrison Ford' AND ord != 1;

-- 7.9 Lead actors of films from 1962
SELECT title, name FROM movie
JOIN casting ON movie.id = movieid
JOIN actor ON actor.id = actorid
WHERE yr = 1962 AND ord = 1;

-- 7.10 Busy years for Rock Hudson
SELECT yr, COUNT(title) FROM movie
JOIN casting ON movie.id = movieid
JOIN actor ON actor.id = actorid
WHERE name = 'Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2;

-- 7.11 Lead role for Julie Andrews movies
SELECT title, name FROM movie
JOIN casting ON movie.id = movieid
JOIN actor ON actor.id = actorid
WHERE ord = 1
  AND movieid IN (
    SELECT movieid FROM casting
    JOIN actor ON actorid = actor.id
    WHERE name = 'Julie Andrews'
  );

-- 7.12 Actors who lead in 15 or more films
SELECT name FROM actor
JOIN casting ON actor.id = actorid
WHERE ord = 1
GROUP BY name
HAVING COUNT(movieid) >= 15;

-- 7.13 Films of 1978 ordered by cast size
SELECT title, COUNT(actorid) AS cast_size
FROM movie
JOIN casting ON movie.id = movieid
WHERE yr = 1978
GROUP BY title
ORDER BY cast_size DESC, title ASC;

-- 7.14 Co-stars of Art Garfunkel
SELECT DISTINCT name FROM actor
JOIN casting ON actor.id = actorid
WHERE movieid IN (
  SELECT movieid FROM casting
  JOIN actor ON actorid = actor.id
  WHERE name = 'Art Garfunkel'
) AND name != 'Art Garfunkel';
```
