# Dæmi 1

## Útskýring á lið eitt.

`SELECT
    k.name AS kingdom_id,
    h.name AS house_id
FROM
    atlas.kingdoms k
FULL OUTER JOIN
    got.houses h ON k.name = h.region;`

-Þessi fyrirspurn sækir lista yfir öll konungsríki og samsvarandi hús þeirra
 úr Game of Thrones heiminum. Það notar PostgreSQL skipunina FULL OUTER JOIN
 sem sér til þess að gögn úr báðum töflum séu teknar inn hvort sem match finnst
 eða ekki.

 `CREATE TABLE IF NOT EXISTS baratheon.tables_mapping (
     kingdom_name TEXT,
     house_name TEXT,
     UNIQUE(kingdom_name, house_name)
 );`

-CREATE TABLE IF NOT EXISTS = skipun sem PostgreSQL styður til að passa að tafla sé
búin til aðeins ef hún er ekki til nú þegar.

-UNIQUE= skipunin passar að kingdom og house pörin sé einstök inni í töflunni.

`WITH kingdom_house_mapping AS (
    SELECT
        k.gid AS kingdom_id,
        h.id AS house_id
    FROM
        atlas.kingdoms k
    FULL OUTER JOIN
        got.houses h ON k.name = h.region
)
INSERT INTO baratheon.tables_mapping (kingdom_id, house_id)
SELECT kingdom_id, house_id FROM kingdom_house_mapping
ON CONFLICT (house_id) DO NOTHING;`

-Tilgangur kóðans er að setja inn gögnin í baratehon.tables_mapping án þess
að upp komi tvítekningar.

-ON CONFLICT DO NOTHING= sérstakur klási í PostgreSQL sér um að höndla conflicts.

`SELECT * FROM baratheon.tables_mapping;`

-Þessi skipun sækir töfluna tables_mapping fyrir okkur.

Niðurstaðan er eftirfarandi og sýnir öll ríki og hús líka þau sem hafa ekki samsvörun:

