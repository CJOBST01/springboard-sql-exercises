# Data Modeling Exercise

Schema designs and critiques for Unit 17.2.

## Part 1: Schema Design

Each \`*.sql\` file is a runnable PostgreSQL script that drops and recreates the
database, defines the schema, and inserts a tiny seed for sanity checking.

- \`medical_center.sql\` — doctors, patients, visits, diseases, and a join table
  for diagnoses per visit.
- \`craigslist.sql\` — regions, users (with preferred region), categories,
  posts, and a join table for post categories.
- \`soccer_league.sql\` — seasons, teams, players, referees, matches, goals,
  referee assignments, and a derived \`standings\` view.

## Part 2: Schema Critique

See \`schema_critique.md\` for written notes on how to improve the provided
Outer Space, Air Traffic, and Music schemas. The same file lists the concrete
DDL changes (new tables, foreign keys, normalisation, constraints) that the
seed files would need.

## Running

```bash
psql -U postgres -f medical_center.sql
psql -U postgres -f craigslist.sql
psql -U postgres -f soccer_league.sql
```
