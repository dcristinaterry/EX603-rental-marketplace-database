Modelling justification, 400 to 600 words. Cover your key design decisions: your choice of primary keys, your ON DELETE behaviors, and which rules you chose to enforce in the schema rather than leaving to the application.
## Justification for Design

The Rental Marketplace database was designed to represent the interactions between renters and available properties while maintaining the integrity of the data. The model centers on renters, properties, and viewings, while amenities provide additional information about each property.
Each concept separates relations in order to avoid duplicate information and allow an user to search information about each entity and their relation.

I defined the primary keys of each relation as unique number assigned by the system in order to avoid any changes on the primary key.  Information such as name, SSN or other type of data might change in the future, and this way I find it more secure to have the system assign a unique numerical primary key.

I found there to be a many to many relations between a Property and Amenity.  A property will have many amenities, and a type of amenity can be found in multiple properties, for example a pool.  This is why the listing_amenities table is necessary to brake the many to many relation.

There was also another possible many to many relation between a Renter and a property.  In this case since we are just managing Viewing of listing's information, the many to many relationship doesn't occur.  We end up with a renter participating in multiple viewings, and a property also showing up in multiple viewings. We could find in the Viewing table all the renters for a specific property, or all the Properties a specific renter is viewing. Each viewing can therefore be recorded independently along with its time, number of attendees, and duration.

As a preliminary decision, I added "number of attendees" for a viewing, since this information might be helpful to the user in preparing the property.  I added is_available in the property table to make sure only available properties are assinged to a viewing at the moment of assign a property for viewing to a renter.

As for Deletes I chose ON DELETE CASCADE between Property and Listing_Amenities because an association between a property and an amenity has no meaning after the property itself has been deleted.  I decided to maintain the information of Properties and Renters on the viewing table even if the records are deleted from the corresponding tables since history of viewings might be necessary.



## Reflection

When designing the solution I set up the following questions:

Which properties are there?
Which properties are currently available?
Which properties are currently Not available?

Which properties has a renter viewed?
Which renters have viewed a particular property?
How many viewings does a property have?
How many viewings does a property have in a specific timeframe?
How long did a viewing last?

Which amenities does a property offer?
Which properties have a specific amenity?

There are other decisions left open that will need more clarity as the project progresses and that different designer could have made different.  for example Do we need to save information about the rental process?, what type of information do we need to save of the Renter.  Are there specific searches by price range of the property or just amenities?
From my initial set of questions, this one still not reflected on the model "How many viewings does a property have in a specific timeframe?".  There's still need to be clarity if there will be searches by a certain time frame for available properties or what was viewed in a certain time period.

Another design decision I made was introducing is_available to the property table.  Another designer could have chose not to to add this attribute, but I found it necessary since I find it important to show the renter that the property might not be available for rent when viewing the property.  And Since we are not managing renting information this piece of data might not have been introduce by another designer.
