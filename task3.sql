--1
select 
	category.name, count(film_category.film_id) 
from 
	category 
	inner join film_category using(category_id)
group by category.name
order by 2 desc;


--2
SELECT
	CONCAT(actor.last_name, ', ', actor.first_name) AS actor,
	sum(film.rental_duration)
FROM
	film
	join film_actor using(film_id)
	join actor using(actor_id)
GROUP by actor
order by 2 desc
limit 10;


--3
select 
	category.name, sum(payment.amount) 
from
	category 
	join film_category using (category_id)
	join film using(film_id)
	join inventory using(film_id)
	join rental using(inventory_id)
	join payment using(rental_id)
group by 1
order by 2 desc
limit 1;


--4
select 
	film.title 
from 
	film
	left join inventory using(film_id) 
where inventory.film_id is null;


--5
with tbl as (
	select 
		CONCAT(actor.last_name, ', ', actor.first_name) AS actor,
		count(film.film_id) as c
	FROM
		actor
		join film_actor using(actor_id)
		join film using(film_id)
		join film_category using(film_id)
		join category using(category_id)
	where
		category.name = 'Children'
	group by 
		actor)
select * from tbl 
where
	c in (select distinct(c) from tbl order by 1 desc limit 3)
order by 2 desc;


--6
select 
	city.city, sum(customer.active) active, 
	count(customer.active) - sum(customer.active) inactive
from 
	customer 
	join address using(address_id)
	join city using(city_id)
group by 1
order by 3 desc;


--7
with tbl as (
	select 
	 	category.name, rental.return_date, 
	 	rental.rental_date, city.city 
	from
		city
		join address using(city_id)
		join customer using(address_id)
		join rental using(customer_id)
		join inventory using(inventory_id)
		join film using(film_id)
		join film_category using(film_id)
		join category using(category_id)
	where 
		rental.return_date is not null)
(select 
 	name,
 	sum(return_date - rental_date) 
from tbl
where 
	city like 'A%' or city like 'a%'
group by 1 
order by 2 desc
limit 1)
union all
(select 
 	name, 
 	sum(return_date - rental_date)
from tbl
where 
	city like '%-%'
group by 1 
order by 2 desc 
limit 1);
