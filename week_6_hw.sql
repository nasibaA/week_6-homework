
 
#1. Show all customers whose last names start with T. Order them by first name from A-Z.
 
select last_name,first_name   --- in this one select last name and first name from desired date 
from customer
where last_name like 'T%'     --- will gets a last_name of all last_names whose last name begins with 'T' 
order by first_name;

#2. Show all rentals returned from 5/28/2005 to 6/1/2005


select *                                                        --- first I select all columns from  rental date.
from rental
where return_date                                               --- here I used 'where' clause to filter date      
Between '5/28/2005' and '6/2/2005';                              ---'Between' operator select values between those date   


#3. How would you determine which movies are rented the most?

select f.title, Count(r.inventory_id) as most_rented --- I used 3 tables to get result.
from rental as r
inner join inventory as i
on i.inventory_id = r.inventory_id                   --- for join one table to another we need to use same-ID 
inner join film as f
on f.film_id = i.inventory_id                        
group by f.title
order by most_rented desc;



#4. Show how much each customer spent on movies (for all time) . Order them from least to most.

select concat(customer.last_name,' ' ,customer.first_name) as customer , sum(amount) as expense 
from payment                                    --- In here I use concat to make the Last_name and First_name in one column 
                                                --- and ',' because we use between last_name and first_name make a space. 
inner join customer
on customer.customer_id = payment.customer_id 
group by customer 
order by expense 





#5 Which actor was in the most movies in 2006 (based on this dataset)? Be sure to alias the actor name and count as a more descriptive name. Order the results from most to least.

select first_name, last_name,actor.actor_id, COUNT(film_actor.actor_id) as number_rol
from actor
inner join film_actor 
on film_actor.actor_id = actor.actor_id
inner join film
on film.film_id = film_actor.film_id
group by actor.actor_id
order by number_rol desc;

#6.  Write an explain plan for 4 and 5. Show the queries and explain what is happening in each one. Use the following link to understand how this works http://postgresguide.com/performance/explain.html 

--- N=4
EXPLAIN ANALYZE  select concat(customer.last_name,' ' ,customer.first_name) as customer , sum(amount) as expense 
from payment 
inner join costomer
on customer.customer_id = payment.customer_id 
group by customer 
order by expense 
--- when I run N=4 code with EXPLAIN ANALYZE it shows me seq scans took less time their max time.


----N=5
Explain Analyze select first_name, last_name,actor.actor_id, COUNT(film_actor.actor_id) as number_rol
from actor
inner join film_actor 
on film_actor.actor_id = actor.actor_id
inner join film
on film.film_id = film_actor.film_id
group by actor.actor_id
order by number_rol desc;
--- when I run this code I got lot of execution plan then N=4. I think in N=5 exercise more steps then N=4. But N=5 still took less time then max time.



#7.What is the average rental rate per genre?
 
select category.name as cotegory_name, avg(film.rental_rate)
from  category
inner join film_category
on category.category_id = film_category.category_id
inner join film
on film.film_id = film_category.film_id
group by category.name



#8. How many films were returned late? Early? On time?

select  COUNT(DATE_PART('day', return_date - rental_date) - rental_duration = 0 ) as on_time,
        COUNT(DATE_PART('day', return_date - rental_date) - rental_duration  > 0 ) as late,
         COUNT(DATE_PART('day', return_date - rental_date) - rental_duration  < 0 ) as early
from film
inner join inventory
Using(film_id)
inner join rental
using(inventory_id)

#9. What categories are the most rented and what are their total sales?
 
select c.name as category,sum(amount)as total_sales
from category as c
inner join film_category
on c.category_id = film_category.category_id
inner join inventory as i
on film_category.film_id = i.film_id
inner join rental as r
on i.inventory_id = r.inventory_id
inner join payment as p
on p.rental_id = r.rental_id
group by category
order by Count(r.rental_id)desc;

#10. Create a view for 8 and a view for 9. Be sure to name them appropriately. 

---view for N=8

create view return_days_table as
select  COUNT(DATE_PART('day', return_date - rental_date) - rental_duration = 0 ) as on_time,
        COUNT(DATE_PART('day', return_date - rental_date) - rental_duration  > 0 ) as late,
         COUNT(DATE_PART('day', return_date - rental_date) - rental_duration  < 0 ) as early
from film
inner join inventory
Using(film_id)
inner join rental
using(inventory_id)

---view for N=9

create view rented_categories as

select c.name as category,sum(amount)as total_sales
from category as c
inner join film_category
on c.category_id = film_category.category_id
inner join inventory as i
on film_category.film_id = i.film_id
inner join rental as r
on i.inventory_id = r.inventory_id
inner join payment as p
on p.rental_id = r.rental_id
group by category
order by Count(r.rental_id)desc;