The Riverlands,House Slynt of Harrenhal
The Stormlands,House Baratheon of Storm's End
The Vale,House Arryn of the Eyrie
The Reach,House Leygood
The Stormlands,House Cafferen of Fawnton
The Westerlands,House Kyndall
Dorne,House Drinkwater
The Riverlands,House Erenford
The North,House Bolton of the Dreadfort
The Westerlands,House Lannister of Casterly Rock
,House Buckwell of the Antlers
The Stormlands,House Buckler of Bronzegate
The North,House Flint of Flint's Finger
Dorne,House Blackmont of Blackmont
Dorne,House Nymeros Martell of Sunspear
The Riverlands,House Grey
The Stormlands,House Durrandon
The Reach,House Tyrell of Highgarden
The North,House Flint of Widow's Watch
The Westerlands,House Foote
Iron Islands,House Kenning of Harlaw
The Reach,House Fossoway of Cider Hall
Iron Islands,House Saltcliffe of Saltcliffe
The Westerlands,House Estren of Wyndhall
Iron Islands,House Sparr of Great Wyk
The Stormlands,House Staedmon of Broad Arch
The Westerlands,House Lorch
The North,House Boggs
Iron Islands,House Goodbrother of Hammerhorn
The Westerlands,House Jast
The Westerlands,House Stackspear
The Riverlands,House Mooton of Maidenpool
The Reach,House Varner
Iron Islands,House Merlyn of Pebbleton
The Stormlands,House Mertyns of Mistwood
The Westerlands,House Turnberry
The Westerlands,House Yew
,House Gaunt
Iron Islands,House Farwynd of Sealskin Point
The Westerlands,House Payne
The Reach,House Inchfield
Dorne,House Jordayne of the Tor
Iron Islands,House Harlaw of Grey Garden
The Reach,House Cockshaw
Iron Islands,House Greyjoy of Pyke
Iron Islands,House Tawney of Orkmont
The Stormlands,House Grandison of Grandview
Dorne,House Toland of Ghost Hill
The North,House Locke of Oldcastle
The North,House Dustin of Barrowton
The Westerlands,House Farman of Faircastle
The Reach,House Hightower of the Hightower
The North,House Hornwood of Hornwood
The North,House Norrey
The Vale,House Royce of Runestone
The Westerlands,House Lannister of Lannisport
The Westerlands,House Lefford of the Golden Tooth
The Vale,House Longthorpe of Longsister
The Riverlands,House Goodbrook
The Riverlands,House Nayland of Hag's Mire
The Riverlands,House Charlton
The Stormlands,House Cole
The North,House Condon
,House Farring
The Riverlands,House Smallwood of Acorn Hall
Iron Islands,House Stonetree of Harlaw
The North,House Flint of the mountains
,House Brune of the Dyre Den
The Westerlands,House Swyft of Cornfield
,House Boggs of Crackclaw Point
Iron Islands,House Shepherd
Iron Islands,House Blacktyde of Blacktyde
The Reach,House Tarly of Horn Hill
The Stormlands,House Toyne
The Vale,House Moore
Iron Islands,House Codd
The Reach,House Norcross
The Riverlands,House Paege
The Vale,House Baelish of the Fingers
Iron Islands,House Harlaw of Harlaw Hall
Iron Islands,House Ironmaker
The Riverlands,House Haigh
Iron Islands,House Harlaw of Harridan Hill
The Reach,House Serry of Southshield
,House Rambton
The Reach,House Mullendore of Uplands
,House Byrch
The Riverlands,House Tully of Riverrun
The Stormlands,House Trant of Gallowsgrey
,House Velaryon of Driftmark
,House Darklyn of Duskendale
The North,House Stark of Winterfell
The Riverlands,House Frey of the Crossing
The Reach,House Ball
The Reach,House Bushy
The Riverlands,House Baelish of Harrenhal
The Reach,House Wythers
The Westerlands,House Yarwyck
The Reach,House Hunt
Iron Islands,House Humble
Iron Islands,House Harlaw of Harlaw
The Reach,House Osgrey of Standfast
The Reach,House Gardener of Highgarden
The Reach,House Fossoway of New Barrel
The Westerlands,House Tarbeck of Tarbeck Hall
The Westerlands,House Reyne of Castamere
Dorne,House Dayne of Starfall
The Vale,House Torrent of Littlesister
Dorne,House Uller of Hellholt
The Westerlands,House Hetherspoon
The North,House Thenn
The Westerlands,House Casterly of Casterly Rock
Iron Islands,House Wynch of Iron Holt
,House Corbray of Heart's Home
The Reach,House Webber of Coldmoat
The Reach,House Willum
The North,House Woolfield
The North,House Mollen
The Reach,House Beesbury of Honeyholt
The Westerlands,House Bettley
The Reach,House Ambrose
,House Blount
The Westerlands,House Broom
Iron Islands,House Sharp
The Riverlands,House Frey of Riverrun
The Reach,House Tyrell of Brightwater Keep
The Stormlands,House Foote of Nightsong
,House Redbeard
,House Cox of Saltpans
,House Targaryen of King's Landing
The Reach,House Rowan of Goldengrove
The North,House Woods
,House Fenn
The Reach,House Lyberr
The Reach,House Oakheart of Old Oak
The Riverlands,House Deddings
The Westerlands,House Brax of Hornvale
Iron Islands,House Weaver
The Reach,House Chester of Greenshield
,House Chyttering
The Riverlands,House Blanetree
The Riverlands,House Roote of Lord Harroway's Town
The Stormlands,House Hasty
The Reach,House Graceford of Holyhall
The Westerlands,House Sarsfield of Sarsfield
The Stormlands,House Estermont of Greenstone
The Riverlands,House Blackwood of Raventree Hall
The Reach,House Cuy of Sunhouse
The Riverlands,House Darry of Darry
Iron Islands,House Farwynd of the Lonely Light
The Reach,House Bulwer of Blackcrown
The Riverlands,House Bigglestone
The Reach,House Redding
,House Darke
The Stormlands,House Morrigen of Crow's Nest
The North,House Tallhart of Torrhen's Square
The North,House Mormont of Bear Island
,House Hollard
The Stormlands,House Caron of Nightsong
,House Crabb
,House Celtigar of Claw Isle
The Riverlands,House Hawick of Saltpans
The North,House Cerwyn of Cerwyn
The Reach,House Caswell of Bitterbridge
,House Chelsted
The Reach,House Crane of Red Lake
Dorne,House Allyrion of Godsgrace
The Riverlands,House Piper of Pinkmaiden
,House Vypren
The Stormlands,House Horpe
The Westerlands,House Plumm
The Vale,House Redfort of Redfort
The Stormlands,House Bolling
Iron Islands,House Stonehouse of Old Wyk
The Vale,House Egen
The Stormlands,House Seaworth of Cape Wrath
The Riverlands,House Grell
The Reach,House Costayne of Three Towers
The Westerlands,House Crakehall of Crakehall
The Riverlands,House Lychester
Dorne,House Manwoody of Kingsgrave
The Reach,House Meadows of Grassy Vale
The Westerlands,House Greenfield of Greenfield
The Riverlands,House Bracken of Stone Hedge
The Vale,House Belmore of Strongsong
The North,House Cassel
,House Reed of Greywater Watch
,House Bywater
The Westerlands,House Westerling of the Crag
,House Kettleblack
The Riverlands,House Ryger of Willow Wood
Dorne,House Fowler of Skyreach
The Reach,House Ashford of Ashford
The Reach,House Florent of Brightwater Keep
,House Pyle
The Vale,House Sunderland of the Three Sisters
The North,House Slate of Blackpool
The Riverlands,House Vance of Atranta
The Reach,House Vyrwel of Darkdell
The Vale,House Upcliff
The Riverlands,House Vance of Wayfarer's Rest
The Westerlands,House Moreland
The Stormlands,House Musgood
Iron Islands,House Myre of Harlaw
The Reach,House Hastwyck
The Riverlands,House Mallister of Seagard
The Stormlands,House Connington of Griffin's Roost
The Vale,House Lynderly of the Snakewood
The Reach,House Lowther
The Vale,House Grafton of Gulltown
,House Massey of Stonedance
The Riverlands,House Mudd of Oldstones
The Reach,House Redwyne of the Arbor
The Reach,House Conklyn
The Reach,House Uffering
The Vale,House Hardyng
The North,House Wells
Iron Islands,House Hoare of Orkmont
The North,House Karstark of Karhold
Iron Islands,House Goodbrother of Shatterstone
,House Staunton of Rook's Rest
The Reach,House Peake of Starpike
Dorne,House Wells
The Stormlands,House Peasebury of Poddingfield
,House Mallery
The North,House Towers
,House Rollingford
The Stormlands,House Wylde of Rain House
The Reach,House Hewett of Oakenshield
The Stormlands,House Swann of Stonehelm
The North,House Stout of Goldgrass
The Riverlands,House Whent of Harrenhal
,House Stokeworth of Stokeworth
The North,House Greenwood
The Westerlands,House Marbrand of Ashemark
The Reach,House Merryweather of Longtable
The Westerlands,House Ruttiger
The North,House Poole
,House Manning
,House Templeton
The Reach,House Rhysling
The Reach,House Risley
The Stormlands,House Gower
The Riverlands,House Wayn
,House Thorne
,House Baratheon of Dragonstone
,House Hardy
The Riverlands,House Heddle
The Stormlands,House Penrose of Parchments
The Westerlands,House Prester of Feastfires
The Westerlands,House Clifton
The Reach,House Blackbar of Bandallon
The Westerlands,House Clegane
,House Greengood
The Vale,House Waxley of Wickenden
The Westerlands,House Vikary
,House Brune of Brownhollow
The Riverlands,House Wode
Dorne,House Yronwood of Yronwood
The Riverlands,House Butterwell
,House Baratheon of King's Landing
,House Blackfyre of King's Landing
The Stormlands,House Lonmouth
The Riverlands,House Qoherys of Harrenhal
,House Longwaters
Dorne,House Dalt of Lemonwood
The Westerlands,House Peckledon
Iron Islands,House Drumm of Old Wyk
The Vale,House Tollett of the Grey Glen
Dorne,House Dayne of High Hermitage
The Stormlands,House Dondarrion of Blackhaven
The North,House Glover of Deepwood Motte
Dorne,House Gargalen of Salt Shore
The North,House Harclay
The Reach,House Norridge
The Stormlands,House Wagstaff
The Westerlands,House Banefort of Banefort
,House Bar Emmon of Sharp Point
The Vale,House Borrell of Sweetsister
Iron Islands,House Harlaw of the Tower of Glimmering
The Vale,House Hunter of Longbow Hall
The North,House Liddle
The Riverlands,House Lannister of Darry
Iron Islands,House Botley of Lordsport
The Vale,House Coldwater of Coldwater Burn
The Stormlands,House Fell of Felwood
The North,House Manderly of White Harbor
The Stormlands,House Errol of Haystack Hall
Dorne,House Qorgyle of Sandstone
The Westerlands,House Kenning of Kayce
The Vale,House Royce of the Gates of the Moon
,House Hayford of Hayford
Dorne,House Santagar of Spottswood
,House Rosby of Rosby
The Westerlands,House Spicer of Castamere
The Westerlands,House Lydden of Deep Den
,House Rykker of Duskendale
The Riverlands,House Lothston of Harrenhal
The Riverlands,House Strong of Harrenhal
The Stormlands,House Tarth of Evenfall Hall
The Stormlands,House Selmy of Harvest Hall
The Vale,House Shett of Gull Tower
Dorne,House Vaith of the Red Dunes
The Vale,House Waynwood of Ironoaks
The North,House Umber of the Last Hearth
Iron Islands,House Volmark
The North,House Wull
,House Hogg of Sow's Horn
,House Strickland
,House Quagg
The Reach,House Grimm of Greyshield
The North,House Ryswell of the Rills
,House Sunglass of Sweetport Sound
The Reach,House Bridges
The Vale,House Elesham of the Paps
The Riverlands,House Harlton
The Westerlands,House Sarwyck
The North,House Woodfoot of Bear Island
The Vale,House Breakstone
The Riverlands,House Keath
The Riverlands,House Justman
,House Harte
The Vale,House Pryor of Pebble
The Reach,House Roxton of the Ring
The North,House Crowl of Deepdown
The North,House Magnar of Kingshouse
The Reach,House Cordwayner of Hammerhal
The Stormlands,House Tudbury
The Reach,House Footly of Tumbleton
The Vale,House Melcolm of Old Anchor
The Reach,House Orme
The Westerlands,House Ferren
Iron Islands,House Orkwood of Orkmont
The Westerlands,House Falwell
The Vale,House Arryn of Gulltown
The North,House Amber
The Reach,House Westbrook
The Westerlands,House Drox
,House Edgerton
The Westerlands,House Hawthorne
The Stormlands,House Herston
The Reach,House Durwell
The Riverlands,House Terrick
The Riverlands,House Towers of Harrenhal
The Westerlands,House Serrett of Silverhill
Dorne,House Wyl of the Boneway
The Westerlands,House Myatt
The North,House Lightfoot
The North,House Ironsmith
Iron Islands,House Greyiron of Orkmont
The North,House Waterman
The North,House Moss
The Reach,House Kidwell of Ivy Hall
Iron Islands,House Goodbrother of Corpse Lake
The Westerlands,House Westford
The North,House Long
The Westerlands,House Hamell
The Westerlands,House Lantell
Iron Islands,House Goodbrother of Crow Spike Keep
The North,House Fisher of the Stony Shore
,House Cressey
The North,House Greystark of Wolf's Den
The Riverlands,House Hook
The North,House Ryder of the Rills
,House Darkwood
,House Follard
The Riverlands,House Chambers
The Vale,House Donniger
Iron Islands,House Sunderly of Saltcliffe
,House Cray
Dorne,House Ladybright
The Reach,House Osgrey of Leafy Lake
The Westerlands,House Garner
The Reach,House Sloane
The Stormlands,House Kellington
The Reach,House Oldflowers
The North,House Overton
The Westerlands,House Doggett
The Vale,House Shett of Gulltown
The Riverlands,House Lolliston
The North,House Forrester
The Reach,House Woodwright
The Reach,House Dunn
The Reach,House Middlebury
The Reach,House Shermer of Smithyton
The Reach,House Graves
The Stormlands,House Swygert
The North,House Bole
The North,House Branch
The Riverlands,House Shawney
,House Cargyll
,House Wendwater
The North,House Burley
The North,House Whitehill
The Vale,House Wydman
The Reach,House Hutcheson
The Westerlands,House Parren
The Reach,House Yelshire
The North,House Ashwood
,House Blackmyre
The Westerlands,House Lannett
The Westerlands,House Lanny
Iron Islands,House Netley
The Riverlands,House Nutt
,House Peat
The Riverlands,House Perryn
The Reach,House Pommingham
The Vale,House Ruthermont
The Riverlands,House Fisher
The North,House Branfield
The Stormlands,House Wensington
The North,House Knott
The Riverlands,House Harroway of Harrenhal
The North,House Flint of Breakstone Hill
Iron Islands,House Goodbrother of Downdelving
Dorne,House Shell
The North,House Glenmore
The Riverlands,House Teague
The Vale,House Brightstone
Dorne,House Dryland
Dorne,House Briar
Dorne,House Brook
Dorne,House Brownhill
,House Langward
Dorne,House Holt
Dorne,House Lake
The Vale,House Shell
The Reach,House Appleton of Appleton
The North,House Lake
The Vale,House Lipps
,House Pyne
,House Cave
Iron Islands,House Goodbrother of Orkmont
The Stormlands,House Rogers of Amberly
The North,House Holt
Dorne,House Hull
The North,House Frost
The Vale,House Hersy of Newkeep
The North,House Marsh
The Reach,House Stackhouse
,House Dargood
Dorne,House Wade
The Westerlands,House Algood
The North,House Stane of Driftwood Hall
The Crownsland,
Gift,

