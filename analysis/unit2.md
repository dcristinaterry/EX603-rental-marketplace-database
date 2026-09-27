## Constraints table

The design has changed from the previous, there was extra considerations that resurfaced when more detailed information was determined for each table.
The Renter/owner changed to user to make the associations more consistent and to show a person once and representing their different relationships through junction tables rather than storing the same person in separate Renter and Owner tables and risk duplicity in data.

 A new junction table was created between users and properties reflecting how an user can have many properties and a property can be owned by different users.  A new junction table got created between viewing and users to also reflect how an user can have viewings for different properties and one propery can be viewed by multiple users.   An user can be also a renter and an Owner, we could determine if it's both if the user has records in the user_property table.



| Constraint | Action | Description |
|---|---|---|
| `fk_viewing_property` | `RESTRICT` | A property cannot be deleted while viewing records reference it. This preserves historical information. |
| `fk_user_id_user_property` | `RESTRICT` | A user cannot be deleted while ownership records reference the user. The ownership relationship must be resolved first. |
| `fk_property_id_user_property` | `CASCADE` | When a property is deleted, its ownership associations are also deleted because the relationship cannot exist without the property. |
| `fk_viewing_id_user_viewing` | `CASCADE` | When a viewing is deleted, its user-viewing associations are also deleted because the relationship no longer applies. |
| `fk_user_id_user_viewing` | `RESTRICT` | A user cannot be deleted while viewing records reference the user, preserving historical viewing information. |
| `fk_amenity_id_listing_amenities` | `CASCADE` | When an amenity is deleted, its property associations are also deleted. |
| `fk_property_id_listing_amenities` | `CASCADE` | When a property is deleted, its amenity associations are also deleted because they cannot exist without the property. |


## Check Constraints
| Constraint | Action | Description |
|---|---|---|
| `chk_user_email` | `CHECK (email LIKE '%@%.%')` | Requires the email to contain an @ followed by a period, providing basic email format validation. |
| `chk_number_attendees` | `CHECK (total_attendees >= 1)` | A viewing must have at least one attendee; otherwise, there would not be a viewing. |
| `chk_viewing_duration` | `CHECK (duration_min > 0)` | A viewing must have a duration greater than zero. |
