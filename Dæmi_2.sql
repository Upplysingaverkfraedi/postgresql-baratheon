CREATE OR REPLACE VIEW baratheon.v_pov_characters_human_readable AS
WITH pov_characters AS (
    SELECT
        -- Bara fyrranafnið ef það er hægt
        COALESCE(NULLIF(c.titles[1], ''), c.name) AS full_name,
        c.gender AS gender,
        COALESCE(father_c.name, 'Unknown') AS father,
        COALESCE(mother_c.name, 'Unknown') AS mother,
        COALESCE(spouse_c.name, 'Unknown') AS spouse,

        -- Breytir AC í jákvæða tölu og BC í neikvæða tölu fyrir fæðingarár
        CASE
            WHEN c.born IS NOT NULL AND c.born ~ '\d+.*AC' THEN CAST((regexp_match(c.born, '(\d+)[ ]*AC'))[1] AS INT)
            WHEN c.born IS NOT NULL AND c.born ~ '\d+.*BC' THEN -CAST((regexp_match(c.born, '(\d+)[ ]*BC'))[1] AS INT)
            ELSE NULL
        END AS born,

        -- Breytir AC í jákvæða tölu og BC í neikvæða tölu fyrir dánarár
        CASE
            WHEN c.died IS NOT NULL AND c.died ~ '\d+.*AC' THEN CAST((regexp_match(c.died, '(\d+)[ ]*AC'))[1] AS INT)
            WHEN c.died IS NOT NULL AND c.died ~ '\d+.*BC' THEN -CAST((regexp_match(c.died, '(\d+)[ ]*BC'))[1] AS INT)
            ELSE NULL
        END AS died,

        -- Reiknar aldur
        CASE
            WHEN c.died IS NOT NULL AND c.born IS NOT NULL THEN
                (CAST((regexp_match(c.died, '(\d+)'))[1] AS INT) - CAST((regexp_match(c.born, '(\d+)'))[1] AS INT))
            WHEN c.died IS NULL AND c.born IS NOT NULL THEN
                (300 - CAST((regexp_match(c.born, '(\d+)'))[1] AS INT))
            ELSE NULL
        END AS age,

        -- Lifandi eða látinn (TRUE ef lifandi, FALSE ef látinn)
        CASE
            WHEN c.died IS NULL THEN TRUE
            ELSE FALSE
        END AS alive,

        -- Listi af bókum þar sem persónan kemur fyrir
        ARRAY_AGG(b.name ORDER BY b.released ASC) AS books

    FROM
        got.characters AS c
    LEFT JOIN got.characters AS father_c ON c.father = father_c.id
    LEFT JOIN got.characters AS mother_c ON c.mother = mother_c.id
    LEFT JOIN got.characters AS spouse_c ON c.spouse = spouse_c.id
    LEFT JOIN got.character_books AS cb ON c.id = cb.character_id
    LEFT JOIN got.books AS b ON cb.book_id = b.id

    -- Veljum bara POV characters
    WHERE c.id IN (SELECT DISTINCT character_id FROM got.characters)

    -- Flokkun
    GROUP BY c.id, c.name, c.titles, c.gender, father_c.name, mother_c.name, spouse_c.name, c.born, c.died
)

-- Veljum alla flokkana í röð
SELECT
    full_name,
    CASE
        WHEN gender = 'Male' THEN 'M'
        WHEN gender = 'Female' THEN 'F'
        ELSE NULL
    END AS gender,
    father,
    mother,
    spouse,
    born,
    died,
    age,
    alive,
    books
FROM pov_characters
ORDER BY alive DESC, age DESC;

-- Keyra þetta til að sjá töfluna
SELECT * FROM baratheon.v_pov_characters_human_readable
ORDER BY alive DESC, age DESC;
