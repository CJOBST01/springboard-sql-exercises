-- medical_center.sql
-- Schema for the medical center exercise.
--
-- Notes:
--   - Doctors and patients have a many-to-many relationship via visits.
--   - A visit may produce zero or many diagnoses (a many-to-many between
--     visits and diseases via visit_diagnoses).
--   - Diseases are normalised so we can describe them once and reuse them.

DROP DATABASE IF EXISTS medical_center;
CREATE DATABASE medical_center;
\c medical_center

CREATE TABLE doctors (
  id           SERIAL PRIMARY KEY,
  first_name   TEXT NOT NULL,
  last_name    TEXT NOT NULL,
  specialty    TEXT
);

CREATE TABLE patients (
  id           SERIAL PRIMARY KEY,
  first_name   TEXT NOT NULL,
  last_name    TEXT NOT NULL,
  date_of_birth DATE NOT NULL
);

CREATE TABLE diseases (
  id           SERIAL PRIMARY KEY,
  name         TEXT NOT NULL UNIQUE,
  description  TEXT
);

CREATE TABLE visits (
  id           SERIAL PRIMARY KEY,
  doctor_id    INTEGER NOT NULL REFERENCES doctors(id),
  patient_id   INTEGER NOT NULL REFERENCES patients(id),
  visit_date   TIMESTAMP NOT NULL DEFAULT NOW(),
  notes        TEXT
);

CREATE TABLE visit_diagnoses (
  visit_id     INTEGER NOT NULL REFERENCES visits(id) ON DELETE CASCADE,
  disease_id   INTEGER NOT NULL REFERENCES diseases(id),
  PRIMARY KEY (visit_id, disease_id)
);

INSERT INTO doctors (first_name, last_name, specialty) VALUES
  ('Hannah', 'Reyes', 'General Practice'),
  ('Marcus', 'Okafor', 'Cardiology');

INSERT INTO patients (first_name, last_name, date_of_birth) VALUES
  ('Anna', 'Liu', '1985-04-12'),
  ('Theo', 'Burke', '1972-09-30');

INSERT INTO diseases (name, description) VALUES
  ('Influenza', 'Seasonal flu'),
  ('Hypertension', 'High blood pressure');

INSERT INTO visits (doctor_id, patient_id, notes) VALUES
  (1, 1, 'Routine check-up'),
  (2, 2, 'Follow-up after stress test');

INSERT INTO visit_diagnoses (visit_id, disease_id) VALUES
  (1, 1),
  (2, 2);
