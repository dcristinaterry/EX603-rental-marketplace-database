6.1

—group by 13
—window 156

The window-function query uses AVG(duration_min) OVER (PARTITION BY property_id) to calculate the average viewing duration for each property while preserving every individual viewing record. In contrast, the GROUP BY query combines the viewing records into one row per property.
The window-function query returns one row per attended viewing, while the GROUP BY query returns one row per property with attended viewings. The main disadvantage of GROUP BY for this task is that it removes individual viewing details from the results, making it impossible to compare each viewing's duration with its property's average without joining the aggregated results back to the original table.

I would use AVG() with OVER(PARTITION BY property_id) to display each viewing alongside the average duration for its property.

SELECT
    viewing_id,
    property_id,
    duration_min,
    AVG(duration_min) OVER (
        PARTITION BY property_id
    ) AS avg_property_duration
FROM viewings;

But this doesn't really answer the question for the duration of each property viewing. A window function allows me to calculate the group average without losing the individual records.

2. Ranking and Tie Handling

Platform feature: A leaderboard showing the most-viewed properties.

I would rank properties based on their total number of viewings to help identify which listings attract the most interest.

For this DENSE_RANK() would be best, because properties with the same number of viewings should share the same rank, without skipping the next rank.

For example, if two properties each have 5 viewings and share first place, the property with 1 viewings should be ranked second, not third, so properties with equal viewing counts receive equal rankings.

6.2

What would a large delta tell someone about your platform, and what should they do about it?

A large delta indicates the change in viewing duration betwwen two consecutive viewings for the same property.   Te positive delta is that it lasted longer. It might indicate that the renter is more interested or the property is better, but this should be investigated further. 

Why does a running total answer a question that a plain SUM cannot?
because the running total shows how it accumulates over time. 


Why did you pick your moving-average window size? A different size tells a different story.


What does a gap mean in your platform: a data quality problem, a real stop in activity, or a side effect of how events were recorded? Each needs a different response. Say which one yours is and how you know.