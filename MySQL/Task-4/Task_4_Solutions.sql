--Combine Two Tables
select firstName , lastName , city , state 
from Person 
left join Address
on Person.personId=Address.personId ;
----------------------------------------------------------------
-- Replace Employee ID With The Unique Identifier
select unique_id , name
from Employees
left join EmployeeUNI
on Employees.id=EmployeeUNI.id;
----------------------------------------------------------------
-- Customer Who Visited but Did Not Make Any Transactions
select customer_id , count(*) as count_no_trans 
from Visits as v
left join Transactions as t
on v.visit_id=t.visit_id
where t.transaction_id is null 
group by customer_id;
----------------------------------------------------------------
-- Project Employees I
select  p.project_id , round(avg(experience_years),2) as average_years 
from Project as p 
inner join Employee as e
on p.employee_id=e.employee_id      
group by p.project_id ;
----------------------------------------------------------------
-- Sales Person
select s.name
from SalesPerson as s
where sales_id not in (
select o.sales_id
from orders as o
join Company as c
on o.com_id=c.com_id      
where c.name='RED'
);
----------------------------------------------------------------
-- Rising Temperature
select w.id
from Weather as w
inner join weather as w1
on w.recordDate=date_add(w1.recordDate,interval 1 day)
where w.temperature>w1.temperature ;
----------------------------------------------------------------
-- Average Time of Process per Machine
select a.machine_id,round(avg(e.timestamp-s.timestamp),3) as processing_time
from Activity as a
inner join Activity as s
on a.machine_id=s.machine_id
and a.process_id=s.process_id
and s.activity_type='start'
inner join Activity as e
on a.machine_id=e.machine_id
and a.process_id=e.process_id
and e.activity_type='end'
group by a.machine_id;
----------------------------------------------------------------
-- Students and Examinations
select s.student_id,s.student_name,
sub.subject_name, count(e.student_id)as attended_exams
from Students as s
cross join Subjects as sub
left join Examinations as e
on s.student_id=e.student_id
and sub.subject_name=e.subject_name
group by 
s.student_id,s.student_name,sub.subject_name
ORDER BY 
 s.student_id, sub.subject_name;
----------------------------------------------------------------
-- Managers with at Least 5 Direct Reports
select e1.name 
from Employee as e
inner join Employee as e1
on e.managerId=e1.id
group by e1.id,e1.name
having count(e.id)>=5;
----------------------------------------------------------------
-- Confirmation Rate
SELECT s.user_id, 
ROUND(AVG(IF(c.action='confirmed',1,0)),2) as confirmation_rate 
FROM Signups as s
LEFT JOIN Confirmations as c 
ON s.user_id = c.user_id
GROUP BY s.user_id;
----------------------------------------------------------------
-- Product Sales Analysis III
select product_id,year as first_year, quantity, price
from Sales
where(product_id, year) in (select  product_id, min(year) 
from Sales 
group by product_id);
-- or
select s.product_id, s.year as first_year ,s.quantity, s.price
from Sales as s
inner join (
    select product_id , min(year) as first_year
    from sales 
    group by product_id
) as n
ON s.product_id = n.product_id
AND s.year = n.first_year;
----------------------------------------------------------------
-- Market Analysis I
select u.user_id as buyer_id,
u.join_date,
ifnull(count(o.order_id),0) as orders_in_2019 
from users u
left join orders o
on u.user_id=o.buyer_id
and YEAR(order_date) = '2019'
group by u.user_id, u.join_date;
----------------------------------------------------------------