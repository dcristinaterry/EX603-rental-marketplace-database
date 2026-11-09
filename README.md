# EX603 Rental Marketplace Database

Rental Data Base that models Renters, Properties, Amenities, Viewings, and the amenities associated with rental properties. 

## Domain

This project will provide a system where information about Renters and Properties can be managed.  It will allow users to search what Renters has viewied a specefic property, and what renters have seen a specific property, and how long the viewing lasted.  It will also allow to record and search all information related to each propertie's ammenities, like pool, air conditioning, parking space.

## Entity Relationship Diagram
![Rental Marketplace ERD](schema/erd.png)

## Schema

The database consists of seven tables that represent users, properties, amenities, property viewings, and the relationships between them.

- `users` stores information about people using the system. A user can participate as a renter, an owner, or both.
`property` stores the properties available in the system.
- `user_property` is a junction table that represents the ownership relationship between users and properties.
- `amenities` stores the different amenities that can be associated with properties.
- `viewing` represents scheduled property viewings. Each viewing is associated with one property.
- `user_viewing` is a junction table that represents which users participate in particular viewings.
- `listing_amenities` is a junction table that associates properties with their amenities.

### Design Decisions

The original design represented renters and owners separately. As the design became more detailed, these were consolidated into a single `users` table to avoid duplicating information for a person who can participate in both roles.

The `user_property` junction table supports a many-to-many relationship between users and properties. A user can own multiple properties, while a property can have multiple owners.

The `user_viewing` junction table records multiple users attending a viewing and allows a user to be in multiple viewings. The `viewing` table remains a separate entity because each viewing has its own time, duration, attendance information, and associated property.

The `listing_amenities` table represents the many-to-many relationship between properties and amenities, allowing a property to have multiple amenities and the same type of amenity to be associated with multiple properties.

##Query Catalog

--1
SELECT
    COUNT(*) AS total_viewings,
    SUM(duration_min) AS total_duration,
    ROUND(AVG(duration_min),2) AS avg_duration,
    MIN(duration_min) AS min_duration,
    MAX(duration_min) AS max_duration,
    COUNT(DISTINCT renter_id) AS number_of_renters
FROM viewings;

--2
SELECT
    property_id,
    COUNT(*) AS viewing_count,
    ROUND(AVG(duration_min),2) AS duration_avg
FROM viewings
GROUP BY property_id
ORDER BY viewing_count DESC;

--3

SELECT
    property_id,
    COUNT(*) AS viewing_count,
    ROUND(AVG(duration_min),2) AS duration_avg
FROM viewings
GROUP BY property_id
HAVING COUNT(*) >= 12
ORDER BY viewing_count DESC;


--4

SELECT
    property_id,
    booking_city,
    COUNT(*) AS viewing_count,
    ROUND(AVG(duration_min),2) AS avg_duration
FROM viewings
GROUP BY property_id, booking_city
ORDER BY property_id DESC, viewing_count DESC;





-- PART A
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

-- Part C: A two-step pipeline baseline


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








