
-- Task 5.3: Understand Join Performance and Execution Plans
-- In this task, you will explore how joins affect query performance and how PostgreSQL decides to execute a query.

-- Part A: Explore CROSS JOIN
-- Write a CROSS JOIN between two small tables.

-- Then:

-- Count the rows in each source table.
-- Run the CROSS JOIN and count the resulting rows.
-- Show how the result matches the multiplication of the two source table counts.
-- Explain when a Cartesian product might be useful and when it could indicate a query error.
-- For example, if one table has 5 rows and another has 4 rows, the cross join produces 20 rows.

-- Choose small tables so the result is manageable.



-- Part B: Examine a Query Execution Plan
-- Return to your three-table join from Task 5.1, Part A. Use PostgreSQL's EXPLAIN command to examine how the database plans to execute the query.



-- EXPLAIN
-- SELECT ...    -- your three-table join from 5.1
-- ;
-- -- EXPLAIN ANALYZE also runs the query and reports actual timings.
-- -- Safe here; be careful with it on statements that modify data.


-- Review the execution plan and complete the following:

-- Capture the full execution plan.
-- Identify the join algorithm or algorithms used, such as Nested Loop, Hash Join, or Merge Join.
-- Explain why PostgreSQL may have selected these algorithms, considering table sizes and available indexes.
-- Predict which part of the query might become less efficient as the dataset grows.
-- You may also use EXPLAIN ANALYZE to measure actual execution behavior. Unlike EXPLAIN, it runs the query. It is appropriate for your read-only SELECT query, but use caution with statements that modify data.



-- Write up
-- In /analysis/unit5.md, answer the following questions:

-- Give an example of when a Cartesian product could be useful on your platform, or explain why you would not need one.
-- Which join algorithms did PostgreSQL choose for your query?
-- What information in the execution plan helps explain those choices?
-- Why is it useful to understand the selected join algorithms?
-- What changes to the data or database might make another join algorithm more appropriate?
-- Support your explanation with observations from your execution plan.
