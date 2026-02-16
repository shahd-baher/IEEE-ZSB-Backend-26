## Normalization forms
What if we got a messy excel sheet that contain a single table called **Student_Grade_Report** that has composite primary key which is (*student_name , course_title*) and this sheet won't help us get the data we want directly as its data isn't organized well , its has redundant values , it has repeated groups and there are functional dependencies so, to solve these problems we will execute some steps that will help us to make this sheet perfect and effecient: 
1. **First Normal Form**
2. **Second Normal Form**
3. **Third Normal Form**

Let's go to the first step:
### **Step 1: First Normal Form (1NF)**
We use this form to handle :
- Multivalued attributes
- Composite attributes
- Repeating groups

In our table we have multivalued attribute and composite attribute so we will handle them and see what the table will look like after this step.
#### Multivalued attribute (student_phone) :
we will make a new table and put the student_phone in it and add the student_name to be a foreign key refrencing the primary table and at the same time will form composite primary key with the student_phone.
#### Composite attribute (student_address) :
we will decopose it in the same table to its components which are (city , street , zip).

So the 1NF after these edits will be like this :

**Student_Grade_Report :**

| student_name | city | street | zip | course_title | Instructor_Name | Instructor_dept | dept_building | grade|

**Student_Phone :**

| student_name | student_phone | 
->(here *student_name* will be (FK) refrencing the primary table and will be ( composite PK) with *student_phone*)

### **Step 2: Second Normal Form (2NF)**
We use this form when we make sure that the table :
- is in the 1NF 
- has partial dependencies -> (it means that there is a non key attribute depends on a part of the primary key)

In our table that is in the 1NF we have 2 partial dependencies so we will make a new table for each partial dependency and we will see them in the 2NF tables.

So the 2NF after these edits will be like this :
**Student_Phone :**

| student_name | student_phone | 

**Student_grade :**

| student_name | course_title | grade|

**Student_address :**

| student_name | city | street | zip | 

->(here the address of the student depends on the *student_name* not dependent on the *course_title* and the (PK) here is the (student_name)) 

**Instructor_info :**

| course_title | Instructor_Name | Instructor_dept | dept_building | 

->(here the info of the instructor depends only on the *course_title* not the *student_name* as by knowing the course_title its easy to know who teaches it and its info and here the (PK) will be the (course_title))

### **Step 3: Third Normal Form (3NF)**
We use this form when we make sure that the table :
- is in the 2NF 
- has transitive dependencies -> (it means that there is a non key attribute depends on another non key attribite that depends on a part of the primary key or on the full primary key)

In our table that is in the 2NF we have 1 transitive dependency so we will make a new table for this transitive dependency and we will see it in the 3NF tables.

So the 3NF after these edits will be like this :
**Student_Phone :**

| student_name | student_phone |

**Student_grade :**

| student_name | course_title | grade|

**Student_address :**

| student_name | city | street | zip | 

**Instructor_info :**

| course_title | Instructor_Name | Instructor_dept |

->(here (Instructor_dept) is (FK) which refrence the (Department_info) table)

**Department_info :**

| Instructor_dept | dept_building |

->(here to know the building where the instructor works we want to know only the department which he belongs to so this represents transitive dependency where (dept_building) which is a non key attribute depends on (Instructor_dept) which is a non key attribute and here the (Instructor_dept) will be a (PK))

So after these three steps our sheet will be organized , easy to use and has no redundant values.