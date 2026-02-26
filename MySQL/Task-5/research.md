## Research Answers
### 1. Window Functions vs GROUP BY :
|Item|Window Functions|GROUP BY|
|:--:|:--------------:|:------:|
|Output Granularity|Keeps all original rows|Reduces the rows into one row per group|
|Details|`Preserves` the row-level details|`Loses` the row-level details| 
|Data analysis|Advanced data analysis|Simple data analysis|
|Use case|Aggregation without reducing rows|Aggregation with row reduction|

`Window Functions` -> keep all original rows, adding aggregated values as extra columns. The granularity stays at the row level.  
`GROUP BY` -> reduces the number of rows by collapsing them into one row per group. As a result, you lose row-level detail.
- So, if you want the details and advanced data analysis choose `Window Functions` but if you want less details and simple data analysis choose `GROUP BY`.
---
### 2. Clustered vs Non-Clustered Indexes :
**Difference between the `Leaf Nodes` in :**
|Clustered Indexes|Non-Clustered Indexes|
|:---------------:|:-------------------:|
|It stores the `actual data` rows in the leaf nodes of its B-tree|It stores `row locators` or `pointers` in its leaf nodes which references where the data is stored|

**Why is allowed to have exactly `one` clustered index per table ?**
- Because the clustered index determines the `physical order` of the data on the disk so as a result they can't be ordered physically more than one time.
---
### 3. Filtered & Unique Indexes :
**What Is a Filtered Index?**
- It is a filter that filters a subset of rows using the `Where` filter.
**Why is it Useful?**
- According to : 

|Storage|
|:-----:|
|It uses less storage as it indexes fewer rows| 

|Query Performance|
|:---------------:|
|Faster queries that target the filtered subsets|
|Lower index maintenance cost during inserts and updates|

**Unique Index Impact on INSERT vs SELECT :**
|INSERT|SELECT|
|:----:|:----:|
|Slows it down because the SQL server must check the index to make sure that there are no duplicates| speeds it up because a unique index is highly selective and making row lookusps faster|
--- 
### 3. Choosing the Right Index for a Staging Table :
- We will use the `Heap` structure.
- Because it allows :
  - maximum insert speed.
  - minimal maintenance.
  - efficient `read once`.
  ---
### 4.Database Transactions (ACID) :
**All or Nothing `(Atomicity)` concept :**
- It is a concept that ensures that every step in a transaction succeeds or else everything is rolled back.  

**What disastrous scenario happens if a partial failure occurs without using a Transaction ?**
- The partial failure might commit some changes and not others.
- This can cause disastrous inconsistencies such as:
  - Money withdrawn but not deposited.
  - Inventory deducted but order not created.
  - Duplicate charges.
  - Corrupted or incomplete data states.  
- So, transactions prevent the system from being left in an `invalid` or `partially` updated state.