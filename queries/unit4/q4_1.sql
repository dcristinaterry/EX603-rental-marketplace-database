-- The questions
-- 1. Calculate the following statistics across the entire event table using your theme's metric: 
-- the count, total, average, minimum, and maximum of your theme’s metric across the whole event table, 
-- and how many distinct actors appear. Review your results carefully. 
-- For example, if your metric should never be zero but your minimum value is zero, this may indicate another data-quality issue that needs investigation.

SELECT
    COUNT(*) AS total_viewings,
    SUM(duration_min) AS total_duration,
    ROUND(AVG(duration_min),2) AS avg_duration,
    MIN(duration_min) AS min_duration,
    MAX(duration_min) AS max_duration,
    COUNT(DISTINCT renter_id) AS number_of_renters
FROM viewings;

--conclusion:
-- I noticed that some properties had significantly more viewings than others. However, a higher number of viewings does not necessarily indicate better performance. 
-- A property might receive many viewings because it is attractive to potential renters, but it could also mean that many people are viewing it without deciding to rent it.
-- On the other hand, a property with fewer viewings might have been rented quickly, which could indicate better performance despite its lower viewing count.

Without additional information, such as whether a property was successfully rented or how long it remained available, we cannot determine whether a higher viewing count represents better performance.


----------------------

-- 2. Write a query that calculates the event count and average metric for each producer. 
-- Sort the results from the producer with the most events to the producer with the fewest. 
-- Consider what these results tell you about differences in activity and performance across producers.

SELECT
    property_id,
    COUNT(*) AS viewing_count,
    ROUND(AVG(duration_min),2) AS duration_avg
FROM viewings
GROUP BY property_id
ORDER BY viewing_count DESC;

-- 3. Which producers have enough volume for their rate to mean anything? 
-- A producer with only a few events may have a high failure rate that is not representative of their usual performance. 
-- Choose a minimum event-count threshold and use HAVING to include only producers who meet that threshold. Explain why you selected your threshold.

SELECT
    property_id,
    COUNT(*) AS viewing_count,
    ROUND(AVG(duration_min),2) AS duration_avg
FROM viewings
GROUP BY property_id
HAVING COUNT(*) >= 12
ORDER BY viewing_count DESC;

-- 4. How does the picture change along two dimensions at once? Leadership also wants to understand how performance varies across regions. 
-- Write a query that groups the data by two dimensions, including region, and calculates the relevant summary statistics. 
-- Your results should contain one row for each combination of the two dimensions so that regional leaders can review their results.
SELECT
    property_id,
    booking_city,
    COUNT(*) AS viewing_count,
    ROUND(AVG(duration_min),2) AS avg_duration
FROM viewings
GROUP BY property_id, booking_city
ORDER BY property_id DESC, viewing_count DESC;

