/*Esercizio 1 
Effettuate un’esplorazione preliminare del database. Di cosa si tratta? Quante e quali tabelle contiene? Fate in modo di avere un’idea abbastanza chiara riguardo a con cosa state lavorando.*/

SHOW TABLES from sakila;
SELECT * FROM sakila.actor;
SELECT * FROM sakila.address;
SELECT * FROM sakila.category;
SELECT * FROM sakila.city;
SELECT * FROM sakila.country;
SELECT * FROM sakila.customer;
SELECT * FROM sakila.film;
SELECT * FROM sakila.film_actor;
SELECT * FROM sakila.film_category;
SELECT * FROM sakila.film_text;
SELECT * FROM sakila.inventory;
SELECT * FROM sakila.language;
SELECT * FROM sakila.payment;
SELECT * FROM sakila.rental;
SELECT * FROM sakila.staff;
SELECT * FROM sakila.store;

/*Esercizio 2
Scoprite quanti clienti si sono registrati nel 2006.*/

SELECT first_name, last_name
FROM customer
WHERE YEAR(create_date) = 2006;

SELECT 
    COUNT(customer.customer_id) AS NumeroClientiRegistrati
FROM
    customer
WHERE
    YEAR(customer.create_date) = 2006;
-- RISULTATO UGUALE MA A ME VENGONO I DETTAGLI, A LEI IL TOTALE.
/*Esercizio 3
Trovate il numero totale di noleggi effettuati il giorno 1/1/2006. NON Dà RISULTATI PERCHE' QUEL GIORNO NON C'è NIENTE*/

SELECT COUNT(rental_id)
FROM rental
WHERE DATE(rental_date) = 2006-01-01;

/*Esercizio 4
Elencate tutti i film noleggiati nell’ultima settimana e tutte le informazioni legate al cliente che li ha noleggiati.*/

SELECT
	customer.first_name AS NOME,
    customer.last_name AS COGNOME,
    customer.email,
    film.title AS TITOLO_FILM
FROM
	customer
    LEFT JOIN
	rental ON customer.customer_id = rental.customer_id
	LEFT JOIN
	inventory ON inventory.inventory_id = rental.inventory_id
	LEFT JOIN
	film ON film.film_id = inventory.film_id
WHERE
	rental.rental_date >= SUBDATE(
		(SELECT
			MAX(rental_date)
		FROM
			rental), INTERVAL 7 DAY);
	
/*Esercizio 5: Calcolate la durata media del noleggio per ogni categoria di film.*/
SELECT 
    category.name AS Categoria,
    CAST(AVG(DATEDIFF(rental.return_date, rental.rental_date))
        AS DECIMAL (10 , 2 )) AS DurataNoleggio
FROM
    category
        LEFT JOIN
    film_category ON category.category_id = film_category.category_id
        LEFT JOIN
    film ON film_category.film_id = film.film_id
        LEFT JOIN
    inventory ON film.film_id = inventory.film_id
        LEFT JOIN
    rental ON inventory.inventory_id = rental.inventory_id
        LEFT JOIN
    customer ON rental.customer_id = customer.customer_id
GROUP BY Categoria
ORDER BY DurataNoleggio;

/*Esercizio 6: Trovate la durata del noleggio più lungo.*/
SELECT 
    film.title AS Film,
    customer.first_name AS NomeCliente,
    customer.last_name AS CognomeCliente,
    DATEDIFF(rental.return_date, rental.rental_date) AS DurataNoleggio
FROM
    film
        LEFT JOIN
    inventory ON film.film_id = inventory.film_id
        LEFT JOIN
    rental ON inventory.inventory_id = rental.inventory_id
        LEFT JOIN
    customer ON rental.customer_id = customer.customer_id
WHERE
    DATEDIFF(rental.return_date, rental.rental_date) = (SELECT 
            MAX(DATEDIFF(rental.return_date, rental.rental_date))
        FROM
            rental); 