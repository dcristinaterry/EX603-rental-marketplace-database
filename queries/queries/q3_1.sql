
-- Queries to evaluate the Data
SELECT * FROM public.listing_amenities
ORDER BY property_id ASC, amenity_id ASC 

SELECT * FROM amenities

SELECT * FROM property_features

SELECT * FROM renters

SELECT * FROM viewings


-- 3.1-a:   Find the 10 most expensive available properties with monthly rent of $2,000 or less.
--          Requirement: SELECT, WHERE, ORDER BY, LIMIT.

SELECT *
FROM properties
WHERE properties.is_available= true 
AND properties.monthly_rent <= 2000
ORDER BY properties.monthly_rent DESC
LIMIT 10


-- 3.1-b:   Find all possible event statuses. Display the distinct values in the event status column. 
-- Look carefully at the results. Are there more statuses than you expected?

SELECT DISTINCT viewings.viewing_status 
FROM viewings

-- status:  attended, cancelled, disputed

select count(*). --Total 200
from viewings

SELECT count(*). --Total 156
From viewings
where viewings.viewing_status = 'attended'

SELECT count(*)
From viewings
where viewings.viewing_status = 'cancelled' or viewings.viewing_status = 'disputed'

-- Conclusion:  there are more statuses than I expected.  I expected show, no-show.  I would ask: Is cancelled and disputed considered a no show?
-- 156 attended the viewings out of 200. no_show_reason shows nulls. 


-- 3.1-c:
-- Filter the events in two different ways. 

--3.1-c, way 1
SELECT *
FROM viewings
WHERE viewings.duration_min = 0 



--3.1-c, way 2

SELECT *
FROM viewings
WHERE viewings.viewing_status = 'cancelled' 


--3.1-c: Write: one query that filters a numeric range. 

SELECT *
FROM viewings
WHERE viewings.duration_min >= 30 and viewings.duration_min <=60

-- 3.1-c: Write one query that filters using an explicit list of values with IN.
SELECT *
From viewings
where viewings.viewing_status IN ('cancelled','disputed')

-- 3.1c
-- Work with text and missing values. Write queries that find producers whose names match a text pattern using LIKE, 
SELECT * 
FROM properties
WHERE city LIKE '%nan%'

-- 3.1-c:  Identify records where a reason/value is missing (NULL). Use COALESCE to replace a missing value with a useful label such as: No reason provided.
select *,
	COALESCE(viewings.no_show_reason, 'no reason provided') AS REASON
	FROM viewings


-- 3.1-D:
-- Make the results easier to understand. Create a query with calculated/computed columns that would make sense to someone who does not work with SQL. Depending on your theme, you might calculate or label:
-- a payout amount, a time of day, a value/rating category, or another useful business measure.
-- Use CASE where appropriate to create plain-language categories.

-- For this case I'm using:  Show viewings attended by price/rent category

SELECT 
	v.renter_id, 
	v.viewing_id,
	p.property_id,
	CASE
 		WHEN p.monthly_rent < 2000 THEN 'Low Rent'
		WHEN p.monthly_rent < 3000 THEN 'Medium Rent'
	ELSE 'High Rent'
	END AS category
FROM properties p
JOIN viewings v 
	ON p.property_id = v.property_id
where v.viewing_status = 'attended' 
order by category asc
