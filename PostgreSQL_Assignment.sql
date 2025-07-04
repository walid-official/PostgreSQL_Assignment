-- Active: 1747616765373@@localhost@5432@conservation_db
CREATE DATABASE conservation_db;


-- RANGERS TABLE --
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    region VARCHAR(255) NOT NULL
);
-- RANGERS TABLE VALUES --
INSERT INTO rangers (name, region) 
VALUES 
('Alice Green', 'Northern Hills'), 
('Bob White', 'River Delta'), 
('Carol King', 'Mountain Range');

-- SPECIES TABLE --
CREATE TABLE species  (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(255) NOT NULL,
    scientific_name VARCHAR(255) NOT NULL,
    discovery_date DATE,
    conservation_status VARCHAR(50) 
);

-- SPECIES TABLE VALUES --
INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status) 
VALUES
('Snow Leopard', ' Panthera uncia', '1775-01-01', 'Endangered'),
('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');


-- SIGHTINGS TABLE --
CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    species_id INT REFERENCES species(species_id),
    ranger_id INT REFERENCES rangers(ranger_id),
    location VARCHAR(255) NOT NULL,
    sighting_time TIMESTAMP  NOT NULL,
    notes TEXT
);

-- INSERT VALUES INTO SIGHTINGS TABLE --
INSERT INTO sightings (species_id, ranger_id, location, sighting_time, notes)
VALUES
(1, 1,  'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);

-- 1 FIRST  TASK --
INSERT INTO rangers (name, region) VALUES ('Derek Fox', 'Coastal Plains');

-- 2 SECOND TASK --
SELECT COUNT(DISTINCT species_id) AS unique_species_count FROM sightings;


-- 3 THIRD TASK --
SELECT * FROM sightings 
WHERE location LIKE '%Pass%';

-- 4 FOURTH TASK --
SELECT rangers.name, COUNT(sighting_id) AS total_sightings FROM rangers
INNER JOIN sightings ON rangers.ranger_id = sightings.ranger_id
GROUP BY rangers.name;

-- 5 FIFTH TASK --
SELECT species.common_name 
FROM species 
LEFT JOIN sightings si ON species.species_id = si.species_id
WHERE si.species_id IS NULL;

-- 6 SIXTH TASK --
SELECT 
 species.common_name,
 sightings.sighting_time,
 rangers.name
from  sightings 
JOIN rangers ON sightings.ranger_id = rangers.ranger_id
JOIN species ON sightings.species_id = species.species_id
ORDER BY sightings.sighting_time DESC
LIMIT 2;

-- 7 SEVENTH TASK --
UPDATE species
SET conservation_status = 'Historic'
WHERE EXTRACT(YEAR FROM species.discovery_date) < 1800;


-- 8 EIGHTH TASK --
SELECT
  sighting_id,
  CASE 
    WHEN EXTRACT(HOUR FROM sighting_time) < 12 THEN 'Morning'
    WHEN EXTRACT(HOUR FROM sighting_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
  END AS time_of_day
FROM sightings;

-- 9 NINTH TASK
DELETE FROM rangers
WHERE ranger_id NOT IN (
  SELECT DISTINCT ranger_id FROM sightings
);


