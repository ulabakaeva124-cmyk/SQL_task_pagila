--The number OF movies IN EACH category

SELECT category.name AS name,
	COUNT(category_id) AS amount
FROM category
	INNER JOIN film_category USING(category_id)
GROUP BY category.name
ORDER BY amount DESC;

-- The 10 actors whose movies rented the most

SELECT first_name,
	last_name,
	SUM(payment.amount) AS amount
FROM
	payment
	INNER JOIN rental USING(rental_id)
	INNER JOIN inventory USING(inventory_id)
	INNER JOIN film_actor USING(film_id)
	INNER JOIN actor USING(actor_id)
GROUP BY first_name, last_name
ORDER BY amount DESC
LIMIT 10;

-- The category of movies on which the most money was spent

SELECT category.name AS name,
	SUM(payment.amount) AS amount
FROM payment 
	INNER JOIN rental USING(rental_id)
	INNER JOIN inventory USING(inventory_id)
	INNER JOIN film_category USING(film_id)
	INNER JOIN category USING(category_id)
GROUP BY name
ORDER BY amount DESC
LIMIT 1;

--The names of movies that are not in the inventory

SELECT title
FROM film
	LEFT JOIN inventory USING(film_id)
WHERE inventory_id IS NULL;

--The top 3 actors who have appeared the most in movies in the “Children” category
	
WITH amount_of_films (first_name, last_name, amount, number)
AS (SELECT first_name,
	last_name,
	COUNT(film_id) AS amount,
	DENSE_RANK() OVER(ORDER BY COUNT(film_id) DESC) AS number
FROM category
	INNER JOIN film_category USING(category_id)
	INNER JOIN film_actor USING(film_id)
	INNER JOIN actor USING(actor_id)
WHERE category.name = 'Children'
GROUP BY first_name, last_name
)
SELECT first_name, last_name, amount
FROM amount_of_films
WHERE number <= 3

-- Cities with the number of active and inactive customers 

SELECT city,
	SUM(active) AS active_true,
	COUNT(active) - SUM(active) AS active_false
FROM customer
INNER JOIN address USING(address_id)
INNER JOIN city USING(city_id)
GROUP BY city
ORDER BY active_false DESC

--The category of movies that have the highest number of total rental hours in the city and that start with the letter “a”

SELECT city,
	c.name AS name,
	SUM(return_date - rental_date) AS rental_time
FROM category c
	INNER JOIN film_category USING(category_id)
	INNER JOIN inventory USING(film_id)
	INNER JOIN rental USING(inventory_id)
	INNER JOIN customer USING(customer_id)
	INNER JOIN address USING(address_id)
	INNER JOIN city USING(city_id)
WHERE city LIKE 'a%' OR city LIKE '%-%'
GROUP BY city, name
ORDER BY rental_time DESC
	