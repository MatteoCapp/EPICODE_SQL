/* esplora le tabelle dei prodotti**/

SELECT *
FROM
dimproduct;

/* interroga la tabella dei prodotti (dimproduct) ed esponi i campi...... il result set deve essere parlante per cui assegna un alias se lo ritieni opportuno**/

SELECT
ProductKey AS chiaveprimaria,
ProductAlternateKey AS PINO,
WeightUnitMeasureCode,
SizeUnitMeasureCode,
EnglishProductName
FROM
dimproduct;


/*questo è select con alias modifica solo per l'output, poi torna normale***/

SELECT
ProductKey AS chiaveprimaria,
ProductAlternateKey AS PINO,
WeightUnitMeasureCode,
SizeUnitMeasureCode,
EnglishProductName,
FinishedGoodsFlag
FROM
dimproduct
WHERE
FinishedGoodsFlag=1;

/** questo è per indicargli da dove lo vuoi prendere, il where è indicativo di quali sono i parametri che magari vuoi includere o escludere***/

SELECT 
    ProductKey,
    ModelName,
    EnglishProductName,
    StandardCost,
    ListPrice
FROM
    dimproduct
WHERE
    ProductAlternateKey LIKE 'FR%'
        OR ProductAlternateKey LIKE 'BK%';
 
 /** questo come filtro usiamo la ricerca di una parola che contenga qualsiasi lettera dopo le due impostate (FR) oppure una dopo le altre 2 impostate (BK),
 in poche parole devi sempre selezionare dopo l'"or" o altro da dove prendi i dati***/
 
 /**Arricchisci il risultato della query scritta nel passaggio precedente del Markup applicato dall’azienda (ListPrice - StandardCost)***/
 SELECT 
    ProductKey,
    ModelName,
    EnglishProductName,
    StandardCost,
    ListPrice,
    ListPrice - StandardCost
FROM
    dimproduct
WHERE
    ProductAlternateKey LIKE 'FR%' OR ProductAlternateKey LIKE 'BK%';
    
/**** Scrivi un’altra query al fine di esporre l’elenco dei prodotti finiti il cui prezzo di listino è compreso tra 1000 e 2000.***/
    SELECT *
    FROM
    dimproduct
    WHERE
    ListPrice >= 1000 AND ListPrice <=2000
    
/**Esplora la tabella degli impiegati aziendali (DimEmployee)***/

SELECT 
    *
FROM
    dimemployee;
    
/**Esponi, interrogando la tabella degli impiegati aziendali, l’elenco dei soli agenti. Gli agenti sono i dipendenti per i quali il campo SalespersonFlag è uguale a 1.***/
SELECT 
    *
FROM
    dimemployee
WHERE
    SalespersonFlag = 1;

/**Interroga la tabella delle vendite (FactResellerSales).
Esponi in output l’elenco delle transazioni registrate a partire dal 1 gennaio 2020 dei soli codici prodotto: 597, 598, 477, 214. Calcola per ciascuna transazione il profitto (SalesAmount - TotalProductCost).***/

SELECT
*, SalesAmount - TotalProductCost
FROM
factresellersales
WHERE
OrderDate >= "2020/01/01"
AND
ProductKey IN (597,598, 477, 214);
