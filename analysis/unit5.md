Analysis 

5.1
What feature or report on your platform could use the three-table join from Question 1? What information would it display?

One of the queries provided would show managers which renters scheduled viewings and what properties they have schedulled viewings. 

select ren.renter_id, ren.renter_name, prop.property_label, vi.scheduled_at
from renters ren
	inner join viewings vi on vi.renter_id = ren.renter_id
	inner join properties prop on vi.property_id = prop.property_id


Why is the junction table important for answering Question 2? What would make this analysis more difficult without it?

Without having a junction table managing many to many relationships would not work in the database unless we don't have an attribute as primary key.  This allow us to have many to many relationships and not have a table with duplicated tuples.  For the rental market place, this was necessary to determine the amenities that each property has. one amenity like a pool can be an amenitiy for 1 or more properties, and one property can have more than 1 amenity.


5.2

Write up
In /analysis/unit5.md, answer the following questions:

1. Which producers were excluded by the inner join? Report their identifiers.
   Records that exists in Properties but not in the Viewing table.  2 properties had no assigned viewings. 

2. What does it mean when a producer has no events? What are some possible explanations?
    It means the property had no viewings.  This could be for a multitud of reasons such as:  
        The property has just been added.
        The property is not available.
        The property is not appealing to renters, maybe rent is too high, or in not an appealing location.

3. How could a report based only on an inner join give leadership an incomplete picture of the platform?
    An inner join will return records only for properties that have asssinged viewings. This could lead leadership to believe all listed properties have viewing activity, when some have never received a viewing.  It would not show the complete picture of the state of all the properties. 
4.  Why might leadership want to identify producers who have never been active?
    It might be important to understand why they are not active and how what to do to have them active.  If a property the rent is too high, they can analyze to lower the rent, or if certian locations are not producing viewings then perhaps not work on with properties for that location, or detect potential issues with the viewing process. 
5. What action could leadership take based on these findings?
    They could determine how to plan their strategy, how to target theri marketing efforts for example by comparing rental price of properties with high viewing and properties with no viewings.  Location of properties with high viewings.  Perhaps types of amenities for properties with high viewings.
