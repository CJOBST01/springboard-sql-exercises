# Schema Critique

Notes on the three provided seed files (\`outer_space.sql\`, \`air_traffic.sql\`,
\`music.sql\`) and the changes I would make to each.

## 1. Outer Space

**Observed problems**

- Planet rows store \`moons\` as a comma-separated string. That makes counting,
  joining, and updating a single moon awkward.
- Galaxy and orbit data are repeated on every planet row instead of being
  normalised into their own tables.
- There is no primary key constraint enforced on every table; some only have a
  unique name column.

**Improvements**

- Split into \`galaxies\`, \`stars\`, \`planets\`, and \`moons\` tables with
  surrogate \`id SERIAL PRIMARY KEY\` columns and foreign keys.
- Each \`moons\` row points at one \`planets.id\`. The string column on
  \`planets\` goes away.
- Add \`NOT NULL\` constraints on names and reasonable check constraints on
  numeric values (orbital_period_days > 0, etc.).

```sql
CREATE TABLE galaxies (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE planets (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  galaxy_id INTEGER NOT NULL REFERENCES galaxies(id),
  orbital_period_days NUMERIC CHECK (orbital_period_days > 0)
);

CREATE TABLE moons (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  planet_id INTEGER NOT NULL REFERENCES planets(id) ON DELETE CASCADE
);
```

## 2. Air Traffic

**Observed problems**

- Each flight row stores \`airline\`, \`from_city\`, and \`to_city\` as text. The
  same airline appears many times with the same name; a typo creates a phantom
  carrier.
- Cities are not normalised either, so we cannot answer questions like “how many
  flights pass through SFO” without text matching.
- Times are stored as strings rather than as TIMESTAMP, which prevents
  comparison and arithmetic.

**Improvements**

- Add \`airlines\`, \`airports\`, and \`cities\` tables.
- Reference them from the flights table via foreign keys.
- Use \`TIMESTAMP\` columns for \`departs_at\` and \`arrives_at\`. Add a check
  constraint that arrival is after departure.

```sql
CREATE TABLE airlines (id SERIAL PRIMARY KEY, name TEXT NOT NULL UNIQUE);
CREATE TABLE airports (
  id SERIAL PRIMARY KEY,
  code TEXT NOT NULL UNIQUE,
  city TEXT NOT NULL
);
CREATE TABLE flights (
  id SERIAL PRIMARY KEY,
  airline_id INTEGER NOT NULL REFERENCES airlines(id),
  from_airport_id INTEGER NOT NULL REFERENCES airports(id),
  to_airport_id INTEGER NOT NULL REFERENCES airports(id),
  departs_at TIMESTAMP NOT NULL,
  arrives_at TIMESTAMP NOT NULL,
  CHECK (arrives_at > departs_at),
  CHECK (from_airport_id <> to_airport_id)
);
```

## 3. Music

**Observed problems**

- Songs store \`artist\` and \`album\` as plain text columns, which prevents the
  many-to-many relationship between artists and songs (think collaborations or
  features).
- Genre is stored on the song, not the album, even though many catalogues track
  it at album level. Either way, it is duplicated text.
- There is no notion of producer or release year separate from the album.

**Improvements**

- Tables: \`artists\`, \`albums\`, \`songs\`, plus a \`song_artists\` join table
  for collaborations.
- Move \`genre\` and \`released_year\` onto \`albums\` and add a \`genres\`
  lookup table so we can rename a genre in one place.

```sql
CREATE TABLE artists (id SERIAL PRIMARY KEY, name TEXT NOT NULL UNIQUE);
CREATE TABLE genres  (id SERIAL PRIMARY KEY, name TEXT NOT NULL UNIQUE);
CREATE TABLE albums (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  primary_artist_id INTEGER NOT NULL REFERENCES artists(id),
  genre_id INTEGER REFERENCES genres(id),
  released_year INTEGER
);
CREATE TABLE songs (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  album_id INTEGER NOT NULL REFERENCES albums(id) ON DELETE CASCADE,
  duration_seconds INTEGER CHECK (duration_seconds > 0)
);
CREATE TABLE song_artists (
  song_id INTEGER NOT NULL REFERENCES songs(id) ON DELETE CASCADE,
  artist_id INTEGER NOT NULL REFERENCES artists(id),
  PRIMARY KEY (song_id, artist_id)
);
```
