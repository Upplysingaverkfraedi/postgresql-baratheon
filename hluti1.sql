--Liður 1
-- Using a FULL OUTER JOIN to fetch all kingdoms and houses, including those without matches
SELECT
    k.name AS kingdom_id,
    h.name AS house_id
FROM
    atlas.kingdoms k
FULL OUTER JOIN
    got.houses h ON k.name = h.region;

-- Create a new table if it does not exist, with a unique constraint to prevent duplicate mappings
CREATE TABLE IF NOT EXISTS baratheon.tables_mapping (
    kingdom_name TEXT,
    house_name TEXT,
    UNIQUE(kingdom_name, house_name)
);

-- Define a Common Table Expression (CTE) to simplify the insertion process by handling complex join logic separately
WITH kingdom_house_mapping AS (
    SELECT
        k.gid AS kingdom_id,  -- Assuming 'gid' is a unique identifier for kingdoms
        h.id AS house_id      -- Assuming 'id' is a unique identifier for houses
    FROM
        atlas.kingdoms k
    FULL OUTER JOIN
        got.houses h ON k.name = h.region
)
-- Insert data into the mapping table, avoiding duplicates for house IDs
INSERT INTO baratheon.tables_mapping (kingdom_id, house_id)
SELECT kingdom_id, house_id FROM kingdom_house_mapping
ON CONFLICT (house_id) DO NOTHING;  -- PostgreSQL-specific UPSERT handling

-- Query to fetch and display all current mappings from the tables_mapping table
SELECT * FROM baratheon.tables_mapping;






--liður 2

WITH gagntaek_vorpun AS (
    -- Mapping locations to houses based on the location's name possibly matching the house's seat or another attribute
    SELECT
        l.gid AS location_id,
        l.name AS location_name,
        h.id AS house_id,
        h.name AS house_name,
        l.summary AS summary

    FROM
        atlas.locations l
    JOIN
        got.houses h ON l.name = ANY(h.seats)  -- Assuming 'seats' could match locations by name
    WHERE
        h.region = 'The North'
),
X AS (
select *, regexp_match(summary, house_name) from gagntaek_vorpun
),
-- UPSERT into the baratheon.tables_mapping table
y as (SELECT
    case when house_name like concat('%',location_name) then 1 else 0 end as better_match,
*
      FROM x),

z as (select row_number() over (partition by location_id order by better_match desc) as rank, * from y)
--INSERT INTO baratheon.tables_mapping (house_id, location_id)
, g as (select house_id, location_id from z where rank = 1),

-- skoða house_id = 120 af hverju location_id 190 og 301 koma upp
   -- Ranking based on the direct string length comparison

u AS (
    SELECT
        *,
        -- Calculate the length of the substring match and use it as the matching score
        CASE WHEN house_name LIKE CONCAT('%', location_name, '%')
             THEN LENGTH(location_name)
             ELSE 0
        END AS match_length
    FROM x
),
w AS (
    SELECT
        *,
        -- Rank locations for each house based on the match length
        ROW_NUMBER() OVER (PARTITION BY house_id ORDER BY match_length DESC) AS rank
    FROM u
)


-- Upsert the best match into the mapping table
INSERT INTO baratheon.tables_mapping (house_id, location_id)
SELECT
    house_id,
    location_id
FROM w
WHERE rank = 1
ON CONFLICT (house_id) DO
    UPDATE SET location_id = excluded.location_id;



-- Now select results for 'The North' region
SELECT
    h.name AS house_name,
    h.id AS house_id,
    l.name AS location_name,
    l.gid AS location_id
FROM
    gagntaek_vorpun otm
JOIN
    got.houses h ON otm.house_id = h.id
JOIN
    atlas.locations l ON otm.location_id = l.gid
WHERE
    h.region = 'The North';  -- Corrected to filter houses by region

-- Select all from the mapping result
SELECT *
FROM gagntaek_vorpun;



SELECT * FROM baratheon.tables_mapping;



--liður 3
-- sql fyrirspurn sem finnur stærstu ættir allra norðmanna
-- Define CTE for extracting houses in 'The North' and their sworn members
WITH northern_houses AS (
    SELECT id, unnest(sworn_members) AS member_id  -- Expand the array of sworn members into individual rows
    FROM got.houses
    WHERE region = 'The North'  -- Filter for houses located in 'The North'
),

-- Define CTE for linking members to their last names using character data
northern_characters AS (
    SELECT
        nh.member_id,
        split_part(c.name, ' ', array_length(string_to_array(c.name, ' '), 1)) AS family_name  -- Extract the last part of the name, assumed to be the family name
    FROM
        northern_houses nh
    JOIN
        got.characters c ON nh.member_id = c.id  -- Join on character ID to get full names
),

-- Aggregate and count members by family, filtering for families with more than 5 members
family_counts AS (
    SELECT
        family_name,
        COUNT(*) AS member_count  -- Count the number of members in each family
    FROM
        northern_characters
    GROUP BY
        family_name  -- Group results by family name
    HAVING
        COUNT(*) > 5  -- Only include families with more than 5 members
)

-- Select and order the results to show the largest families first
SELECT
    family_name,
    member_count
FROM
    family_counts
ORDER BY
    member_count DESC,  -- Order by number of members in descending order
    family_name ASC;    -- In case of ties in member count, order alphabetically by family name


