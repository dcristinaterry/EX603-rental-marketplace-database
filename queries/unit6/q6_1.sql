---------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Task 6.1.1: Compute across a window without collapsing
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Compare each event to its producer’s average. 
-- Is an event unusual for its own producer? Return every event with its producer’s average metric on the same row.
-- Are there producers who have never had an event?

-- Producer	Property (property_id)
-- Actor	Renter (renter_id)
-- Event	Viewing
-- Metric	Viewing duration (duration_min)
-- Region	Booking city (booking_city)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
WITH total_avg AS(
	SELECT property_id, 
			round(avg(duration_min),2) as avg_duration
			-- cout(*) over() as total_count 
	FROM viewings
	where viewing_status = 'attended'
	group by property_id
)
SELECT v.viewing_id, 
	v.property_id, 	
	v.duration_min,
	av.avg_duration,
	v.duration_min - av.avg_duration AS difference_from_avg
FROM viewings v
LEFT JOIN total_avg av
	ON av.property_id = v.property_id
WHERE viewing_status = 'attended'
order by av.avg_duration desc

--window

SELECT 	vi.property_id,
		vi.viewing_id,
		vi.duration_min,
			round(avg(vi.duration_min) over (partition by vi.property_id ),2)as avg_duration

	FROM viewings vi
	WHERE viewing_status = 'attended'
	order by avg_duration desc


---------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Task 6.1.2: Rank producers three ways.
---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Rank producers three ways. Leadership wants to publish a producer leaderboard. 
-- When two producers tie, the ranking method decides who appears higher. 
-- Rank producers by number of events using ROW_NUMBER(), RANK(), and DENSE_RANK(), side by side in one query. 
-- Make sure your output shows at least one tie.

WITH property_counts AS (
    SELECT
        property_id,
        COUNT(viewing_id) AS viewing_count
    FROM viewings
    GROUP BY property_id
)
select 	property_id, 
		viewing_count,
		ROW_NUMBER() OVER(
			order by viewing_count) AS r_count,
		RANK() OVER(
			order by viewing_count) AS rank_count,
		DENSE_RANK() OVER(
			order by viewing_count) AS dense_rank_count
from property_counts


---------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Task 6.1.3: Sort producers into four bands
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
			
--Sort producers into four bands. Use NTILE(4) to split producers into four groups by number of events. 
--Look at what happens when tied producers land on both sides of a group boundary.

---------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
WITH property_counts AS (
    SELECT
        property_id,
        COUNT(viewing_id) AS viewing_count
    FROM viewings
    GROUP BY property_id
)
SELECT
    property_id,
    viewing_count,
    NTILE(4) OVER (
        ORDER BY viewing_count DESC, property_id
    ) AS performance_prop
	
FROM property_counts
ORDER BY performance_prop, viewing_count DESC;

