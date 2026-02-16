### 1-Difference between DBMS and RDBMS
**DBMS (Data Base Management System)** -> Is a software package that facilitate the creation and maintanence of computerized database and help us in :
- storing data
- retrieving data
- upating data
- deleting data

but it is used in :
- simple files 
- weak relationships
- good in small data or applications

*EX :*
- Microsoft Access

**RDBMS (Relational Data Base Management System)** -> It is a more advanced type of DBMS and it help us in :
- storing data in tables
- strong relationships
- using primary keys and foreign keys
- good for large applications or systems

*EX :*
- MySQL
- Oracle Database
------------------------------------------------------------------
### 2-Difference between DDL and DML
Firstly we must know that we use **SQL** language when we work with data base and this language has different types of commands including **DDL** and **DML**.

**DDL (Data Defintion Language)** -> It is used to create or change the structure of the data base but not manipulate it.

It is used in : 
- creating (tables , columns)
- Altering (tables , columns)
- Dropping (tables , columns)
- Truncate (tables)

so this changes the structures not the data .

*EX : creating a table*

create table Employee(
    Id varchar2(20) Primary key,
    Name varchar2(30)
);

**DML (Data Manipulation Language)** -> is used to work with the actual data inside the tables.

It is used in : 
- select (reading data)
- upate (changing data)
- delete (removing data)

so this changes the data not the structure.

*EX : inserting into a table*

INSERT INTO Employee (ID, Name)
VALUES (1, 'Omar');

------------------------------------------------------------------
### 3-Importance of Normalization
In fact normaliztion means :
- Organizing data into separate tables
- Removing redundancy
- Avoiding data problems

so when we have large system like University we must make sure that the data is not in a mess so we use normalization by executing some steps to make sure that the data is organized and well structured.

**So, We can say that the impotance of Normalization is :**
- Reducing Repetition
  - No unnecessary repeated data
- Preventing Update Problems
  - Change student name once — done
- Preventing Deletion Problems
  - Deleting a course does not delete student information
- Keeping Data Accurate
  - Relationships are clear and safe
- Keeping the system developed
  - The system still works efficiently
------------------------------------------------------------------