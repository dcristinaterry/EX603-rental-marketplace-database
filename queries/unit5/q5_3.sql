
-- Task 5.3: Understand Join Performance and Execution Plans
-- In this task, you will explore how joins affect query performance and how PostgreSQL decides to execute a query.
SELECT COUNT(*)  --count renters
FROM (
    SELECT renter_id
    FROM renters
    LIMIT 3
) r;

SELECT COUNT(*) -- count amenities
FROM (
    SELECT amenity_id
    FROM amenities
    LIMIT 3
) a;
-- Part A: Explore CROSS JOIN
-- Write a CROSS JOIN between two small tables.

SELECT
    r.renter_id,
    a.amenity_id
FROM (
    SELECT renter_id
    FROM renters
    ORDER BY renter_id
    LIMIT 3
) r
CROSS JOIN (
    SELECT amenity_id
    FROM amenities
    ORDER BY amenity_id
    LIMIT 3
) a;
-- Then:

-- Count the rows in each source table. :  3 row per table


-- Run the CROSS JOIN and count the resulting rows.
    -- Count the rows in the result of the CROSS JOIN. :  9 rows
-- Show how the result matches the multiplication of the two source table counts. (see screenshot)
-- Explain when a Cartesian product might be useful and when it could indicate a query error.:
    -- Cartesian product could be useful for generating every possible combination of a small set of renters and amenities.  
    -- Maybe if we want to evaluate all the amenties per Property.



------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------
-- Part B: Examine a Query Execution Plan
-- Return to your three-table join from Task 5.1, Part A. Use PostgreSQL's EXPLAIN command to examine how the database plans to execute the query.



-- EXPLAIN
-- SELECT ...    -- your three-table join from 5.1
-- ;
-- -- EXPLAIN ANALYZE also runs the query and reports actual timings.
-- -- Safe here; be careful with it on statements that modify data.


-- Review the execution plan and complete the following:

-- Capture the full execution plan.
-- Identify the join algorithm or algorithms used, such as Nested Loop, Hash Join, or Merge Join.
-- Explain why PostgreSQL may have selected these algorithms, considering table sizes and available indexes.
-- Predict which part of the query might become less efficient as the dataset grows.
-- You may also use EXPLAIN ANALYZE to measure actual execution behavior. Unlike EXPLAIN, it runs the query. It is appropriate for your read-only SELECT query, but use caution with statements that modify data.

------------------------------------------------------------------------------------------------------------------------
EXPLAIN
SELECT
    ren.renter_id,
    ren.renter_name,
    prop.property_label,
    vi.scheduled_at
FROM renters ren
INNER JOIN viewings vi
    ON vi.renter_id = ren.renter_id
INNER JOIN properties prop
    ON vi.property_id = prop.property_id;


"Nested Loop  (cost=12.40..28.34 rows=200 width=528)"
"  ->  Hash Join  (cost=12.25..17.80 rows=200 width=274)"
"        Hash Cond: (vi.renter_id = ren.renter_id)"
"        ->  Seq Scan on viewings vi  (cost=0.00..5.00 rows=200 width=16)"
"        ->  Hash  (cost=11.00..11.00 rows=100 width=262)"
"              ->  Seq Scan on renters ren  (cost=0.00..11.00 rows=100 width=262)"
"  ->  Memoize  (cost=0.15..0.41 rows=1 width=262)"
"        Cache Key: vi.property_id"
"        Cache Mode: logical"
"        ->  Index Scan using properties_pkey on properties prop  (cost=0.14..0.40 rows=1 width=262)"
"              Index Cond: (property_id = vi.property_id)"


-- Algorithms:  
    -- Hash Join and Nested loop. These might have been selected because the viewings table is relatively small, and the hash join is efficient for joining smaller datasets. The nested loop is used to iterate over the results of the hash join and match them with the properties table using an index scan.

--  Predict which part of the query might become less efficient as the dataset grows.
    -- Scanning all the viewings for each property could become less efficient as the dataset grows, especially if the number of viewings increases significantly. The nested loop may lead to performance issues if the number of rows in the viewings table becomes large, as it would require more iterations to find matches.