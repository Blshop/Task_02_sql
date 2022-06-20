
--	1. Number of films in each category in descending order.

SELECT count(f.title) AS amount, c."name" AS category
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id 
JOIN category c ON c.category_id =fc.category_id 
GROUP BY c."name" 
ORDER BY amount DESC;

--	2. Top 10 actors whose films are most rented in descending order.

SELECT a.first_name||' '||a.last_name AS "actor name", count(*) AS amount 
FROM actor a 
JOIN film_actor fa ON a.actor_id = fa.actor_id 
JOIN inventory i ON i.film_id  = fa.film_id 
JOIN rental r ON r.inventory_id = i.inventory_id 
GROUP BY "actor name"
ORDER BY amount DESC 
LIMIT 10;

--	3. Film category with most money spent.

SELECT c."name" , sum(p.amount) AS amount
FROM category c 
JOIN film_category fc ON fc.category_id = c.category_id 
JOIN inventory i ON i.film_id = fc.film_id 
JOIN rental r ON r.inventory_id = i.inventory_id 
JOIN payment p  ON p.rental_id  = r.rental_id 
GROUP BY c."name" 
ORDER BY amount DESC 
LIMIT 1;

--	4. Films not in inventory, without using IN.

SELECT  f.title
FROM film f 
LEFT JOIN inventory i ON i.film_id = f.film_id
WHERE inventory_id IS NULL;

-- 5. Top 3 actors in category "children" with ties. 

SELECT a.first_name||' '||a.last_name AS "actor name", count(*) AS amount
FROM actor a 
JOIN film_actor fa ON fa.actor_id = a.actor_id 
JOIN film_category fc ON fa.film_id = fc.film_id 
JOIN category c ON c.category_id = fc.category_id
WHERE c."name" = 'Children'
GROUP BY "actor name" 
ORDER BY amount DESC 
FETCH FIRST 3 ROWS WITH TIES;

--	6. Cities with active and inactive clients. Sort by inactive clients in descending order.

SELECT 
	c2.city,
	sum(c.active) AS active,
	count(c.active)-sum(c.active) AS inactive
FROM customer c
JOIN address a ON a.address_id = c.address_id 
JOIN city c2 ON c2.city_id = a.city_id
GROUP BY city
ORDER BY inactive DESC;

--	7. Category with most hours rent in cities begin with 'a'. the same for cities which have '-' in their name. 


SELECT DISTINCT ON (cl.city) cl.city, fl.category, (r.return_date-r.rental_date) AS rent_time
FROM customer_list cl 
JOIN rental r ON r.customer_id = cl.id
JOIN inventory i ON i.inventory_id = r.inventory_id 
JOIN film_list fl ON fl.fid = i.film_id
WHERE (city like 'A%' OR city like '%-%') AND (r.return_date-r.rental_date) IS NOT NULL
ORDER BY city, rent_time DESC;