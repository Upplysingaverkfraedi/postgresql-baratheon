Taflan ´baratheon.v_pov_characters_human_readable´ skilar nafni persónunnar en ef það er er fleira en eitt nafn þá er valið fyrsta nafnið.

Þessi skipun sér til þess: 
´COALESCE(NULLIF(c.titles[1], ''), c.name)´

Til að finna út hvort persónan eigi faðir er notað eftir farandi skipun:
´COALESCE(father_c.name, 'Unknown') AS father,´

og móðir
´COALESCE(mother_c.name, 'Unknown') AS mother,´

Ef það á enga foreldra kemur upp 'Unknown' í töfluna.

Til að komast að því hvort persónan eigi maka er notað eftirfarandi:
´COALESCE(spouse_c.name, 'Unknown') AS spouse,´

Til að finna út hvenær persónan fæddist:

´    CASE
            WHEN c.born IS NOT NULL AND c.born ~ '\d+.*AC' THEN CAST((regexp_match(c.born, '(\d+)[ ]*AC'))[1] AS INT)
            WHEN c.born IS NOT NULL AND c.born ~ '\d+.*BC' THEN -CAST((regexp_match(c.born, '(\d+)[ ]*BC'))[1] AS INT)
            ELSE NULL
        END AS born,´

og til að finna út hvenær persónan lést:

´CASE
            WHEN c.died IS NOT NULL AND c.died ~ '\d+.*AC' THEN CAST((regexp_match(c.died, '(\d+)[ ]*AC'))[1] AS INT)
            WHEN c.died IS NOT NULL AND c.died ~ '\d+.*BC' THEN -CAST((regexp_match(c.died, '(\d+)[ ]*BC'))[1] AS INT)
            ELSE NULL
        END AS died,´

Til að reikna út aldurinn:

´CASE
            WHEN c.died IS NOT NULL AND c.born IS NOT NULL THEN
                (CAST((regexp_match(c.died, '(\d+)'))[1] AS INT) - CAST((regexp_match(c.born, '(\d+)'))[1] AS INT))
            WHEN c.died IS NULL AND c.born IS NOT NULL THEN
                (300 - CAST((regexp_match(c.born, '(\d+)'))[1] AS INT))
            ELSE NULL
        END AS age,´

En ef dánarár er ekki til staðar þá er reiknað aldurinn út frá 300 AC.

Skilar tvíundarbreytu um hvort persónan sé á lífi eða ekki:

´CASE
            WHEN c.died IS NULL THEN TRUE
            ELSE FALSE
        END AS alive,´


Býr til lista yfir yfir bókarheiti sem persónan kemur fyrir í, í réttri röð eftir útgáfuárum:

´ARRAY_AGG(b.name ORDER BY b.released ASC) AS books´

Veljum hvaða flokka á að birta í töflunni ´baratheon.v_pov_characters_human_readable´:

´SELECT
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
ORDER BY alive DESC, age DESC;´

Þar sem breytt er ´Male´ í M og ´Female´ í F.

Til að geta birt myndina er svo keyrt eftirfarandi:

´SELECT * FROM baratheon.v_pov_characters_human_readable
ORDER BY alive DESC, age DESC;´







