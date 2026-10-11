
-- Task 3.3: Hand the team a corrected query
-- You want to give the dashboard team a query they can trust. The same question can be asked in several ways. Answer a two-step question about your data — for example, which actors were involved in the disputed events and express it three ways.



-- Demonstrate that all three return identical result sets. Matching row counts is not enough: show that the rows themselves match.
-- Name one input condition under which the three would not be equivalent. NULLs, duplicates, and empty result sets are the usual places equivalence breaks.


--- QUESTION:  Which viewings have a status other than attended or cancelled and are associated with inactive renters?
-- This can help answer why would there be inactive renters for disputed viewings.


-- First as a subquery using IN or NOT IN.
SELECT
    v.viewing_id,
    r.renter_id,
    r.renter_name,
    r.is_active,
    v.viewing_status
FROM viewings v
JOIN renters r ON r.renter_id = v.renter_id
WHERE v.viewing_status = 'disputed'
  AND r.renter_id IN (
      SELECT renter_id
      FROM renters
      WHERE is_active != true
  )
ORDER BY r.renter_name;


-- Then as a Common Table Expression using WITH.
--3.3b: CTE
WITH renter_info AS (
	SELECT *
	FROM renters r
	Where r.is_active != true
),
viewing_disputed AS(
	SELECT *
	FROM viewings v
	WHERE v.viewing_status = 'disputed'
)
SELECT v.viewing_id , 
	r.renter_id,
	r.renter_name, 
	r.is_active, 
	v.viewing_status
FROM renter_info r
JOIN viewing_disputed v 
	ON r.renter_id = v.renter_id
ORDER BY r.renter_name


-- Then a third way, distinct from both — a different subquery form, a CASE-based construction, or a set-based approach.
-- 3.3c: EXISTS
SELECT
    v.viewing_id,
    r.renter_id,
    r.renter_name,
    r.is_active,
    v.viewing_status
FROM viewings v
JOIN renters r ON r.renter_id = v.renter_id
WHERE v.viewing_status = 'disputed'
  AND EXISTS (
      SELECT 1
      FROM renters r2
      WHERE r2.renter_id = v.renter_id
        AND r2.is_active != true
  )
ORDER BY r.renter_name;

-- Additional query:  What viewing could have been re-schedule for a canceled dispued viewing for the same client: