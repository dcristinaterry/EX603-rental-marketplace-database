
-- Task 3.2: Find the bug
-- The dashboard query contains two SQL problems. 
-- Your goal is to reproduce each problem, show what goes wrong, and then fix it.

-- Part A: The rows that vanished
-- SQL uses three-valued logic: TRUE, FALSE, and UNKNOWN. A comparison against NULL yields UNKNOWN, and a WHERE clause keeps only rows where the predicate is TRUE.
-- A filter that looks exhaustive can therefore discard rows silently, without an error and without warning anyone.
-- Reproduce it:

-- Pick a nullable column on your event or producer table. If the dataset has no NULLs in it, insert a few deliberately and say that you did.
-- Write a query with a negation or inequality predicate on that column — for example WHERE status != 'completed' — and record the row count it returns.
-- Write a second query counting the rows the first one silently omitted, and show that the two counts do not sum to the table total.
-- Repair the first query using an explicit IS NULL condition or COALESCE, so it returns what you intended.

SELECT *
FROM viewings v
WHERE v.no_show_reason != 'Renter cancelled' 
	AND v.no_show_reason != 'Renter no show' 
	OR v.no_show_reason = null


SELECT count(*) -- returns 14 rows
FROM viewings v
WHERE v.no_show_reason != 'Renter cancelled' 
	AND v.no_show_reason != 'Renter no show' 
	OR v.no_show_reason = null


	
-- Repaired Query   -- Returns: 180
SELECT v.property_id,
	v.scheduled_at,
	v.attended_at,
	v.duration_min,
	COALESCE(v.no_show_reason,'no reason provided')  --returns 14 rows
FROM viewings v
WHERE v.no_show_reason 
	NOT IN ('Renter cancelled','Renter no show')
	OR v.no_show_reason IS NULL



-- Part B: The alias that did not exist yet
-- SQL is written FROM, WHERE, SELECT, ORDER BY, but it is not evaluated in that order.
-- Write a query defining an alias in SELECT and referencing that alias in WHERE. Capture the error message verbatim.
-- Produce two correct rewrites: one repeating the expression in WHERE, one wrapping the query in a CTE or subquery so the alias becomes a real column.

SELECT p.monthly_rent * 12 AS annual_rent
FROM properties p
WHERE annual_rent < 24000;

        -- ERROR:  ERROR:  column "annual_rent" does not exist
        -- LINE 3: WHERE annual_rent * 12 < 24000;
        -- SQL state: 42703
        -- Character: 63

SELECT p.property_id, p.monthly_rent * 12 AS annual_rent
FROM properties p
WHERE p.monthly_rent * 12 < 24000;


-- CTE:
WITH annual_rental_costs AS (
    SELECT
        p.property_id,
        p.monthly_rent * 12 AS annual_rent
    FROM properties p
)
SELECT *
FROM annual_rental_costs
WHERE annual_rent < 24000;

