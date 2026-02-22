## Research Answers
### 1. UNION vs UNION ALL :
|Features|UNION|UNION ALL|
|:------:|:---:|:-------:|
|Duplicate Handling|Removes duplicates|Keeps all rows including duplicates|
|Performance|Slower due to filtering the repeated data`(Distinct operation)`|Faster as it doesn't filter the repeated data `(No Distinct operation)`|
|Use Case|When unique results are required|When performance or time matters and there is no problem for duplications|

**Conclusion :**
- `UNION`-> performs a `DISTINCT` operation which makes it slower so, Choose `UNION` only when you need unique results. 
- `UNION ALL` -> keeps `all` rows and is faster, especially with large datasets so, Choose `UNION ALL` when performance is a priority and duplicates don't matter.
---
### 2. Subquery vs JOIN :

**Why might you choose to use a `Join` instead of a `Subquery`?**   
Let's see ...
|Features|Subquery|JOIN|
|:------:|:---:|:-------:|
|Performance|Can be slower,especially the correlated subqueries `(Nested subqueries)`|Usually faster as it is optimized by SQL engine|
|Readability|Harder to read when it is nested deeply|Easier to read for complex multi-table queries|
|Index Usage|Sometimes harder to engine to optimize|It makes a better use of indecies|
|Flexibility|Becomes complex with multiple nested subqueries|Less complex and easy to join multiple tables|

**Conclusion :**
- `Subquery` -> They are still useful in scenarios where simplification or isolated logic is needed, but they can hurt performance and they are sometimes complicated to understand.
- `JOIN` -> They are generally preferred in production for better performance, clearer structure, and more efficient use of indexes and easier to understand so, Prefer `JOINs` in production for speed, readability, and optimization.