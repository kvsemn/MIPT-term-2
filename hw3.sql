--Вывести распределение (количество) клиентов по сферам деятельности, отсортировав результат по убыванию количества. — (1 балл)

select 
	c.job_industry_category,
	count(distinct customer_id)
from customer c 
group by 1
order by 2 desc;


-- Найти сумму транзакций за каждый месяц по сферам деятельности, отсортировав по месяцам и по сфере деятельности. — (1 балл)

select 
	split_part(transaction_date::text, '.', 2),
	c.job_industry_category,
	sum(replace(list_price, ',', '.')::float)
from "transaction" t 
join customer c 
	on t.customer_id = c.customer_id 
group by 1, 2
order by 1, 2;


-- Вывести количество онлайн-заказов для всех брендов в рамках подтвержденных заказов клиентов из сферы IT. — (1 балл)


select 
	brand,
	count(distinct t.transaction_id)
from "transaction" t 
join customer c 
	on t.customer_id = c.customer_id 
		and c.job_industry_category = 'IT'
where t.online_order and order_status = 'Approved'
group by 1
having brand <> '';


-- Найти по всем клиентам сумму всех транзакций (list_price), максимум, минимум и количество транзакций,
-- отсортировав результат по убыванию суммы транзакций и количества клиентов. Выполните двумя способами: 
-- используя только group by и используя только оконные функции. Сравните результат. — (2 балла)

select 
	customer_id,
	sum(replace(list_price, ',', '.')::float),
	max(replace(list_price, ',', '.')::float),
	min(replace(list_price, ',', '.')::float),
	count(distinct replace(list_price, ',', '.')::float) 
from "transaction" t 
group by 1
order by 2 desc, 1 desc;



select 
	distinct customer_id,
	sum(replace(list_price, ',', '.')::float) over (partition by customer_id),
	max(replace(list_price, ',', '.')::float) over (partition by customer_id),
	min(replace(list_price, ',', '.')::float) over (partition by customer_id),
	count(replace(list_price, ',', '.')::float) over (partition by customer_id)
from "transaction" t 
order by 2 desc, 1 desc;



-- Найти имена и фамилии клиентов с минимальной/максимальной суммой транзакций за весь период (сумма транзакций не может быть null).
-- Напишите отдельные запросы для минимальной и максимальной суммы. — (2 балла)

select 
	first_name , last_name 
from (
	select 
		distinct 
		c.customer_id,
		c.first_name,
		c.last_name,
		sum(replace(list_price, ',', '.')::float) over (partition by c.customer_id) as sum_list_price
	from "transaction" t 
	join customer c
		on c.customer_id = t.customer_id 
) a 
where sum_list_price::int8 in (select min(sum_list_price::int8) from (
	select 
		distinct 
		customer_id,
		sum(replace(list_price, ',', '.')::float) over (partition by customer_id) as sum_list_price
	from "transaction" t 
	) a
);




select 
	first_name , last_name 
from (
	select 
		distinct 
		c.customer_id,
		c.first_name,
		c.last_name,
		sum(replace(list_price, ',', '.')::float) over (partition by c.customer_id) as sum_list_price
	from "transaction" t 
	join customer c
		on c.customer_id = t.customer_id 
) a 
where sum_list_price::int8 in (select max(sum_list_price::int8) from (
	select 
		distinct 
		customer_id,
		sum(replace(list_price, ',', '.')::float) over (partition by customer_id) as sum_list_price
	from "transaction" t 
	) a
);




-- Вывести только самые первые транзакции клиентов. Решить с помощью оконных функций. — (1 балл)

select 
transaction_id 
from (
	select 
	customer_id,
	transaction_id,
	row_number() over(partition by customer_id order by transaction_date asc) as rn 
	from "transaction" t
	order by customer_id, transaction_date asc
) a 
where rn = 1;



-- Вывести имена, фамилии и профессии клиентов, между транзакциями которых был максимальный интервал (интервал вычисляется в днях) — (2 балла).




-- максимальные интервалы между транзакциями для каждого пользователя
with base as (
select 
customer_id, 
max(dt::date - lag::date) as max_interval
from (
select 
t.customer_id ,
t.dt ,
lag(t.dt) over (partition by customer_id order by t.dt::date asc) as "lag"
from (
	select 
		*, 
		split_part(t.transaction_date, '.', 3) || '-' || split_part(t.transaction_date, '.', 2) || '-' || split_part(t.transaction_date, '.', 1) as dt
	from "transaction" t 
		) t
) a
group by customer_id
having max(dt::date - lag::date) is not null
order by 2 desc
)
select 
	c.first_name, c.last_name, c.job_title
from customer c 
join base b 
	on c.customer_id = b.customer_id
	and b.max_interval in (select max(max_interval) from base);



















