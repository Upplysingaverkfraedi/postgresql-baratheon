## Hluti 3: PostGIS og föll í PostgreSQL

### 1. Flatarmáls konungsríkja

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

### 2. Fjöldi staðsetninga og staðsetningar af ákveðnum tegundum

**SQL fyrirspurn sem finnur sjaldgæfustu staðsetningategund utan The Seven Kingdoms**
- `WITH tegundir AS` býr til tímabundna töflu
- `SELECT type, COUNT(*) AS count` notar dálkin type úr töflunni atlas.locations (`FROM atlas.locations`) til að telja fjölda staða fyrir hverja tegund
- `WHERE geog IS NOT NULL` tekur út staði sem að hafa ekki geog og `AND geog NOT IN (SELECT geog FROM atlas.kingdoms)` útilokar staði sem að eru í the seven kingdoms með því að bera saman við `geog` í töflunni `atlas.kingdoms`
- `SELECT MIN(count) AS minnst FROM tegundir` Velur lægsta talningu úr `tegundir` töflunni
- `SELECT r.type, l.name FROM atlas.locations l` Velur dálkinn `type` úr tegundir og heiti staðanna `name` úr atlas.locations
- `JOIN tegundir r ON l.type = r.type` tengir locations við tegundir
- `WHERE r.count = (SELECT minnst FROM minnst);` notar töfluna minnst sem að var búin til til að velja þá tegund sem er sjaldgæfust