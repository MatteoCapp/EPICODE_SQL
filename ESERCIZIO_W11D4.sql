/*Esercizio 1 Elencate il numero di tracce per ogni genere in ordine discendente, escludendo quei generi che hanno meno di 10 tracce.*/
SELECT
	COUNT(DISTINCT track.Name),
    genre.Name
FROM
	track
	JOIN
	genre
    ON genre.GenreId = track.GenreId
GROUP BY
	genre.Name
HAVING
	COUNT(track.Name)>=10
ORDER BY
	COUNT(track.Name) DESC;
    
/*Esercizio 2 Trovate le tre canzoni più costose.*/
SELECT
	*
FROM
	track
ORDER BY
	UnitPrice DESC
LIMIT 3;

/*Esercizio 3 Elencate gli artisti che hanno canzoni più lunghe di 6 minuti.*/
SELECT DISTINCT
    artist.Name
FROM
	track
    LEFT JOIN
    album ON track.AlbumId = album.AlbumId
    LEFT JOIN
    artist ON artist.ArtistId = album.ArtistId
WHERE
	Milliseconds>360000;
/*Esercizio 4 Individuate la durata media delle tracce per ogni genere.*/
SELECT
	genre.Name,
    CAST(AVG(Milliseconds)/60000 AS DECIMAL (6,3)) AS media
FROM
	track
    LEFT JOIN
    genre ON track.GenreId = genre.GenreId
GROUP BY
	genre.Name
ORDER BY
	AVG(Milliseconds) DESC;
/*Esercizio 5 Elencate tutte le canzoni con la parola “Love” nel titolo, ordinandole alfabeticamente prima per genere e poi per nome.*/
SELECT
	genre.Name,
    track.Name
FROM
	track
    JOIN
    genre ON genre.GenreId = track.GenreId
WHERE
	track.Name LIKE '%LOVE%'
ORDER BY
	genre.Name,
    track.Name;
/*Esercizio 6 Tovate il costo medio per ogni tipologia di media*/
SELECT *
FROM
	track
    LEFT JOIN
    mediatype ON mediatype.MediaTypeId = track.MediaTypeId
GROUP BY
	mediatype.Name
ORDER BY
	AVG;
/*Esercizio 7 Individuate il genere con più tracce.*/
SELECT G.NAME AS GENRE_NAME
FROM TRACK T
LEFT JOIN GENRE G ON T.GENREID=G.GENREID
GROUP BY G.NAME
HAVING COUNT(DISTINCT T.NAME)=(SELECT MAX(NUM_TRACK)
                    FROM(SELECT G.NAME AS GENRE_NAME, COUNT(DISTINCT T.NAME) AS NUM_TRACK
                            FROM TRACK T
                            LEFT JOIN GENRE G ON T.GENREID=G.GENREID
                            GROUP BY G.NAME) A );
/*Esercizio 8 Esercizio Query Avanzate Trovate gli artisti che hanno lo stesso numero di album dei Rolling Stones.*/
SELECT AR.NAME, COUNT(AL.TITLE) AS NUM_ALBUM
FROM ALBUM AL 
LEFT JOIN ARTIST  AR ON AL.ARTISTID=AR.ARTISTID
GROUP BY AR.NAME
HAVING NUM_ALBUM=(  SELECT COUNT(AL.TITLE) AS NUM_ALBUM
                    FROM ALBUM AL 
                    LEFT JOIN ARTIST  AR  ON AL.ARTISTID=AR.ARTISTID
                    WHERE AR.NAME = 'The Rolling Stones');
/*Esercizio 9 Trovate l’artista con l’album più costoso.*/