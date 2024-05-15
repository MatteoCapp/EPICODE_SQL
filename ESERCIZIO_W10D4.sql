/***
A QUANTO PARE LE JOIN SERVONO PER PRENDERE DATI DA PIù TABELLE CONTEMPORANEAMENTE
LA BASE è
SELECT campi sia di tabella 1 che da 2
FROM tabella1
INNER JOIN tabella2 ON condizione
***/

/****
Esponi l’anagrafica dei prodotti indicando per ciascun prodotto anche la sua sottocategoria (DimProduct, DimProductSubcategory).

le due righe sotto sono copiate e incollate da come le hanno fatte a lezione, io non ho minimamente capito il perchè delle scelte
****/

SELECT *
FROM dimproductsubcategory
JOIN dimproduct ON dimproductsubcategory.ProductCategoryKey = dimproduct.ProductSubcategoryKey;

/***
Esponi l’anagrafica dei prodotti indicando per ciascun prodotto la sua sottocategoria e la sua categoria (DimProduct, DimProductSubcategory, DimProductCategory)
che non funziona
*****/

SELECT A.*, B.EnglishProductSubcategoryName, C.EnglishProductCategoryName
FROM dimproduct AS A
JOIN dimproductsubcategory AS B ON A.ProductSubcategorykey = B.ProductySubcategoryKey
JOIN dimproductcategory AS C ON B.Productcategorykey = C.ProductycategoryKey;


/*****
Esponi l’elenco dei soli prodotti venduti (DimProduct, FactResellerSales).
****/
SELECT A.*, B.*
FROM DimProduct A
JOIN FactResellerSales B ON A.Productkey = B.Productkey
WHERE SalesAmount > 0;

/***
Esponi l’elenco dei prodotti non venduti (considera i soli prodotti finiti cioè quelli per i quali il campo FinishedGoodsFlag è uguale a 1).
***/

SELECT DimProduct.*
FROM DimProduct WHERE
DimProduct.Productkey NOT IN
(SELECT FactResellerSales.Productkey
FROM
	DimProduct
	JOIN
	FactResellerSales  ON DimProduct.Productkey = FactResellerSales.Productkey)
AND FinishedGoodsFlag = 1;

/**Esponi l’elenco delle transazioni di vendita (FactResellerSales) indicando anche il nome del prodotto venduto (DimProduct)
metto il salesordernumer come distinct in modo da prendermi la singola transazione**/

SELECT DISTINCT
	dimproduct.EnglishProductName,
	factresellersales.SalesOrderNumber
FROM 
	factresellersales
    JOIN
    dimproduct ON factresellersales.ProductKey = dimproduct.ProductKey;
    
/**Esponi l’elenco delle transazioni di vendita indicando la categoria di appartenenza di ciascun prodotto venduto.**/

SELECT DISTINCT
	dimproductsubcategory.EnglishProductSubcategoryName AS nome_articolo,
	factresellersales.SalesOrderNumber AS numero_transazione
FROM 
	factresellersales
    JOIN
    dimproduct ON factresellersales.ProductKey = dimproduct.ProductKey
    JOIN
    dimproductsubcategory ON dimproduct.ProductSubCategoryKey = dimproductsubcategory.ProductSubCategoryKey;
    
/**Esplora la tabella DimReseller.**/

SELECT
	*
FROM
	DimReseller;
    
/**Esponi in output l’elenco dei reseller indicando, per ciascun reseller, anche la sua area geografica.**/

SELECT DISTINCT
	dimreseller.ResellerName AS Nome_Reseller,
    dimsalesterritory.SalesTerritoryRegion AS Region,
    dimgeography.City AS Citta
FROM
	dimreseller
    JOIN
    dimgeography ON dimreseller.GeographyKey = dimgeography.GeographyKey
    JOIN
    dimsalesterritory ON dimgeography.SalesTerritoryKey = dimsalesterritory.SalesTerritoryKey;
    
/**Esponi l’elenco delle transazioni di vendita. Il result set deve esporre i campi: SalesOrderNumber, SalesOrderLineNumber, OrderDate, UnitPrice, Quantity, TotalProductCost.
Il result set deve anche indicare il nome del prodotto, il nome della categoria del prodotto, il nome del reseller e l’area geografica.**/

SELECT
	factresellersales.SalesOrderNumber,
    factresellersales.SalesOrderLineNumber,
    factresellersales.OrderDate,
    factresellersales.UnitPrice,
    factresellersales.OrderQuantity,
    factresellersales.TotalProductCost,
    dimproduct.EnglishProductName AS nome_prodotto,
    dimproductsubcategory.EnglishProductSubcategoryName AS nome_categoria_prodotto,
    dimreseller.ResellerName AS nome_reseller,
    dimsalesterritory.SalesTerritoryRegion AS area_geografica
FROM
	dimproductsubcategory
    JOIN
	dimproduct ON dimproductsubcategory.ProductSubcategoryKey = dimproduct.ProductSubcategoryKey
    JOIN
    factresellersales ON dimproduct.ProductKey = factresellersales.ProductKey
    JOIN
    dimsalesterritory ON factresellersales.SalesTerritoryKey = dimsalesterritory.SalesTerritoryKey
    JOIN
    dimreseller ON factresellersales.ResellerKey = dimreseller.ResellerKey;
    
SELECT
	factresellersales.SalesOrderNumber,
    factresellersales.SalesOrderLineNumber,
    factresellersales.OrderDate,
    factresellersales.UnitPrice,
    factresellersales.OrderQuantity,
    factresellersales.TotalProductCost,
    dimproduct.EnglishProductName AS nome_prodotto,
    dimproductsubcategory.EnglishProductSubcategoryName AS nome_categoria_prodotto,
    dimreseller.ResellerName AS nome_reseller,
    dimsalesterritory.SalesTerritoryRegion AS area_geografica
FROM
	dimproductsubcategory
    JOIN
	dimproduct ON dimproductsubcategory.ProductSubcategoryKey = dimproduct.ProductSubcategoryKey
    JOIN
    factresellersales ON dimproduct.ProductKey = factresellersales.ProductKey
    JOIN
    dimsalesterritory ON factresellersales.SalesTerritoryKey = dimsalesterritory.SalesTerritoryKey
    JOIN
    dimgeography ON dimgeography.SalesTerritoryKey = dimsalesterritory.SalesTerritoryKey
    JOIN
    dimreseller ON dimgeography.GeographyKey = dimreseller.GeographyKey;