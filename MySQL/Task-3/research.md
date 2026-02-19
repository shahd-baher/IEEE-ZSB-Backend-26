# Reasearch Questions :
### 1. WHERE vs HAVING 
 **WHERE** and **HAVING** are both used to filter data according a specific conditions in a SQL query.
 | WHERE | HAVING |
 |:-----:|:------:|
 | Filters rows before grouping | Filters the groups after grouping |
 |Doesn't used with aggregate functions as `(Sum(),Avg())`| Can be used with aggregate functions as `(Max(),Count())`|
 |used before `group by`| used after `group by`|

**EXAMPLE:**
  ```SQL
SELECT class,SUM(score) AS total_score
FROM Students
WHERE score > 50         
GROUP BY class           
HAVING SUM(score) > 150; 
```
---
### 2. DELETE vs TRUNCATE vs DROP :
They all are used to `delete` but in different ways.
| DELETE | TRUNCATE | DROP |
|:------:|:--------:|:----:|
|Remove rows one by one|Remove all rows at once|Removes the table completely `data&structure`|
|Can use a `where` clause|Can't use a `where` clause|Can't use a `where` clause|
|Can be `rolled back`|can't be `rolled back`|can't be `rolled back`|
|Table `structure` stays|Table `structure` stays|Table `structure` doesn't stay|
---
### 3. Order of Execution :
Although we write SQL statement in this order :
`SELECT ... FROM ... WHERE ... GROUP BY ... HAVING ... ORDER BY;`
But it isn't executed in this order so, let's see the `logical` execution.

**The database executes it in this logical order :**
1. FROM `GEt the tables`
2. WHERE `Filter the rows according to the conditions`
3. GROUP BY `To group the rows`
4. HAVING `To filter the groups`
5. SELECT `Choose the columns`
6. ORDER BY `To order the data`
---
### 4. COUNT(*) vs COUNT(Column_Name):
 | COUNT(*) | COUNT(Column_Name) |
 |:-----:|:------:|
 |Counts all rows including `Null` values|Counts only `Non-Null` values in the specified column|
 |Doesn't care about columns values|Cares about columns values|
 |Dosn't ignore NULLS in the rows|ignore NULLS in the columns|
 ---
 ### 5. CHAR vs VARCHAR:
 | CHAR | VARCHAR |
 |:-----:|:------:|
 |Fixed length|Variable length|
 |Uses the n characters of space even if it doesn't need them|Uses only the space needed to store the specific word|
 |Best for `fixed` length|Best for `variable` length|

**EXAMPLE:**  
Explain the difference
between `CHAR(10)` and `VARCHAR(10)` if we store the word
`Cat` in both.
| CHAR(10) | VARCHAR(10) |
 |:-----:|:------:|
 |`"Cat       "`|`"Cat"`|
 |it uses `all` the space|it uses the `length` of the word|