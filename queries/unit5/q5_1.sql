-- Are there producers who have never had an event?
-- Producer	Property (property_id)
-- Actor	Renter (renter_id)
-- Event	Viewing
-- Metric	Viewing duration (duration_min)
-- Region	Booking city (booking_city)

-- select * from renters
-- select * from viewings
-- select * from properties
-- select * from property_features
-- select * from amenities
-- select * from listing_amenities

-----------------------------------------------------------------------------------------------------------
----------  5.1.1------------------------------------------------------------------------------------------
-- Task: 5.1.1 that joins three tables to display the actor who performed each event, 
-- The producer associated with the event, and the event's date and time.
-- Analisis:
-- tables: 	- (actor)renter -renterID // renter_id, renter_name
-- 			- (producer)property - property_id // property_label, listing_code, city, monthly_rent, is_available
-- 			- (event)viewing - renterid, viewing_id // renter_id, property_id, viewing_status_no_show_reason

select ren.renter_id, ren.renter_name, prop.property_label, vi.scheduled_at
from renters ren
	inner join viewings vi on vi.renter_id = ren.renter_id
	inner join properties prop on vi.property_id = prop.property_id

-----------------------------------------------------------------------------------------------------------
----------  5.1.2------------------------------------------------------------------------------------------
--Do the producers identified in Assignment 4 share certain catalog credentials or tags? 
--Write a query that connects the producer table to the catalog table through the junction table. 
--Return the producers associated with your theme's catalog tag.

select prop.property_id, prop.property_label, amen.amenity_name
from properties prop
inner join listing_amenities lia on lia.property_id= prop.property_id
inner join amenities amen on amen.amenity_id = lia.amenity_id
where amenity_name = 'Pool'

-----------------------------------------------------------------------------------------------------------
----------  5.1.3------------------------------------------------------------------------------------------
-- How do the producers compare with one another? 
-- Write a self join to compare records within the producer table.  (properties)
-- Use the results to explore whether the producers identified in Assignment 4 share characteristics with other producers 
-- or whether differences in activity levels may explain their performance.
-----------------------------------------------------------------------------------------------------------

SELECT
    p1.property_label AS property_1,
    p2.property_label AS property_2,
    p1.city,
    p1.monthly_rent AS rent_1,
    p2.monthly_rent AS rent_2
FROM properties p1
INNER JOIN properties p2
    ON p1.city = p2.city
WHERE p1.property_id < p2.property_id
	AND (p1.is_available = True AND p2.is_available= True);
			