## Útskýring á lið 2

Nokkur atriði úr kóðanum til að skoða.

`WITH gagntaek_vorpun AS (
    SELECT
        l.gid AS location_id,
        l.name AS location_name,
        h.id AS house_id,
        h.name AS house_name,
        l.summary AS summary
    FROM
        atlas.locations l
    JOIN
        got.houses h ON l.name = ANY(h.seats)
    WHERE
        h.region = 'The North'
)`

-Hér býr kóðinn til kortlagningu (gagntaek_vorpun) staðsetningar á hús út frá staðsetningarheiti
 sem gæti passað við hvaða sæti hússins sem er (ANY(h.sæti)).

`X AS (
    SELECT *, regexp_match(summary, house_name) FROM gagntaek_vorpun
),
y AS (
    SELECT
        CASE WHEN house_name LIKE concat('%',location_name) THEN 1 ELSE 0 END as better_match,
        *
    FROM x
),
z AS (
    SELECT row_number() OVER (PARTITION BY location_id ORDER BY better_match DESC) as rank, * FROM y
)`

Hér er verið að að vinna með þegar það koma tvívegis mötch og unnið úr hvernig eigi að velja betra
matchið. Þá er þetta gert til að grípa tvítekningar.

`g AS (
    SELECT house_id, location_id FROM z WHERE rank = 1
)`

