##1a. Display the first and last names of all actors from the table actor.
select first_name, last_name from sakila.actor;


##1b. Display the first and last name of each actor in a single column in upper case letters. 
##Name the column Actor Name.
select concat(first_name, ' ',last_name) as 'Actor_Name' from sakila.actor;

##2a. You need to find the ID number, first name, and last name of an actor,
##of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name, last_name from sakila.actor where first_name like '%joe%';

##2b. Find all actors whose last name contain the letters GEN:
select * from sakila.actor where last_name like '%GEN%';


##2c. Find all actors whose last names contain the letters LI. 
##This time, order the rows by last name and first name, in that order:
select * from sakila.actor where last_name like '%li%' order by last_name, first_name;

##2d. Using IN, display the country_id and country columns of the following countries: 
#Afghanistan, Bangladesh, and China:
select * from sakila.country where country in ('Afghanistan', 'Bangladesh', 'China');

##3a. You want to keep a description of each actor. 
##You don't think you will be performing queries on a description, 
##so create a column in the table actor named description 
##and use the data type BLOB 
##(Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE sakila.actor 
ADD COLUMN `description` BLOB NOT NULL AFTER `last_update`;


##3b. Very quickly you realize that entering descriptions for each actor is too much effort. 
##Delete the description column.
ALTER TABLE sakila.actor
DROP COLUMN `description`;


##4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(last_name) as 'number_of_last_name'
from sakila.actor group by last_name;


##4b. List last names of actors and the number of actors who have that last name, 
##but only for names that are shared by at least two actors
select last_name, count(last_name) as 'number_of_last_name'
from sakila.actor group by last_name having count(last_name) >= 2;

##4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
##Write a query to fix the record.
UPDATE sakila.actor 
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' and last_name = 'WILLIAMS';


##4d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
##It turns out that GROUCHO was the correct name after all! In a single query, 
##if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE sakila.actor 
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO';


##5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE sakila.address;


##6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
##Use the tables staff and address:
select a.first_name, a.last_name, b.address,b.address2,b.district,c.city,b.postal_code
from sakila.staff as a
left join sakila.address as b on a.address_id = b.address_id
left join sakila.city as c on b.city_id = c.city_id;


##6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. 
##Use tables staff and payment.
select a.first_name, a.last_name, sum(b.amount) as 'total_amount'
from sakila.staff as a
left join sakila.payment as b on a.staff_id = b.staff_id
where b.payment_date between '2005-08-01' and '2005-08-31'
group by a.staff_id;

##6c. List each film and the number of actors who are listed for that film. 
##Use tables film_actor and film. Use inner join.
select a.title,count(b.actor_id) as 'number_of_actors'
from sakila.film as a
join sakila.film_actor as b on a.film_id = b.film_id
group by a.film_id;

##6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select count(a.film_id) as 'number_of_copies'
from sakila.inventory as a
where a.film_id in (select b.film_id from sakila.film as b where b.title = 'Hunchback Impossible');

##6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
##List the customers alphabetically by last name:
select a.first_name, a.last_name, sum(b.amount) as 'total_amount_paid'
from sakila.customer as a
join sakila.payment as b on a.customer_id = b.customer_id
group by a.customer_id
order by a.last_name asc;


##7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
##As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
##Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select a.title
from sakila.film as a
where a.title like 'k%' or a.title like 'q%' 
and a.language_id in (select b.language_id from sakila.language as b where b.name = 'english');

##7b. Use subqueries to display all actors who appear in the film Alone Trip.
select a.first_name, a.last_name
from sakila.actor as a
where a.actor_id in (select b.actor_id from sakila.film_actor as b 
							where b.film_id in (select c.film_id from sakila.film as c
														where c.title = 'Alone Trip'));
                                                        

##7c. You want to run an email marketing campaign in Canada, 
##for which you will need the names and email addresses of all Canadian customers. 
##Use joins to retrieve this information.
select a.first_name, a.last_name,a.email,d.country
from sakila.customer as a
join sakila.address as b on a.address_id = b.address_id
join sakila.city as c on b.city_id = c.city_id
join sakila.country as d on c.country_id = d.country_id
where d.country = 'canada';



##7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
##Identify all movies categorized as family films.
select a.title
from sakila.film as a
join sakila.film_category b on a.film_id = b.film_id
join sakila.category as c on b.category_id = c.category_id
where c.name = 'family';

##7e. Display the most frequently rented movies in descending order.
select a.title, count(a.film_id) as 'frequently_rented_film'
from sakila.film as a
join sakila.inventory as b on a.film_id = b.film_id
join sakila.rental as c on b.inventory_id = c.inventory_id
group by a.film_id
order by count(a.film_id) desc;

##7f. Write a query to display how much business, in dollars, each store brought in.
select a.store_id, sum(b.amount) as 'dollars_per_store'
from sakila.store as a
left join sakila.payment as b on a.manager_staff_id = b.staff_id
group by a.store_id;

##7g. Write a query to display for each store its store ID, city, and country.
select a.store_id, c.city, d.country
from sakila.store as a
left join sakila.address as b on a.address_id = b.address_id
left join sakila.city as c on b.city_id = c.city_id
left join sakila.country as d on c.country_id = d.country_id
group by a.store_id;


##7h. List the top five genres in gross revenue in descending order. 
##(Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select
e.name as 'film_genres'
,count(a.film_id) as 'frequently_rented_film'
,sum(f.amount) as 'total_revenue'
from sakila.film as a
join sakila.inventory as b on a.film_id = b.film_id
join sakila.rental as c on b.inventory_id = c.inventory_id
join sakila.film_category as d on a.film_id = d.film_id
join sakila.category as e on d.category_id = e.category_id
join sakila.payment as f on c.rental_id = f.rental_id
group by e.category_id
order by sum(f.amount) desc
limit 5;


##8a. In your new role as an executive, 
##you would like to have an easy way of viewing the Top five genres by gross revenue. 
##Use the solution from the problem above to create a view. 
##If you haven't solved 7h, you can substitute another query to create a view.

CREATE VIEW `sakila`.`view_top_5_genres_by_revenue` AS
select
e.name as 'film_genres'
,count(a.film_id) as 'frequently_rented_film'
,sum(f.amount) as 'total_revenue'
from sakila.film as a
join sakila.inventory as b on a.film_id = b.film_id
join sakila.rental as c on b.inventory_id = c.inventory_id
join sakila.film_category as d on a.film_id = d.film_id
join sakila.category as e on d.category_id = e.category_id
join sakila.payment as f on c.rental_id = f.rental_id
group by e.category_id
order by sum(f.amount) desc
limit 5;

##8b. How would you display the view that you created in 8a?
select * from `sakila`.`view_top_5_genres_by_revenue`;

##8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW `sakila`.`view_top_5_genres_by_revenue`;


