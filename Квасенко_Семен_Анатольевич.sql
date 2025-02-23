

-- 1
select 
	t.brand
from (
select 
	distinct t.brand
	,replace(t.standard_cost, ',', '.') as standard_cost
from "transaction" t 
where t.brand > ''
) t
where t.standard_cost::float > 1500
;

-- 2

select 
	distinct transaction_id
from (
select 
	transaction_id 
	,split_part(transaction_date, '.', 3) || '-' || split_part(transaction_date, '.', 2) || '-' || split_part(transaction_date, '.', 1) as transaction_date 
from "transaction" t 
where order_status = 'Approved'
) t 
where 
	transaction_date::date >= '2017-04-01'::date and transaction_date::date <= '2017-04-09'::date
;

-- 3
	
select 
	distinct c.job_title
from customer c 
where
	c.job_title ilike 'Senior%'
	and c.job_industry_category in ('IT', 'Financial Services');

-- 4

select 
	distinct brand		
from "transaction" t 
where t.customer_id::text in (select distinct customer_id::text from customer c where c.job_industry_category in ('Financial Services'))
	and t.order_status = 'Approved';

	
-- 5

select customer_id from "transaction" t 
where t.online_order
	and t.brand in ('Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles')
order by random() limit 10;


-- 6 

select
	distinct c.customer_id 
from customer c 
left join "transaction" t 
	on c.customer_id = t.customer_id 
where
	t.customer_id is null;
	
-- 7
	
select t.customer_id, max(replace(t.standard_cost, ',', '.')::float) as max_std_cost
from customer c
join "transaction" t 
	using(customer_id)
where c.job_industry_category = 'IT' and t.standard_cost > ''
group by t.customer_id;
	


-- 8
select 
	customer_id
from (
select 
	t.customer_id
	,split_part(transaction_date, '.', 3) || '-' || split_part(transaction_date, '.', 2) || '-' || split_part(transaction_date, '.', 1) as transaction_date 
from "transaction" t 
join customer c 
	on t.customer_id = c.customer_id
		and c.job_industry_category in ('IT', 'Health')
where t.order_status = 'Approved'
) a 
where 
	transaction_date::date >= '2017-07-07'::date and transaction_date::date <= '2017-07-17'::date
;












	
	
	

