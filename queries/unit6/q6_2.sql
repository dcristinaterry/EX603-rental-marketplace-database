
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Task 6.2.1: Compare each row to its neighbors
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
-- Part A: Row to row
-- Is a producer’s metric going up or down over time, not just high or low overall? 
-- For each event, show the metric from the previous event and the next event, in time order.
-- ✓  LAG() and LEAD(), partitioned by producer and ordered by timestamp.
-- ✓  A delta column: the current metric minus the previous metric.
-- ✓	In the final output, filter to one producer of your choice so the trend is easy to read.

---------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT
    property_id,
    renter_id,
    scheduled_at,
    duration_min,

    LAG(duration_min) OVER (
        PARTITION BY property_id
        ORDER BY scheduled_at
    ) AS LAG_duration,

    LEAD(duration_min) OVER (
        PARTITION BY property_id
        ORDER BY scheduled_at
    ) AS LEAD_duration,

    duration_min - LAG(duration_min) OVER (
        PARTITION BY property_id
        ORDER BY scheduled_at
    ) AS delta

FROM viewings
WHERE property_id = 1
ORDER BY scheduled_at ASC;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Task 6.2.2: Cumulative and smoothed
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- How is the platform doing over time, both in total and on a recent average? 
-- Leadership wants to see where things stand now and how they got there.
-- ✓  SUM(...) OVER (ORDER BY ... ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) for a running total.
-- ✓  AVG(...) OVER (... ROWS BETWEEN n PRECEDING AND CURRENT ROW) for a moving average. Note: ROWS counts rows, not days. 
-- If some days have no events, a 7-row window covers more than 7 days.
-- ✓  Choose a target (for example, a total for the quarter), state it, and show how close the running total gets to it.
-- ✓  One or two sentences on how ROWS differs from RANGE when two rows have the same ORDER BY value.
---------------------------------------------------------------------------------------------------------------------------------------------------------------------

Select  property_id,
    viewing_id,
    scheduled_at,
    duration_min,
	SUM(duration_min) OVER (ORDER BY duration_min ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as running_total,
	ROUND((AVG(duration_min) OVER (ORDER BY scheduled_at, viewing_id ROWS BETWEEN 7 PRECEDING AND CURRENT ROW)),2) as moving_average

FROM viewings
ORDER BY scheduled_at, viewing_id;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Task 6.2.3: Where the series stops
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- One producer stops for a while and then starts again. Find that gap. 
-- Then think about what you cannot tell yet: did the producer leave, or did your data lose them?
-- ✓  LAG() or LEAD() comparing adjacent rows.
-- ✓  A CTE or subquery that computes the gap, and a WHERE in the outer query that keeps only the gaps. 
-- (You cannot filter a window function result with WHERE or HAVING in the same query, 
-- because the window function runs after them.)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------

WITH viewing_dates AS (
    SELECT
        property_id,
        scheduled_at::date AS scheduled_date,
        COUNT(*) AS daily_views
    FROM viewings
    GROUP BY property_id, scheduled_at::date
)
SELECT
    property_id,
    scheduled_date,
    daily_views,
    LAG(scheduled_date) OVER (
        PARTITION BY property_id
        ORDER BY scheduled_date
    ) AS previous_date
FROM viewing_dates
WHERE scheduled_date - previous_date > 1;
	