- skipun sem velur besta matchið. Eða 1 frekar  en 0.

`INSERT INTO baratheon.tables_mapping (house_id, location_id)
SELECT house_id, location_id FROM g
ON CONFLICT (house_id) DO UPDATE SET location_id = excluded.location_id;`

-Varpar inn í baratheon.tables_mapping töfluna og leysir árekstra með því að uppfæra
 núverandi færslur ef house_id er þegar til í töflunni.

`SELECT
    h.name AS house_name,
    h.id AS house_id,
    l.name AS location_name,
    l.gid AS location_id
FROM
    gagntaek_vorpun otm
JOIN
    got.houses h ON otm.house_id = h.id
JOIN
    atlas.locations l ON otm.location_id = l.id
WHERE
    h.region = 'The North';`

-Sýnir endalegar upplýsingar fyrir norðrið það sem hver staður passar við eitt hús.

Kom tvítekning í kóðanum þar sem tvær staðsetningar mötchuðu við sama hús sem ekki náðist
að leysa úr. Reynt var að útfæra kóða sem myndi velja að substringið sem væri lengra myndi
veljast sem match en ekki tókst það. Þannig að dæmið náð ekki að keyra.

## Útskýring á lið 3

`WITH northern_houses AS (
    SELECT id, unnest(sworn_members) AS member_id
    FROM got.houses
    WHERE region = 'The North'
),`

