/*Cominciate facendo un’analisi esplorativa del database, ad esempio: Fate un elenco di tutte le tabelle.
Visualizzate le prime 10 righe della tabella Album. Trovate il numero totale di canzoni della tabella Tracks. Trovate i diversi generi presenti nella tabella Genre.*/

SHOW  tables;

SELECT *
FROM album
LIMIT 10;

SELECT COUNT(TrackId)
FROM track;

SELECT COUNT(Name)
FROM track;

SELECT DISTINCT name
FROM genre;

/*Recuperate il nome di tutte le tracce e del genere associato.*/

SELECT
	track.Name,
    genre.Name
FROM
	genre
    JOIN
    track ON track.GenreId = genre.GenreId;
    
SELECT
	track.Name,
    genre.Name
FROM
	track
    RIGHT JOIN
    genre ON genre.GenreId = track.GenreId;

/*Recuperate il nome di tutti gli artisti che hanno almeno un album nel database. Esistono artisti senza album nel database?*/

SELECT DISTINCT
	artist.Name
FROM
	artist
    JOIN
    album ON artist.ArtistId = album.ArtistId;
    
SELECT DISTINCT
	COUNT(Name)
FROM artist;

SELECT DISTINCT
	COUNT(AlbumId)
FROM album;

/*Esistono artisti senza album nel database?*/

SELECT DISTINCT
	artist.Name
FROM
	artist
    LEFT JOIN
    album ON artist.ArtistId = album.ArtistId
WHERE album.AlbumId IS NULL;

/*Recuperate il nome di tutte le tracce, del genere associato e della tipologia di media.
Esiste un modo per recuperare il nome della tipologia di media?*/

SELECT
	track.Name AS nome_traccia,
    genre.Name AS nome_genere,
    mediatype.Name AS tipo_di_media
FROM
	genre
	JOIN
    track ON genre.GenreId = track.GenreId
	JOIN
    mediatype ON track.MediaTypeId = mediatype.MediaTypeId;

SELECT distinct
	Name
from mediatype;

/**Elencate i nomi di tutti gli artisti e dei loro album.*/

SELECT
	artist.Name AS nome_artista,
    album.Title AS nome_album
FROM
	album
	JOIN
    artist ON album.ArtistId = artist.ArtistId;
    
SELECT
	artist.Name AS nome_artista,
    album.Title AS nome_album
FROM
	artist
	LEFT JOIN
    album ON album.ArtistId = artist.ArtistId;
    
/*Recuperate tutte le tracce che abbiano come genere “Pop” o “Rock”.*/

SELECT
	track.Name AS nome_traccia,
	genre.Name AS nome_genere
FROM
	track
    JOIN
    genre ON track.GenreId = genre.GenreId
WHERE
	genre.Name = 'Pop'
    OR
    genre.Name = 'Rock';

/*Elencate tutti gli artisti e/o gli album che inizino con la lettera “A”.*/
SELECT
	album.Title AS nome_album,
    artist.Name AS nome_artista
FROM
	artist
	LEFT JOIN
    album ON album.ArtistId = artist.ArtistId
WHERE
	artist.Name LIKE 'A%'
    OR
    album.Title LIKE 'A%';
    
/*Elencate tutte le tracce che hanno come genere “Jazz” o che durano meno di 3 minuti.*/
SELECT
	track.Name AS nome_traccia,
    track.Milliseconds AS durata
FROM
	track
    JOIN
    genre ON track.GenreId = genre.GenreId
WHERE
	genre.Name = 'Jazz'
    OR
    track.Milliseconds < 180000;
/*Recuperate tutte le tracce più lunghe della durata media.*/
SELECT
	Name AS nome_traccia,
    Milliseconds AS durata
FROM
	track
WHERE
	Milliseconds >
    (SELECT
		AVG(Milliseconds)
	FROM track);
    
-- PROVA DEL NOVE
SELECT
	AVG(Milliseconds)
FROM track;

/*Individuate i generi che hanno tracce con una durata media maggiore di 4 minuti.*/
SELECT
	Name AS nome_traccia,
    Milliseconds AS durata
FROM
	track
WHERE
	Milliseconds > 240000;

/*Trovate la traccia più lunga in ogni album.*/
SELECT
	track.Name AS nome,
    track.Milliseconds AS durata,
    album.Title AS nome_album
FROM
	track
    RIGHT JOIN
    album ON album.AlbumId = track.AlbumId
WHERE
	track.Milliseconds =
    (SELECT
		MAX(track.Milliseconds)
	 FROM
		track)
GROUP BY album.Title;
/**TRACCIA PAOLO*/
SELECT
	track.Name AS nome,
    track.Milliseconds AS durata,
    album.Title AS nome_album
FROM
	track
    JOIN
    album ON album.AlbumId = track.AlbumId
WHERE
	track.Milliseconds IN
    ((SELECT 
			TRACCIA_LUNGA
    FROM
    (SELECT 
			MAX(track.Milliseconds) AS TRACCIA_LUNGA,
            track.AlbumId
	FROM
		track
	GROUP BY
		track.AlbumId) AS SUB));
        
SELECT 
			TRACCIA_LUNGA
    FROM
    (SELECT 
			MAX(track.Milliseconds) AS TRACCIA_LUNGA,
            track.AlbumId
	FROM
		track
	GROUP BY
		track.AlbumId) AS SUB;

SELECT 
			MAX(track.Milliseconds) AS TRACCIA_LUNGA,
            track.AlbumId
	FROM
		track
	GROUP BY
		track.AlbumId;
/*Individuate la durata media delle tracce per ogni album.*/
SELECT
    AVG(track.Milliseconds) AS durata,
    album.Title AS nome_album
FROM
	album
    LEFT JOIN
    track ON track.AlbumId = album.AlbumId
WHERE
	track.Milliseconds IN
    ((SELECT
		AVG(track.Milliseconds)
	FROM
	(SELECT 
    AVG(track.Milliseconds),
    track.AlbumId
	FROM
    track
	GROUP BY track.AlbumId)AS SUB));
/*Individuate gli album che hanno più di 20 tracce e mostrate il nome dell’album e il numero di tracce in esso contenute.*/
SELECT
	album.Title AS NOME_ALBUM,
    COUNT(track.AlbumId) AS TOTALI_TRACCE
FROM
	album
	JOIN
    track ON track.AlbumId = album.AlbumId
GROUP BY
	album.AlbumId
HAVING
	COUNT(track.AlbumId) >=20;