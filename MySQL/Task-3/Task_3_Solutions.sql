-- invalid tweets
select tweet_id 
from Tweets
where length(content)>15;
-----------------------------------------------------------------
-- fix name in a table
select user_id , concat(upper(left(name,1)),lower(substr(name,2))) as name
from Users
order by user_id;
-----------------------------------------------------------------
-- calculate special bonus
select employee_id , 
case
when (employee_id %2!=0) and name not like "M%"
then salary
else 0
end as bonus
from Employees
order by employee_id;
------------------------------------------------------------------
-- Patients With a Condition
select  patient_id , patient_name ,conditions   
from Patients
where conditions like 'DIAB1%' OR conditions like '% DIAB1%';
------------------------------------------------------------------
-- Find Total Time Spent by Each Employee
select event_day as day , emp_id , sum(out_time - in_time) as "total_time"
from Employees
group by event_day,emp_id;
------------------------------------------------------------------
-- Find Followers Count
select user_id , count(follower_id ) as "followers_count"
from Followers
group by user_id
order by user_id ;
------------------------------------------------------------------
-- Daily Leads and Partners
select date_id , make_name , count(distinct lead_id )as "unique_leads" , count(distinct partner_id ) as "unique_partners"
from DailySales
group by date_id , make_name;
------------------------------------------------------------------
-- Actors and Directors Who Cooperated At Least Three Times
select actor_id , director_id
from ActorDirector 
group by actor_id,director_id
having count(concat(actor_id, director_id))>=3;
------------------------------------------------------------------
-- Classes With at Least 5 Students
select  class
from Courses
group by class
having count(concat(student, class))>=5;
------------------------------------------------------------------
-- Game Play Analysis I
select player_id , min(event_date) as first_login
from Activity
group by player_id;
------------------------------------------------------------------
-- Capital Gain/Loss
select stock_name ,
 sum(
    case 
    when operation ='Sell'
    then price
    else 
    - price 
    end
  ) as capital_gain_loss 
  from Stocks
  group by stock_name ;
------------------------------------------------------------------
-- Second Highest Salary
select max(salary) as SecondHighestSalary 
from Employee
where salary<(select max(salary) from Employee );
------------------------------------------------------------------