-Þessi CTE finnur alla þá sem eru sworn members í húsum sem eru staðsett
í norðrinu.
unnest(sworn_members) = þessi postgreSQL stækkar fylki í sett af línum.
Hér er það notað til að búa til röð fyrir hvern meðlim sem er í
sworn_members fylkinu í hverju norðrinu.
WHERE region = 'The North' = passar að þetta sé aðeins í norðrinu.

`northern_characters AS (
    SELECT nh.member_id, split_part(c.name, ' ', array_length(string_to_array(c.name, ' '), 1)) AS family_name
    FROM northern_houses nh
    JOIN got.characters c ON nh.member_id = c.id
),`

-Setur hvert aukenni manneskju við ættarnafn.

-split_part(c.name, ' ', array_length(string_to_array(c.name, ' '), 1))
Nokkrar PostreSQL kallanir sem Það telur bilin í nafninu, breytir nafninu í fylki
og velur síðan síðasta þátt fylkisins sem ættarnafn.

`family_counts AS (
    SELECT family_name, COUNT(*) AS member_count
    FROM northern_characters
    GROUP BY family_name
    HAVING COUNT(*) > 5
)`

-Tekur saman gögnin til að telja meðlimi í hverri fjölskyldu
 og síar út fjölskyldur með fleiri en fimm meðlimi.

