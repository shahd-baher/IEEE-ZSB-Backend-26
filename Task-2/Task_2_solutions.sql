select product_id 
from Products
where low_fats ='Y'
and recyclable ='Y';
--------------------------------------------------------------------------
select name ,population ,area
from World
where area>=3000000
or population >=25000000;
--------------------------------------------------------------------------
select name 
from Customer
where referee_id !=2
or referee_id is null;