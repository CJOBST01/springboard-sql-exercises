-- soccer_league.sql
-- Schema for the Soccer League exercise.
--
-- Notes:
--   - Standings are derivable from match results, so they live in a view rather
--     than a redundant table.
--   - A goal references a match and the player who scored. The player’s team
--     is normalised on the players table, so we don’t duplicate it.
--   - Two referees per match is supported by referee_assignments.

DROP DATABASE IF EXISTS soccer_league;
CREATE DATABASE soccer_league;
\c soccer_league

CREATE TABLE seasons (
  id          SERIAL PRIMARY KEY,
  name        TEXT NOT NULL,
  start_date  DATE NOT NULL,
  end_date    DATE NOT NULL
);

CREATE TABLE teams (
  id          SERIAL PRIMARY KEY,
  name        TEXT NOT NULL UNIQUE
);

CREATE TABLE players (
  id          SERIAL PRIMARY KEY,
  first_name  TEXT NOT NULL,
  last_name   TEXT NOT NULL,
  team_id     INTEGER NOT NULL REFERENCES teams(id)
);

CREATE TABLE referees (
  id          SERIAL PRIMARY KEY,
  first_name  TEXT NOT NULL,
  last_name   TEXT NOT NULL
);

CREATE TABLE matches (
  id          SERIAL PRIMARY KEY,
  season_id   INTEGER NOT NULL REFERENCES seasons(id),
  home_team_id INTEGER NOT NULL REFERENCES teams(id),
  away_team_id INTEGER NOT NULL REFERENCES teams(id),
  played_at   TIMESTAMP NOT NULL,
  CHECK (home_team_id <> away_team_id)
);

CREATE TABLE referee_assignments (
  match_id    INTEGER NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
  referee_id  INTEGER NOT NULL REFERENCES referees(id),
  role        TEXT NOT NULL DEFAULT 'main',
  PRIMARY KEY (match_id, referee_id)
);

CREATE TABLE goals (
  id          SERIAL PRIMARY KEY,
  match_id    INTEGER NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
  player_id   INTEGER NOT NULL REFERENCES players(id),
  minute      INTEGER NOT NULL CHECK (minute >= 0)
);

-- Standings derived from match goals.
CREATE OR REPLACE VIEW standings AS
WITH per_match_goals AS (
  SELECT m.id AS match_id,
         m.season_id,
         m.home_team_id,
         m.away_team_id,
         COUNT(*) FILTER (WHERE p.team_id = m.home_team_id) AS home_goals,
         COUNT(*) FILTER (WHERE p.team_id = m.away_team_id) AS away_goals
  FROM matches m
  LEFT JOIN goals g  ON g.match_id = m.id
  LEFT JOIN players p ON p.id = g.player_id
  GROUP BY m.id
),
team_results AS (
  SELECT season_id, home_team_id AS team_id,
         home_goals AS goals_for, away_goals AS goals_against,
         CASE WHEN home_goals > away_goals THEN 3
              WHEN home_goals = away_goals THEN 1
              ELSE 0 END AS points
  FROM per_match_goals
  UNION ALL
  SELECT season_id, away_team_id AS team_id,
         away_goals AS goals_for, home_goals AS goals_against,
         CASE WHEN away_goals > home_goals THEN 3
              WHEN home_goals = away_goals THEN 1
              ELSE 0 END AS points
  FROM per_match_goals
)
SELECT season_id,
       team_id,
       SUM(points) AS points,
       SUM(goals_for) AS goals_for,
       SUM(goals_against) AS goals_against,
       SUM(goals_for) - SUM(goals_against) AS goal_difference
FROM team_results
GROUP BY season_id, team_id
ORDER BY season_id, points DESC, goal_difference DESC;

INSERT INTO seasons (name, start_date, end_date) VALUES
  ('2025 Spring', '2025-03-01', '2025-06-15');

INSERT INTO teams (name) VALUES ('Lions FC'), ('Hawks United');

INSERT INTO players (first_name, last_name, team_id) VALUES
  ('Sam', 'Lee', 1),
  ('Tasha', 'Owens', 2);

INSERT INTO referees (first_name, last_name) VALUES ('Jordan', 'Park');

INSERT INTO matches (season_id, home_team_id, away_team_id, played_at) VALUES
  (1, 1, 2, '2025-04-05 15:00:00');

INSERT INTO referee_assignments (match_id, referee_id) VALUES (1, 1);

INSERT INTO goals (match_id, player_id, minute) VALUES
  (1, 1, 12),
  (1, 1, 67),
  (1, 2, 80);
