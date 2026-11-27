--===============================================================================================================================================
--== Report B
--===============================================================================================================================================

-- Index Report A
-- The bottleneck in Report A was the sequential scan on the plays table, which was filtered by user_id and played_at.
-- ->  Parallel Seq Scan on plays p  (cost=0.00..43849.65 rows=4411 width=4) (actual time=0.412..875.512 rows=3378 loops=3)"
-- "                                            Filter: ((played_at >= '2025-01-01 00:00:00'::timestamp without time zone) AND (played_at < '2026-01-01 00:00:00'::timestamp without time zone) AND (user_id = 1))"
-- "                                            Rows Removed by Filter: 996697"
-- "                                            Buffers: shared hit=96 read=21877"
-- This bottle neck added most of the query execution time, so creating an index on user_id and played_at helps to speed up the filtering process.


--Solution:
CREATE INDEX idx_plays_user_played_at
ON plays (user_id, played_at)

--===============================================================================================================================================
--== Report B
--===============================================================================================================================================
-- Problem bottleneck:
-- "                                      ->  Parallel Seq Scan on plays p  (cost=0.00..46974.88 rows=6250 width=8) (actual time=0.328..561.133 rows=41017 loops=3)"
-- "                                            Filter: ((date(played_at) >= '2025-12-01'::date) AND (date(played_at) <= '2025-12-31'::date))"
-- "                                            Rows Removed by Filter: 959059"
-- "                                            Buffers: shared hit=352 read=21621"

-- "Where" fix Report B:  played_at >= '2025-12-01 00:00:00' AND played_at < '2026-01-01 00:00:00'
SELECT a.account_id, a.name,
       ROUND(SUM(p.play_duration_seconds) / 60.0, 1) AS minutes
FROM   accounts a
JOIN   plays p ON p.user_id = a.account_id
WHERE  played_at >= '2025-12-01 00:00:00' AND played_at < '2026-01-01 00:00:00'
GROUP  BY a.account_id, a.name
ORDER  BY minutes DESC NULLS LAST, a.account_id ASC
LIMIT  20;

--consideration:
-- since the query filters on played_at using a range, removing the date() function helps to utilize the index efficiently.
--so played_at >= '2025-12-01 00:00:00' AND played_at < '2026-01-01 00:00:00' will make use of the index efficiently.



--===============================================================================================================================================
--== Report C
--===============================================================================================================================================

-- Index Report C
CREATE INDEX idx_plays_user_played_at
ON plays (user_id, played_at)
INCLUDE (track_id);

-- ->  Index Scan Backward using idx_plays_played_at on plays p  (cost=0.43..173310.63 rows=21302 width=12) (actual time=4.799..138.035 rows=50 loops=1)"
-- "              Filter: (user_id = 1)"
-- "              Rows Removed by Filter: 7528"
-- "              Buffers: shared hit=5653 read=1968"

--solution:
-- The index idx_plays_user_played_at on (user_id, played_at) including track_id helps to speed up queries 
-- filtering by user_id and played_at while also retrieving the track_id efficiently without additional lookups.    