`SELECT family_name, member_count
FROM family_counts
ORDER BY member_count DESC, family_name ASC;`

-Gefur út lista yfir fjölskyldur, raðað eftir fjölda meðlima
 (lækkandi) og í stafrófsröð eftir ættarnafni (hækkandi)

Niðurstaðan þegar þetta er keyrt skilar stærtstu ættum fjölskylda í norðri stærsta
fjölskyldan kemur fyrst fer svo í lækkandi röð.

Stark,36
Karstark,13
Manderly,8
Mormont,8
Glover,7
Ryswell,7
Flint,6
Hornwood,6
Tallhart,6
Umber,6

# Dæmi 2

Taflan `baratheon.v_pov_characters_human_readable` skilar nafni persónunnar en ef það er er fleira en eitt nafn þá er valið fyrsta nafnið.

Þessi skipun sér til þess: `COALESCE(NULLIF(c.titles[1], ''), c.name)`

Til að finna út hvort persónan eigi faðir er notað eftir farandi skipun: `COALESCE(father_c.name, 'Unknown') AS father,`

og móðir `COALESCE(mother_c.name, 'Unknown') AS mother,`

Ef það á enga foreldra kemur upp 'Unknown' í töfluna.

Til að komast að því hvort persónan eigi maka er notað eftirfarandi: `COALESCE(spouse_c.name, 'Unknown') AS spouse,`

Til að finna út hvenær persónan fæddist:

`CASE WHEN c.born IS NOT NULL AND c.born ~ '\d+.*AC' THEN CAST((regexp_match(c.born, '(\d+)[ ]*AC'))[1] AS INT) WHEN c.born IS NOT NULL AND c.born ~ '\d+.*BC' THEN -CAST((regexp_match(c.born, '(\d+)[ ]*BC'))[1] AS INT) ELSE NULL END AS born,`

og til að finna út hvenær persónan lést:

`CASE WHEN c.died IS NOT NULL AND c.died ~ '\d+.*AC' THEN CAST((regexp_match(c.died, '(\d+)[ ]*AC'))[1] AS INT) WHEN c.died IS NOT NULL AND c.died ~ '\d+.*BC' THEN -CAST((regexp_match(c.died, '(\d+)[ ]*BC'))[1] AS INT) ELSE NULL END AS died,`

Til að reikna út aldurinn:

`CASE WHEN c.died IS NOT NULL AND c.born IS NOT NULL THEN (CAST((regexp_match(c.died, '(\d+)'))[1] AS INT) - CAST((regexp_match(c.born, '(\d+)'))[1] AS INT)) WHEN c.died IS NULL AND c.born IS NOT NULL THEN (300 - CAST((regexp_match(c.born, '(\d+)'))[1] AS INT)) ELSE NULL END AS age,`

En ef dánarár er ekki til staðar þá er reiknað aldurinn út frá 300 AC.

Skilar tvíundarbreytu um hvort persónan sé á lífi eða ekki:

`CASE WHEN c.died IS NULL THEN TRUE ELSE FALSE END AS alive,`

Býr til lista yfir yfir bókarheiti sem persónan kemur fyrir í, í réttri röð eftir útgáfuárum:

`ARRAY_AGG(b.name ORDER BY b.released ASC) AS books`

