Renter {
		int renter_id PK :   must be an integer assingned by the system, other information might be saved relevant to a renter such as SSN or phone.number, but for id is important this number is Unique and never changes.
		
        varchar first_name: must be a string and not null.
		varchar last_name:  must be a string and not null.
		varchar address:  must be a string, can be null, the renter might not want to provide or have a current address.
	}

	viewing {
		int viewing_id PK :  must be an unique integer assigned by the system, not null.
		int renter_id FK  must reference an existing renter.
		int property_id FK must reference and existing property.
		timestamp viewing_time : timestamp date to record time of the viewing.
		int number_attendees:  integer not null probably greather than 1 to record how many people are attending the viewing.
		int duration_min : integer in min.
	}

	Property {
		int property_id PK :must be an unique integer assigned by the system, not null 
		varchar name:  string containing the property name, can be null 
		varchar address:  string containing the property address.  NOT null
        boolean is_available:  true or false value to indicate if the property is available for viewing 
	}

	amenities {
		int amenity_id PK: must be an unique integer assigned by the system, not null 
		varchar name : string with the ammenitie name
		varchar description: string with the ammenitie description
	}

	listing_amenities {
		int amenity_id PK,FK must reference an existing amenity.
		int property_id PK,FK must reference an existing property.
	}