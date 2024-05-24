/* Esercizio 1
Identificate tutti i clienti che non hanno effettuato nessun noleggio a gennaio 2006.*/

SELECT 
	CONCAT(customer.first_name, ' ',customer.last_name) AS NOME_CLIENTE
FROM 
	customer
	 LEFT JOIN
	rental ON customer.customer_id = rental.customer_id
WHERE 
	NOT EXISTS
    (SELECT 1
        FROM rental
        WHERE rental.customer_id = customer.customer_id
        AND rental.rental_date BETWEEN '2006-01-01' AND '2006-01-31')
GROUP BY
CONCAT(customer.first_name, ' ',customer.last_name);

SELECT 
	CONCAT(customer.first_name, ' ',customer.last_name) AS NOME_CLIENTE
FROM 
	customer
	 LEFT JOIN
	rental ON customer.customer_id = rental.customer_id
WHERE
	customer.customer_id NOT IN
    (SELECT DISTINCT
		customer.customer_id
        FROM
        customer
        LEFT JOIN
        rental ON customer.customer_id = rental.customer_id
WHERE
	YEAR(rental.rental_date) = 2006
	AND MONTH (rental.rental_date) = 1)
GROUP BY
CONCAT(customer.first_name, ' ',customer.last_name);

/*Esercizio 2
Elencate tutti i film che sono stati noleggiati più di 10 volte nell’ultimo quarto del 2005*/
SELECT
    film.title,
    COUNT(rental.rental_id) AS num_rentals
FROM
    rental
    JOIN 
    inventory ON rental.inventory_id = inventory.inventory_id
    JOIN 
    film ON inventory.film_id = film.film_id
WHERE
    rental.rental_date BETWEEN '2005-10-01' AND '2005-12-31'
GROUP BY
    film.title
HAVING
    COUNT(rental.rental_id) > 10;

SELECT
    film.title,
    COUNT(rental.rental_id) AS num_rentals
FROM
    rental
    JOIN 
    inventory ON rental.inventory_id = inventory.inventory_id
    JOIN 
    film ON inventory.film_id = film.film_id
WHERE
	rental.inventory_id IN
    (SELECT DISTINCT
		rental.inventory_id
	FROM
		rental
	WHERE
		YEAR(rental.rental_date) = 2005
			AND MONTH(rental.rental_date) BETWEEN 9 AND 12)
GROUP BY
	film.title
HAVING
	COUNT(rental.rental_id)> 10
ORDER BY COUNT(rental.rental_id) DESC;

/*Esercizio 3
Trovate il numero totale di noleggi effettuati il giorno 1/1/2006.*/
SELECT
	COUNT(rental_id)
FROM
	rental
WHERE
	rental_date = 2006-01-01;
    
/*Esercizio 4
Calcolate la somma degli incassi generati nei weekend (sabato e domenica).*/
SELECT
	SUM(amount) AS totale_incassato
FROM
	payment
WHERE
	DAYOFWEEK(payment_date) IN (1,7);
    
/*Esercizio 5
Individuate il cliente che ha speso di più in noleggi.*/

SELECT
	CONCAT(customer.first_name, ' ', customer.last_name) AS NOME_COGNOME,
	SUM(payment.amount) AS MASSIMO_PAGATO
FROM
	payment
    LEFT JOIN
    customer ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY 2 DESC
LIMIT 1;

SELECT
	customer.customer_id,
    customer.first_name,
    customer.last_name,
	SUM(payment.amount) somma_noleggi
FROM
payment
LEFT JOIN
customer ON payment.customer_id = customer.customer_id
GROUP BY customer.customer_id
ORDER BY 4 DESC
LIMIT 1;

/*Esercizio 6
Elencate i 5 film con la maggior durata media di noleggio*/
SELECT
	film.title AS titolo_film
FROM
	film
    LEFT JOIN
    inventory ON film.film_id = inventory.film_id
    LEFT JOIN
    rental ON rental.inventory_id = inventory.inventory_id
GROUP BY film.title
ORDER BY 1 DESC
LIMIT 5;


SELECT
	f.title titolo_film,
    AVG(DATEDIFF(r.return_date,r.rental_date)) durata_noleggio_media
FROM
rental r
LEFT JOIN
inventory i ON r.inventory_id = i.inventory_id
LEFT JOIN
film f ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY 2 DESC
LIMIT 5;
/*Esercizio 7 
Calcolate il tempo medio tra due noleggi consecutivi da parte di un cliente.*/

SELECT 
    customer.first_name,
    customer.last_name,
    AVG(DATEDIFF(next_rental.rental_date, rental.rental_date)) AS Tempo_Medio_Due_Noleggi
FROM 
    sakila.customer
JOIN 
    sakila.rental ON customer.customer_id = rental.customer_id
LEFT JOIN 
    sakila.rental AS next_rental ON rental.customer_id = next_rental.customer_id 
                                    AND next_rental.rental_date = (
                                        SELECT MIN(nr.rental_date)
                                        FROM sakila.rental nr
                                        WHERE nr.customer_id = rental.customer_id 
                                          AND nr.rental_date > rental.rental_date
                                    )
GROUP BY 
    customer.customer_id, customer.first_name, customer.last_name
ORDER BY 
    Tempo_Medio_Due_Noleggi DESC;

/*Esercizio 8 
Individuate il numero di noleggi per ogni mese del 2005.*/

SELECT
	MONTHNAME(rental.rental_date) AS mese,
	COUNT(rental.rental_id) AS numero_noleggi
FROM
	rental
WHERE
	YEAR (rental.rental_date) = 2005
GROUP BY MONTHNAME(rental.rental_date);

/*Esercizio 9 
Trovate i film che sono stati noleggiati almeno due volte lo stesso giorno.*/

SELECT
	film.title AS film,
    COUNT(DISTINCT DATE(rental.rental_date)) AS numero_noleggi_distinti
FROM
	rental
		LEFT JOIN
	inventory ON rental.inventory_id = inventory.inventory_id
		LEFT JOIN
	film ON inventory.film_id = film.film_id
GROUP BY film.title
HAVING COUNT(DISTINCT DATE(rental.rental_date)) >= 2
ORDER BY 2;

/*Esercizio 10 
Calcolate il tempo medio di noleggio.*/
SELECT
	AVG(DATEDIFF(return_date,rental_date)) AS durata_noleggio_media
FROM
	rental;