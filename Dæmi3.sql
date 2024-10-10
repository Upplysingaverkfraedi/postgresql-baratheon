-- bý til fallið baratheon.get_kingdom_size
CREATE OR REPLACE FUNCTION baratheon.get_kingdom_size(kingdom_id INT)
RETURNS INTEGER AS $$
DECLARE
    kingdom_area_km2 INTEGER;
BEGIN
    -- tryggja að aðeins gilt kingdom_id er notað í fallinu
    IF NOT EXISTS (SELECT 1 FROM atlas.kingdoms WHERE gid = kingdom_id) THEN
        RAISE EXCEPTION 'Ólöglegt kingdom_id: %', kingdom_id;
    END IF;

    -- nota ST_Area til að reikna flatarmál konungsríkja í ferkílómetrum (km²) með geog dálkinum
    SELECT ROUND(ST_Area(geog::geography) / 1000000.0)  -- Ferkílómetrar án aukastafa
    INTO kingdom_area_km2
    FROM atlas.kingdoms
    WHERE gid = kingdom_id;

    RETURN kingdom_area_km2;
END;
$$ LANGUAGE plpgsql;


-- nota baratheon.get_kingdom_size fallið til að finna fllatarmál þriðja stærsta konungsríkissins
SELECT gid, name, baratheon.get_kingdom_size(gid) AS kingdom_area_km2
FROM atlas.kingdoms
ORDER BY kingdom_area_km2 DESC
OFFSET 2 LIMIT 1;


-- SQL fyrirspurn sem finnur sjaldgæfustu staðsetningategund utan The Seven Kingdoms
WITH tegundir AS (
    SELECT type, COUNT(*) AS count
    FROM atlas.locations
    WHERE geog IS NOT NULL
    AND geog NOT IN (SELECT geog FROM atlas.kingdoms)
    GROUP BY type
),
minnst AS (
    SELECT MIN(count) AS minnst
    FROM tegundir
)
SELECT r.type, l.name
FROM atlas.locations l
JOIN tegundir r ON l.type = r.type
WHERE r.count = (SELECT minnst FROM minnst);