Veljum hvaða flokka á að birta í töflunni ´baratheon.v_pov_characters_human_readable´:

`SELECT full_name, CASE WHEN gender = 'Male' THEN 'M' WHEN gender = 'Female' THEN 'F' ELSE NULL END AS gender, father, mother, spouse, born, died, age, alive, books FROM pov_characters ORDER BY alive DESC, age DESC;`

Þar sem breytt er ´Male´ í M og ´Female´ í F.

Til að geta birt myndina er svo keyrt eftirfarandi:

`SELECT * FROM baratheon.v_pov_characters_human_readable ORDER BY alive DESC, age DESC;`

# Dæmi 3

## 1. Flatarmáls konungsríkja

**PostgreSQL function baratheon.get_kingdom_size(int kingdom_id) sem reiknar út flatarmál konungsríkis út frá landfræðilegum gögnum. Gefið niðurstöðu í ferkílómetrum (þ.e. km²) með engum aukastöfum.**

- `CREATE OR REPLACE FUNCTION baratheon.get_kingdom_size(kingdom_id INT) RETURNS INTEGER AS $$` býr til function sem tekur inn INT breytu og skilar INT breytu
- `DECLARE kingdom_area_km2 INTEGER` býr til breytu kingdom_area_km2 til að geyma flatarmálið
- `IF NOT EXISTS (SELECT 1 FROM atlas.kingdoms WHERE gid = kingdom_id)` athugar hvort að gildið fyrir kingdom_id sé löglegt og kastar villu með skilaboðum ef ekki með `RAISE EXCEPTION 'Ólöglegt kingdom_id: %', kingdom_id;`
- `SELECT ROUND(ST_Area(geog::geography) / 1000000.0)` Reiknar flatarmál konungsríkisins í ferkílómetrum með `ST_Area` á `geog` dálkinum og breytir í fermetra
- `INTO kingdom_area_km2` setur niðurstöðuna í breytuna
- `RETURN kingdom_area_km2` Skilar flatarmálinu sem heiltölu.
 
**Hvað gerist ef þú setur inn ólöglegt gildi fyrir `kingdom_id?`, Er hægt að koma í veg fyrir það?**
Ef að sett er inn ólöglegt gildi á `kingdom_id` er `RAISE EXCEPTION` skipunin í fallinu er notuð til að senda skilaboðin "Ólöglegt kingdom_id: [gildið]"

**SQL fyrirspurn sem notar fallið til að finna heildar flatarmál þriðja stærsta konungsríkisins.**
- `SELECT gid, name, baratheon.get_kingdom_size(gid) AS kingdom_area_km2` Velur dálkana gid, name, og útreiknað flatarmál frá fallinu okkar
- `FROM atlas.kingdoms` tekur gögn frá atlas.kingdoms töflunni
- `ORDER BY kingdom_area_km2 DESC` raðar niðurstöðunum eftir kingdom_area_km2 í lækkandi röð
- `OFFSET 2 LIMIT 1` Sleppir fyrstu tveimur niðurstöðum og skilar því þriðja stærsta

## 2. Fjöldi staðsetninga og staðsetningar af ákveðnum tegundum

**SQL fyrirspurn sem finnur sjaldgæfustu staðsetningategund utan The Seven Kingdoms**
- `WITH tegundir AS` býr til tímabundna töflu
- `SELECT type, COUNT(*) AS count` notar dálkin type úr töflunni atlas.locations (`FROM atlas.locations`) til að telja fjölda staða fyrir hverja tegund
- `WHERE geog IS NOT NULL` tekur út staði sem að hafa ekki geog og `AND geog NOT IN (SELECT geog FROM atlas.kingdoms)` útilokar staði sem að eru í the seven kingdoms með því að bera saman við `geog` í töflunni `atlas.kingdoms`
- `SELECT MIN(count) AS minnst FROM tegundir` Velur lægsta talningu úr `tegundir` töflunni
- `SELECT r.type, l.name FROM atlas.locations l` Velur dálkinn `type` úr tegundir og heiti staðanna `name` úr atlas.locations
- `JOIN tegundir r ON l.type = r.type` tengir locations við tegundir
- `WHERE r.count = (SELECT minnst FROM minnst);` notar töfluna minnst sem að var búin til til að velja þá tegund sem er sjaldgæfust

