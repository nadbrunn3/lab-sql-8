-- LAB | SQL Join (Part 2) 

USE sakila;

-- 1. Write a query to display for each store its store ID, city, and country.

SELECT s.store_id, c.city, co.country
FROM sakila.store s
JOIN sakila.address a
ON s.address_id = a.address_id
JOIN sakila.city c
ON a.city_id = c.city_id
JOIN sakila.country co
ON c.country_id = co.country_id;


-- 2. Write a query to display how much business, in dollars, each store brought in.

SELECT s.store_id, SUM(p.amount) as incoming
FROM sakila.store s
JOIN sakila.staff st 
ON s.store_id = st.store_id
JOIN sakila.payment p
ON st.staff_id = p.staff_id
GROUP BY s.store_id;

-- 3. Which film categories are longest?

SELECT ROUND(AVG(f.length)), c.name
FROM sakila.film f
JOIN sakila.film_category fc
ON f.film_id = fc.film_id
JOIN sakila.category c
ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY AVG(f.length) DESC
LIMIT 1;

-- 4. Display the most frequently rented movies in descending order.

SELECT f.title, COUNT(r.rental_id) AS frequency
FROM sakila.rental r
JOIN sakila.inventory i
ON r.inventory_id = i.inventory_id
JOIN sakila.film f
ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY frequency DESC;

-- 5. List the top five genres in gross revenue in descending order.

SELECT  SUM(p.amount) as revenue, ca.name as genre
FROM 
	sakila.category ca
	JOIN sakila.film_category fc
	ON ca.category_id = fc.category_id
	JOIN sakila.film f
	ON fc.film_id = f.film_id 
	JOIN sakila.inventory i
	ON f.film_id = i.film_id
	JOIN sakila.rental r
	ON i.inventory_id = r.inventory_id
	JOIN sakila.payment p
	ON r.rental_id = p.rental_id
GROUP BY ca.name
ORDER BY revenue desc
LIMIT 5;

-- 6. Is "Academy Dinosaur" available for rent from Store 1?

SELECT f.title, i.store_id
FROM sakila.film f
	JOIN sakila.inventory i
    ON f.film_id = i.film_id
WHERE f.title = 'Academy Dinosaur'
GROUP BY i.store_id; 

-- 7. Get all pairs of actors that worked together.

SELECT fa1.actor_id, fa2.actor_id, 
		CONCAT(a1.first_name, ' ', a1.last_name),
        CONCAT(a2.first_name, ' ', a2.last_name)
FROM sakila.film_actor fa1
	JOIN sakila.film_actor fa2
    ON fa1.film_id = fa2.film_id
    JOIN sakila.actor a1
    ON fa1.actor_id = a1.actor_id
    JOIN sakila.actor a2
    ON fa2.actor_id = a2.actor_id
WHERE fa1.actor_id <> fa2.actor_id;

-- 8. Get all pairs of customers that have rented the same film more than 3 times.

SELECT  r1.customer_id as c1,
		r2.customer_id as c2,
        COUNT(r1.inventory_id) as i1,
        COUNT(r2.inventory_id) as i2        
FROM  
		sakila.rental r1
		JOIN 
        sakila.rental r2
        ON 
        r1.inventory_id = r2.inventory_id
GROUP BY 
		r1.customer_id , r2.customer_id
HAVING 
		(r1.customer_id <> r2.customer_id) 
        AND (COUNT(r1.inventory_id) > 2);
      
-- 9. For each film, list actor that has acted in more films.


SELECT  f.title,
		CONCAT(a.first_name, ' ', a.last_name) AS actor,
		COUNT(fa.film_id) OVER (
		PARTITION BY fa.actor_id
		) AS number_of_movies
FROM
				sakila.actor a 
        JOIN 
				sakila.film_actor fa
        ON 		a.actor_id = fa.actor_id
        JOIN 	sakila.film f
        ON 		fa.film_id = f.film_id

ORDER BY number_of_movies DESC
;
		

		


        

			