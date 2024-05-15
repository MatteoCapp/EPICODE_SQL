/*Scrivi una query per verificare che il campo ProductKey nella tabella DimProduct sia una chiave primaria. Quali considerazioni/ragionamenti è necessario che tu faccia?*/

SELECT ProductKey, COUNT(*) AS ANTONELLO
FROM DimProduct
GROUP BY ProductKey
HAVING ANTONELLO >1;

/* Scrivi una query per verificare che la combinazione dei campi SalesOrderNumber e SalesOrderLineNumber sia una PK*/

SELECT SalesOrderNumber, SalesOrderLineNumber, COUNT(*) AS somma
FROM factresellersales
GROUP BY SalesOrderNumber, SalesOrderLineNumber
HAVING somma >1;

/*Conta il numero transazioni (SalesOrderLineNumber) realizzate ogni giorno a partire dal 1 Gennaio 2020.*/

SELECT OrderDate, COUNT(SalesOrderLineNumber) AS venduti
FROM factresellersales
GROUP BY OrderDate
HAVING OrderDate >= '2020-01-01';

SELECT OrderDate, COUNT(SalesOrderLineNumber) AS venduti
FROM factresellersales
WHERE OrderDate >= '2020-01-01'
GROUP BY OrderDate;

/*Calcola il fatturato totale (FactResellerSales.SalesAmount), la quantità totale venduta (FactResellerSales.OrderQuantity) e il prezzo medio di vendita (FactResellerSales.UnitPrice)
per prodotto (DimProduct) a partire dal 1 Gennaio 2020. Il result set deve esporre pertanto il nome del prodotto,
il fatturato totale, la quantità totale venduta e il prezzo medio di vendita. I campi in output devono essere parlanti!*/

SELECT
    prod.EnglishProductName AS nome_prodotto,
    SUM(reselsales.SalesAmount) AS fatturato_totale,
    SUM(reselsales.OrderQuantity) AS quantita_totale_venduta,
    AVG(reselsales.UnitPrice) AS prezzo_medio_vendita
FROM
    factresellersales AS reselsales
        JOIN
    dimproduct AS prod ON reselsales.productkey = prod.productkey
WHERE
    reselsales.OrderDate >= '2020-01-01'
GROUP BY
    prod.EnglishProductName
ORDER BY
    prod.EnglishProductName;
    
/*Calcola il fatturato totale (FactResellerSales.SalesAmount) e la quantità totale venduta (FactResellerSales.OrderQuantity) 
per Categoria prodotto (DimProductCategory). Il result set deve esporre pertanto il nome della categoria prodotto, 
il fatturato totale e la quantità totale venduta. I campi in output devono essere parlanti!*/

SELECT
	dimproductcategory.EnglishProductCategoryName,
	SUM(FactResellerSales.SalesAmount) AS Fatturato_totale,
    SUM(FactResellerSales.OrderQuantity) AS Quantita_Totale_venduta
FROM
	factresellersales
	JOIN
    dimproduct ON factresellersales.productkey = dimproduct.productkey
    JOIN
    dimproductsubcategory ON dimproductsubcategory.ProductSubcategoryKey = dimproduct.ProductSubcategoryKey
    JOIN
    dimproductcategory ON dimproductcategory.ProductCategoryKey = dimproductsubcategory.ProductcategoryKey
GROUP BY
	dimproductcategory.EnglishProductCategoryName;

/**Calcola il fatturato totale per area città (DimGeography.City) realizzato a partire dal 1 Gennaio 2020. Il result set deve esporre l’elenco delle città con fatturato realizzato superiore a 60K.*/

SELECT
	dimgeography.City,
    SUM(factresellersales.SalesAmount)
FROM
	dimgeography
	LEFT JOIN
	dimreseller ON dimreseller.GeographyKey = dimgeography.GeographyKey
	LEFT JOIN
	factresellersales ON factresellersales.ResellerKey = dimreseller.ResellerKey
WHERE
OrderDate >= '2020-01-01'
GROUP BY
	dimgeography.City
HAVING
	SUM(factresellersales.SalesAmount) >= 60000;