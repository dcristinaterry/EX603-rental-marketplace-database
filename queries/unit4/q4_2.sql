-- Task 4.2: Build the breakdown leadership asked for
-- Leadership needs additional information that cannot be obtained from the basic grouping queries in Task 4.1.
-- Complete the following three parts to produce more detailed analytical summaries.



-- Part A: Two numbers in one pass
-- For each producer, compute the total number of events and the total number of events classified as failures, 
--in a single pass over the event table, without a WHERE clause filtering the whole query. The outliers here are the producers you will name in your finding.
-- ✓  CASE used inside an aggregate — for example SUM(CASE WHEN ... THEN 1 ELSE 0 END) or COUNT(CASE WHEN ... END).
-- ✓  Both totals appearing as separate columns in one result set.



SELECT
    property_id,
    COUNT(*) AS total_viewings,
    COUNT(
        CASE
            WHEN viewing_status = 'cancelled' THEN 1
        END
    ) AS cancelled_count
FROM viewings
GROUP BY property_id;


WITH viewing_stats AS (
    SELECT
        property_id,
        COUNT(*) AS total_viewings,
        COUNT(
            CASE
                WHEN viewing_status = 'cancelled' THEN 1
            END
        ) AS cancelled_count
    FROM viewings
    GROUP BY property_id
)
SELECT
    property_id,
    total_viewings,
    cancelled_count,
    ROUND(
        cancelled_count * 100.0 / total_viewings,
        2
    ) AS cancellation_rate
FROM viewing_stats;



-- Part B: Subtotals and a grand total
-- The regional director wants subtotals per region and a platform grand total, not the detail rows. 
--Write a query that produces regional subtotals and a platform-wide grand total without including the individual detail rows.
-- ✓  GROUP BY ROLLUP (...), or GROUPING SETS or CUBE.
-- ✓  A written note identifying which rows are the subtotals and which is the grand total.


SELECT
    property_id,
    booking_city,
    COUNT(*) AS total_viewings
FROM viewings
GROUP BY ROLLUP(property_id, booking_city);


SELECT
    property_id,
    booking_city,
    COUNT(*) AS total_viewings
FROM viewings
GROUP BY CUBE(property_id, booking_city);


SELECT
    booking_city,
    COUNT(*) AS total_viewings
FROM viewings
GROUP BY GROUPING SETS (
    (booking_city),
    () --total
)
ORDER BY booking_city;

-- Part C: A two-step pipeline
-- Leadership wants to establish a baseline for evaluating high-volume producers. That needs two steps: use a WITH clause to create an intermediate result that summarizes performance for each producer, then use a second aggregation or filter on that intermediate result to calculate a baseline for high-volume producers.
-- ✓  A WITH clause producing an intermediate aggregate.
-- ✓  A second aggregation or filter applied to that intermediate result.


WITH performance_properties AS(
    SELECT
        property_id,
        COUNT(*) AS total_property_viewings,
        COUNT(CASE WHEN viewing_status = 'cancelled' THEN 1 END) AS cancelled_count
    FROM viewings
    GROUP BY property_id
)
SELECT
    ROUND(AVG(cancelled_count),2) AS base_line_cancelled_viewings
FROM performance_properties
WHERE total_property_viewings > 12;


