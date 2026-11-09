-- Are there producers who have never had an event?
-- Producer	= Property (property_id)
-- Actor	= Renter (renter_id)
-- Event	= Viewing
-- Metric	= Viewing duration (duration_min)
-- Region	= Booking city (booking_city)

select * from renters
select * from viewings
select * from properties
select * from property_features
select * from amenities
select * from listing_amenities

-----------------------------------------------------------------------------------------------------------------
-- 5.2.1
-- Find Records That Joins May Exclude
-- Part A: Compare INNER JOIN and LEFT JOIN
-----------------------------------------------------------------------------------------------------------------
-- Write two queries to compare the results of an inner join and a left join.

-- Use LEFT JOIN to return all producers, including those who have never had an event.
-- Write an equivalent query using INNER JOIN.
-- Compare the results and determine how many producers are excluded by the inner join.
-- Explain which producers are missing and why.
-- Your results must include a count of the producers excluded by the inner join.

-- hint: When counting producers, use their unique identifiers so that producers with multiple events are not counted more than once.

-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-- returns 200 records
SELECT prop.property_id, prop.property_label, vi.viewing_id
FROM properties prop
INNER JOIN viewings vi on vi.property_id = prop.property_id;

SELECT count(distinct prop.property_id) as total_view
FROM properties prop
INNER JOIN viewings vi on vi.property_id = prop.property_id


-- 202 records
SELECT prop.property_id, prop.property_label, vi.viewing_id
FROM properties prop
LEFT JOIN viewings vi on vi.property_id = prop.property_id


SELECT count(distinct prop.property_id) as total_records_left
FROM properties prop
LEFT JOIN viewings vi ON vi.property_id = prop.property_id
WHERE vi.viewing_id IS NULL
-- returns 2 records counting disctinct property id's that are not found in the viewings table,


-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-- 5.2.2
-- Part B
-- Explore RIGHT JOIN and FULL OUTER JOIN
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-- Next, examine the same relationship using two additional join types.
-- Write a RIGHT JOIN that returns the same records as your LEFT JOIN from Part A.
-- Compare the results to confirm that they match.


SELECT prop.property_id, prop.property_label, vi.viewing_id
FROM properties prop
RIGHT JOIN viewings vi on vi.property_id = prop.property_id

SELECT count(distinct prop.property_id) as total_records_left
FROM properties prop
RIGHT JOIN viewings vi on vi.property_id = prop.property_id

SELECT count(distinct prop.property_id) as total_records_left
FROM properties prop
RIGHT JOIN viewings vi on vi.property_id = prop.property_id


-- Write a FULL OUTER JOIN that includes matching and unmatched records from both tables.
-- Explain what a full outer join can reveal that a left join or right join alone may not show.
-- Be sure to verify your results rather than assuming the queries are equivalent.

SELECT prop.property_id, prop.property_label, vi.viewing_id
FROM properties prop
FULL OUTER JOIN viewings vi on vi.property_id = prop.property_id


-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-- 5.2.2
-- Part C: Find Producers with No Events Using Two Approaches
-- Write two queries that identify producers who have never had an event and compare them.
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-- ✓  NOT EXISTS.

SELECT prop.property_id, prop.property_label
FROM properties prop
WHERE NOT EXISTS (
    SELECT 1
    FROM viewings vi
    WHERE vi.property_id = prop.property_id
);


-- ✓  EXCEPT.

-- Run both queries and compare their results.

-- In one or two sentences, explain how the approaches differ and confirm whether they identify the same producers.

SELECT property_id, property_label
FROM properties
WHERE property_id IN (
    SELECT property_id
    FROM properties

    EXCEPT

    SELECT property_id
    FROM viewings
);
