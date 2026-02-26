-- Duplicate Emails
select distinct email as Email
from(
    select email,count(*) over(partition by email) as c
from Person
) as a
where c>1;
--or
select email as Email
from Person 
group by email
having count(email)>1;
----------------------------------------------------
-- Delete Duplicate Emails
delete from Person
where id not in(
   select id from  (
    select id , row_number() over(partition by email order by id) as a
    from Person
   ) as b
   where a=1
);
--or
delete p
from Person p
inner join Person p1
on p.email=p1.email
and p.id>p1.id;
----------------------------------------------------
-- Nth Highest Salary
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
set N=N-1;
  RETURN (
    select distinct salary
    from Employee
    order by salary desc
    limit 1 offset N
  );
END
----------------------------------------------------
-- Rank Scores
select score , dense_rank() over(order by score desc) as "rank"
from Scores
order by score desc;
----------------------------------------------------
-- Department Highest Salary
select a.deptname as Department , a.name as Employee , a.salary
from(
    select e.name , e.salary , d.name as deptname , dense_rank() over(partition by e.departmentid order by salary desc) as r
    from Employee e
    inner join Department d
    on e.departmentid=d.id
) as a
where a.r=1;
----------------------------------------------------