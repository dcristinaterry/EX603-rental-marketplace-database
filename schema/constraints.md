
user {
	int user_id PK:  must be a system created integer for primary key
	varchar first_name:  string NOT NULL containing user's name
	varchar last_name:  string NOT NULL containing user's last name
	varchar address: string containing user's last name
	varchar email:  string containing user's e-mail, should be UNIQUE
	varchar phone_number: string containing user's phone number
	int ssn:  int containing user's SSN, should be UNIQUE **check other conditions for SSN**
}

Your relationship statement "A user can have zero or many viewings" is conceptually correct, but technically it's implemented through user_viewing.
	user_property {
		int user_id PK,FK:  user_id and propert_id are composite keys.  it referenes an user from the user table
		int property_id PK,FK.  it references a property from the property table.
	}

	property {
		int property_id PK: must be a system created integer for primary key
		varchar address: string containing property address.
		boolean is_available : boolean value to determine if the property is available for renting. 
	}

	user_viewing {
		int user_id PK,FK unique key primary and foreing key
		int viewing_id PK,FK unique key primary and foreing key
	}

	viewing {
		int viewing_id PK: must be a system created integer for primary key
		int property_id FK:  relation with properties. 
		timestamp viewing_time:  time stamp field recording time of property viewing.
		int total_attendees: integer with number of attendies for a viewing, the attendies don't have to be users, must be >=1
		int duration_min:  how long the viewing took and it should be > 0.
	}

	listing_amenities {
		int amenity_id PK,FK: unique key primary and foreing key ** both keys are composite keys
		int property_id PK,FK:unique key primary and foreing key
	}

	amenities {
		int amenity_id PK
		varchar name: name of amenity.
		int size : some amenities might need to know how big it is like a pool or bedroom size. 
		varchar description
	}

Relations:
	One user can have cero or many user_property.
	A property can have one or many user_property.
	A user can have cero or many viewings.
	A property can be viewd by cero or many users.
	A property can have cero or many amenities listed.
	

   ON DELETE:

	user_property {
		int user_id PK,FK: ON DELETE RESTRIC. There might be ownership relations, that relation must be resolved first.
		int property_id PK,FK. ON DELETE CASCADE. if a property is deleted all its associations must be deleted.
	}

	property {
		int property_id PK.
		boolean is_available -->set to false.  this can be set to false instead of deleting a property.
	}

	user_viewing {
		int user_id PK,FK  ON DELETE RESTRICT
		int viewing_id PK,FK  ON DELETE CASCADE
	}

	viewing {
		int viewing_id PK.
		int property_id FK ON DELETE RESTRICT. a property cannot be deleted while having a reference to it. this preserves its history, the property attribute can is_available can be set to false instead.
	}

	listing_amenities {
		int amenity_id PK,FK ""ON DELETE CASCADE
		int property_id PK,FK "" ON DELETE CASCADE
	}
