
# Findings

## Breakdown

Viewing Cancellation Analysis

Across the platform, 34 out of 200 viewings were cancelled, resulting in an overall cancellation rate of 17%.

Cancellation rates were different through properties. Some properties showed high cancellation rates, however, a high cancellation percentage alone does not necessarily mean poor performance.  We would need further invesigations into the reason for the cancellation.

I recommend investigating Properties 4,11,13 and 8.  These properties show the edge cases for cancellations.  4 and 11 show high cancellations, so we can analyze reasons and determine how to count a real cancellation for what leadership is looking for. 13 and 8 are the properties with less cancellations.


**Recommendation:** Review cancellation reasons for the identified properties before deciding whether corrective action is necessary.



## Reflection 

Conditional aggregation computes several answers in one pass over the data. Contrast that with running two separate filtered queries. At a million rows, why does the difference matter?

For this assignment, I used COUNT(*) to calculate the total number of viewings for each property and COUNT(CASE WHEN viewing_status = 'cancelled' THEN 1 END) to calculate the number of cancelled viewings.  I could have used two separate queries to count all viewings and another one only cancelled viewings.  By doing this the database would have to scan data multimple times.  I would also need to combine the results separately to compare cancellations with total viewings.

Having this small of data set, I might not be able to notice a difference on the perfomance, but working with over a million rows, reading the rows in the same table repeatedly will increase use of resources and processing time. Conditional aggregation reduces unnecessary work by doing the calculation in the same grouping operation.  As well as keeping the logic together, this makes it more readable and maintainable. 
